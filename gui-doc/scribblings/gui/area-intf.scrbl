#lang scribble/doc
@(require "common.rkt")

@definterface/title[area<%> ()]{

@;{An @racket[area<%>] object is either a window or a windowless
 container for managing the position and size of other areas. An
 @racket[area<%>] can be a container, a containee, or both. The only
 areas without a parent are top-level windows.}
@racket[area<%>]对象是用于管理其他区域位置和大小的窗口或无窗口容器。@racket[area<%>]可以是容器、窗格或两者。唯一没有父级的区域是顶级窗口。

@;{All @racket[area<%>] classes accept the following named instantiation
 arguments:}
 所有@racket[area<%>]类都接受以下命名的实例化参数：
@itemize[

 @item{@indexed-racket[min-width]@;{ --- default is the initial graphical minimum width; passed to @method[area<%> min-width]}——默认为初始图形最小宽度；传递到最小宽度@method[area<%> min-width]} 
 @item{@indexed-racket[min-height]@;{ --- default is the initial graphical minimum height; passed to @method[area<%> min-height]}——默认为初始图形最小高度；传递到最小高度@method[area<%> min-height]} 
 @item{@indexed-racket[stretchable-width]@;{ --- default is class-specific; passed to @method[area<%> stretchable-width]}——默认值特定于类；传递到可拉伸宽度@method[area<%> stretchable-width]} 
 @item{@indexed-racket[stretchable-height]@;{ --- default is class-specific; passed to @method[area<%> stretchable-height]}——默认值特定于类；传递到可拉伸高度@method[area<%> stretchable-height]} 
]



@defmethod[(get-graphical-min-size)
           (values dimension-integer?
                   dimension-integer?)]{

@;{Returns the area's graphical minimum size as two values: the minimum
 width and the minimum height (in pixels).}
  以两个值返回区域的图形最小大小：最小宽度和最小高度(以像素为单位)。

@;{See @|geomdiscuss| for more information. Note that the return value
 @italic{does not} depend on the area's
@method[area<%> min-width] and
@method[area<%> min-height] settings.}
 有关更多信息，请参见@|geomdiscuss|。请注意，返回值@italic{不}取决于区域的@method[area<%> min-width]和@method[area<%> min-height]设置。 

}

@defmethod[(get-parent)
           (or/c (is-a?/c area-container<%>) #f)]{

@;{Returns the area's parent. A top-level window may have no parent (in
 which case @racket[#f] is returned), or it may have another top-level
 window as its parent.}
  返回区域的父级。顶级窗口可能没有父级(在这种情况下返回@racket[#f]),或者它可能有另一个顶级窗口作为其父级。

}

@defmethod[(get-top-level-window)
           (or/c (is-a?/c frame%) (is-a?/c dialog%))]{

@;{Returns the area's closest frame or dialog ancestor. For a frame or
 dialog area, the frame or dialog itself is returned.}
  返回区域最近的框架或对话框原型。对于框架或对话框区域，将返回框架或对话框本身。

}

@defmethod*[([(min-width)
              dimension-integer?]
             [(min-width [w dimension-integer?])
              void?])]{

@;{Gets or sets the area's minimum width (in pixels) for geometry
 management.}
获取或设置用于几何图形管理的区域最小宽度(像素)。

@;{The minimum width is ignored when it is smaller than the area's
 @tech{graphical minimum width}, or when it is smaller
 than the width reported by
@method[area-container<%> container-size] if the area is a container. See @|geomdiscuss| for more information.}
如果最小宽度小于区域的图形最小宽度，或者如果最小宽度小于@method[area-container<%> container-size]报告的宽度(如果区域是容器)，则忽略最小宽度。有关更多信息，请参见@|geomdiscuss|。

@;{An area's initial minimum width is its graphical minimum width. See
 also
@method[area<%> get-graphical-min-size] .}
区域的初始最小宽度是其图形最小宽度。另请参见@method[area<%> get-graphical-min-size]。

@;{When setting the minimum width, if @racket[w] is smaller than the
 internal hard minimum, @|MismatchExn|.}
  设置最小宽度时，如果@racket[w]小于内部强制最小值，@|MismatchExn|。

}

@defmethod*[([(min-height)
              dimension-integer?]
             [(min-height [h dimension-integer?])
              void?])]{

@;{Gets or sets the area's minimum height for geometry management.}
  获取或设置用于几何图形管理的区域的最小高度。

@;{The minimum height is ignored when it is smaller than the area's
 @tech{graphical minimum height}, or when it is smaller
 than the height reported by
@method[area-container<%> container-size] if the area is a container. See @|geomdiscuss| for more information.}
 当最小高度小于区域的图形最小高度时，或当最小高度小于@method[area-container<%> container-size]报告的高度(如果区域是容器)时，忽略最小高度。有关更多信息，请参见@|geomdiscuss|。 

@;{An area's initial minimum height is its graphical minimum height. See
 also
@method[area<%> get-graphical-min-size] .}
  区域的初始最小高度是图形的最小高度。另请参见@method[area<%> get-graphical-min-size]。

@;{When setting the minimum height (in pixels); if @racket[h] is smaller
 than the internal hard minimum, @|MismatchExn|.}
  设置最小高度时(以像素为单位)；如果@racket[h]小于内部强制最小值，@|MismatchExn|。

}

@defmethod*[([(stretchable-height)
              boolean?]
             [(stretchable-height [stretch? any/c])
              void?])]{

@;{Gets or sets the area's vertical stretchability for geometry
 management. See @|geomdiscuss| for more information.}
  获取或设置用于几何图形管理的区域的垂直可伸缩性。有关更多信息，请参见@|geomdiscuss|。

}

@defmethod*[([(stretchable-width)
              boolean?]
             [(stretchable-width [stretch? any/c])
              void?])]{

@;{Gets or sets the area's horizontal stretchability for geometry
 management. See @|geomdiscuss| for more information.}
  获取或设置用于几何图形管理的区域的水平可伸缩性。有关更多信息，请参见@|geomdiscuss|。

}}
