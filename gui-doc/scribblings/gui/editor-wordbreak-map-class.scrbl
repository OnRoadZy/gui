#lang scribble/doc
@(require "common.rkt")

@defclass/title[editor-wordbreak-map% object% ()]{

@;{An @racket[editor-wordbreak-map%] objects is used with a
 @racket[text%] objects to specify word-breaking criteria for the
 default wordbreaking function.  See also @method[text%
 set-wordbreak-map], @method[text% get-wordbreak-map], @method[text%
 find-wordbreak], and @method[text% set-wordbreak-func].}
  @racket[editor-wordbreak-map%]对象与@racket[text%]对象一起使用，以指定默认分词函数的分词条件。另请参见@method[text%
 set-wordbreak-map]、@method[text% get-wordbreak-map]、@method[text%
 find-wordbreak]和@method[text% set-wordbreak-func]。

@;{A global object @racket[the-editor-wordbreak-map] is created
 automatically and used as the default map for all @racket[text%]
 objects.}
  一个全局对象@racket[the-editor-wordbreak-map]将自动创建，并用作所有@racket[text%]对象的默认映射。

@;{A wordbreak objects implements a mapping from each character to a list
  of symbols. The following symbols are legal elements of the list:}
  分词对象实现从每个字符到符号列表的映射。以下符号是列表的法定元素：

@itemize[
@item{@indexed-racket['caret]}
@item{@indexed-racket['line]}
@item{@indexed-racket['selection]}
@item{@indexed-racket['user1]}
@item{@indexed-racket['user2]}
]

@;{The presence of a flag in a character's value indicates that the
 character does not break a word when searching for breaks using the
 corresponding reason. For example, if @racket['caret] is present,
 then the character is a non-breaking character for caret-movement
 words. (Each stream of non-breaking characters is a single word.)}
字符值中的标志表示字符在使用相应的原因搜索分隔符时不会打断单词。例如，如果存在@racket['caret]，则字符是插入符号移动字的非中断字符。（每个非中断字符流都是一个单个单词。）


@defconstructor[()]{

@;{All ASCII alpha-numeric characters are initialized with
 @racket['(caret line selection)]. All other ASCII non-whitespace
 characters except @litchar{-} are initialized with
 @racket['(line)]. All ASCII whitespace characters and @litchar{-} are
 initialized with @racket[null].}
  所有ASCII字母数字字符都用@racket['(caret line selection)]初始化。除@litchar{-}之外的所有其他ASCII非空白字符都用@racket['(line)]初始化。所有ASCII空白字符和@litchar{-}都用@racket[null]初始化。

}

@defmethod[(get-map [char char?])
           (listof (or/c 'caret 'line 'selection 'user1 'user2))]{

@;{Gets the mapping value for @racket[char].  See
@racket[editor-wordbreak-map%] for more information.}
  获取@racket[char]的映射值。有关详细信息，请参阅@racket[editor-wordbreak-map%]。

}

@defmethod[(set-map [char char?]
                    [value (listof (or/c 'caret 'line 'selection 'user1 'user2))])
           void?]{


@;{Sets the mapping value for @racket[char] to @racket[value].  See
@racket[editor-wordbreak-map%] for more information.}
  设置@racket[char]到@racket[value]的映射值。有关详细信息，请参阅@racket[editor-wordbreak-map%]。

}}
