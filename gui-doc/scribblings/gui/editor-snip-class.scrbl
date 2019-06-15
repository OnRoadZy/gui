#lang scribble/doc
@(require "common.rkt")

@defclass/title[editor-snip% snip% ()]{

@;{An @racket[editor-snip%] object is a @racket[snip%] object that
 contains and displays an @racket[editor<%>] object. This snip class
 is used to insert an editor as a single @techlink{item} within
 another editor.}
@racket[editor-snip%]对象是一个@racket[snip%]对象，它包含并显示一个@racket[editor<%>]对象。这个剪切类用于将一个编辑器作为单个@techlink{项}插入到另一个编辑器中。

@defconstructor[([editor (or/c (is-a?/c editor<%>) #f) #f]
                 [with-border? any/c #t]
                 [left-margin exact-nonnegative-integer? 5]
                 [top-margin exact-nonnegative-integer? 5]
                 [right-margin exact-nonnegative-integer? 5]
                 [bottom-margin exact-nonnegative-integer? 5]
                 [left-inset exact-nonnegative-integer? 1]
                 [top-inset exact-nonnegative-integer? 1]
                 [right-inset exact-nonnegative-integer? 1]
                 [bottom-inset exact-nonnegative-integer? 1]
                 [min-width (or/c (and/c real? (not/c negative?)) 'none) 'none]
                 [max-width (or/c (and/c real? (not/c negative?)) 'none) 'none]
                 [min-height (or/c (and/c real? (not/c negative?)) 'none) 'none]
                 [max-height (or/c (and/c real? (not/c negative?)) 'none) 'none])]{

@;{If @racket[editor] is non-@racket[#f], then it will be used as the
 editor contained by the snip. See also @method[editor-snip%
 set-editor].}
  如果@racket[editor]是非@racket[#f]，那么它将用作剪切包含的编辑器。另请参见@method[editor-snip%
 set-editor]。

@;{If @racket[with-border?] is not @racket[#f], then a border will be drawn
 around the snip. The editor display will be inset in the snip area by
 the amounts specified in the @racket[-margin] arguments.  The border
 will be drawn with an inset specified by the @racket[-inset] arguments.}
如果@racket[with-border?]不是@racket[#f]，则将在剪切周围绘制边界。编辑器显示将按@racket[-margin]参数中指定的数量插入剪切区域。将使用@racket[-inset]参数指定的inset绘制边框。  

@;{See @method[editor-snip% get-inset] and @method[editor-snip%
get-margin] for information about the inset and margin arguments.}
有关嵌入和边距参数的信息，请参见@method[editor-snip% get-inset]和@method[editor-snip%
get-margin]。

}


@defmethod[#:mode override 
           (adjust-cursor [dc (is-a?/c dc<%>)]
                          [x real?]
                          [y real?]
                          [editorx real?]
                          [editory real?]
                          [event (is-a?/c mouse-event%)])
           (or/c (is-a?/c cursor%) #f)]{

@;{Gets a cursor from the embedded editor by calling its
@method[editor<%> adjust-cursor] method.}
  通过调用其@method[editor<%> adjust-cursor]方法从嵌入的编辑器中获取光标。

}


@defmethod[(border-visible?)
           boolean?]{

@;{Returns @racket[#t] if the snip has a border draw around it,
@racket[#f] otherwise.}
如果剪切周围有边框，则返回@racket[#t]，否则返回@racket[#f]。

@;{See also @method[editor-snip% show-border].}
另请参见@method[editor-snip% show-border]。
}


@defmethod[(get-align-top-line)
           boolean?]{

@;{Reports whether the snip is in align-top-line mode. See
@method[editor-snip% get-extent] for more information.}
  报告剪切是否处于对齐顶行模式。有关更多信息，请参阅@method[editor-snip% get-extent]。

@;{See also @method[editor-snip% set-align-top-line].}
  另请参见@method[editor-snip% set-align-top-line]。

}


@defmethod[(get-editor)
           (or/c (or/c (is-a?/c text%) (is-a?/c pasteboard%)) #f)]{

@;{Returns the editor contained by the snip, or @racket[#f] is there is
 no editor.}
  返回剪切包含的编辑器，或者没有编辑器返回@racket[#f]。

}

@defmethod[#:mode override 
           (get-extent [dc (is-a?/c dc<%>)]
                       [x real?]
                       [y real?]
                       [w (or/c (box/c (and/c real? (not/c negative?))) #f) #f]
                       [h (or/c (box/c (and/c real? (not/c negative?))) #f) #f]
                       [descent (or/c (box/c (and/c real? (not/c negative?))) #f) #f]
                       [space (or/c (box/c (and/c real? (not/c negative?))) #f) #f]
                       [lspace (or/c (box/c (and/c real? (not/c negative?))) #f) #f]
                       [rspace (or/c (box/c (and/c real? (not/c negative?))) #f) #f])
           void?]{

@;{Calls its editor's @method[editor<%> get-extent] method, then adds the
 editor snip's margins.}
  调用编辑器的@method[editor<%> get-extent]方法，然后添加编辑器剪切的边距。

@;{The top space always corresponds to the space of the editor's top
 line, plus the snip's top margin. Normally, the descent corresponds
 to the descent of the editor's last line plus the snip's bottom
 margin. However, if the snip is in align-top-line mode (see
 @method[editor-snip% set-align-top-line]), the descent corresponds to
 the descent of the top line, plus the height rest of the editor's
 lines, plus the snip's bottom margin.}
  顶部空间总是对应于编辑器顶行的空间，加上剪切的上边缘。通常，下降对应于编辑最后一行的下降加上剪切的下边距。但是，如果剪切处于对齐顶行模式（请参见@method[editor-snip% set-align-top-line]），则下降对应于顶行的下降，加上编辑器行的其余高度，再加上剪切的下边距。

@;{If the editor is a text editor, then @racket[1] is normally subtracted
 from the editor's width as returned by @method[editor<%> get-extent],
 because the result looks better for editing.  If the snip is in
 tight-text-fit mode (see @method[editor-snip% set-tight-text-fit])
 then @racket[2] is subtracted from a text editor's width, eliminating
 the two pixels that the text editor reserves for the blinking
 caret. In addition, tight-text-fit mode subtracts an amount equal to
 the line spacing from the editor's height. By default, tight-text-fit
 mode is disabled.}
  如果编辑器是文本编辑器，那么通常从@method[editor<%> get-extent]返回的编辑器宽度中减去@racket[1]，因为结果看起来更适合编辑。如果剪切处于文本调整模式（请参见@method[editor-snip% set-tight-text-fit]），则从文本编辑器的宽度中减去@racket[2]，从而消除文本编辑器为闪烁插入符号保留的两个像素。此外，紧致文本适应（tight-text-fit）模式从编辑器高度减去等于行距的量。默认情况下，将禁用紧致文本适应模式。

}


@defmethod[(get-inset [l (box/c exact-nonnegative-integer?)]
                      [t (box/c exact-nonnegative-integer?)]
                      [r (box/c exact-nonnegative-integer?)]
                      [b (box/c exact-nonnegative-integer?)])
           void?]{

@;{Gets the current border insets for the snip. The inset sets how much space
is left between the edge of the snip and the border.}
获取剪切的当前边框嵌入。嵌入设置了剪切边缘和边框之间的剩余空间。  

@;{@boxisfill[@racket[l] @elem{left inset}]
@boxisfill[@racket[t] @elem{top inset}]
@boxisfill[@racket[r] @elem{right inset}]
@boxisfill[@racket[b] @elem{bottom inset}]}
  @boxisfill[@racket[l] @elem{左嵌入}]
@boxisfill[@racket[t] @elem{顶嵌入}]
@boxisfill[@racket[r] @elem{右嵌入}]
@boxisfill[@racket[b] @elem{底嵌入}]

}


@defmethod[(get-margin [l (box/c exact-nonnegative-integer?)]
                       [t (box/c exact-nonnegative-integer?)]
                       [r (box/c exact-nonnegative-integer?)]
                       [b (box/c exact-nonnegative-integer?)])
           void?]{

@;{Gets the current margins for the snip. The margin sets how much space
is left between the edge of the editor's contents and the edge of the
snip.}
  获取剪切的当前边距。边距设置编辑器内容边缘和剪切边缘之间的空白空间。

@;{@boxisfill[@racket[l] @elem{left margin}]
@boxisfill[@racket[t] @elem{top margin}]
@boxisfill[@racket[r] @elem{right margin}]
@boxisfill[@racket[b] @elem{bottom margin}]}
  @boxisfill[@racket[l] @elem{左边距}]
@boxisfill[@racket[t] @elem{顶边距}]
@boxisfill[@racket[r] @elem{右边距}]
@boxisfill[@racket[b] @elem{底边距}]

}


@defmethod[(get-max-height)
           (or/c (and/c real? (not/c negative?)) 'none)]{

@;{Gets the maximum display height of the snip; zero or @racket['none]
 indicates that there is no maximum.}
  获取剪切的最大显示高度；零或@racket['none]表示没有最大值。

}


@defmethod[(get-max-width)
           (or/c (and/c real? (not/c negative?)) 'none)]{

@;{Gets the maximum display width of the snip; zero or @racket['none]
 indicates that there is no maximum.}
  获取剪切的最大显示宽度；零或@racket['none]表示没有最大值。

}

@defmethod[(get-min-height)
           (or/c (and/c real? (not/c negative?)) 'none)]{

@;{Gets the minimum display height of the snip; zero or @racket['none]
 indicates that there is no minimum.}
  获取剪切的最小显示高度；零或@racket['none]表示没有最小值。

}

@defmethod[(get-min-width)
           (or/c (and/c real? (not/c negative?)) 'none)]{

@;{Gets the minimum display width of the snip; zero or @racket['none]
 indicates that there is no minimum.}
 获取剪切的最小显示宽度；零或@racket['none]表示没有最小值。

}

@defmethod[(get-tight-text-fit)
           boolean?]{

@;{Reports whether the snip is in tight-text-fit mode. See
@method[editor-snip% get-extent] for more information.}
  报告剪切是否处于紧致文本适应（tight-text-fit）模式。有关更多信息，请参阅@method[editor-snip% get-extent]。

@;{See also @method[editor-snip% set-tight-text-fit].}
  另请参见@method[editor-snip% set-tight-text-fit]。

}

@defmethod[#:mode override 
           (resize [w (and/c real? (not/c negative?))]
                   [h (and/c real? (not/c negative?))])
           boolean?]{

@;{Sets the snip's minimum and maximum width and height to the specified
 values minus the snip border space. See also @method[editor-snip%
 set-min-width] @method[editor-snip% set-max-width]
 @method[editor-snip% set-max-height] @method[editor-snip%
 set-min-height].}
 将剪切的最小和最大宽度和高度设置为指定值减去剪切边框空间。另请参见@method[editor-snip%
 set-min-width]、@method[editor-snip% set-max-width]、@method[editor-snip% set-max-height]、@method[editor-snip%
 set-min-height]。 

@;{Also sets the minimum and maximum width of the editor owned by the
 snip to the given width (minus the snip border space) via
 @method[editor<%> set-max-width] and @method[editor<%>
 set-min-width].}
  还可以通过@method[editor<%> set-max-width]和@method[editor<%>
 set-min-width]，将剪切拥有的编辑器的最小和最大宽度设置为给定的宽度（减去剪切边框空间）。

}

@defmethod[(set-align-top-line [tight? any/c])
           void?]{

@;{Enables or disables align-top-line mode. See @method[editor-snip%
 get-extent] for more information.}
  启用或禁用对齐顶行模式。有关更多信息，请参阅@method[editor-snip%
 get-extent]。

@;{See also @method[editor-snip% get-align-top-line].}
  另请参见@method[editor-snip% get-align-top-line]。

}

@defmethod[(set-editor [editor (or/c (or/c (is-a?/c text%) (is-a?/c pasteboard%)) #f)])
           void?]{

@;{Sets the editor contained by the snip, releasing the old editor in the
 snip (if any). If the new editor already has an administrator, then
 the new editor is @italic{not} installed into the snip.}
  设置剪切包含的编辑器，释放剪切中的旧编辑器（如果有）。如果新的编辑器已经有了管理员，那么新的编辑器@italic{不}会安装到剪切中。

@;{When an @racket[editor-snip%] object is not inserted in an editor, it
 does not have an administrator. During this time, it does not give
 its contained editor an administrator, either. The administratorless
 contained editor can therefore ``defect'' to some other
 @techlink{display} with an administrator. When a contained editor
 defects and the snip is eventually inserted into a different editor,
 the snip drops the traitor contained editor, setting its contained
 editor to @racket[#f].}
  当@racket[editor-snip%]对象未插入到编辑器中时，它没有管理员。在这段时间内，它也不会给所包含的编辑器一个管理员。因此，无管理员包含的编辑器可以“缺陷”到管理员的其他@techlink{显示}。当一个被包含的编辑器出现故障，并且剪切最终被插入到另一个编辑器中时，剪切将删除被包含的故障编辑器，并将其包含的编辑器设置为@racket[#f]。

}

@defmethod[(set-inset [l exact-nonnegative-integer?]
                      [t exact-nonnegative-integer?]
                      [r exact-nonnegative-integer?]
                      [b exact-nonnegative-integer?])
           void?]{

@;{Sets the current border insets for the snip. The inset sets how much
 space is left between the edge of the snip and the border.}
  设置剪切的当前边框嵌入。嵌入设置了剪切边缘和边框之间的空白空间。

}


@defmethod[(set-margin [l exact-nonnegative-integer?]
                       [t exact-nonnegative-integer?]
                       [r exact-nonnegative-integer?]
                       [b exact-nonnegative-integer?])
           void?]{

@;{Sets the current margins for the snip. The margin sets how much space
 is left between the edge of the editor's contents and the edge of the
 snip.}
  设置剪切的当前边距。边距设置编辑器内容边缘和剪切边缘之间的空白空间。

}

@defmethod[(set-max-height [h (or/c (and/c real? (not/c negative?)) 'none)])
           void?]{

@edsnipmax[@racket[height]]

@;{Zero or @racket['none] disables the limit.}
  零或@racket['none]禁用限制。

}

@defmethod[(set-max-width [w (or/c (and/c real? (not/c negative?)) 'none)])
           void?]{

@;{@edsnipmax[@racket[width]] The contained editor's width limits are not
 changed by this method.}
  @edsnipmax[@racket[width]]此方法不会更改包含的编辑器的宽度限制。

@;{Zero or @racket['none] disables the limit.}
  零或@racket['none]禁用限制。

}

@defmethod[(set-min-height [h (or/c (and/c real? (not/c negative?)) 'none)])
           void?]{

@edsnipmin[@racket[height] @elem{@;{top}顶}]
  

@;{Zero or @racket['none] disables the limit.}
  零或@racket['none]禁用限制。

}

@defmethod[(set-min-width [w (or/c (and/c real? (not/c negative?)) 'none)])
           void?]{

@;{@edsnipmin[@racket[width] @elem{@;{left}左}]@;{ The contained editor's width
 limits are not changed by this method.}此方法不会更改包含的编辑器的宽度限制。}
  

@;{Zero or @racket['none] disables the limit.}
零或@racket['none]禁用限制。
}

@defmethod[(set-tight-text-fit [tight? any/c])
           void?]{

@;{Enables or disables tight-text-fit mode. See @method[editor-snip%
 get-extent] for more information.}
 启用或禁用紧致文本适应（tight-text-fit）模式。有关更多信息，请参阅@method[editor-snip%
 get-extent]。 

@;{See also @method[editor-snip% get-tight-text-fit].}
  另请参见@method[editor-snip% get-tight-text-fit]。

}

@defmethod[(show-border [show? any/c])
           void?]{

@;{Shows or hides the snip's border.}
  显示或隐藏剪切的边框。

}


@defmethod[(style-background-used?)
           boolean?]{

@;{Returns @racket[#t] if the snip uses its style's background and
 transparency information when drawing, @racket[#f] otherwise.}
  如果剪切在绘制时使用其样式的背景和透明度信息，则返回@racket[#t]，否则返回@racket[#f]。

@;{See also @method[editor-snip% use-style-background].}
  另请参见@method[editor-snip% use-style-background]。

}


@defmethod[(use-style-background [use? any/c])
           void?]{

@;{Causes the snip to use or not used (the default) its style's
 background and transparency information for drawing the background
 within the snip's border.}
  使剪切使用或不使用（默认）其样式的背景和透明度信息，以便在剪切边框内绘制背景。

@;{If @racket[use?] is @racket[#f], the style background and transparency
information is ignored, otherwise is it used.}
  如果@racket[use?]是@racket[#f]，样式背景和透明度信息将被忽略，否则将被使用。

}}

