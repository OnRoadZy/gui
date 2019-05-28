#lang scribble/doc
@(require "common.rkt")

@defclass/title[printer-dc% object% (dc<%>)]{

@;{A @racket[printer-dc%] object is a printer device context. A newly
 created @racket[printer-dc%] object obtains orientation (portrait
 versus landscape) and scaling information from the current
 @racket[ps-setup%] object, as determined by the
 @racket[current-ps-setup] parameter. This information can be
 configured by the user through a dialog shown by
 @racket[get-page-setup-from-user].}
  @racket[printer-dc%]对象是打印机设备上下文。新创建的@racket[printer-dc%]对象从当前@racket[ps-setup%]对象获取方向（纵向与横向）和缩放信息，由当前@racket[ps-setup%]参数确定。用户可以通过@racket[get-page-setup-from-user]显示的对话框配置此信息。

@|PrintNote|

@;{See also @racket[post-script-dc%].}
另请参见@racket[post-script-dc%]。
  
@;{When the @method[dc<%> end-doc] method is called on a
 @racket[printer-dc%] instance, the user may receive a dialog
 to determine how the document is printed.}
 当在@racket[printer-dc%]实例上调用@method[dc<%> end-doc]方法时，用户可能会收到一个对话框来确定如何打印文档。

@defconstructor[([parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f])]{

@;{If @racket[parent] is not @racket[#f], it is may be as the parent window
 of the dialog (if any) presented by @method[dc<%> end-doc].}
  如果@racket[parent]不是@racket[#f]，则它可能是由@method[dc<%> end-doc]显示的对话框（如果有）的父级窗口。

}}

