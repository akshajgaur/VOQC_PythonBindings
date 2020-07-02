type 'a fn = 'a

module CI = Cstubs_internals

type 'a f = 'a CI.fn =
 | Returns  : 'a CI.typ   -> 'a f
 | Function : 'a CI.typ * 'b f  -> ('a -> 'b) f
type 'a name = 
| Fn_add : (int -> int) name
| Fn_optimize : (CI.voidp -> _ CI.fatptr) name

external register_value : 'a name -> 'a fn -> unit =
  "money_register"

let internal : type a b.
               ?runtime_lock:bool -> string -> (a -> b) Ctypes.fn -> (a -> b) -> unit =
fun ?runtime_lock name fn f -> match fn, name with
| Function (CI.Primitive CI.Int, Returns (CI.Primitive CI.Int)), "add" -> register_value Fn_add (f)
| Function (CI.Pointer x3, Returns (CI.Pointer _)), "optimize" -> register_value Fn_optimize ((
 fun x2 -> let CI.CPointer x4 = f (CI.make_ptr x3 x2) in x4))
| _ -> failwith ("Linking mismatch on name: " ^ name)

let enum _ _ = () and structure _ = () and union _ = () and typedef _ _ = ()
