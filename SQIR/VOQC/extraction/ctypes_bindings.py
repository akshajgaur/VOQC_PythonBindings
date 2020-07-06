from ctypes import (Structure, c_char_p, c_uint, c_int,
    POINTER, CDLL,Union, byref,c_void_p)
from enum import IntEnum


class coq_RzQ_Unitary1(IntEnum):
    URzQ_X = 0
    URzQ_H = 1
    URzQ_Rz = 2
    URzQ_CNOT = 3


class final_gates(Structure):
    _fields_ = [('gates', c_int), ('x', c_int)]


class back_orig(Structure):
    _fields_ = [('gates1', final_gates)]


class tuples(Structure):
    _fields_ = [('gate', back_orig), ('x', c_int)]


class triples(Structure):
    _fields_ = [('gate1', back_orig), ('a', c_int), ('b', c_int)]


class quad(Structure):
    _fields_ = [('gate2', back_orig), ('c', c_int), ('f', c_int), ('e', c_int),]


class gate_app1(Union):
    _fields_ = [('App1', tuples), ('App2', triples), ('App3', quad)]


final1 = final_gates(2, 3)
basic1 = back_orig(final1)
tripe = triples(basic1,5,5)
dube = tuples(basic1,3)
a= gate_app1()
b = gate_app1()
GateArr = gate_app1 * 2
a.App2 = tripe
b.App1 = dube
x = GateArr(a, b)
testlib = CDLL('./libvoqc.so')
testlib.optimize.argtype= c_void_p
testlib.optimize.restype = c_void_p
print(testlib.optimize(byref(x)))
