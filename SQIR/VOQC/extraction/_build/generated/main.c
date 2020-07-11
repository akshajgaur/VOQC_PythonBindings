#include <stdio.h>
#include <money.h>
#include <stdlib.h>
int main(){
  struct with_qubits *yy;
  yy = get_gate_list("tof_3.qasm");
  struct with_qubits *yyy;
  int w=0;
  for (w = 0; w<(yy->length);w++){
  	struct gate_app1 temp;
  	temp = yy ->contents2[w];
  	if (temp.App1.gate.gates ==0 && temp.App2.gate1.gates==0){
  	temp.ans = 3;
  	yy->contents2[w] = temp;
  	}else if(temp.App2.gate1.gates ==0 && temp.App3.gate2.gates==0){
  	temp.ans = 1;
  	yy->contents2[w]=temp;
  	}else{
  	temp.ans = 2;
  	yy->contents2[w] = temp;
  	}
	}
  yyy = optimizer(yy);
    
  int i=0;
  for (i = 0; i<(yyy->length);i++){
  	struct gate_app1 temp;
  	temp = yyy ->contents2[i];
  	if (temp.App1.gate.gates ==0 && temp.App2.gate1.gates==0){
  	temp.ans = 3;
  	yyy->contents2[i] = temp;
  	}else if(temp.App2.gate1.gates ==0 && temp.App3.gate2.gates==0){
  	temp.ans = 1;
  	yyy->contents2[i]=temp;
  	}else{
  	temp.ans = 2;
  	yyy->contents2[i] = temp;
  	}
	}
  write_qasm_file("me", yyy);
    /* struct gate_app1 g;
  int w;
  for (w= 0;w<(gate_l->length);w++){
  g = gate_l ->contents2[6];
  printf("%d\n", g.App1.gate.gates);
  printf("%d\n", g.App1.x);
   printf("%s\n","------------------------------");
  printf("%d\n", g.App2.gate1.gates);
  printf("%d\n", g.App2.a);
  printf("%d\n", g.App2.b);
  printf("%s\n","------------------------------");
  printf("%d\n", g.App3.gate2.gates);
  printf("%d\n", g.App3.c);
  printf("%d\n", g.App3.f);
  printf("%d\n", g.App3.e);
  printf("%s\n","------------------------------");
  printf("%s\n\n","NEXT");
  }
    */ 

  
  
  
 
  
  
}
