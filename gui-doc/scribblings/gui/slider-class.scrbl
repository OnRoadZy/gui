#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/slider}}

@defclass/title[slider% object% (control<%>)]{

@;{A @racket[slider] object is a panel item with a handle that the user can
 drag to change the control's value. Each slider has a fixed minimum
 and maximum value.}
@racket[slider]对象是一个带有柄的面板项，用户可以拖动它来更改控件的值。每个滑块都有一个固定的最小值和最大值。
  
@;{Whenever the user changes the value of a slider, its callback
 procedure is invoked. A callback procedure is provided as an
 initialization argument when each slider is created.}
每当用户更改滑块的值时，都会调用其回调过程。当创建每个滑块时，回调过程作为初始化参数提供。


@defconstructor[([label (or/c label-string? #f)]
                 [min-value position-integer?]
                 [max-value position-integer?]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [callback ((is-a?/c slider%) (is-a?/c control-event%) . -> . any) (lambda (b e) (void))]
                 [init-value position-integer? min-value]
                 [style (listof (or/c 'horizontal 'vertical 'plain 
                                      'vertical-label 'horizontal-label 
                                      'deleted)) 
                        '(horizontal)]
                 [font (is-a?/c font%) normal-control-font]
                 [enabled any/c #t]
                 [vert-margin spacing-integer? 2]
                 [horiz-margin spacing-integer? 2]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c (memq 'horizontal style)]
                 [stretchable-height any/c (memq 'vertical style)])]{

@;{If @racket[label] is a string, it is used as the label for the slider.
 Otherwise, the slider does not display its label.}
  如果@racket[label]是字符串，则用作滑块的标签。否则，滑块不会显示其标签。

@labelstripped[@racket[label]
  @elem{} @elem{@;{move the keyboard focus to the slider}移动键盘焦点到滑块}]

@;{The @racket[min-value] and @racket[max-value] arguments specify the
 range of the slider, inclusive. The @racket[init-value] argument
 optionally specifies the slider's initial value. If the sequence
 [@racket[min-value], @racket[initial-value], @racket[maximum-value]]
 is not increasing, @|MismatchExn|.}
  @racket[min-value]和@racket[max-value]参数指定滑块的范围（包括该范围）。@racket[init-value]参数可选地指定滑块的初始值。如果序列[@racket[min-value]、@racket[initial-value]、@racket[maximum-value]]没有增加，@|MismatchExn|。

@;{The @racket[callback] procedure is called (with the event type
 @indexed-racket['slider]) when the user changes the slider's value.}
  当用户更改滑块的值时，调用@racket[callback]过程（使用事件类型@indexed-racket['slider]）。

@;{The @racket[style] argument must include either @racket['vertical] for
 a vertical slider, or @racket['horizontal] for a horizontal
 slider. If @racket[style] includes @racket['plain], the slider does
 not display numbers for its range and current value to the user.
 @HVLabelNote[@racket[style]]{slider} @DeletedStyleNote[@racket[style] @racket[parent]]{slider}}
@racket[style]参数必须对垂直滑块包含@racket['vertical]或者对水平滑块包含@racket['horizontal]。如果@racket[style]包含@racket['plain]，则滑块不会向用户显示其范围和当前值的数字。@HVLabelNote[@racket[style]]{滑块} @DeletedStyleNote[@racket[style] @racket[parent]]{滑块}。
  
@FontKWs[@racket[font]] @WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaKWs[]


}

@defmethod[(get-value)
           position-integer?]{

@;{Gets the current slider value.}
  获取当前的滑块值。

}

@defmethod[(set-value [value position-integer?])
           void?]{

@;{Sets the value (and displayed position) of the slider. (The control's
 callback procedure is @italic{not} invoked.) If @racket[value] is
 outside the slider's minimum and maximum range, @|MismatchExn|.}
设置滑块的值（和显示位置）。（@italic{未}调用控件的回调过程）如果@racket[value]超出滑块的最小和最大范围，@|MismatchExn|。
  
@;{@MonitorCallback[@elem{A slider's value} @elem{the user clicking the control} @elem{value}]}
  @MonitorCallback[@elem{滑块值} @elem{用户单击控件} @elem{值}]

}}

