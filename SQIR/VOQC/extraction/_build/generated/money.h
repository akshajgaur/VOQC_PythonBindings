#include <stdint.h>
#include <stddef.h>
#include <unistd.h>
#include <gmp.h>
enum coq_RzQ_Unitary1 {

  URzQ_H = 0,
  URzQ_X = 1,
  URzQ_Rz = 2,
  URzQ_CNOT = 3
  
};

struct final_gates { enum coq_RzQ_Unitary1 gates; mpq_ptr type1;  };

struct back_orig { struct final_gates gates1;  };

struct tuples { struct back_orig gate; int x;  };

struct triples { struct back_orig gate1; int a; int b;  };

struct quad { struct back_orig gate2; int c; int f; int e;  };

union gate_app1 { struct tuples App1; struct triples App2; struct quad App3; 
};

struct with_qubits { union gate_app1* app_list; int qubits;  };

int add(int x19);
void* optimize(void* x20);

