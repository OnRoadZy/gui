#lang scribble/doc
@(require "common.rkt")

@defclass/title[editor-data-class% object% ()]{

@;{An @racket[editor-data-class%] object defines a type for
@racket[editor-data%] objects. See also @|editordatadiscuss|.}
@racket[editor-data-class%]对象定义了@racket[editor-data%]对象的类型。另请参见@|editordatadiscuss|。

@defconstructor[()]{

@;{Creates a (useless) instance.}
创建（无用）实例。
}

@defmethod[(get-classname)
           string?]{

@;{Gets the name of the class. Names starting with @litchar{wx} are reserved for
internal use.}
获取类的名称。以@litchar{wx}开头的名称保留供内部使用。
}

@defmethod[(read [f (is-a?/c editor-stream-in%)])
           (or/c (is-a?/c editor-data%) #f)]{

@;{Reads a new data object from the given stream, returning @racket[#f] if
 there is an error.}
从给定流中读取新的数据对象，如果出现错误，则返回@racket[#f]。
}

@defmethod[(set-classname [v string?])
           void?]{

@;{Sets the name of the class. Names starting with @litchar{wx} are
 reserved for internal use.}
设置类的名称。以@litchar{wx}开头的名称保留供内部使用。

@;{An editor data class name should usually have the form @racket["(lib
 ...)"]  to enable on-demand loading of the class; see
 @|editordatadiscuss| for details.}
编辑器数据类名称的格式通常应为@racket["(lib
 ...)"]，以启用类的按需加载；有关详细信息，请参阅@|editordatadiscuss|。
}}
