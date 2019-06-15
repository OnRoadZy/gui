#lang scribble/doc
@(require "common.rkt")

@definterface/title[editor-snip-editor-admin<%> ()]{

@;{An instance of this administrator interface is created with each
 @racket[editor-snip%] object; new instances cannot be
 created directly.}
使用每个@racket[editor-snip%]对象创建此管理员界面的实例；无法直接创建新实例。

@defmethod[(get-snip)
           (is-a?/c editor-snip%)]{

@;{Returns the snip that owns this administrator (and displays the
editor controlled by the administrator, if any).}
返回拥有此管理员的剪切（并显示由管理员控制的编辑器，如果有的话）。
}}

