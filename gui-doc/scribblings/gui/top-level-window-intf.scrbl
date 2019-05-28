#lang scribble/doc
@(require "common.rkt")

@definterface/title[top-level-window<%> (area-container-window<%>)]{

@;{A top-level window is either a @racket[frame%] or @racket[dialog%]
 object.}
  顶级窗口是一个@racket[frame%]或@racket[dialog%]对象。

@defmethod[#:mode pubment 
           (can-close?)
           boolean?]{

@;{Called just before the window might be closed (e.g., by the window
 manager). If @racket[#f] is returned, the window is not closed,
 otherwise @method[top-level-window<%> on-close] is called and the
 window is closed (i.e., the window is hidden, like calling
 @method[window<%> show] with @racket[#f]).}
  在关闭窗口之前调用（例如，由窗口管理器）。如果返回@racket[#f]，则不会关闭窗口，否则将调用@method[top-level-window<%> on-close]并关闭窗口（即，窗口是隐藏的，就像用@racket[#f]调用@method[window<%> show]）。

@;{This method is @italic{not} called by @method[window<%> show].}
  @method[window<%> show] @italic{不}调用此方法。
}

@defmethod[(can-exit?)
           boolean?]{
@methspec{

@;{Called before @method[top-level-window<%> on-exit] to check whether an
exit is allowed. See @method[top-level-window<%> on-exit] for more
information.}
  规范：在@method[top-level-window<%> on-exit]前调用，以检查是否允许出口。有关详细信息，请参见@method[top-level-window<%> on-exit]。

}
@methimpl{

@;{Calls @method[top-level-window<%> can-close?] and returns the result.}
  默认实现：调用@method[top-level-window<%> can-close?]并返回结果。

}}

@defmethod[(center [direction (or/c 'horizontal 'vertical 'both) 'both])
           void?]{

@;{Centers the window on the screen if it has no parent. If it has a
 parent, the window is centered with respect to its parent's location.}
  如果窗口没有父级，则使其在屏幕上居中。如果它有一个父窗口，则该窗口相对于其父窗口的位置居中。

@;{If @racket[direction] is @racket['horizontal], the window is centered
 horizontally.  If @racket[direction] is @racket['vertical], the
 window is centered vertically.  If @racket[direction] is
 @racket['both], the window is centered in both directions.}
  如果@racket[direction]为@racket['horizontal]，则窗口水平居中。如果@racket[direction]为@racket['vertical]，则窗口垂直居中。如果@racket[direction]是@racket['both]，则窗口在两个方向上居中。

}

@defmethod[(get-edit-target-object)
           (or/c (or/c (is-a?/c window<%>) (is-a?/c editor<%>)) #f)]{

@;{@index['("keyboard focus" "last active")]{Like}
 @method[top-level-window<%> get-edit-target-window], but if an editor
 canvas had the focus and it also displays an editor, the editor is
 returned instead of the canvas. Further, if the editor's focus is
 delegated to an embedded editor, the embedded editor is returned.}
  与@method[top-level-window<%> get-edit-target-window] @index['("keyboard focus" "last active")]{类似}，但是如果一个编辑器画布有焦点，并且它也显示一个编辑器，则返回编辑器而不是画布。此外，如果编辑器的焦点委托给嵌入的编辑器，则返回嵌入的编辑器。

@;{See also @method[top-level-window<%> get-focus-object].}
  另请参见@method[top-level-window<%> get-focus-object]。

}

@defmethod[(get-edit-target-window)
           (or/c (is-a?/c window<%>) #f)]{

@;{@index['("keyboard focus" "last active")]{Returns} the window that
most recently had the keyboard focus, either the top-level window or
one of its currently-shown children. If neither the window nor any of
its currently-shown children has even owned the keyboard focus,
@racket[#f] is returned.}
  @index['("keyboard focus" "last active")]{返回}最近具有键盘焦点的窗口，即顶级窗口或其当前显示的子窗口之一。如果窗口及其当前显示的任何子窗口都没有拥有键盘焦点，则返回@racket[#f]。

@;{See also @method[top-level-window<%> get-focus-window] and
@method[top-level-window<%> get-edit-target-object].}
  另请参见@method[top-level-window<%> get-focus-window]和@method[top-level-window<%> get-edit-target-object]。

}

@defmethod[(get-eventspace)
           eventspace?]{
@;{Returns the window's eventspace.}
  返回窗口的事件空间。

}

@defmethod[(get-focus-object)
           (or/c (or/c (is-a?/c window<%>) (is-a?/c editor<%>)) #f)]{

@;{@index["keyboard focus"]{Like} @method[top-level-window<%>
get-focus-window], but if an editor canvas has the focus and it also
displays an editor, the editor is returned instead of the
canvas. Further, if the editor's focus is delegated to an embedded
editor, the embedded editor is returned.}
  与@method[top-level-window<%>
get-focus-window] @index["keyboard focus"]{类似}，但如果编辑器画布具有焦点，并且它也显示编辑器，则返回编辑器而不是画布。此外，如果编辑器的焦点委托给嵌入的编辑器，则返回嵌入的编辑器。

@;{See also @method[top-level-window<%> get-edit-target-object].}
  另请参见@method[top-level-window<%> get-edit-target-object]。

}

@defmethod[(get-focus-window)
           (or/c (is-a?/c window<%>) #f)]{

@;{@index["keyboard focus"]{Returns} the window that has the keyboard
 focus, either the top-level window or one of its children. If neither
 the window nor any of its children has the focus, @racket[#f] is
 returned.}
  @index["keyboard focus"]{返回}具有键盘焦点的窗口，即顶级窗口或其子窗口之一。如果窗口及其任何子窗口都没有焦点，@racket[#f]将返回。

@;{See also @method[top-level-window<%> get-edit-target-window] and
@method[top-level-window<%> get-focus-object].}
 另请参见@method[top-level-window<%> get-edit-target-window]和@method[top-level-window<%> get-focus-object]。 

}


@defmethod[(move [x position-integer?]
                 [y position-integer?])
           void?]{

@;{Moves the window to the given position on the screen.}
  将窗口移动到屏幕上的给定位置。

@;{@MonitorMethod[@elem{A window's position} @elem{the user dragging the window} @elem{@method[window<%> on-move]} @elem{position}]}
  
  @MonitorMethod[@elem{窗户的位置} @elem{用户拖动窗口} @elem{@method[window<%> on-move]} @elem{位置}]

}


@defmethod[(on-activate [active? any/c])
           void?]{

@;{Called when a window is @defterm{activated} or
 @defterm{deactivated}. A top-level window is activated when the
 keyboard focus moves from outside the window to the window or one of
 its children. It is deactivated when the focus moves back out of the
 window. On Mac OS, a child of a floating frames can have the
 focus instead of a child of the active non-floating frame; in other
 words, floating frames act as an extension of the active non-frame
 for keyboard focus.}
  当窗口被@defterm{激活}或@defterm{停用}时调用。当键盘焦点从窗口外部移动到窗口或其子窗口之一时，将激活顶级窗口。当焦点移回窗口外时，它将被禁用。在Mac OS上，浮动框架的子级可以具有焦点，而不是活动非浮动框架的子级；换句话说，浮动框架用作键盘焦点的活动非框架的扩展。

@;{The method's argument is @racket[#t] when the window is activated,
 @racket[#f] when it is deactivated.}
  该方法的参数在激活窗口时为@racket[#t]，在停用窗口时为@racket[#f]。

}

@defmethod[#:mode pubment 
           (on-close)
           void?]{

@;{Called just before the window is closed (e.g., by the window manager).
 This method is @italic{not} called by @method[window<%> show].}
在窗口关闭前调用（例如，由窗口管理器调用）。@method[window<%> show] @italic{不}调用此方法。
  
@;{See also
@method[top-level-window<%> can-close?].}
  也参见@method[top-level-window<%> can-close?]。

}

@defmethod[(on-exit)
           void?]{

@methspec{

@;{Called by the default application quit handler (as determined by the
 @racket[application-quit-handler] parameter) when the operating
 system requests that the application shut down (e.g., when the
 @onscreen{Quit} menu item is selected in the main application menu
 on Mac OS). In that case, this method is called for the most
 recently active top-level window in the initial eventspace, but only
 if the window's @method[top-level-window<%> can-exit?]  method first
 returns true.}
  规范：当操作系统请求关闭应用程序时（例如，在Mac OS的主应用程序菜单中选择@onscreen{退出（Quit）}菜单项时），由默认的应用程序退出处理程序调用（由@racket[application-quit-handler]参数确定）。在这种情况下，对初始事件空间中最近活动的顶级窗口调用此方法，但仅当窗口的@method[top-level-window<%> can-exit?]方法首先返回真。

}
@methimpl{

@;{Calls
@method[top-level-window<%> on-close] and then
@method[top-level-window<%> show] to hide the window.}
 默认实现：调用@method[top-level-window<%> on-close]，然后@method[top-level-window<%> show]以隐藏窗口。 

}}

@defmethod[(on-message [message any/c])
           any/c]{
@methspec{

@;{@index["drag-and-drop"]{A} generic message method, usually called by
@racket[send-message-to-window].}
  规范：@index["drag-and-drop"]{一种}通用的消息方法，通常通过向窗口发送消息来调用。

@;{If the method is invoked by @racket[send-message-to-window], then it
is invoked in the thread where @racket[send-message-to-window] was
called (which is possibly @italic{not} the handler thread of the
window's eventspace).}
 如果方法是由@racket[send-message-to-window]调用的，那么它将在调用@racket[send-message-to-window]的线程中调用（该线程可能@italic{不是}窗口的事件空间的处理程序线程）。 

}
@methimpl{

@;{Returns @|void-const|.}
  默认实现：返回@|void-const|。

}}


@defmethod[(display-changed) any/c]{
  @methspec{
    @;{Called when the displays configuration changes.}
指定：显示配置更改时调用。
      
    @;{To determine the new monitor configuration, use
    @racket[get-display-count], @racket[get-display-size],
    @racket[get-display-left-top-inset], and
    @racket[get-display-backing-scale].}
      要确定新的监视器配置，请使用@racket[get-display-count]、@racket[get-display-size]、@racket[get-display-left-top-inset]和@racket[get-display-backing-scale]。

    @;{Note that this method may be invoked multiple times for a single
    logical change to the monitors.}
      请注意，对于监视器的单个逻辑更改，可以多次调用此方法。
    
  }
  @methimpl{
    @;{Returns @|void-const|.}
      默认实现：返回@|void-const|。
  }
}


@defmethod[(on-traverse-char [event (is-a?/c key-event%)])
           boolean?]{

@methspec{

@;{@index['("keyboard focus" "navigation")]{Attempts} to handle the given
 keyboard event as a navigation event, such as a Tab key event that
 moves the keyboard focus. If the event is handled, @racket[#t] is
 returned, otherwise @racket[#f] is returned.}
规范：@index['("keyboard focus" "navigation")]{尝试}将给定的键盘事件作为导航事件处理，例如移动键盘焦点的Tab键事件。如果处理事件，则返回@racket[#t]，否则返回@racket[#f]。
}
@methimpl{

@;{The following rules determine, in order, whether and how @racket[event]
is handled:}
  默认实现：以下规则依次确定@racket[event]是否处理以及如何处理：

@itemize[

@item{
@;{If the window that currently owns the focus specifically handles the
 event, then @racket[#f] is returned. The following describes window
 types and the keyboard events they specifically handle:}
  如果当前拥有焦点的窗口专门处理事件，则返回@racket[#f]。下面介绍窗口类型及其专门处理的键盘事件：
  
@itemize[

 @item{@;{@racket[editor-canvas%] --- tab-exit is disabled (see
@method[editor-canvas% allow-tab-exit]): all keyboard events, except alphanumeric key events when the Meta
       (Unix) or Alt (Windows) key is pressed; when tab-exit is enabled:
       all keyboard events except Tab, Enter, Escape, and alphanumeric
       Meta/Alt events.}
      @racket[editor-canvas%]——tab-exit禁用（请参见@method[editor-canvas% allow-tab-exit]）：当按下Meta（Unix）或Alt（Windows）键时，除字母数字键事件外的所有键盘事件；当tab-exit启用时，除Tab、Enter、Escape和字母数字Meta/Alt事件外的所有键盘事件。}

 @item{@;{@racket[canvas%] --- when tab-focus is disabled (see
@method[canvas<%> accept-tab-focus]): all keyboard events, except alphanumeric key events when the Meta
       (Unix) or Alt (Windows) key is pressed; when tab-focus is enabled:
       no key events}
        @racket[canvas%]——禁用tab-focus时（请参阅@method[canvas<%> accept-tab-focus]）：除按下Meta（Unix）或Alt（Windows）键时发生的字母数字键事件外的所有键盘事件；启用tab-focus时：无键事件}

 @item{@;{@racket[text-field%], @racket['single] style --- arrow key
 events and alphanumeric key events when the Meta (Unix) or Alt
 (Windows) key is not pressed (and all alphanumeric events on
 Mac OS)}
         @racket[text-field%]、@racket['single]样式——未按下Meta（Unix）或Alt（Windows）键时的箭头键事件和字母数字键事件（以及Mac OS上的所有字母数字事件）}

 @item{@;{@racket[text-field%], @racket['multiple] style --- all
 keyboard events, except alphanumeric key events when the Meta (Unix) or
 Alt (Windows) key is pressed}
         @racket[text-field%]、@racket['multiple]样式——除按下Meta（Unix）或Alt（Windows）键时发生的字母数字键事件外的所有键盘事件}

 @item{@;{@racket[choice%] --- arrow key events and alphanumeric key
 events when the Meta (Unix) or Alt (Windows) key is not pressed}
        @racket[choice%]——未按meta（unix）或alt（windows）键时的箭头键事件和字母数字键事件}

 @item{@;{@racket[list-box%] --- arrow key events and alphanumeric key
 events when the Meta (Unix) or Alt (Windows) key is not pressed}
      @racket[list-box%]——未按meta（unix）或alt（windows）键时的箭头键事件和字母数字键事件}

]}

@item{
@;{If @racket[event] is a Tab or arrow key event, the keyboard focus is
 moved within the window and @racket[#t] is returned. Across platforms,
 the types of windows that accept the keyboard focus via navigation
 may vary, but @racket[text-field%] windows always accept the focus,
 and @racket[message%], @racket[gauge%], and @racket[panel%]
 windows never accept the focus.}
  如果@racket[event]是Tab或箭头键事件，键盘焦点将在窗口中移动，并返回@racket[#t]。跨平台，通过导航接受键盘焦点的窗口类型可能有所不同，但@racket[text-field%]窗口始终接受焦点，而@racket[message%]、@racket[gauge%]和@racket[panel%]窗口从不接受焦点。}

@item{
@;{If @racket[event] is a Space key event and the window that currently
 owns the focus is a @racket[button%], @racket[check-box%], or
 @racket[radio-box%] object, the event is handled in the same way as
 a click on the control and @racket[#t] is returned.}
  如果@racket[event]是一个Space键事件，并且当前拥有焦点的窗口是一个@racket[button%]、@racket[check-box%]或@racket[radio-box%]对象，则该事件的处理方式与单击控件的方式相同，并返回@racket[#t]。}

@item{
@;{If @racket[event] is an Enter key event and the current top-level window
 contains a border button, the button's callback is invoked and
 @racket[#t] is returned. (The @racket['border] style for a
 @racket[button%] object indicates to the user that pressing Enter
 is the same as clicking the button.) If the window does not contain a
 border button, @racket[#t] is returned if the window with the current
 focus is not a text field or editor canvas.}
  如果@racket[event]是Enter键事件，并且当前顶级窗口包含边框按钮，则调用按钮的回调并返回@racket[#t]。（@racket[button%]对象的@racket['border]样式向用户指示按Enter键与单击按钮相同。）如果窗口不包含边框按钮，如果当前焦点的窗口不是文本字段或编辑器画布，则返回@racket[#t]。}

@item{
@;{In a dialog, if @racket[event] is an Escape key event, the event is
 handled the same as a click on the dialog's close box (i.e., the
 dialog's
@method[top-level-window<%> can-close?] and
@method[top-level-window<%> on-close] methods are called, and the dialog is hidden) and @racket[#t] is
 returned.}
  在对话框中，如果@racket[event]是一个转义键事件，则该事件的处理方式与单击对话框的关闭框（即对话框的@method[top-level-window<%> can-close?]）和@method[top-level-window<%> on-close]方法被调用，对话框被隐藏），并返回@racket[#t]。}

@item{
@;{If @racket[event] is an alphanumeric key event and the current top-level
 window contains a control with a mnemonic matching the key (which is
 installed via a label that contains @litchar{&}; see
 @method[window<%> get-label] for more information), then the
 keyboard focus is moved to the matching control. Furthermore, if the
 matching control is a @racket[button%], @racket[check-box%], or
 @racket[radio-box%] button, the keyboard event is handled in the
 same way as a click on the control.}
  如果@racket[event]是字母数字键事件，并且当前顶级窗口包含一个控件，该控件具有与该键匹配的助记键（通过包含@litchar{&}；有关详细信息，请参见@method[window<%> get-label]）安装，则键盘焦点将移动到匹配的控件。此外，如果匹配的控件是@racket[button%]、@racket[check-box%]或@racket[radio-box%]按钮，则键盘事件的处理方式与单击控件的方式相同。}

@item{
@;{Otherwise, @racket[#f] is returned.}
    否则，返回@racket[#f]。}

]
}}

@defmethod[(on-system-menu-char [event (is-a?/c key-event%)])
           boolean?]{

@;{Checks whether the given event pops open the system menu in the
 top-left corner of the window (Windows only). If the window's system
 menu is opened, @racket[#t] is returned, otherwise @racket[#f] is
 returned.}
  检查给定事件是否弹出窗口左上角的系统菜单（仅限Windows）。如果打开窗口的系统菜单，则返回@racket[#t]，否则返回@racket[#f]。

}

@defmethod[(resize [width dimension-integer?]
                   [height dimension-integer?])
           void?]{

@;{Sets the size of the window (in pixels), but only if the given size is
 larger than the window's minimum size.}
  设置窗口的大小（以像素为单位），但前提是给定的大小大于窗口的最小大小。

@;{@MonitorMethod[@elem{A window's size} @elem{the user} @elem{@method[window<%> on-size]} @elem{size}]}
  @MonitorMethod[@elem{窗口的大小} @elem{用户} @elem{@method[window<%> on-size]} @elem{大小}]

}


@defmethod[(set-icon [icon (is-a?/c bitmap%)]
                     [mask (is-a?/c bitmap%) #f]
                     [which (or/c 'small 'large 'both) 'both])
           void?]{

@;{Sets the large or small icon bitmap for the window.  Future changes to
 the bitmap do not affect the window's icon.}
  设置窗口的大图标位图或小图标位图。以后对位图的更改不会影响窗口的图标。

@;{The icon is used in a platform-specific way:}
  该图标以特定于平台的方式使用：

@itemize[

 @item{Windows@;{ --- the small icon is used for the window's icon (in the
       top-left) and in the task bar, and the large icon is used for
       the Alt-Tab task switcher.}——小图标用于窗口的图标（左上角）和任务栏，大图标用于Alt-Tab任务切换。}

 @item{Mac OS@;{ --- both icons are ignored.}——两个图标都被忽略。}

 @item{Unix@;{ --- many window managers use the small icon in the same way
       as Windows, and others use the small icon when iconifying the
       frame; the large icon is ignored.}——许多窗口管理器使用小图标的方式与Windows相同，而其他窗口管理器在对框架进行图标化时使用小图标；忽略大图标。

}

]

@;{The bitmap for either icon can be any size, but most platforms scale
 the small bitmap to 16 by 16 pixels and the large bitmap to 32 by 32
 pixels.}
 两个图标的位图可以是任意大小，但大多数平台将小位图缩放为16 x 16像素，大位图缩放为32 x 32像素。 

@;{If a mask bitmap is not provided, then the entire (rectangular) bitmap
 is used as an icon.}
如果未提供遮罩位图，则整个（矩形）位图将用作图标。
  
@;{If a mask bitmap is provided, the mask must be monochrome. In the mask
 bitmap, use black pixels to indicate the icon's region and use white
 pixels outside the icon's region. In the icon bitmap, use black
 pixels for the region outside the icon.}
  如果提供了遮罩位图，则遮罩必须是单色的。在遮罩位图中，使用黑色像素指示图标的区域，并在图标区域之外使用白色像素。在图标位图中，对图标外的区域使用黑色像素。
 }


@defmethod[(show [show any/c])
           void?]{

@;{If the window is already shown, it is moved front of other top-level
 windows. If the window is iconized (frames only), it is deiconized.}
  如果该窗口已显示，则它将移动到其他顶级窗口的前面。如果窗口是图标化的（仅限框架），则将其非图标化。

@;{See also @xmethod[window<%> show].}
  另请参见@xmethod[window<%> show]。

}}

