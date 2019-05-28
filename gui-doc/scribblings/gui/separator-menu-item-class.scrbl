#lang scribble/doc
@(require "common.rkt")

@defclass/title[separator-menu-item% object% (menu-item<%>)]{

@;{A separator is an unselectable line in a menu. Its parent must be a
 @racket[menu%] or @racket[popup-menu%].}
  分隔符是菜单中不可选择的行。它的父级必须是@racket[menu%]或@racket[popup-menu%]。

@defconstructor[([parent (or/c (is-a?/c menu%) (is-a?/c popup-menu%))])]{

@;{Creates a new separator in the menu.}
  在菜单中新建分隔符。

}}

