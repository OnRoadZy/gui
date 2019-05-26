#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/gauge}}

@defclass/title[gauge% object% (control<%>)]{

@;{A gauge is a horizontal or vertical bar for displaying the output
value of a bounded integer quantity. Each gauge has an adjustable
range, and the gauge's current value is always between 0 and its
range, inclusive. Use @method[gauge% set-value] to set the value
of the gauge.}
  计量条（进度条）是显示有界整数输出值的水平或垂直条。每个计量条都有一个可调范围，计量条的当前值始终在0和其范围之间，包括0和范围。使用@method[gauge% set-value]设置计量条的值。


@defconstructor[([label (or/c label-string? #f)]
                 [range positive-dimension-integer?]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [style (listof (or/c 'horizontal 'vertical 
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

@;{If @racket[label] is a string, it is used as the gauge label; otherwise
 the gauge does not display a label.}
如果@racket[label]是字符串，则用作计量条标签；否则计量条不显示标签。

@;{@labelsimplestripped[@racket[label] @elem{gauge}]}
@labelsimplestripped[@racket[label] @elem{计量条}]

@;{The @racket[range] argument is an integer specifying the maximum value of
 the gauge (inclusive). The minimum gauge value is always @racket[0].}
  @racket[range]参数是一个整数，指定计量条的最大值（包括）。最小计量值始终为@racket[0]。

@;{The @racket[style] list must include either @racket['horizontal],
 specifying a horizontal gauge, or @racket['vertical], specifying a vertical
 gauge. @HVLabelNote[@racket[style]]{gauge} @DeletedStyleNote[@racket[style]
 @racket[parent]]{gauge}}
  @racket[style]列表必须包括@racket['horizontal]，指定水平计量条，或@racket['vertical]，指定垂直计量条。@HVLabelNote[@racket[style]]{计量条} @DeletedStyleNote[@racket[style]
 @racket[parent]]{计量条}

@FontKWs[@racket[font]] @WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaKWs[]


}

@defmethod[(get-range)
           positive-dimension-integer?]{
@;{Returns the range (maximum value) of the gauge.}
  返回计量条的范围（最大值）。

}

@defmethod[(get-value)
           dimension-integer?]{

@;{Returns the gauge's current value.}
  返回计量条的当前值。

}

@defmethod[(set-range [range positive-dimension-integer?])
           void?]{

@;{Sets the range (maximum value) of the gauge.}
  设置计量条的范围（最大值）。

}

@defmethod[(set-value [pos dimension-integer?])
           void?]{

@;{Sets the gauge's current value. If the specified value is larger than
 the gauge's range, @|MismatchExn|.}
  设置计量条的当前值。如果指定的值大于计量条的范围，@|MismatchExn|。

}}

