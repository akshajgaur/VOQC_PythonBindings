#include <stdio.h>
#include "money.h"

int main(){
  struct final_gates qa ={1,0};
  struct tuples y= {qa,100};
  struct triples z = {qa, 5,50};
  union gate_app1 u;
  u.App1 = y;
  union gate_app1 t;
  t.App2 = z;
  union gate_app1 q[2];
  q[0] = u;
  q[1]=t;
  union gate_app1 *k;
  k =cancel_two_qubit_gates(q);
  printf("%p\n", k);
  struct tuples r;
  struct triples ll;
  ll = k[1].App2;
  printf("%d\n",r.x);
  struct final_gates e;
  e = ll.gate1;
  enum coq_RzQ_Unitary1 yt;
  yt = e.gates;
  printf("%d", yt);
}
