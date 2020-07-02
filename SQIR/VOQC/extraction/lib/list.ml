open Ctypes
open UnitaryListRepresentation
open RzQGateSet.RzQGateSet
module CList :
sig
  type t
  val t : t typ  (* Used to describe interfaces to C *) 

  val alloc : RzQGateSet.RzQGateSet.coq_RzQ_Unitary UnitaryListRepresentation.gate_app list -> t
  val free : t -> unit

  val get : t -> RzQGateSet.RzQGateSet.coq_RzQ_Unitary UnitaryListRepresentation.gate_app list
  val set : t -> RzQGateSet.RzQGateSet.coq_RzQ_Unitary UnitaryListRepresentation.gate_app list -> unit
end =
struct
  type t = unit ptr
  let t = ptr void

  let alloc = Root.create
  let free = Root.release

  let get = Root.get
  let set = Root.set
end