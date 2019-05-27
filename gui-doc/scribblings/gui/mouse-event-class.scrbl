#lang scribble/doc
@(require "common.rkt")

@defclass/title[mouse-event% event% ()]{

@;{A @racket[mouse-event%] object encapsulates a mouse event.
 Mouse events are primarily processed by
@xmethod[window<%> on-subwindow-event] and
@xmethod[canvas<%> on-event].}
  @racket[mouse-event%]对象封装鼠标事件。鼠标事件主要由@xmethod[window<%> on-subwindow-event]和@xmethod[canvas<%> on-event]处理。

@;{See also @|mousekeydiscuss|.}
另参见@|mousekeydiscuss|。

@defconstructor[([event-type (or/c 'enter 'leave 'left-down 'left-up 
                                   'middle-down 'middle-up 
                                   'right-down 'right-up 'motion)]
                 [left-down any/c #f]
                 [middle-down any/c #f]
                 [right-down any/c #f]
                 [x exact-integer? 0]
                 [y exact-integer? 0]
                 [shift-down any/c #f]
                 [control-down any/c #f]
                 [meta-down any/c #f]
                 [alt-down any/c #f]
                 [time-stamp exact-integer? 0]
                 [caps-down any/c #f]
                 [mod3-down any/c #f]
                 [mod4-down any/c #f]
                 [mod5-down any/c #f])]{

@;{Creates a mouse event for a particular type of event. The event types
 are:}
  为特定类型的事件创建鼠标事件。事件类型为：

@itemize[
@item{@racket['enter]@;{ --- mouse pointer entered the window}——鼠标指针进入窗口}
@item{@racket['leave]@;{ --- mouse pointer left the window}——鼠标指针离开窗口}
@item{@racket['left-down]@;{ --- left mouse button pressed}——按下鼠标左键}
@item{@racket['left-up]@;{ --- left mouse button released}——释放鼠标左键}
@item{@racket['middle-down]@;{ --- middle mouse button pressed}——按下鼠标中键}
@item{@racket['middle-up]@;{ --- middle mouse button released}——释放鼠标中键}
@item{@racket['right-down]@;{ --- right mouse button pressed (Mac OS: click with control key pressed)}——按下鼠标右键（Mac OS：按下控制键单击）}
@item{@racket['right-up]@;{ --- right mouse button released (Mac OS: release with control key pressed)}——释放鼠标右键（Mac OS：按下控制键释放）}
@item{@racket['motion]@;{ --- mouse moved, with or without button(s) pressed}——鼠标移动，按下或不按下按钮}
]

@;{See the corresponding @racketidfont{get-} and @racketidfont{set-}
 methods for information about @racket[left-down],
 @racket[middle-down], @racket[right-down], @racket[x], @racket[y],
 @racket[shift-down], @racket[control-down], @racket[meta-down],
 @racket[alt-down], @racket[time-stamp], @racket[caps-down], @racket[mod3-down],
 @racket[mod4-down], and @racket[mod5-down].}
  有关@racket[left-down]、@racket[middle-down]、@racket[right-down]、@racket[x]、@racket[y]、@racket[shift-down]、@racket[control-down]、@racket[meta-down]、@racket[alt-down]、@racket[time-stamp]、@racket[caps-down]、@racket[mod3-down]、@racket[mod4-down]和@racket[mod5-down]的信息，请参见相应的@racketidfont{get-}和@racketidfont{set-}方法。

@;{@history[#:changed "1.1" @elem{Added @racket[mod3-down], @racket[mod4-down], and @racket[mod5-down].}]}
  @history[#:changed "1.1" @elem{添加@racket[mod3-down]、@racket[mod4-down]和@racket[mod5-down]。}]
}

@defmethod[(button-changed? [button (or/c 'left 'middle 'right 'any) 'any])
           boolean?]{

@;{Returns @racket[#t] if this was a mouse button press or release event,
 @racket[#f] otherwise. See also
@method[mouse-event% button-up?] and
@method[mouse-event% button-down?].}
  如果这是鼠标按钮按下或释放事件，则返回@racket[#t]，否则返回@racket[#f]。另见@method[mouse-event% button-up?]和@method[mouse-event% button-down?]。

@;{If @racket[button] is not @racket['any], then @racket[#t] is only returned
 if it is a release event for a specific button.}
  如果@racket[button]不是@racket['any]，则仅当它是特定按钮的释放事件时才返回@racket[#t]。

}

@defmethod[(button-down? [button (or/c 'left 'middle 'right 'any) 'any])
           boolean?]{

@;{Returns @racket[#t] if the event is for a button press, @racket[#f]
 otherwise.}
  如果事件是按钮按下，则返回@racket[#t]，否则返回@racket[#f]。

@;{If @racket[button] is not @racket['any], then @racket[#t] is only returned
 if it is a press event for a specific button.}
  如果@racket[button]不是@racket['any]，则仅当它是特定按钮的按下事件时才返回@racket[#t]。

}

@defmethod[(button-up? [button (or/c 'left 'middle 'right 'any) 'any])
           boolean?]{

@;{Returns @racket[#t] if the event is for a button release, @racket[#f]
 otherwise. (As noted in @|mousekeydiscuss|, button release events are
 sometimes dropped.)}
如果事件用于按钮释放，则返回@racket[#t]，否则返回@racket[#f]。（如@|mousekeydiscuss|中所述，按钮释放事件有时会丢失。）
  
@;{If @racket[button] is not @racket['any], then @racket[#t] is only returned
 if it is a release event for a specific button.}
  如果@racket[button]不是@racket['any]，则仅当它是特定按钮的释放事件时才返回@racket[#t]。

}

@defmethod[(dragging?)
           boolean?]{

@;{Returns @racket[#t] if this was a dragging event (motion while a button
 is pressed), @racket[#f] otherwise.}
  如果这是拖动事件（按下按钮时的运动），则返回@racket[#t]，否则返回@racket[#f]。

}

@defmethod[(entering?)
           boolean?]{

@;{Returns @racket[#t] if this event is for the mouse entering a window,
 @racket[#f] otherwise.}
如果此事件用于鼠标进入窗口，则返回@racket[#t]，否则返回@racket[#f]。
  
@;{When the mouse button is up, an enter/leave event notifies a window
 that it will start/stop receiving mouse events. When the mouse button
 is down, however, the window receiving the mouse-down event receives
 all mouse events until the button is released; enter/leave events are
 not sent to other windows, and are not reliably delivered to the
 click-handling window (since the window can detect movement out of
 its region via @method[mouse-event% get-x] and @method[mouse-event%
 get-y]). See also @|mousekeydiscuss|.}
  当鼠标按钮启动时，进入/离开事件通知窗口它将开始/停止接收鼠标事件。但是，当鼠标按钮按下时，接收鼠标按下事件的窗口将接收所有鼠标事件，直到释放按钮为止；进入/离开事件不会发送到其他窗口，也不会可靠地传递到点击处理窗口（因为窗口可以通过@method[mouse-event% get-x]和@method[mouse-event%
 get-y]检测出其区域外的移动）。另见@|mousekeydiscuss|。

}


@defmethod[(get-alt-down)
           boolean?]{

@;{Returns @racket[#t] if the Option (Mac OS) key was down for the
 event. When the Alt key is pressed in Windows, it is reported as a
 Meta press (see @method[mouse-event% get-meta-down]).}
  如果事件的Option键（Mac OS）已按下，则返回@racket[#t]。在Windows中按下Alt键时，将报告为Meta键按下（请参阅@method[mouse-event% get-meta-down]）。

}

@defmethod[(get-caps-down)
           boolean?]{

@;{Returns @racket[#t] if the Caps Lock key was on for the event.}
  如果事件的Caps Lock键处于打开状态，则返回@racket[#t]。

}

@defmethod[(get-control-down)
           boolean?]{

@;{Returns @racket[#t] if the Control key was down for the event.}
  如果事件的Control键已按下，则返回@racket[#t]。

@;{On Mac OS, if a control-key press is combined with a mouse button
 click, the event is reported as a right-button click and
 @method[mouse-event% get-control-down] for the event reports
 @racket[#f].}
  在Mac OS上，如果按下控制键并单击鼠标按钮，则事件将报告为右键单击，并且事件报告的@method[mouse-event% get-control-down]为@racket[#f]。

}

@defmethod[(get-event-type)
           (or/c 'enter 'leave 'left-down 'left-up 
                 'middle-down 'middle-up 
                 'right-down 'right-up 'motion)]{

@;{Returns the type of the event; see @racket[mouse-event%] for
information about each event type. See also @method[mouse-event%
set-event-type].}
  返回事件类型；有关每个事件类型的信息，请参阅@racket[mouse-event%]。另请参见@method[mouse-event%
set-event-type]。

}

@defmethod[(get-left-down)
           boolean?]{
@;{Returns @racket[#t] if the left mouse button was down (but not pressed) during the event.}
  如果在事件期间鼠标左键按下（但未接受），则返回@racket[#t]。

}

@defmethod[(get-meta-down)
           boolean?]{

@;{Returns @racket[#t] if the Meta (Unix), Alt (Windows), or Command (Mac OS) key was down for the event.}
  如果事件的Meta（unix）、Alt（windows）或Command（mac os）键按下，则返回@racket[#t]。

}

@defmethod[(get-middle-down)
           boolean?]{

@;{Returns @racket[#t] if the middle mouse button was down (but not
 pressed) for the event.  On Mac OS, a middle-button click is
 impossible.}
  如果事件的鼠标中键已按下（但未接受），则返回@racket[#t]。在Mac OS上，点击鼠标中键是不可能的。

}

@defmethod[(get-mod3-down)
           boolean?]{

@;{Returns @racket[#t] if the Mod3 (Unix) key was down for the event.}
  如果事件的Mod3（unix）键已按下，则返回@racket[#t]。

@history[#:added "1.1"]}

@defmethod[(get-mod4-down)
           boolean?]{

@;{Returns @racket[#t] if the Mod4 (Unix) key was down for the event.}
如果事件的Mod4（unix）键已按下，则返回@racket[#t]。

@history[#:added "1.1"]}

@defmethod[(get-mod5-down)
           boolean?]{

@;{Returns @racket[#t] if the Mod5 (Unix) key was down for the event.}
  如果事件的Mod5（unix）键已按下，则返回@racket[#t]。

@history[#:added "1.1"]}

@defmethod[(get-right-down)
           boolean?]{

@;{Returns @racket[#t] if the right mouse button was down (but not
 pressed) for the event. On Mac OS, a control-click combination
 is treated as a right-button click.}
  如果事件的鼠标右键已按下（但未接受），则返回@racket[#t]。在Mac OS上，控件单击组合被视为右键单击。

}

@defmethod[(get-shift-down)
           boolean?]{

@;{Returns @racket[#t] if the Shift key was down for the event.}
  如果事件的Shift键已按下，则返回@racket[#t]。

}

@defmethod[(get-x)
           exact-integer?]{

@;{Returns the x-position of the mouse at the time of the event, in the
 target's window's (client-area) coordinate system.}
  返回事件发生时鼠标在目标窗口（工作区）坐标系中的X位置。

}

@defmethod[(get-y)
           exact-integer?]{

@;{Returns the y-position of the mouse at the time of the event in the
 target's window's (client-area) coordinate system.}
  返回事件发生时鼠标在目标窗口（工作区）坐标系中的Y位置。

}

@defmethod[(leaving?)
           boolean?]{

@;{Returns @racket[#t] if this event is for the mouse leaving a window,
 @racket[#f] otherwise.}
  如果此事件是因为鼠标离开窗口，则返回@racket[#t]，否则返回[#f]。

@;{See @method[mouse-event% entering?] for information about enter and
leave events while the mouse button is clicked.}
  有关单击鼠标按钮时进入和离开事件的信息,参见@method[mouse-event% entering?]。

}

@defmethod[(moving?)
           boolean?]{

@;{Returns @racket[#t] if this was a moving event (whether a button is
 pressed is not), @racket[#f] otherwise.}
  如果这是一个移动事件（不管是否按下按钮），则返回@racket[#t]，否则返回@racket[#f]。
}


@defmethod[(set-alt-down [down? any/c])
           void?]{

@;{Sets whether the Option (Mac OS) key was down for the event.  When
 the Alt key is pressed in Windows, it is reported as a Meta press
 (see @method[mouse-event% set-meta-down]).}
  设置事件的Option键（Mac OS）是否按下。当在Windows中按下Alt键时，它被报告为Meta键按下（请参见@method[mouse-event% set-meta-down]）。

}

@defmethod[(set-caps-down [down? any/c])
           void?]{

@;{Sets whether the Caps Lock key was on for the event.}
  设置事件的Caps Lock键是否松开。

}

@defmethod[(set-control-down [down? any/c])
           void?]{

@;{Sets whether the Control key was down for the event.}
  设置事件的Control键是否按下。

@;{On Mac OS, if a control-key press is combined with a mouse button
 click, the event is reported as a right-button click and
 @method[mouse-event% get-control-down] for the event reports
 @racket[#f].}
  在Mac OS上，如果按下控制键并单击鼠标按钮，则事件将报告为右键单击，并且事件报告的@method[mouse-event% get-control-down]为@racket[#f]。

}

@defmethod[(set-event-type [event-type (or/c 'enter 'leave 'left-down 'left-up 
                                             'middle-down 'middle-up 
                                             'right-down 'right-up 'motion)])
           void?]{

@;{Sets the type of the event; see @racket[mouse-event%] for information
about each event type. See also @method[mouse-event% get-event-type].}
  设置事件类型；有关每个事件类型的信息，请参阅@racket[mouse-event%]。另请参见@method[mouse-event% get-event-type]。

}

@defmethod[(set-left-down [down? any/c])
           void?]{

@;{Sets whether the left mouse button was down (but not pressed) during
the event.}
  设置事件期间鼠标左键是否按下（但未接受）。

}

@defmethod[(set-meta-down [down? any/c])
           void?]{

@;{Sets whether the Meta (Unix), Alt (Windows), or Command (Mac OS) key
 was down for the event.}
  设置事件的Meta（unix）、Alt（windows）或Command（mac os）键是否已按下。

}

@defmethod[(set-middle-down [down? any/c])
           void?]{

@;{Sets whether the middle mouse button was down (but not pressed) for
 the event.  On Mac OS, a middle-button click is impossible.}
  设置事件的鼠标中键是否已按下（但未接受）。在Mac OS上，点击鼠标中键是不可能的。

}

@defmethod[(set-mod3-down [down? any/c])
           void?]{

@;{Sets whether the Mod3 (Unix) key was down for the event.}
  设置事件的Mod3（unix）键是否已按下。

@history[#:added "1.1"]}

@defmethod[(set-mod4-down [down? any/c])
           void?]{

@;{Sets whether the Mod4 (Unix) key was down for the event.}
  设置事件的Mod4（unix）键是否已按下。

@history[#:added "1.1"]}

@defmethod[(set-mod5-down [down? any/c])
           void?]{

@;{Sets whether the Mod5 (Unix) key was down for the event.}
  设置事件的Mod5（unix）键是否已按下。

@history[#:added "1.1"]}

@defmethod[(set-right-down [down? any/c])
           void?]{

@;{Sets whether the right mouse button was down (but not pressed) for the
 event. On Mac OS, a control-click combination by the user is
 treated as a right-button click.}
  设置事件的鼠标右键是否已按下（但未接受）。在Mac OS上，用户的控件单击组合被视为右键单击。

}

@defmethod[(set-shift-down [down? any/c])
           void?]{

@;{Sets whether the Shift key was down for the event.}
  设置事件的Shift键是否已按下。

}

@defmethod[(set-x [pos exact-integer?])
           void?]{

@;{Sets the x-position of the mouse at the time of the event in the
 target's window's (client-area) coordinate system.}
  在目标窗口（工作区）坐标系中设置事件发生时鼠标的X位置。

}

@defmethod[(set-y [pos exact-integer?])
           void?]{

@;{Sets the y-position of the mouse at the time of the event in the
 target's window's (client-area) coordinate system.}
  在目标窗口（工作区）坐标系中设置事件发生时鼠标的Y位置。

}}

