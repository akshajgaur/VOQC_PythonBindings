#include <stdint.h>
#include <stddef.h>
#include <unistd.h>
#include <gmp.h>
struct final_gates { int gates; mpq_ptr type1;  };

struct tuples { struct final_gates gate; int x;  };

struct triples { struct final_gates gate1; int a; int b;  };

struct quad { struct final_gates gate2; int c; int f; int e;  };

struct gate_app1 {
  struct tuples App1; struct triples App2; struct quad App3; int ans; 
};

struct with_qubits {
  int length; struct gate_app1 contents2[100]; int qubits; 
};

struct with_qubits* optimizer(struct with_qubits* x75);
struct with_qubits* merge_rotations(struct with_qubits* x76);
struct with_qubits* cancel_single_qubit_gates(struct with_qubits* x77);
struct with_qubits* cancel_two_qubit_gates(struct with_qubits* x78);
struct with_qubits* hadamard(struct with_qubits* x79);
struct with_qubits* not_propagation(struct with_qubits* x80);
struct with_qubits* get_gate_list(char* x81);
void write_qasm_file(char* x83, struct with_qubits* x82);
void voqc(char* x85, char* x84);

