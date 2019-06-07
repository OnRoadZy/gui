#lang scribble/doc
@(require "common.rkt")

@definterface/title[snip-class-list<%> ()]{

@;{Each eventspace has its own instance of @racket[snip-class-list<%>],
 obtained with @racket[(get-the-snip-class-list)]. New instances
 cannot be created directly. Each instance keeps a list of snip
 classes. This list is needed for loading snips from a file. See also
 @|snipclassdiscuss|.}
每个事件空间都有自己的@racket[snip-class-list<%>]实例，通过@racket[(get-the-snip-class-list)]获得。无法直接创建新实例。每个实例都保存一个剪切类的列表。从文件加载剪切需要此列表。另请参见@|snipclassdiscuss|。


@defmethod[(add [snipclass (is-a?/c snip-class%)])
           void?]{

@;{Adds a snip class to the list. If a class with the same name already
 exists in the list, this one will not be added.}
  向列表中添加剪切类。如果列表中已存在同名类，则不会添加该类。

}

@defmethod[(find [name string?])
           (or/c (is-a?/c snip-class%) #f)]{

@;{Finds a snip class from the list with the given name, returning
 @racket[#f] if none is found.}
  从列表中查找具有给定名称的剪切类，如果未找到，则返回@racket[#f]。

}

@defmethod[(find-position [class (is-a?/c snip-class%)])
           exact-nonnegative-integer?]{

@;{Returns an index into the list for the specified class.}
  将索引返回到指定类的列表中。

}

@defmethod[(nth [n exact-nonnegative-integer?])
           (or/c (is-a?/c snip-class%) #f)]{

@;{Returns the @racket[n]th class in the list, or @racket[#f] if
 the list has @racket[n] classes or less.}
  返回列表中的第@racket[n]个类，如果列表中有@racket[n]个或更少的类，则返回@racket[#f]。

}

@defmethod[(number)
           exact-nonnegative-integer?]{

@;{Returns the number of snip classes in the list.}
  返回列表中剪切类的数目。

}}
