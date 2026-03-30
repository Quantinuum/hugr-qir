; ModuleID = 'tail_int_ptr_casts'
source_filename = "tail_int_ptr_casts"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

define void @__hugr__.main.1(i1 %cond, i1 %flag) {
entry:
  %selected = select i1 %cond, %Qubit* null, %Qubit* inttoptr (i64 8 to %Qubit*)
  %selected.int = ptrtoint %Qubit* %selected to i64
  %flag.ext = zext i1 %flag to i64
  %shifted = shl i64 %flag.ext, 1
  %mixed = or i64 %selected.int, %shifted
  %next = add i64 %mixed, 1
  %selected.next = inttoptr i64 %next to %Qubit*
  tail call void @__quantum__qis__reset__body(%Qubit* %selected.next)
  ret void
}

declare void @__quantum__qis__reset__body(%Qubit*)
