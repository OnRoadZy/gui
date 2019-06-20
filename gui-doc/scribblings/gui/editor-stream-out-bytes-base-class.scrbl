#lang scribble/doc
@(require "common.rkt")

@defclass/title[editor-stream-out-bytes-base% editor-stream-out-base% ()]{

@;{An @racket[editor-stream-out-bytes-base%] object can be used to write
 editor data into a byte string.}
  @racket[editor-stream-out-bytes-base%]对象可用于将编辑器数据写入字节字符串。

@defconstructor[()]{

@;{Creates an empty stream.}
创建空流。
}

@defmethod[(get-bytes)
           bytes?]{

@;{Returns the current contents of the stream.}
  返回流的当前内容。

}}
