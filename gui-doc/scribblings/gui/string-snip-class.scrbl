#lang scribble/doc
@(require "common.rkt")

@defclass/title[string-snip% snip% ()]{

@;{An instance of @racket[string-snip%] is created automatically when
 text is inserted into a text editor. See also @xmethod[text%
 on-new-string-snip].}
当文本插入文本编辑器时，将自动创建@racket[string-snip%]的实例。另请参见@xmethod[text%
 on-new-string-snip]。

@defconstructor*/make[(([allocsize exact-nonnegative-integer? 0])
                       ([s string?]))]{

@;{Creates a string snip whose initial content is @racket[s], if
 supplied, empty otherwise. In the latter case, the optional
 @racket[allocsize] argument is a hint about how much storage space
 for text should be initially allocated by the snip.}
创建一个字符串截图，其初始内容为@racket[s]（如果提供），否则为空。在后一种情况下，可选的@racket[allocsize]参数是关于剪切最初应该为文本分配多少存储空间的提示。
}


@defmethod[(insert [s string?]
                   [len exact-nonnegative-integer?]
                   [pos exact-nonnegative-integer? 0])
           void?]{

@;{Inserts @racket[s] (with length @racket[len]) into the snip at relative
 @techlink{position} @racket[pos] within the snip.}
 将@racket[s]（带长度@racket[len]）插入剪切内相对@techlink{位置} @racket[pos]处。 

}


@defmethod[(read [len exact-nonnegative-integer?]
                 [f (is-a?/c editor-stream-in%)])
           void?]{

@;{Reads the snip's data from the given stream.}
  从给定的流中读取剪切的数据。

@;{The @racket[len] argument specifies the maximum length of the text to
 be read.  (When a text snip is written to a file, the very first
 field is the length of the text contained in the snip.)  This method
 is usually invoked by the text snip class's @method[snip-class% read]
 method.}
  @racket[len]参数指定要读取的文本的最大长度。（将文本剪切写入文件时，第一个字段是剪切中包含的文本长度。）此方法通常由文本剪切类的@method[snip-class% read]方法调用。

}}

