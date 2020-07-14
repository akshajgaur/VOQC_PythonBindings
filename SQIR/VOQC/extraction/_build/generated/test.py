from voqc import *

a = load("tof_3.qasm")
a.not_propagation()
a.write("out.qasm")



