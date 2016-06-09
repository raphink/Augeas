module MotionDist =

let comment = Util.comment_generic /[ \t]*[#;][ \t]*/ "# "

let empty = Util.empty

let entry = [ Util.indent . key Rx.word . Sep.space . store Rx.space_in . Util.eol ]

let lns = (comment | empty | entry)*
