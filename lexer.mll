{
  open Lexing
  open Parser
  open Printf
  exception Eof
  exception Lexing_error of string
  
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
        "for",FOR;
        "putchar", PUTCHAR;
        "while", WHILE;
      ] ;
    fun s ->
      try  Hashtbl.find h s
      with Not_found -> IDENT(s)

}
let digit = ('-' | "") ['0'-'9']
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
    | '-'  { MINUS }
    | '*'  { MUL }
    | '{'  { LBRACE }
    | '}'  { RBRACE }
    | '!'  {NOT}
    | '/' { DIV }
    | '%' { MOD }
    | '>' { GT }
    | "==" { DOUBLE_EQ }
    | "<=" { LE }
    | ">=" { GE }
    | '&' { BIT_AND }
    | '|' { BIT_OR }
    | "!=" { NEQ }
    | "&&" { AND }
    | "||" { OR }  
    | "<<" { SHIFT_LEFT }
    | ">>" { SHIFT_RIGHT } 
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
