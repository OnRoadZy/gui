#lang scribble/doc
@(require "common.rkt" "diagrams.rkt")

@;{@title[#:style '(toc quiet)]{Editor Classes}}
@title[#:tag "Editor_Classes" #:style '(toc quiet)]{编辑器类}

@;{Editors:}
编辑器：

@diagram->table[editor-diagram]

@;{Editor Snips:}
编辑器剪切：

@diagram->table[editor-snip-diagram]

@;{Displays, Administrators, and Mappings:}
显示、管理员和映射：

@diagram->table[editor-admin-diagram]

@;{Streams for Saving and Cut-and-Paste:}
用于保存、剪切和粘贴的流：

@diagram->table[stream-diagram]

@;{Alphabetical:}
按字母顺序排列的：

@local-table-of-contents[]

@include-section["editor-intf.scrbl"]
@include-section["editor-admin-class.scrbl"]
@include-section["editor-canvas-class.scrbl"]
@include-section["editor-data-class.scrbl"]
@include-section["editor-data-class-class.scrbl"]
@include-section["editor-data-class-list-intf.scrbl"]
@include-section["editor-snip-editor-admin-intf.scrbl"]
@include-section["editor-snip-class.scrbl"]
@include-section["editor-stream-in-class.scrbl"]
@include-section["editor-stream-in-base-class.scrbl"]
@include-section["editor-stream-in-bytes-base-class.scrbl"]
@include-section["editor-stream-out-class.scrbl"]
@include-section["editor-stream-out-base-class.scrbl"]
@include-section["editor-stream-out-bytes-base-class.scrbl"]
@include-section["editor-wordbreak-map-class.scrbl"]
@include-section["keymap-class.scrbl"]
@include-section["pasteboard-class.scrbl"]
@include-section["text-class.scrbl"]
