; ModuleID = 'float_select_with_downstream_call'
source_filename = "float_select_with_downstream_call"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

define void @__hugr__.main.1(i1 %cond0, i1 %cond1) {
entry:
  %selected = select i1 %cond0, double 1.000000e+00, double 2.000000e+00
  br i1 %cond1, label %left, label %right

left:
  call void @consume(double %selected)
  br label %join

right:
  call void @consume(double %selected)
  br label %join

join:
  ret void
}

declare void @consume(double)
