#lang scribble/doc
@(require "common.rkt")

@defclass/title[snip-class% object% ()]{

@;{Useful snip classes are defined by instantiating derived subclasses of
 @racket[snip-class%]. A class derived from @racket[snip-class%]
 serves as a kind of ``meta-class'' for snips; each snip is associated
 with an instance of @racket[snip-class%] as its snip class.
 See @secref["snip-example"] for more information about deriving a new
  snip class.}
有用的剪切类是通过实例化@racket[snip-class%]的派生子类来定义的。从@racket[snip-class%]派生的类用作剪切的“元类”；每个剪切都与@racket[snip-class%]的实例关联，作为剪切类。有关派生新剪切类的更多信息，请参见@secref["snip-example"]。

@defconstructor[()]{

@;{Creates a (useless) snip class.}
  创建一个（无用的）剪切类。

}

@defmethod[(get-classname)
           string?]{

@;{Returns the class's name, a string uniquely designating this snip
 class. For example, the standard text snip classname is
 @racket["wxtext"]. Names beginning with @litchar{wx} are reserved.}
  返回类的名称，一个唯一指定此剪切类的字符串。例如，标准文本剪切类名是@racket["wxtext"]。以@litchar{wx}开头的名称是保留的。

@;{A snip class name should usually have the form @racket["((lib ...)
(lib ...))"]  to enable on-demand loading of the class. See
@|snipclassdiscuss| for details.}
  剪切类名的格式通常应为@racket["((lib ...)
(lib ...))"]，以启用类的按需加载。有关详细信息，请参见@|snipclassdiscuss|。

}

@defmethod[(get-version)
           exact-integer?]{

@;{Returns the version of this snip class. When attempting to load a file
 containing a snip with the same class name but a different version,
 the user is warned.}
  返回此剪切类的版本。当试图加载包含具有相同类名但版本不同的剪切的文件时，会警告用户。

}

@defmethod[(read [f (is-a?/c editor-stream-in%)])
           (or/c (is-a?/c snip%) #f)]{

@methspec{

@;{Reads a snip from a given stream, returning a newly created snip as
 the result or @racket[#f] if there is an error.}
  规范：从给定的流中读取剪切，返回新创建的剪切作为结果，如果有错误，则返回@racket[#f]。

}
@methimpl{

@;{Returns @racket[#f].}
  默认实现：返回@racket[#f]。

}}

@defmethod[(read-header [f (is-a?/c editor-stream-in%)])
           boolean?]{

@methspec{

@;{Called to read header information that may be useful for every snip
 read in this class. This method is only called once per editor read
 session, and only if the stream contains header information for this
 class.}
  规范：调用以读取标题信息，这些信息可能对此类中读取的每个剪切都有用。每个编辑器读取会话只调用一次此方法，并且仅当流包含此类的头信息时才调用此方法。

@;{The return value is @racket[#f] if a read error occurs or anything else
 otherwise.}
  如果发生读取错误或其他任何错误，返回值为@racket[#f]。

@;{See also @method[snip-class% write-header].}
 另请参见@method[snip-class% write-header]。 

}
@methimpl{

@;{Returns @racket[#t].}
  默认实现：返回@racket[#t]。

}}


@defmethod[(reading-version [stream (is-a?/c editor-stream-in%)])
           exact-integer?]{

@;{Returns the version number specified for this snip class for snips
 currently being read from the given stream.}
  返回为当前从给定流中读取的剪切类指定的版本号。

}


@defmethod[(set-classname [name string?])
           void?]{

@;{Sets the class's name. See also @method[snip-class% get-classname].}
  设置类的名称。另请参见@method[snip-class% get-classname]。

}


@defmethod[(set-version [v exact-integer?])
           void?]{

@;{Sets the version of this class. See @method[snip-class% get-version].}
  设置此类的版本。请参见@method[snip-class% get-version]。

}

@defmethod[(write-header [stream (is-a?/c editor-stream-out%)])
           boolean?]{

@methspec{

@;{Called to write header information that may be useful for every snip
 written for this class. This method is only called once per editor
 write session, and only if the editor contains snips in this class.}
  规范：调用它来编写头信息，这对于为这个类编写的每个剪切都可能有用。每个编辑器编写会话只调用一次此方法，并且仅当编辑器包含此类中的剪切时才调用此方法。

@;{When reading the snips back in, @method[snip-class% read-header] will
 only be called if @method[snip-class% write-header] writes some data
 to the stream.}
  当读取剪切时，只有当@method[snip-class% write-header]向流中写入一些数据时，才会调用@method[snip-class% read-header]。

@;{The return value is @racket[#f] if a write error occurs or anything else
 otherwise.}
  如果发生写入错误或其他任何情况，返回值为@racket[#f]。

}
@methimpl{

@;{Returns @racket[#t].}
 默认实现：返回@racket[#t]。 

}}
}
