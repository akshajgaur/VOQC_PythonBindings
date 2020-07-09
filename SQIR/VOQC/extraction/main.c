#include <stdio.h>
#include <money.h>
#include <stdlib.h>
int main(){
  struct tuples x;
  struct final_gates u;
  u.gates =1;
  x.gate = u;
  x.x = 9;
  struct triples t= {{3, 0}, 2, 2};
  union gate_app1 y;
  union gate_app1 yy;
  yy.App2 = t;
  y.App1 = x;
  struct internal test1;
  test1.contents[0] = y;
  test1.contents[1] = yy;
  test1.length = 3;
  struct internal *pass;
  pass =not_propagation(&test1);
  union gate_app1 get;
  get= pass->contents[0];
  union gate_app1 get1;
  get1= pass->contents[1];
  struct quad w;
  struct quad ww;
  ww = get.App3;
  w = get1.App3;

  printf("%d\n", ww.gate2.gates);
  printf("%d\n", ww.c);
  printf("%d\n", ww.f);
  printf("%d\n", ww.e);
  printf("%s\n","Second");
  printf("%d\n", get1.App2.gate2.gates);
  printf("%d\n", get1.App2.c);
  printf("%d\n", get1.App2.f);
  printf("%d\n", get1.App2.e);
 

  
}
