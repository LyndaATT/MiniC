%{
	open Ast
%}

/* menhir --interpret --unused-token symbol --interpret-show-cst parser.mly */

%token <int> CST
%token <string> IDENT
%token PLUS MUL PRINT FIN
%token COMMA SCOLON IF ELSE INT
%token EQUAL LT AND PUTCHAR WHILE
%token LPAREN RPAREN LBRACE RBRACE
%token VOID BOOL RETURN SEP
%start prog
%type <Ast.prog> prog

%left LT
%left PLUS
%left MUL
%right COMMA
%right SCOLON

%%
prog :
 | gl=list(decl_var) SEP fn=list(decl_functions) FIN
  { {globals=gl; functions=fn}}

 | error
    { let pos = $startpos in
      let message = Printf.sprintf "échec à la position %d, %d" pos.pos_lnum (pos.pos_cnum - pos.pos_bol) in
      failwith message }

decl_var:
 | t=typ i=IDENT SCOLON { (i,t) }
 | t=typ i=IDENT EQUAL e=expr SCOLON { (i,t) }

decl_functions:
 | t=typ id=IDENT LPAREN  fparams=parameters RPAREN LBRACE fvar=list(decl_var) fcode=seq option(return) RBRACE SCOLON
	{
		{
			name=id;
			params = fparams;
			return=t;
			locals= fvar;
		  code=fcode;
		}
	}

parameters:
 | p=separated_list(COMMA, param) { p }

param:
 | t=typ id=IDENT
   { (id, t) }

seq:
 | e=list(instr)
   { e }

instr:
 | IF LPAREN c=expr RPAREN LBRACE e1=nonempty_list(instr) RBRACE
	{ If(c, e1, []) }

 | IF LPAREN c=expr RPAREN LBRACE e1=nonempty_list(instr) RBRACE ELSE LBRACE e2=separated_nonempty_list(SCOLON, instr) RBRACE
	{ If(c, e1, e2) }

 | i=IDENT EQUAL e=expr SCOLON
  { Set(i,e) }
 | WHILE LPAREN e=expr RPAREN LBRACE s=seq RBRACE
  	{ While(e, s) }
 | PUTCHAR LPAREN e=expr RPAREN SCOLON { Putchar(e) }

return:
 | RETURN e=expr SCOLON { Return(e) }


expr :
 | i = CST
    { Cst i }
 | i = IDENT
	 	{ Ident i}
 | e1=expr PLUS e2=expr
    { Add(e1, e2) }
 | e1=expr MUL e2=expr
    { Mul(e1, e2) }
 | fn=IDENT LPAREN lis_param=separated_list(COMMA, expr)
 	{ Call(fn, lis_param) }
 | e1=expr LT e2=expr
 		{ Lt(e1, e2) }

typ :
 | INT  {Int}
 | BOOL {Bool}
 | VOID {Void}
