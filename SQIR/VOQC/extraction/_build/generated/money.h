#include <stdint.h>
#include <stddef.h>
#include <unistd.h>
#include <gmp.h>
struct final_gates { int gates; mpq_ptr type1;  };

struct tuples { struct final_gates gate; int x;  };

struct triples { struct final_gates gate1; int a; int b;  };

struct quad { struct final_gates gate2; int c; int f; int e;  };

union gate_app1 { struct tuples App1; struct triples App2; struct quad App3; 
};

struct with_qubits { void* SQIR; int qubits;  };

struct internal { int length; union gate_app1 contents[100];  };

struct internal* optimizer(struct internal* x67);
void write_qasm_file(char* x70, struct internal* x69, int x68);
struct internal* merge_rotations(struct internal* x71);
struct internal* cancel_single_qubit_gates(struct internal* x72);
struct internal* cancel_two_qubit_gates(struct internal* x73);
struct internal* hadamard(struct internal* x74);
struct internal* not_propagation(struct internal* x75);
struct internal* test(void);

