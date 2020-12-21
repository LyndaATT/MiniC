open Ast

let afficher_type = function
  | Int -> "int"
  | Bool -> "bool"
  | Void -> "void"

let rec afficher_gl var =
  match var with
  | [] -> ()
  | x::suite -> begin
                  let (nom, t) = x in
                  Printf.printf " (%s : %s) " nom (afficher_type t);
                  afficher_gl suite
                end

let rec afficher_fn fn =
  match fn with
  | [] -> ()
  | x::suite ->
    begin
      Printf.printf "\tType : %s\n" (afficher_type x.return);
      Printf.printf "\tNom : %s\n" x.name;
      Printf.printf "\tLes params : ["; afficher_gl x.params ; Printf.printf "]\n";
      Printf.printf "\tLes variables locales: ["; afficher_gl x.locals ; Printf.printf "]\n";
    end

let afficher prog =
  let gl = prog.globals in
  let fn = prog.functions in
  Printf.printf "Les variables globales reconnues : [" ; afficher_gl gl ; Printf.printf "]\n";
  Printf.printf "Les fonctions reconnues : [\n" ;
  afficher_fn fn;
  Printf.printf "]\n"
