; ModuleID = 'simple_float_phi'
source_filename = "simple_float_phi"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

define double @__hugr__.main.1(i1 %cond0) {
entry:
  br i1 %cond0, label %left, label %right

left:
  br label %merge

right:
  br label %merge

merge:
  %selected = phi double [ 1.000000e+00, %left ], [ 2.000000e+00, %right ]
  %sum = fadd double %selected, 3.000000e+00
  ret double %sum
}
