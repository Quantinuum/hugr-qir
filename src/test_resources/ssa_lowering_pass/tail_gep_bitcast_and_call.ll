; ModuleID = 'tail_gep_bitcast_and_call'
source_filename = "tail_gep_bitcast_and_call"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

@0 = private unnamed_addr constant [5 x i8] c"tail\00", align 1

define void @__hugr__.main.1(i1 %cond) {
entry:
  %selected = select i1 %cond, %Qubit* null, %Qubit* inttoptr (i64 5 to %Qubit*)
  %label.ptr = bitcast [5 x i8]* @0 to i8*
  %label.gep = getelementptr inbounds i8, i8* %label.ptr, i64 1
  tail call void @__test__consume_label(i8* %label.gep)
  tail call void @__quantum__qis__reset__body(%Qubit* %selected)
  ret void
}

declare void @__test__consume_label(i8*)
declare void @__quantum__qis__reset__body(%Qubit*)
