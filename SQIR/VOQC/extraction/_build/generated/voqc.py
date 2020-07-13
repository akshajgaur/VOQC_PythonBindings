from ctypes import *
import argparse
import ast
from gmpy2 import mpq

class rational(Structure):
    _fields_ = [('num', c_int), ('den', c_int)]

class final_gates(Structure):
    _fields_ = [('gates', c_int), ('type1', rational)]



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
        temp = final_gates(gates = int_val)
            
        if sub_len == 2:
            tup = tuples(temp, int(py_list[i][1]))
            struct_app=gate_app1(App1=tup, ans =1)
        elif sub_len == 3:
            tup = triples(temp, int(py_list[i][1]),int(py_list[i][2]))
            struct_app=gate_app1(App2=tup, ans=2)
        else:
             tup = quad(temp, int(py_list[i][1]),int(py_list[i][2]),int(py_list[i][3]))
             struct_app=gate_app1(App3=tup, ans =3)
        struct_return[i] = struct_app
    with_q = with_qubits(tot_length, struct_return, 0)
    return with_q
def get_text(x,y,z):
    gate_get = {1:'X', 2: 'H', 3:'CNOT', 4: 'Rz'+ ' ' +str(y) + '/' + str(z)}
    return gate_get.get(x)
def format_from_c(y):
    return_list = []
    val = gate_app1()
    deref = y.contents
    for i in range(deref.length):
        val = deref.contents2[i]
        if val.App2.gate1.gates == 0 and val.App3.gate2.gates ==0:
            sub_list = []
            sub_list.append(get_text(val.App1.gate.gates,val.App1.gate.type1.num, val.App1.gate.type1.den))
            sub_list.append(val.App1.x)
            return_list.append(sub_list)
        elif val.App3.gate2.gates ==0 and val.App1.gate.gates==0:
            sub_list =[]
            sub_list.append(get_text(val.App2.gate1.gates,val.App2.gate1.type1.num, val.App2.gate1.type1.den))
            sub_list.append(val.App2.a)
            sub_list.append(val.App2.b)
            return_list.append(sub_list)
        else:
            sub_list = []
            sub_list.append(get_text(val.App3.gate2.gates,val.App3.gate2.type1.num, val.App3.gate2.type1.den))
            sub_list.append(val.App3.c)
            sub_list.append(val.App3.f)
            sub_list.append(val.App3.e)
            return_list.append(sub_list)
        
    return return_list
def get_gate_list(fname, out): 
    testlib = CDLL('./libvoqc.so')
    testlib.get_gate_list.argtypes = [c_char_p]
    testlib.get_gate_list.restype = POINTER(with_qubits)
    final_file =str(fname).encode('utf-8')
    circ = testlib.get_gate_list(final_file)
    q = circ.contents.qubits
    temp = format_from_c(circ)
    f = open(out, "w+")
    with open(out, 'w') as f:
        for item in temp:
            f.write("%s\n" % item)
    print(format_from_c(circ), q)


def voqc(fname, out):
    testlib = CDLL('./libvoqc.so')
    testlib.get_gate_list.argtypes = [c_char_p, c_char_p]
    testlib.get_gate_list.restype = None
    in_file =str(fname).encode('utf-8')
    out_file = str(out).encode('utf-8')
    testlib.voqc(in_file, out_file)
    
def optimize(fname, out):
    to_py = []
    input1 = open(fname +'.txt')
    for i in (input1.readlines()):
        to_py.append(i)
    new_py = []
    new_py = [x[:-1] for x in to_py]
    fin_py = []
    for i in range(len(new_py)):
        if new_py[i]!= ' ':
            fin_py.append(ast.literal_eval(new_py[i]))
    testlib = CDLL('./libvoqc.so')
    testlib.optimizer.argtypes =[POINTER(with_qubits)]
    testlib.optimizer.restype =POINTER(with_qubits)
    with_c = format_to_c(fin_py)
    temp = format_from_c(testlib.optimizer(byref(with_c)))
    with open(out, 'w') as f:
        for item in temp:
            f.write("%s\n" % item)
    print(temp)
    
def write_qasm_file(out, sqir):
    to_py = []
    input1 = open(fname +'.txt')
    for i in (input1.readlines()):
        to_py.append(i)
    new_py = []
    new_py = [x[:-1] for x in to_py]
    fin_py = []
    for i in range(len(new_py)):
        if new_py[i]!= ' ':
            fin_py.append(ast.literal_eval(new_py[i]))
    testlib = CDLL('./libvoqc.so')
    testlib.not_propagation.argtypes =[POINTER(with_qubits)]
    testlib.not_propagation.restype =POINTER(with_qubits)
    with_c = format_to_c(fin_py)
    temp = format_from_c(testlib.not_propagation(byref(with_c)))
    with open(out, 'w') as f:
        for item in temp:
            f.write("%s\n" % item)
    print(temp)
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Pass a function name and then its parameters")
    parser.add_argument("-f", "--function", help="Function to be called")
    parser.add_argument("-i", help="Pass file to function")
    parser.add_argument("-o", help="Name of output qasm file")
    args, unknown = parser.parse_known_args()
    if args.function == 'voqc':
        voqc(args.i,args.o)
    elif args.function == 'get_gate_list':
        get_gate_list(args.i, args.o)
    elif args.function=='optimize':
        optimize(args.i, args.o)

        


    


    
    
        

