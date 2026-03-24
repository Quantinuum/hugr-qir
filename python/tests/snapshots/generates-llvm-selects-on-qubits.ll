; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

@0 = private unnamed_addr constant [3 x i8] c"q0\00", align 1
@1 = private unnamed_addr constant [3 x i8] c"q1\00", align 1
@2 = private unnamed_addr constant [3 x i8] c"q2\00", align 1
@3 = private unnamed_addr constant [3 x i8] c"q3\00", align 1

define dso_local void @__hugr__.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 4 to %Qubit*), %Result* null)
  %0 = tail call i1 @__quantum__qis__read_result__body(%Result* null)
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 5 to %Qubit*), %Result* nonnull inttoptr (i64 1 to %Result*))
  %1 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 1 to %Result*))
  br i1 %1, label %alloca_blockselect.merge_dupselect.merge_dup, label %alloca_blockselect.merge_dup548select.merge_dup559

alloca_blockselect.merge_dupselect.merge_dup:     ; preds = %alloca_block
  br i1 %0, label %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup, label %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup555

common.ret:                                       ; preds = %alloca_blockselect.merge_dup548select.merge_dup559select.merge_dup562, %alloca_blockselect.merge_dup548select.merge_dup559select.merge_dup, %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup555, %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup
  ret void

alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup: ; preds = %alloca_blockselect.merge_dupselect.merge_dup
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  %2 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %2, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @0, i64 0, i64 0))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  %3 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %3, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @1, i64 0, i64 0))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  %4 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %4, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @2, i64 0, i64 0))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  %5 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %5, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @3, i64 0, i64 0))
  br label %common.ret

alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup555: ; preds = %alloca_blockselect.merge_dupselect.merge_dup
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 2 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  %6 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %6, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @0, i64 0, i64 0))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  %7 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @1, i64 0, i64 0))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  %8 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %8, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @2, i64 0, i64 0))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  %9 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %9, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @3, i64 0, i64 0))
  br label %common.ret

alloca_blockselect.merge_dup548select.merge_dup559: ; preds = %alloca_block
  br i1 %0, label %alloca_blockselect.merge_dup548select.merge_dup559select.merge_dup, label %alloca_blockselect.merge_dup548select.merge_dup559select.merge_dup562

alloca_blockselect.merge_dup548select.merge_dup559select.merge_dup: ; preds = %alloca_blockselect.merge_dup548select.merge_dup559
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 1 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  %10 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %10, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @0, i64 0, i64 0))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  %11 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %11, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @1, i64 0, i64 0))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  %12 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %12, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @2, i64 0, i64 0))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  %13 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %13, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @3, i64 0, i64 0))
  br label %common.ret

alloca_blockselect.merge_dup548select.merge_dup559select.merge_dup562: ; preds = %alloca_blockselect.merge_dup548select.merge_dup559
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 3 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  %14 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %14, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @0, i64 0, i64 0))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  %15 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %15, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @1, i64 0, i64 0))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  %16 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %16, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @2, i64 0, i64 0))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  %17 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %17, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @3, i64 0, i64 0))
  br label %common.ret
}

declare void @__quantum__qis__mz__body(%Qubit*, %Result*) local_unnamed_addr

declare i1 @__quantum__qis__read_result__body(%Result*) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, %Qubit*) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, i8*) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="custom" "required_num_qubits"="6" "required_num_results"="6" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
