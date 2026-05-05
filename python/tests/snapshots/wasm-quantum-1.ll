; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

@0 = private unnamed_addr constant [4 x i8] c"qub\00", align 1
@1 = private unnamed_addr constant [6 x i8] c"2 + 6\00", align 1

define dso_local void @__hugr__.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(i8* null)
  tail call void @__quantum__qis__mz__body(%Qubit* null, %Result* null)
  %0 = tail call i1 @__quantum__rt__read_result(%Result* null)
  tail call void @__quantum__rt__bool_record_output(i1 %0, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @0, i64 0, i64 0))
  %1 = tail call i64 @add_one(i64 1)
  %2 = tail call i64 @multi(i64 2, i64 3)
  %3 = add i64 %2, %1
  tail call void @__quantum__rt__int_record_output(i64 %3, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @1, i64 0, i64 0))
  ret void
}

declare i64 @multi(i64, i64) local_unnamed_addr #1

declare i64 @add_one(i64) local_unnamed_addr #1

declare void @__quantum__qis__mz__body(%Qubit*, %Result* writeonly) local_unnamed_addr #2

declare i1 @__quantum__rt__read_result(%Result* readonly) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, i8*) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, i8*) local_unnamed_addr

declare void @__quantum__rt__initialize(i8*) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="1" "required_num_results"="1" }
attributes #1 = { "wasm" }
attributes #2 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
