#include "money.h"
#include <stddef.h>
#include <stdint.h>
#include <unistd.h>
#include <gmp.h>
#include <caml/memory.h>
#include <caml/callback.h>
#include "ctypes_cstubs_internals.h"

enum functions
{
   fn_optimizer,
   fn_write_qasm_file,
   fn_merge_rotations,
   fn_cancel_single_qubit_gates,
   fn_cancel_two_qubit_gates,
   fn_hadamard,
   fn_count
};

/* A table of OCaml "callbacks". */
static value functions[fn_count];

/* Record a value in the callback table. */
value money_register(value i, value v)
{
  CAMLparam2(i, v);
  functions[Long_val(i)] = v;
  caml_register_global_root(&functions[Long_val(i)]);
  CAMLreturn (Val_unit);
}
union gate_app1* optimizer(union gate_app1* x1)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x1);
   value x2 = functions[fn_optimizer];
   value x3 = caml_callbackN(x2, nargs, locals);
   union gate_app1* x4 = CTYPES_ADDR_OF_FATPTR(x3);
   caml_local_roots = caml__frame;;
   return x4;
}
void write_qasm_file(char* x11, void* x10, int x9)
{
   enum { nargs = 3 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x11);
   locals[1] = CTYPES_FROM_PTR(x10);
   locals[2] = Val_long(x9);
   value x12 = functions[fn_write_qasm_file];
   value x13 = caml_callbackN(x12, nargs, locals);
   caml_local_roots = caml__frame;;
   return;
}
void* merge_rotations(union gate_app1* x19)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x19);
   value x20 = functions[fn_merge_rotations];
   value x21 = caml_callbackN(x20, nargs, locals);
   void* x22 = CTYPES_ADDR_OF_FATPTR(x21);
   caml_local_roots = caml__frame;;
   return x22;
}
union gate_app1* cancel_single_qubit_gates(union gate_app1* x27)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x27);
   value x28 = functions[fn_cancel_single_qubit_gates];
   value x29 = caml_callbackN(x28, nargs, locals);
   union gate_app1* x30 = CTYPES_ADDR_OF_FATPTR(x29);
   caml_local_roots = caml__frame;;
   return x30;
}
union gate_app1* cancel_two_qubit_gates(union gate_app1* x35)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x35);
   value x36 = functions[fn_cancel_two_qubit_gates];
   value x37 = caml_callbackN(x36, nargs, locals);
   union gate_app1* x38 = CTYPES_ADDR_OF_FATPTR(x37);
   caml_local_roots = caml__frame;;
   return x38;
}
union gate_app1* hadamard(union gate_app1* x43)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x43);
   value x44 = functions[fn_hadamard];
   value x45 = caml_callbackN(x44, nargs, locals);
   union gate_app1* x46 = CTYPES_ADDR_OF_FATPTR(x45);
   caml_local_roots = caml__frame;;
   return x46;
}

