
(* The type of tokens. *)

type token = 
  | WHILE
  | VOID
  | SEP
  | SCOLON
  | RPAREN
  | RETURN
  | RBRACE
  | PUTCHAR
  | PRINT
  | PLUS
  | MUL
  | LT
  | LPAREN
  | LBRACE
  | INT
  | IF
  | IDENT of (string)
  | FIN
  | EQUAL
  | ELSE
  | CST of (int)
  | COMMA
  | BOOL
  | AND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.prog)
