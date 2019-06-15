#lang scribble/doc
@(require "common.rkt")

@definterface/title[editor-data-class-list<%> ()]{

@;{Each eventspace has an instance of @racket[editor-data-class-list<%>],
 obtained with @racket[(get-the-editor-data-class-list)]. New
 instances cannot be created directly. This list keeps a list of
 editor data classes; this list is needed for loading snips from a
 file. See also @|editordatadiscuss|.}
每个事件空间都有一个@racket[editor-data-class-list<%>]的实例，通过@racket[(get-the-editor-data-class-list)]获得。无法直接创建新实例。这个列表保存一个编辑器数据类的列表；这个列表是从一个文件加载剪切所必需的。另请参见@|editordatadiscuss|。

@defmethod[(add [snipclass (is-a?/c editor-data-class%)])
           void?]{
@;{Adds a snip data class to the list. If a class with the same name already
exists in the list, this one will not be added.}
向列表中添加剪切数据类。如果列表中已存在同名类，则不会添加该类。
}

@defmethod[(find [name string?])
           (or/c (is-a?/c snip-class%) #f)]{
@;{Finds a snip data class from the list with the given name, returning
 @racket[#f] if none can be found.}
从列表中查找具有给定名称的剪切数据类，如果找不到，则返回@racket[#f]。
}

@defmethod[(find-position [class (is-a?/c editor-data-class%)])
           exact-nonnegative-integer?]{
@;{Returns an index into the list for the specified class.}
将索引返回到指定类的列表中。
}

@defmethod[(nth [n exact-nonnegative-integer?])
           (or/c (is-a?/c editor-data-class%) #f)]{
@;{Returns the @racket[n]th class in the list (counting from 0), returning
 @racket[#f] if the list has @racket[n] or less classes.}
返回列表中的第@racket[n]个类（从0开始计数），如果列表中有@racket[n]个或更少的类，则返回@racket[#f]。
}

@defmethod[(number)
           exact-nonnegative-integer?]{

@;{Returns the number of editor data classes in the list.}
返回列表中编辑器数据类的数目。
}}

