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

module Coq_U :
sig
  type t
  val t : t typ  (* Used to describe interfaces to C *) 

  val alloc : RzQGateSet.RzQGateSet.coq_RzQ_Unitary UnitaryListRepresentation.gate_app
  list -> t
  val free : t -> unit

  val get : t -> RzQGateSet.RzQGateSet.coq_RzQ_Unitary UnitaryListRepresentation.gate_app
  list
  val set : t -> RzQGateSet.RzQGateSet.coq_RzQ_Unitary UnitaryListRepresentation.gate_app
  list -> unit
end =
struct
  type t = unit ptr
  let t = ptr void

  let alloc = Root.create
  let free = Root.release

  let get = Root.get
  let set = Root.set
end
(**Enums for RzQGateSet for Gates**)
type t =  | X | H| CNOT| Rz [@@deriving enum]
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
X -> URzQ_X
|H -> URzQ_H
|CNOT -> URzQ_CNOT
|Rz -> (URzQ_Rz (getf d type1))
let set_gates x =
let d = make final_gates in
match x with 
URzQ_X ->(setf d gates X;d)
|URzQ_H ->(setf d gates H;d)
|URzQ_CNOT -> (setf d gates CNOT;d)
|URzQ_Rz y -> (setf d gates Rz;setf d type1 y;d)
let coq_RzQ_Unitary2 = view ~read:get_gates~write:set_gates final_gates



(**App1 Tuple**)
let tuples : [`tuples] structure typ = structure "tuples"
let gate = field tuples "gate" (coq_RzQ_Unitary2)
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
let gate1 = field triples "gate1" (coq_RzQ_Unitary2)
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
let gate2 = field quad "gate2" (coq_RzQ_Unitary2)
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
let gate_app3 = view ~read:get1_app~write:set1_app gate_app1


let with_qubits : [`with_qubits] structure typ = structure "with_qubits"
let sqir = field with_qubits "SQIR" (Coq_U.t)
let qubits= field with_qubits "qubits" (int)
let () = seal with_qubits
(*type with_q = 
|L of RzQGateSet.RzQGateSet.coq_RzQ_Unitary UnitaryListRepresentation.gate_app
  list * int
let get_qubits d  = 
let w =getf d sqir in
let u = getf d qubits in
((L (w,u)))
let set_q ((L (w,u))) =
let d = make with_qubits in
(setf d sqir w;setf d qubits u;d)
let with_qubits1 = view ~read:get_q~write:set_q with_qubits*)

 
let optimizer a = 
let config = to_voidp a |> Root.get in
let y = CArray.to_list config in
let t = (optimize y) in
Root.create t |> from_voidp gate_app1

let gate_list fname =
let y = get_gate_list fname in 
Root.create y |> from_voidp with_qubits


let write_qasm x y z = 
let u = Coq_U.get y in
write_qasm_file x u z

let merge x = 
let t = to_voidp x in 
let u = Root.get t in 
let m_rot = merge_rotations u in
Coq_U.alloc m_rot

let single x =
let test= to_voidp x in
let pass = Root.get test in 
let get  = cancel_single_qubit_gates pass in 
Root.create get |> from_voidp gate_app1

let two x =
let test= to_voidp x in
let pass = Root.get test in 
let get  = cancel_two_qubit_gates pass in 
Root.create get |> from_voidp gate_app1

let hadamard x =
let test= to_voidp x in
let pass = Root.get test in 
let get  = hadamard_reduction pass in 
Root.create get |> from_voidp gate_app1


module Stubs(I: Cstubs_inverted.INTERNAL) = struct
 I.enum ["X", 0L; "H", 1L; "CNOT", 2L; "Rz", 3L] coq_RzQ_Unitary1
 let () = I.structure final_gates
 let () = I.structure tuples
 let () = I.structure triples
 let () = I.structure quad
 let () = I.union gate_app1
 let () = I.structure with_qubits
 let () = I.internal "optimizer"(ptr (gate_app1) @-> returning (ptr gate_app1)) optimizer
 let () = I.internal "write_qasm_file"(string @-> Coq_U.t @->int @-> returning void) write_qasm
 let () = I.internal "merge_rotations"((ptr gate_app1) @-> returning Coq_U.t) merge
 let () = I.internal "cancel_single_qubit_gates"(ptr (gate_app1) @-> returning (ptr gate_app1))single
 let () = I.internal "cancel_two_qubit_gates"(ptr (gate_app1) @-> returning (ptr gate_app1)) two
 let () = I.internal "hadamard"(ptr (gate_app1) @-> returning (ptr gate_app1)) hadamard
 
end