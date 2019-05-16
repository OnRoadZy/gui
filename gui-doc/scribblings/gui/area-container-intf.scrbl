#lang scribble/doc
@(require "common.rkt")

@definterface/title[area-container<%> (area<%>)]{

@;{An @racket[area-container<%>] is a container @racket[area<%>].}
@racket[area-container<%>]是一个容器@racket[area<%>]。

@;{All @racket[area-container<%>] classes accept the following named
instantiation arguments:}
所有@racket[area-container<%>]类接受以下命名实例化参数:
@itemize[

 @item{@indexed-racket[border]@;{ --- default is @racket[0]; passed to
@method[area-container<%> border]}——默认值为@racket[0]；传递到@method[area-container<%> border]} 
 @item{@indexed-racket[spacing]@;{ --- default is @racket[0]; passed to
@method[area-container<%> spacing]}——默认值为@racket[0]；传递到@method[area-container<%> spacing]} 
 @item{@indexed-racket[alignment]@;{ --- default is class-specific, such as
 @racket['(center top)] for @racket[vertical-panel%]; the list
 elements are passed to
@method[area-container<%> set-alignment]}——默认值是特定于类的，例如@racket[vertical-panel%]的@racket['(center top)]；列表元素将传递到@method[area-container<%> set-alignment]} 
]

@defmethod[(add-child [child (is-a?/c subwindow<%>)])
           void?]{
@;{Add the given subwindow to the set of non-deleted children. See also
@method[area-container<%> change-children].}
  将给定的子窗口添加到未删除的子窗口集。另请参见@method[area-container<%> change-children]。

}

@defmethod[(after-new-child [child (is-a?/c subarea<%>)])
           void?]{
@methspec{

@;{This method is called after a new containee area is created with this
 area as its container. The new child is provided as an argument to
 the method.}
  此方法在创建新的窗格区域后调用,该区域作为其容器。新子级作为方法的参数提供。

}
@methimpl{

@;{Does nothing.}
  默认实现:不执行任何操作。

}}

@defmethod[(begin-container-sequence)
           void?]{
@;{Suspends geometry management in the container's top-level window
 until
@method[area-container<%> end-container-sequence] is called. The
@method[area-container<%> begin-container-sequence] and 
@method[area-container<%> end-container-sequence] methods are used to bracket a set of container modifications so that
 the resulting geometry is computed only once.  A container sequence also 
 delays show and hide actions by
@method[area-container<%> change-children], as well as the on-screen part of showing via
@method[window<%> show] until the sequence is complete.  Sequence begin and end commands may
 be nested arbitrarily deeply.}
  挂起容器顶级窗口中的几何图形管理,直到调用@method[area-container<%> end-container-sequence]。@method[area-container<%> begin-container-sequence]和@method[area-container<%> end-container-sequence]方法用于将一组容器修改括起来，以便只计算一次生成的几何图形。容器序列还通过@method[area-container<%> change-children]延迟显示和隐藏操作，以及通过@method[window<%> show]在显示的部分屏幕上，直到序列完成。序列开始和结束命令可以任意深地嵌套。

}

@defmethod*[([(border)
              spacing-integer?]
             [(border [margin spacing-integer?])
              void?])]{

@;{Gets or sets the border margin for the container in pixels. This
 margin is used as an inset into the panel's client area before the
 locations and sizes of the subareas are computed.}
获取或设置容器的边框边距(像素)。在计算子区域的位置和大小之前，此边距用作插入面板的工作区。
}


@defmethod[(change-children [filter ((listof (is-a?/c subarea<%>)) 
                                     . -> . (listof (is-a?/c subarea<%>)))])
           void?]{

@;{Takes a filter procedure and changes the container's list of
non-deleted children. The filter procedure takes a list of
children areas and returns a new list of children areas. The new
list must consist of children that were created as subareas of
this area (i.e., @method[area-container<%> change-children]
cannot be used to change the parent of a subarea).}
  采用筛选过程并更改容器的未删除子项列表。筛选过程获取子区域列表并返回新的子区域列表。新列表必须包含创建为此区域的子区域的子区域(即,@method[area-container<%> change-children]不能用于更改子区域的父区域)。

@;{After the set of non-deleted children is changed, the container computes
 the sets of newly deleted and newly non-deleted children. Newly deleted
 windows are hidden. Newly non-deleted windows are shown.}
  更改未删除的子项集后，容器将计算新删除和新未删除的子项集。新删除的窗口将被隐藏。显示新的未删除窗口。

@;{Since non-window areas cannot be hidden, non-window areas cannot be
 deleted. If the filter procedure removes non-window subareas,
 an exception is raised and the set of non-deleted children is not changed.}
  由于不能隐藏非窗口区域，因此不能删除非窗口区域。如果筛选过程删除了非窗口子区域，则会引发异常，并且不会更改未删除的子区域集。

}

@defmethod[(container-flow-modified)
           void?]{
@;{Call this method when the result changes for an overridden flow-defining method, such as
@method[area-container<%> place-children]. The call notifies the geometry manager that the placement of the
 container's children needs to be recomputed. }
当重写的流定义方法，如@method[area-container<%> place-children]的结果更改时，调用此方法。调用通知几何管理器需要重新计算容器子级的位置。

@;{The
@method[area-container<%> reflow-container]method only recomputes child positions when the geometry manager
 thinks that the placement has changed since the last computation.}
@method[area-container<%> reflow-container]方法仅在几何管理器认为自上次计算以来位置已更改时重新计算子位置。
}

@defmethod[(container-size [info (listof (list/c dimension-integer?
                                                 dimension-integer?
                                                 any/c
                                                 any/c))])
           (values dimension-integer? dimension-integer?)]{

@;{Called to determine the minimum size of a container. See
 @|geomdiscuss| for more information.}
  调用以确定容器的最小大小。有关更多信息，请参见@|geomdiscuss|。

}

@defmethod[(delete-child [child (is-a?/c subwindow<%>)])
           void?]{
@;{Removes the given subwindow from the list of non-deleted children.  See also
@method[area-container<%> change-children].}
  从未删除的子窗口列表中删除给定的子窗口。另请参见@method[area-container<%> change-children]。

}

@defmethod[(end-container-sequence)
           void?]{

@;{See
@method[area-container<%> begin-container-sequence].}
  参见@method[area-container<%> begin-container-sequence]。

}

@defmethod[(get-alignment)
           (values (symbols 'right 'center 'left)
                   (symbols 'bottom 'center 'top))]{

@;{Returns the container's current alignment specification. See
@method[area-container<%> set-alignment] for more information.}
  返回容器的当前对齐规范。有关详细信息,请参见@method[area-container<%> set-alignment]。

}

@defmethod[(get-children)
           (listof (is-a?/c subarea<%>))]{
@;{Returns a list of the container's non-deleted children. (The non-deleted
 children are the ones currently managed by the container; deleted
 children are generally hidden.) The order of the children in the list
 is significant. For example, in a vertical panel, the first child in
 the list is placed at the top of the panel.}
  返回容器的未删除子级的列表。(未删除的子项是容器当前管理的子项；已删除的子项通常是隐藏的。)列表中子项的顺序非常重要。例如，在垂直面板中，列表中的第一个子项放置在面板的顶部。

}

@defmethod[(place-children [info (listof (list/c dimension-integer?
                                                 dimension-integer?
                                                 any/c
                                                 any/c))]
                           [width dimension-integer?]
                           [height dimension-integer?])
           (listof (list/c dimension-integer?
                           dimension-integer?
                           dimension-integer?
                           dimension-integer?))]{

@;{Called to place the children of a container. See @|geomdiscuss|
 for more information.}
  调用以放置容器的子级。有关更多信息,请参见@|geomdiscuss|。

}


@defmethod[(reflow-container)
           void?]{

@;{When a container window is not shown, changes to the container's
set of children do not necessarily trigger the immediate
re-computation of the container's size and its children's sizes
and positions.  Instead, the recalculation is delayed until the
container is shown, which avoids redundant computations between a
series of changes. The @method[area-container<%>
reflow-container] method forces the immediate recalculation of
the container's and its children's sizes and locations.}
  如果未显示容器窗口，则对容器的子级集所做的更改不一定会立即重新计算容器的大小及其子级的大小和位置。相反，重新计算会延迟到显示容器为止，这样可以避免一系列更改之间的重复计算。@method[area-container<%>
reflow-container]方法强制立即重新计算容器及其子容器的大小和位置。

@;{Immediately after calling the @method[area-container<%>
reflow-container] method, @method[window<%> get-size],
@method[window<%> get-client-size], @method[window<%> get-width],
@method[window<%> get-height], @method[window<%> get-x], and
@method[window<%> get-y] report the manager-applied sizes and
locations for the container and its children, even when the
container is hidden. A container implementation can call
functions such as @method[window<%> get-size] at any time to
obtain the current state of a window (because the functions do
not trigger geometry management).}
  在调用@method[area-container<%>
reflow-container]方法、@method[window<%> get-size]、@method[window<%> get-client-size]、@method[window<%> get-width]、@method[window<%> get-height]、@method[window<%> get-x]和@method[window<%> get-y]之后，立即报告管理器为容器及其子容器应用的大小和位置，即使容器是隐藏的。容器实现可以随时调用诸如@method[window<%> get-size]之类的函数来获取窗口的当前状态(因为函数不会触发几何管理)。

@;{See also @method[area-container<%> container-flow-modified].}
另请参见@method[area-container<%> container-flow-modified]。
}

@defmethod[(set-alignment [horiz-align (symbols 'right 'center 'left)]
                          [vert-align (symbols 'bottom 'center 'top)])
           void?]{
@;{Sets the alignment specification for a container, which determines how
 it positions its children when the container has leftover space (when
 a child was not stretchable in a particular dimension).}
  设置容器的对齐规范，该规范确定当容器有剩余空间时(当子容器在特定维度中不可拉伸时)如何定位其子容器。

@;{When the container's horizontal alignment is @racket['left], the
 children are left-aligned in the container and whitespace is inserted
 to the right.  When the container's horizontal alignment is
 @racket['center], each child is horizontally centered in the
 container. When the container's horizontal alignment is
 @racket['right], leftover whitespace is inserted to the left.}
  当容器的水平对齐方式为@racket['left]时，子级将在容器中左对齐，空白将插入到右侧。当容器的水平对齐方式为@racket['center]时，每个子容器在容器中水平居中。当容器的水平对齐方式为@racket['right]时，左上方的空白将插入到左侧。

@;{Similarly, a container's vertical alignment can be @racket['top],
 @racket['center], or @racket['bottom].}
  类似地，容器的垂直对齐方式可以是@racket['top]、@racket['center]或@racket['bottom]。

}

@defmethod*[([(spacing)
              spacing-integer?]
             [(spacing [spacing spacing-integer?])
              void?])]{

@;{Gets or sets the spacing, in pixels, used between subareas in the
 container. For example, a vertical panel inserts this spacing between
 each pair of vertically aligned subareas (with no extra space at the
 top or bottom).}
  获取或设置容器中子区域之间使用的间距(以像素为单位)。例如，垂直面板在每对垂直对齐的子区域之间插入此间距(顶部或底部没有额外空间)。
}

}

