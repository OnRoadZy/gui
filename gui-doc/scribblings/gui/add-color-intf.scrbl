#lang scribble/doc
@(require "common.rkt")

@definterface/title[add-color<%> ()]{

@;{An @racket[add-color<%>] object is used to additively change the RGB values of
a @racket[color%] object. An @racket[add-color<%>] object only exists within a
@racket[style-delta%] object.}
  @racket[add-color<%>]对象用于附加更改@racket[color%]对象的RGB值。@racket[add-color<%>]对象只存在于@racket[style-delta%]对象。

@;{See also @method[style-delta% get-foreground-add] and @method[style-delta%
get-background-add].}
  也参见@method[style-delta% get-foreground-add]和@method[style-delta%
get-background-add]。

@defmethod[(get [r (box/c (integer-in -1000 1000))]
                [g (box/c (integer-in -1000 1000))]
                [b (box/c (integer-in -1000 1000))])
           void?]{
@;{  Gets all of the additive values.}
  获取所有添加值。

  @boxisfill[@racket[r] @elem{@;{the additive value for the red component of the color}颜色中红色分量的添加值}]
  @boxisfill[@racket[g] @elem{@;{the additive value for the green component of the color}颜色的绿色分量的添加值}]
  @boxisfill[@racket[b] @elem{@;{the additive value for the blue component of the color}颜色的蓝色分量的添加值}]
}

@defmethod[(get-b)
           (integer-in -1000 1000)]{
  @;{Gets the additive value for the blue component of the color.}
    获取颜色的蓝色分量的添加值。
}

@defmethod[(get-g)
           (integer-in -1000 1000)]{

@;{Gets the additive value for the green component of the color.}
  获取颜色的绿色分量的添加值。

}

@defmethod[(get-r)
           (integer-in -1000 1000)]{
  @;{Gets the additive value for the red component of the color.}
    获取颜色的红色分量的添加值。
}

@defmethod[(set [r (integer-in -1000 1000)]
                [g (integer-in -1000 1000)]
                [b (integer-in -1000 1000)])
           void?]{
  @;{Sets all of the additive values.}
    设置所有添加值。
}

@defmethod[(set-b [v (integer-in -1000 1000)])
           void?]{
  @;{Sets the additive value for the blue component of the color.}
    为颜色的蓝色分量设置添加值。
}

@defmethod[(set-g [v (integer-in -1000 1000)])
           void?]{
  @;{Sets the additive value for the green component of the color.}
    设置颜色的绿色分量的添加值。
}

@defmethod[(set-r [v (integer-in -1000 1000)])
           void?]{
  @;{Sets the additive value for the red component of the color.}
    设置颜色的红色分量的添加值。
}}

