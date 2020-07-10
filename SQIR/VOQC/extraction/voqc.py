from ctypes import (Structure, c_char_p, c_uint, c_int,
    POINTER, CDLL,Union, byref,c_void_p)
from enum import IntEnum
import os



class final_gates(Structure):
    _fields_ = [('gates', c_int), ('x', c_int)]



class tuples(Structure):
    _fields_ = [('gate', final_gates), ('x', c_int)]


class triples(Structure):
    _fields_ = [('gate1', final_gates), ('a', c_int), ('b', c_int)]


class quad(Structure):
    _fields_ = [('gate2', final_gates), ('c', c_int), ('f', c_int), ('e', c_int)]


class gate_app1(Structure):
    _fields_ = [('App1', tuples), ('App2', triples), ('App3', quad)]
    
GATE_APP = gate_app1 *100

class with_qubits(Structure):
    _fields_ = [('length', c_int), ('contents', GATE_APP), ('qubits', c_int)]
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
            temp = final_gates(int_val,int( zarith[1]))
        else:
            temp = final_gates(gates = int_val)
            
        if sub_len == 2:
            tup = tuples(temp, py_list[i][1])
            struct_app=gate_app1(App1=tup)
        elif sub_len == 3:
            tup = triples(temp, py_list[i][1],py_list[i][2])
            struct_app=gate_app1(App2=tup)
        else:
             tup = quad(temp, py_list[i][1],py_list[i][2],py_list[i][3])
             struct_app=gate_app1(App3=tup)
        struct_return[i] = struct_app
    with_q = with_qubits(tot_length, struct_return, 0)
    return with_q
def get_text(x,y):
    gate_get = {1:'X', 2: 'H', 3:'CNOT', 4: 'Rz'+ ' '+ y}
    return gate_get.get(x)
def format_from_c(y):
    return_list = []
    deref = y.contents
    ret_length = deref.length
    for i in range(ret_length):
        val = deref.contents[i]
        if val.App1.gate.gates==0 & val.App2.gate.gates==0:
            sub_list = []
            sub_list.append(get_text(val.App3.gate2.gates, val.App3.gate2.type1))
            sub_list.append(val.App3.c)
            sub_list.append(val.App3.f)
            sub_list.append(val.App3.e)
            return_list.append(sub_list)
        elif val.App1.gate.gates==0 & val.App3.gate2.gates==0:
            sub_list = []
            sub_list.append(get_text(val.App2.gate1.gates, val.App2.gate1.type1))
            sub_list.append(val.App3.a)
            sub_list.append(val.App3.b)
            return_list.append(sub_list)
        else:
            sub_list = []
            sub_list.append(get_text(val.App1.gate.gates, val.App1.gate.type1))
            sub_list.append(val.App1.x)
            return_list.append(sub_list)
    return return_list
          
            
    
           
                

    
    
        

