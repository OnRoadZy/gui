#lang scribble/doc
@(require "common.rkt")

@defclass/title[editor-stream-in% object% ()]{

@;{An @racket[editor-stream-in%] object is used to read editor
 information from a file or other input stream (such as the
 clipboard).}
@racket[editor-stream-in%]对象用于从文件或其他输入流（如剪贴板）读取编辑器信息。

@defconstructor/make[([base (is-a?/c editor-stream-in-base%)])]{

@;{An in-stream base---possibly an @racket[editor-stream-in-bytes-base%]
 object---must be supplied in @racket[base].}
  一个in-stream基，可能是@racket[editor-stream-in-bytes-base%]对象——必须在@racket[base]中提供。

}


@defmethod*[([(get [v (box/c exact-integer?)])
              (is-a?/c editor-stream-in%)]
             [(get [v (box/c real?)])
              (is-a?/c editor-stream-in%)])]{

@;{Reads data from the stream, returning itself.
Reading from a bad stream always gives @racket[0].}
  从流中读取数据，并返回自身。从坏流中读取总是给出@racket[0]。

@;{@boxisfill[@racket[v] @elem{the next integer or floating-point value in the stream}]}
  @boxisfill[@racket[v] @elem{流中的下一个整数或浮点值。}]

}


@defmethod[(get-bytes [len (or/c (box/c exact-nonnegative-integer?) #f) #f])
           (or/c bytes? #f)]{

@;{Like @method[editor-stream-in% get-unterminated-bytes], but the last
 read byte is assumed to be a nul terminator and discarded. Use this
 method when data is written by a call to @method[editor-stream-out%
 put] without an explicit byte count, and use
 @method[editor-stream-in% get-unterminated-bytes] when data is
 written with an explicit byte count.}
  与@method[editor-stream-in% get-unterminated-bytes]类似，但最后一个读取字节被假定为nul终止符并丢弃。当通过调用@method[editor-stream-out%
 put]写入数据而不使用显式字节计数时，使用此方法；当使用显式字节计数写入数据时，使用@method[editor-stream-in% get-unterminated-bytes]。

@;{@boxisfillnull[@racket[len] @elem{the length of the byte string plus one (to indicate the terminator)}]}
  @boxisfillnull[@racket[len] @elem{字节字符串的长度加上一（表示终止符）。}]

}

@defmethod[(get-exact)
           exact-integer?]{

@;{Returns the next integer value in the stream.}
  返回流中的下一个整数值。

}

@defmethod[(get-fixed [v (box/c exact-integer?)])
           (is-a?/c editor-stream-in%)]{

@;{@boxisfill[@racket[v] @elem{a fixed-size integer from the stream obtained through 
           @method[editor-stream-in% get-fixed-exact]}]}
  @boxisfill[@racket[v] @elem{从流中获取的固定大小整数@method[editor-stream-in% get-fixed-exact]}]

}

@defmethod[(get-fixed-exact)
           exact-integer?]{

@;{Gets a fixed-sized integer from the stream. See
@method[editor-stream-out% put-fixed] for more information.
Reading from a bad stream always gives @racket[0].}
  从流中获取固定大小的整数。有关更多信息，请参见@method[editor-stream-out% put-fixed]。从坏流中读取总是给出@racket[0]。

}

@defmethod[(get-inexact)
           real?]{

@;{Returns the next floating-point value in the stream.}
返回流中的下一个浮点值。  

}

@defmethod[(get-unterminated-bytes [len (or/c (box/c exact-nonnegative-integer?) #f) #f])
           (or/c bytes? #f)]{

@;{Returns the next byte string from the stream.  This is
the recommended way to read bytes back in from a stream;
use @method[editor-stream-out% put] with two arguments
(passing along the length of the bytes) to write out the bytes
to match this method.}
  返回流中的下一个字节字符串。这是从流中读取字节的推荐方法；将@method[editor-stream-out% put]与两个参数（沿字节长度传递）一起使用，写出与此方法匹配的字节。

@;{Reading from a bad stream returns @racket[#f] or @racket[#""].}
  从坏流读取返回@racket[#f]或@racket[#""]。

@;{Note that when @method[editor-stream-out% put] is not given a byte
 length, it includes an extra byte for a nul terminator; use
 @method[editor-stream-in% get-bytes] to read such byte strings.}
  注意，当@method[editor-stream-out% put]没有给定字节长度时，它包含一个额外的nul终止符字节；使用@method[editor-stream-in% get-bytes]读取此类字节字符串。



@;{@boxisfillnull[@racket[len] @elem{the length of the byte string}]}
 @boxisfillnull[@racket[len] @elem{字节字符串的长度。}]

}

@defmethod[(jump-to [pos exact-nonnegative-integer?])
           void?]{

@;{Jumps to a given position in the stream.}
  跳到流中的给定位置。

}

@defmethod[(ok?)
           boolean?]{

@;{Returns @racket[#t] if the stream is ready for reading, @racket[#f] otherwise.
Reading from a bad stream always returns @racket[0] or @racket[""].}
  如果流已准备好读取，则返回@racket[#t]，否则返回@racket[#f]。从错误流读取始终返回@racket[0]或@racket[""]。

}

@defmethod[(remove-boundary)
           void?]{

@;{See @method[editor-stream-in% set-boundary].}
  参见@method[editor-stream-in% set-boundary]。

}

@defmethod[(set-boundary [n exact-nonnegative-integer?])
           void?]{

@;{Sets a file-reading boundary at @racket[n] bytes past the current
 stream location. If there is an attempt to read past this boundary,
 an error is signaled. The boundary is removed with a call to
 @method[editor-stream-in% remove-boundary].  Every call to
 @method[editor-stream-in% set-boundary] must be balanced by a call to
 @method[editor-stream-in% remove-boundary].}
 将文件读取边界设置为超过当前流位置@racket[n]个字节。如果试图读取超过此边界，则会发出错误信号。通过调用@method[editor-stream-in% remove-boundary]来移除边界。必须通过调用@method[editor-stream-in% remove-boundary]来平衡对@method[editor-stream-in% set-boundary]的每个调用。 

@;{Boundaries help keep a subroutine from reading too much data leading
 to confusing errors. However, a malicious subroutine can call
 @method[editor-stream-in% remove-boundary] on its own.}
  边界有助于防止子例程读取过多的数据，从而导致混淆错误。但是，恶意子例程可以自己调用@method[editor-stream-in% remove-boundary]。

}


@defmethod[(skip [n exact-nonnegative-integer?])
           void?]{

@;{Skips past the next @racket[n] bytes in the stream.}
跳过流中接下来的@racket[n]个字节。
}

@defmethod[(tell)
           exact-nonnegative-integer?]{

@;{Returns the current stream position.}
  返回当前流位置。

}}
