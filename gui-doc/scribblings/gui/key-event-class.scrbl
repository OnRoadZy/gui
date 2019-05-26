#lang scribble/doc
@(require "common.rkt")

@defclass/title[key-event% event% ()]{

@;{A @racket[key-event%] object contains information about a key press
or release event. Key events are primarily processed by
@xmethod[window<%> on-subwindow-char] and
@xmethod[canvas<%> on-char].}
 @racket[key-event%]对象包含有关按键或释放事件的信息。关键字事件主要由@xmethod[window<%> on-subwindow-char]和@xmethod[canvas<%> on-char]处理。 

@;{For a key-press event, a virtual key code is provided by
@method[key-event% get-key-code]. For a key-release event, 
@method[key-event% get-key-code] reports @racket['release], and a virtual key code is provided by
@method[key-event% get-key-release-code].}
  对于按键事件，由@method[key-event% get-key-code]提供虚拟按键代码。对于键释放事件，@method[key-event% get-key-code]报告@racket['release]，@method[key-event% get-key-release-code]提供虚拟键代码。

@;{See also @|mousekeydiscuss|.}
 另见@|mousekeydiscuss|。


@defconstructor[([key-code (or/c char? key-code-symbol?) #\nul]
                 [shift-down any/c #f]
                 [control-down any/c #f]
                 [meta-down any/c #f]
                 [alt-down any/c #f]
                 [x exact-integer? 0]
                 [y exact-integer? 0]
                 [time-stamp exact-integer? 0]
                 [caps-down any/c #f]
                 [mod3-down any/c #f]
                 [mod4-down any/c #f]
                 [mod5-down any/c #f]
                 [control+meta-is-altgr any/c #f])]{

@;{See the corresponding @racketidfont{get-} and @racketidfont{set-}
 methods for information about @racket[key-code], @racket[shift-down],
 @racket[control-down], @racket[meta-down], @racket[mod3-down], @racket[mod4-down],
 @racket[mod5-down], @racket[alt-down], @racket[x], @racket[y], 
 @racket[time-stamp], @racket[caps-down], @racket[mod3-down],
 @racket[mod4-down], @racket[mod5-down], and @racket[control+meta-is-altgr].}
  参见相应的@racketidfont{get-}和@racketidfont{set-}方法以获取有关@racket[key-code]、@racket[shift-down]、
 @racket[control-down]、@racket[meta-down]、@racket[mod3-down]、 @racket[mod4-down]、
 @racket[mod5-down]、@racket[alt-down]、@racket[x]、@racket[y]、
 @racket[time-stamp]、@racket[caps-down]、@racket[mod3-down]、 @racket[mod4-down]、@racket[mod5-down]以及@racket[control+meta-is-altgr]的信息。

@;{The release key code, as returned by @method[key-event%
get-key-release-code], is initialized to @racket['press].}
  由@method[key-event%
get-key-release-code]返回的释放键代码初始化为@racket['press]。

@;{@history[#:changed "1.1" @elem{Added @racket[mod3-down], @racket[mod4-down], and @racket[mod5-down].}
         #:changed "1.2" @elem{Added @racket[control+meta-is-altgr].}]}
  @history[#:changed "1.1" @elem{添加@racket[mod3-down]、@racket[mod4-down]和@racket[mod5-down]。}
         #:changed "1.2" @elem{添加@racket[control+meta-is-altgr]。}]
}

@defmethod[(get-alt-down)
           boolean?]{
Returns @racket[#t] if the Option (Mac OS) key was down for
 the event. When the Alt key is pressed in Windows, it is reported as
 a Meta press (see
@method[key-event% get-meta-down]).
如果事件的Option键（Mac OS）按下，则返回@racket[#t]。在Windows中按下Alt键时，将报告为Meta按下（请参阅@method[key-event% get-meta-down]）。
}

@defmethod[(get-caps-down)
           boolean?]{
@;{Returns @racket[#t] if the Caps Lock key was on for the event.}
  如果事件的Caps Lock键处于松开状态，则返回@racket[#t]。

}

@defmethod[(get-control-down)
           boolean?]{
@;{Returns @racket[#t] if the Control key was down for the event.}
如果事件的Control键已按下，则返回@racket[#t]。

@;{On Mac OS, if a Control-key press is combined with a mouse button
 click, the event is reported as a right-button click and
@method[key-event% get-control-down] for the event reports @racket[#f].}
  在Mac OS上，如果按下Control键并单击鼠标按钮，则事件将报告为右键单击同时事件的@method[key-event% get-control-down]报告@racket[#f]。

}


@defmethod[(get-control+meta-is-altgr)
           boolean?]{

@;{Returns @racket[#t] if a Control plus Meta event should be treated as
an AltGr event on Windows. By default, AltGr treatment applies if the
Control key was the left one and the Alt key (as Meta) was the right one---typed
that way on a keyboard with a right Alt key, or produced by a single
AltGr key. See also @racket[any-control+alt-is-altgr], which controls
whether other Control plus Alt combinations are treated as AltGr.}
  如果Control+Meta事件应在Windows上被视为AltGr事件，则返回@racket[#t]。默认情况下，如果Control键是左键，而Alt键(作为Meta)是右键，则AltGr对待请求——用右Alt键在键盘上以这种方式键入，或者由单个AltGr键生成。另请参见@racket[any-control+alt-is-altgr]，它控制其他Control+Alt组合是否被视为AltGr。

@history[#:added "1.2"]}


@defmethod[(get-key-code)
           (or/c char? key-code-symbol?)]{

@;{Gets the virtual key code for the key event. The virtual key code is
 either a character or a special key symbol, one of the following:}
  取得键盘事件的虚拟键代码。虚拟键代码或者是一个字符或者是一个特殊键符号，或者是下面的其中一个:

@itemize[
#:style 'compact
@item{@indexed-racket['start]}
@item{@indexed-racket['cancel]}
@item{@indexed-racket['clear]}
@item{@indexed-racket['shift]@;{ --- Shift key}——Shift键}
@item{@indexed-racket['rshift]@;{ --- right Shift key}——右Shift键}
@item{@indexed-racket['control]@;{ --- Control key}——Control键}
@item{@indexed-racket['rcontrol]@;{ --- right Control key}——右Control键}
@item{@indexed-racket['menu]}
@item{@indexed-racket['pause]}
@item{@indexed-racket['capital]}
@item{@indexed-racket['prior]}
@item{@indexed-racket['next]}
@item{@indexed-racket['end]}
@item{@indexed-racket['home]}
@item{@indexed-racket['left]}
@item{@indexed-racket['up]}
@item{@indexed-racket['right]}
@item{@indexed-racket['down]}
@item{@indexed-racket['escape]}
@item{@indexed-racket['select]}
@item{@indexed-racket['print]}
@item{@indexed-racket['execute]}
@item{@indexed-racket['snapshot]}
@item{@indexed-racket['insert]}
@item{@indexed-racket['help]}
@item{@indexed-racket['numpad0]}
@item{@indexed-racket['numpad1]}
@item{@indexed-racket['numpad2]}
@item{@indexed-racket['numpad3]}
@item{@indexed-racket['numpad4]}
@item{@indexed-racket['numpad5]}
@item{@indexed-racket['numpad6]}
@item{@indexed-racket['numpad7]}
@item{@indexed-racket['numpad8]}
@item{@indexed-racket['numpad9]}
@item{@indexed-racket['numpad-enter]}
@item{@indexed-racket['multiply]}
@item{@indexed-racket['add]}
@item{@indexed-racket['separator]}
@item{@indexed-racket['subtract]}
@item{@indexed-racket['decimal]}
@item{@indexed-racket['divide]}
@item{@indexed-racket['f1]}
@item{@indexed-racket['f2]}
@item{@indexed-racket['f3]}
@item{@indexed-racket['f4]}
@item{@indexed-racket['f5]}
@item{@indexed-racket['f6]}
@item{@indexed-racket['f7]}
@item{@indexed-racket['f8]}
@item{@indexed-racket['f9]}
@item{@indexed-racket['f10]}
@item{@indexed-racket['f11]}
@item{@indexed-racket['f12]}
@item{@indexed-racket['f13]}
@item{@indexed-racket['f14]}
@item{@indexed-racket['f15]}
@item{@indexed-racket['f16]}
@item{@indexed-racket['f17]}
@item{@indexed-racket['f18]}
@item{@indexed-racket['f19]}
@item{@indexed-racket['f20]}
@item{@indexed-racket['f21]}
@item{@indexed-racket['f22]}
@item{@indexed-racket['f23]}
@item{@indexed-racket['f24]}
@item{@indexed-racket['numlock]}
@item{@indexed-racket['scroll]}
@item{@indexed-racket['wheel-up]@;{ --- @index["wheel on mouse"]{mouse} wheel up one notch}——@index["wheel on mouse"]{鼠标}滚轮释放的一个键}
@item{@indexed-racket['wheel-down]@;{ --- mouse wheel down one notch}——鼠标滚轮按下一个键}
@item{@indexed-racket['wheel-left]@;{ --- mouse wheel left one notch}——鼠标滚轮左边键}
@item{@indexed-racket['wheel-right]@;{ --- mouse wheel right one notch}——鼠标滚轮右边档}
@item{@indexed-racket['release]@;{ --- indicates a key-release event}——表明一个键释放事件}
@item{@indexed-racket['press]@;{ --- indicates a key-press event; usually only from @racket[get-key-release-code]}——表明一个键按下事件；通常仅来自@racket[get-key-release-code]}
]

@;{The special key symbols attempt to capture useful keys that have no
 standard ASCII representation. A few keys have standard
 representations that are not obvious:}
指定的键符号试图去捕捉有用的键，它没有标准的ASCII表示。有几个键有不明显的标准表示。

@itemize[

 @item{@racket[#\space]@;{ --- the space bar}——空格键}

 @item{@racket[#\return]@;{ --- the Enter or Return key (on all
      platforms), but not necessarily the Enter key near the numpad
      (which is reported as @racket['numpad-enter] Unix and Mac OS)}——Enter或Return键（在所有平台上），但不一定是数字键盘的Enter键（Unix和Mac OS报告为@racket['numpad-enter]）}

 @item{@racket[#\tab]@;{ --- the tab key}——tab键}

 @item{@racket[#\backspace]@;{ --- the backspace key}——回退（backspace）键}

 @item{@racket[#\rubout]@;{ --- the delete key}——删除（delete）键}

]

@;{If a suitable special key symbol or ASCII representation is not
 available, @racket[#\nul] (the NUL character) is reported.}
  如果没有合适的指定键符号或ASCII表示，则会报告@racket[#\nul](NUL字符)。

@;{A @racket['wheel-up], @racket['wheel-down], @racket['wheel-left], or
 @racket['wheel-right] event may be sent to a window other than the
 one with the keyboard focus, because some platforms generate wheel
 events based on the location of the mouse pointer instead of the
 keyboard focus.}
  @racket['wheel-up]、@racket['wheel-down]、@racket['wheel-left]或@racket['wheel-right]事件可以发送到键盘焦点所在窗口以外的其他窗口，因为某些平台会根据鼠标指针的位置而不是键盘焦点生成滚轮事件。

@;{On Windows, when the Control key is pressed without Alt, the key
 code for ASCII characters is downcased, roughly cancelling the effect
 of the Shift key. On Mac OS, the key code is computed without
 Caps Lock effects when the Control or Command key is pressed; in the
 case of Control, Caps Lock is used normally if special handling is
 disabled for the Control key via @racket[special-control-key]. On
 Unix, the key code is computed with Caps Lock effects when the Control
 key is pressed without Alt.}
  在Windows上，当在不使用Alt的情况下按下Control键时，ASCII字符的键代码是小写的，大致取消了Shift键的效果。在Mac OS上，当按下Control键或Command键时，键代码求值不受Caps Lock的影响；在Control情况下，如果通过@racket[special-control-key]禁用Control键的指定操作，通常使用Caps Lock。在Unix上，当在不使用Alt的情况下按下Control键时，使用键代码求值会受Caps Lock影响。

@;{See also @method[key-event% get-other-shift-key-code].}
 另请参见@method[key-event% get-other-shift-key-code]。 

@;{@history[#:changed "6.1.0.8" @elem{Changed reporting of numpad Enter
                                   to @racket['numpad-enter] as
                                   documented, instead of
                                   @racket[#\u03].}]}
  @history[#:changed "6.1.0.8" @elem{将数字键盘Enter的报告更改为文档化的@racket['numpad-enter]，而不是@racket[#\u03]。}]
 }


@defmethod[(get-key-release-code)
           (or/c char? key-code-symbol?)]{

@;{Gets the virtual key code for a key-release event; the result is
 @racket['press] for a key-press event. See @method[key-event%
 get-key-code] for the list of virtual key codes.}
  获取键释放事件的虚拟键代码；结果是一个键按下事件的@racket['press]。有关虚拟键代码的列表，请参见@method[key-event%
 get-key-code]。

}

@defmethod[(get-meta-down)
           boolean?]{

@;{Returns @racket[#t] if the Meta (Unix), Alt (Windows), or Command (Mac OS) key was down for the event.}
 如果事件的Meta（Unix）、Alt（Windows）或Command（Mac OS）键按下，则返回@racket[#t]。 

}

@defmethod[(get-mod3-down)
           boolean?]{

@;{Returns @racket[#t] if the Mod3 (Unix) key was down for the event.}
 如果事件的Mod3（Unix）键已关闭，则返回@racket[#t]。 

@history[#:added "1.1"]}

@defmethod[(get-mod4-down)
           boolean?]{

@;{Returns @racket[#t] if the Mod4 (Unix) key was down for the event.}
  如果事件的Mod4(Unix)键已关闭，则返回@racket[#t]。 

@history[#:added "1.1"]}

@defmethod[(get-mod5-down)
           boolean?]{

@;{Returns @racket[#t] if the Mod5 (Unix) key was down for the event.}
如果事件的Mod5(Unix)键已关闭，则返回@racket[#t]。

@history[#:added "1.1"]}

@defmethod[(get-other-altgr-key-code)
           (or/c char? key-code-symbol? #f)]{

@;{See @method[key-event% get-other-shift-key-code].}
  参见@method[key-event% get-other-shift-key-code]。

}

@defmethod[(get-other-caps-key-code)
           (or/c char? key-code-symbol? #f)]{

@;{See @method[key-event% get-other-shift-key-code].}
  参见@method[key-event% get-other-shift-key-code]。

}

@defmethod[(get-other-shift-altgr-key-code)
           (or/c char? key-code-symbol? #f)]{

@;{See @method[key-event% get-other-shift-key-code].}
  参见@method[key-event% get-other-shift-key-code]。

}

@defmethod[(get-other-shift-key-code)
           (or/c char? key-code-symbol? #f)]{

@;{Since keyboard mappings vary, it is sometimes useful in key mappings
 for a program to know the result that the keyboard would have
 produced for an event if the Shift key had been toggled
 differently. The @method[key-event% get-other-shift-key-code]
 produces that other mapping, returning @racket[#f] if the alternate
 mapping is unavailable, otherwise returning the same kind of result
 as @method[key-event% get-key-code].}
  由于键盘映射是不同的，所以有时在键映射中，要让程序知道如果移位键被不同地切换，键盘将为事件生成的结果是有用的。@method[key-event% get-other-shift-key-code]方法产生另一个映射，如果备用映射不可用，则返回@racket[#f]，否则返回与@method[key-event% get-key-code]相同的结果。

@;{The @method[key-event% get-other-altgr-key-code] method provides the
same information with respect to the AltGr key (i.e., Alt combined
with Control) on Windows and Unix, or the Option key on Mac OS. The @method[key-event% get-other-shift-altgr-key-code] method
reports a mapping for in tha case that both Shift and AltGr/Option
were different from the actual event.}
  @method[key-event% get-other-altgr-key-code]方法提供了与Windows和Unix上的AltGr键（即Alt与Control组合）或Mac OS上的Option键有关的相同信息。@method[key-event% get-other-shift-altgr-key-code]方法报告在Shift和AltGr/Option与实际事件不同的情况下的映射。

@;{The @method[key-event% get-other-shift-key-code], @method[key-event%
get-other-altgr-key-code], and @method[key-event%
get-other-shift-altgr-key-code] results all report key mappings where
Caps Lock is off, independent of whether Caps Lock was on for the
actual event. The @method[key-event% get-other-caps-key-code] method
reports a mapping for in that case that the Caps Lock state was
treated opposite as for the @method[key-event% get-key-code]
result. (Caps Lock normally has either no effect or the same effect as
Shift, so further combinations involving Caps Lock and other modifier
keys would not normally produce further alternatives.)}
 @method[key-event% get-other-shift-key-code]、@method[key-event%
get-other-altgr-key-code]和@method[key-event%
get-other-shift-altgr-key-code]结果所有报告的Caps Lock处于关闭状态的键映射，与实际事件的Caps Lock是否处于打开状态无关。@method[key-event% get-other-caps-key-code]方法报告的映射，在这种情况下，Caps Lock状态被视为@method[key-event% get-key-code]结果的相反状态。(Caps Lock通常不起作用，或者与Shift的效果相同，因此涉及Caps Lock和其他修改键的进一步组合通常不会产生更多的选择。) 

@;{Alternate mappings are not available for all events. On Windows,
 alternate mappings are reported when they produce ASCII letters,
 ASCII digits, and ASCII symbols. On Mac OS and Unix, alternate
 mappings are usually available.}
 备用映射不适用于所有事件。在Windows上，当生成ASCII字母、ASCII数字和ASCII符号时，会报告备用映射。在Mac OS和Unix上，通常可以使用备用映射。 

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
  返回事件发生时目标窗口(工作区)坐标系中鼠标的X位置。

}

@defmethod[(get-y)
           exact-integer?]{

@;{Returns the y-position of the mouse at the time of the event in the
 target's window's (client-area) coordinate system.}
  返回事件发生时目标窗口(工作区)坐标系中鼠标的Y位置。

}

@defmethod[(set-alt-down [down? any/c])
           void?]{

@;{Sets whether the Option (Mac OS) key was down for the event.  When
 the Alt key is pressed in Windows, it is reported as a Meta press
 (see @method[key-event% set-meta-down]).}
  设置事件的Option（Mac OS）键是否已按下。当在Windows中按下Alt键时，它被报告为Meta键按下（请参见@method[key-event% set-meta-down]）。

}

@defmethod[(set-caps-down [down? any/c])
           void?]{

@;{Sets whether the Caps Lock key was on for the event.}
  设置事件的Caps Lock键是否放开。

}

@defmethod[(set-control-down [down? any/c])
           void?]{

@;{Sets whether the Control key was down for the event.}
设置事件的Control键是否按下。
  
@;{On Mac OS, if a control-key press is combined with a mouse button
 click, the event is reported as a right-button click and
 @method[key-event% get-control-down] for the event reports
 @racket[#f].}
在Mac OS上，如果按下控制键并单击鼠标按钮，则事件将报告为右键单击并且事件报告的@method[key-event% get-control-down]为@racket[#f]。
  
}

@defmethod[(set-control+meta-is-altgr [down? any/c])
           void?]{

@;{Sets whether a Control plus Meta combination on Windows should be
treated as an AltGr combinations. See @method[key-event% get-control+meta-is-altgr].}
  设置是否应将Windows上的Control+Meta组合视为Altgr组合。请参见@method[key-event% get-control+meta-is-altgr]。

@history[#:added "1.2"]}


@defmethod[(set-key-code [code (or/c char? key-code-symbol?)])
           void?]{

@;{Sets the virtual key code for the event, either a character or one of
 the special symbols listed with @method[key-event% get-key-code].}
  设置事件的虚拟键码，可以是一个字符，也可以是与@method[key-event% get-key-code]一起列出的一个特殊符号。 

}

@defmethod[(set-key-release-code [code (or/c char? key-code-symbol?)])
           void?]{

@;{Sets the virtual key code for a release event, either a character or
 one of the special symbols listed with @method[key-event%
 get-key-code]. See also @method[key-event% get-key-release-code].}
  为发布事件设置虚拟键代码，可以是一个字符，也可以是与@method[key-event%
 get-key-code]一起列出的一个特殊符号。另请参见@method[key-event% get-key-release-code]。

}

@defmethod[(set-meta-down [down? any/c])
           void?]{

@;{Sets whether the Meta (Unix), Alt (Windows), or Command (Mac OS) key
 was down for the event.}
  设置事件的Meta（Unix）、Alt(Windows）或Command（Mac OS）键是否按下。

}

@defmethod[(set-mod3-down [down? any/c])
           void?]{

@;{Sets whether the Mod3 (Unix) key was down for the event.}
  设置事件的Mod3（Unix）键是否按下。

@history[#:added "1.1"]}

@defmethod[(set-mod4-down [down? any/c])
           void?]{

@;{Sets whether the Mod4 (Unix) key was down for the event.}
  设置事件的Mod4(Unix)键是否按下。

@history[#:added "1.1"]}

@defmethod[(set-mod5-down [down? any/c])
           void?]{

@;{Sets whether the Mod5 (Unix) key was down for the event.}
  设置事件的Mod5(Unix)键是否按下。

@history[#:added "1.1"]}

@defmethod[(set-other-altgr-key-code [code (or/c char? key-code-symbol? #f)])
           void?]{

@;{Sets the key code produced by @method[key-event%
get-other-altgr-key-code].}
  设置由@method[key-event%
get-other-altgr-key-code]产生的键代码。

}

@defmethod[(set-other-caps-key-code [code (or/c char? key-code-symbol? #f)])
           void?]{

@;{Sets the key code produced by @method[key-event%
 get-other-caps-key-code].}
  设置由@method[key-event%
 get-other-caps-key-code]产生的键代码。

}

@defmethod[(set-other-shift-altgr-key-code [code (or/c char? key-code-symbol? #f)])
           void?]{

@;{Sets the key code produced by @method[key-event%
 get-other-shift-altgr-key-code].}
  设置由@method[key-event%
 get-other-shift-altgr-key-code]产生的键代码。

}

@defmethod[(set-other-shift-key-code [code (or/c char? key-code-symbol? #f)])
           void?]{

@;{Sets the key code produced by @method[key-event%
 get-other-shift-key-code].}
  设置由@method[key-event%
 get-other-shift-key-code]产生的键代码。

}

@defmethod[(set-shift-down [down? any/c])
           void?]{

@;{Sets whether the Shift key was down for the event.}
  设置事件的Shift键是否按下。

}

@defmethod[(set-x [pos exact-integer?])
           void?]{

@;{Sets the x-position of the mouse at the time of the event in the
 target's window's (client-area) coordinate system.}
设置事件发生时目标窗口(工作区)坐标系中鼠标的X位置。
}

@defmethod[(set-y [pos exact-integer?])
           void?]{

@;{Sets the y-position of the mouse at the time of the event in the
 target's window's  (client-area) coordinate system.}
设置事件发生时目标窗口(工作区)坐标系中鼠标的Y位置。
}
}

