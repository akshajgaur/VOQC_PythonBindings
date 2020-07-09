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
type t =  |X | H| CNOT| Rz [@@deriving enum]
let get w = 
match w with 
1 -> X
|2 -> H
|3 -> CNOT
|4 -> Rz
|_ -> X
let set w = 
match w with 
X -> 1
|H -> 2
|CNOT -> 3
|Rz -> 4
let to_int64 d = Int64.of_int (to_enum d)
let coq_RzQ_Unitary1 = view ~read: get~write:set int


(**RzQGateSet Final Structure**)
let final_gates : [`final_gates] structure typ = structure "final_gates"
let gates = field final_gates "gates" (int)
let type1 = field final_gates "type1" (MPQ.t_ptr)
let () = seal final_gates

let get_gates d : coq_RzQ_Unitary = 
let w =getf d gates in
match w with 
1 -> URzQ_X
|2 -> URzQ_H
|3 -> URzQ_CNOT
|4 -> (URzQ_Rz (getf d type1))
|_-> URzQ_X

let set_gates x =
let d = make final_gates in
match x with 
URzQ_X ->(setf d gates 1;d)
|URzQ_H ->(setf d gates 2;d)
|URzQ_CNOT -> (setf d gates 3;d)
|URzQ_Rz y -> (setf d gates 4;setf d type1 y;d)
let coq_RzQ_Unitary2 = view ~read:get_gates~write:set_gates final_gates



(**App1 Tuple**)
let tuples : [`tuples] structure typ = structure "tuples"
let gate = field tuples "gate" (coq_RzQ_Unitary2)
let x = field tuples "x" (int)
let () = seal tuples

(**Connect the App1 Tuple to the App1 Union **)
let get_tuples d = 
let z =getf d gate in
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


(**App3 Tuple**)
let quad : [`quad] structure typ = structure "quad"
let gate2 = field quad "gate2" (coq_RzQ_Unitary2)
let c= field quad "c" (int)
let f= field quad "f" (int)
let e= field quad "e" (int)
let () = seal quad

(**Connect the App1 Tuple to the App1 Union **)
let get_triples d = 
let first =getf d gate1 in
let second = getf d a in
let third = getf d b in
 App2(first,second,third)


let set_triples (App2(first,second,third)) =
let d = make triples in (setf d gate1 first; setf d a second;setf d b third;d)

let final_App2 = view ~read:get_triples~write:set_triples triples


let get_quad d = 
let first_quad =getf d gate2 in
let second_quad = getf d c in
let third_quad = getf d f in
let fourth_quad = getf d e in

App3(first_quad,second_quad,third_quad,fourth_quad)

let set_quad (App3(first_quad,second_quad,third_quad,fourth_quad)) =

let d = make quad in (setf d gate2 first_quad; setf d c second_quad;setf d f third_quad;setf d e fourth_quad;d)
let final_App3 = view ~read:get_quad~write:set_quad quad

(**Gate Applications**)
let gate_app1 : [`gate_app1] structure typ = structure "gate_app1"
let app1 = field gate_app1 "App1" (final_App1)
let app2 = field gate_app1 "App2" (final_App2)
let app3 = field gate_app1 "App3" (final_App3)
let ans = field gate_app1 "ans" (int)
let () = seal gate_app1



let get1_app d = 
let p = getf d ans in 
match p with 
|1 -> (getf d app1)
|2 -> (getf d app2)
|3 -> (getf d app3)
let set1_app xy =
let d  = make gate_app1 in
match xy with 
|App1(_,_) ->  (setf d app1 xy;d)
|App2(_,_,_) ->  (setf d app2 xy;d)
|App3(_,_,_,_) ->  (setf d app3 xy;d)
let gate_app3 = view ~read:get1_app~write:set1_app gate_app1






let with_qubits : [`with_qubits] structure typ = structure "with_qubits"
let sqir = field with_qubits "SQIR" (Coq_U.t)
let qubits= field with_qubits "qubits" (int)
let () = seal with_qubits


  type internal
  let internal : [`internal] structure typ = structure "internal"
  let length = field internal "length" int
  let contents = field internal "contents" (array 100 gate_app3)
  let () = seal internal
  
  type mem = {
    length   : int;
    contents1 : RzQGateSet.RzQGateSet.coq_RzQ_Unitary UnitaryListRepresentation.gate_app
  list; 
  }

  let of_internal_ptr p : mem =
   let y = !@p in
    let arr_len = getf y length in
    let contents_list =
      let arr_start = getf y contents |> CArray.start in
      CArray.from_ptr arr_start arr_len |> CArray.to_list in
    { length = arr_len; contents1 = contents_list; }
    
    let to_internal_ptr mem =
    let size = (sizeof internal + mem.length * sizeof gate_app1) in
    let internal =
      allocate_n (abstract ~name:"" ~size ~alignment:1) 1
      |> to_voidp |> from_voidp internal |> (!@) in
    setf internal length mem.length;
    List.iteri (CArray.unsafe_set (getf internal contents)) mem.contents1;
    addr internal
    let final9 = view ~read:of_internal_ptr ~write:to_internal_ptr (ptr internal)
let test1 () = 
let t = make gate_app1 in 
let y = getf t app1 in 
{length= 3;contents1 = [y;y;y]}

let optimizer mem = 
let get  = optimize mem.contents1 in 
{length= 2;contents1 = get}

let not_propagation1 a = 
let get1  = not_propagation a.contents1 in 
{length= List.length get1;contents1 = get1}



let write_qasm x mem z = 
let get  = write_qasm_file x mem.contents1 z in 
get

let merge mem = 
let get  = merge_rotations mem.contents1 in 
{length= List.length get;contents1 = get}

let single mem=
let get  = cancel_single_qubit_gates mem.contents1 in 
{length= List.length get;contents1 = get}
let two mem =
let get  = cancel_two_qubit_gates mem.contents1 in 
{length= List.length get;contents1 = get}

let hadamard mem =
let get  = hadamard_reduction mem.contents1 in 
{length= List.length get;contents1 = get}



let test a = 
let t = a.contents1 @ [App2(URzQ_X, 3, 3)] in 
{length = List.length t;contents1 = t}




module Stubs(I: Cstubs_inverted.INTERNAL) = struct
 
 let () = I.structure final_gates
 let () = I.structure tuples
 let () = I.structure triples
 let () = I.structure quad
 let () = I.structure gate_app1
 let () = I.structure with_qubits
 let () = I.structure internal
 let () = I.internal "optimizer"(final9 @-> returning final9) optimizer
 let () = I.internal "write_qasm_file"(string @-> final9 @->int @-> returning void) write_qasm
 let () = I.internal "merge_rotations"(final9 @-> returning final9) merge
 let () = I.internal "cancel_single_qubit_gates"(final9 @-> returning final9)single
 let () = I.internal "cancel_two_qubit_gates"(final9 @-> returning final9) two
 let () = I.internal "hadamard"(final9 @-> returning final9) hadamard
 let () = I.internal "not_propagation"(final9 @-> returning final9) not_propagation1
 let () = I.internal "test"(final9 @->  returning final9) test
end
