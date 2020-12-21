%{


	open Ast

	(*Fonctions qui servira à afficher le nom des types en cas d'incohérence de type*)
	let afficher_type = function
	  | Int -> "int"
	  | Bool -> "bool"
	  | Void -> "void"

	let var_glob = Hashtbl.create 1 (*c'est là que je met les variables globales*)
	let functionsNameType = Hashtbl.create 1 (*ici, il y a le nom des fonctions et leurs types de retour*)
	let functionsParam = Hashtbl.create 1 (*ici il y a un tableau de hashage qui, à chaque (nom de fonction),
	 																				associe une liste des typ_des_param (dans l'ordre)*)
	let currentFunctionVarParam = Hashtbl.create 1 (*les paramètres (nom, type) de la fonction en cours ainsi que les variables locales*)


	(*Fonction qui prend une liste de couple ('a, 'b) et qui la transforme en une table de hashage
	  dont les clés seront de type 'a et les valeurs de type 'b *)
	let lis_to_Hshtbl hash lis =
		List.fold_right (fun x hash -> (let (a,b) = x in Hashtbl.add hash a b; hash)) lis hash

	(*Fonction qui prend la liste des variables locales et qui rend la liste des types par ordre*)
	let get_params_typ_only lis =
		List.fold_right (fun x y -> y@[snd x]) lis []

	let rec typeExpr e =
		match e with
		| Cst _ -> Int

		| Not(e) -> if typeExpr e != Bool
					then failwith "Type Error Unary Operation's Argument\n"
					else Bool
		| Neg(e) -> if typeExpr e != Int
					then failwith "Type Error Unary Operation's Argument\n"
					else Int


		| Add(e1, e2) | Mul(e1, e2) | Mod(e1,e2) | Div(e1,e2) | ShiftR(e1, e2) | ShiftL(e1,e2)->
			begin
				if typeExpr e1 != Int
				then failwith "Type Error Binary Operation's First Argument\n"
				else begin
							if typeExpr e2 != Int
						 	then failwith "Type Error Binary Operation's Second Argument\n"
						 	else Int
						 end
			end
		| Lt(e1, e2) | Le(e1, e2) | Ge(e1, e2) | Gt(e1, e2) | Eqq(e1,e2) | Eq(e1, e2) | NEq(e1,e2)->
			begin
				if typeExpr e1 != Int
				then failwith "Type Error Binary Operation's First Argument\n"
				else begin
							if typeExpr e2 != Int
						 	then failwith "Type Error Binary Operation's Second Argument\n"
						 	else Bool
						 end
			end
		| And(e1, e2) | Or(e1, e2) | BitAnd(e1, e2) | BitOr(e1, e2)	-> 
			begin
				if typeExpr e1 != Bool
				then failwith "Type Error Binary Operation's First Argument\n"
				else begin
							if typeExpr e2 != Bool
						 	then failwith "Type Error Binary Operation's Second Argument\n"
						 	else Bool
						 end
			end
		| Get(x) | Ident(x) ->
			begin
				try
					let t = Hashtbl.find currentFunctionVarParam x in
					afficher_type t;
					t
				with Not_found ->
						try
							let t = (Hashtbl.find currentFunctionVarParam x) in t
						with Not_found ->
							let message = "You may forgot to declare" ^ x ^"\n" in failwith message
			end
		| Call(f,x) ->
			try
				let t = Hashtbl.find functionsNameType f in
				t
			with Not_found ->
				let message = "The function '" ^ f ^"' has not been declared\n" in failwith message ;
			
			let t = Hashtbl.find functionsNameType f in
			let f_type = Hashtbl.find functionsParam f in
			let x_type = List.fold_right (fun h y -> (typeExpr h)::y) x [] in
			if (x_type=f_type)
			then t
			else let message = "Type error when calling the function" ^ f ^ "\n" in failwith message


		| _ -> failwith "What is this expression ?\n"


	(*Fonction qui interdit de déclarer une variable locale portant le même nom qu'un paramètre*)
	let rec check_ident lis nom_fonction =
		match lis with
		| [] -> ()
		| elt::suite ->
			begin
				let (nom,ty) = elt in
				if (Hashtbl.mem currentFunctionVarParam nom)
				then (let message = "Function : "^ nom_fonction ^"\nThe identifier "^ nom ^" is already taken by one of the parameters.\n" in failwith message)
				else check_ident suite nom_fonction
			end

	(* Cette fonction *)
	let rec check_returns lis nom_fonction type_fonction =
		match lis with
		| [] -> ()
		| While(_,s)::suite -> begin
											(check_returns s nom_fonction type_fonction);
											(check_returns suite nom_fonction type_fonction)
										end
		| If(_,i1,i2)::suite -> begin
															(check_returns i1 nom_fonction type_fonction);
															(check_returns i2 nom_fonction type_fonction);
															(check_returns suite nom_fonction type_fonction)
														end
		| Return(e)::suite -> begin
		 												let t = typeExpr e in
														if (t = type_fonction)
														then (check_returns suite nom_fonction type_fonction)
														else (let message = "Function : "^ nom_fonction^ " has not a right return type\nThe return type excpected is : " ^ (afficher_type type_fonction) ^ " but this expression has type " ^ (afficher_type t) in
																	failwith message)
													end
		| _::suite -> (check_returns suite nom_fonction type_fonction)

	let rec check_instr = function
		| [] -> ()
		| Set(e,i)::suite -> begin
														let g = Get(e) in
														let t1 = typeExpr g in
														let t2 = typeExpr i in
														if t1=t2
														then check_instr suite
														else failwith "This instruction is not typable"
													end

		| While(e,_)::suite -> begin
														let t = typeExpr e in
														if t=Bool
														then check_instr suite
														else failwith "The while loop has not a valid condition."
													end
		| Putchar(e)::suite -> let t = typeExpr e in check_instr suite
		| _ -> ()


%}


%token <int> CST
%token <string> IDENT
%token PLUS MUL FIN MINUS
%token COMMA SCOLON IF ELSE INT FOR
%token EQUAL LT AND PUTCHAR WHILE LE GE
%token LPAREN RPAREN LBRACE RBRACE
%token MOD DIV GT DOUBLE_EQ BIT_AND BIT_OR NEQ OR
%token VOID BOOL RETURN SEP NOT
%token SHIFT_LEFT SHIFT_RIGHT
%left OR
%left AND
%left BIT_OR
%left BIT_AND
%left LT GT GE LE
%left SHIFT_LEFT SHIFT_RIGHT
%left PLUS 
%left MUL DIV MOD
%nonassoc NEG_MINUS


%start prog
%type <Ast.prog> prog

%%
prog :
 | gl=list(decl_var_glo) SEP fn=list(decl_functions) FIN
  { {globals=gl; functions=fn}}

 | error
    { let pos = $startpos in
      let message = Printf.sprintf "échec à la position %d, %d" pos.pos_lnum (pos.pos_cnum - pos.pos_bol) in
      failwith message }

decl_var_glo:
 | decl SCOLON { Hashtbl.add var_glob (fst $1) (snd $1); ((fst $1),(snd $1)) }
 | decl EQUAL e=expr SCOLON {Hashtbl.add var_glob (fst $1) (snd $1)	; ((fst $1),(snd $1)) }

decl_var:
 | decl SCOLON { ((fst $1),(snd $1))  }
 | decl EQUAL e=expr SCOLON {((fst $1),(snd $1))  }

decl_functions:
 | decl_fun LPAREN  fparams=parameters RPAREN LBRACE fvar=list(decl_var) fcode=seq RBRACE
	{
		Hashtbl.add functionsParam (fst $1) (get_params_typ_only fparams);
		lis_to_Hshtbl currentFunctionVarParam fparams;
		check_ident fvar (fst $1); (*On regarde bien qu'il n y a pas de variables locales qui portent le même nom que l'un des params*)
		lis_to_Hshtbl currentFunctionVarParam fvar;
		check_returns fcode (fst $1) (snd $1); (*On regarde qu'on renvoit bien le type demandé*)
		check_instr fcode; (*On verifie le typage des instructions de cette fonction*)
		{
			name=(fst $1);
			params = fparams;
			return=(snd $1);
			locals= fvar;
		  	code=fcode;
		}
	}
parameters:
 | p=separated_list(COMMA, decl)
 		{ p }

decl:
 | t=typ id=IDENT
   { (id, t) }
decl_v:
 | t=typ i=IDENT  { (i,t) }
 | t=typ i=IDENT EQUAL e=expr  { (i,t) }

decl_fun:
 | t=typ id=IDENT
	{Hashtbl.reset currentFunctionVarParam;
	 Hashtbl.add functionsNameType id t;
	 (id, t) }

seq:
 | e=list(instr)
   { e }

instr:
 | IF LPAREN c=expr RPAREN LBRACE e1=nonempty_list(instr) RBRACE
	{ If(c, e1, []) }

 | IF LPAREN c=expr RPAREN LBRACE e1=nonempty_list(instr) RBRACE ELSE LBRACE e2=separated_nonempty_list(SCOLON, instr) RBRACE
	{ If(c, e1, e2) }

 | i=IDENT EQUAL e=expr SCOLON
  {
		Set(i,e) }
 | WHILE LPAREN e=expr RPAREN LBRACE s=seq RBRACE
  	{ While(e, s) }

 | PUTCHAR LPAREN e=expr RPAREN SCOLON { Putchar(e) }

 | e=expr { Expr e 	}

 | FOR LPAREN init = decl_v SCOLON cond = for_cond SCOLON last = expr RPAREN LBRACE code = seq RBRACE
    { For(init, cond, last, code ) }

 | RETURN e=expr SCOLON { Return(e) }

for_cond :
 |expr LT expr {Lt($1,$3)} 
 |expr GT expr {Gt($1,$3)} 
 |expr LE expr {Le($1,$3)}
 |expr GE expr {Ge($1,$3)}

expr :
 | i = CST
    { Cst i }
 | i = IDENT
	 	{ Ident i}
 | e1=expr PLUS e2=expr
    { Add(e1, e2) }
 | e1=expr MUL e2=expr
    { Mul(e1, e2) }
 | fn=IDENT LPAREN lis_param=separated_list(COMMA, expr) RPAREN
 	{ Call(fn, lis_param) }
 | e1=expr LT e2=expr
 		{ Lt(e1, e2) }
 | LPAREN e=expr RPAREN
 		{ e }
 | MINUS e = expr %prec NEG_MINUS
    { Neg(e) }
 | NOT e = expr
    { Not(e) }
 | e1 = expr DIV e2 = expr
    { Div(e1, e2) }
 | e1 = expr MOD e2 = expr
    { Mod(e1, e2) } 
 | e1 = expr DOUBLE_EQ e2 = expr
    { Eqq(e1, e2) } 
 | e1 = expr GT e2 = expr
    { Gt(e1, e2) } 
 | e1 = expr NEQ e2 = expr
    { NEq(e1, e2) } 
 | e1 = expr AND e2 = expr
    { And(e1, e2) }
 | e1 = expr OR e2 = expr
    { Or(e1, e2) } 
 | e1 = expr BIT_AND e2 = expr
    { BitAnd(e1, e2) } 
 | e1 = expr BIT_OR e2 = expr
    { BitOr(e1, e2) }
 | e1 = expr GE e2 = expr
    { Ge(e1, e2) } 
 | e1 = expr LE e2 = expr
    { Le(e1, e2) }
 | e1 = expr SHIFT_LEFT e2 = expr
    { ShiftL(e1, e2) }
 | e1 = expr SHIFT_RIGHT e2 = expr
    { ShiftR(e1, e2) }
 | e1 = expr EQUAL e2 = expr
    { Eq(e1, e2) }

typ :
 | INT  {Int}
 | BOOL {Bool}
 | VOID {Void}
