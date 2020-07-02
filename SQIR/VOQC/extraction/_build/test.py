from ctypes import (Structure, c_char_p, c_uint, c_int,POINTER, CDLL)
class AttrList(Structure): pass
AttrList._fields_ = [
    ('name', c_char_p),
    ('next', POINTER(AttrList)),
    ('op', c_int),
]

(OP1, OP2, OP3) = (2, 3, -1)

enum = CDLL('./libenum.so')
enum.f.argtypes = [POINTER(AttrList)]
enum.f.restype = None

