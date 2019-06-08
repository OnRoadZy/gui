#lang scribble/doc
@(require "common.rkt")

@defclass/title[style-list% object% ()]{

@;{A @racket[style-list%] object contains a set of @racket[style<%>]
 objects and maintains the hierarchical relationships between them. A
 @racket[style<%>] object can only be created through the methods of a
 @racket[style-list%] object. There is a global style list object,
 @indexed-racket[the-style-list], but any number of independent lists can be
 created for separate style hierarchies.  Each editor creates its own
 private style list.}
  @racket[style-list%]对象包含一组@racket[style<%>]对象，并维护它们之间的层次关系。@racket[style<%>]对象只能通过@racket[style-list%]对象的方法创建。有一个全局样式列表对象，即@indexed-racket[the-style-list]，但是可以为单独的样式层次结构创建任意数量的独立列表。每个编辑器都创建自己的私有样式列表。

@;{See @|stylediscuss| for more information.}
 有关详细信息，请参见@|stylediscuss|。 

@defconstructor[()]{

@;{The root style, named @racket["Basic"], is automatically created.}
将自动创建名为@racket["Basic"]的根样式。
}

@defmethod[#:mode public-final
                  (basic-style)
                  (is-a?/c style<%>)]{

@;{Returns the root style. Each style list has its own root style.}
返回根样式。每个样式列表都有自己的根样式。
  
@;{See also @|mrprefsdiscuss| for information about the
 @ResourceFirst{default-font-size}.}
有关@ResourceFirst{default-font-size}的信息，请参见@|mrprefsdiscuss|。
}


@defmethod[(convert [style (is-a?/c style<%>)])
           (is-a?/c style<%>)]{

@;{Converts @racket[style], which can be from another style list, to a style
in this list. If @racket[style] is already in this list, then @racket[ style]
is returned. If @racket[style] is named and a style by that name is
already in this list, then the existing named style is returned.
Otherwise, the style is converted by converting its base style
(and shift style if @racket[style] is a join style) and then creating
a new style in this list.}
将样式（可以是其他样式列表中的样式）转换为此列表中的@racket[style]。如果@racket[style]已在此列表中，则返回样式。如果@racket[style]已命名，并且该名称的样式已在此列表中，则返回现有的命名样式。否则，将通过转换其基本样式（如果@racket[style]是联接样式，则转换样式），然后在此列表中创建新样式来转换样式。
}

@defmethod[(find-named-style [name string?])
           (or/c (is-a?/c style<%>) #f)]{

@;{Finds a style by name. If no such style can be found, @racket[#f] is
returned.}
  按名称查找样式。如果找不到这样的样式，则返回@racket[#f]。

}

@defmethod[(find-or-create-join-style [base-style (is-a?/c style<%>)]
                                      [shift-style (is-a?/c style<%>)])
           (is-a?/c style<%>)]{

@;{Creates a new join style, or finds an appropriate existing one. The
returned style is always unnamed.  See @|stylediscuss| for more
information. }
创建新的联接样式，或查找适当的现有联接样式。返回的样式始终未命名。有关详细信息，请参见@|stylediscuss|。
  
@;{The @racket[base-style] argument must be a style within this style
 list.}
  @racket[base-style]参数必须是此样式列表中的样式。

}


@defmethod[(find-or-create-style [base-style (is-a?/c style<%>)]
                                 [delta (is-a?/c style-delta%)])
           (is-a?/c style<%>)]{

@;{Creates a new derived style, or finds an appropriate existing one.
The returned style is always unnamed.  See @|stylediscuss| for more
information.}
  创建新的派生样式，或查找适当的现有样式。返回的样式始终未命名。有关详细信息，请参见@|stylediscuss|。


@;{The @racket[base-style] argument must be a style within this style
list.  If @racket[base-style] is not a join style, if it has no name,
and if its delta can be collapsed with @racket[delta] (see
@xmethod[style-delta% collapse]), then the collapsed delta is used in
place of @racket[delta], and the base style of @racket[base-style] is
used in place of @racket[base-style]; this collapsing and substitution
of base styles is performed recursively.}
@racket[base-style]参数必须是此样式列表中的样式。如果@racket[base-style]不是联接样式，如果它没有名称，并且它的delta可以用@racket[delta]折叠（请参见@xmethod[style-delta% collapse]），则使用折叠的delta代替@racket[delta]，使用基样式的@racket[base-style]代替@racket[base-style]；这种基样式的折叠和替换是递归执行的。
 }


@defmethod[(forget-notification [key any/c])
           void?]{

@;{See @method[style-list% notify-on-change].}
  请参见@method[style-list% notify-on-change]。

@;{The @racket[key] argument is the value returned by @method[style-list%
notify-on-change].}
  @racket[key]参数是@method[style-list%
notify-on-change]返回的值。

}


@defmethod[(index-to-style [i exact-nonnegative-integer?])
           (or/c (is-a?/c style<%>) #f)]{

@;{Returns the style associated with the given index, or @racket[#f] for
 a bad index. See also @method[style-list% style-to-index].}
  返回与给定索引关联的样式，对于错误的索引返回@racket[#f]。另请参见@method[style-list% style-to-index]。

}


@defmethod[(new-named-style [name string?]
                            [like-style (is-a?/c style<%>)])
           (is-a?/c style<%>)]{

@;{Creates a new named style, unless the name is already being used. }
创建新的命名样式，除非该名称已被使用。
  
@;{If @racket[name] is already being used, then @racket[like-style] is
 ignored and the old style associated to the name is
 returned. Otherwise, a new style is created for @racket[name] with
 the same characteristics (i.e., the same base style and same style
 delta or shift style) as @racket[like-style].}
  如果@racket[name]已经被使用，那么@racket[like-style]将被忽略，并返回与该名称关联的旧样式。否则，将为具有相同特征（即相同的基本样式和相同的样式增量或移位样式）的@racket[name]创建一个新样式作为@racket[like-style]。

@;{The @racket[like-style] style must be in this style list, otherwise
 the named style is derived from the basic style with an empty style
 delta.}
  @racket[like-style]必须在此样式列表中，否则命名样式是从具有空样式增量的基样式派生的。

}

@defmethod[(notify-on-change [f ((or/c (is-a?/c style<%>) #f) . -> . any)])
           any/c]{

@;{Attaches a callback @racket[f] to the style list. The callback
 @racket[f] is invoked whenever a style is modified.}
  将回调@racket[f]附加到样式列表。每次修改样式时都会调用回调@racket[f]。

@;{Often, a change in one style will trigger a change in several other
 derived styles; to allow clients to handle all the changes in a
 batch, @racket[#f] is passed to @racket[f] as the changing style after a set of
 styles has been processed.}
  通常，一个样式中的更改会触发其他几个派生样式中的更改；为了允许客户端处理批处理中的所有更改，在处理一组样式后作为更改样式把@racket[#f]传递给@racket[f]。

@;{The return value from @method[style-list% notify-on-change] is an
 opaque key to be used with @method[style-list% forget-notification].}
  @method[style-list% notify-on-change]的返回值是用于@method[style-list% forget-notification]的不透明键。

@;{The callback @racket[f] replaces any callback for which it is
 @racket[equal?], which helps avoid redundant notifications in case of
 redundant registrations. The callback @racket[f] is retained only
 weakly (in the sense of @racket[make-weak-box]), but it is retained
 as long as any value that @racket[f] impersonates is reachable; for
 example, if @racket[f] represents a function with a contract applied,
 then @racket[f] is retained for notification as long as the original
 (pre-contract) function is reachable. The callback @racket[f] is also
 retained as long as the opaque key produced by @method[style-list%
 notify-on-change] is reachable.}
回调@racket[f]替换它是@racket[equal?]的任何回调,这有助于避免冗余注册时的冗余通知。回调@racket[f]仅被弱保留（在@racket[make-weak-box]的意义上），但只要@racket[f]模拟的任何值是可访问的，它就被保留；例如，如果@racket[f]表示应用了协定的函数，则只要原始（预定合约）函数是可访问的，就保留@racket[f]以供通知。只要可以访问由@method[style-list%
 notify-on-change]生成的不透明密钥，回调@racket[f]也会保留。
  }


@defmethod[(number)
           exact-nonnegative-integer?]{

@;{Returns the number of styles in the list.}
  返回列表中的样式数。

}

@defmethod[(replace-named-style [name string?]
                                [like-style (is-a?/c style<%>)])
           (is-a?/c style<%>)]{

@;{Like @method[style-list% new-named-style], except that if the name is
 already mapped to a style, the existing mapping is replaced.}
  与@method[style-list% new-named-style]类似，但如果名称已映射到样式，则替换现有映射。

}

@defmethod[(style-to-index [style (is-a?/c style<%>)])
           (or/c exact-nonnegative-integer? #f)]{

@;{Returns the index for a particular style. The index for a style's base
 style (and shift style, if it is a join style) is guaranteed to be
 lower than the style's own index. (As a result, the root style's
 index is always @racket[0].) A style's index can change whenever a new
 style is added to the list, or the base style or shift style of
 another style is changed.}
  返回特定样式的索引。样式的基样式（如果是连接样式，则为偏移样式）的索引保证低于样式自己的索引。（因此，根样式的索引始终为@racket[0]。）每当向列表中添加新样式或更改其他样式的基样式或移位样式时，样式的索引都会发生更改。

@;{If the given style is not in this list, @racket[#f] is returned.}
  如果给定的样式不在此列表中，则返回@racket[#f]。

}}

