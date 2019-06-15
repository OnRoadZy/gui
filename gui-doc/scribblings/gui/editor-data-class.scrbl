#lang scribble/doc
@(require "common.rkt")

@defclass/title[editor-data% object% ()]{

@;{An @racket[editor-data%] object contains extra data associated to a
snip or region in an editor. See also @|editordatadiscuss|.}
@racket[editor-data%]对象包含与编辑器中的剪切或区域关联的额外数据。另请参见@|editordatadiscuss|。

@defconstructor[()]{

@;{The element returned by @method[editor-data% get-next] is initialized
to @racket[#f].}
@method[editor-data% get-next]返回的元素初始化为@racket[#f]。
}

@defmethod[(get-dataclass)
           (or/c (is-a?/c editor-data-class%) #f)]{
@;{Gets the class for this data.}
  获取此数据的类。
}

@defmethod[(get-next)
           (or/c (is-a?/c editor-data%) #f)]{
@;{Gets the next editor data element in a list of editor data elements.
A @racket[#f] terminates the list.}
 获取编辑器数据元素列表中的下一个编辑器数据元素。@racket[#f]终止列表。 
}

@defmethod[(set-dataclass [v (is-a?/c editor-data-class%)])
           void?]{
  @;{Sets the class for this data.}
 设置此数据的类。   
}

@defmethod[(set-next [v (or/c (is-a?/c editor-data%) #f)])
           void?]{
  @;{Sets the next editor data element in a list of editor data elements.
A @racket[#f] terminates the list.}
  设置编辑器数据元素列表中的下一个编辑器数据元素。@racket[#f]终止列表。  
}

@defmethod[(write [f (is-a?/c editor-stream-out%)])
           boolean?]{
@methspec{

@;{Writes the data to the specified stream, returning @racket[#t] if data
is written successfully or @racket[#f] otherwise.}
规范：将数据写入指定的流，如果成功写入数据，则返回@racket[#t]，否则返回@racket[#f]。

}
@methimpl{

@;{Returns @racket[#f].}
  默认实现：返回@racket[#f]。

}}}

