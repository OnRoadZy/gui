#lang scribble/doc
@(require "common.rkt")

@defclass/title[editor-stream-out% object% ()]{

@;{An @racket[editor-stream-out%] object is used to write editor
 information to a file or other output stream (such as the
 clipboard).}
@racket[editor-stream-out%]对象用于将编辑器信息写入文件或其他输出流（如剪贴板）。


@defconstructor/make[([base (is-a?/c editor-stream-out-base%)])]{

@;{An out-stream base---possibly an
@racket[editor-stream-out-bytes-base%] object---must be supplied in
@racket[base].}
输出流基——可能是@racket[editor-stream-out-bytes-base%]对象——必须在@racket[base]中被提供。
}

@defmethod[(jump-to [pos exact-nonnegative-integer?])
           void?]{
@;{Jumps to a given position in the stream.}
跳到流中的给定位置。
}

@defmethod[(ok?)
           boolean?]{
@;{Returns @racket[#t] if the stream is ready for writing, @racket[#f] otherwise.
Writing to a bad stream has no effect.}
如果流已准备好写入，则返回@racket[#t]，否则返回@racket[#f]。写入坏流没有效果。
}

@defmethod[(pretty-finish)
           void?]{

@;{Ensures that the stream ends with a newline.
This method is called by
@racket[write-editor-global-footer].}
确保流以换行符结尾。此方法由@racket[write-editor-global-footer]调用。
}


@defmethod[(pretty-start)
           void?]{

@;{Writes a ``comment'' into the stream that identifies the file format.
This method is called by @racket[write-editor-global-header].}
将“注释”写入标识文件格式的流中。此方法由@racket[write-editor-global-header]调用。
}

@defmethod*[([(put [n exact-nonnegative-integer?]
                   [v bytes?])
              (is-a?/c editor-stream-out%)]
             [(put [v bytes?])
              (is-a?/c editor-stream-out%)]
             [(put [v exact-integer?])
              (is-a?/c editor-stream-out%)]
             [(put [v real?])
              (is-a?/c editor-stream-out%)])]{


@;{Writes @racket[v], or @racket[n] bytes of @racket[v]. }
  写入@racket[v]或@racket[v]的@racket[n]字节。

@;{When @racket[n] is supplied with a byte-string @racket[v], use
 @method[editor-stream-in% get-unterminated-bytes] to read the bytes
 later. This is the recommended way to write out bytes to 
 be easily read in later; use @method[editor-stream-in%
 get-unterminated-bytes] to read the bytes back in.}
  当@racket[n]与字节字符串@racket[v]一起提供时，使用@method[editor-stream-in% get-unterminated-bytes]来稍后读取字节。这是写入字节以便以后轻松读取的推荐方法；使用@method[editor-stream-in%
 get-unterminated-bytes]来重新读取字节。

@;{If @racket[n] is not supplied and @racket[v] is a byte string, then
 for historical reasons, the actual number of bytes written includes a
 @racket[#\nul] terminator, so use @method[editor-stream-in%
 get-bytes] instead of @method[editor-stream-in%
 get-unterminated-bytes] to read the bytes later.}
  如果没有提供@racket[n]且@racket[v]是一个字节字符串，那么出于历史原因，实际写入的字节数包括一个@racket[#\nul]终止符，因此使用@method[editor-stream-in%
 get-bytes]而不是@method[editor-stream-in%
 get-unterminated-bytes]来稍后读取字节。

}


@defmethod[(put-fixed [v exact-integer?])
           (is-a?/c editor-stream-out%)]{

@;{Puts a fixed-sized integer into the stream. This method is needed
 because numbers are usually written in a way that takes varying
 numbers of bytes. In some cases it is useful to temporary write a
 @racket[0] to a stream, write more data, and then go back and change
 the @racket[0] to another number; such a process requires a
 fixed-size number.}
  将固定大小的整数放入流中。这种方法是必要的，因为数字通常是以一种需要不同字节数的方式写入的。在某些情况下，将@racket[0]临时写入流、写入更多数据，然后返回并将@racket[0]更改为另一个数字是很有用的；这样的过程需要一个固定大小的数字。

@;{Numbers written to a stream with @method[editor-stream-out% put-fixed]
 must be read with @method[editor-stream-in% get-fixed-exact]
 or @method[editor-stream-in% get-fixed].}
用@method[editor-stream-out% put-fixed]写入流的数字必须用@method[editor-stream-in% get-fixed-exact]或@method[editor-stream-in% get-fixed]读取。
  }


@defmethod[(put-unterminated [v bytes?]) (is-a?/c editor-stream-out%)]{

@;{The same as calling @method[editor-stream-out% put] with
@racket[(bytes-length v)] and @racket[v].}
与用@racket[(bytes-length v)]和@racket[v]调用@method[editor-stream-out% put]相同。
  }


@defmethod[(tell)
           exact-nonnegative-integer?]{

@;{Returns the current stream position.}
返回当前流位置。
}}
