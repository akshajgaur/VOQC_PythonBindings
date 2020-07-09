#include <stdio.h>
#include <money.h>
#include <stdlib.h>
int main(){
  struct tuples x;
  struct final_gates u;
  u.gates =2;
  x.gate = u;
  x.x = 9;
  union gate_app1 y;
  y.App1 = x;
  struct internal test1;
  test1.contents[0] = y;
  test1.length = 1;
  struct internal *pass;
  pass =optimizer(&test1);
  union gate_app1 get;
  get= pass->contents[0];
  struct tuples w;
  w = get.App1;
  struct final_gates q;
  q = w.gate;
  printf("%d", w.gates);
  
 

  
}
