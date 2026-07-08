import mms
import math

fs, ss = mms.evaluate("div(s*(grad(V)+b*grad(T)))", "cos(2*pi*x)*sin(2*pi*y)*sin(2*pi*z)", variable="V", scalars=["s", "b", "T"])

mms.print_fparser(fs)
mms.print_fparser(ss)

fs2, ss2 = mms.evaluate("div(-k*grad(T)+b*T*J)+(-grad(V).dot(J))", "300+sin(2*pi*x)*sin(2*pi*y)*cos(2*pi*z)", variable="T", scalars=["k", "b", "V"], vectors="J")

mms.print_fparser(fs2)
mms.print_fparser(ss2)