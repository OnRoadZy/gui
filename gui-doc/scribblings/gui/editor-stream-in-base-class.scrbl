#lang scribble/doc
@(require "common.rkt")

@defclass/title[editor-stream-in-base% object% ()]{

@;{An @racket[editor-stream-in-base%] object is used by an
 @racket[editor-stream-in%] object to perform low-level reading of
 data.}
@racket[editor-stream-in%]对象使用@racket[editor-stream-in-base%]对象执行低级数据读取。  

@;{The @racket[editor-stream-in-base%] class is never instantiated
 directly, but the derived class @racket[editor-stream-in-bytes-base%]
 can be instantiated.  New derived classes must override all of the
 methods described in this section.}
  从未直接实例化@racket[editor-stream-in-base%]类，但可以实例化@racket[editor-stream-in-bytes-base%]派生类。新的派生类必须重写本节中描述的所有方法。


@defmethod[(bad?)
           boolean?]{

@;{Returns @racket[#t] if there has been an error reading from the
 stream, @racket[#f] otherwise.}
  如果从流中读取时出错，则返回@racket[#t]，否则返回@racket[#f]。

}

@defmethod[(read [data (and/c vector? (not immutable?))])
           exact-nonnegative-integer?]{

@;{Like @method[editor-stream-in-base% read-bytes], but fills a supplied
vector with Latin-1 characters instead of filling a byte string.  This method
is implemented by default via @method[editor-stream-in-base% read-bytes].}
@method[editor-stream-in-base% read-bytes]类似，但用Latin-1字符填充提供的向量，而不是填充字节字符串。此方法默认通过@method[editor-stream-in-base% read-bytes]实现。
 }

@defmethod[(read-bytes [bstr (and/c bytes? (not immutable?))])
           exact-nonnegative-integer?]{

@;{Reads bytes to fill the supplied byte string. The return value is the
 number of bytes read, which may be less than the number
 requested if the stream is emptied. If the stream is emptied, the
 next call to @method[editor-stream-in-base% bad?] must return
 @racket[#t].}
  读取字节以填充提供的字节字符串。返回值是读取的字节数，如果流被清空，该值可能小于请求的字节数。如果流被清空，下次调用@method[editor-stream-in-base% bad?]必须返回@racket[#t]。
  }

@defmethod[(read-byte) (or/c byte? #f)]{

@;{Reads a single byte and return it, or returns @racket[#f] if no more
bytes are available. The default implementation of this method uses
@method[editor-stream-in-base% read-bytes].}
读取一个字节并返回它，或者如果没有更多的字节可用，则返回@racket[#f]。此方法的默认实现使用@method[editor-stream-in-base% read-bytes]。
}

@defmethod[(seek [pos exact-nonnegative-integer?])
           void?]{

@;{Moves to the specified absolute position in the stream.}
移动到流中指定的绝对位置。
}

@defmethod[(skip [n exact-nonnegative-integer?])
           void?]{

@;{Skips past the next @racket[n] characters in the stream.}
  跳过流中接下来的@racket[n]个字符。
}

@defmethod[(tell)
           exact-nonnegative-integer?]{

@;{Returns the current stream position.}
  返回当前流位置。

}}

