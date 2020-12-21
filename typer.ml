open Ast

module Env = Map.Make(String)
  

(*typage des expressions*)

let rec type_expr (e: expr) (env: typ Env.t): typ = match e with

  | Cst _ -> Int

  | Add(e1, e2)
    let t1 = type_expr e1 env in
    let t2 = type_expr e2 env in
    if t1 = Int && t2 = Int
    then Int
    else failwith "type error"

  | Mul(e1, e2)
    let t1 = type_expr e1 env in
    let t2 = type_expr e2 env in
    if t1 = Int && t2 = Int
    then Int
    else failwith "type error"

 | Lt(e1, e2)
    let t1 = type_expr e1 env in
    let t2 = type_expr e2 env in
    if t1 = Int && t2 = Int
    then Int
    else failwith "type error"

  | Get(x) -> Env.find x env

(*d'ici je ne suis pas sûre*)
  | Call(f, args) ->
    let paramsf = f.params in
    let rec f l1 l2 = 
        match l1 l2 with 
          |[],[] -> failwith "No params"
          |_,[] ->failwith "type error"
          |[],_ ->failwith "type error"
          |p1::pn, a1::an ->
                  let t1= type_expr p1 in
                  let t2= type_expr a1 in 
                  if t1 = t2 then t1
                                  f pn an
                  else failwith "type error"
    in f params args 
    end


let rec type_instr(i: instr) (env: typ Env.t): typ = match i with
    | If(e,s1,s2) ->
        let t1 = type_expr e in 
        if t1 = bool then 
            match s1, s2 with 
              |[],[] -> failwith("not a branch")
              |_,[] -> List.map type_instr s1 env
              |[],[] -> List.map type_instr s2 env
              |_,_ -> List.map type_instr s1 env
                      List.map type_instr s2 env
        else 
          failwith("the if condition is not a boolean!")
