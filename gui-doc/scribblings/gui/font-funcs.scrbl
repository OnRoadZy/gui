#lang scribble/doc
@(require "common.rkt")

@;{@title{Fonts}}
@title[#:tag "font-funcs"]{字体}

@defthing[menu-control-font (is-a?/c font%)]{

@;{This font is the default for @racket[popup-menu%] objects.}
  此字体是@racket[popup-menu%]对象的默认字体。

@;{On Mac OS, this font is slightly larger than
 @racket[normal-control-font]. On Windows and Unix, it is the same
 size as @racket[normal-control-font].}
  在Mac OS上，此字体比@racket[normal-control-font]略大。在Windows和Unix上，它的大小与@racket[normal-control-font]相同。

}

@defthing[normal-control-font (is-a?/c font%)]{

@;{This font is the default for most controls, except
 @racket[list-box%] and @racket[group-box-panel%] objects.}
  除了@racket[list-box%]和@racket[group-box-panel%]对象之外，此字体是大多数控件的默认字体。

}

@defthing[small-control-font (is-a?/c font%)]{

@;{This font is the default for @racket[group-box-panel%] objects, and it is
 a suitable for controls in a floating window and other contexts that
 need smaller controls.}
  此字体是@racket[group-box-panel%]对象的默认字体，适用于浮动窗口中的控件和需要较小控件的其他上下文。

@;{On Windows, this font is the same size as
 @racket[normal-control-font], since the Windows control font is
 already relatively small. On Unix and Mac OS, this font is slightly
 smaller than @racket[normal-control-font].}
  在Windows上，此字体与@racket[normal-control-font]大小相同，因为Windows控件字体已经相对较小。在Unix和Mac OS上，此字体比@racket[normal-control-font]稍小。

}

@defthing[tiny-control-font (is-a?/c font%)]{

@;{This font is for tiny controls, and it is smaller than
 @racket[small-control-font] on all platforms.}
  此字体用于小控件，它比所有平台上的@racket[small-control-font]都小。

}

@defthing[view-control-font (is-a?/c font%)]{

@;{This font is the default for @racket[list-box%] objects (but not
 list box labels, which use @racket[normal-control-font]).}
此字体是@racket[list-box%]对象（但不是使用@racket[normal-control-font]的列表框标签）的默认字体。
  
@;{On Mac OS, this font is slightly smaller than
 @racket[normal-control-font], and slightly larger than
 @racket[small-control-font]. On Windows and Unix, it is the same size
 as @racket[normal-control-font].}
 在Mac OS上，此字体比@racket[normal-control-font]稍小，比@racket[small-control-font]稍大。在Windows和Unix上，它的大小与@racket[normal-control-font]相同。 

}
