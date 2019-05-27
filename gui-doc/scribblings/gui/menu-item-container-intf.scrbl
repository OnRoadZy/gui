#lang scribble/doc
@(require "common.rkt")

@definterface/title[menu-item-container<%> ()]{

@;{A @racket[menu-item-container<%>] object is a @racket[menu%],
 @racket[popup-menu%], or @racket[menu-bar%].}
  @racket[menu-item-container<%>]对象是@racket[menu%]、@racket[popup-menu%]或@racket[menu-bar%]。


@defmethod[(get-items)
           (listof (is-a?/c menu-item<%>))]{
@;{Returns a list of the items in the menu, popup menu, or menu bar. The
 order of the items in the returned list corresponds to the order as
 the user sees them in the menu or menu bar.}
  返回菜单、弹出菜单或菜单栏中的项目列表。返回列表中项目的顺序与用户在菜单或菜单栏中看到的顺序相对应。

}


@defmethod[(on-demand)
           void?]{
@methspec{

@;{Called when the user clicks on the container as a menu bar (before the
 user sees any menu items, except with Unity's global menu bar as
 noted below), just before the container as a popup menu
 is popped up, or just before inspecting the menu bar containing the
 item for a shortcut key binding.}
  规范：当用户单击容器作为菜单栏时调用（在用户看到任何菜单项之前，除了下面指出的Unity的全局菜单栏），在容器作为弹出菜单弹出之前，或在检查包含该项的菜单栏以进行快捷键绑定之前。

@;{If the container is not a @tech{menu bar} or a @tech{popup menu}, this method is
 normally called via the @method[menu-item-container<%> on-demand]
 method of the container's owning menu bar or popup menu, because the
 default implementation of the method chains to the
 @method[labelled-menu-item<%> on-demand] method of its
 items. However, the method can be overridden in a container such that
 it does not call the @method[labelled-menu-item<%> on-demand] method
 of its items.}
  如果容器不是@tech{菜单栏}或@tech{弹出菜单}，则通常通过容器所属菜单栏或弹出菜单的@method[menu-item-container<%> on-demand]方法调用此方法，因为方法的默认实现链接到其项的@method[labelled-menu-item<%> on-demand]方法。但是，该方法可以在容器中重写，这样它就不会调用其项的@method[labelled-menu-item<%> on-demand]方法。

@;{On Unix with the Unity window manager using the global menu bar (which
 is the default on Ubuntu), @racket[racket/gui/base] receives no
 notification when the user clicks the menu bar. To approximate
 @method[menu-item-container<%> on-demand] triggered by user clicks of
 the menu bar, @method[menu-item-container<%> on-demand] is called for
 a @tech{menu bar} whenever its @racket[frame%] object loses the
 keyboard focus. Beware that if keyboard focus was lost because a menu
 was clicked, then items added to the clicked menu during an
 @method[menu-item-container<%> on-demand] invocation may not appear
 for the user.}
  在使用统一窗口管理器的Unix上，使用全局菜单栏（Ubuntu上的默认菜单栏），当用户单击菜单栏时，@racket[racket/gui/base]不会收到任何通知。为了估计用户点击菜单栏触发的@method[menu-item-container<%> on-demand]，每当@tech{菜单栏}的@racket[frame%]对象失去键盘焦点时，就会调用@method[menu-item-container<%> on-demand]。请注意，如果键盘焦点由于单击菜单而丢失，那么在@method[menu-item-container<%> on-demand]调用期间添加到单击菜单的项可能不会为用户显示。

}
 
@methimpl{

@;{Calls the @racket[demand-callback] procedure that was provided when
 the object was created, then calls the @method[labelled-menu-item<%>
 on-demand] method of the contained items.}
  默认实现：调用创建对象时提供的@racket[demand-callback]过程，然后调用所包含项的@method[labelled-menu-item<%>
 on-demand]方法。

}}}
