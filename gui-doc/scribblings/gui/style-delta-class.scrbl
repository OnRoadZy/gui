#lang scribble/doc
@(require "common.rkt")

@defclass/title[style-delta% object% ()]{

@;{A @racket[style-delta%] object encapsulates a style change. The changes
expressible by a delta include:}
  @racket[style-delta%]对象封装了样式更改。可以用delta表示的变化包括：
  
@itemize[
@item{@;{changing the font family}更改字体系列}
@item{@;{changing the font face}更改字体表面}
@item{@;{changing the font size to a new value}将字体大小更改为新值}
@item{@;{enlarging the font by an additive amount}将字体增大一个加法量}
@item{@;{enlarging the font by a multiplicative amount, etc.}将字体增大一个乘法量等}
@item{@;{changing the font style (normal, @italic{italic}, or @slant{slant})}更改字体样式（普通、@italic{斜体}或@slant{倾斜}）}
@item{@;{toggling the font style}切换字体样式}
@item{@;{changing the font to @italic{italic} if it is currently @slant{slant}, etc.}如果字体当前@slant{倾斜}，则将其更改为@italic{斜体}等}
@item{@;{changing the font weight, etc.}更改字体粗细等}
@item{@;{changing the underline, etc.}更改下划线等}
@item{@;{changing the vertical alignment, etc.}更改垂直对齐方式等}
@item{@;{changing the foreground color}更改前景颜色}
@item{@;{dimming or brightening the foreground color, etc.}使前景颜色变暗或变亮等}
@item{@;{changing the background color, etc.}更改背景色等}
@item{@;{changing text backing transparency}更改文字背景透明度}
]

@;{The @method[style-delta% set-delta] method is convenient for most
style delta settings; it takes a high-level delta specification and
sets the internal delta information.}
@method[style-delta% set-delta]方法对于大多数样式的delta设置都很方便；它采用高级delta规范并设置内部delta信息。

@;{To take full advantage of a style delta, it is necessary to understand
the internal on/off settings that can be manipulated through methods
such as @method[style-delta% set-weight-on]. For example, the font
weight change is specified through the @racket[weight-on] and
@racket[weight-off] internal settings. Roughly, @racket[weight-on]
turns on a weight setting when it is not present and
@racket[weight-off] turns off a weight setting when it is
present. These two interact precisely in the following way:}
要充分利用样式增量，必须了解可通过诸如@method[style-delta% set-weight-on]之类的方法操作的内部开/关设置。例如，字体粗细更改是通过内部设置的@racket[weight-on]和@racket[weight-off]来指定的。大致上，@racket[weight-on]会在不存在权重设置时打开权重设置，@racket[weight-off]会在存在权重设置时关闭权重设置。这两种方式的交互方式如下：

@itemize[
@item{@;{If both @racket[weight-on] and @racket[weight-off] are set to @racket['base], 
then the font weight is not changed.}
        如果@racket[weight-on]和@racket[weight-off]都设置为@racket['base]，则字体粗细不会更改。}
 
@item{@;{If @racket[weight-on] is not @racket['base], then the weight is set to 
@racket[weight-on].}
        如果@racket[weight-on]不是@racket['base]，则将粗体设置为@racket[weight-on]。}

@item{@;{If @racket[weight-off] is not @racket['base], then the weight will be set back 
to @racket['normal] when the base style has the weight @racket[weight-off].}
        如果@racket[weight-off]不是@racket['base]，则当基本样具有粗体@racket['normal]时，粗体将设置回@racket['normal]。}

@item{@;{If both @racket[weight-on] and @racket[weight-off] are set to the same
value, then the weight is toggled with respect to that value: if
the base style has the weight @racket[weight-on], then weight is changed to
@racket['normal]; if the base style has a different weight, it is changed to
@racket[weight-on].}
        如果@racket[weight-on]和@racket[weight-off]都设置为相同的值，则相对于该值切换粗体：如果基本样式具有@racket[weight-on]，则粗体更改为@racket['normal]；如果基本样式具有不同的粗体，则更改为@racket[weight-on]。}

@item{@;{If both @racket[weight-on] and @racket[weight-off] are set, but to
different values, then the weight is changed to @racket[weight-on] 
only when the base style has the weight @racket[weight-off].}
        如果同时设置了@racket[weight-on]和@racket[weight-off]，但值不同，则仅当基本样式@racket[weight-off]时，才会将粗体更改为@racket[weight-on]。}
]

@;{Font styles, smoothing, underlining, and alignment work in an analogous manner.}
字体样式、平滑、下划线和对齐以类似的方式工作。

@;{The possible values for @racket[alignment-on] and @racket[alignment-off] are:}
  @racket[alignment-on]和@racket[alignment-off]的可能值为：
  
@itemize[
@item{@indexed-racket['base]}
@item{@indexed-racket['top]}
@item{@indexed-racket['center]}
@item{@indexed-racket['bottom]}
]

@;{The possible values for @racket[style-on] and @racket[style-off] are:}
  @racket[style-on]和@racket[style-off]的可能值为：
  
@itemize[
@item{@indexed-racket['base]}
@item{@indexed-racket['normal]}
@item{@indexed-racket['italic]}
@item{@indexed-racket['slant]}
]

@;{The possible values for @racket[smoothing-on] and @racket[smoothing-off] are:}
  @racket[smoothing-on]和@racket[smoothing-off]的可能值为：
  
@itemize[
@item{@indexed-racket['base]}
@item{@indexed-racket['default]}
@item{@indexed-racket['partly-smoothed]}
@item{@indexed-racket['smoothed]}
@item{@indexed-racket['unsmoothed]}
]

@;{The possible values for @racket[underlined-on] and @racket[underlined-off] are:}
  @racket[underlined-on]和@racket[underlined-off]的可能值为：
  
@itemize[
@item{@racket[#f] (@;{acts like }相当于@racket['base])}
@item{@racket[#t]}
]

@;{The possible values for @racket[size-in-pixels-on] and
@racket[size-in-pixels-off] are:}
  @racket[size-in-pixels-on]和@racket[size-in-pixels-off]的可能值为：
  
@itemize[
@item{@racket[#f] (@;{acts like }相当于@racket['base])}
@item{@racket[#t]}
]

@;{The possible values for @racket[transparent-text-backing-on] and 
@racket[transparent-text-backing-off] are:}
  @racket[transparent-text-backing-on]和@racket[transparent-text-backing-off]的可能值为：
  
@itemize[
@item{@racket[#f] (@;{acts like }相当于@racket['base])}
@item{@racket[#t]}
]

@;{The possible values for @racket[weight-on] and @racket[weight-off] are:}
  @racket[weight-on]和@racket[weight-off] 的可能值为：
  
@itemize[
@item{@indexed-racket['base]}
@item{@indexed-racket['normal]}
@item{@indexed-racket['bold]}
@item{@indexed-racket['light]}
]

@;{The family and face settings in a style delta are interdependent:}
样式增量中的系列和表面设置相互依赖：

@itemize[

 @item{@;{When a delta's face is @racket[#f] and its family is
       @racket['base], then neither the face nor family are modified by
       the delta.}
         当一个delta的表面（face）是@racket[#f]，它的系列（family）是@racket['base]，那么这表面和系列都不会被delta所改变。}

 @item{@;{When a delta's face is a string and its family is
       @racket['base], then only face is modified by the delta.}
         当一delta的表面是一个字符串并且它的系列是@racket['base]时，那么只有表面是由delta修改的。}

 @item{@;{When a delta's family is not @racket['base], then both the face
       and family are modified by the delta. If the delta's face is
       @racket[#f], then applying the delta sets a style's face to
       @racket[#f], so that the family setting prevails in choosing a
       font.}
         当delta的系列不是@racket['base]时，表面和系列都会被delta修改。如果delta的表面为@racket[#f]，则应用delta将样式的面设置为@racket[#f]，以便在选择字体时使用系列设置。}

]


@defconstructor*/make[(([change-command (or/c 'change-nothing
                                              'change-normal
                                              'change-toggle-underline
                                              'change-toggle-size-in-pixels
                                              'change-normal-color
                                              'change-bold)
                                        'change-nothing])
                       ([change-command (or/c 'change-family
                                              'change-style
                                              'change-toggle-style
                                              'change-weight
                                              'change-toggle-weight
                                              'change-smoothing
                                              'change-toggle-smoothing
                                              'change-alignment)]
                        [v symbol])
                       ([change-command (or/c 'change-size
                                              'change-bigger
                                              'change-smaller)]
                        [v byte?])
                       ([change-command (or/c 'change-underline
                                              'change-size-in-pixels)]
                        [v any/c]))]{

@;{The initialization arguments are passed on to
 @method[style-delta% set-delta].}
  初始化参数被传递给@method[style-delta% set-delta]。
}


@defmethod[(collapse [delta (is-a?/c style-delta%)])
           boolean?]{

@;{Tries to collapse into a single delta the changes that would be made
 by applying this delta after a given delta. If the return value is
 @racket[#f], then it is impossible to perform the
 collapse. Otherwise, the return value is @racket[#t] and this delta
 will contain the collapsed change specification.}
  尝试将在给定增量之后应用此增量所做的更改折叠为单个增量。如果返回值为@racket[#f]，则不可能执行折叠。否则，返回值是@racket[#t]，这个delta将包含折叠的变更规范。

}

@defmethod[(copy [delta (is-a?/c style-delta%)]) void?]{
  @;{Copies the given style delta's settings into this one.}
    将给定样式增量的设置复制到此样式增量中。
    }

@defmethod[(equal? [delta (is-a?/c style-delta%)]) boolean?]{
  @;{Returns @racket[#t] if the given delta is equivalent to this one in
  all contexts or @racket[#f] otherwise.}
    如果给定的delta在所有上下文中都等于此delta，则返回@racket[#t]，否则返回@racket[#f]。
    }

@defmethod[(get-alignment-off) (or/c 'base 'top 'center 'bottom)]{
  @;{See @racket[style-delta%].}
    请参见@racket[style-delta%]。
 }

@defmethod[(get-alignment-on) (or/c 'base 'top 'center 'bottom)]{
  @;{See @racket[style-delta%].}
    请参见@racket[style-delta%]。
 }

@defmethod[(get-background-add) (is-a?/c add-color<%>)]{

@;{Gets the object additive color shift for the background (applied after
 the multiplicative factor). Call this @racket[add-color<%>] object's
 methods to change the style delta's additive background color shift.}
  获取背景的对象加法颜色偏移（在乘法因子之后应用）。调用这个@racket[add-color<%>]对象的方法来更改样式delta的附加背景色偏移。

}

@defmethod[(get-background-mult)
           (is-a?/c mult-color<%>)]{

@;{Gets the multiplicative color shift for the background (applied before
 the additive factor). Call this @racket[mult-color<%>] object's
 methods to change the style delta's multiplicative background color
 shift.}
 获取背景的乘法颜色偏移（在加法因子之前应用）。调用此@racket[mult-color<%>]对象的方法以更改样式delta的乘法背景色偏移。 

}

@defmethod[(get-face)
           (or/c string? #f)]{

@;{Gets the delta's font face string. If this string is @racket[#f] and the
 family is @indexed-racket['base] when the delta is applied to a style,
 the style's face and family are not changed. However, if the face
 string is @racket[#f] and the family is not @indexed-racket['base], then
 the style's face is changed to @racket[#f].}
获取增量的字体字符串。如果此字符串是@racket[#f]，并且当delta应用于样式时，系列是@indexed-racket['base]，则样式的表面和系列不会更改。但是，如果表面字符串是@racket[#f]，而系列不是@indexed-racket['base]，则样式的表面将更改为@racket[#f]。
  
@;{See also @method[style-delta% get-family].}
  另请参见@method[style-delta% get-family]。

}

@defmethod[(get-family)
           (or/c 'base 'default 'decorative 'roman 'script 
                 'swiss 'modern 'symbol 'system)]{

@;{Returns the delta's font family. The possible values are}
  返回delta的字体系列。可能的值是
  
@itemize[
@item{@indexed-racket['base]@;{ --- no change to family}——系列没有变化}
@item{@indexed-racket['default]}
@item{@indexed-racket['decorative]}
@item{@indexed-racket['roman]}
@item{@indexed-racket['script]}
@item{@indexed-racket['swiss]}
@item{@indexed-racket['modern] (@;{fixed width}固定宽度)}
@item{@indexed-racket['symbol] (@;{Greek letters}希腊字母)}
@item{@indexed-racket['system] (@;{used to draw control labels}用于绘制控件标签)}
]

@;{See also @method[style-delta% get-face].}
  也参见@method[style-delta% get-face]。

}

@defmethod[(get-foreground-add) (is-a?/c add-color<%>)]{

@;{Gets the additive color shift for the foreground (applied after the
 multiplicative factor). Call this @racket[add-color<%>] object's
 methods to change the style delta's additive foreground color shift.}
  获取前景的附加色移（在乘法因子之后应用）。调用这个@racket[add-color<%>]对象的方法来更改样式delta的加法前景颜色偏移。

}

@defmethod[(get-foreground-mult)
           (is-a?/c mult-color<%>)]{

@;{Gets the multiplicative color shift for the foreground (applied before
 the additive factor). Call this @racket[mult-color<%>] object's
 methods to change the style delta's multiplicative foreground color
 shift.}
 获取前景的乘法颜色偏移（在加法因子之前应用）。调用此@racket[mult-color<%>]对象的方法以更改样式delta的乘法前景颜色偏移。 

}

@defmethod[(get-size-add) byte?]{
  @;{Gets the additive font size shift (applied after the multiplicative factor).}
 获取加性字体大小偏移（在乘因子之后应用）。
 }

@defmethod[(get-size-in-pixels-off) boolean?]{
  @;{See @racket[style-delta%].}
参见@racket[style-delta%]。
 }

@defmethod[(get-size-in-pixels-on) boolean?]{
  @;{See @racket[style-delta%].}
参见@racket[style-delta%]。
 }

@defmethod[(get-size-mult) real?]{
  @;{Gets the multiplicative font size shift (applied before the additive factor).}
    获取乘性字体大小偏移（在加法因子之前应用）。
 }

@defmethod[(get-smoothing-off)
           (or/c 'base 'default 'partly-smoothed 'smoothed 'unsmoothed)]{
  @;{See @racket[style-delta%].}
参见@racket[style-delta%]。
}

@defmethod[(get-smoothing-on)
           (or/c 'base 'default 'partly-smoothed 'smoothed 'unsmoothed)]{
  @;{See @racket[style-delta%].}
参见@racket[style-delta%]。
}

@defmethod[(get-style-off)
           (or/c 'base 'normal 'italic 'slant)]{
  @;{See @racket[style-delta%].}
参见@racket[style-delta%]。
}

@defmethod[(get-style-on) (or/c 'base 'normal 'italic 'slant)]{
  @;{See @racket[style-delta%].}
参见@racket[style-delta%]。
}

@defmethod[(get-transparent-text-backing-off) boolean?]{
  @;{See @racket[style-delta%].}
参见@racket[style-delta%]。
}

@defmethod[(get-transparent-text-backing-on) boolean?]{
  @;{See @racket[style-delta%].}
参见@racket[style-delta%]。
}
@defmethod[(get-underlined-off)
           boolean?]{
  @;{See @racket[style-delta%].}
参见@racket[style-delta%]。
}

@defmethod[(get-underlined-on)
           boolean?]{
  @;{See @racket[style-delta%].}
参见@racket[style-delta%]。
}

@defmethod[(get-weight-off) (or/c 'base 'normal 'bold 'light)]{
  @;{See @racket[style-delta%].}
参见@racket[style-delta%]。
}

@defmethod[(get-weight-on) (or/c 'base 'normal 'bold 'light)]{
  @;{See @racket[style-delta%].}
参见@racket[style-delta%]。
}

@defmethod[(set-alignment-off [v (or/c 'base 'top 'center 'bottom)]) void?]{
  @;{See @racket[style-delta%].}
参见@racket[style-delta%]。
}

@defmethod[(set-alignment-on [v (or/c 'base 'top 'center 'bottom)]) void?]{
  @;{See @racket[style-delta%].}
参见@racket[style-delta%]。
}

@defmethod*[([(set-delta [change-command (or/c 'change-nothing
                                               'change-normal
                                               'change-toggle-underline
                                               'change-toggle-size-in-pixels
                                               'change-normal-color
                                               'change-bold)
                                         'change-nothing])
              (is-a?/c style-delta%)]
             [(set-delta [change-command (or/c 'change-family
                                               'change-style
                                               'change-toggle-style
                                               'change-weight
                                               'change-toggle-weight
                                               'change-smoothing
                                               'change-toggle-smoothing
                                               'change-alignment)]
                         [param symbol?])
              (is-a?/c style-delta%)]
             [(set-delta [change-command (or/c 'change-size
                                               'change-bigger
                                               'change-smaller)]
                         [param byte?])
              (is-a?/c style-delta%)]
             [(set-delta [change-command (or/c 'change-underline
                                               'change-size-in-pixels)]
                         [on? any/c])
              (is-a?/c style-delta%)])]{

@;{Configures the delta with high-level specifications.  The return value
 is the delta itself.}
  使用高级规范配置增量。返回值是delta本身。

@;{Except for @racket['change-nothing] and
 @racket['change-normal], the command only changes part of the
 delta. Thus, applying @racket['change-bold] and then
 @racket['change-italic] sets the delta for both the style and
 weight change.}
  除了@racket['change-nothing]和@racket['change-normal]之外，该命令只更改delta的一部分。因此，应用@racket['change-bold]和@racket['change-italic]设置样式和权重更改的增量。

@;{The @racket[change-command] argument specifies how the delta is changed;
the possible values are:}
@racket[change-command]参数指定增量的更改方式；可能的值为：

@itemize[
@item{@racket['change-nothing]@;{ --- reset all changes}——重置所有更改}
@item{@racket['change-normal]@;{ --- turn off all styles and resizings}——关闭所有样式和大小调整}
@item{@racket['change-toggle-underline]@;{ --- underline regions that are currently not underlined, and vice versa}——为当前没有下划线的区域加下划线，反之亦然}
@item{@racket['change-toggle-size-in-pixels]@;{ --- interpret sizes in pixels for regions that are currently interpreted in points, and vice versa}——为当前以点为单位的区域解释以像素为单位的大小，反之亦然}
@item{@racket['change-normal-color]@;{ --- change the foreground and background to black and white, respectively}——分别将前景和背景更改为黑色和白色}
@item{@racket['change-italic]@;{ --- change the style of the font to @italic{italic}}——将字体样式更改为@italic{斜体}}
@item{@racket['change-bold]@;{ --- change the weight of the font to @bold{bold}}——将字体的粗体更改为@bold{粗体}}
@item{@racket['change-family]@;{ --- change the font family (@racket[param] is a family; see
@racket[font%]); see also
@method[style-delta% get-family]}——更改字体系列（@racket[param]是一个系列；请参阅@racket[font%]）；另请参阅@method[style-delta% get-family]}          @item{@racket['change-style]@;{ --- change the style of the font (@racket[param] is a style; see
            @racket[font%])}——更改字体的样式（@racket[param]是样式；请参阅@racket[font%]）}
@item{@racket['change-toggle-style]@;{ --- toggle the style of the font (@racket[param] is a style; see
@racket[font%])}——切换字体样式（@racket[param]是一种样式；请参见@racket[font%]）}
@item{@racket['change-weight]@;{ --- change the weight of the font (@racket[param] is a weight; see
@racket[font%])}——更改字体的粗体（@racket[param]是粗体；请参阅@racket[font%]）}
@item{@racket['change-toggle-weight]@;{ --- toggle the weight of the font (@racket[param] is a weight; see
@racket[font%])}——切换字体的权重（@racket[param]是权重；请参阅@racket[font%]）}
@item{@racket['change-smoothing]@;{ --- change the smoothing of the font (@racket[param] is a smoothing; see
@racket[font%])}——更改字体的平滑（@racket[param]是平滑；请参见@racket[font%]）}
@item{@racket['change-toggle-smoothing]@;{ --- toggle the smoothing of the font (@racket[param] is a smoothing; see
@racket[font%])}）——切换字体的平滑（@racket[param]是平滑；请参见@racket[font%]）}
@item{@racket['change-alignment]@;{ --- change the alignment (@racket[param] is an alignment; see
@racket[style-delta%])}——更改对齐方式（@racket[param]是对齐方式；请参见@racket[style-delta%]}
@item{@racket['change-size]@;{ --- change the size to an absolute value (@racket[param] is a size)}——将大小更改为绝对值（@racket[param]是大小）}
@item{@racket['change-bigger]@;{ --- make the text larger (@racket[param] is an additive amount)}——使文本更大（@racket[param]是一个加法量）}
@item{@racket['change-smaller]@;{ --- make the text smaller (@racket[param] is an additive amount)}——使文本变小（@racket[param]是一个加法量）}
@item{@racket['change-underline]@;{ --- set the underline status to either underlined or plain}——将下划线状态设置为带下划线或纯下划线}
@item{@racket['change-size-in-pixels]@;{ --- set the size interpretation to pixels or points}——将大小解释设置为像素或点}
]
}


@defmethod*[([(set-delta-background [name string?])
              (is-a?/c style-delta%)]
             [(set-delta-background [color (is-a?/c color%)])
              (is-a?/c style-delta%)])]{

@;{Makes the delta encode a background color change to match the absolute
 color given; that is, it sets the multiplicative factors to
 @racket[0.0] in the result of @method[style-delta%
 get-background-mult], and it sets the additive values in the result
 of @method[style-delta% get-background-add] to the specified color's
 values.  In addition, it also disables transparent text backing by
 setting @racket[transparent-text-backing-on] to @racket[#f] and
 @racket[transparent-text-backing-off] to @racket[#t].
 The return value of the method is the delta itself.}
  使delta编码背景颜色更改以匹配给定的绝对颜色；即，它在@method[style-delta%
 get-background-mult]的结果中将乘法因子设置为@racket[0.0]，并在@method[style-delta% get-background-add]的结果中将加法值设置为指定颜色的值。此外，它还通过将@racket[transparent-text-backing-on]设置为@racket[#f]，将@racket[transparent-text-backing-off]设置为@racket[#t]。该方法的返回值是delta本身。

@;{For the case that a string color name is supplied, see
 @racket[color-database<%>].}
  对于提供字符串颜色名称的情况，请参见@racket[color-database<%>]。

}

@defmethod[(set-delta-face [name string?]
                           [family (or/c 'base 'default 'decorative 'roman
                                         'script 'swiss 'modern 'symbol 'system)
                                   'default])
           (is-a?/c style-delta%)]{

@;{Like @method[style-delta% set-face], but sets the family at the same
 time.}
  就像@method[style-delta% set-face]，但同时设定了系列。

@;{The return value is @this-obj[].}
 返回值是@this-obj[]。 

}


@defmethod*[([(set-delta-foreground [name string?])
              (is-a?/c style-delta%)]
             [(set-delta-foreground [color (is-a?/c color%)])
              (is-a?/c style-delta%)])]{

@;{Makes the delta encode a foreground color change to match the absolute
 color given; that is, it sets the multiplicative factors to
 @racket[0.0] in the result of @method[style-delta%
 get-foreground-mult], and it sets the additive values in the result
 of @method[style-delta% get-foreground-add] to the specified color's
 values.  The return value of the method is the delta itself.}
  使delta编码前景颜色更改以匹配给定的绝对颜色；即，它在@method[style-delta%
 get-foreground-mult]的结果中将乘法因子设置为@racket[0.0]，并在@method[style-delta% get-foreground-add]的结果中将加法值设置为指定颜色的值。方法的返回值是delta本身。

@;{For the case that a string color name is supplied, see
 @racket[color-database<%>].}
  对于提供字符串颜色名称的情况，请参见@racket[color-database<%>]。

}


@defmethod[(set-face [v (or/c string? #f)])
           void?]{
  @;{See
@method[style-delta% get-face]. See also
@method[style-delta% set-delta-face].}
    参见@method[style-delta% get-face]。另请参见@method[style-delta% set-delta-face]。

}

@defmethod[(set-family [v (or/c 'base 'default 'decorative 'roman 'script
                                'swiss 'modern 'symbol 'system)])
           void?]{
@;{Sets the delta's font family. See
@method[style-delta% get-family].}
  设置delta的字体系列。请参见@method[style-delta% get-family]。

}

@defmethod[(set-size-add [v byte?]) void?]{
  @;{Sets the additive font size shift (applied
  after the multiplicative factor).}
    设置加性字体大小偏移（在乘因子之后应用）。}

@defmethod[(set-size-in-pixels-off [v any/c]) void?]{
  @;{See @racket[style-delta%].}
 请参见@racket[style-delta%]。}

@defmethod[(set-size-in-pixels-on [v any/c]) void?]{
  @;{See @racket[style-delta%].}
 请参见@racket[style-delta%]。}

@defmethod[(set-size-mult [v real?]) void?]{
  @;{Sets the multiplicative font size shift (applied before the additive factor).}
    设置乘法字体大小偏移（在加法因子之前应用）。}

@defmethod[(set-smoothing-off [v (or/c 'base 'default 'partly-smoothed
                                       'smoothed 'unsmoothed)])
           void?]{
  @;{See @racket[style-delta%].}
 请参见@racket[style-delta%]。}

@defmethod[(set-smoothing-on [v (or/c 'base 'default 'partly-smoothed
                                      'smoothed 'unsmoothed)])
           void?]{
  @;{See @racket[style-delta%].}
 请参见@racket[style-delta%]。}

@defmethod[(set-style-off [v (or/c 'base 'normal 'italic 'slant)])
           void?]{
  @;{See @racket[style-delta%].}
 请参见@racket[style-delta%]。}

@defmethod[(set-style-on [v (or/c 'base 'normal 'italic 'slant)])
           void?]{
  @;{See @racket[style-delta%].}
 请参见@racket[style-delta%]。}

@defmethod[(set-transparent-text-backing-off [v any/c])
           void?]{
  @;{See @racket[style-delta%].}
 请参见@racket[style-delta%]。}

@defmethod[(set-transparent-text-backing-on [v any/c]) void?]{
  @;{See @racket[style-delta%].}
 请参见@racket[style-delta%]。}

@defmethod[(set-underlined-off [v any/c]) void?]{
  @;{See @racket[style-delta%].}
 请参见@racket[style-delta%]。}

@defmethod[(set-underlined-on [v any/c])
           void?]{
  @;{See @racket[style-delta%].}
 请参见@racket[style-delta%]。}

@defmethod[(set-weight-off [v (or/c 'base 'normal 'bold 'light)])
           void?]{
  @;{See @racket[style-delta%].}
 请参见@racket[style-delta%]。}

@defmethod[(set-weight-on [v (or/c 'base 'normal 'bold 'light)])
           void?]{
  @;{See @racket[style-delta%].}
 请参见@racket[style-delta%]。}

}
