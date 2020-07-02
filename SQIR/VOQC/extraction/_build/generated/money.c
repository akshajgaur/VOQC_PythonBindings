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
   fn_add,
   fn_optimize,
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
int add(int x1)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = Val_long(x1);
   value x2 = functions[fn_add];
   value x3 = caml_callbackN(x2, nargs, locals);
   int x4 = Long_val(x3);
   caml_local_roots = caml__frame;;
   return x4;
}
union gate_app1* optimize(void* x11)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x11);
   value x12 = functions[fn_optimize];
   value x13 = caml_callbackN(x12, nargs, locals);
   union gate_app1* x14 = CTYPES_ADDR_OF_FATPTR(x13);
   caml_local_roots = caml__frame;;
   return x14;
}

