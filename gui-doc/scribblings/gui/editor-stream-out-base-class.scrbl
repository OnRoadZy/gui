#lang scribble/doc
@(require "common.rkt")

@defclass/title[editor-stream-out-base% object% ()]{

@;{An @racket[editor-stream-out-base%] object is used by an
 @racket[editor-stream-out%] object to perform low-level writing of
 data.}
  @racket[editor-stream-out-base%]对象被@racket[editor-stream-out%]对象用于执行低级数据写入。

@;{The @racket[editor-stream-out-base%] class is never instantiated
 directly, but the derived class
 @racket[editor-stream-out-bytes-base%] can be instantiated.  New
 derived classes must override all of the methods described in this
 section.}
从未直接实例化@racket[editor-stream-out-base%]类，但派生类@racket[editor-stream-out-bytes-base%]可以实例化。新的派生类必须重写本节中描述的所有方法。

@defmethod[(bad?)
           boolean?]{

@;{Returns @racket[#t] if there has been an error writing to the stream,
 @racket[#f] otherwise.}
如果写入流时出错，则返回@racket[#t]，否则返回@racket[#f]。
}

@defmethod[(seek [pos exact-nonnegative-integer?])
           void?]{

@;{Moves to the specified absolute position in the stream.}
移动到流中指定的绝对位置。
}

@defmethod[(tell)
           exact-nonnegative-integer?]{

@;{Returns the current stream position.}
返回当前流位置。
}

@defmethod[(write [data (listof char?)])
           void?]{

@;{Writes data (encoded as Latin-1 characters) to the stream. This method
is implemented by default via @method[editor-stream-out-base%
write-bytes].}
  将数据（编码为Latin-1字符）写入流。此方法默认通过@method[editor-stream-out-base%
write-bytes]。
  }

@defmethod[(write-bytes [bstr bytes?]) void?]{

@;{Writes data to the stream.}
将数据写入流。
}}


