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
type t =  | URzQ_H_temp | URzQ_X_temp | URzQ_Rz_temp | URzQ_CNOT_temp [@@deriving enum]
let of_int64 i = let Some d = of_enum (Int64.to_int i) in d
let to_int64 d = Int64.of_int (to_enum d)
let coq_RzQ_Unitary = Ctypes.(typedef (view int64_t ~read:of_int64 ~write:to_int64) "enum coq_RzQ_Unitary")



(**RzQGateSet Final Structure**)
let final_gates : [`final_gates] structure typ = structure "final_gates"
let gates = field final_gates "gates" (coq_RzQ_Unitary)
let type1 = field final_gates "type1" (MPQ.zarith)
let () = seal final_gates

let get_gates d = 
let w =getf d type1 in
URzQ_Rz w
let set_gates (URzQ_Rz w) =
let d = make final_gates in (setf d gates URzQ_Rz_temp;setf d type1 w;d)
let final_URzQ_Rz = view ~read:get_gates~write:set_gates final_gates

let get_gates1 d = 
let w =getf d gates in
URzQ_H
let set_gates1 (URzQ_H) =
let d = make final_gates in (setf d gates URzQ_H_temp;d)
let final_URzQ_H = view ~read:get_gates1~write:set_gates1 final_gates


let get_gates2 d = 
let w =getf d gates in
URzQ_X
let set_gates2 (URzQ_H) =
let d = make final_gates in (setf d gates URzQ_X_temp;d)
let final_URzQ_X = view ~read:get_gates2~write:set_gates2 final_gates

let get_gates3 d = 
let w =getf d gates in
URzQ_CNOT
let set_gates3 (URzQ_CNOT) =
let d = make final_gates in (setf d gates URzQ_CNOT_temp;d)
let final_URzQ_CNOT = view ~read:get_gates3~write:set_gates3 final_gates





let fin_gates : [`fin_gates] structure typ = structure "fin_gates"
let xg = field fin_gates "xg" (final_URzQ_X)
let hg = field fin_gates "hg" (final_URzQ_H)
let rz = field fin_gates "rzgate" (final_URzQ_Rz)
let cnot = field fin_gates "cnot" (final_URzQ_CNOT)
let () = seal fin_gates

(**Connect the App1 Tuple to the App1 Union **)
let get_tuples2 d = 
let x = getf d xg in 
let y = getf d hg in
let z = getf d rz in
let w = getf d cnot in
if x = URzQ_X then x else if y = URzQ_H then y else if w = URzQ_CNOT then w else z

let set_tuples2 x =
let d = make fin_gates in 
if x = URzQ_X then 
    (setf d xg x;d)
else if x = URzQ_H then 
    (setf d hg x;d)
else if x = URzQ_CNOT then 
    (setf d cnot x;d) 
else (setf d rz x;d)

let final_gates12= view ~read:get_tuples2~write:set_tuples2 fin_gates



(**App1 Tuple**)
let tuples : [`tuples] structure typ = structure "tuples"
let gate = field tuples "gate" (final_gates12)
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
let gate1 = field triples "gate1" (final_gates12)
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
let gate2 = field quad "gate2" (final_gates12)
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
let gate_app : [`gate_app] structure typ = structure "gate_app"
let app1 = field gate_app "App1" (final_App1)
let app2= field gate_app "App2" (final_App2)
let app3= field gate_app "App3" (final_App3)
let () = seal gate_app

let get1_app d = 
let p = make tuples in 
let r = make triples in 
let y = getf d app1 in
let z = getf d app2 in
let w = getf d app3 in
if y = App1(getf p gate, getf p x) then y else if z = App2(getf r gate1, getf r a, getf r b) then z else y

let set1_app xy =
let d = make gate_app in 
if xy = (getf d app1) then 
    (setf d app1 xy;d)
else if xy = getf d app2 then 
    (setf d app2 xy;d)
else (setf d app3 xy;d)


let final_help = view ~read:get1_app~write:set1_app gate_app


(** Tuple of Gate Application list and integer**)
let with_qubits : [`with_qubits] structure typ = structure "with_qubits"
let app_list = field with_qubits "app_list" (ptr gate_app)
let quibits= field with_qubits "qubits" (int)
let () = seal with_qubits



let add a = 
a+3
module Stubs(I: Cstubs_inverted.INTERNAL) = struct
 I.enum ["URzQ_H", 1L; "URzQ_X", 2L; "URzQ_Rz", 3L; "URzQ_CNOT", 4L] coq_RzQ_Unitary
 let () = I.structure final_gates
 let () = I.structure tuples
 let () = I.structure triples
 let () = I.structure quad
 let () = I.structure gate_app
 let () = I.structure with_qubits
 let () = I.internal "add"(int@-> returning int) add
 let () = I.internal "optimize"(final_help @-> returning final_help) optimize


end