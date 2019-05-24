#lang scribble/doc
@(require "common.rkt")

@defclass/title[clipboard-client% object% ()]{

@;{A @racket[clipboard-client%] object allows a program to take over
 the clipboard and service requests for clipboard data. See
 @racket[clipboard<%>] for more information.}
  @racket[clipboard-client%]对象允许程序接管剪贴板，并为剪贴板数据的请求提供服务。有关详细信息，请参阅@racket[clipboard<%>].

@;{A @racket[clipboard-client%] object is associated to an eventspace
 when it becomes the current client; see
@method[clipboard<%> set-clipboard-client] for more information.}
  @racket[clipboard-client%]对象在成为当前客户端时与事件空间相关联；有关详细信息，请参阅@method[clipboard<%> set-clipboard-client]。


@defconstructor[()]{

@;{Creates a clipboard client that supports no data formats.}
  创建支持无数据格式的剪贴板客户端。

}

@defmethod[(add-type [format string?])
           void?]{

@;{Adds a new data format name to the list supported by the clipboard
 client.}
  将新的数据格式名称添加到剪贴板客户端支持的列表中。

@;{The @racket[format] string is typically four capital letters. (On
 Mac OS, only four characters for @racket[format] are ever used.)
 For example, @racket["TEXT"] is the name of the UTF-8-encoded string
 format. New format names can be used to communicate application- and
 platform-specific data formats.}
  @racket[format]字符串通常是四个大写字母。(在Mac OS上，只有@racket[format]的四个字符曾被使用。)例如，@racket["TEXT"]是UTF-8编码字符串格式的名称。新的格式名称可用于通信特定于应用程序和平台的数据格式。

}

@defmethod[(get-data [format string?])
           (or/c bytes? string? #f)]{

@;{Called when a process requests clipboard data while this client is the
 current one for the clipboard. The requested format is passed to the
 method, and the result should be a byte string matching the requested
 format, or @racket[#f] if the request cannot be fulfilled.}
  当进程请求剪贴板数据而此客户端是剪贴板的当前客户端时调用。将请求的格式传递给方法，结果应为与请求的格式匹配的字节字符串，或者如果无法满足请求，则为@racket[#f]。

@;{Only data format names in the client's list will be passed to this
 method; see @method[clipboard-client% add-type].}
  只有客户端列表中的数据格式名称才会传递给此方法；请参见@method[clipboard-client% add-type]。

@;{When this method is called by the clipboard, the current eventspace is
 the same as the client's eventspace. If, at the point of the
 clipboard request, the current eventspace is not the client's
 eventspace, then current thread is guaranteed to be the handler
 thread of the client's eventspace.}
  当剪贴板调用此方法时，当前的事件空间与客户端的事件空间相同。如果在剪贴板请求点，当前的事件空间不是客户端的事件空间，那么当前线程就保证是客户端事件空间的处理程序线程。

}

@defmethod[(get-types)
           (listof string?)]{

@;{Returns a list of names that are the data formats supported by the
 clipboard client.}
  返回剪贴板客户端支持的数据格式的名称列表。

}

@defmethod[(on-replaced)
           void?]{
@;{Called when a clipboard client is dismissed as the clipboard owner
 (because the clipboard has be taken by another client or by an
 external application).}
  当剪贴板客户机被视为剪贴板所有者时调用（因为剪贴板已被其他客户端或外部应用程序占用）。

}

}
