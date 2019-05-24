#lang scribble/doc
@(require "common.rkt")

@definterface/title[clipboard<%> ()]{

@;{A single @racket[clipboard<%>] object, @indexed-racket[the-clipboard],
 manages the content of the system-wide clipboard for cut and paste.}
  一个单一的@racket[clipboard<%>]对象，即@indexed-racket[the-clipboard]，用于管理系统范围内的剪切和粘贴剪贴板的内容。

@;{On Unix, a second @racket[clipboard<%>] object,
 @indexed-racket[the-x-selection-clipboard], manages the content of the
 system-wide X11 selection. If the @ResourceFirst{selectionAsClipboard}
 preference (see @|mrprefsdiscuss|) is set to a non-zero true value,
 however, then @racket[the-clipboard] is always the same as
 @racket[the-x-selection-clipboard], and the system-wide X11 clipboard
 is not used.}
  在Unix上，第二个@racket[clipboard<%>]对象，@indexed-racket[the-x-selection-clipboard]管理系统范围内X11选择的内容。但是，如果@ResourceFirst{selectionAsClipboard}首选项（请参见@|mrprefsdiscuss|）设置为非零真值，则@racket[the-clipboard]始终与@racket[the-x-selection-clipboard]相同，并且不使用系统范围的X11剪贴板。

@;{On Windows and Mac OS, @racket[the-x-selection-clipboard] is
 always the same as @racket[the-clipboard].}
  在Windows和Mac OS上，@racket[the-x-selection-clipboard]始终与@racket[the-clipboard]相同。

@;{Data can be entered into a clipboard in one of two ways: by setting
 the current clipboard string or byte string, or by installing a
 @racket[clipboard-client%] object. When a client is installed,
 requests for clipboard data are directed to the client.}
  可以通过以下两种方式之一将数据输入剪贴板：设置当前剪贴板字符串或字节字符串，或安装@racket[clipboard-client%]对象。安装客户端后，对剪贴板数据的请求将定向到客户端。

@;{Generic data is always retrieved from the clipboard as a byte
 string. When retrieving clipboard data, a data type string specifies
 the format of the data string. The availability of different
 clipboard formats is determined by the current clipboard owner.}
  一般数据总是以字节字符串的形式从剪贴板中检索。检索剪贴板数据时，数据类型字符串指定数据字符串的格式。不同剪贴板格式的可用性由当前剪贴板所有者决定。


@defmethod[(get-clipboard-bitmap [time exact-integer?])
           (or/c (is-a?/c bitmap%) #f)]{

@;{Gets the current clipboard contents as a bitmap (Windows, Mac OS),
 returning @racket[#f] if the clipboard does not contain a bitmap.}
获取当前剪贴板内容作为位图(Windows、Mac OS)，如果剪贴板不包含位图，则返回@racket[#f]。
  
@;{See
@method[clipboard<%> get-clipboard-data] for information on eventspaces and the current clipboard client.}
有关事件空间和当前剪贴板客户端的信息，请参阅@method[clipboard<%> get-clipboard-data]。
  
@;{See @|timediscuss| for a discussion of the @racket[time] argument.  If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的论述，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}

@defmethod[(get-clipboard-data [format string?]
                               [time exact-integer?])
           (or/c bytes? string? #f)]{

@;{Gets the current clipboard contents in a specific format, returning
 @racket[#f] if the clipboard does not contain data in the requested
 format.}
获取特定格式的当前剪贴板内容，如果剪贴板不包含请求格式的数据,则返回@racket[#f]。
  
@;{If the clipboard client is associated to an eventspace that is not the
 current one, the data is retrieved through a callback event in the
 client's eventspace. If no result is available within one second, the
 request is abandoned and @racket[#f] is returned.}
如果剪贴板客户端与非当前事件空间相关联，则通过客户端事件空间中的回调事件检索数据。如果一秒钟内没有结果可用，则放弃请求并返回@racket[#f]。
  
@;{See @xmethod[clipboard-client% add-type] for information on
@racket[format].}
  有关@racket[format]的信息，请参阅@xmethod[clipboard-client% add-type]。

@;{See @|timediscuss| for a discussion of the @racket[time] argument.  If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的论述，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}

@defmethod[(get-clipboard-string [time exact-integer?])
           string?]{

@;{Gets the current clipboard contents as simple text, returning
 @racket[""] if the clipboard does not contain any text.}
获取当前剪贴板内容作为简单文本，如果剪贴板不包含任何文本，则返回@racket[""]。
  
@;{See @method[clipboard<%> get-clipboard-data] for information on
eventspaces and the current clipboard client.}
有关事件空间和当前剪贴板客户端的信息，请参阅@method[clipboard<%> get-clipboard-data]。
  
@;{See @|timediscuss| for a discussion of the @racket[time] argument.  If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的论述，请参见@|timediscuss|。如果时间超出平台特定的时间范围，@|MismatchExn|。

}


@defmethod[(same-clipboard-client? [owner (is-a?/c clipboard-client%)])
           boolean?]{

@;{Returns @racket[#t] if @racket[owner] currently owns the clipboard,
@racket[#f] otherwise.}
 如果@racket[owner]当前拥有剪贴板，则返回@racket[#t]，否则返回@racket[#f]。}


@defmethod[(set-clipboard-bitmap [new-bitmap (is-a?/c bitmap%)]
                                 [time exact-integer?])
           void?]{

@;{Changes the current clipboard contents to @racket[new-bitmap] (Windows, Mac OS)
 and releases the current clipboard client (if any).}
将当前剪贴板内容更改为@racket[new-bitmap]（Windows、Mac OS），并释放当前剪贴板客户端（如果有）。
  
@;{See @|timediscuss| for
 a discussion of the @racket[time] argument.  If @racket[time] is outside
 the platform-specific range of times, @|MismatchExn|.}
  有关@racket[time]参数的论述，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}

@defmethod[(set-clipboard-client [new-owner (is-a?/c clipboard-client%)]
                                 [time exact-integer?])
           void?]{

@;{Changes the clipboard-owning client: sets the client to
 @racket[new-owner] and associates @racket[new-owner] with the current
 eventspace (as determined by @racket[current-eventspace]). The
 eventspace association is removed when the client is no longer the
 current one.}
更改拥有剪贴板的客户端：将客户端设置为@racket[new-owner]，并将@racket[new-owner]与当前事件空间关联（由@racket[current-eventspace]确定）。当客户端不再是当前客户端时，将删除事件空间关联。
  
@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的论述，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}

@defmethod[(set-clipboard-string [new-text string?]
                                 [time exact-integer?])
           void?]{

@;{Changes the current clipboard contents to @racket[new-text],
 and releases the current clipboard client (if any).}
将当前剪贴板内容更改为@racket[new-text]，并释放当前剪贴板客户端（如果有）。

  
@;{See @|timediscuss| for
 a discussion of the @racket[time] argument.  If @racket[time] is outside
 the platform-specific range of times, @|MismatchExn|.}
  有关@racket[time]参数的论述,请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围,@|MismatchExn|。
}
}

