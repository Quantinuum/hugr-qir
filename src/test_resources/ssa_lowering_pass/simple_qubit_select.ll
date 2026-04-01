; ModuleID = 'simple_qubit_select'
source_filename = "simple_qubit_select"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

define void @__hugr__.main.1(i1 %cond) {
entry:
  %selected = select i1 %cond, %Qubit* null, %Qubit* inttoptr (i64 1 to %Qubit*)
  tail call void @__quantum__qis__reset__body(%Qubit* %selected)
  ret void
}

declare void @__quantum__qis__reset__body(%Qubit*)
