#lang scribble/doc
@(require "common.rkt")

@defclass/title[keymap% object% ()]{

@;{A @racket[keymap%] object is used by @racket[editor<%>] objects to
 map keyboard and mouse sequences to arbitrary functions in an
 extensible way. Keymaps can be used without editors, as well.  A
 @racket[keymap%] object contains}
@racket[editor<%>]对象使用@racket[keymap%]对象以可扩展的方式将键盘和鼠标序列映射到任意函数。也可以在没有编辑器的情况下使用键映射。@racket[keymap%]对象包含
  
@itemize[

 @item{@;{a mapping from function names to event-handling procedures; and}
         从函数名到事件处理过程的映射；以及}

 @item{@;{a mapping from key and mouse sequences to function names.}
         从键和鼠标序列到函数名的映射。}

]

@;{A handler procedure in a keymap is invoked with a @racket[key-event%]
 object or a @racket[mouse-event%] object. It is also given another
 value that depends on the context in which the keymap is used (or,
 more specifically, the arguments to @method[keymap% handle-key-event]
 or @method[keymap% handle-mouse-event]). For keymaps associated with
 @racket[editor<%>] objects, the extra parameter is generally the
 @racket[editor<%>] object that received the keyboard or mouse event.}
  使用@racket[key-event%]对象或@racket[mouse-event%]对象调用键映射中的处理程序过程。它还提供了另一个值，该值取决于使用键映射的上下文（或者更具体地说，是@method[keymap% handle-key-event]或@method[keymap% handle-mouse-event]的参数）。对于与@racket[editor<%>]对象关联的键映射，额外参数通常是接收键盘或鼠标事件的@racket[editor<%>]对象。

@defconstructor[()]{

@;{Creates an empty keymap.}
  创建空的键映射。

}

@defmethod[(add-function [name string?]
                         [func (any/c (is-a?/c event%) . -> . any)])
           void?]{

@;{Names a new function to handle events, called in response to
 @method[keymap% handle-key-event], @method[keymap%
 handle-mouse-event], or @method[keymap% call-function]. The return
 value is of the procedure is ignored.}
  命名一个新的函数来处理事件、响应@method[keymap% handle-key-event]、@method[keymap% handle-key-event]或@method[keymap% call-function]。返回值是过程被忽略。


@;{If there was already a function mapped to this name, it will be
 replaced with the given function.}
  如果已经有一个函数映射到此名称，它将被替换为给定的函数。

@;{When the function is called, it gets the arguments that were passed to
 @method[keymap% handle-key-event], @method[keymap%
 handle-mouse-event], or @method[keymap% call-function]. For keymaps
 associated with an editor, this is normally the target editor.}
  调用函数时，它获取传递给@method[keymap% handle-key-event]、@method[keymap%
 handle-mouse-event]或@method[keymap% call-function]的参数。对于与编辑器关联的键映射，这通常是目标编辑器。

}

@defmethod[(is-function-added? [fname string?]) boolean?]{
@;{  Returns @racket[#t] if @racket[fname] has been added
          via @method[add-function keymap%] to this keymap 
          and @racket[#f] otherwise.}
  如果已通过@method[add-function keymap%]将@racket[fname]添加到此键映射，则返回@racket[#t]，否则返回@racket[#f]。

  @;{This method doesn't check chained keymaps to see if the function
  has been added to one of those.}
   此方法不检查链接的键映射，以查看是否已将函数添加到其中之一。
 
}

@defmethod[(break-sequence)
           void?]{

@;{Clears the state of the keymap if it is in the middle of a key
 sequence. For example, the user may have hit escape, and then changed
 to another window; if escape is part of a keyboard sequence, the
 keymap state needs to be cleared because the user is not going to
 complete the sequence.}
  如果键映射位于键序列的中间，则清除键映射的状态。例如，用户可能点击了escape，然后切换到另一个窗口；如果escape是键盘序列的一部分，则需要清除键映射状态，因为用户不会完成该序列。

@;{A break callback function can be installed with @method[keymap%
 set-break-sequence-callback].}
  可以使用@method[keymap%
 set-break-sequence-callback]安装break回调函数。

}

@defmethod[(call-function [name string?]
                          [in any/c]
                          [event (is-a?/c event%)]
                          [try-chain? any/c #f])
           boolean?]{

@;{Calls a named event handler directly. If the function cannot be found
 or the found handler did not want to handle the event, @racket[#f] is
 returned. Otherwise, the return value is the boolean return value of
 the event handler.}
  直接调用命名事件处理程序。如果找不到函数或找到的处理程序不想处理事件，则返回@racket[#f]。否则，返回值是事件处理程序的布尔返回值。

@;{The @racket[in] and @racket[event] arguments are passed on to the keymap
 handler procedure if one is found.}
 如果找到键映射处理程序过程，则将@racket[in]和@racket[event]参数传递给它。 

@;{If @racket[try-chain?] is not @racket[#f], keymaps chained to this one
 are searched for the function name.  If the function is not found and
 @racket[try-chain?] is @racket[#f]; an exception is also raised, but
 the exception handler cannot escape (see
 @secref["evtcontjump"]).}
如果@racket[try-chain?]不是@racket[#f]，链接到此键的键映射将搜索函数名。如果找不到函数且@racket[try-chain?]是@racket[#f]；也会引发异常，但异常处理程序无法转义（请参阅@secref["evtcontjump"]）。
  
}


@defmethod[(chain-to-keymap [next (is-a?/c keymap%)]
                            [prefix? any/c])
           void?]{

@;{Chains @racket[next] off @this-obj[] The @racket[next] keymap will be
 used to handle events which are not handled by @this-obj[].}
将@racket[next]与@this-obj[]链接，@racket[next]键映射将用于处理非@this-obj[]处理的事件。
  
@;{If @racket[prefix?] is a true value, then @racket[next] will take
 precedence over other keymaps already chained to @this-obj[] in the
 case that both keymaps map the same key sequence.
 When one chained keymap maps a key that is a prefix of another, then the
 shorter key sequence is always used, regardless of @racket[prefix?].}
  如果@racket[prefix?]是一个真值，那么在两个键映射映射相同的键序列的情况下，@racket[next]将优先于已经链接到@this-obj[]的其他键映射。当一个链接的键映射映射一个作为另一个前缀的键时，总是使用较短的键序列，不管@racket[prefix?]。

@;{Multiple keymaps can be chained off one keymap using @method[keymap%
 chain-to-keymap]. When keymaps are chained off a main keymap, events
 not handled by the main keymap are passed to the chained keymaps
 until some chained keymap handles the events.  Keymaps can be chained
 together in an arbitrary acyclic graph.}
  使用@method[keymap% chain-to-keymap]可以将多个键映射从一个键映射链接起来。当键映射与主键映射链接时，未由主键映射处理的事件将传递到链接的键映射，直到某些链接的键映射处理这些事件。键映射可以在任意非循环图中链接在一起。

@;{Keymap chaining is useful because multiple-event sequences are handled
 correctly for chained groups. Without chaining, a sequence of events
 can produce state in a keymap that must be reset when a callback is
 invoked in one of the keymaps. This state can be manually cleared
 with @method[keymap% break-sequence], though calling the
 @method[keymap% break-sequence] method also invokes the handler
 installed by @method[keymap% set-break-sequence-callback].}
  键映射链接非常有用，因为对于链接的组，正确处理了多个事件序列。如果不链接，事件序列可以在键映射中生成状态，当在其中一个键映射中调用回调时，必须重置该状态。虽然调用@method[keymap% break-sequence]方法还调用@method[keymap% set-break-sequence-callback]回调安装的处理程序，但可以使用@method[keymap% break-sequence]手动清除此状态。

}


@defmethod[(get-double-click-interval)
           (integer-in 0 1000000)]{

@;{Returns the maximum number of milliseconds that can separate the
 clicks of a double-click.}
  返回可分离双击单击的最大毫秒数。

@;{The default interval is determined in a platform-specific way, but it
 can be overridden globally though the
 @ResourceFirst{doubleClickTime}; see @|mrprefsdiscuss|.}
 默认间隔是以特定于平台的方式确定的，但可以通过@ResourceFirst{doubleClickTime}全局覆盖；请参见@|mrprefsdiscuss|。 

}

@defmethod[(handle-key-event [in any/c]
                             [event (is-a?/c key-event%)])
           boolean?]{

@;{Attempts to handle a keyboard event, returning @racket[#t] if the event
 was handled (i.e., a handler was found and it returned a true value),
 @racket[#f] otherwise.}
  尝试处理键盘事件，如果事件被处理（即，找到了一个处理程序，它返回了一个真值），则返回@racket[#t]，否则返回@racket[#f]。

@;{See also @method[keymap% call-function].}
  另请参见@method[keymap% call-function]。

}


@defmethod[(handle-mouse-event [in any/c]
                               [event (is-a?/c mouse-event%)])
           boolean?]{

@;{Attempts to handle a mouse event, returning @racket[#t] if the event
 was handled (i.e., a handler was found and it returned a true value),
 @racket[#f] otherwise.}
尝试处理一个鼠标事件，如果事件被处理（即找到一个处理程序，它返回一个真值），则返回@racket[#t]，否则返回@racket[#f]。
  
@;{See also @method[keymap% call-function].}
  另请参见@method[keymap% call-function]。

}


@defmethod[(map-function [keyname string?]
                         [fname string?])
           void?]{

@;{Maps an input state sequence to a function name using a string-encoded
 sequence in @racket[keyname]. The format of @racket[keyname] is a
 sequence of semicolon-delimited input states; each state is made up
 of a sequence of modifier identifiers followed by a key identifier.}
  使用@racket[keyname]中的字符串编码序列将输入状态序列映射到函数名。@racket[keyname]的格式是一系列分号分隔的输入状态；每个状态由一系列修饰符标识符和一个键标识符组成。

@;{The modifier identifiers are:}
  修改器标识符为：

@itemize[

 @item{@litchar{s:}@;{ --- All platforms: Shift}——所有平台：Shift}

 @item{@litchar{c:}@;{ --- All platforms: Control}——所有平台：Control}

 @item{@litchar{a:}@;{ --- Mac OS: Option}——Mac OS：Option}

 @item{@litchar{m:}@;{ --- Windows: Alt; Unix: Meta; Mac OS: Command, when
 @racket[map-command-as-meta-key] produces @racket[#t]}——当@racket[map-command-as-meta-key]方法为@racket[#t]，Windows：Alt；Unix：Meta；Mac OS：Command}

 @item{@litchar{d:}@;{ --- Mac OS: Command}——Mac OS：Command}

 @item{@litchar{l:}@;{ --- All platforms: Caps Lock}——所有平台：Caps Lock}

 @item{@litchar{g:}@;{ --- Windows: Control plus Alt as AltGr;
                        see @xmethod[key-event% get-control+meta-is-altgr]}
   ——Windows：Control+Alt作为AltGr，参见@xmethod[key-event% get-control+meta-is-altgr]}

 @item{@litchar{?:}@;{ --- All platforms: allow match to character produced by opposite 
                  use of Shift, AltGr/Option, and/or Caps Lock, when available; see
                  @xmethod[key-event% get-other-shift-key-code]}
   ——所有平台：允许匹配使用Shift、AltGr/Option和/或Caps Lock时产生的字符（如果可用）；请参阅@xmethod[key-event% get-other-shift-key-code]}
]

@;{If a particular modifier is not mentioned in a state string, it
 matches states whether that modifier is pressed or not pressed. A
 @litchar{~} preceding a modifier makes the string match only states
 where the corresponding modifier is not pressed. If the state string
 begins with @litchar{:}, then the string matches a state only if
 modifiers among Shift, Control, Option, Alt, Meta, and Command that are
 not mentioned in the string are not pressed.}
  如果在状态字符串中没有提到某个特定的修饰符，那么它将匹配该修饰符是否被按下的状态。修饰符前面的@litchar{~}使字符串只匹配未按下相应修饰符的状态。如果状态字符串以@litchar{:}开头，则只有在未按字符串中未提及的Shift、Control、Option、Alt、Meta和Command中的修饰符时，字符串才匹配状态。

@;{A key identifier can be either a character on the keyboard (e.g.,
 @litchar{a}, @litchar{2}, @litchar{?}) or a special name. The
 special names are as follows:}
  键标识符可以是键盘上的字符（例如，@litchar{a}、@litchar{2}、@litchar{?}）或者一个特殊的名字。特殊名称如下：
  
@itemize[
#:style 'compact
@item{@litchar{leftbutton}@;{ (button down)}（按下按钮）}
@item{@litchar{rightbutton}}
@item{@litchar{middlebutton}}
@item{@litchar{leftbuttondouble}@;{ (button down for double-click)}（双击按下按钮）}
@item{@litchar{rightbuttondouble}}
@item{@litchar{middlebuttondouble}}
@item{@litchar{leftbuttontriple}@;{ (button down for triple-click)}（三次点击按下按钮）}
@item{@litchar{rightbuttontriple}}
@item{@litchar{middlebuttontriple}}
@item{@litchar{leftbuttonseq}@;{ (all events from button down through button up)}（所有事件来自于按下按钮通过弹起按钮）}
@item{@litchar{rightbuttonseq}}
@item{@litchar{middlebuttonseq}}
@item{@litchar{wheelup}}
@item{@litchar{wheeldown}}
@item{@litchar{wheelleft}}
@item{@litchar{wheelright}}
@item{@litchar{esc}}
@item{@litchar{delete}}
@item{@litchar{del}@;{  (same as @litchar{delete})}（类似于@litchar{delete}）}
@item{@litchar{insert}}
@item{@litchar{ins}@;{ (same as @litchar{insert})}（类似于@litchar{insert}）}
@item{@litchar{add}}
@item{@litchar{subtract}}
@item{@litchar{multiply}}
@item{@litchar{divide}}
@item{@litchar{backspace}}
@item{@litchar{back}}
@item{@litchar{return}}
@item{@litchar{enter}@;{ (same as @litchar{return})}（类似于@litchar{return}）}
@item{@litchar{tab}}
@item{@litchar{space}}
@item{@litchar{right}}
@item{@litchar{left}}
@item{@litchar{up}}
@item{@litchar{down}}
@item{@litchar{home}}
@item{@litchar{end}}
@item{@litchar{pageup}}
@item{@litchar{pagedown}}
@item{@litchar{semicolon}@;{ (since @litchar{;} separates sequence steps)}（因为@litchar{;}分隔序列步骤）}
@item{@litchar{colon}@;{  (since @litchar{:} separates modifiers)}（因为@litchar{:}分隔修饰符）}
@item{@litchar{numpad0}}
@item{@litchar{numpad1}}
@item{@litchar{numpad2}}
@item{@litchar{numpad3}}
@item{@litchar{numpad4}}
@item{@litchar{numpad5}}
@item{@litchar{numpad6}}
@item{@litchar{numpad7}}
@item{@litchar{numpad8}}
@item{@litchar{numpad9}}
@item{@litchar{numpadenter}}
@item{@litchar{f1}}
@item{@litchar{f2}}
@item{@litchar{f3}}
@item{@litchar{f4}}
@item{@litchar{f5}}
@item{@litchar{f6}}
@item{@litchar{f7}}
@item{@litchar{f8}}
@item{@litchar{f9}}
@item{@litchar{f10}}
@item{@litchar{f11}}
@item{@litchar{f12}}
@item{@litchar{f13}}
@item{@litchar{f14}}
@item{@litchar{f15}}
@item{@litchar{f16}}
@item{@litchar{f17}}
@item{@litchar{f18}}
@item{@litchar{f19}}
@item{@litchar{f20}}
@item{@litchar{f21}}
@item{@litchar{f22}}
@item{@litchar{f23}}
@item{@litchar{f24}}
]

@;{For a special keyword, the capitalization does not matter. However,
 capitalization is important for single-letter keynames. Furthermore,
 single-letter ASCII keynames are treated specially: @litchar{A} and
 @litchar{s:a} are both treated as @litchar{s:A}.  However, when
 @litchar{c:} is included on Windows without @litchar{m:}, or when
 @litchar{d:} is included on Mac OS, then ASCII letters are not
 upcased with @litchar{s:}, since the upcasing behavior of the Shift key
 is cancelled by Control without Alt (on Windows) or by Command
 (on Mac OS).}
  对于一个特殊的关键字，大写并不重要。然而，大写字母对于单字母键名很重要。此外，单字母ASCII 键名被特殊处理：@litchar{A}和@litchar{s:a}都被视为@litchar{s:A}。但是，当@litchar{c:}包含在不带@litchar{m:}的Windows上时，或当@litchar{d:}包含在Mac OS上时，则ASCII字母不使用@litchar{s:}升序，因为Shift键的升序行为被不带Alt的Control（在Windows上）或Command（在Mac OS上）取消。

@;{A state can match multiple state strings mapped in a keymap (or keymap
 chain); when a state matches multiple state strings, a mapping is
 selected by ranking the strings according to specificity. A state
 string that mentions more pressed modifiers ranks higher than other
 state strings, and if two strings mention the same number of pressed
 modifiers, the one that mentions more unpressed modifiers ranks
 higher. Finally, a state string that includes @litchar{?:} and
 matches only with the opposite use of Shift, AltGr/Option, and/or
 Caps Lock ranks below all matches that do not depend on @litchar{?:},
 and one that requires the opposite use of both Shift and AltGr/Option
 ranks even lower. In the case that multiple matching strings have the
 same rank, a match is selected arbitrarily.}
  一个状态可以匹配一个键映射（或键映射链）中映射的多个状态字符串；当一个状态匹配多个状态字符串时，通过根据特定性对字符串排序来选择映射。一个状态字符串，它提到更多的按修饰符，其排名高于其他状态字符串，如果两个字符串提到相同数量的按修饰符，则提到更多未按修饰符的状态字符串排名更高。最后，一个状态字符串包括@litchar{?:}并且仅与Shift、AltGr/Option和/或Caps Lock的相反用法匹配，并且排名低于所有不依赖的匹配项@litchar{?:}，而需要同时使用Shift和AltGr/Option的则排名更低。如果多个匹配字符串具有相同的秩，则可以任意选择匹配项。

@;{Examples:}
  示例：

@itemize[

 @item{@racket["space"]@;{ --- matches whenever the space bar is pressed,
 regardless of the state of modifiers keys.}
        ——无论修改器键的状态如何，只要按下空格键就会匹配。}

 @item{@racket["~c:space"]@;{ --- matches whenever the space bar is pressed
 and the Control key is not pressed.}
        ——只要按下空格键而不按下Control键，就会匹配。}

 @item{@racket["a"]@;{ --- matches whenever @litchar{a} is typed, regardless of
 the state of modifiers keys (other than Shift).}
        ——无论何时键入@litchar{a}，都匹配，而不管修改器键的状态如何（Shift除外）。}

 @item{@racket[":a"]@;{ --- matches only when @litchar{a} is typed with no
 modifier keys pressed.}
        ——仅当键入@litchar{a}时不按修改键时匹配。}

 @item{@racket["~c:a"]@;{ --- matches whenever @litchar{a} is typed and neither
 the Shift key nor the Control key is pressed.}
        ——每次键入@litchar{a}时都匹配，并且既不按Shift键也不按Control键。}

 @item{@racket["c:m:~g:x"]@;{ --- matches whenever @litchar{x} is typed
 with Control and Alt (Windows) or Meta (Unix) is pressed, as long as
 the Control-Alt combination is not formed by AltGr on Windows.}
        ——只要在Windows上的AltGr不构成Control-Alt组合，只要在键入@litchar{x}时使用Control并按下Alt（Windows）或Meta（Unix），就会匹配。}

 @item{@racket[":esc;:c:c"]@;{ --- matches an Escape key press (no
 modifiers) followed by a Control-C press (no modifiers other than
 Control).}
        ——匹配Escape键按下（无修改器），然后是Control-C按下（除Control之外无修改器）。}

 @item{@racket["?:d:+"]@;{ --- matches when Command is pressed with key
  that produces @litchar{+}, even if producing @litchar{+} normally requires
  pressing Shift.}
        ——用产生@litchar{+}的键按下命令时匹配，即使产生@litchar{+}通常需要按下Shift键。}

]

@;{A call to @method[keymap% map-function] that would map a particular
 key sequence both as a prefix and as a complete sequence raises an
 exception, but the exception handler cannot escape (see
 @secref["evtcontjump"]).}
  调用@method[keymap% map-function]函数以前缀和完整序列的形式映射特定的键序列会引发异常，但异常处理程序无法转义（请参见@secref["evtcontjump"]）。

@;{A function name does not have to be mapped to a handler before input
 states are mapped to the name; the handler is dispatched by name at
 the time of invocation. The event handler mapped to a function name
 can be changed without affecting the map from input states to
 function names.}
在输入状态映射到名称之前，不必将函数名映射到处理程序；调用时按名称调度处理程序。映射到函数名的事件处理程序可以更改，而不会影响从输入状态到函数名的映射。

@;{@history[#:changed "1.2" @elem{Added @litchar{g:} and @litchar{~g:} support.}]}
  @history[#:changed "1.2" @elem{添加@litchar{g:}和@litchar{~g:}支持。}]
 }


@defmethod[(remove-chained-keymap [keymap (is-a?/c keymap%)])
           void?]{

@;{If @racket[keymap] was previously chained from this keymap (through
 @method[keymap% chain-to-keymap]), then it is removed from the
 chain-to list.}
  如果@racket[keymap]以前是从这个键映射链接的（通过@method[keymap% chain-to-keymap]），那么它将从链到列表中删除。

}


@defmethod[(remove-grab-key-function)
           void?]{

@;{Removes a callback installed with @method[keymap%
 set-grab-key-function].}
  删除使用@method[keymap%
 set-grab-key-function]函数安装的回调。

}

@defmethod[(remove-grab-mouse-function)
           void?]{

@;{Removes a callback installed with @method[keymap%
 set-grab-mouse-function].}
删除使用@method[keymap%
 set-grab-mouse-function]函数安装的回调。
  
}


@defmethod[(set-break-sequence-callback [f (-> any)])
           void?]{

@;{Installs a callback procedure that is invoked when @method[keymap%
 break-sequence] is called. After it is invoked once, the callback is
 removed from the keymap. If another callback is installed before
 @method[keymap% break-sequence] is called, the old callback is
 invoked immediately before the new one is installed.}
  安装在调用@method[keymap%  break-sequence]时调用的回调过程。调用一次后，回调将从keymap中删除。如果在调用@method[keymap%
 break-sequence]之前安装了另一个回调，则在安装新回调之前立即调用旧回调。

}


@defmethod[(set-double-click-interval [n (integer-in 0 1000000)])
           void?]{

@;{Sets the maximum number of milliseconds that can separate the clicks
 of a double-click.}
  设置双击可分离单击的最大毫秒数。

}

@defmethod[(set-grab-key-function [f ((or/c string? false?) 
                                      (is-a?/c keymap%) 
                                      any/c 
                                      (is-a?/c key-event%)
                                      . -> . any)])
           void?]{

@;{Installs a callback procedure that is invoked after the keymap matches
 input to a function name or fails to match an input. Only one
 keyboard grab function can be installed at a time. When keymaps are
 chained to a keymap with a grab callback, the callback is invoked for
 matches in the chained keymap (when the chained keymap does not have
 its own grab callback).}
  
安装一个回调过程，该过程在键映射将输入与函数名匹配或与输入匹配失败后调用。一次只能安装一个键盘抓取功能。当使用抓取回调将键映射链接到键映射时，将为链接键映射中的匹配项调用回调（当链接键映射没有自己的抓取回调时）。

@;{If a grab callback returns a true value for a matching or non-matching
 callback, the event is considered handled. If the callback returns a
 true value for a matching callback, then the matching keymap function
 is not called by the keymap.}
  如果抓取回调返回匹配或不匹配回调的真值，则视为已处理该事件。如果回调返回匹配回调的真值，则键映射不会调用匹配的键映射函数。

@;{The callback procedure @racket[f] will be invoked as:}
回调过程@racket[f]将被调用为：
  
@racketblock[
(f _str _keymap _editor _event)
]

@;{The @racket[_str] argument is the name of a function for a matching
 callback, or @racket[#f] for a non-matching callback.  The
 @racket[_keymap] argument is the keymap that matched (possibly a
 keymap chained to the one in which the callback was installed) or the
 keymap in which the callback was installed. The @racket[_editor] and
 @racket[_event] arguments are the same as passed on to the matching
 keymap function.}
  @racket[_str]参数是匹配回调函数的名称，或者@racket[#f]是不匹配回调函数的名称。@racket[_keymap]参数是匹配的键映射（可能是链接到安装回调的键映射）或安装回调的键映射。@racket[_editor]和@racket[_event]参数与传递给匹配的键映射函数的参数相同。


@;{Key grab callback functions are de-installed with @method[keymap%
 remove-grab-key-function].}
  键抓取回调函数与@method[keymap%
 remove-grab-key-function]一起卸载。

}


@defmethod[(set-grab-mouse-function [f ((or/c string? false?) 
                                        (is-a?/c keymap%)
                                        any/c 
                                        (is-a?/c mouse-event%)
                                        . -> . any)])
           void?]{

@;{Like @method[keymap% set-grab-key-function], but for mouse events.}
类似@method[keymap% set-grab-key-function]，但用于鼠标事件。

}}

