#lang scribble/doc
@(require "common.rkt")

@defclass/title[snip-admin% object% ()]{

@;{See @|admindiscuss| for information about the role of administrators.
 The @racket[snip-admin%] class is never instantiated directly. It
 is not even instantiated through derived classes by most programmers;
 each @racket[text%] or @racket[pasteboard%] object
 creates its own administrator. However, it may be useful to derive a
 new instance of this class to display snips in a new context. Also,
 it may be useful to call the methods of an existing administrator
 from an owned snip.}
  有关管理员角色的信息，请参阅@|admindiscuss|。@racket[snip-admin%]类从未直接实例化。它甚至没有被大多数程序员通过派生类实例化；每个@racket[text%]或@racket[pasteboard%]对象创建自己的管理员。但是，派生此类的新实例以在新上下文中显示剪切可能很有用。此外，从拥有的剪切调用现有管理员的方法可能很有用。

@;{To create a new @racket[snip-admin%] class, all methods described here
 must be overridden. They are all invoked by the administrator's snip.}
  要创建新的@racket[snip-admin%]类，必须重写此处描述的所有方法。它们都是由管理员的剪切调用的。

@;{Because a @racket[snip-admin%] object typically owns more than one
 snip, many methods require a @racket[snip%] object as an argument.}
  由于@racket[snip-admin%]对象通常拥有多个剪切，许多方法需要@racket[snip%]对象作为参数。



@defconstructor[()]{

@;{Creates a (useless) editor administrator.}
  创建（无用的）编辑器管理员。

}

@defmethod[(get-dc)
           (or/c (is-a?/c dc<%>) #f)]{

@;{Gets a drawing context suitable for determining display size
 information. If the snip is not displayed, @racket[#f] is returned.}
  获取适用于确定显示大小信息的绘图上下文。如果没有显示剪切，则返回@racket[#f]。

}

@defmethod[(get-editor)
           (or/c (is-a?/c text%) (is-a?/c pasteboard%))]{

@;{Returns the editor that this administrator reports to (directly or
 indirectly).}
  返回此管理员报告的编辑器（直接或间接）。

}

@defmethod[(get-view [x (or/c (box/c real?) #f)]
                     [y (or/c (box/c real?) #f)]
                     [w (or/c (box/c (and/c real? (not/c negative?))) #f)]
                     [h (or/c (box/c (and/c real? (not/c negative?))) #f)]
                     [snip (or/c (is-a?/c snip%) #f) #f])
           void?]{
@methspec{

@;{Gets the @techlink{location} and size of the visible region of a snip in snip
 coordinates. The result is undefined if the given snip is not managed
 by this administrator.}
  规格：获取剪切坐标中剪切可见区域的@techlink{定位（location）}和大小。如果给定的剪切不由该管理员管理，则结果未定义。

@;{If @racket[snip] is not @racket[#f], the current visible region of the
 snip is installed in the boxes @racket[x], @racket[y], @racket[w],
 and @racket[h].  The @racket[x] and @racket[y] values are relative to
 the snip's top-left corner. The @racket[w] and @racket[h] values may
 be larger than the snip itself.}
  如果@racket[snip]不是@racket[#f]，则剪切的当前可见区域安装在框@racket[x]、@racket[y]、@racket[w]和@racket[h]中。@racket[x]和@racket[y]值相对于剪切的左上角。@racket[w]和@racket[h]值可能大于剪切本身。

@;{If @racket[snip] is @racket[#f], the total visible region of the
 snip's top-level @techlink{display} is returned in editor
 coordinates. Using @racket[#f] for @racket[snip] is analogous to
 using @racket[#t] for @racket[full?] in @xmethod[editor-admin%
 get-view].}
 如果@racket[snip]为@racket[#f]，则剪切顶级@techlink{显示}的总可见区域将以编辑器坐标返回。使用@racket[#f]进行@racket[snip]类似于在@xmethod[editor-admin%
 get-view]使用@racket[#t]进行@racket[full?]。 

@;{If no snip is specified, then the @techlink{location} and size of the snip's
 editor are returned, instead, in editor coordinates.}
  如果未指定剪切，则剪切编辑器的@techlink{定位}和大小将返回到编辑器坐标中。

@;{See also @xmethod[editor-admin% get-view].}
  另请参见@xmethod[editor-admin% get-view]。

}
@methimpl{

@;{Fills all boxes with @racket[0.0].}
默认实现：用@racket[0.0]填充所有框。

}}

@defmethod[(get-view-size [w (or/c (box/c (and/c real? (not/c negative?))) #f)]
                          [h (or/c (box/c (and/c real? (not/c negative?))) #f)])
           void?]{

@methspec{

@;{Gets the visible size of the administrator's @techlink{display} region.}
  规格：获取管理员@techlink{显示}区域的可见大小。

@;{If the @techlink{display} is an editor canvas, see also
 @method[area-container<%> reflow-container].}
 如果@techlink{显示}为编辑器画布，也请参见@method[area-container<%> reflow-container]。 

}
@methimpl{

@;{Fills all boxes with @racket[0.0].}
  默认实现：用@racket[0.0]填充所有框。

}
}

@defmethod[(modified [snip (is-a?/c snip%)]
                     [modified? any/c])
           void?]{
@methspec{

@;{Called by a snip to report that its modification state has changed to
 either modified or unmodified.}
  指定：由剪切调用以报告其修改状态已更改为已修改或未修改。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}

@defmethod[(needs-update [snip (is-a?/c snip%)]
                         [localx real?]
                         [localy real?]
                         [w (and/c real? (not/c negative?))]
                         [h (and/c real? (not/c negative?))])
           void?]{
@methspec{

@;{Called by the snip to request that the snip's display needs to be
 updated. The administrator determines when to actually update the
 snip; the snip's @method[snip% draw] method is eventually called.}
  规范：由剪切调用以请求剪切的显示需要更新。管理员决定何时实际更新剪切；最后调用剪切的@method[snip% draw]方法。

@;{The @racket[localx], @racket[localy], @racket[w], and @racket[h]
 arguments specify a region of the snip to be refreshed (in snip
 coordinates).}
  @racket[localx]、@racket[localy]、@racket[w]和@racket[h]参数指定要刷新的剪切区域（在剪切坐标中）。

@;{No update occurs if the given snip is not managed by this
 administrator.}
  如果给定的剪切不由该管理员管理，则不会发生更新。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}

@defmethod[(popup-menu [menu (is-a?/c popup-menu%)]
                       [snip (is-a?/c snip%)]
                       [x real?]
                       [y real?])
           boolean?]{
@methspec{

@;{Opens a popup menu in the @techlink{display} for this snip's editor.  The result
 is @racket[#t] if the popup succeeds, @racket[#f] otherwise (independent
 of whether the user selects an item in the popup menu).}
规格：在@techlink{显示}上打开一个弹出菜单，用于此剪切编辑器。如果弹出菜单成功，则结果为@racket[#t]，否则为@racket[#f]（与用户是否在弹出菜单中选择项目无关）。
  
@;{The menu is placed at @racket[x] and @racket[y] in @racket[snip]
 coordinates.}
菜单位于@racket[snip]坐标中的@racket[x]和@racket[y]处。
  
@;{While the menu is popped up, its target is set to the top-level editor
 in the @techlink{display} for this snip's editor. See
@method[popup-menu% get-popup-target] for more information.}
当弹出菜单时，它的目标被设置为该剪切编辑器@techlink{显示}的顶级编辑器。有关详细信息，请参见@method[popup-menu% get-popup-target]。
}
@methimpl{

@;{Returns @racket[#f].}
 默认实现：返回@racket[#f]。 

}}

@defmethod[(recounted [snip (is-a?/c snip%)]
                      [refresh? any/c])
           void?]{
@methspec{

@;{Called by a snip to notify the administrator that the specified snip
 has changed its @techlink{count}. The snip generally needs to be updated after
 changing its @techlink{count}, but the snip decides whether the update should
 occur immediately.}
  规范：由剪切调用，通知管理员指定的剪切已更改其@techlink{计数}。剪切通常需要在更改其@techlink{计数}后更新，但剪切决定是否立即更新。

@;{If @racket[refresh?] is not @racket[#f], then the snip is requesting
 to be updated immediately. Otherwise, @method[snip-admin%
 needs-update] must eventually be called as well.}
  如果@racket[refresh?]不是@racket[#f]，则剪切请求立即更新。否则，@method[snip-admin%
 needs-update]也必须调用需求更新。

@;{The method call is ignored if the given snip is not managed by this
 administrator.}
  如果给定的剪切不由该管理员管理，则忽略方法调用。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}

@defmethod[(release-snip [snip (is-a?/c snip%)])
           boolean?]{

@methspec{

@;{Requests that the specified snip be released. If this administrator is
 not the snip's owner or if the snip cannot be released, then
 @racket[#f] is returned. Otherwise, @racket[#t] is returned and the
 snip is no longer owned.}
  规格：要求释放指定的剪切。如果此管理员不是剪切的所有者，或者剪切无法释放，则返回@racket[#f]。否则返回@racket[#t]且剪切将不再拥有。

@;{See also @xmethod[editor<%> release-snip] .}
  另请参见@xmethod[editor<%> release-snip]。

@;{The result is @racket[#f] if the given snip is not managed by this
 administrator.}
  如果给定的剪切不由该管理员管理，则结果为@racket[#f]。

}
@methimpl{

@;{Returns @racket[#f].}
  默认实现：返回@racket[#f]。

}}


@defmethod[(resized [snip (is-a?/c snip%)]
                    [refresh? any/c])
           void?]{
@methspec{

@;{Called by a snip to notify the administrator that the specified snip
 has changed its display size. The snip generally needs to be updated
 after a resize, but the snip decides whether the update should occur
 immediately.}
 规范：由剪切调用，通知管理员指定的剪切已更改其显示大小。通常需要在调整大小后更新剪切，但剪切决定是否立即更新。

@;{If @racket[refresh?] is not @racket[#f], then the snip is requesting
 to be updated immediately, as if calling @method[snip-admin%
 needs-update].  Otherwise, @method[snip-admin% needs-update] must
 eventually be called as well.}
  如果@racket[refresh?]不是@racket[#f]，则剪切请求立即更新，就像调用@method[snip-admin%
 needs-update]一样。否则，最终也必须调用@method[snip-admin% needs-update]。

@;{The method call is ignored if the given snip is not managed by this
 administrator.}
  如果给定的剪切不由该管理员管理，则忽略方法调用。

}
@methimpl{

@;{Does nothing.}
 默认实现：不执行任何操作。 

}}


@defmethod[(scroll-to [snip (is-a?/c snip%)]
                      [localx real?]
                      [localy real?]
                      [w (and/c real? (not/c negative?))]
                      [h (and/c real? (not/c negative?))]
                      [refresh? any/c]
                      [bias (or/c 'start 'end 'none) 'none])
           boolean?]{
@methspec{

@;{Called by the snip to request scrolling so that the given region is
 visible. The snip generally needs to be updated after a scroll, but
 the snip decides whether the update should occur immediately.}
  规范：由剪切调用以请求滚动，以便给定区域可见。剪切通常需要在滚动后更新，但剪切决定是否立即更新。

@;{The @racket[localx], @racket[localy], @racket[w], and @racket[h] arguments specify
 a region of the snip to be made visible by the scroll (in snip
 coordinates).}
  @racket[localx]、@racket[localy]、@racket[w]和@racket[h]参数指定要由滚动显示的剪切区域（在剪切坐标中）。

@;{If @racket[refresh?] is not @racket[#f], then the editor is requesting to
 be updated immediately.}
  如果@racket[refresh?]不是@racket[#f]，则编辑器请求立即更新。

@;{The @racket[bias] argument is one of:}
  @racket[bias]参数是：
@itemize[

 @item{@racket['start]@;{ --- if the range doesn't fit in the visible area, show the top-left region}
        ——如果范围不适合可见区域，则显示左上角区域}

 @item{@racket['none]@;{ --- no special scrolling instructions}
        ——无特殊滚动说明}

 @item{@racket['end]@;{ --- if the range doesn't fit in the visible area, show the bottom-right region}
        ——如果范围不适合可见区域，则显示右下方区域}

]

@;{The result is @racket[#t] if the editor is scrolled, @racket[#f]
 otherwise.}
  如果滚动编辑器，则结果为@racket[#t]，否则为@racket[#f]。

@;{The method call is ignored (and the result is @racket[#f]) if the given
 snip is not managed by this administrator.}
  如果给定的剪切不由该管理员管理，则忽略方法调用（结果为@racket[#f]）。

}
@methimpl{

@;{Returns @racket[#f].}
  默认实现：返回@racket[#f]。

}}

@defmethod[(set-caret-owner [snip (is-a?/c snip%)]
                            [domain (or/c 'immediate 'display 'global)])
           void?]{
@methspec{

@;{Requests that the keyboard focus is assigned to the specified snip.
 If the request is granted, the @method[snip% own-caret] method of the
 snip is called.}
  规格：要求将键盘焦点分配给指定的剪切。如果授予请求，则调用剪切的@method[snip% own-caret]方法。

@;{See @method[editor<%> set-caret-owner] for information about the
 possible values of @racket[domain].}
  有关@racket[domain]的可能值的信息，请参阅@method[editor<%> set-caret-owner]。

@;{The method call is ignored if the given snip is not managed by this
 administrator.}
如果给定的剪切不由该管理员管理，则忽略方法调用。
}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[(update-cursor)
           void?]{

@methspec{

@;{Queues an update for the cursor in the @techlink{display} for this
 snip's editor.  The actual cursor used will be determined by calling
 the snip's @method[snip% adjust-cursor] method as appropriate.}
  规范：在这个剪切编辑器的@techlink{显示}中为光标排队更新。实际使用的光标将根据需要调用@method[snip% adjust-cursor]方法来确定。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[(get-line-spacing)
           (and/c real? (not/c negative?))]{

@methspec{

@;{Returns the spacing inserted by the snip's editor between each
line. }
  规范：返回剪切编辑器在每行之间插入的间距。
}
@methimpl{

@;{Returns @racket[0.0]}
  默认实现：返回@racket[0.0]。

}}

@defmethod[(get-selected-text-color)
           (or/c (is-a?/c color%) #f)]{

@methspec{

@;{Returns the color that is used to draw selected text or @racket[#f] if
selected text is drawn with its usual color.}
  规格：返回用于绘制所选文本的颜色，如果所选文本是用其常规颜色绘制的，则返回@racket[#f]。
}
@methimpl{

@;{Returns @racket[#f].}
  默认实现：返回@racket[#f]。
}}


@defmethod[(call-with-busy-cursor [thunk (-> any)])
           any]{

@methspec{

@;{Calls @racket[thunk] while changing the cursor to a watch cursor for
all windows in the current eventspace.}
  规范：在将光标更改为当前事件空间中所有窗口的监视光标时调用@racket[thunk]。

}

@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。
}}

@defmethod[(get-tabs [length (or/c (box/c exact-nonnegative-integer?) #f) #f]
                     [tab-width (or/c (box/c real?) #f) #f]
                     [in-units (or/c (box/c any/c) #f) #f])
           (listof real?)]{

@methspec{
@;{Returns the current tab-position array as a list.}
  规范：以列表形式返回当前选项卡位置数组。

@boxisfillnull[@racket[length] @elem{@;{the length of the tab array (and therefore the returned 
list)}选项卡数组的长度（因此返回的列表）}]
@boxisfillnull[@racket[tab-width] @elem{@;{the width used for tabs past the 
end of the tab array}用于选项卡的宽度超过了选项卡数组的结尾}]
@boxisfillnull[@racket[in-units] @elem{@;{@racket[#t] if the tabs are specified in
canvas units or @racket[#f] if they are specified in space-widths}如果标签以画布单位指定，则为@racket[#t]；如果标签以空格宽度指定，则为@racket[#f]}]
}

@methimpl{
@;{Returns @racket[null].}
  默认实现：返回空值。
}
}
}
