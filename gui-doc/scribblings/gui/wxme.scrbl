#lang scribble/doc
@(require "common.rkt"
          (for-label wxme wxme/editor wxme/image racket/snip
                     racket/gui/dynamic
                     (except-in wxme/comment reader)
                     (except-in wxme/xml reader)
                     (except-in wxme/scheme reader)
                     (except-in wxme/text reader)
                     (except-in wxme/test-case reader)
                     (except-in wxme/cache-image reader)))

@(define-syntax-rule (in mod . content)
   (begin
     (define-syntax-rule (intro)
       (begin (require (for-label mod))
              . content))
     (intro)))

@;{@title{WXME Decoding}}
@title{WXME解码}

@;{@defmodule[wxme]{The @racketmodname[wxme] library provides tools for
reading @tech{WXME} @racket[editor<%>]-format files (see
@secref["editorfileformat"]) without the @racket[racket/gui] library.}}
@defmodule[wxme]{The @racketmodname[wxme] library provides tools for
reading @tech{WXME} @racket[editor<%>]-format files (see
@secref["editorfileformat"]) without the @racket[racket/gui] library.}
@defmodule[wxme]{@racketmodname[wxme]库提供不用@racket[racket/gui]库即可读取@tech{WXME} @racket[editor<%>]格式文件（参见@secref["editorfileformat"]）的工具。}

@defproc[(is-wxme-stream? [in input-port?]) boolean?]{

@;{Peeks from @racket[in] and returns @racket[#t] if it starts with the
magic bytes indicating a @tech{WXME}-format stream (see
@secref["editorfileformat"]), @racket[#f] otherwise.}
从@racket[in]探视并返回@racket[#t]，如果它以表示@tech{WXME}格式流的魔法字节开始（参见@secref["editorfileformat"]），否则返回@racket[#f]。
}


@defproc[(wxme-port->text-port [in input-port?] [close? any/c #t])
         input-port?]{

@;{Takes an input port whose stream starts with @tech{WXME}-format data
and returns an input port that produces a text form of the WXME
content, like the result of opening a WXME file in DrRacket and saving
it as text. }
  获取一个输入端口，其流以wxme格式数据开始，并返回一个生成wxme内容文本形式的输入端口，如在drracket中打开wxme文件并将其保存为文本的结果。

@;{Unlike @racket[wxme-port->port], this function may take liberties
with the snips in a way that would render a valid program invalid.
For example, if the wxme stream @racket[in] contains
a bitmap image, then there may not be a reasonable text-only version
of it and thus @racket[wxme-port->port] might turn what would have been
a valid Racket program into text that is a syntax error,
Nevertheless, the result may still be useful for human readers or 
approximate program-processing tools that run only in a GUI-less context.}
  与@racket[wxme-port->port]不同，此函数可能会以使有效程序用无效的方式使用剪切。例如，如果@racket[in]的wxme流包含位图图像，则可能没有其合理的纯文本版本，因此@racket[wxme-port->port]可能会将原本有效的Racket程序转换为语法错误的文本，但是，结果可能仍然对人类读卡器或仅在无图形用户界面上下文中运行的近似程序处理工具。

@;{If @racket[close?] is true, then closing the result port closes the
original port.}
  如果@racket[close?]为真，则关闭结果端口将关闭原始端口。

@;{See @secref["snipclassmapping"] for information about the kinds of
non-text content that can be read.}
有关可以读取的非文本内容类型的信息，请参见@secref["snipclassmapping"]。
  }


@defproc[(wxme-port->port [in input-port?]
                          [close? any/c #t]
                          [snip-filter (any/c . -> . any/c) (lambda (_x) _x)])
         input-port?]{

@;{Takes an input port whose stream starts with @tech{WXME}-format data
and returns an input port that produces text content converted to
bytes, and non-text content as ``special'' values (see
@racket[read-char-or-special]).}
  接受其流以@tech{WXME}格式数据开头的输入端口，并返回一个输入端口，该端口生成转换为字节的文本内容，而非文本内容作为“特殊”值（请参见@racket[read-char-or-special]）。

@;{These special values produced by the new input port are different than
the ones produced by reading a file into an @racket[editor<%>]
object. Instead of instances of the @racket[snip%], the special values
are typically simple extensions of @racket[object%].  See
@secref["snipclassmapping"] for information about the kinds of
non-text content that can be read.}
  新输入端口产生的这些特殊值与将文件读取到@racket[editor<%>]对象中产生的值不同。特殊值不是@racket[snip%]的实例，而是@racket[object%]的简单扩展。有关可以读取的非文本内容类型的信息，请参见@secref["snipclassmapping"]。

@;{If @racket[close?] is true, then closing the result port close the
original port.}
  如果@racket[close?]为真，那么关闭结果端口会关闭原始端口。

@;{The @racket[snip-filter] procedure is applied to any special value
generated for the stream, and its result is used as an alternate
special value.}
  @racket[snip-filter]过程应用于为流生成的任何特殊值，其结果用作备用特殊值。

@;{If a special value (possibly produced by the filter procedure) is an
object implementing the @racket[readable<%>] interface, then the
object's @method[readable<%> read-special] method is called to produce
the special value.}
如果一个特殊值（可能由过滤过程产生）是一个实现@racket[readable<%>]接口的对象，则调用该对象的 @method[readable<%> read-special]方法来产生该特殊值。
  }


@defproc[(extract-used-classes [in input-port?])
         (values (listof string?)
                 (listof string?))]{

@;{Returns two values: a list of snip-class names used by the given
stream, and a list of data-class names used by the stream. If the
stream is not a @tech{WXME} stream, the result is two empty lists. The
given stream is not closed, and only data for a @tech{WXME} stream (if
any) is consumed.}
返回两个值：给定流使用的剪切类名列表和流使用的数据类名列表。如果流不是@tech{WXME}流，则结果是两个空列表。给定流未关闭，并且仅使用@tech{WXME}流（如果有）的数据。
  }


@defproc[(register-lib-mapping! [str string?] 
                                [mod-path (cons/c 'lib (listof string?))])
         void?]{

@;{Maps a snip-class name to a quoted module path that provides a
@racket[reader%] implementation. The module path must have the form
@racket['(lib #,(racket _string ...))], where each @racket[_string]
contains only alpha-numeric ASCII characters, @litchar{.},
@litchar{_}, @litchar{-}, and spaces.}
将剪切类名映射到提供@racket[reader%]实现的带引号的模块路径。模块路径的格式必须为@racket['(lib #,(racket _string ...))]，其中每个字符串只包含字母数字ASCII字符、@litchar{.}、@litchar{_}、@litchar{-}和空格。
  }


@defproc[(string->lib-path [str string?] [gui? any/c])
         (or/c (cons/c 'lib (listof string?))
               #f)]{

@;{Returns a quoted module path for @racket[str] for either
@racket[editor<%>] mode when @racket[gui?] is true, or
@racketmodname[wxme] mode when @racket[gui?] is @racket[#f]. For the
latter, built-in mappings and mapping registered via
@racket[register-lib-mapping!] are used. If @racket[str] cannot be
parsed as a library path, and if no mapping is available (either
because the class is built-in or not known), the result is
@racket[#f].}
当@racket[gui?]是真，为@racket[editor<%>]模式返回一个@racket[str]的引用模块路径；当@racket[gui?]为@racket[#f]，为@racketmodname[wxme]模式返回。对于后者，内置映射和映射通过使用@racket[register-lib-mapping!]注册。如果无法将@racket[str]解析为库路径，并且没有可用的映射（因为类是内置的或未知的），则结果为@racket[#f]。
  }


@defboolparam[unknown-extensions-skip-enabled skip?]{

@;{A parameter. When set to #f (the default), an exception is raised when
an unrecognized snip class is encountered in a @tech{WXME}
stream. When set to a true value, instances of unrecognized snip
classes are simply omitted from the transformed stream.}
一个参数。当设置为#f（默认值）时，当@tech{WXME}流中遇到无法识别的剪切类时，会引发异常。当设置为真值时，无法识别的剪切类的实例只会从转换的流中简单地忽略。
  }


@defboolparam[broken-wxme-big-endian? big?]{

@;{A parameter. Some old and short-lived @tech{WXME} formats depended on
the endian order of the machine where the file was saved. Set this
parameter to pick the endian order to use when reading the file; the
default is the current platform's endian order.}
一个参数。一些旧的和短期的@tech{WXME}格式依赖于保存文件的机器的字节存储次序。设置此参数以选择读取文件时要使用的字节存储次序；默认值是当前平台的字节存储次序。
  }


@defproc[(wxme-read [in input-port?]) any/c]{

@;{Like @racket[read], but for a stream that starts with
@tech{WXME}-format data. If multiple S-expressions are in the
@tech{WXME} data, they are all read and combined with
@racket['begin].}
 与@racket[read]类似，但对于以@tech{WXME}格式数据开头的流而言。如果@tech{WXME}数据中有多个S表达式，则它们都将被读取并与@racket['begin]组合。 

@;{If @racket[racket/gui/base] is available (as determined by
@racket[gui-available?]), then @racket[open-input-text-editor] is
used. Otherwise, @racket[wxme-port->port] is used.}
如果@racket[racket/gui/base]可用（由可用的@racket[gui-available?]确定），然后使用@racket[open-input-text-editor]。否则，将使用@racket[wxme-port->port]。
}


@defproc[(wxme-read-syntax [source-v any/c] [in input-port?])
         (or/c syntax? eof-object?)]{

@;{Like @racket[read-syntax], but for a @tech{WXME}-format input stream.
If multiple S-expressions are in the @tech{WXME} data, they are all
read and combined with @racket['begin].}
  类似于@racket[read-syntax]，但对于@tech{WXME}格式的输入流。如果@tech{WXME}数据中有多个S表达式，则它们都将被读取并与@racket['begin]组合。

@;{If @racket[racket/gui/base] is available (as determined by
@racket[gui-available?]), then @racket[open-input-text-editor] is
used. Otherwise, @racket[wxme-port->port] is used.}
如果@racket[racket/gui/base]可用（由可用的@racket[gui-available?]确定），然后使用@racket[open-input-text-editor]。否则，将使用@racket[wxme-port->port]。
  }


@definterface[snip-reader<%> ()]{

@;{An interface to be implemented by a reader for a specific kind of data
in a @tech{WXME} stream. The interface has two methods:
@method[snip-reader<%> read-header] and @method[snip-reader<%> read-snip].}
  由读卡器为@tech{WXME}流中特定类型的数据实现的接口。接口有两种方法：@method[snip-reader<%> read-header]和@method[snip-reader<%> read-snip]。

@defmethod[(read-header [version exact-nonnegative-integer?]
                        [stream (is-a?/c stream<%>)])
           any]{

@;{Called at most once per @tech{WXME} stream to initialize the data
type's stream-specific information. This method usually does nothing.}
每个@tech{WXME}流最多调用一次以初始化数据类型的流特定信息。这种方法通常不起作用。
  }

@defmethod[(read-snip [text-only? boolean?]
                      [version exact-nonnegative-integer?]
                      [stream (is-a?/c stream<%>)])
           (if text-only?
               bytes?
               any/c)]{

@;{Called when an instance of the data type is encountered in the
stream. This method reads the data and returns either bytes to be
returned as part of the decoded stream or any other kind of value to
be returned as a ``special'' value from the decoded stream. The result
value can optionally be an object that implements
@racket[readable<%>].}
  在流中遇到数据类型的实例时调用。此方法读取数据并返回将作为解码流的一部分返回的字节，或者返回将作为解码流的“特殊”值返回的任何其他类型的值。结果值可以是实现@racket[readable<%>]的对象。

@;{The @racket[text-only?] argument is @racket[#f] when 
@racket[wxme-port->text-port] was called and @racket[#t]
when @racket[wxme-port->port] was called.}
调用@racket[wxme-port->text-port]时@racket[text-only?]参数为@racket[#f]，调用@racket[wxme-port->port]时参数为@racket[#t]。
  
}

}

@definterface[readable<%> ()]{

@;{An interface to be implemented by values returned from a snip reader.
The only method is @method[readable<%> read-special].}
 由剪切读取器返回的值实现的接口。唯一的方法是@method[readable<%> read-special]。 

@defmethod[(read-special [source any/c]
                         [line (or/c exact-nonnegative-integer? #f)]
                         [column (or/c exact-nonnegative-integer? #f)]
                         [position (or/c exact-nonnegative-integer? #f)])
           any/c]{

@;{Like @method[readable-snip<%> read-special], but for non-graphical
mode. When a value implements this interface, its @method[readable<%>
read-special] method is called with source-location information to
obtain the ``special'' result from the @tech{WXME}-decoding port.}
类似于@method[readable-snip<%> read-special]，但非图形模式。当一个值实现这个接口时，用源位置信息调用它的@method[readable<%>
read-special]方法，从@tech{WXME}解码端口获得“特定”结果。
 }
                 
}

@definterface[stream<%> ()]{

@;{Represents a @tech{WXME} input stream for use by
@racket[snip-reader<%>] instances.}
  表示供@racket[snip-reader<%>]实例使用的@tech{WXME}输入流。

@defmethod[(read-integer [what any/c]) exact-integer?]{

@;{Reads an exact integer, analogous to @method[editor-stream-in%
get-exact].}
读取一个精确的整数，类似于@method[editor-stream-in%
get-exact]。
  

@;{The @racket[what] field describes what is being read, for
error-message purposes, in case the stream does not continue with an
integer.}
@racket[what]字段描述在流不继续使用整数的情况下，出于错误消息的目的正在读取的内容。
  }

@defmethod[(read-fixed-integer [what any/c]) exact-integer?]{

@;{Reads an exact integer that has a fixed size in the stream, analogous
to @method[editor-stream-in% get-fixed].}
读取流中具有固定大小的精确整数，类似于@method[editor-stream-in% get-fixed]。
  
@;{The @racket[what] argument is as for @method[stream<%> read-integer].}
@racket[what]参数就好像@method[stream<%> read-integer]。
  }

@defmethod[(read-inexact [what any/c]) (and/c real? inexact?)]{

@;{Reads an inexact real number, analogous to @method[editor-stream-in%
get-inexact].}
  读一个不精确的实数，类似于@method[editor-stream-in%
get-inexact]。

@;{The @racket[what] argument is as for @method[stream<%> read-integer].}
@racket[what]参数就好像@method[stream<%> read-integer]。
  }

@defmethod[(read-raw-bytes [what any/c]) bytes?]{

@;{Reads raw bytes, analogous to @method[editor-stream-in%
get-unterminated-bytes].}
  读取原始字节，类似于@method[editor-stream-in%
get-unterminated-bytes]。

@;{The @racket[what] argument is as for @method[stream<%> read-integer].}
@racket[what]参数就好像@method[stream<%> read-integer]。
  }

@defmethod[(read-bytes [what any/c]) bytes?]{

@;{Reads raw bytes, analogous to @method[editor-stream-in% get-bytes].}
读取原始字节，类似于@method[editor-stream-in% get-bytes]。
  

@;{The @racket[what] argument is as for @method[stream<%> read-integer].}
@racket[what]参数就好像@method[stream<%> read-integer]。
  }

@defmethod[(read-editor [what any/c]) input-port?]{

@;{Reads a nested editor, producing a new input port to extract the
editor's content.}
  读取嵌套编辑器，生成新的输入端口以提取编辑器的内容。

@;{The @racket[what] argument is as for @method[stream<%> read-integer].}
@racket[what]参数就好像@method[stream<%> read-integer]。
  }
}

@defproc[(read-snip-from-port [name string?]
                              [who any/c]
                              [stream (is-a?/c stream<%>)])
         bytes?]{
  @;{Given @racket[name], which is expected to be the name of a snipclass,
  uses that snipclass to read from the given stream at the current point
  in that stream. Returns the processed bytes, much like the
  @method[snip-reader<%> read-snip] method.}
    给定@racket[name]（应为剪切类的名称）使用该剪切类在该流中的当前点从给定流中读取。返回处理的字节，与@method[snip-reader<%> read-snip]方法非常相似。
}

@; ----------------------------------------------------------------------

@;{@section[#:tag "snipclassmapping"]{Snip Class Mapping}}
@section[#:tag "snipclassmapping"]{剪切类映射}

@;{When graphical data is marshaled to the WXME format, it is associated
with a snip-class name to be matched with an implementation at load
time. See also @secref["editorsnipclasses"].}
当图形数据被封送到WXME格式时，它与剪切类名相关联，以便在加载时与实现相匹配。另请参见@secref["editorsnipclasses"]。

@;{Ideally, the snip-class name is generated as}
理想情况下，剪切类名生成为

@racketblock[
(format "~s" (list '(lib #,(racket _string ...))
                   '(lib #,(racket _string ...))))
]

@;{where each element of the @racket[format]ed list is a quoted module
path (see @racket[module-path?]). The @racket[_string]s must contain only
alpha-numeric ASCII characters, plus @litchar{.}, @litchar{_},
@litchar{-}, and spaces, and they must not be @racket["."] or
@racket[".."].}
其中@racket[format]列表的每个元素都是带引号的模块路径（请参见@racket[module-path?]）。@racket[_string]只能包含字母数字ASCII字符，加@litchar{.}、@litchar{_}、@litchar{-}和空格，并且不能是@racket["."]或@racket[".."]。

@;{In that case, the first quoted module path is used for loading
@tech{WXME} files in graphical mode; the corresponding module must
provide @racketidfont{snip-class} object that implements the
@racket[snip-class%] class. The second quoted module path is used by
the @racketmodname[wxme] library for converting @tech{WXME} streams
without graphical support; the corresponding module must provide a
@racketidfont{reader} object that implements the @racket[snip-reader<%>]
interface. Naturally, the @racket[snip-class%] instance and
@racket[snip-reader<%>] instance are expected to parse the same format, but
generate different results suitable for the different contexts (i.e.,
graphical or not).}


@;{If a snip-class name is generated as}


@racketblock[
(format "~s" '(lib #,(racket _string ...)))
]

@;{then graphical mode uses the sole module path, and
@racketmodname[wxme] needs a compatibility mapping. Install one with
@racket[register-lib-mapping!].}


@;{If a snip-class name has neither of the above formats, then graphical
mode can use the data only if a snip class is registered for the name,
or if it the name of one of the built-in classes: @racket["wxtext"],
@racket["wxtab"], @racket["wximage"], or @racket["wxmedia"] (for
nested editors). The @racketmodname[wxme] library needs a
compatibility mapping installed with @racket[register-lib-mapping!]
if it is not one of the built-in classes.}


@;{Several compatibility mappings are installed automatically for the
@racketmodname[wxme] library. They correspond to popular graphical
elements supported by various versions of DrRacket, including comment
boxes, fractions, XML boxes, Racket boxes, text boxes, and images
generated by the @racketmodname[htdp/image #:indirect] teachpack (or, more
generally, from @racketmodname[mrlib/cache-image-snip]), and test-case
boxes.}


@;{For a port created by @racket[wxme-port->port], nested editors are
represented by instances of the @racket[editor%] class provided by the
@racketmodname[wxme/editor] library. This class provides a single
method, @method[editor% get-content-port], which returns a port for
the editor's content. Images are represented as instances of the
@racket[image%] class provided by the @racketmodname[wxme/image]
library.}


@;{Comment boxes are represented as instances of a class that extends
@racket[editor%] to implement @racket[readable<%>]; see
@racketmodname[wxme/comment]. The read form produces a special comment
(created by @racket[make-special-comment]), so that the comment box
disappears when @racket[read] is used to read the stream; the
special-comment content is the readable instance. XML, Racket, and
text boxes similarly produce instances of @racket[editor%] and
@racket[readable<%>] that expand in the usual way; see
@racketmodname[wxme/xml], @racketmodname[wxme/scheme], and
@racket[wxme/text]. Images from the 
@racketmodname[htdp/image #:indirect] teachpack
are packaged as instances of @racket[cache-image%] from the
@racketmodname[wxme/cache-image] library. Test-case boxes are packaged
as instances of @racket[test-case%] from the
@racketmodname[wxme/test-case] library.}


@; ----------------------------------------

@;{@subsection{Nested Editors}}
@subsection{Nested Editors}

@defmodule[wxme/editor]

@defclass[editor% object% ()]{

@;{Instantiated for plain nested editors in a @tech{WXME} stream in text
mode.}
  

@defmethod[(get-content-port) input-port?]{

@;{Returns a port (like the one from @racket[wxme-port->port]) for the
editor's content.}

  }

}

@; ----------------------------------------

@;{@subsection{Images}}
@subsection{Images}

@defmodule[wxme/image]

@defclass[image% image-snip% ()]{

@;{Instantiated for images in a @tech{WXME} stream in text mode.
This class can just be treated like @racket[image-snip%] and should
behave just like it, except it has the methods below in addition
in case old code still needs them. In other words, the methods
below are provided for backwards compatibility with earlier 
verisons of Racket.}
  

@defmethod[(get-data) (or/c bytes? #f)]{

@;{Returns bytes for a PNG, XBM,or XPM file for the image.}

  }

@defmethod[(get-w) (or/c exact-nonnegative-integer? -1)]{

@;{Returns the display width of the image, which may differ from the
width of the actual image specified as data or by a filename; -1 means
that the image data's width should be used.}

  }

@defmethod[(get-h) (or/c exact-nonnegative-integer? -1)]{

@;{Returns the display height of the image, which may differ from the
height of the actual image specified as data or by a filename; -1
means that the image data's height should be used.}

  }

@defmethod[(get-dx) exact-integer?]{

@;{Returns an offset into the actual image to be used
as the left of the display image.}

  }

@defmethod[(get-dy) exact-integer?]{

@;{Returns an offset into the actual image to be used as the top of the
display image.}

  }

}

@; ----------------------------------------

@;{@section{DrRacket Comment Boxes}}
@section{DrRacket Comment Boxes}

@defmodule[wxme/comment]

@in[wxme/comment
@defthing[reader (is-a?/c snip-reader<%>)]{

@;{A text-mode reader for comment boxes.}

     }]


@defclass[comment-editor% editor% (readable<%>)]{

@;{Instantiated for DrRacket comment boxes in a @tech{WXME} stream for
text mode.}
  

@defmethod[(get-data) #f]{

@;{No data is available.}
  

}

@defmethod[(read-special [source any/c]
                         [line (or/c exact-nonnegative-integer? #f)]
                         [column (or/c exact-nonnegative-integer? #f)]
                         [position (or/c exact-nonnegative-integer? #f)])
           any/c]{

@;{Generates a special comment using @racket[make-special-comment]. The
special comment contains the comment text.}

  }

}

@; ----------------------------------------

@;{@section{DrRacket XML Boxes}}
@section{DrRacket XML Boxes}

@defmodule[wxme/xml]

@in[wxme/xml
@defthing[reader (is-a?/c snip-reader<%>)]{

@;{A text-mode reader for XML boxes.}

     }]


@defclass[xml-editor% editor% (readable<%>)]{

@;{Instantiated for DrRacket XML boxes in a @tech{WXME} stream for text
mode.}

  

@defmethod[(get-data) any/c]{

@;{Returns @racket[#t] if whitespace is elimited from the contained XML
literal, @racket[#f] otherwise.}

  }

@defmethod[(read-special [source any/c]
                         [line (or/c exact-nonnegative-integer? #f)]
                         [column (or/c exact-nonnegative-integer? #f)]
                         [position (or/c exact-nonnegative-integer? #f)])
           any/c]{

@;{Generates a @racket[quasiquote] S-expression that enclosed the XML,
with @racket[unquote] and @racket[unquote-splicing] escapes for nested
Racket boxes.}

  }

}

@; ----------------------------------------

@;{@section{DrRacket Racket Boxes}}
@section{DrRacket Racket Boxes}


@defmodule[wxme/scheme]

@in[wxme/scheme
@defthing[reader (is-a?/c snip-reader<%>)]{

@;{A text-mode reader for Racket boxes.}

     }]


@defclass[scheme-editor% editor% (readable<%>)]{

@;{Instantiated for DrRacket Racket boxes in a @tech{WXME} stream for text
mode.}
  

@defmethod[(get-data) any/c]{

@;{Returns @racket[#t] if the box corresponds to a splicing unquote,
@racket[#f] for a non-splicing unquote.}

  }

@defmethod[(read-special [source any/c]
                         [line (or/c exact-nonnegative-integer? #f)]
                         [column (or/c exact-nonnegative-integer? #f)]
                         [position (or/c exact-nonnegative-integer? #f)])
           any/c]{

@;{Generates an S-expression for the code in the box.}

  }

}

@; ----------------------------------------

@;{@section{DrRacket Text Boxes}}
@section{DrRacket Text Boxes}


@defmodule[wxme/text]

@in[wxme/text
@defthing[reader (is-a?/c snip-reader<%>)]{

@;{A text-mode reader for text boxes.}

     }]


@defclass[text-editor% editor% (readable<%>)]{

@;{Instantiated for DrRacket text boxes in a @tech{WXME} stream for text
mode.}
  

@defmethod[(get-data) #f]{

@;{No data is available.}

 }

@defmethod[(read-special [source any/c]
                         [line (or/c exact-nonnegative-integer? #f)]
                         [column (or/c exact-nonnegative-integer? #f)]
                         [position (or/c exact-nonnegative-integer? #f)])
           any/c]{

@;{Generates a string containing the text.}

  }

}

@; ----------------------------------------

@;{@section{DrRacket Fractions}}
@section{DrRacket Fractions}


@defmodule[wxme/number]

@in[wxme/number
@defthing[reader (is-a?/c snip-reader<%>)]{

@;{A text-mode reader for DrRacket fractions that generates exact,
rational numbers.}

     }]

@; ----------------------------------------

@;{@section{DrRacket Teachpack Images}}
@section{DrRacket Teachpack Images}

@defmodule[wxme/cache-image]

@in[wxme/cache-image
@defthing[reader (is-a?/c snip-reader<%>)]{

@;{A text-mode reader for images in a WXME stream generated by the
@racketmodname[htdp/image #:indirect] teachpack---or, more generally, by
@racketmodname[mrlib/cache-image-snip].}

     }]


@defclass[cache-image% object% ()]{

@;{Instantiated for DrRacket teachpack boxes in a @tech{WXME} stream for
text mode.}
  

@defmethod[(get-argb) (vectorof byte?)]{

@;{Returns a vector of bytes representing the content of the image.}

  }

@defmethod[(get-width) exact-nonnegative-integer?]{

@;{Returns the width of the image.}

  }

@defmethod[(get-height) exact-nonnegative-integer?]{

@;{Returns the height of the image.}

  }

@defmethod[(get-pin-x) exact-integer?]{

@;{Returns an offset across into the image for the pinhole.}

  }

@defmethod[(get-pin-y) exact-integer?]{

@;{Returns an offset down into the image for the pinhole.}

  }

}

@;{@section{DrRacket Test-Case Boxes}}
@section{DrRacket Test-Case Boxes}

@defmodule[wxme/test-case]

@in[wxme/test-case
@defthing[reader (is-a?/c snip-reader<%>)]{

@;{A text-mode reader for DrRacket test-case boxes in a WXME stream. It
generates instances of @racket[test-case%].}

     }]

@defclass[test-case% object% ()]{

@;{Instantiated for old-style DrRacket test-case boxes in a @tech{WXME}
stream for text mode.}

  

@defmethod[(get-comment) (or/c #f input-port?)]{

@;{Returns a port for the comment field, if any.}

  }

@defmethod[(get-test) input-port?]{

@;{Returns a port for the ``test'' field.}

  }

@defmethod[(get-expected) input-port?]{

@;{Returns a port for the ``expected'' field.}

  }

@defmethod[(get-should-raise) (or/c #f input-port?)]{

@;{Returns a port for the ``should raise'' field, if any.}

  }

@defmethod[(get-error-message) (or/c #f input-port?)]{

@;{Returns a port for the ``error msg'' field, if any.}

  }

@defmethod[(get-enabled?) boolean?]{

@;{Returns @racket[#t] if the test is enabled.}

  }

@defmethod[(get-collapsed?) boolean?]{

@;{Returns @racket[#t] if the test is collapsed.}

  }

@defmethod[(get-error-box?) boolean?]{

@;{Returns @racket[#t] if the test is for an exception.}

  }

}
