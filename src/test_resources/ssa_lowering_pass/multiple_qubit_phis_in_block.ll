; ModuleID = 'multiple_qubit_phis_in_block'
source_filename = "multiple_qubit_phis_in_block"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque

define void @__hugr__.main.1(i1 %cond) {
entry:
  br i1 %cond, label %then, label %else

then:
  br label %merge

else:
  br label %merge

merge:
  %selected0 = phi %Qubit* [ null, %then ], [ inttoptr (i64 1 to %Qubit*), %else ]
  %selected1 = phi %Qubit* [ inttoptr (i64 2 to %Qubit*), %then ], [ inttoptr (i64 3 to %Qubit*), %else ]
  tail call void @__quantum__qis__reset__body(%Qubit* %selected0)
  tail call void @__quantum__qis__reset__body(%Qubit* %selected1)
  ret void
}

declare void @__quantum__qis__reset__body(%Qubit*)
