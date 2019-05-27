#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/menu-bar}}

@defclass/title[menu-bar% object% (menu-item-container<%>)]{

@;{A @racket[menu-bar%] object is created for a particular
 @racket[frame%] object. A frame can have at most one menu bar;
 @|MismatchExn| when a new menu bar is created for a frame that
 already has a menu bar.}
为特定的@racket[frame%]对象创建@racket[menu-bar%]对象。一个框架最多可以有一个菜单栏；当为已经有菜单栏的框架创建新的菜单栏时，@|MismatchExn|。


@defconstructor[([parent (or/c (is-a?/c frame%) 'root)]
                 [demand-callback ((is-a?/c menu-bar%) . -> . any) (lambda (m) (void))])]{

@;{Creates a menu bar in the specified frame. The menu bar is initially
 empty. If @indexed-racket['root] is supplied as @racket[parent], the
 menu bar becomes active only when no other frames are shown. A
 @racket['root] @racket[parent] is allowed only when
 @racket[current-eventspace-has-menu-root?] returns @racket[#t], and
 only if no such menu bar has been created before, otherwise
 @|MismatchExn|.}
  在指定框架中创建菜单栏。菜单栏最初为空。如果@indexed-racket['root]作为@racket[parent]提供，则只有在未显示其他框架时，菜单栏才会激活。只有当@racket[current-eventspace-has-menu-root?]返回@racket[#t]时才允许使用@racket['root] @racket[parent]，并且仅当以前未创建此类菜单栏时，否则@|MismatchExn|。
  
@;{The @racket[demand-callback] procedure is called by the default
@method[menu-item-container<%> on-demand] method with the object itself.}
  @racket[demand-callback]过程由对象本身的默认@method[menu-item-container<%> on-demand]方法调用。

}


@defmethod[(enable [enable? any/c])
           void?]{

@;{Enables or disables the menu bar (i.e., all of its menus).  Each
 menu's @method[labelled-menu-item<%> is-enabled?] method returns
 @racket[#f] only if the menu is specifically disabled (in addition to
 the menu bar).}
  启用或禁用菜单栏（即其所有菜单）。仅在菜单被特别禁用（除了菜单栏）时每个菜单的@method[labelled-menu-item<%> is-enabled?]方法返回@racket[#f]。

}


@defmethod[(get-frame)
           (or/c (is-a?/c frame%) 'root)]{

@;{Returns the menu bar's frame, or returns @racket['root] if the menu
bar is shown when no other frames are shown.}
  返回菜单栏的框架，如果没有显示其他框架时显示菜单栏，则返回@racket['root]。

}


@defmethod[(is-enabled?)
           boolean?]{

@;{Returns @racket[#t] if the menu bar is enabled, @racket[#f] otherwise.}
  如果启用菜单栏，则返回@racket[#t]，否则返回@racket[#f]。

}}
