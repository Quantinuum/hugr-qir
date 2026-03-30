; ModuleID = 'tail_switch_terminator'
source_filename = "tail_switch_terminator"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

@0 = private unnamed_addr constant [6 x i8] c"which\00", align 1

define void @__hugr__.main.1(i1 %cond, i1 %flag) {
entry:
  %selected = select i1 %cond, %Qubit* null, %Qubit* inttoptr (i64 4 to %Qubit*)
  %idx = zext i1 %flag to i64
  switch i64 %idx, label %default [
    i64 0, label %case0
    i64 1, label %case1
  ]

case0:
  br label %exit

case1:
  br label %exit

default:
  br label %exit

exit:
  %which = phi i64 [ 0, %case0 ], [ 1, %case1 ], [ 2, %default ]
  tail call void @__quantum__rt__int_record_output(i64 %which, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @0, i64 0, i64 0))
  ret void
}

declare void @__quantum__rt__int_record_output(i64, i8*)
