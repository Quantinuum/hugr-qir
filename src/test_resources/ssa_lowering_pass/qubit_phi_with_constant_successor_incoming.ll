; ModuleID = 'qubit_phi_with_constant_successor_incoming'
source_filename = "qubit_phi_with_constant_successor_incoming"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque

define void @__hugr__.main.1(i1 %cond0, i1 %cond1) {
entry:
  br i1 %cond0, label %left, label %right

left:
  br label %merge

right:
  br label %merge

merge:
  %selected = phi %Qubit* [ inttoptr (i64 1 to %Qubit*), %left ], [ inttoptr (i64 2 to %Qubit*), %right ]
  br i1 %cond1, label %succ, label %other

other:
  br label %succ

succ:
  %downstream = phi %Qubit* [ inttoptr (i64 3 to %Qubit*), %merge ], [ inttoptr (i64 4 to %Qubit*), %other ]
  call void @__quantum__qis__reset__body(%Qubit* %downstream)
  ret void
}

declare void @__quantum__qis__reset__body(%Qubit*)
