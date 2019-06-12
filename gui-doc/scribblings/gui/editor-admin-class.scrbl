#lang scribble/doc
@(require "common.rkt")

@defclass/title[editor-admin% object% ()]{

@;{See @|admindiscuss| for information about the role of administrators.
 The @racket[editor-admin%] class is never instantiated directly. It
 is not even instantiated through derived classes by most programmers;
 each @racket[editor-canvas%] and @racket[editor-snip%] object
 creates its own administrator. However, it may be useful to derive a
 new instance of this class to display editors in a new context. Also,
 it may be useful to call the methods of an existing administrator
 from an owned editor.}
  有关管理员角色的信息，请参阅@|admindiscuss|。@racket[editor-admin%]类从未直接实例化。它甚至没有被大多数程序员通过派生类实例化；每个@racket[editor-canvas%]和@racket[editor-snip%]对象创建自己的管理员。但是，派生此类的新实例以在新上下文中显示编辑器可能很有用。此外，从拥有的编辑器调用现有管理员的方法可能很有用。

@;{To create a new @racket[editor-admin%] class, all methods described
 here must be overridden. They are all invoked by the administrator's
 editor.}
  若要创建新的@racket[editor-admin%]类，必须重写此处描述的所有方法。它们都由管理员的编辑器调用。

@defconstructor[()]{

@;{Creates a (useless) editor administrator.}
创建（无用的）编辑器管理员。

}

@defmethod[(get-dc [x (or/c (box/c real?) #f) #f]
                   [y (or/c (box/c real?) #f) #f])
           (or/c (is-a?/c dc<%>) #f)]{
@methspec{

@;{Returns either the drawing context into which the editor is displayed,
 or the context into which it is currently being drawn. When the
 editor is not embedded, the returned context is always the drawing
 content into which the editor is displayed. If the editor is not
 displayed, @racket[#f] is returned.}
  规范：返回显示编辑器的绘图上下文，或当前正在绘制编辑器的上下文。当编辑器未嵌入时，返回的上下文始终是显示编辑器的绘图内容。如果未显示编辑器，则返回@racket[#f]。

@;{The origin of the drawing context is also returned, translated into
 the local coordinates of the editor. For an embedded editor, the
 returned origin is reliable only while the editor is being drawn, or
 while it receives a mouse or keyboard event.}
  图形上下文的原点也会返回，并转换为编辑器的局部坐标。对于嵌入的编辑器，返回的原点仅在绘制编辑器或接收鼠标或键盘事件时可靠。

@;{@boxisfillnull[@racket[x] @elem{the x-origin of the DC in editor coordinates}]
@boxisfillnull[@racket[y] @elem{the y-origin of the DC in editor coordinates}]}
  @boxisfillnull[@racket[x] @elem{编辑器坐标中的DC的x坐标原点}]
@boxisfillnull[@racket[y] @elem{编辑器坐标中的DC的y坐标原点}]

@;{See also @xmethod[editor<%> editor-location-to-dc-location] and
 @xmethod[editor<%> dc-location-to-editor-location].}
另请参见@xmethod[editor<%> editor-location-to-dc-location]和@xmethod[editor<%> dc-location-to-editor-location]。
}
@methimpl{

@;{Fills all boxes with @racket[0.0] and returns @racket[#f].}
  默认实现：用@racket[0.0]填充所有框并返回@racket[#f]。

}}

@defmethod[(get-max-view [x (or/c (box/c real?) #f)]
                         [y (or/c (box/c real?) #f)]
                         [w (or/c (box/c (and/c real? (not/c negative?))) #f)]
                         [h (or/c (box/c (and/c real? (not/c negative?))) #f)]
                         [full? any/c #f])
           void?]{
@methspec{

@;{Same as @method[editor-admin% get-view] unless the editor is visible
 in multiple standard @techlink{display}s. If the editor has multiple
 @techlink{display}s, a region is computed that includes the visible
 region in all @techlink{display}s.}
  规格：与@method[editor-admin% get-view]相同，除非编辑器在多个标准@techlink{显示}中可见。如果编辑器有多个@techlink{显示}，则计算一个区域，该区域包括所有@techlink{显示}中的可见区域。

@;{See @method[editor-admin% get-view].}
  请参见@method[editor-admin% get-view]。

}
@methimpl{

@;{Fills all boxes with @racket[0.0].}
  默认实现：用@racket[0.0]填充所有框。

}}


@defmethod[(get-view [x (or/c (box/c real?) #f)]
                     [y (or/c (box/c real?) #f)]
                     [w (or/c (box/c (and/c real? (not/c negative?))) #f)]
                     [h (or/c (box/c (and/c real? (not/c negative?))) #f)]
                     [full? any/c #f])
           void?]{
@methspec{

@;{Gets the visible region of the editor within its @techlink{display} (in
 editor coordinates), or the overall size of the viewing region in the
 editor's top-level @techlink{display} (for an embedded editor).}
  规范：获取编辑器在其@techlink{显示}中的可见区域（以编辑器坐标为单位），或获取编辑器顶级@techlink{显示}中查看区域的总体大小（对于嵌入的编辑器）。



@;{If the @techlink{display} is an editor canvas, see also
 @method[area-container<%> reflow-container]. The viewing area within
 an editor canvas is not the full client area of the canvas, because
 an editor canvas installs a whitespace border around a displayed
 editor within the client area.}
  如果@techlink{显示}为编辑器画布，请参见@method[area-container<%> reflow-container]。编辑器画布中的查看区域不是画布的完整客户端区域，因为编辑器画布在客户端区域中显示的编辑器周围安装空白边框。

@;{The calculation of the editor's visible region is based on the current
 size and scrollbar values of the top-level @techlink{display}. For an
 editor canvas @techlink{display}, the region reported by
 @method[editor-admin% get-view] does not depend on whether the canvas
 is hidden, obscured by other windows, or moved off the edge of the
 screen.}
 编辑器可见区域的计算基于顶级@techlink{显示}的当前大小和滚动条值。对于编辑器画布@techlink{显示}，@method[editor-admin% get-view]报告的区域不取决于画布是隐藏的、被其他窗口遮挡的还是从屏幕边缘移开的。

@;{@boxisfillnull[@racket[x] @elem{the left edge of the visible region in editor coordinates}]
@boxisfillnull[@racket[y] @elem{the top edge of the visible region in editor coordinates}]
@boxisfillnull[@racket[w] @elem{the width of the visible region, which may be larger than the editor itself}]
@boxisfillnull[@racket[h] @elem{the height of the visible region, which may be larger than the editor itself}]}

   @boxisfillnull[@racket[x] @elem{编辑器坐标中可见区域的左边缘}]
@boxisfillnull[@racket[y] @elem{编辑器坐标中可见区域的上边缘}]
@boxisfillnull[@racket[w] @elem{可见区域的宽度，该宽度可能大于编辑器本身}]
@boxisfillnull[@racket[h] @elem{可见区域的高度，该宽度可能大于编辑器本身}]

@;{If an editor is fully visible and @racket[full?] is @racket[#f], then
 @racket[x] and @racket[y] will both be filled with @racket[0].}
  如果一个编辑器是完全可见和@racket[full?]为@racket[#f]，则@racket[x]和@racket[y]都将填充@racket[0]。

@;{If @racket[full?] is a true value, then the returned area is the view
 area of the top-level @techlink{display} for the editor. This result
 is different only when the editor is embedded in another editor; in
 that case, the @racket[x] and @racket[y] values may be meaningless,
 because they are in the coordinate system of the immediate editor
 within the top-level @techlink{display}.}
  如果@racket[full?]为真值，则返回的区域是编辑器的顶级@techlink{显示}的视图区域。只有当编辑器嵌入到另一个编辑器中时，此结果才不同；在这种情况下，@racket[x]和@racket[y]值可能毫无意义，因为它们位于顶级@techlink{显示}中的即时编辑器坐标系中。

}
@methimpl{

@;{Fills all boxes with @racket[0.0].}
  默认实现：用@racket[0.0]填充所有框。

}}

@defmethod[(grab-caret [domain (or/c 'immediate 'display 'global) 'global])
           void?]{
@methspec{

@;{Called by the editor to request the keyboard focus. If the request is
 granted, then the administered editor's @method[editor<%> own-caret]
 method will be called.}
  规范：由编辑器调用以请求键盘焦点。如果授予请求，则将调用受管编辑器@method[editor<%> own-caret]方法。

@;{See @method[editor<%> set-caret-owner] for information about the
 possible values of @racket[domain].}
  有关@racket[domain]的可能值的信息，请参阅@method[editor<%> set-caret-owner]。

}
@methimpl{

@;{Does nothing.}
 默认实现：不执行任何操作。 

}}


@defmethod[(modified [modified? any/c])
           void?]{
@methspec{

@;{Called by the editor to report that its modification state has
 changed to either modified or unmodified.}
  规范：由编辑器调用以报告其修改状态已更改为“已修改”或“未修改”。

@;{See also @xmethod[editor<%> set-modified].}
  另请参见@xmethod[editor<%> set-modified]。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}

@defmethod[(needs-update [localx real?]
                         [localy real?]
                         [w (and/c real? (not/c negative?))]
                         [h (and/c real? (not/c negative?))])
           void?]{
@methspec{

@;{Called by the editor to request a refresh to its displayed
 representation. When the administrator decides that the displayed
 should be refreshed, it calls the editor's @method[editor<%> refresh]
 method.}
  规范：由编辑器调用以请求刷新其显示的表示形式。当管理员决定刷新显示的内容时，它调用@method[editor<%> refresh]方法。

@;{The @racket[localx], @racket[localy], @racket[w], and @racket[h]
 arguments specify a region of the editor to be updated (in editor
 coordinates).}
  @racket[localx]、@racket[localy]、@racket[w]和@racket[h]参数指定要更新的编辑器区域（在编辑器坐标中）。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[(popup-menu [menu (is-a?/c popup-menu%)]
                       [x real?]
                       [y real?])
           boolean?]{
@methspec{

@;{@popupmenuinfo[@elem{administrator's @techlink{display}}
               @elem{top-level editor in this administrator's @techlink{display}}
               @elem{The result is @racket[#t] if the popup succeeds,
                  @racket[#f] otherwise (independent of whether the
                  user selects an item in the popup menu).}]}
  
  @popupmenuinfo[@elem{管理员的@techlink{显示}}                  
               @elem{此管理员的@techlink{显示}里的顶级编辑器}
               @elem{如果弹出成功，则结果为@racket[#t]，否则为@racket[#f]（与用户是否选择弹出菜单中的项目无关）。}]

@;{The menu is displayed at @racket[x] and @racket[y] in editor coordinates.}
  菜单显示在编辑器坐标的@racket[x]和@racket[y]处。

}
@methimpl{

@;{Returns @racket[#f].}
 默认实现：返回@racket[#f]。 

}}


@defmethod[(refresh-delayed?)
           boolean?]{

@methspec{

@;{Returns @racket[#t] if updating on this administrator's
 @techlink{display} is currently delayed (usually by
 @xmethod[editor<%> begin-edit-sequence] in an enclosing editor).}
  规范：如果此管理员@techlink{显示}上的更新当前被延迟，则返回@racket[#t]（通常通过封闭编辑器中的@xmethod[editor<%> begin-edit-sequence]实现）。

}
@methimpl{

@;{Returns @racket[#f].}
  默认实现：返回@racket[#f]。

}}


@defmethod[(resized [refresh? any/c])
           void?]{

@methspec{

@;{Called by the editor to notify its @techlink{display} that the
 editor's size or scroll count has changed, so the scrollbars need to
 be adjusted to reflect the new size. The editor generally needs to be
 updated after a resize, but the editor decides whether the update
 should occur immediately. If @racket[refresh?] is not @racket[#f],
 then the editor is requesting to be updated immediately.}
  规范：由编辑器调用，通知其@techlink{显示}编辑器的大小或滚动计数已更改，因此需要调整滚动条以反映新的大小。通常需要在调整大小后更新编辑器，但编辑器决定是否立即进行更新。如果@racket[refresh?]不是@racket[#f]，则编辑器请求立即更新。



}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[(scroll-to [localx real?]
                      [localy real?]
                      [w (and/c real? (not/c negative?))]
                      [h (and/c real? (not/c negative?))]
                      [refresh? any/c #t]
                      [bias (or/c 'start 'end 'none) 'none])
           boolean?]{
@methspec{

@;{Called by the editor to request scrolling so that the given region is
visible. The editor generally needs to be updated after a scroll, but
the editor decides whether the update should occur immediately.}
  规范：由编辑器调用以请求滚动，以使给定区域可见。编辑器通常需要在滚动后更新，但是编辑器决定是否立即更新。

@;{The @racket[localx], @racket[localy], @racket[w], and @racket[h]
 arguments specify a region of the editor to be made visible by the
 scroll (in editor coordinates).}
localx、localy、w和h参数指定要由滚动显示的编辑器区域（在编辑器坐标中）。  

@;{If @racket[refresh?] is not @racket[#f], then the editor is requesting
 to be updated immediately.}
  如果刷新？不是f，则编辑器请求立即更新。

@;{The @racket[bias] argument is one of:}
 偏见论点是： 
@itemize[
@item{@racket['start]@;{ --- if the range doesn't fit in the visible area, show the top-left region}
    ——如果范围不适合可见区域，则显示左上角区域}
@item{@racket['none]@;{ --- no special scrolling instructions}
    ——无特殊滚动说明}
@item{@racket['end]@;{ --- if the range doesn't fit in the visible area, show the bottom-right region}
    ——如果范围不适合可见区域，则显示右下方区域}
]

@;{The return value is @racket[#t] if the @techlink{display} is scrolled,
 @racket[#f] if not (either because the requested region is already
 visible, because the @techlink{display} has zero size, or because the
 editor is currently printing).}
  如果滚动@techlink{显示}，返回值为@racket[#t]；如果不滚动，返回值为@racket[#f]（可能是因为请求的区域已经可见，因为@techlink{显示}的大小为零，也可能是因为编辑器当前正在打印）。

@;{If an editor has multiple @techlink{displays}, then if any display
 currently has the keyboard focus, it is scrolled. Otherwise, the
 ``primary owner'' of the editor (see @method[editor-canvas%
 call-as-primary-owner]) is scrolled.}
 如果一个编辑器有多个@techlink{显示}，那么如果任何显示当前具有键盘焦点，则会滚动显示。否则，将滚动编辑器的“主要所有者”（参见@method[editor-canvas%
 call-as-primary-owner]）。

 

}
@methimpl{

@;{Return @racket[#f]}
  默认实现：返回@racket[#f]。

}}

@defmethod[(update-cursor)
           void?]{

@methspec{

@;{Queues an update for the cursor in the @techlink{display} for this
 editor.  The actual cursor used will be determined by calling the
 editor's @method[editor<%> adjust-cursor] method.}
  规范：在此编辑器的@techlink{显示}中为光标排队更新。实际使用的光标将通过调用编辑器的@method[editor<%> adjust-cursor]方法来确定。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}}

