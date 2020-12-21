type typ =
  | Int
  | Bool
  | Void


type expr =
  | Cst  of int
  | Ident  of string
  | Add  of expr * expr
  | Mul  of expr * expr
  | Lt   of expr * expr
  | Get  of string 
  | Call of string * expr list
  | Div of expr* expr
  | Mod of expr* expr
  | Eqq of expr* expr
  | Gt of expr* expr 
  | NEq of expr* expr
  | And of expr* expr
  | Or of expr* expr
  | BitAnd of expr* expr
  | BitOr of expr* expr
  | Not of expr
  | Neg of expr 
  | Le of expr* expr
  | Ge of expr* expr
  | ShiftL of expr* expr
  | ShiftR of expr* expr
  | Eq of expr* expr
 


type instr =
  | Putchar of expr 
  | Set     of string * expr
  | If      of expr * seq * seq
  | While   of expr* seq 
  | Return  of expr
  | Expr    of expr
  | For of (string * typ)* expr* expr* seq 
        
and seq = instr list

type fun_def = {
  name:   string;
  params: (string * typ) list;
  return: typ;
  locals: (string * typ) list;
  code:   seq;
}

type prog = {
  globals:   (string * typ) list;
  functions: fun_def list;
}

