; ModuleID = 'simple_qubit_phi'
source_filename = "simple_qubit_phi"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

define void @__hugr__.main.1(i1 %cond) {
entry:
  br i1 %cond, label %then, label %else

then:
  br label %merge

else:
  br label %merge

merge:
  %selected = phi %Qubit* [ null, %then ], [ inttoptr (i64 1 to %Qubit*), %else ]
  tail call void @__quantum__qis__reset__body(%Qubit* %selected)
  ret void
}

declare void @__quantum__qis__reset__body(%Qubit*)
