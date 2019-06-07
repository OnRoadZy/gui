#lang scribble/doc
@(require "common.rkt")

@definterface/title[style<%> ()]{

@;{A @racket[style<%>] object encapsulates drawing information (font,
 color, alignment, etc.) in a hierarchical manner. A @racket[style<%>]
 object always exists within the context of a @racket[style-list%]
 object and is never created except by a @racket[style-list%] object.}
  @racket[style<%>]对象以分层方式封装图形信息（字体、颜色、对齐方式等）。@racket[style<%>]对象始终存在于@racket[style-list%]对象的上下文中，除非由@racket[style-list%]对象创建，否则永远不会创建该对象。

@;{See also @|stylediscuss|.}
  另见@|stylediscuss|。

@defmethod[(get-alignment)
           (or/c 'top 'center 'bottom)]{

@;{Returns the style's alignment: @racket['top], @racket['center], or
 @racket['bottom].}
  返回样式的对齐方式：@racket['top]、@racket['center]或@racket['bottom]。

}


@defmethod[(get-background)
           (is-a?/c color%)]{

@;{Returns the style's background color.}
  返回样式的背景色。

}


@defmethod[(get-base-style)
           (or/c (is-a?/c style<%>) #f)]{

@;{Returns the style's base style. See @|stylediscuss| for more
 information. The return value is @racket[#f] only for the basic style
 in the list.}
  返回样式的基本样式。有关详细信息，请参见@|stylediscuss|。返回值为@racket[#f]仅适用于列表中的基本样式。

}

@defmethod[(get-delta [delta (is-a?/c style-delta%)])
           void?]{

@;{Mutates @racket[delta], changing it to match the style's delta, if the style is not a join
 style. See @|stylediscuss| for more information.}
  变异@racket[delta]，如果样式不是连接样式，则将其更改为与样式的delta匹配。有关详细信息，请参见@|stylediscuss|。

}

@defmethod[(get-face)
           (or/c string? #f)]{

@;{Returns the style's face name. See @racket[font%].}
  返回样式的表面名称。请参见@racket[font%]。

}


@defmethod[(get-family)
           (or/c 'default 'decorative 'roman 'script 
                 'swiss 'modern 'symbol 'system)]{

@;{Returns the style's font family. See @racket[font%].}
  返回样式的字体系列。请参见@racket[font%]。

}

@defmethod[(get-font)
           (is-a?/c font%)]{

@;{Returns the style's font information.}
  返回样式的字体信息。

}

@defmethod[(get-foreground)
           (is-a?/c color%)]{

@;{Returns the style's foreground color.}
  返回样式的前景色。

}

@defmethod[(get-name)
           (or/c string? #f)]{

@;{Returns the style's name, or @racket[#f] if it is unnamed. Style names
 are only set through the style's @racket[style-list%] object.}
  返回样式的名称，如果未命名，则返回@racket[#f]。仅通过样式的@racket[style-list%]对象设置样式名。

}

@defmethod[(get-shift-style)
           (is-a?/c style<%>)]{

@;{Returns the style's shift style if it is a join style. Otherwise, the
 root style is returned. See @|stylediscuss| for more information.}
  如果样式是联接样式，则返回该样式的移位样式。否则，将返回根样式。有关详细信息，请参见@|stylediscuss|。

}

@defmethod[(get-size) byte?]{
  @;{Returns the style's font size.}
返回样式的字体大小。
 }

@defmethod[(get-size-in-pixels)
           boolean?]{

@;{Returns @racket[#t] if the style size is in pixels, instead of points,
 or @racket[#f] otherwise.}
如果样式大小以像素为单位，而不是以点为单位，则返回@racket[#t]，否则返回@racket[#f]。
}

@defmethod[(get-smoothing)
           (or/c 'default 'partly-smoothed 'smoothed 'unsmoothed)]{

@;{Returns the style's font smoothing. See @racket[font%].}
  返回样式的字体平滑处理。请参见@racket[font%]。

}

@defmethod[(get-style)
           (or/c 'normal 'italic 'slant)]{

@;{Returns the style's font style. See @racket[font%].}
返回样式的字体样式。请参见@racket[font%]。
}

@defmethod[(get-text-descent [dc (is-a?/c dc<%>)])
           (and/c real? (not/c negative?))]{

@;{Returns the descent of text using this style in a given DC.}
返回在给定DC中使用此样式的文本下降。
}

@defmethod[(get-text-height [dc (is-a?/c dc<%>)])
           (and/c real? (not/c negative?))]{

@;{Returns the height of text using this style in a given DC.}
返回给定DC中使用此样式的文本高度。
}

@defmethod[(get-text-space [dc (is-a?/c dc<%>)])
           (and/c real? (not/c negative?))]{

@;{Returns the vertical spacing for text using this style in a given DC.}
返回给定DC中使用此样式的文本的垂直间距。
}

@defmethod[(get-text-width [dc (is-a?/c dc<%>)])
           (and/c real? (not/c negative?))]{

@;{Returns the width of a space character using this style in a given
DC.}
返回在给定DC中使用此样式的空格字符的宽度。
}

@defmethod[(get-transparent-text-backing)
           boolean?]{

@;{Returns @racket[#t] if text is drawn without erasing the
 text background or @racket[#f] otherwise.}
如果在不删除文本背景的情况下绘制文本，则返回@racket[#t]，否则返回@racket[#f]。
}

@defmethod[(get-underlined)
           boolean?]{

Returns @racket[#t] if the style is underlined or @racket[#f]
 otherwise.
如果样式带下划线，则返回@racket[#t]，否则返回@racket[#f]。
}

@defmethod[(get-weight)
           (or/c 'normal 'bold 'light)]{

@;{Returns the style's font weight. See @racket[font%].}
  返回样式的字体粗细。请参见@racket[font%]。

}

@defmethod[(is-join?)
           boolean?]{

@;{Returns @racket[#t] if the style is a join style or @racket[#f]
 otherwise. See @|stylediscuss| for more information.}
  如果样式是联接样式，则返回@racket[#t]，否则返回@racket[#f]。有关详细信息，请参见@|stylediscuss|。

}

@defmethod[(set-base-style [base-style (is-a?/c style<%>)])
           void?]{

@;{Sets the style's base style and recomputes the style's font, etc. See
 @|stylediscuss| for more information.}
  设置样式的基本样式并重新计算样式的字体等。有关详细信息，请参阅@|stylediscuss|。

}

@defmethod[(set-delta [delta (is-a?/c style-delta%)])
           void?]{

@;{Sets the style's delta (if it is not a join style) and recomputes the
style's font, etc. See @|stylediscuss| for more information.}
  设置样式的增量（如果不是联接样式），并重新计算样式的字体等。有关详细信息，请参阅@|stylediscuss|。

}

@defmethod[(set-shift-style [style (is-a?/c style<%>)])
           void?]{

@;{Sets the style's shift style (if it is a join style) and recomputes
the style's font, etc. See @|stylediscuss| for more information.}
  设置样式的移位样式（如果它是联接样式）并重新计算样式的字体等。有关详细信息，请参阅样式。

}

@defmethod[(switch-to [dc (is-a?/c dc<%>)]
                      [old-style (or/c (is-a?/c style<%>) #f)])
           void?]{

@;{Sets the font, pen color, etc. of the given drawing context. If
 @racket[oldstyle] is not @racket[#f], only differences between the
 given style and this one are applied to the drawing context.}
  设置给定绘图上下文的字体、笔颜色等。如果@racket[oldstyle]不是@racket[#f]，则仅给定样式和此样式之间的差异应用于绘图上下文。

}}

