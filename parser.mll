{
  open Lexing
  open Parser
  open Printf
  exception Eof
  exception Lexing_error of string
  (* type lexeme =
      | CST of int
      | IDENT of string
      | SCOLON
      | DOT
      | LPAREN
      | RPAREN
      | APOS
      | COMMA
      | EQUAL
      | LESS
      | LEQ
      | GREATER
      | GEQ
      | PLUS
      | MINUS
      | MUL
      | DIV
      | MOD
      | XOR_CHR
      | EQQ
      | NET
      | NOT
      | QST
      | OR
      | LBRACE
      | RBRACE
      | ADD_ASSIGN
      | SUB_ASSIGN
      | MUL_ASSIGN
      | DIV_ASSIGN
      | MOD_ASSIGN
      | AND_ASSIGN
      | XOR_ASSIGN
      | OR_ASSIGN
      | AND
      | ELSE
      | ELSEIF
      | FALSE
      | FOR
      | IF
      | NULL
      | VOID
      | RETURN
      | TRUE
      | WHILE
      | PUTCHAR
      | MAIN
      | VAR
      | PRINT
      | NEQ
      | INT *)
  (* let keywords = [
        (* "int", INT;
        "bool", BOOL;
        "void", VOID;
        "if", IF; *)
        "else", ELSE;
        (* "return", RETURN; *)
        (* "while", WHILE; *)
        (* "putchar", PUTCHAR; *)
        (* "main", MAIN; *)
        (* "var",  VAR; *)

    ] *)
  let keyword_or_ident =
    let h = Hashtbl.create 17 in
    List.iter
      (fun (s, k) -> Hashtbl.add h s k)
      [
        "return", RETURN;
        "int", INT;
        "void", VOID;
        "bool", BOOL;
        "else", ELSE;
        "if",   IF;
        "print",PRINT;
        "putchar", PUTCHAR;
        "while", WHILE;
      ] ;
    fun s ->
      try  Hashtbl.find h s
      with Not_found -> IDENT(s)

  (* let id_or_kwd s =  try List.assoc s keywords with _ -> IDENT(s) *)


  (* let rec token_to_string s =
    match s with
    |CST(i) -> Printf.printf "%d" i
    |SCOLON -> Printf.printf ";"
    |LPAREN -> Printf.printf "("
    |RPAREN -> Printf.printf ")"
    |LBRACE -> Printf.printf "{"
    |RBRACE -> Printf.printf "}"
    |PLUS -> Printf.printf "+"
    |MUL -> Printf.printf "*"
    |AND -> Printf.printf "&&"
    |LESS -> Printf.printf "<"
    |EQUAL -> Printf.printf "="
    |COMMA -> Printf.printf ","
    |IDENT(s) -> Printf.printf "%s" s
    |IF -> Printf.printf "if"
    |ELSE -> Printf.printf "else"
    |INT -> Printf.printf "intt" *)

}

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let ident = alpha (digit | alpha | "_")*
let space = [' ' '\t']

rule token = parse
    | digit+ as n { CST(int_of_string n) }
    | space+ { token lexbuf }
    | "\n" { Lexing.new_line lexbuf; token lexbuf }
    | "---" { SEP }
    | "//" [^ '\n']* as s { printf "%s" s; token lexbuf }
    | "/*" { comment lexbuf }
    | ident as s  { keyword_or_ident s }
    | ';' { SCOLON }
    | '(' { LPAREN }
    | ')' { RPAREN }
    | ',' { COMMA }
    | '=' { EQUAL }
    | '<' { LT }
    | '+'  { PLUS }
    | '*'  { MUL }
    | '{'  { LBRACE }
    | '}'  { RBRACE }
    | "&&" { AND }
    | _ as s { raise (Lexing_error (Printf.sprintf "Caractère inconnu : %C\n" s)) }
    | eof { FIN }

and comment = parse
  | "*/" { printf "*/" ;comment lexbuf}
  | eof { raise Eof }
  | "\n" { Lexing.new_line lexbuf; comment lexbuf }
  | _ as c { printf "%c" c; comment lexbuf }
  | "/*" { printf "/*"; comment lexbuf }

{

}
