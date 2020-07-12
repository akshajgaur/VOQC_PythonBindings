from ctypes import *
import argparse



class final_gates(Structure):
    _fields_ = [('gates', c_int), ('type1', c_void_p)]



class tuples(Structure):
    _fields_ = [('gate', final_gates), ('x', c_int)]


class triples(Structure):
    _fields_ = [('gate1', final_gates), ('a', c_int), ('b', c_int)]


class quad(Structure):
    _fields_ = [('gate2', final_gates), ('c', c_int), ('f', c_int), ('e', c_int)]


class gate_app1(Structure):
    _fields_ = [('App1', tuples), ('App2', triples), ('App3', quad),('ans', c_int)]
    
GATE_APP = gate_app1 *100

class with_qubits(Structure):
    _fields_ = [('length', c_int), ('contents2', GATE_APP), ('qubits', c_int)]
def convert_gates(x):
    y = 0
    if x == 'X':
        y = 1
    elif x == 'H':
        y =2
    elif x == 'CNOT':
        y =3
    else:
        y=4
    return y
def format_to_c(py_list):
    struct_return = GATE_APP()
    struct_app = gate_app1()
    tot_length = len(py_list)
    for i in range(tot_length):
        sub_len = len(py_list[i])
        int_val = convert_gates(py_list[i][0])
        zarith = py_list[i][0].split()
        if int_val ==4:
            temp = final_gates(int_val,int(zarith[1]))
        else:
            temp = final_gates(gates = int_val)
            
        if sub_len == 2:
            tup = tuples(temp, py_list[i][1])
            struct_app=gate_app1(App1=tup, ans =1)
        elif sub_len == 3:
            tup = triples(temp, py_list[i][1],py_list[i][2])
            struct_app=gate_app1(App2=tup, ans=2)
        else:
             tup = quad(temp, py_list[i][1],py_list[i][2],py_list[i][3])
             struct_app=gate_app1(App3=tup, ans =3)
        struct_return[i] = struct_app
    with_q = with_qubits(tot_length, struct_return, 0)
    return with_q
def get_text(x,y):
    gate_get = {1:'X', 2: 'H', 3:'CNOT', 4: 'Rz'}
    return gate_get.get(x)
def format_from_c(y):
    return_list = []
    val = gate_app1()
    deref = y.contents
    for i in range(deref.length):
        val = deref.contents2[i]
        if val.App2.gate1.gates == 0 and val.App3.gate2.gates ==0:
            sub_list = []
            sub_list.append(get_text(val.App1.gate.gates,0))
            sub_list.append(val.App1.x)
            return_list.append(sub_list)
        elif val.App3.gate2.gates ==0 and val.App1.gate.gates==0:
            sub_list =[]
            sub_list.append(get_text(val.App2.gate1.gates,0))
            sub_list.append(val.App2.a)
            sub_list.append(val.App2.b)
            return_list.append(sub_list)
        else:
            sub_list = []
            sub_list.append(get_text(val.App3.gate2.gates,0))
            sub_list.append(val.App3.c)
            sub_list.append(val.App3.f)
            sub_list.append(val.App3.e)
            return_list.append(sub_list)
            
            
        
        
    return return_list
def get_gate_list(fname): 
    testlib = CDLL('./libvoqc.so')
    testlib.get_gate_list.argtypes = [c_char_p]
    testlib.get_gate_list.restype = POINTER(with_qubits)
    final_file =str(fname).encode('utf-8')
    circ = testlib.get_gate_list(final_file)
    q = circ.contents.qubits
    print(format_from_c(circ), q)


def voqc(fname, out):
    testlib = CDLL('./libvoqc.so')
    testlib.get_gate_list.argtypes = [c_char_p, c_char_p]
    testlib.get_gate_list.restype = None
    in_file =str(fname).encode('utf-8')
    out_file = str(out).encode('utf-8')
    testlib.voqc(in_file, out_file)
    
def optimize(sqir):
    testlib = CDLL('./libvoqc.so')
    testlib.not_propagation.argtypes =[POINTER(with_qubits)]
    testlib.not_propagation.restype =POINTER(with_qubits)
    with_c = format_to_c(sqir)
    print(format_from_c(testlib.not_propagation(byref(with_c))))
    
    
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Pass a function name and then its parameters")
    parser.add_argument("-f", "--function", help="Function to be called")
    parser.add_argument("-i", help="Pass file to function")
    parser.add_argument("-o", help="Name of output qasm file")
    parser.add_argument("-s", help= "Input Sqir circut", nargs = '+')
    args, unknown = parser.parse_known_args()
    if args.function == 'voqc':
        voqc(args.i,args.o)
    elif args.function == 'get_gate_list':
        get_gate_list(args.i)
    elif args.function=='optimize':
        trav_list = []
        print(args.s)
optimize([['X', 4], ['CNOT', 4, 5]])
        


    


    
    
        
