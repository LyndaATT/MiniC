(* ocamllex lexer.mll
menhir parser.mly
ocamlc ast.ml parser.mli parser.ml lexer.ml main.ml
./a.out (car mon main a le fichier d'entrée ready) *)

(* ou  *)

(* ocamlbuild -use-menhir main.native *)
open Aff

let _ =
  let fichier = Sys.argv.(1) in
  let c = open_in fichier in
  let lexbuf = Lexing.from_channel c in
  let prog = Parser.prog Lexer.token lexbuf in
  afficher prog;
  ignore(prog);
  close_in c;
  exit 0
