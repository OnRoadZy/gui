#lang scribble/doc
@(require "common.rkt")

@defclass/title[editor-stream-in-bytes-base% editor-stream-in-base% ()]{

@;{An @racket[editor-stream-in-bytes-base%] object can be used to
read editor data from a byte string.}
@racket[editor-stream-in-bytes-base%]对象可用于从字节字符串读取编辑器数据。

@defconstructor/make[([s bytes?])]{

@;{Creates a stream base that reads from @racket[s].}
创建从@racket[s]读取的流基。
}}
