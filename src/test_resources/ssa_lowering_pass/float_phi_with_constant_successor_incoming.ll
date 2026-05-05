; ModuleID = 'float_phi_with_constant_successor_incoming'
source_filename = "float_phi_with_constant_successor_incoming"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

define void @__hugr__.main.1(i1 %cond0, i1 %cond1) {
entry:
  br i1 %cond0, label %left, label %right

left:
  br label %merge

right:
  br label %merge

merge:
  %selected = phi double [ 1.000000e+00, %left ], [ 2.000000e+00, %right ]
  br i1 %cond1, label %succ, label %other

other:
  br label %succ

succ:
  %downstream = phi double [ 3.000000e+00, %merge ], [ 4.000000e+00, %other ]
  call void @consume(double %downstream)
  ret void
}

declare void @consume(double)
