#lang scribble/doc
@(require "common.rkt")

@definterface/title[mult-color<%> ()]{

@;{A @racket[mult-color<%>] object is used to scale the RGB values of a
 @racket[color%] object. A @racket[mult-color<%>] object exist only
 within a @racket[style-delta%] object.}
  @racket[mult-color<%>]对象用于缩放@racket[color%]对象的RGB值。@racket[mult-color<%>]对象仅存在于@racket[style-delta%]对象中。

@;{See also @method[style-delta% get-foreground-mult] and
 @method[style-delta% get-background-mult].}
另请参见@method[style-delta% get-foreground-mult]和@method[style-delta% get-background-mult]。


@defmethod[(get [r (box/c real?)]
                [g (box/c real?)]
                [b (box/c real?)])
           void?]{

@;{Gets all of the scaling values.}
  获取所有缩放值。

@;{@boxisfill[@racket[r] @elem{the scaling value for the red component of the color}]
@boxisfill[@racket[g] @elem{the scaling value for the green component of the color}]
@boxisfill[@racket[b] @elem{the scaling value for the blue component of the color}]}
  @boxisfill[@racket[r] @elem{框中填充颜色的红色分量的缩放值。}] @boxisfill[@racket[g] @elem{框中填充颜色的绿色分量的缩放值。}] @boxisfill[@racket[b] @elem{框中填充颜色蓝色分量的缩放值。}]

}

@defmethod[(get-b)
           real?]{

@;{Gets the multiplicative scaling value for the blue component of the color.}
 获取颜色的蓝色分量的乘法缩放值。 

}

@defmethod[(get-g)
           real?]{

@;{Gets the multiplicative scaling value for the green component of the color.}
  获取颜色的绿色分量的乘法缩放值。

}

@defmethod[(get-r)
           real?]{

@;{Gets the multiplicative scaling value for the red component of the color.}
  获取颜色的红色分量的乘法缩放值。

}

@defmethod[(set [r real?]
                [g real?]
                [b real?])
           void?]{

@;{Sets all of the scaling values.}
  设置所有缩放值。

}

@defmethod[(set-b [v real?])
           void?]{

@;{Sets the multiplicative scaling value for the blue component of the color.}
  为颜色的蓝色分量设置乘法缩放值。

}

@defmethod[(set-g [v real?])
           void?]{

@;{Sets the multiplicative scaling value for the green component of the
color.}
  设置颜色的绿色分量的乘法缩放值。

}

@defmethod[(set-r [v real?])
           void?]{

@;{Sets the additive value for the red component of the color.}
  设置颜色的红色分量的加法值。

}}
