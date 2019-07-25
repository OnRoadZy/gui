#lang scribble/doc
@(require "common.rkt"
          (for-label racket/gui/dynamic racket/pretty racket/gui/base setup/dirs))

@;{@title{Init Libraries}}
@title[#:tag "Init_Libraries"]{初始化库}

@defmodule*/no-declare[(racket/gui/init)]{
 @;{The
@racketmodname[racket/gui/init] library is the default start-up
library for GRacket. It re-exports the @racketmodname[racket/init] and
@racketmodname[racket/gui/base] libraries, and it sets
@racket[current-load] to use @racket[text-editor-load-handler].}
@racketmodname[racket/gui/init]库是GRacket的默认启动库。它重新导出@racketmodname[racket/init]和@racketmodname[racket/gui/base]库，并将@racket[current-load]设置为使用@racket[text-editor-load-handler]。
}

@defmodule*/no-declare[(racket/gui/interactive)]{
 @;{Similar to @racketmodname[racket/interactive], but for
 GRacket. This library can be changed by modifying 
 @racket['gui-interactive-file] in the
 @filepath{config.rktd} file in @racket[(find-config-dir)].
 Additionally, if the file @filepath{gui-interactive.rkt}
 exists in @racket[(find-system-path 'addon-dir)], it is run
 rather than the installation wide graphical interactive
 module.}
   类似于@racketmodname[racket/interactive]，但用于GRacket。此库可以通过在中修改@filepath{config.rktd}文件中的@racket['gui-interactive-file]进行更改@racket[(find-config-dir)]。此外，如果文件@filepath{gui-interactive.rkt}存在于@racket[(find-system-path 'addon-dir)]，则运行该文件，而不是安装范围内的图形交互模块。 

 @;{This library runs the 
 @racket[(find-graphical-system-path 'init-file)] file in
 the users home directory if it exists, rather than their 
 @racket[(find-system-path 'init-file)]. Unlike 
 @racketmodname[racket/interactive], this library does not
 start @racketmodname[xrepl].}
   此库运行@racket[(find-graphical-system-path 'init-file)]文件（如果存在），而不是其@racket[(find-system-path 'init-file)]。与@racketmodname[racket/interactive]不同，此库不启动@racketmodname[xrepl]。 

 @history[#:added "1.27"]}
