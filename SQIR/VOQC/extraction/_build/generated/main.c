#include <stdio.h>
#include <money.h>
#include <stdlib.h>
int main(){
  struct tuples xg = {{1, 0},1};
  struct triples cnotg = {{3, 0}, 2, 8};
  struct triples cnotg = {{4, 1.9}, 2, 8};
  struct gate_app1 first;
  first.App1 = xg;
  first.ans = 1;
  struct gate_app1 second;
  second.App2 = cnotg;
  second.ans = 2;
  struct internal pass;
  pass.contents[0] = first;
  pass.contents[1] = second;
  pass.length = 2;
  printf("%s\n", "Input 1");
  printf("%d\n", pass.contents[0].App1.gate.gates);
  printf("%d\n", pass.contents[0].App1.x);
  printf("%s\n", "Input 2");
  printf("%d\n", pass.contents[1].App2.gate1.gates);
  printf("%d\n", pass.contents[1].App2.a);
  printf("%d\n", pass.contents[1].App2.b);
  printf("%s\n", "---------------------------------");

  
  struct internal *get;
  get =not_propagation(&pass);
  struct gate_app1 f;
  struct gate_app1 s;
  f = get ->contents[0];
  s = get ->contents[1];
  printf("%s\n", "Output 1");
  printf("%d\n", f.App2.gate1.gates);
  printf("%d\n", f.App2.a);
  printf("%d\n", f.App2.b);
  printf("%s\n", "Output 2");
  printf("%d\n", s.App1.gate.gates);
  printf("%d\n", s.App1.x);
  

  
  
  
 
  
  
}
