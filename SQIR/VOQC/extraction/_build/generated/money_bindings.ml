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

external register_value : 'a name -> 'a fn -> unit =
  "money_register"

let internal : type a b.
               ?runtime_lock:bool -> string -> (a -> b) Ctypes.fn -> (a -> b) -> unit =
fun ?runtime_lock name fn f -> match fn, name with
| Function (CI.Pointer x2, Returns (CI.Pointer _)), "optimizer" -> register_value Fn_optimizer ((
 fun x1 -> let CI.CPointer x3 = f (CI.make_ptr x2 x1) in x3))
| Function
    (CI.View {CI.ty = CI.Pointer x5; read = x6; _},
     Function
       (CI.Pointer x8, Function (CI.Primitive CI.Int, Returns CI.Void))), "write_qasm_file" -> register_value Fn_write_qasm_file ((
 fun x4 x7 x9 -> f (x6 (CI.make_ptr x5 x4)) (CI.make_ptr x8 x7) x9))
| Function (CI.Pointer x11, Returns (CI.Pointer _)), "merge_rotations" -> register_value Fn_merge_rotations ((
 fun x10 -> let CI.CPointer x12 = f (CI.make_ptr x11 x10) in x12))
| Function (CI.Pointer x14, Returns (CI.Pointer _)), "cancel_single_qubit_gates" -> register_value Fn_cancel_single_qubit_gates ((
 fun x13 -> let CI.CPointer x15 = f (CI.make_ptr x14 x13) in x15))
| Function (CI.Pointer x17, Returns (CI.Pointer _)), "cancel_two_qubit_gates" -> register_value Fn_cancel_two_qubit_gates ((
 fun x16 -> let CI.CPointer x18 = f (CI.make_ptr x17 x16) in x18))
| Function (CI.Pointer x20, Returns (CI.Pointer _)), "hadamard" -> register_value Fn_hadamard ((
 fun x19 -> let CI.CPointer x21 = f (CI.make_ptr x20 x19) in x21))
| _ -> failwith ("Linking mismatch on name: " ^ name)

let enum _ _ = () and structure _ = () and union _ = () and typedef _ _ = ()
