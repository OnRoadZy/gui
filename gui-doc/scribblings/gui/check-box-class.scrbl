#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/check-box}}

@defclass/title[check-box% object% (control<%>)]{

@;{A check box is a labeled box which is either checked or unchecked.}
复选框是一个带标签的框，可以是选中的，也可以是未选中的。

@;{Whenever a check box is clicked by the user, the check box's value is
 toggled and its callback procedure is invoked. A callback procedure
 is provided as an initialization argument when each check box is
 created.}
每当用户单击一个复选框时，该复选框的值就会被切换并调用其回调过程。当创建每个复选框时，回调过程作为初始化参数提供。



@defconstructor[([label (or/c label-string? (is-a?/c bitmap%))]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%)
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [callback ((is-a?/c check-box%) (is-a?/c control-event%)
                            . -> . any) (lambda (c e) (void))]
                 [style (listof (or/c 'deleted)) null]
                 [value any/c #f]
                 [font (is-a?/c font%) normal-control-font]
                 [enabled any/c #t]
                 [vert-margin spacing-integer? 2]
                 [horiz-margin spacing-integer? 2]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #f]
                 [stretchable-height any/c #f])]{

@;{Creates a check box with a string or bitmap label. @bitmaplabeluse[label]}
创建带有字符串或位图标签的复选框。@bitmaplabeluse[label]

@;{@labelstripped[@racket[label]
  @elem{ (when @racket[label] is a string)}
  @elem{effectively click the check box}]}
@labelstripped[@racket[label]
  @elem{ (当@racket[label]为字符串)}
  @elem{有效单击复选框}]

@;{The @racket[callback] procedure is called (with the event type
 @indexed-racket['check-box]) whenever the user clicks the check box.}
  每当用户单击该复选框时，就会调用@racket[callback]过程(事件类型为@indexed-racket['check-box])。
  

@DeletedStyleNote[@racket[style] @racket[parent]]{@;{check box}复选框}

@;{If @racket[value] is true, it is passed to
@method[check-box% set-value] so that the box is initially checked.}
  如果@racket[value]为真，则会将其传递给@method[check-box% set-value]，以便最初选中该框。

@FontKWs[@racket[font]] @WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaKWs[]

}

@defmethod[(get-value)
           boolean?]{
@;{Gets the state of the check box: @racket[#t] if it is checked, @racket[#f]
 otherwise.}
  获取复选框的状态：如果选中，则为@racket[#t],否则为@racket[#f]。

}

@defmethod[#:mode override
           (set-label [label (or/c label-string? (is-a?/c bitmap%))])
           void?]{

@;{The same as @xmethod[window<%> set-label] when @racket[label] is a
 string.}
  当@racket[label]是字符串时，与 @xmethod[window<%> set-label]相同。

@;{Otherwise, sets the bitmap label for a bitmap check box.
@bitmaplabeluseisbm[label] @|bitmapiforiglabel|}
  否则，设置位图标签给位图复选框。@bitmaplabeluseisbm[label] @|bitmapiforiglabel|

}

@defmethod[(set-value [state any/c])
           void?]{

@;{Sets the check box's state. (The control's callback procedure is
@italic{not} invoked.)}
  设置复选框的状态。(控件的回调过程@italic{未}调用。）

@;{@MonitorCallback[@elem{The check box's state} @elem{the user clicking the control} @elem{state}]}
@MonitorCallback[@elem{@;{The check box's state}复选框的状态}@elem{@;{the user clicking the control}用户单击控件} @elem{@;{state}状态}]

@;{If @racket[state] is @racket[#f], the box is
 unchecked, otherwise it is checked.}
  如果@racket[state]为@racket[#f]，则为未选中，否则为选中。

}}

