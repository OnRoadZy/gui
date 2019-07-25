#lang scribble/doc
@(require "common.rkt" (for-label racket/gui/dynamic))

@;{@title{Dynamic Loading}}
@title[#:tag "Dynamic_Loading"]{动态加载}

@defmodule[racket/gui/dynamic]{@;{The @racketmodname[racket/gui/dynamic]
library provides functions for dynamically accessing the
@racketmodname[racket/gui/base] library, instead of directly requiring
@racketmodname[racket/gui] or @racketmodname[racket/gui/base].}
@racketmodname[racket/gui/dynamic]库提供动态访问@racketmodname[racket/gui/base]库的功能，而不是直接要求@racketmodname[racket/gui]或@racketmodname[racket/gui/base]。}

@defproc[(gui-available?) boolean?]{

@;{Returns @racket[#t] if dynamic access to the GUI bindings is
available. The bindings are available if
@racketmodname[racket/gui/base] has been loaded, instantiated, and
attached to the namespace in which @racket[racket/gui/dynamic] was
instantiated.}
  如果可以动态访问GUI绑定，则返回@racket[#t]。如果@racketmodname[racket/gui/base]已加载、实例化并附加到@racket[racket/gui/dynamic]实例化所在的命名空间，则绑定可用。
  }


@defproc[(gui-dynamic-require [sym symbol?]) any]{

@;{Like @racket[dynamic-require], but specifically to access exports of
@racketmodname[racket/gui/base].}
与@racket[dynamic-require]类似，但特别是访问@racketmodname[racket/gui/base]的导出。
  }
