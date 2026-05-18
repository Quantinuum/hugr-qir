; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

@0 = private unnamed_addr constant [2 x i8] c"0\00", align 1
@1 = private unnamed_addr constant [2 x i8] c"1\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"0.0.0", section ",qir_generator"

define dso_local void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(i8* null)
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 2 to %Qubit*), %Result* null)
  %0 = tail call i1 @__quantum__rt__read_result(%Result* null)
  br i1 %0, label %bb8, label %cond_391_case_0

cond_391_case_0:                                  ; preds = %alloca_block, %bb8
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 3 to %Qubit*), %Result* nonnull inttoptr (i64 1 to %Result*))
  %1 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 1 to %Result*))
  br i1 %1, label %bb, label %cond_391_case_0.1

bb:                                               ; preds = %cond_391_case_0
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_391_case_0.1

cond_391_case_0.1:                                ; preds = %bb, %cond_391_case_0
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 4 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 4 to %Qubit*), %Result* nonnull inttoptr (i64 2 to %Result*))
  %2 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 2 to %Result*))
  br i1 %2, label %bb0, label %cond_391_case_0.2

bb0:                                              ; preds = %cond_391_case_0.1
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_391_case_0.2

cond_391_case_0.2:                                ; preds = %bb0, %cond_391_case_0.1
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 5 to %Qubit*), %Result* nonnull inttoptr (i64 3 to %Result*))
  %3 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 3 to %Result*))
  br i1 %3, label %bb1, label %cond_391_case_0.3

bb1:                                              ; preds = %cond_391_case_0.2
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_391_case_0.3

cond_391_case_0.3:                                ; preds = %bb1, %cond_391_case_0.2
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 6 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 6 to %Qubit*), %Result* nonnull inttoptr (i64 4 to %Result*))
  %4 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 4 to %Result*))
  br i1 %4, label %bb2, label %cond_391_case_0.4

bb2:                                              ; preds = %cond_391_case_0.3
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_391_case_0.4

cond_391_case_0.4:                                ; preds = %bb2, %cond_391_case_0.3
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 7 to %Qubit*), %Result* nonnull inttoptr (i64 5 to %Result*))
  %5 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 5 to %Result*))
  br i1 %5, label %bb3, label %cond_391_case_0.5

bb3:                                              ; preds = %cond_391_case_0.4
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_391_case_0.5

cond_391_case_0.5:                                ; preds = %bb3, %cond_391_case_0.4
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 8 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 8 to %Qubit*), %Result* nonnull inttoptr (i64 6 to %Result*))
  %6 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 6 to %Result*))
  br i1 %6, label %bb4, label %cond_391_case_0.6

bb4:                                              ; preds = %cond_391_case_0.5
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_391_case_0.6

cond_391_case_0.6:                                ; preds = %bb4, %cond_391_case_0.5
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 9 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 9 to %Qubit*), %Result* nonnull inttoptr (i64 7 to %Result*))
  %7 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 7 to %Result*))
  br i1 %7, label %bb5, label %cond_391_case_0.7

bb5:                                              ; preds = %cond_391_case_0.6
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_391_case_0.7

cond_391_case_0.7:                                ; preds = %bb5, %cond_391_case_0.6
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 10 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 10 to %Qubit*), %Result* nonnull inttoptr (i64 8 to %Result*))
  %8 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 8 to %Result*))
  br i1 %8, label %bb6, label %cond_391_case_0.8

bb6:                                              ; preds = %cond_391_case_0.7
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_391_case_0.8

cond_391_case_0.8:                                ; preds = %bb6, %cond_391_case_0.7
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 11 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 11 to %Qubit*), %Result* nonnull inttoptr (i64 9 to %Result*))
  %9 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 9 to %Result*))
  br i1 %9, label %bb7, label %cond_391_case_0.9

bb7:                                              ; preds = %cond_391_case_0.8
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_391_case_0.9

cond_391_case_0.9:                                ; preds = %bb7, %cond_391_case_0.8
  tail call void @__quantum__qis__mz__body(%Qubit* null, %Result* nonnull inttoptr (i64 10 to %Result*))
  %10 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 10 to %Result*))
  tail call void @__quantum__rt__bool_record_output(i1 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @0, i64 0, i64 0))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 1 to %Qubit*), %Result* nonnull inttoptr (i64 11 to %Result*))
  %11 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 11 to %Result*))
  tail call void @__quantum__rt__bool_record_output(i1 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @1, i64 0, i64 0))
  ret void

bb8:                                              ; preds = %alloca_block
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_391_case_0
}

declare void @__quantum__qis__mz__body(%Qubit*, %Result* writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(%Result* readonly) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, i8*) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, %Qubit*) local_unnamed_addr

declare void @__quantum__rt__initialize(i8*) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="12" "required_num_results"="12" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
