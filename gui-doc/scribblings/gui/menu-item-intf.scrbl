#lang scribble/doc
@(require "common.rkt")

@definterface/title[menu-item<%> ()]{

@;{A @racket[menu-item<%>] object is an element within a @racket[menu%],
 @racket[popup-menu%], or @racket[menu-bar%]. Operations that affect
 the parent --- such as renaming the item, deleting the item, or
 adding a check beside the item --- are accomplished via the
 @racket[menu-item<%>] object.}
  @racket[menu-item<%>]对象是@racket[menu%]、@racket[popup-menu%]或@racket[menu-bar%]中的元素。影响父级的操作——例如重命名项、删除项或在项旁边添加检查——是通过@racket[menu-item<%>]对象完成的。

@;{A menu item is either a @racket[separator-menu-item%] object (merely
 a separator), or a @racket[labelled-menu-item<%>] object; the latter
 is more specifically an instance of either @racket[menu-item%] (a
 plain menu item), @racket[checkable-menu-item%] (a checkable menu
 item), or @racket[menu%] (a submenu).}
  菜单项可以是@racket[separator-menu-item%]对象（仅是分隔符），也可以是@racket[labelled-menu-item<%>]对象；后者更具体地说是@racket[menu-item%]（普通菜单项）、@racket[checkable-menu-item%]（可选中菜单项）或@racket[menu%]（子菜单）的实例。


@defmethod[(delete)
           void?]{

@;{Removes the item from its parent. If the menu item is already deleted,
@method[menu-item<%> delete] has no effect.}
  从其父项中删除该项。如果菜单项已被删除，则@method[menu-item<%> delete]无效。

@;{See also @method[menu-item<%> restore].}
  另请参见@method[menu-item<%> restore]。

}

@defmethod[(get-parent)
           (or/c (is-a?/c menu%) (is-a?/c popup-menu%) (is-a?/c menu-bar%))]{

@;{Returns the menu, popup menu, or menu bar containing the item. The
 parent for a menu item is specified when the menu item is created,
 and it cannot be changed.}
  返回包含该项的菜单、弹出菜单或菜单栏。菜单项的父级是在创建菜单项时指定的，不能更改。

}

@defmethod[(is-deleted?)
           boolean?]{

@;{Returns @racket[#t] if the menu item is deleted from its parent,
 @racket[#f] otherwise.}
  如果菜单项从其父级删除，则返回@racket[#t]，否则返回@racket[#f]。

}

@defmethod[(restore)
           void?]{

@;{Adds a deleted item back into its parent. The item is always restored
 to the end of the parent, regardless of its original position. If the
 item is not currently deleted, @method[menu-item<%> restore] has no
 effect.}
  将已删除的项添加回其父项。无论项目的原始位置如何，该项目始终还原到父级的末尾。如果当前未删除该项目，则@method[menu-item<%> restore]无效。

}}

