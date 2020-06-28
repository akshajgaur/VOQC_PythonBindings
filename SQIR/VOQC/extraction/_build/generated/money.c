#include "money.h"
#include <stddef.h>
#include <stdint.h>
#include <unistd.h>
#include <caml/memory.h>
#include <caml/callback.h>
#include "ctypes_cstubs_internals.h"

enum functions
{
   fn_add,
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

