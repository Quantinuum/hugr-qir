; ModuleID = 'tail_record_output_and_downstream_phi'
source_filename = "tail_record_output_and_downstream_phi"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

@0 = private unnamed_addr constant [8 x i8] c"first\00\00\00", align 1

define void @__hugr__.main.1(i1 %cond0, i1 %cond1) {
entry:
  %selected = select i1 %cond0, %Qubit* null, %Qubit* inttoptr (i64 6 to %Qubit*)
  %flag = tail call i1 @__quantum__qis__read_result__body(%Result* null)
  tail call void @__quantum__rt__bool_record_output(i1 %flag, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @0, i64 0, i64 0))
  br i1 %cond1, label %left, label %right

left:
  br label %join

right:
  br label %join

join:
  %merged.flag = phi i1 [ %flag, %left ], [ true, %right ]
  tail call void @__test__consume_bool(i1 %merged.flag)
  ret void
}

declare i1 @__quantum__qis__read_result__body(%Result*)
declare void @__quantum__rt__bool_record_output(i1, i8*)
declare void @__test__consume_bool(i1)
