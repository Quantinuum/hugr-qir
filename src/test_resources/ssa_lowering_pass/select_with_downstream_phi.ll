; ModuleID = 'select_with_downstream_phi'
source_filename = "select_with_downstream_phi"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

define void @__hugr__.main.1(i1 %cond0, i1 %cond1) {
entry:
  %selected = select i1 %cond0, %Qubit* null, %Qubit* inttoptr (i64 1 to %Qubit*)
  br i1 %cond1, label %left, label %right

left:
  br label %merge

right:
  br label %merge

merge:
  %merged = phi %Qubit* [ %selected, %left ], [ inttoptr (i64 2 to %Qubit*), %right ]
  tail call void @__quantum__qis__reset__body(%Qubit* %merged)
  ret void
}

declare void @__quantum__qis__reset__body(%Qubit*)
