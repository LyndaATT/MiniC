open Ast
(* affichage chars*)
let str_chars n character=
  let rec str_chars n acc=
    match n with
    | 0 -> acc
    | x -> str_chars (n-1) (Printf.sprintf "%s%c" acc character)
  in
  str_chars n ""
;;


(* affichage d'une expression *)
let rec str_expr (e : expr) : string=
    match e with
      | Cst(e1)    -> Printf.sprintf "Cst %i" e1
      | Add(e1,e2)  -> Printf.sprintf "Add(%s, %s)" (str_expr e1) (str_expr e2)
      | Mul(e1,e2)  -> Printf.sprintf "Mul(%s, %s)" (str_expr e1) (str_expr e2)
      | Lt(e1,e2)   -> Printf.sprintf "Lt(%s, %s)"  (str_expr e1) (str_expr e2)
      | Get(e1)    -> Printf.sprintf "Get(%s)" e1
      | Call(e1,e2) ->
                     Printf.sprintf "%s(%s)" e1 (List.fold_left (str_Param) "" e2 )
      | _ -> "undefined expr"
and str_Param (str:string) (param : expr) : string = (* affichage d'une expression *)
  Printf.sprintf "%s,%s" str (str_expr param)
;;


(* affichage d'une sequence d'instructions *)
let str_Seq (instrs : seq) : string=
  let rec str_Seq (instrs : seq) (str: string) indentation =
    let espace = str_chars indentation ' ' in
    match instrs with
      |[]     -> Printf.sprintf "%s" str
      |i1::i2 -> str_Seq i2 (Printf.sprintf "%s\n%s%s" str espace (str_Instr i1 indentation)) indentation
  and str_Instr (instr : instr) indentation: string =
    let espace = str_chars indentation ' ' in
    match instr with
      | Return(v)  -> Printf.sprintf "return (%s);" (str_expr v)
      | Expr(v)  -> Printf.sprintf "execute (%s);" (str_expr v)
      | Putchar(v)  -> Printf.sprintf "putchar (%s);" (str_expr v)
      | Set(id,v)  -> Printf.sprintf "v %s = %s;" (id) (str_expr v)
     (* | If(c,s1,s2) ->
      Printf.sprintf "\n%sif(%s){%s\n%s}else{%s\n%s}"
         espace 
         (str_expr c)  (*condition*)
         (str_Seq s1 ""  indentation) (*sequence d'instruction du if*)
         espace 
         (str_Seq s2 "" indentation) (*sequence d'instructions du else*)
         str_Instr*)
      | While(c,s) -> Printf.sprintf "while(%s){%s\n%s}" (str_expr c) (str_Seq s "" indentation)  espace
      | _           -> "undefined instruction"
  in
  (*traitement de toutes les instructions*)
  match instrs with
    |[]     -> Printf.sprintf "No instructions"
    |i1::i2 -> str_Seq i2 (Printf.sprintf "%s" (str_Instr i1 1)) 1
;;
(* affichage des types *)
let str_Typ typ=
  match typ with
  | Int -> "int"
  | Bool -> "bool"
  | Void -> "void"
;;

(* affichage des params de fonctions et des vars locals et globales, en gros toutes les listes comprenant des vars*)
let str_list_vars vl =
  let rec str_list_vars vl acc=
    match vl with
      | [] -> acc
      | v1::v2 -> str_list_vars v2 (Printf.sprintf "%s,%s %s" acc (str_Typ (snd v1)) (fst v1)) (*attention ici on inverse car on a une paire (expr,type)*)
  in
  str_list_vars vl ""
;;

(* affichage des fonctions *)
let str_functions f = 
  (*affichage vars locales, /!\ c une liste dinc on utilise la fonction d avant*)
  Printf.sprintf "locals = (%s)\n%s %s (%s){\n%s\n}"  (str_list_vars f.locals)
  (str_Typ f.return) (f.name) (str_list_vars f.params) (str_Seq f.code)  (*faire gaffe à l'ordre*)
;;
(*affichage d'une liste de fonctions*)
  let str_list_functions f l =
      Printf.sprintf "%s\n\n%s\n" (str_functions f) l
;;
(* affichage d'un programme tout entier *)
let str_prog prog = 
     let gl = prog.globals in
     let fs = prog.functions in
  (*affichage des vars globales et fonctionS*)
  Printf.sprintf "globals:\n%s\nfunctions:\n%s\n"
  (str_list_vars gl) 
  (*(List.fold_left str_list_functions "" fs)*)
;;
