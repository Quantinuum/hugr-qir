; ModuleID = 'simple_float_select'
source_filename = "simple_float_select"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

define double @__hugr__.main.1(i1 %cond0) {
entry:
  %selected = select i1 %cond0, double 1.000000e+00, double 2.000000e+00
  %sum = fadd double %selected, 3.000000e+00
  ret double %sum
}
