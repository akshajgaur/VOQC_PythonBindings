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

let get1_gates = function 
|0 -> final_URzQ_X
|1 -> final_URzQ_H
|2 -> final_URzQ_Rz 
|3 -> final_URzQ_CNOT
| _ -> assert false

let set1_gates = function 
|final_URzQ_X -> 0
|final_URzQ_H -> 1
|final_URzQ_Rz -> 2
|final_URzQ_CNOT -> 3

let final_gates12 = view ~read:get1_gates~write:set1_gates int




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
let app1 = field gate_app "App1" (tuples)
let app2= field gate_app "App2" (triples)
let app3= field gate_app "App3" (quad)
let () = seal gate_app

let get1_app = function 
|0 -> final_App1
|1 -> final_App2
|2 -> final_App3

let set1_app = function 
|final_App1 -> 0
|final_App2 -> 1
|final_App3 -> 2

let final_help = view ~read:get1_app~write:set1_app int


(** Tuple of Gate Application list and integer**)
let with_qubits : [`with_qubits] structure typ = structure "with_qubits"
let app_list = field with_qubits "app_list" (ptr gate_app)
let quibits= field with_qubits "qubits" (int)
let () = seal with_qubits




let add a = 
a+3
module Stubs(I: Cstubs_inverted.INTERNAL) = struct
 I.enum ["URzQ_H", 0L; "URzQ_X", 1L; "URzQ_Rz", 2L; "URzQ_CNOT", 3L] coq_RzQ_Unitary
 let () = I.structure final_gates
 let () = I.structure tuples
 let () = I.structure triples
 let () = I.structure quad
 let () = I.structure gate_app
 let () = I.structure with_qubits
 let () = I.internal "add"(int@-> returning int) add
 let () = I.internal "optimize"(final_help @-> returning final_help) optimize

end
