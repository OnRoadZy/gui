#lang scribble/doc
@(require "common.rkt")

@defclass/title[image-snip% snip% ()]{

@;{An @racket[image-snip%] is a snip that can display bitmap images
 (usually loaded from a file). When the image file cannot be found, a
 box containing an ``X'' is drawn.}
@racket[image-snip%]是可以显示位图图像（通常从文件加载）的剪切。当找不到图像文件时，将绘制一个包含“X”的框。

@defconstructor*/make[(([file (or/c path-string? input-port? #f) #f]
                        [kind (or/c 'unknown 'unknown/mask 'unknown/alpha
                                    'gif 'gif/mask 'gif/alpha 
                                    'jpeg 'png 'png/mask 'png/alpha
                                    'xbm 'xpm 'bmp 'pict) 'unknown]
                        [relative-path? any/c #f]
                        [inline? any/c #t]
                        [backing-scale (>/c 0.0) 1.0])
                       ([bitmap (is-a?/c bitmap%)]
                        [mask (or/c (is-a?/c bitmap%) #f) #f]))]{

@;{Creates an image snip, loading the image @racket[file] if
 specified (see also @method[image-snip% load-file]), or using the
 given @racket[bitmap].}
创建图像剪切，如果指定，则加载图像@racket[file]（另请参见@method[image-snip% load-file]），或者使用给定的@racket[bitmap]。
  
@;{@history[#:changed "1.1" @elem{Added the @racket[backing-scale] argument.}]}
 @history[#:changed "1.1" @elem{添加@racket[backing-scale]参数。}]
 }


@defmethod[(equal-hash-code-of [hash-code (any/c . -> . exact-integer?)])
           exact-integer?]{

@;{Returns an integer that can be used as a @racket[equal?]-based hash
code for @this-obj[] (using the same notion of @racket[equal?] as
@method[image-snip% other-equal-to?]).}
  返回一个整数，它可以用作用于@this-obj[]的基于@racket[equal?]的散列码（使用相同的作为@method[image-snip% other-equal-to?]的@racket[equal?]概念）。

@;{See also @racket[equal<%>].}}
   也参见@racket[equal<%>]。

@defmethod[(equal-secondary-hash-code-of [hash-code (any/c . -> . exact-integer?)])
           exact-integer?]{

@;{Returns an integer that can be used as a @racket[equal?]-based
secondary hash code for @this-obj[] (using the same notion of
@racket[equal?] as @method[image-snip% other-equal-to?]).}
返回一个整数，它可以用作用于@this-obj[]的基于@racket[equal?]的次要的散列码（使用相同的作为@method[image-snip% other-equal-to?]的@racket[equal?]概念）。

See also @racket[equal<%>].
也参见@racket[equal<%>]。}

@defmethod[(get-bitmap)
           (or/c (is-a?/c bitmap%) #f)]{

Returns the bitmap that is displayed by the snip, whether set through
 @method[image-snip% set-bitmap] or @method[image-snip% load-file]. If
 no bitmap is displayed, the result is @racket[#f].
返回由剪切显示的位图，无论是通过@method[image-snip% set-bitmap]还是@method[image-snip% load-file]进行设置。如果没有显示位图，则结果为@racket[#f]。
}

@defmethod[(get-bitmap-mask)
           (or/c (is-a?/c bitmap%) #f)]{

@;{Returns the mask bitmap that is used for displaying by the snip, if
 one was installed with @method[image-snip% set-bitmap].  If no mask
 is used, the result is @racket[#f].}
  返回用于由snip显示的遮罩位图（如果使用@method[image-snip% set-bitmap]安装了遮罩位图）。如果不使用遮罩，则结果为@racket[#f]。

}

@defmethod[(get-filename [relative-path (or/c (box/c any/c) #f) #f])
           (or/c path-string? #f)]{

@;{Returns the name of the currently loaded, non-inlined file, or
 @racket[#f] if a file is not loaded or if a file was loaded with
 inlining (the default).}
  返回当前加载的非内联文件的名称，如果文件未加载或文件加载时带有内联（默认值），则返回@racket[#f]。

@;{@boxisfillnull[@racket[relative-path] @elem{@racket[#t] if the loaded file's path is
relative to the owning editor's path}]}
  @boxisfillnull[@racket[relative-path] @elem{@racket[#t]如果加载的文件的路径相对于所属编辑器的路径}]

}

@defmethod[(get-filetype)
           (or/c 'unknown 'unknown/mask 'unknown/alpha
                 'gif 'gif/mask 'gif/alpha 
                 'jpeg 'png 'png/mask 'png/alpha
                 'xbm 'xpm 'bmp 'pict)]{

Returns the kind used to load the currently loaded, non-inlined file,
 or @racket['unknown] if a file is not loaded or if a file was loaded
 with inlining (the default).
返回用于加载当前加载的非内联文件的类型，或者如果文件未加载或文件加载时带有内联（默认值），则返回@racket['unknown]。

}

@defmethod[(load-file [file (or/c path-string? input-port? #f)]
                      [kind (or/c 'unknown 'unknown/mask 'unknown/alpha
                                  'gif 'gif/mask 'gif/alpha 
                                  'jpeg 'png 'png/mask 'png/alpha
                                  'xbm 'xpm 'bmp 'pict) 'unknown]
                      [relative-path? any/c #f]
                      [inline? any/c #t]
                      [backing-scale (>/c 0.0) 1.0])
           void?]{

@;{Loads the file by passing @racket[file] and @racket[kind] to
 @xmethod[bitmap% load-file]. If a bitmap had previously been specified
 with @method[image-snip% set-bitmap], that bitmap (and mask) will no
 longer be used. If @racket[file] is @racket[#f], then the current
 image is cleared.}
通过传递@racket[file]和@racket[kind]给@xmethod[bitmap% load-file]来加载文件。如果以前使用@method[image-snip% set-bitmap]指定了位图，则该位图（和遮罩）将不再使用。如果@racket[file]是@racket[#f]，则当前图像将被清除。
  
@;{When @racket['unknown/mask], @racket['gif/mask], or @racket['png/mask]
 is specified and the loaded bitmap object includes a mask (see
 @method[bitmap% get-loaded-mask]), the mask is used for drawing the
 bitmap (see @method[dc<%> draw-bitmap]). The @racket['unknown/alpha],
 @racket['gif/alpha], or @racket['png/alpha] variants are recommended,
 however.}
 当指定了“unknown/mask”、“gif/mask”或“png/mask”并且加载的位图对象包含一个掩码（请参见获取加载的掩码）时，该掩码用于绘制位图（请参见绘制位图）。但是，建议使用“未知/阿尔法”、“GIF/阿尔法”或“PNG/阿尔法”变体。 

@;{If @racket[relative-path?] is not @racket[#f] and @racket[file] is a
 relative path, then the file will be read using the path of the
 owning editor's filename. If the image is not inlined, it will be
 saved as a relative pathname.}
  如果@racket[relative-path?]不是@racket[#f]且@racket[file]是相对路径，则将使用所属编辑器文件名的路径读取文件。如果图像没有内联，它将保存为相对路径名。

@;{If @racket[inline?] is not @racket[#f], the image data will be saved
 directly to the file or clipboard when the image is saved or copied
 (preserving the bitmap's mask, if any).  The source filename and kind
 is no longer relevant.}
  如果@racket[inline?]不是@racket[#f]，保存或复制图像时，图像数据将直接保存到文件或剪贴板（保留位图的遮罩，如果有的话）。源文件名和类型不再相关。

@;{@history[#:changed "1.1" @elem{Added the @racket[backing-scale] argument.}]}
  @history[#:changed "1.1" @elem{添加@racket[backing-scale]参数。}]
 }

@defmethod[(other-equal-to? [snip (is-a?/c image-snip%)]
                            [equal? (any/c any/c . -> . boolean?)])
           boolean?]{

@;{Returns @racket[#t] if @this-obj[] and @racket[snip] both have bitmaps
and the bitmaps are the same. If either has a mask bitmap
with the same dimensions as the main bitmap, then the masks must be
the same (or if only one mask is present, it must correspond to a
solid mask).}
  如果@this-obj[]和@racket[snip]都有位图且位图相同，则返回@racket[#t]。如果有一个与主位图尺寸相同的遮罩位图，则遮罩必须相同（或者如果只存在一个遮罩，则它必须对应于实体遮罩）。

@;{The given @racket[equal?] function (for recursive comparisons) is not
used.}
  给定的@racket[equal?]函数（用于递归比较）未使用。
  }


@defmethod[#:mode override 
           (resize [w (and/c real? (not/c negative?))]
                   [h (and/c real? (not/c negative?))])
           boolean?]{

@;{The bitmap will be cropped to fit in the given dimensions.}
  位图将被裁剪以适合给定的尺寸。

}

@defmethod[(set-bitmap [bm (is-a?/c bitmap%)]
                       [mask (or/c (is-a?/c bitmap%) #f) #f])
           void?]{

@;{Sets the bitmap that is displayed by the snip.}
  设置剪切显示的位图。

@;{An optional @racket[mask] is used when drawing the bitmap (see
 @method[dc<%> draw-bitmap]), but supplying the mask directly is
 deprecated. If no mask is supplied but the bitmap's
 @method[bitmap% get-loaded-mask] method produces a bitmap of the same
 dimensions, it is used as the mask; furthermore, such a mask is saved
 with the snip when it is saved to a file or copied (whereas a
 directly supplied mask is not saved). Typically, however, @racket[bm]
 instead should have an alpha channel instead of a separate mask bitmap.}
  绘制位图时使用可选的@racket[mask]（请参见@method[dc<%> draw-bitmap]），但不推荐直接提供遮罩。如果没有提供遮罩，但位图的@method[bitmap% get-loaded-mask]方法生成的位图尺寸相同，则将其用作遮罩；此外，当将该遮罩保存到文件或复制时（而不保存直接提供的遮罩），该遮罩将与剪切一起保存。但是，通常情况下，@racket[bm]应该有一个alpha通道，而不是一个单独的遮罩位图。

}

@defmethod[(set-offset [dx real?]
                       [dy real?])
           void?]{

@;{Sets a graphical offset for the bitmap within the image snip.}
  为图像剪切中的位图设置图形偏移。

}}

