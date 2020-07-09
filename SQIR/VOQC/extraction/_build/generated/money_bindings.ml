type 'a fn = 'a

module CI = Cstubs_internals

type 'a f = 'a CI.fn =
 | Returns  : 'a CI.typ   -> 'a f
 | Function : 'a CI.typ * 'b f  -> ('a -> 'b) f
type 'a name = 
| Fn_optimizer : (CI.voidp -> _ CI.fatptr) name
| Fn_write_qasm_file : (CI.voidp -> CI.voidp -> int -> unit) name
| Fn_merge_rotations : (CI.voidp -> _ CI.fatptr) name
| Fn_cancel_single_qubit_gates : (CI.voidp -> _ CI.fatptr) name
| Fn_cancel_two_qubit_gates : (CI.voidp -> _ CI.fatptr) name
| Fn_hadamard : (CI.voidp -> _ CI.fatptr) name
| Fn_not_propagation : (CI.voidp -> _ CI.fatptr) name
| Fn_test : (CI.voidp -> _ CI.fatptr) name

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
     Function
       (CI.View {CI.ty = CI.Pointer x11; read = x12; _},
        Function (CI.Primitive CI.Int, Returns CI.Void))), "write_qasm_file" -> register_value Fn_write_qasm_file ((
 fun x7 x10 x13 ->
  f (x9 (CI.make_ptr x8 x7)) (x12 (CI.make_ptr x11 x10)) x13))
| Function
    (CI.View {CI.ty = CI.Pointer x15; read = x16; _},
     Returns (CI.View {CI.ty = CI.Pointer _; write = x17; _})), "merge_rotations" -> register_value Fn_merge_rotations ((
 fun x14 ->
  let CI.CPointer x19 = x17 (f (x16 (CI.make_ptr x15 x14))) in
  let x18 = x19 in x18))
| Function
    (CI.View {CI.ty = CI.Pointer x21; read = x22; _},
     Returns (CI.View {CI.ty = CI.Pointer _; write = x23; _})), "cancel_single_qubit_gates" -> register_value Fn_cancel_single_qubit_gates ((
 fun x20 ->
  let CI.CPointer x25 = x23 (f (x22 (CI.make_ptr x21 x20))) in
  let x24 = x25 in x24))
| Function
    (CI.View {CI.ty = CI.Pointer x27; read = x28; _},
     Returns (CI.View {CI.ty = CI.Pointer _; write = x29; _})), "cancel_two_qubit_gates" -> register_value Fn_cancel_two_qubit_gates ((
 fun x26 ->
  let CI.CPointer x31 = x29 (f (x28 (CI.make_ptr x27 x26))) in
  let x30 = x31 in x30))
| Function
    (CI.View {CI.ty = CI.Pointer x33; read = x34; _},
     Returns (CI.View {CI.ty = CI.Pointer _; write = x35; _})), "hadamard" -> register_value Fn_hadamard ((
 fun x32 ->
  let CI.CPointer x37 = x35 (f (x34 (CI.make_ptr x33 x32))) in
  let x36 = x37 in x36))
| Function
    (CI.View {CI.ty = CI.Pointer x39; read = x40; _},
     Returns (CI.View {CI.ty = CI.Pointer _; write = x41; _})), "not_propagation" -> register_value Fn_not_propagation ((
 fun x38 ->
  let CI.CPointer x43 = x41 (f (x40 (CI.make_ptr x39 x38))) in
  let x42 = x43 in x42))
| Function
    (CI.View {CI.ty = CI.Pointer x45; read = x46; _},
     Returns (CI.View {CI.ty = CI.Pointer _; write = x47; _})), "test" -> register_value Fn_test ((
 fun x44 ->
  let CI.CPointer x49 = x47 (f (x46 (CI.make_ptr x45 x44))) in
  let x48 = x49 in x48))
| _ -> failwith ("Linking mismatch on name: " ^ name)

let enum _ _ = () and structure _ = () and union _ = () and typedef _ _ = ()
