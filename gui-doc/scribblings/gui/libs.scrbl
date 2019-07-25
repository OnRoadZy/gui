#lang scribble/doc
@(require "common.rkt")

@(define draw-doc '(lib "scribblings/draw/draw.scrbl"))

@;{@title[#:tag "libs"]{Platform Dependencies}}
@title[#:tag "libs"]{平台依赖项}

@;{See @secref[#:doc draw-doc "libs"] in @other-manual[draw-doc] for
information on platform library dependencies for
@racketmodname[racket/draw]. On Unix, GTK+ 3 is used if its libraries
can be found and the @indexed-envvar{PLT_GTK2} environment is not
defined. Otherwise, GTK+ 2 is used. The following additional system
libraries must be installed for @racketmodname[racket/gui/base] in
either case:}
有关@racketmodname[racket/draw]的平台库依赖项的信息，请参阅@other-manual[draw-doc]中的@secref[#:doc draw-doc "libs"]。在Unix上，如果可以找到GTK+3的库，并且没有定义@indexed-envvar{PLT_GTK2}环境，则使用GTK+3。否则，使用GTK+2。在任何情况下，都必须为@racketmodname[racket/gui/base]安装以下附加系统库：

@itemlist[
 @item{@filepath{libgdk-3.0[.0]} (GTK+ 3) or @filepath{libgdk-x11-2.0[.0]} (GTK+ 2)}
 @item{@filepath{libgdk_pixbuf-2.0[.0]} (GTK+ 2)}
 @item{@filepath{libgtk-3.0[.0]} (GTK+ 3) or @filepath{libgtk-x11-2.0[.0]} (GTK+ 2)}
 @item{@filepath{libgio-2.0[.0]}@;{ --- optional, for detecting interface scaling}——可选，用于检测接口缩放}
 @item{@filepath{libGL[.1]}@;{ --- optional, for OpenGL support}——可选，用于OpenGL支持}
 @item{@filepath{libunique-1.0[.0]}@;{ --- optional, for single-instance support (GTK+ 2)}——可选，用于单实例支持（GTK+2）}
]
