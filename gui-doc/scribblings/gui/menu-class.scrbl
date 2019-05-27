#lang scribble/doc
@(require "common.rkt")

@defclass/title[menu% object% (menu-item-container<%> labelled-menu-item<%>)]{

@;{A @racket[menu%] object is a submenu within a @racket[menu%] or
 @racket[popup-menu%], or as a top-level menu in a
 @racket[menu-bar%].}
  @racket[menu%]对象是@racket[menu%]或@racket[popup-menu%]中的子菜单，或作为@racket[menu-bar%]中的顶级菜单。


@defconstructor[([label label-string?]
                 [parent (or/c (is-a?/c menu%) (is-a?/c popup-menu%) 
                               (is-a?/c menu-bar%))]
                 [help-string (or/c label-string? #f) #f]
                 [demand-callback ((is-a?/c menu%) . -> . any) (lambda (m) (void))])]{

@;{Creates a new menu with the given label.}
创建具有给定标签的新菜单。
  
@;{If @racket[label] contains a @litchar{&} or tab characters, they are
 handled specially in the same way as for menu-item labels and buttons. See
 @method[labelled-menu-item<%> set-label] and @racket[button%].}
  如果@racket[label]包含@litchar{&}或制表符字符，则它们的处理方式与菜单项标签和按钮的处理方式相同。请参见@method[labelled-menu-item<%> set-label]和@racket[button%]。

@;{If @racket[help-string] is not @racket[#f], the menu has a help
string. See @method[labelled-menu-item<%> get-help-string] for more
information.}
  如果@racket[help-string]不是@racket[#f]，则菜单有一个帮助字符串。有关详细信息，请参阅@method[labelled-menu-item<%> get-help-string]。

@;{The @racket[demand-callback] procedure is called by the default
@method[menu-item-container<%> on-demand] method with the object itself.}
  @racket[demand-callback]过程由对象本身的默认@method[menu-item-container<%> on-demand]方法调用。

}}

