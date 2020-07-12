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
   fn_merge_rotations,
   fn_cancel_single_qubit_gates,
   fn_cancel_two_qubit_gates,
   fn_hadamard,
   fn_not_propagation,
   fn_get_gate_list,
   fn_write_qasm_file,
   fn_voqc,
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
struct with_qubits* optimizer(struct with_qubits* x1)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x1);
   value x2 = functions[fn_optimizer];
   value x3 = caml_callbackN(x2, nargs, locals);
   struct with_qubits* x4 = CTYPES_ADDR_OF_FATPTR(x3);
   caml_local_roots = caml__frame;;
   return x4;
}
struct with_qubits* merge_rotations(struct with_qubits* x9)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x9);
   value x10 = functions[fn_merge_rotations];
   value x11 = caml_callbackN(x10, nargs, locals);
   struct with_qubits* x12 = CTYPES_ADDR_OF_FATPTR(x11);
   caml_local_roots = caml__frame;;
   return x12;
}
struct with_qubits* cancel_single_qubit_gates(struct with_qubits* x17)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x17);
   value x18 = functions[fn_cancel_single_qubit_gates];
   value x19 = caml_callbackN(x18, nargs, locals);
   struct with_qubits* x20 = CTYPES_ADDR_OF_FATPTR(x19);
   caml_local_roots = caml__frame;;
   return x20;
}
struct with_qubits* cancel_two_qubit_gates(struct with_qubits* x25)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x25);
   value x26 = functions[fn_cancel_two_qubit_gates];
   value x27 = caml_callbackN(x26, nargs, locals);
   struct with_qubits* x28 = CTYPES_ADDR_OF_FATPTR(x27);
   caml_local_roots = caml__frame;;
   return x28;
}
struct with_qubits* hadamard(struct with_qubits* x33)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x33);
   value x34 = functions[fn_hadamard];
   value x35 = caml_callbackN(x34, nargs, locals);
   struct with_qubits* x36 = CTYPES_ADDR_OF_FATPTR(x35);
   caml_local_roots = caml__frame;;
   return x36;
}
struct with_qubits* not_propagation(struct with_qubits* x41)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x41);
   value x42 = functions[fn_not_propagation];
   value x43 = caml_callbackN(x42, nargs, locals);
   struct with_qubits* x44 = CTYPES_ADDR_OF_FATPTR(x43);
   caml_local_roots = caml__frame;;
   return x44;
}
struct with_qubits* get_gate_list(char* x49)
{
   enum { nargs = 1 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x49);
   value x50 = functions[fn_get_gate_list];
   value x51 = caml_callbackN(x50, nargs, locals);
   struct with_qubits* x52 = CTYPES_ADDR_OF_FATPTR(x51);
   caml_local_roots = caml__frame;;
   return x52;
}
void write_qasm_file(char* x58, struct with_qubits* x57)
{
   enum { nargs = 2 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x58);
   locals[1] = CTYPES_FROM_PTR(x57);
   value x59 = functions[fn_write_qasm_file];
   value x60 = caml_callbackN(x59, nargs, locals);
   caml_local_roots = caml__frame;;
   return;
}
void voqc(char* x67, char* x66)
{
   enum { nargs = 2 };
   CAMLparam0();
   CAMLlocalN(locals, nargs);
   locals[0] = CTYPES_FROM_PTR(x67);
   locals[1] = CTYPES_FROM_PTR(x66);
   value x68 = functions[fn_voqc];
   value x69 = caml_callbackN(x68, nargs, locals);
   caml_local_roots = caml__frame;;
   return;
}

