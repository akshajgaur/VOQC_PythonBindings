#include <stdint.h>
#include <stddef.h>
#include <unistd.h>
enum coq_RzQ_Unitary {

  URzQ_H = 0,
  URzQ_X = 1,
  URzQ_Rz = 2,
  URzQ_CNOT = 3
  
};

struct rational { float zarith;  };

struct final_gates { enum coq_RzQ_Unitary gates; struct rational type1;  };

struct tuples { struct final_gates gate; int x;  };

struct triples { struct final_gates gate1; int a; int b;  };

struct quad { struct final_gates gate2; int c; int f; int e;  };

struct gate_app { struct tuples App1; struct triples App2; struct quad App3; 
};

struct with_qubits { struct gate_app* app_list; int qubits;  };

int add(int x11);

