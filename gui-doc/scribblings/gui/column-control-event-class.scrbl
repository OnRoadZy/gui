#lang scribble/doc
@(require "common.rkt")

@defclass/title[column-control-event% control-event% ()]{

@;{A @racket[column-control-event%] object contains information about a
 event on an @racket[list-box%] column header.}
  @racket[column-control-event%]对象包含有关@racket[list-box%]列标题上事件的信息。

@defconstructor[([column exact-nonnegative-integer?]
                 [event-type (or/c 'list-box-column)]
                 [time-stamp exact-integer? 0])]{

@;{The @racket[column] argument indicates the column that was clicked.}
  @racket[column]参数指示单击的列。
}

@defmethod[(get-column) exact-nonnegative-integer?]{

@;{Returns the column number (counting from 0) of the clicked column.}
  返回单击列的列号（从0开始计数）。
}

@defmethod[(set-column
            [column exact-nonnegative-integer?])
           void?]{


@;{Sets the column number (counting from 0) of the clicked column.}
  设置单击列的列号（从0开始计数）。

}}
