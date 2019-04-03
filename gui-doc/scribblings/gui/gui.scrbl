#lang scribble/doc
@(require "common.rkt")

@;{@title{The Racket Graphical Interface Toolkit}}
@title[#:tag "The-Racket-Graphical-Interface-Toolkit"]{Racket图形界面工具包}

@author["Matthew Flatt" "Robert Bruce Findler" "John Clements"]
@author["张恒源译"]

@declare-exporting[racket/gui/base racket/gui #:use-sources (mred)]

@defmodule*/no-declare[(racket/gui/base)]{@;{The
@racketmodname[racket/gui/base] library provides all of the class,
interface, and procedure bindings defined in this manual, in addition
to the bindings of @racketmodname[racket/draw] and 
@racketmodname[file/resource].}
@racketmodname[racket/gui/base]库提供本手册中定义的所有类、接口和过程绑定，以及@racketmodname[racket/draw]和@racketmodname[file/resource]的绑定。}

@defmodulelang*/no-declare[(racket/gui)]{@;{The
@racketmodname[racket/gui] language combines all bindings of the
@racketmodname[racket] language and the
@racketmodname[racket/gui/base] and @racketmodname[racket/draw] modules.}
@racketmodname[racket/gui]语言结合了@racketmodname[racket]语言和@racketmodname[racket/gui/base]和@racketmodname[racket/draw]模块的所有绑定。}

@;{The @racketmodname[racket/gui] toolbox is roughly organized into two
parts:}
@racketmodname[racket/gui]工具箱大致分为两部分：

@itemize[

 @item{@;{The @deftech{windowing toolbox}, for implementing windows,
 buttons, menus, text fields, and other controls.}
 @deftech{窗口工具箱（windowing toolbox）}，用于实现窗口、按钮、菜单、文本字段和其它控件。}

 @item{@;{The @deftech{editor toolbox}, for developing traditional text
 editors, editors that mix text and graphics, or free-form layout
 editors (such as a word processor, HTML editor, or icon-based file
 browser).}
@deftech{编辑器工具箱（editor toolbox）}，用于开发传统文本编辑器、混合文本和图形的编辑器，或自由格式的布局编辑器（如字处理器、HTML编辑器或基于图标的文件浏览器）。}

]

@;{Both parts of the toolbox rely extensively on the
@racketmodname[racket/draw] drawing library.}
工具箱的两个部分都广泛依赖于@racketmodname[racket/draw]绘图库。

@table-of-contents[]

@;------------------------------------------------------------------------

@include-section["win-overview.scrbl"]
@include-section["widget-gallery.scrbl"]
@include-section["win-classes.scrbl"]
@include-section["win-funcs.scrbl"]
@include-section["editor-overview.scrbl"]
@include-section["snip-classes.scrbl"]
@include-section["editor-classes.scrbl"]
@include-section["editor-funcs.scrbl"]
@include-section["wxme.scrbl"]
@include-section["prefs.scrbl"]
@include-section["dynamic.scrbl"]
@include-section["startup.scrbl"]
@include-section["init.scrbl"]
@include-section["libs.scrbl"]

@;------------------------------------------------------------------------

@index-section[]
