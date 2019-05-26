#lang scribble/doc
@(require "common.rkt")

@defclass/title[frame% object% (top-level-window<%>)]{

@;{A frame is a top-level container window. It has a title bar (which
 displays the frame's label), an optional menu bar, and an optional
 status line.}
  框架是顶级容器窗口。它有一个标题栏(显示框架的标签)、一个可选菜单栏和一个可选状态行。

@defconstructor[([label label-string?]
                 [parent (or/c (is-a?/c frame%) #f) #f]
                 [width (or/c dimension-integer? #f) #f]
                 [height (or/c dimension-integer? #f) #f]
                 [x (or/c position-integer? #f) #f]
                 [y (or/c position-integer? #f) #f]
                 [style (listof (or/c 'no-resize-border 'no-caption 
                                      'no-system-menu 'hide-menu-bar 
                                      'toolbar-button 'float 'metal
                                      'fullscreen-button 'fullscreen-aux))
                        null]
                 [enabled any/c #t]
                 [border spacing-integer? 0]
                 [spacing spacing-integer? 0]
                 [alignment (list/c (or/c 'left 'center 'right)
                                    (or/c 'top 'center 'bottom))
                            '(center top)]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #t]
                 [stretchable-height any/c #t])]{

@;{The @racket[label] string is displayed in the frame's title
bar. If the frame's label is changed (see @method[window<%>
set-label]), the title bar is updated.}
  @racket[label]字符串显示在框架的标题栏中。如果框架的标签已更改（请参见@method[window<%>
set-label]），则标题栏将更新。

@;{The @racket[parent] argument can be @racket[#f] or an existing
frame. On Windows, if @racket[parent] is an existing frame,
the new frame is always on top of its parent.
On Windows and Unix (for many window managers), a
frame is iconized when its parent is iconized.}
@racket[parent]参数可以是@racket[#f]或现有框架。在Windows上，如果@racket[parent]是现有框架，则新框架始终位于其父框架的顶部。在Windows和Unix（对于许多窗口管理器）上，当父级被图标化时，框架会被图标化。

@;{If @racket[parent] is @racket[#f], then the eventspace for the
new frame is the current eventspace, as determined by
@racket[current-eventspace]. Otherwise, @racket[parent]'s
eventspace is the new frame's eventspace.}
  如果@racket[parent]为@racket[#f]，则新框架的事件空间是当前事件空间，由@racket[current-eventspace]确定。否则，@racket[parent]的事件空间是新框架的事件空间。

@;{If the @racket[width] or @racket[height] argument is not
@racket[#f], it specifies an initial size for the frame (in
pixels) assuming that it is larger than the minimum size,
otherwise the minimum size is used.}
  如果@racket[width]或@racket[height]参数不是@racket[#f]，则它指定框架的初始大小（以像素为单位），假定大于最小大小，否则使用最小大小。

@;{If the @racket[x] or @racket[y] argument is not @racket[#f], it
specifies an initial location for the frame. Otherwise, a
location is selected automatically (tiling frames and dialogs as
they are created).}
  如果@racket[x]或@racket[y]参数不是@racket[#f]，则指定框架的初始位置。否则，将自动选择一个位置（创建时平铺框架和对话框）。

@;{The @racket[style] flags adjust the appearance of the frame on
some platforms:}
  @racket[style]标志可调整某些平台上框架的外观：

@itemize[

 @item{@racket['no-resize-border]@;{ --- omits the resizeable border
  around the window (Windows, Unix), ability to resize the window (Mac
  OS), or grow box in the bottom right corner (older Mac OS)}——省略窗口周围可调整大小的边框（Windows、Unix）、调整窗口大小的功能（Mac OS）或右下角的增长框（较旧的Mac OS）}

 @item{@racket['no-caption]@;{ --- omits the title bar for the frame
 (Windows, Mac OS, Unix)}——省略框架的标题栏（Windows、Mac OS、Unix）}
 

 @item{@racket['no-system-menu]@;{ --- omits the system menu
 (Windows)}——省略系统菜单（Windows）}
 

 @item{@racket['toolbar-button]@;{ --- includes a toolbar button on the
 frame's title bar (Mac OS 10.6 and earlier); a click on the toolbar button triggers
 a call to @method[frame% on-toolbar-button-click]}——包括框架标题栏上的工具栏按钮（Mac OS 10.6及更早版本）；单击工具栏按钮可触发对@method[frame% on-toolbar-button-click]调用}
 

 @item{@racket['hide-menu-bar]@;{ --- hides the menu bar and dock when
 the frame is active (Mac OS) or asks the window manager to make
 the frame fullscreen (Unix)}——隐藏菜单栏，并在框架处于活动状态（Mac OS）或要求窗口管理器将框架设为全屏（Unix）时停靠。}
 

 @item{@racket['float]@;{ --- causes the frame to stay in front of all
 other non-floating windows (Windows, Mac OS, Unix); on Mac OS, a floating frame
 shares the focus with an active non-floating frame; when this style
 is combined with @racket['no-caption], then showing the frame does
 not cause the keyboard focus to shift to the window, and on Unix,
 clicking the frame does not move the focus; on Windows, a floating
 frame has no taskbar button}——使框架停留在所有其他非浮动窗口（Windows、Mac OS、Unix）之前；在Mac OS上，浮动框架与活动非浮动框架共享焦点；当此样式与@racket['no-caption]组合时，显示框架不会导致键盘焦点移到窗口，在Unix上，单击框架不会移动焦点；在Windows上，浮动框架没有任务栏按钮}
 

 @item{@racket['metal]@;{ --- ignored (formerly supported for Mac OS)}——忽略（以前支持Mac OS）}
 

 @item{@racket['fullscreen-button]@;{ --- includes a button on the
 frame's title bar to put the frame in fullscreen mode (Mac OS 10.7 and later)}——包括框架标题栏上的按钮，将框架置于全屏模式（Mac OS 10.7及更高版本）}
 

 @item{@racket['fullscreen-aux]@;{ --- allows the frame to accompany
 another that is in fullscreen mode (Mac OS 10.7 and later)}——允许框架伴随另一个全屏模式（Mac OS 10.7及更高版本）}
                                                             

]

@;{Even if the frame is not shown, a few notification events may be
 queued for the frame on creation. Consequently, the new frame's
 resources (e.g., memory) cannot be reclaimed until some events are
 handled, or the frame's eventspace is shut down.}
即使未显示框架，也可能会在创建框架时排队等待一些通知事件。因此，在处理某些事件或关闭框架的事件空间之前，无法回收新框架的资源（例如内存）。

@WindowKWs[@racket[enabled]] @AreaContKWs[] @AreaKWs[]

@history[#:changed "6.0.0.6" @elem{@;{Added @racket['fullscreen-button]
                                   and @racket['fullscreen-aux] options 
                                   for @racket[style].}添加了@racket[style]的@racket['fullscreen-button]和@racket['fullscreen-aux]。}]

}


@defmethod[(create-status-line)
           void?]{

@;{Creates a status line at the bottom of the frame. The width of the
 status line is the whole width of the frame (adjusted automatically
 when resizing), and the height and text size are platform-specific.}
在框架底部创建状态行。状态行的宽度是框架的整个宽度（在调整大小时自动调整），高度和文本大小是平台特定的。
  
@;{See also @method[frame% set-status-text].}
  另请参见@method[frame% set-status-text]。

}

@defmethod[(fullscreen [fullscreen? any/c])
           void?]{

@;{Puts the frame in fullscreen mode or restores the frame to
 non-fullscreen mode. The frame's show state is not affected.}
  将框架置于全屏模式或将框架恢复为非全屏模式。框架的显示状态不受影响。

@;{@Unmonitored[@elem{A frame's mode} @elem{the user} @elem{a
frame has been put in fullscreen mode} @elem{@method[frame% is-fullscreened?]}]}
  @Unmonitored[@elem{框架的模式} @elem{用户} @elem{框架已经被置于全屏模式} @elem{@method[frame% is-fullscreened?]}]

@;{On Mac OS, the @racket[frame%] must be created with the style
 @racket['fullscreen-button] for fullscreen mode to work, and Mac OS
 10.7 or later is required.}
 在Mac OS上，必须使用样式@racket['fullscreen-button]创建@racket[frame%]才能使全屏模式工作，并且需要Mac OS 10.7或更高版本。

@;{@history[#:added "1.9"
         #:changed "1.18" @elem{Changed @method[frame% fullscreen] with @racket[#t]
                                to not imply @method[window<%> show] on Windows and Mac OS.}]}
@history[#:added "1.9"
         #:changed "1.18" @elem{用@racket[#t]更改@method[frame% fullscreen]，以不暗示在Windows和Mac OS上@method[window<%> show]}]
}
                 

@defmethod[(get-menu-bar)
           (or/c (is-a?/c menu-bar%) #f)]{

@;{Returns the frame's menu bar, or @racket[#f] if none has been created
 for the frame.}
  返回框架的菜单栏，或者如果没有为框架创建菜单栏返回@racket[#f]。

}

@defmethod[(has-status-line?)
           boolean?]{

@;{Returns @racket[#t] if the frame's status line has been created,
 @racket[#f] otherwise. See also @method[frame% create-status-line].}
  如果框架的状态行已创建，则返回@racket[#t]，否则返回@racket[#f]。另请参见@method[frame% create-status-line]。

}

@defmethod[(iconize [iconize? any/c])
           void?]{

@;{Iconizes (@as-index{minimizes}) or deiconizes (restores) the
 frame. Deiconizing brings the frame to the front.}
将框架图标化（@as-index{minimizes}）或去图标化（恢复）。去图标化将框架带到前面。

@;{@Unmonitored[@elem{A frame's iconization} @elem{the user} @elem{a
frame has been iconized} @elem{@method[frame% is-iconized?]}]}
 @Unmonitored[@elem{一个框架的图标化} @elem{用户} @elem{一个框架已经图标化} @elem{@method[frame% is-iconized?]}]
 
}

@defmethod[(is-fullscreened?)
           boolean?]{

@;{Returns @racket[#t] if the frame is in fullscreen mode, @racket[#f]
otherwise.}
  如果框架处于全屏模式，则返回@racket[#t]，否则返回@racket[#f]。

@history[#:added "6.0.0.6"]
}

@defmethod[(is-iconized?)
           boolean?]{

@;{Returns @racket[#t] if the frame is iconized (minimized), @racket[#f]
otherwise.}
 如果框架被图标化（最小化），则返回@racket[#t]，否则返回@racket[#f]。 

}

@defmethod[(is-maximized?)
           boolean?]{

@;{On Windows and Mac OS, returns @racket[#t] if the frame is
maximized, @racket[#f] otherwise. On Unix, the result is always
@racket[#f].}
 在Windows和Mac OS上，如果框架最大化，则返回@racket[#t]，否则返回@racket[#f]。在Unix上，结果总是@racket[#f]。 

}

@defmethod[(maximize [maximize? any/c])
           void?]{
@methspec{

@;{Maximizes or restores the frame on Windows and Mac OS; the
 frame's show state is not affected. On Windows, an iconized frame
 cannot be maximized or restored.}
  规格：在Windows和Mac OS上最大化或还原框架；框架的显示状态不受影响。在Windows上，无法最大化或还原图标化的框架。


@;{@MonitorMethod[@elem{A window's maximization} @elem{the user} @elem{@method[window<%> on-size]} @elem{size}]}
  @MonitorMethod[@elem{窗口的最大化} @elem{用户} @elem{@method[window<%> on-size]} @elem{大小}]

}
@methimpl{

@;{If @racket[maximize?] is @racket[#f], the window is restored, otherwise
 it is maximized.}
默认实现：如果@racket[maximize?]是@racket[#f]，窗口恢复，否则最大化。

}}

@defmethod*[([(modified)
              boolean?]
             [(modified [modified? any/c])
              void?])]{

@;{Gets or sets the frame's modification state as reflected to the user.
 On Mac OS, the modification state is reflected as a dot in the
 frame's close button. On Windows and Unix, the modification state is
 reflected by an asterisk at the end of the frame's displayed title.}
  获取或设置框架的修改状态，以反映给用户。在MacOS上，修改状态在框架的关闭按钮中以点的形式反映出来。在Windows和Unix上，修改状态由框架显示标题末尾的星号反映。

}

@defmethod[(on-menu-char [event (is-a?/c key-event%)])
           boolean?]{

@;{If the frame has a menu bar with keyboard shortcuts, and if the key
event includes a Control, Alt, Option, Meta, Command, Shift, or
Function key, then @method[frame% on-menu-char] attempts to match the
given event to a menu item. If a match is found, @racket[#t] is
returned, otherwise @racket[#f] is returned.}
如果框架具有带键盘快捷键的菜单栏，并且键盘事件包括Control键、Alt键、Option键、Meta键、Command键、Shift键或Function键，则@method[frame% on-menu-char]尝试将给定事件与菜单项匹配。如果找到匹配项，则返回@racket[#t]，否则返回@racket[#f]。

@;{When the match corresponds to a complete shortcut combination, the
 menu item's callback is called (before
@method[frame% on-menu-char] returns).}
当匹配对应一个完整的快捷方式组合时，将调用菜单项的回调（在返回@method[frame% on-menu-char]之前）。

@;{If the event does not correspond to a complete shortcut combination,
 the event may be handled anyway if it corresponds to a mnemonic in the
 menu bar (i.e., an underlined letter in a menu's title, which is
 installed by including an ampersand in the menu's label). If a
 mnemonic match is found, the keyboard focus is moved to the menu bar
 (selecting the menu with the mnemonic), and @racket[#t] is returned.}
 如果事件不对应于完整的快捷方式组合，则如果事件对应于菜单栏中的助记键，即菜单标题中带下划线的字母，通过在菜单标签中包含一个与符号来安装），则无论如何都会处理该事件。如果找到助记键匹配，键盘焦点将移动到菜单栏（用助记键选择菜单），并返回@racket[#t]。 

}

@defmethod[#:mode override 
           (on-subwindow-char [receiver (is-a?/c window<%>)]
                              [event (is-a?/c key-event%)])
           boolean?]{

@;{Returns the result of}
  返回

@racketblock[
(or (send this @#,method[frame% on-menu-char] event)
    (send this @#,method[top-level-window<%> on-system-menu-char] event)
    (send this @#,method[top-level-window<%> on-traverse-char] event))
]
的结果。
}

@defmethod[(on-toolbar-button-click)
           void?]{

@;{On Mac OS, called when the user clicks the toolbar button on a
 frame created with the @indexed-racket['toolbar-button] style.}
  在Mac OS上，当用户单击用@indexed-racket['toolbar-button]样式创建的框架上的工具栏按钮时调用。

}

@defmethod[(set-status-text [text string?])
           void?]{

Sets the frame's status line text and redraws the status line. See
 also @method[frame% create-status-line].
设置框架的状态行文本并重新绘制状态行。另请参见@method[frame% create-status-line]。

}}

