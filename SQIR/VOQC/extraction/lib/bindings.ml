open Ctypes
open Ctypes_zarith
open UnitaryListRepresentation
open RzQGateSet.RzQGateSet
open Datatypes
open FMapAVL
open FSetAVL
open OrderedTypeEx
open GateCancellation
open HadamardReduction
open NotPropagation
open RotationMerging
open Optimize
open Qasm2sqir
(**Enums for RzQGateSet for Gates**)
type t =  | URzQ_H_temp | URzQ_X_temp| URzQ_Rz_temp| URzQ_CNOT_temp [@@deriving enum]
let of_int64 i = let Some d = of_enum (Int64.to_int i) in d
let to_int64 d = Int64.of_int (to_enum d)
let coq_RzQ_Unitary1 = Ctypes.(typedef (view int64_t ~read:of_int64 ~write:to_int64) "enum coq_RzQ_Unitary1")


(**RzQGateSet Final Structure**)
let final_gates : [`final_gates] structure typ = structure "final_gates"
let gates = field final_gates "gates" (coq_RzQ_Unitary1)
let type1 = field final_gates "type1" (MPQ.zarith)
let () = seal final_gates

let get_gates d : coq_RzQ_Unitary = 
let w =getf d gates in
match w with 
URzQ_X_temp -> URzQ_X
|URzQ_H_temp -> URzQ_H
|URzQ_CNOT_temp -> URzQ_CNOT
|URzQ_Rz_temp -> (URzQ_Rz (getf d type1))
let set_gates (x:coq_RzQ_Unitary) =
let d = make final_gates in
if x = URzQ_X then 
(setf d gates URzQ_X_temp;d)
else if x = URzQ_H then 
(setf d gates URzQ_H_temp;d)
else if x = URzQ_CNOT then
(setf d gates URzQ_CNOT_temp;d)
else 
(setf d gates URzQ_Rz_temp;setf d type1 (getf d type1);d)
let coq_RzQ_Unitary = view ~read:get_gates~write:set_gates final_gates


let back_orig : [`back_orig] structure typ = structure "back_orig"
let gates1 = field back_orig "gates1" (coq_RzQ_Unitary)
let () = seal back_orig
let get_back d u= 
let w =getf d gates in

match w with 
URzQ_X_temp -> (setf u gates1 URzQ_X)
|URzQ_H_temp -> (setf u gates1 URzQ_H)
|URzQ_CNOT_temp -> (setf u gates1 URzQ_CNOT)
|URzQ_Rz_temp -> (setf u gates1 (URzQ_Rz(getf d type1)))
let set_back x =
let d = make final_gates in 
let u = make back_orig in 
let v =getf u gates1 in
match v with 
 URzQ_X->(setf d gates URzQ_X_temp;d) 
|URzQ_H->(setf d gates URzQ_H_temp;d)
|URzQ_CNOT->(setf d gates URzQ_CNOT_temp;d)
|URzQ_Rz _ -> (setf d gates URzQ_Rz_temp;d)

let get_orig d = 
let z =getf d gates1 in
z
let set_orig z =
let d = make back_orig in (setf d gates1 z;d)
let final_Unitary = view ~read:get_orig~write:set_orig back_orig

(**App1 Tuple**)
let tuples : [`tuples] structure typ = structure "tuples"
let gate = field tuples "gate" (final_Unitary)
let x = field tuples "x" (int)
let () = seal tuples

(**Connect the App1 Tuple to the App1 Union **)
let get_tuples d = let z =getf d gate in
let y = getf d x in
App1 (z,y)
let set_tuples (App1(z,y)) =
let d = make tuples in (setf d gate z; setf d x y;d)
let final_App1 = view ~read:get_tuples~write:set_tuples tuples


(**App2 Tuple**)
let triples : [`triples] structure typ = structure "triples"
let gate1 = field triples "gate1" (final_Unitary)
let a= field triples "a" (int)
let b= field triples "b" (int)
let () = seal triples

(**Connect the App1 Tuple to the App1 Union **)
let get_triples d = 
let first =getf d gate1 in
let second = getf d a in
let third = getf d b in
App2 (first,second,third)
let set_triples (App2(first,second,third)) =
let d = make triples in (setf d gate1 first; setf d a second;setf d b third;d)
let final_App2 = view ~read:get_triples~write:set_triples triples

(**App3 Tuple**)
let quad : [`quad] structure typ = structure "quad"
let gate2 = field quad "gate2" (final_Unitary)
let c= field quad "c" (int)
let f= field quad "f" (int)
let e= field quad "e" (int)
let () = seal quad

let get_quad d = 
let first_quad =getf d gate2 in
let second_quad = getf d c in
let third_quad = getf d f in
let fourth_quad = getf d e in

App3 (first_quad,second_quad,third_quad,fourth_quad)
let set_quad (App3(first_quad,second_quad,third_quad,fourth_quad)) =
let d = make quad in (setf d gate2 first_quad; setf d c second_quad;setf d f third_quad;setf d e fourth_quad;d)
let final_App3 = view ~read:get_quad~write:set_quad quad

(**Gate Applications**)
let gate_app1 : [`gate_app1] union typ = union "gate_app1"
let app1 = field gate_app1 "App1" (final_App1)
let app2= field gate_app1 "App2" (final_App2)
let app3= field gate_app1 "App3" (final_App3)
let () = seal gate_app1

let get1_app d = 
let p = make tuples in 
let r = make triples in 
let y = getf d app1 in
let z = getf d app2 in
let w = getf d app3 in
if y = App1(getf p gate, getf p x) then y else if z = App2(getf r gate1, getf r a, getf r b) then z else w

let set1_app xy =
let d = make gate_app1 in 
if xy = (getf d app1) then 
    (setf d app1 xy;d)
else if xy = getf d app2 then 
    (setf d app2 xy;d)
else (setf d app3 xy;d)


let gate_app = view ~read:get1_app~write:set1_app gate_app1


(** Tuple of Gate Application list and integer**)
let with_qubits : [`with_qubits] structure typ = structure "with_qubits"
let app_list = field with_qubits "app_list" (ptr gate_app)
let quibits= field with_qubits "qubits" (int)
let () = seal with_qubits


let optimize1 a = 
Root.create (optimize((Ctypes.Root.get a: RzQGateSet.RzQGateSet.coq_RzQ_Unitary UnitaryListRepresentation.gate_app
  list))) |> from_voidp gate_app1



let add a = 
a+3
module Stubs(I: Cstubs_inverted.INTERNAL) = struct
 I.enum ["URzQ_H", 0L; "URzQ_X", 1L; "URzQ_Rz", 2L; "URzQ_CNOT", 3L] coq_RzQ_Unitary1
 let () = I.structure final_gates
 let () = I.structure back_orig
 let () = I.structure tuples
 let () = I.structure triples
 let () = I.structure quad
 let () = I.union gate_app1
 let () = I.structure with_qubits
 let () = I.internal "add"(int@-> returning int) add
 let () = I.internal "optimize"(ptr void @-> returning (ptr gate_app1)) optimize1
 
 

end