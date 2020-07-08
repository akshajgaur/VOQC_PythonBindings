#include <stdio.h>
#include <money.h>
#include <stdlib.h>
int main(){
  struct internal *yy;
  yy= test();
  struct internal *tt;
  int x = yy ->length;
  printf("%d\n", x);
  union gate_app1 u;
  union gate_app1 qa;
  qa = yy->contents[0];
  u = yy->contents[1];
  struct tuples i;
  struct triples o;
  o = qa.App2;
  i = u.App1;
  struct final_gates r;
  struct final_gates rw;
  r = o.gate1;
  rw = i.gate;
  printf("%d\n", r.gates);
  printf("%d\n", o.a);
  printf("%d\n", o.b);
  printf("%s\n", "Second one");
  printf("%d\n", rw.gates);
  printf("%d\n", i.x);
  
 

  
}
  
