#include <stdint.h>
#include <stddef.h>
#include <unistd.h>
#include <gmp.h>
enum coq_RzQ_Unitary1 {

  X = 0,
  H = 1,
  CNOT = 2,
  Rz = 3
  
};

struct final_gates { enum coq_RzQ_Unitary1 gates; mpq_ptr type1;  };

struct tuples { struct final_gates gate; int x;  };

struct triples { struct final_gates gate1; int a; int b;  };

struct quad { struct final_gates gate2; int c; int f; int e;  };

union gate_app1 { struct tuples App1; struct triples App2; struct quad App3; 
};

struct with_qubits { void* SQIR; int qubits;  };

union gate_app1* optimizer(union gate_app1* x51);
void write_qasm_file(char* x54, void* x53, int x52);
void* merge_rotations(union gate_app1* x55);
union gate_app1* cancel_single_qubit_gates(union gate_app1* x56);
union gate_app1* cancel_two_qubit_gates(union gate_app1* x57);
union gate_app1* hadamard(union gate_app1* x58);

