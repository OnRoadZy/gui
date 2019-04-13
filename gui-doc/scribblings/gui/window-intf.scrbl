#lang scribble/doc
@(require "common.rkt"
          (for-label (only-in ffi/unsafe cpointer?)))

@definterface/title[window<%> (area<%>)]{

@;{A @racket[window<%>] object is an @racket[area<%>] with a graphical
 representation that can respond to events.}
  
  @racket[window<%>]对象是一个具有图形表示的@racket[area<%>]可以响应事件。

@;{All @racket[window<%>] classes accept the following named instantiation
 arguments:}
  所有window<%>类都接受以下命名的实例化参数：
    
@itemize[

 @item{@indexed-racket[enabled]@;{ --- default is @racket[#t]; passed to
@method[window<%> enable] if @racket[#f]}
  ——默认值为@racket[#t]；如果是@racket[#f]，传递到@method[window<%> enable]。}

]




@defmethod*[([(accept-drop-files)
              boolean?]
             [(accept-drop-files [accept-files? any/c])
              void?])]{

@;{@index["drag-and-drop"]{Enables} or disables drag-and-drop dropping
 for the window, or gets the enable state. Dropping is initially
 disabled. See also @method[window<%> on-drop-file].}
  为窗口@index["drag-and-drop"]{启用}或禁用拖放，或获取启用状态。最初禁用删除。另请参见@method[window<%> on-drop-file]。
}

@defmethod[(client->screen [x position-integer?]
                           [y position-integer?])
           (values position-integer?
                   position-integer?)]{

@;{@index["global coordinates"]{Converts} local window coordinates to
screen coordinates.}
  将@index["global coordinates"]{本地窗口}坐标转换为屏幕坐标。

@;{On Mac OS, the screen coordinates start with @math{(0, 0)} at the
upper left of the menu bar. In contrast, @xmethod[top-level-window<%>
move] considers @math{(0, 0)} to be below the menu bar. See also
@racket[get-display-left-top-inset].}
  在Mac OS上，屏幕坐标从菜单栏左上角的@math{(0, 0)}开始。相反，@xmethod[top-level-window<%>
move]会认为@math{(0, 0)}在菜单栏下方。另请参见@racket[get-display-left-top-inset]。

}

@defmethod[(enable [enable? any/c])
           void?]{

@;{Enables or disables a window so that input events are ignored. (Input
 events include mouse events, keyboard events, and close-box clicks,
 but not focus or update events.) When a window is disabled, input
 events to its children are also ignored.}
  启用或禁用窗口，以便忽略输入事件。（输入事件包括鼠标事件、键盘事件和关闭框单击，但不包括焦点或更新事件。）当窗口被禁用时，对其子级的输入事件也将被忽略。

@;{@MonitorMethod[@elem{The enable state of a window} @elem{enabling a parent window} @elem{@method[window<%> on-superwindow-enable]} @elem{enable state}]}
  @MonitorMethod[@elem{窗口的启用状态}@elem{启用父窗口}@elem{@method[window<%> on-superwindow-enable]}@elem{启用状态}]

@;{If @racket[enable?] is true, the window is enabled, otherwise it is
 disabled.}
  如果@racket[enable?]为真，则启用该窗口，否则禁用该窗口。

}

@defmethod[(focus)
           void?]{

@;{@index['("keyboard focus" "setting")]{Moves} the keyboard focus to the
 window, relative to its top-level window, if the window ever accepts
 the keyboard focus.  If the focus is in the window's top-level
 window or if the window's top-level window is visible and floating
 (i.e., created with the @racket['float] style), then the focus is
 immediately moved to this
 window. Otherwise, the focus is not immediately moved, but when the
 window's top-level window gets the keyboard focus, the focus is
 delegated to this window.}
  如果窗口接受键盘焦点，则将键盘焦点相对于其顶层窗口移动到窗口。如果焦点在窗口的顶层窗口中，或者窗口的顶层窗口可见且浮动（即使用@racket['float]样式创建），则焦点将立即移动到此窗口。否则，焦点不会立即移动，但当窗口的顶层窗口获得键盘焦点时，焦点将委托给该窗口。

@;{See also
@method[window<%> on-focus].}
  另请参见@method[window<%> on-focus]。

@;{Note that on Unix, keyboard focus can move to the menu bar
 when the user is selecting a menu item.}
 注意，在UNIX上，当用户选择菜单项时，键盘焦点可以移动到菜单栏。 

@;{@MonitorMethod[@elem{The current keyboard focus window} @elem{the user} @elem{@method[window<%> on-focus]} @elem{focus}]}
  @MonitorMethod[@elem{当前键盘焦点窗口} @elem{用户} @elem{@method[window<%> on-focus]} @elem{焦点}]

}


@defmethod[(get-client-handle) cpointer?]{

@;{Returns a handle to the ``inside'' of the window for the current
platform's GUI toolbox. The value that the pointer represents depends
on the platform:}
  将句柄返回到当前平台的GUI工具箱窗口的“内部”。指针表示的值取决于平台：

@itemize[

 @item{Windows: @tt{HWND}}

 @item{Mac OS: @tt{NSView}}

 @item{Unix: @tt{GtkWidget}}

]

@;{See also @method[window<%> get-handle].}}
另请参见@method[window<%> get-handle]。


@defmethod[(get-client-size)
           (values dimension-integer?
                   dimension-integer?)]{

@;{Gets the interior size of the window in pixels. For a container, the
 interior size is the size available for placing subwindows (including
 the border margin). For a canvas, this is the visible drawing
 area.}
  获取窗口的内部大小（像素）。对于容器，内部大小是可用于放置子窗口的大小（包括边框边距）。对于画布，这是可见的绘图区域。


@;{The client size is returned as two values: width and height (in pixels).}
  客户端大小返回为两个值：宽度和高度（以像素为单位）。

@;{See also
@method[area-container<%> reflow-container].
  另请参见@method[area-container<%> reflow-container]。}

}


@defmethod[(get-cursor)
           (or/c (is-a?/c cursor%) #f)]{

@;{Returns the window's cursor, or @racket[#f] if this window's cursor
 defaults to the parent's cursor.  See
@method[window<%> set-cursor] for more information.}
  返回窗口的光标，如果此窗口的光标默认为父级光标，则返回@racket[#f]。有关详细信息，请参见@method[window<%> set-cursor]。

}


@defmethod[(get-handle) cpointer?]{

@;{Returns a handle to the ``outside'' of the window for the current platform's GUI
toolbox. The value that the pointer represents depends on the
platform:}
  将句柄返回到当前平台的GUI工具箱窗口的“外部”。指针表示的值取决于平台：

@itemize[

 @item{Windows: @tt{HWND}}

 @item{Mac OS: @;{@tt{NSWindow} for a @racket[top-level-window<%>] object,
       @tt{NSView} for other windows}
   @tt{NSWindow}用于@racket[top-level-window<%>]对象，@tt{NSView}用于其他窗口}

 @item{Unix: @tt{GtkWidget}}

]

@;{See also @method[window<%> get-client-handle].}
  另请参见@method[window<%> get-client-handle]。}


@defmethod[(get-height)
           dimension-integer?]{

@;{Returns the window's total height (in pixels).}
  返回窗口的总高度（像素）。

@;{See also
@method[area-container<%> reflow-container].}
  另请参见@method[area-container<%> reflow-container]。

}

@defmethod[(get-label)
           (or/c label-string? 
                 (is-a?/c bitmap%)
                 (or/c 'app 'caution 'stop) 
                 (list/c (is-a?/c bitmap%)
                         label-string?
                         (or/c 'left 'top 'right 'bottom))
                 #f)]{

@;{Gets a window's label, if any. Control windows generally display their
 label in some way. Frames and dialogs display their label as a window
 title. Panels do not display their label, but the label can be used
 for identification purposes. Messages, buttons, and check boxes can
 have bitmap labels (only when they are created with bitmap labels),
 but all other windows have string labels. In addition, a message
 label can be an icon symbol @racket['app], @racket['caution], or
 @racket['stop], and a button can have both a bitmap label and a
 string label (along with a position for the bitmap).}
  获取窗口的标签（如果有）。控制窗口通常以某种方式显示其标签。框架和对话框将其标签显示为窗口标题。面板不显示其标签，但标签可用于识别意义。消息、按钮和复选框可以有位图标签（仅当使用位图标签创建时），但所有其他窗口都有字符串标签。此外，消息标签可以是图标符号@racket['app]、@racket['caution]或@racket['stop]，按钮可以同时具有位图标签和字符串标签（以及位图的位置）。

@;{A label string may contain @litchar{&}s, which serve as
 keyboard navigation annotations for controls on Windows and Unix. The
 ampersands are not part of the displayed label of a control; instead,
 ampersands are removed in the displayed label (on all platforms),
 and any character preceding an ampersand is underlined (Windows and
 Unix) indicating that the character is a mnemonic for the
 control. Double ampersands are converted into a single ampersand
 (with no displayed underline). See also
 @method[top-level-window<%> on-traverse-char].}
  标签字符串可以包含@litchar{&}，它用作Windows和Unix上控件的键盘导航注释。&号不是控件显示标签的一部分；相反，&号将在显示标签中删除（在所有平台上），&号前面的任何字符都加下划线（Windows和Unix），表示该字符是控件的助记键。双&号（&&）转换为单&号（&）（没有显示下划线）。另请参见@method[top-level-window<%> on-traverse-char]。

@;{If the window does not have a label, @racket[#f] is returned.}
  如果窗口没有标签，则返回@racket[#f]。

}


@defmethod[(get-plain-label)
           (or/c string? #f)]{

@;{Like
@method[window<%> get-label], except that:}
  类似于@method[window<%> get-label]，除非是： 

@itemlist[

 @item{@;{If the label includes @litchar{(&}@racket[_c]@litchar{)} for
       any character @racket[_c], then the sequenece and any surrounding
       whitespace is removed.}
   如果标签包含任何字符@racket[_c]的@litchar{(&}@racket[_c]@litchar{)}，然后删除序列和周围的空白。}

 @item{@;{If the label contains @litchar{&}@racket[_c] for any character @racket[_c],
       the @litchar{&} is removed.}
   如果标签中含有任何字符@racket[_c]的@litchar{&}@racket[_c]，则将@litchar{&}删除。}

 @item{@;{If the label contains a tab character, then the tab character and all following
       characters are removed.}
   如果标签包含制表符，则将删除制表符和所有以下字符。}

]

@;{See also @racket[button%]'s handling of labels.}
  另请参见@racket[button%]的标签处理。

@;{If the window has
 no label or the window's
 label is not a string, @racket[#f] is returned.}
  如果窗口没有标签或窗口标签不是字符串，则返回@racket[#f]。

}


@defmethod[(get-size)
           (values dimension-integer?
                   dimension-integer?)]{

@;{Gets the current size of the entire window in pixels, not counting
 horizontal and vertical margins. (On Unix, this size does not include
 a title bar or borders for a frame/dialog.) See also
@method[window<%> get-client-size].}
  获取整个窗口的当前大小（像素），不计算水平和垂直边距。（在Unix上，此大小不包括框架/对话框的标题栏或边框。）另请参见@method[window<%> get-client-size]。

@;{The geometry is returned as two values: width and height (in pixels).}
几何图形返回为两个值：宽度和高度（以像素为单位）。

@;{See also
@method[area-container<%> reflow-container].}
  另请参见@method[area-container<%> reflow-container]。
}


@defmethod[(get-width)
           dimension-integer?]{

@;{Returns the window's current total width (in pixels).}
  返回窗口当前的总宽度（像素）。

@;{See also
@method[area-container<%> reflow-container].}
  另请参见@method[area-container<%> reflow-container]。

}

@defmethod[(get-x)
           position-integer?]{

@;{Returns the position of the window's left edge in its
 parent's coordinate system.}
  返回窗口左边缘在其父坐标系中的位置。

@;{See also
@method[area-container<%> reflow-container].}
  另请参见@method[area-container<%> reflow-container]。

}

@defmethod[(get-y)
           position-integer?]{

@;{Returns the position of the window's top edge in its
 parent's coordinate system.}
返回窗口上边缘在其父坐标系中的位置。

@;{See also
@method[area-container<%> reflow-container].}
  另请参见@method[area-container<%> reflow-container]。

}


@defmethod[(has-focus?)
           boolean?]{

@;{Indicates whether the window currently has the keyboard focus. See
 also
@method[window<%> on-focus].}
  指示窗口当前是否具有键盘焦点。另请参见@method[window<%> on-focus]。

}


@defmethod[(is-enabled?)
           boolean?]{

@;{Indicates whether the window is currently enabled or not. The result is
 @racket[#t] if this window is enabled when its ancestors are enabled, or
 @racket[#f] if this window remains disable when its ancestors are
 enabled. (That is, the result of this method is affected only by calls
 to @method[window<%> enable] for @this-obj[], not by the enable state of
 parent windows.)}
 指示窗口当前是否已启用。如果此窗口在启用其祖先时启用，则结果为@racket[#t]；如果此窗口在启用其祖先时保持禁用，则结果为@racket[#f]。（也就是说，此方法的结果只受@this-obj[]的@method[window<%> enable]调用的影响，而不受父窗口的启用状态的影响。）}


@defmethod[(is-shown?)
           boolean?]{

@;{Indicates whether the window is currently shown or not. The result is
 @racket[#t] if this window is shown when its ancestors are shown, or
 @racket[#f] if this window remains hidden when its ancestors are
 shown. (That is, the result of this method is affected only by calls
 to @method[window<%> show] for @this-obj[], not by the visibility of
 parent windows.)}
  指示当前是否显示窗口。如果此窗口在显示其祖先时显示，则结果为@racket[#t]；如果此窗口在显示其祖先时保持隐藏，则结果为@racket[#f]。（也就是说，此方法的结果只受为@this-obj[]的@method[window<%> show]调用的影响，而不受父窗口的可见性的影响。）}


@defmethod[(on-drop-file [pathname path?])
           void?]{

@;{@index["drag-and-drop"]{Called} when the user drags a file onto the
 window. (On Unix, drag-and-drop is supported via the XDND
 protocol.) Drag-and-drop must first be enabled for the window with
 @method[window<%> accept-drop-files].}
  当用户将文件拖到窗口上时@index["drag-and-drop"]{调用}。（在Unix上，通过xnd协议支持拖放。）必须首先为具有@method[window<%> accept-drop-files]的窗口启用拖放。

@;{On Mac OS, when the application is running and user
 double-clicks an application-handled file or drags a file onto the
 application's icon, the main thread's application file handler is
 called (see
@racket[application-file-handler]). The default handler calls the
@method[window<%> on-drop-file] method of the most-recently activated frame if drag-and-drop is
 enabled for that frame, independent of the frame's eventspace (but
 the method is called in the frame's eventspace's handler
 thread). When the application is not running, the filenames are
 provided as command-line arguments.}
  在Mac OS上，当应用程序运行并且用户双击应用程序处理的文件或将文件拖到应用程序的图标上时，将调用主线程的应用程序文件处理程序（请参见@racket[application-file-handler]）。如果为该帧启用了拖放功能，则默认处理程序将调用最近激活的框架的@method[window<%> on-drop-file]方法，与该框架的事件空间无关（但该方法在该框架的事件空间的处理程序线程中调用）。当应用程序不运行时，文件名作为命令行参数提供。

}

@defmethod[(on-focus [on? any/c])
           void?]{
@methspec{

@;{@index['("keyboard focus" "notification")]{Called} when a window
 receives or loses the keyboard focus. If the argument is @racket[#t],
 the keyboard focus was received, otherwise it was lost.}
  规范：当窗口接收或丢失键盘焦点时@index['("keyboard focus" "notification")]{调用}。如果参数为@racket[#t]，则接收到键盘焦点，否则将丢失。

@;{Note that on Unix, keyboard focus can move to the menu bar
 when the user is selecting a menu item.}
  注意，在UNIX上，当用户选择菜单项时，键盘焦点可以移动到菜单栏。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}

@defmethod[(on-move [x position-integer?]
                    [y position-integer?])
           void?]{
@methspec{

@;{Called when the window is moved. (For windows that are not top-level
 windows, ``moved'' means moved relative to the parent's top-left
 corner.) The new position is provided to the method.}
  规范：在移动窗口时调用。（对于不是顶层窗口的窗口，“移动”表示相对于父窗口的左上角移动。）新位置提供给该方法。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[(on-size [width dimension-integer?]
                    [height dimension-integer?])
           void?]{
@methspec{

@;{Called when the window is resized. The window's new size (in pixels)
 is provided to the method. The size values are for the entire window,
 not just the client area.}
  规范：在调整窗口大小时调用。该方法提供了窗口的新大小（以像素为单位）。大小值适用于整个窗口，而不仅仅是工作区。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}

@defmethod[(on-subwindow-char [receiver (is-a?/c window<%>)]
                              [event (is-a?/c key-event%)])
           boolean?]{
@methspec{

@;{Called when this window or a child window receives a keyboard event.
 The
@method[window<%> on-subwindow-char] method of the receiver's top-level window is called first (see
@method[area<%> get-top-level-window]); if the return value is @racket[#f], then the
@method[window<%> on-subwindow-char] method is called for the next child in the path to the receiver, and
 so on. Finally, if the receiver's
@method[window<%> on-subwindow-char] method returns @racket[#f], the event is passed on to the receiver's
 normal key-handling mechanism.}
  规范：当此窗口或子窗口接收到键盘事件时调用。首先调用接收器顶级窗口的@method[window<%> on-subwindow-char]方法（请参见@method[area<%> get-top-level-window]）；如果返回值为@racket[#f]，则为接收器路径中的下一个子项调用@method[window<%> on-subwindow-char]方法，依此类推。最后，如果服务器的@method[window<%> on-subwindow-char]方法返回@racket[#f]，则事件将传递给服务器的常规密钥处理机制。

@;{The @racket[event] argument is the event that was generated for the
 @racket[receiver] window.}
  @racket[event]参数是为@racket[receiver]窗口生成的事件。

@;{The atomicity limitation @method[window<%> on-subwindow-event] applies
 to @method[window<%> on-subwindow-char] as well. That is, an insufficiently cooperative
 @method[window<%> on-subwindow-char] method can effectively disable
 a control's handling of key events, even when it returns @racket[#f]}
  @method[window<%> on-subwindow-event]的原子性限制也适用于@method[window<%> on-subwindow-char]。也就是说，在@method[window<%> on-subwindow-char]方法上不充分合作可以有效地禁用控件对键盘事件的处理，即使它返回@racket[#f]。

@;{BEWARE: The default
@xmethod[frame% on-subwindow-char] and
@xmethod[dialog% on-subwindow-char] methods consume certain keyboard events (e.g., arrow keys, Enter) used
 for navigating within the window. Because the top-level window gets
 the first chance to handle the keyboard event, some events never
 reach the ``receiver'' child unless the default frame or dialog
 method is overridden.}
  注意：@xmethod[frame% on-subwindow-char]和@xmethod[dialog% on-subwindow-char]方法使用某些键盘事件（例如，箭头键、Enter）用于在窗口中导航。因为顶层窗口第一次有机会处理键盘事件，所以有些事件永远不会到达“接收器”子级，除非覆盖默认框架或对话框方法。

}
@methimpl{

@;{Returns @racket[#f].}
默认实现：返回@racket[#f]。
}}

@defmethod[(on-subwindow-event [receiver (is-a?/c window<%>)]
                               [event (is-a?/c mouse-event%)])
           boolean?]{
@methspec{

@;{Called when this window or a child window receives a mouse event.
 The
@method[window<%> on-subwindow-event] method of the receiver's top-level window is called first (see
@method[area<%> get-top-level-window]); if the return value is @racket[#f], the
@method[window<%> on-subwindow-event] method is called for the next child in the path to the receiver, and
 so on. Finally, if the receiver's
@method[window<%> on-subwindow-event] method returns @racket[#f],  the event is passed on to the
 receiver's normal mouse-handling mechanism. }
  规范：当此窗口或子窗口接收到鼠标事件时调用。首先调用接收器顶层@method[window<%> on-subwindow-event]事件方法（请参见@method[area<%> get-top-level-window]）；如果返回值为@racket[#f]，则为接收器路径中的下一个子级调用@method[window<%> on-subwindow-event]事件方法，依此类推。最后，如果接收器的@method[window<%> on-subwindow-event]方法返回@racket[#f]，则事件将传递到接收器的正常鼠标处理机制。

@;{The @racket[event] argument is the event that was generated for the
 @racket[receiver] window.}
  @racket[event]参数是为@racket[receiver]窗口生成的事件。

@;{If the @method[window<%> on-subwindow-event] method chain does not complete
 atomically (i.e., without requiring other threads to run) or does not complete
 fast enough, then the corresponding event may not be delivered to a target
 control, such as a button. In other words, an insufficiently cooperative
 @method[window<%> on-subwindow-event] method can effectively disable a
 control's handling of mouse events, even when it returns @racket[#f].}
  如果@method[window<%> on-subwindow-event]方法链没有原子地完成（即，不需要运行其他线程）或完成得不够快，则相应的事件可能无法传递到目标控件，例如按钮。换句话说，在@method[window<%> on-subwindow-event]方法上不充分合作可以有效地禁用控件对鼠标事件的处理，即使控件返回@racket[#f]。

}
@methimpl{

@;{eturns @racket[#f].}
  默认实现：返回@racket[#f]。

}}


@defmethod[(on-subwindow-focus [receiver (is-a?/c window<%>)]
                               [on? boolean?])
           void?]{

@methspec{

Called when this window or a child window receives or loses the keyboard focus.
 This method is called after the @method[window<%> on-focus] method of @racket[receiver].
 The
@method[window<%> on-subwindow-focus] method of the receiver's top-level window is called first (see
@method[area<%> get-top-level-window]), then the
@method[window<%> on-subwindow-focus] method is called for the next child in the path to the receiver, and
 so on.
规范：当此窗口或子窗口接收或丢失键盘焦点时调用。此方法在@racket[receiver]的@method[window<%> on-focus]之后调用。首先调用接收器顶层窗口的@method[window<%> on-subwindow-focus]方法（请参见@method[window<%> on-subwindow-focus]），然后为接收器路径中的下一个子级调用@method[window<%> on-subwindow-focus]方法，依此类推。
}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}

@defmethod[(on-superwindow-enable [enabled? any/c])
           void?]{

@methspec{

@;{Called via the event queue whenever the enable state of a window has
 changed, either through a call to the window's
@method[window<%> enable] method, or through the enabling/disabling of one of the window's
 ancestors. The method's argument indicates whether the window is now
 enabled or not.}
  规范：每当窗口的启用状态发生更改时，通过事件队列调用，可以通过调用窗口的@method[window<%> enable]方法，也可以通过启用/禁用窗口的一个祖先来调用。方法的参数指示窗口现在是否已启用。

@;{This method is not called when the window is initially created; it is
 called only after a change from the window's initial enable
 state. Furthermore, if an enable notification event is queued for the
 window and it reverts its enabled state before the event is
 dispatched, then the dispatch is canceled.}
  最初创建窗口时不调用此方法；只有在窗口的初始启用状态更改后才调用此方法。此外，如果启用通知事件排队等待窗口，并在调度事件之前恢复其启用状态，则调度被取消。

@;{If the enable state of a window's ancestor changes while the window is
 deleted (e.g., because it was removed with
@method[area-container<%> delete-child]), then no enable events are queued for the deleted window. But if
 the window is later re-activated into an enable state that is
 different from the window's state when it was de-activated, then an
 enable event is immediately queued.}
 如果在删除窗口时窗口祖先的启用状态发生更改（例如，因为它是用@method[area-container<%> delete-child]删除的），则不会为已删除窗口排队任何启用事件。但是，如果稍后重新激活窗口，使其处于与取消激活时窗口的状态不同的启用状态，则会立即将启用事件排队。 

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}
@defmethod[(on-superwindow-show [shown? any/c])
           void?]{

@methspec{

@;{Called via the event queue whenever the visibility of a window has
 changed, either through a call to the window's
@method[window<%> show], through the showing/hiding of one of the window's ancestors, or
 through the activating or deactivating of the window or its ancestor
 in a container (e.g., via
@method[area-container<%> delete-child]). The method's argument indicates whether the window is now
 visible or not.}
  规范：每当窗口的可见性发生变化时，通过事件队列调用，可以通过调用窗口的@method[window<%> show]、显示/隐藏窗口的一个祖先，也可以通过激活或停用窗口或其在容器中的祖先（例如，通过@method[area-container<%> delete-child]）。方法的参数指示窗口现在是否可见。

@;{This method is not called when the window is initially created; it is
 called only after a change from the window's initial
 visibility. Furthermore, if a show notification event is queued for
 the window and it reverts its visibility before the event is
 dispatched, then the dispatch is canceled.}
  最初创建窗口时不调用此方法；只有在窗口的初始可见性发生更改后才调用此方法。此外，如果显示通知事件排队等待窗口，并且在调度事件之前恢复其可见性，则调度被取消。

}
@methimpl{

@;{Does nothing.}
 默认实现：不执行任何操作。 

}}

@defmethod[(popup-menu [menu (is-a?/c popup-menu%)]
                       [x position-integer?]
                       [y position-integer?])
           void?]{

@popupmenuinfo["window" "window" ""]

@;{The @racket[menu] is popped up within the window at position
 (@racket[x], @racket[y]).}
   @racket[menu]在窗口中的位置(@racket[x], @racket[y])弹出。

}

@defmethod[(refresh)
           void?]{

@;{Enqueues an event to repaint the window.}
  将事件排队以重新绘制窗口。

}

@defmethod[(screen->client [x position-integer?]
                           [y position-integer?])
           (values position-integer?
                   position-integer?)]{

@;{@index["global coordinates"]{Converts} global coordinates to window
 local coordinates. See also @method[window<%> client->screen] for information
 on screen coordinates.}
  将全局坐标@index["global coordinates"]{转换为}窗口局部坐标。有关屏幕坐标的信息，请参见@method[window<%> client->screen]。

}


@defmethod[(set-cursor [cursor (or/c (is-a?/c cursor%) #f)])
           void?]{

@;{Sets the window's cursor. Providing @racket[#f] instead of a cursor
 value removes the window's cursor.}
  设置窗口的光标。提供@racket[#f]而不是光标值将删除窗口的光标。

@;{If a window does not have a cursor, it uses the cursor of its parent.
 Frames and dialogs start with the standard arrow cursor, and text
 fields start with an I-beam cursor. All other windows are created
 without a cursor.}
  如果窗口没有光标，则使用其父窗口的光标。框架和对话框以标准箭头光标开始，文本字段以工字梁光标开始。所有其他窗口都是在没有光标的情况下创建的。

}


@defmethod[(set-label [l label-string?])
           void?]{

@;{Sets a window's label. The window's natural minimum size might be
 different after the label is changed, but the window's minimum size
 is not recomputed.}
  设置窗口标签。更改标签后，窗口的自然最小大小可能不同，但不会重新计算窗口的最小大小。

@;{If the window was not created with a label, or if the window was
 created with a non-string label, @racket[l] is ignored.}
  如果窗口不是用标签创建的，或者窗口是用非字符串标签创建的，则忽略@racket[l]。

@;{See
@method[window<%> get-label] for more information.}
  有关详细信息，请参见@method[window<%> get-label]。

}

@defmethod[(show [show? any/c])
           void?]{

@;{Shows or hides a window.}
  显示或隐藏窗口。

@;{@MonitorMethod[@elem{The visibility of a window} @elem{the user clicking the window's close box, for example} @elem{@method[window<%> on-superwindow-show] or @method[top-level-window<%> on-close]} @elem{visibility}]}
  @MonitorMethod[@elem{窗口的可见性} @elem{用户单击窗口的关闭框， 例如} @elem{@method[window<%> on-superwindow-show]或@method[top-level-window<%> on-close]} @elem{可见性}]

@;{If @racket[show?] is @racket[#f], the window is hidden. Otherwise, the
window is shown.}
  如果@racket[show?]是@racket[#f]，窗口是隐藏的。否则，将显示窗口。

}

@defmethod[(warp-pointer [x position-integer?]
                         [y position-integer?])
           void?]{
@;{Moves the cursor to the given location in the window's local coordinates.}
  将光标移动到窗口局部坐标中的给定位置。

}

}

