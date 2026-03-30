; ModuleID = 'tail_float_casts_and_cmp'
source_filename = "tail_float_casts_and_cmp"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

define void @__hugr__.main.1(i1 %cond, i1 %flag) {
entry:
  %selected = select i1 %cond, %Qubit* null, %Qubit* inttoptr (i64 3 to %Qubit*)
  %flag.i64 = zext i1 %flag to i64
  %flag.f64 = uitofp i64 %flag.i64 to double
  %flag.f32 = fptrunc double %flag.f64 to float
  %flag.f64.ext = fpext float %flag.f32 to double
  %is.zero = fcmp oeq double %flag.f64.ext, 0.000000e+00
  br i1 %is.zero, label %left, label %right

left:
  tail call void @__quantum__qis__reset__body(%Qubit* %selected)
  ret void

right:
  tail call void @__quantum__qis__reset__body(%Qubit* %selected)
  ret void
}

declare void @__quantum__qis__reset__body(%Qubit*)
