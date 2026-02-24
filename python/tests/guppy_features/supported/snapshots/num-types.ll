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
@4 = private unnamed_addr constant [15 x i8] c"big_endian_res\00", align 1
@5 = private unnamed_addr constant [11 x i8] c"random_sum\00", align 1
@6 = private unnamed_addr constant [8 x i8] c"int_res\00", align 1

define dso_local void @__hugr__.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x3FF41B2F769CF0E0, %Qubit* null)
  tail call void @__quantum__qis__mz__body(%Qubit* null, %Result* null)
  %0 = tail call i1 @__quantum__qis__read_result__body(%Result* null)
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 1 to %Qubit*), %Result* nonnull inttoptr (i64 1 to %Result*))
  %1 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 1 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 2 to %Qubit*), %Result* nonnull inttoptr (i64 2 to %Result*))
  %2 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 2 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 3 to %Qubit*), %Result* nonnull inttoptr (i64 3 to %Result*))
  %3 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 3 to %Result*))
  %"751_0.0" = select i1 %0, i64 8, i64 0
  %"786_0.0" = select i1 %1, i64 4, i64 0
  %"821_0.0" = select i1 %2, i64 2, i64 0
  %"856_0.0" = zext i1 %3 to i64
  %4 = or i64 %"786_0.0", %"751_0.0"
  %5 = or i64 %4, %"821_0.0"
  %6 = or i64 %5, %"856_0.0"
  tail call void @__quantum__rt__bool_record_output(i1 %0, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @0, i64 0, i64 0))
  tail call void @__quantum__rt__bool_record_output(i1 %1, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @1, i64 0, i64 0))
  tail call void @__quantum__rt__bool_record_output(i1 %2, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @2, i64 0, i64 0))
  tail call void @__quantum__rt__bool_record_output(i1 %3, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @3, i64 0, i64 0))
  tail call void @__quantum__rt__int_record_output(i64 %6, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @4, i64 0, i64 0))
  %"0489.0" = select i1 %0, i64 1, i64 -1
  %"0517.0" = select i1 %1, i64 1, i64 -1
  %"0545.0" = select i1 %2, i64 1, i64 -1
  %"0573.0" = select i1 %3, i64 1, i64 -1
  %7 = add nsw i64 %"0517.0", %"0489.0"
  %8 = add nsw i64 %7, %"0545.0"
  %9 = add nsw i64 %8, %"0573.0"
  %10 = mul nsw i64 %9, %9
  %11 = sub nsw i64 10, %10
  tail call void @__quantum__rt__int_record_output(i64 %9, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @5, i64 0, i64 0))
  tail call void @__quantum__rt__int_record_output(i64 %11, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @6, i64 0, i64 0))
  ret void
}

declare void @__quantum__qis__phasedx__body(double, double, %Qubit*) local_unnamed_addr

declare void @__quantum__qis__rz__body(double, %Qubit*) local_unnamed_addr

declare void @__quantum__qis__mz__body(%Qubit*, %Result*) local_unnamed_addr

declare i1 @__quantum__qis__read_result__body(%Result*) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, i8*) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, i8*) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="custom" "required_num_qubits"="4" "required_num_results"="4" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
