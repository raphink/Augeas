(*
Module: Libvirt
  Parses /etc/libvirt/*.conf

Author: Raphael Pinson <raphael.pinson@camptocamp.com>

About: Reference

About: License
   This file is licenced under the LGPL v2+, like the rest of Augeas.

About: Lens Usage
   To be documented

About: Configuration files
   This lens applies to /etc/libvirt/*.conf. See <filter>.

About: Examples
   The <Test_Libvirt> file contains various examples and tests.
*)
module Libvirt =

autoload xfm

(* View: entry_gen
     A generic <entry>, using <Build.key_value_line_comment> *)
let entry_gen (lns:lens) =
     let equal = Util.delim "="
  in Util.indent . Build.key_value_line_comment Rx.word equal lns Util.comment_eol

(* View: sto_integer
     Storing an integer,
     with optional quotes,
     defaulting to no quotes *)
let sto_integer = Quote.do_quote_opt_nil (store Rx.integer)

(* View: sto_string
     Storing a string,
     with mandatory quotes,
     defaulting to double quotes *)
let sto_string  = Quote.do_quote (store (/[^ \t\n=#'"]+/ - Rx.integer))

(* View: list
     A list of entries.
     Each entry can be a <sto_integer> or a <sto_string> *)
let list =
     let list_entry = [ label "item" . sto_integer ]
                    | [ label "item" . sto_string ]
  in let lbrack = del /\[[ \t\n]*/ "["
  in let rbrack = del /[ \t\n]*\]/ "]"
  in let comma   = del /[ \t]*,[ \t\n]*/ ", "
  in let opt_comma = del /([ \t]*,)?/ ""
  in lbrack
   . Build.opt_list list_entry comma
   . opt_comma
   . rbrack

(* View: entry *)
let entry = entry_gen sto_integer
          | entry_gen sto_string
          | entry_gen list

(* View: lns *)
let lns = ( entry | Util.comment | Util.empty )*

(* Variable: filter *)
let filter = incl "/etc/libvirt/*.conf"

let xfm = transform lns filter

