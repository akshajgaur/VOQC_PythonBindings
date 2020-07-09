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
   fn_not_propagation,
   fn_test,
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
struct internal* optimizer(struct internal* x1)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x1);
   value x2 = functions[fn_optimizer];
   value x3 = caml_callbackN(x2, nargs, locals);
   struct internal* x4 = CTYPES_ADDR_OF_FATPTR(x3);
   caml_local_roots = caml__frame;;
   return x4;
}
void write_qasm_file(char* x11, struct internal* x10, int x9)
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
struct internal* merge_rotations(struct internal* x19)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x19);
   value x20 = functions[fn_merge_rotations];
   value x21 = caml_callbackN(x20, nargs, locals);
   struct internal* x22 = CTYPES_ADDR_OF_FATPTR(x21);
   caml_local_roots = caml__frame;;
   return x22;
}
struct internal* cancel_single_qubit_gates(struct internal* x27)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x27);
   value x28 = functions[fn_cancel_single_qubit_gates];
   value x29 = caml_callbackN(x28, nargs, locals);
   struct internal* x30 = CTYPES_ADDR_OF_FATPTR(x29);
   caml_local_roots = caml__frame;;
   return x30;
}
struct internal* cancel_two_qubit_gates(struct internal* x35)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x35);
   value x36 = functions[fn_cancel_two_qubit_gates];
   value x37 = caml_callbackN(x36, nargs, locals);
   struct internal* x38 = CTYPES_ADDR_OF_FATPTR(x37);
   caml_local_roots = caml__frame;;
   return x38;
}
struct internal* hadamard(struct internal* x43)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x43);
   value x44 = functions[fn_hadamard];
   value x45 = caml_callbackN(x44, nargs, locals);
   struct internal* x46 = CTYPES_ADDR_OF_FATPTR(x45);
   caml_local_roots = caml__frame;;
   return x46;
}
struct internal* not_propagation(struct internal* x51)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x51);
   value x52 = functions[fn_not_propagation];
   value x53 = caml_callbackN(x52, nargs, locals);
   struct internal* x54 = CTYPES_ADDR_OF_FATPTR(x53);
   caml_local_roots = caml__frame;;
   return x54;
}
struct internal* test(struct internal* x59)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x59);
   value x60 = functions[fn_test];
   value x61 = caml_callbackN(x60, nargs, locals);
   struct internal* x62 = CTYPES_ADDR_OF_FATPTR(x61);
   caml_local_roots = caml__frame;;
   return x62;
}

