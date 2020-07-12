type 'a fn = 'a

module CI = Cstubs_internals

type 'a f = 'a CI.fn =
 | Returns  : 'a CI.typ   -> 'a f
 | Function : 'a CI.typ * 'b f  -> ('a -> 'b) f
type 'a name = 
| Fn_optimizer : (CI.voidp -> _ CI.fatptr) name
| Fn_merge_rotations : (CI.voidp -> _ CI.fatptr) name
| Fn_cancel_single_qubit_gates : (CI.voidp -> _ CI.fatptr) name
| Fn_cancel_two_qubit_gates : (CI.voidp -> _ CI.fatptr) name
| Fn_hadamard : (CI.voidp -> _ CI.fatptr) name
| Fn_not_propagation : (CI.voidp -> _ CI.fatptr) name
| Fn_get_gate_list : (CI.voidp -> _ CI.fatptr) name
| Fn_write_qasm_file : (CI.voidp -> CI.voidp -> unit) name
| Fn_voqc : (CI.voidp -> CI.voidp -> unit) name

external register_value : 'a name -> 'a fn -> unit =
  "money_register"

let internal : type a b.
               ?runtime_lock:bool -> string -> (a -> b) Ctypes.fn -> (a -> b) -> unit =
fun ?runtime_lock name fn f -> match fn, name with
| Function
    (CI.View {CI.ty = CI.Pointer x2; read = x3; _},
     Returns (CI.View {CI.ty = CI.Pointer _; write = x4; _})), "optimizer" -> register_value Fn_optimizer ((
 fun x1 ->
  let CI.CPointer x6 = x4 (f (x3 (CI.make_ptr x2 x1))) in let x5 = x6 in x5))
| Function
    (CI.View {CI.ty = CI.Pointer x8; read = x9; _},
     Returns (CI.View {CI.ty = CI.Pointer _; write = x10; _})), "merge_rotations" -> register_value Fn_merge_rotations ((
 fun x7 ->
  let CI.CPointer x12 = x10 (f (x9 (CI.make_ptr x8 x7))) in
  let x11 = x12 in x11))
| Function
    (CI.View {CI.ty = CI.Pointer x14; read = x15; _},
     Returns (CI.View {CI.ty = CI.Pointer _; write = x16; _})), "cancel_single_qubit_gates" -> register_value Fn_cancel_single_qubit_gates ((
 fun x13 ->
  let CI.CPointer x18 = x16 (f (x15 (CI.make_ptr x14 x13))) in
  let x17 = x18 in x17))
| Function
    (CI.View {CI.ty = CI.Pointer x20; read = x21; _},
     Returns (CI.View {CI.ty = CI.Pointer _; write = x22; _})), "cancel_two_qubit_gates" -> register_value Fn_cancel_two_qubit_gates ((
 fun x19 ->
  let CI.CPointer x24 = x22 (f (x21 (CI.make_ptr x20 x19))) in
  let x23 = x24 in x23))
| Function
    (CI.View {CI.ty = CI.Pointer x26; read = x27; _},
     Returns (CI.View {CI.ty = CI.Pointer _; write = x28; _})), "hadamard" -> register_value Fn_hadamard ((
 fun x25 ->
  let CI.CPointer x30 = x28 (f (x27 (CI.make_ptr x26 x25))) in
  let x29 = x30 in x29))
| Function
    (CI.View {CI.ty = CI.Pointer x32; read = x33; _},
     Returns (CI.View {CI.ty = CI.Pointer _; write = x34; _})), "not_propagation" -> register_value Fn_not_propagation ((
 fun x31 ->
  let CI.CPointer x36 = x34 (f (x33 (CI.make_ptr x32 x31))) in
  let x35 = x36 in x35))
| Function
    (CI.View {CI.ty = CI.Pointer x38; read = x39; _},
     Returns (CI.View {CI.ty = CI.Pointer _; write = x40; _})), "get_gate_list" -> register_value Fn_get_gate_list ((
 fun x37 ->
  let CI.CPointer x42 = x40 (f (x39 (CI.make_ptr x38 x37))) in
  let x41 = x42 in x41))
| Function
    (CI.View {CI.ty = CI.Pointer x44; read = x45; _},
     Function
       (CI.View {CI.ty = CI.Pointer x47; read = x48; _}, Returns CI.Void)), "write_qasm_file" -> register_value Fn_write_qasm_file ((
 fun x43 x46 -> f (x45 (CI.make_ptr x44 x43)) (x48 (CI.make_ptr x47 x46))))
| Function
    (CI.View {CI.ty = CI.Pointer x50; read = x51; _},
     Function
       (CI.View {CI.ty = CI.Pointer x53; read = x54; _}, Returns CI.Void)), "voqc" -> register_value Fn_voqc ((
 fun x49 x52 -> f (x51 (CI.make_ptr x50 x49)) (x54 (CI.make_ptr x53 x52))))
| _ -> failwith ("Linking mismatch on name: " ^ name)

let enum _ _ = () and structure _ = () and union _ = () and typedef _ _ = ()
