open Ast

let afficher_type = function
  | Int -> "int"
  | Bool -> "bool"
  | Void -> "void"
;;

let rec expr_to_string = function
  | Cst a -> string_of_int a
  | Ident s -> s
  | Add(e1, e2) -> "Add(" ^ (expr_to_string e1) ^ "," ^ (expr_to_string e2) ^ ")"
  | Mul(e1, e2) -> "Mul("^(expr_to_string e1) ^ "," ^ (expr_to_string e2)^")"
  | Lt(e1, e2) -> "Lt("^(expr_to_string e1) ^ "," ^ (expr_to_string e2)^")"
  | Get(e1) -> "Get("^e1^")"
  | Call(a,lis) -> "Call ("^a^","^ (List.fold_left ( afficher_args)"" lis )
  | Not(e) -> "Not("^(expr_to_string e)^")"
  | Neg(e) -> "Neg("^(expr_to_string e)^")"
  | Div(e1,e2) -> "Div("^(expr_to_string e1)^","^(expr_to_string e2)^")"
  | Mod(e1,e2) -> "Mod("^(expr_to_string e1)^","^(expr_to_string e2)^")"
  | Eq(e1,e2) -> " Equal("^(expr_to_string e1)^","^(expr_to_string e2)^")"
  | Eqq(e1,e2) -> " Equalll("^(expr_to_string e1)^","^(expr_to_string e2)^")"
  | Gt(e1,e2) -> " Gt("^(expr_to_string e1)^","^(expr_to_string e2)^")"
  | NEq(e1,e2) -> " NEq("^(expr_to_string e1)^","^(expr_to_string e2)^")"
  | And(e1,e2) -> " And("^(expr_to_string e1)^","^(expr_to_string e2)^")"
  | Or(e1,e2) -> " Or("^(expr_to_string e1)^","^(expr_to_string e2)^")"
  | BitAnd(e1,e2) -> "BitAnd("^(expr_to_string e1)^","^(expr_to_string e2)^")"
  | BitOr(e1,e2) -> "BitOr("^(expr_to_string e1)^","^(expr_to_string e2)^")"
  | Ge(e1,e2) -> " GE("^(expr_to_string e1)^","^(expr_to_string e2)^")"
  | Le(e1,e2) -> " LE("^(expr_to_string e1)^","^(expr_to_string e2)^")"
  | ShiftL(e1,e2) -> " SHIFTLEFT("^(expr_to_string e1)^","^(expr_to_string e2)^")"
  | ShiftR(e1,e2) -> " SHIFTRIGHT("^(expr_to_string e1)^","^(expr_to_string e2)^")"

 and afficher_args (str:string) (arg : expr) : string  = 
   str^(expr_to_string arg)
;;


let rec afficher_instr seq =
  match seq with
  | [] -> ()
  | i1::i2 ->
    Printf.printf "\t\t\t%s\n" (instr_to_string i1);
    afficher_instr i2;
  and instr_to_string i = 
        match i with 
          | Set(a,b) ->
                        "Set("^a ^ " , " ^ (expr_to_string b)^");"
          | If(c,i1,i2) -> 
                          Printf.printf "\t\tif(";
                          Printf.printf "%s"(expr_to_string c);
                          Printf.printf "%s"") {\n ";
                          (afficher_instr i1);
                          Printf.printf "\t\t} else {\n";
                          (afficher_instr i2);
                          Printf.printf "\t\t}";
                          "";
          | Return(e) -> 
                         ("return " ^ expr_to_string e)
          | While(c,i) -> 
                          Printf.printf "\t\twhile(";
                          Printf.printf "%s"(expr_to_string c);
                          Printf.printf"){\n";
                          (afficher_instr i);
                          Printf.printf "\t\t}";
                          "";
          | Putchar(v)  ->  
                           "Putchar(" ^(expr_to_string v)^");"
          | Expr(v) -> 
                       "Execute"^(expr_to_string v)
          | For(i,c,l,s) -> 
              let (nom, t) = i in
              Printf.printf "\t\tfor((";
              Printf.printf " %s : "nom;
              Printf.printf " %s  );"(afficher_type t);
              Printf.printf " %s ;" (expr_to_string c);
              Printf.printf " %s  ){\n"(expr_to_string l);
              (afficher_instr s);
              Printf.printf "\t\t}";
              " "
    ;;


let rec afficher_gl var =
  match var with
  | [] -> ()
  | x::suite -> begin
                  let (nom, t) = x in
                  Printf.printf " (%s : %s) " nom (afficher_type t);
                  afficher_gl suite
                end

let rec afficher_fn fn  =
  match fn with
  | [] -> ()
  | x::suite ->
      Printf.printf "\tNom : %s\n" x.name;
      Printf.printf "\tType de retour : %s\n" (afficher_type x.return);
      Printf.printf "\tLes params : ["; afficher_gl x.params ; Printf.printf "]\n";
      Printf.printf "\tLes variables locales: ["; afficher_gl x.locals ; Printf.printf "]\n";
      Printf.printf "\tLes instructions : [\n"; afficher_instr x.code ; Printf.printf "\n\t]\n";
      Printf.printf "\n";

      afficher_fn suite;;

let afficher prog =
  let gl = prog.globals in
  let fn = prog.functions in
  Printf.printf "Le programme : \n";
  Printf.printf "   Les variables globales reconnues : [" ; afficher_gl gl ; Printf.printf "]\n";
  Printf.printf "   Les fonctions reconnues : [\n" ;
  afficher_fn fn;
  Printf.printf "\t]\n"
