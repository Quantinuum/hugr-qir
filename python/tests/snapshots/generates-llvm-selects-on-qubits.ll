; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

@0 = private unnamed_addr constant [3 x i8] c"c0\00", align 1
@1 = private unnamed_addr constant [3 x i8] c"c1\00", align 1
@2 = private unnamed_addr constant [3 x i8] c"q0\00", align 1
@3 = private unnamed_addr constant [3 x i8] c"q1\00", align 1
@4 = private unnamed_addr constant [3 x i8] c"q2\00", align 1
@5 = private unnamed_addr constant [3 x i8] c"q3\00", align 1
@6 = private unnamed_addr constant [8 x i8] c"c0 + c1\00", align 1
@7 = private unnamed_addr constant [18 x i8] c"2nd result as int\00", align 1
@8 = private unnamed_addr constant [3 x i8] c"q4\00", align 1
@9 = private unnamed_addr constant [3 x i8] c"q5\00", align 1

define dso_local void @__hugr__.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 4 to %Qubit*), %Result* null)
  %0 = tail call i1 @__quantum__qis__read_result__body(%Result* null)
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 5 to %Qubit*), %Result* nonnull inttoptr (i64 1 to %Result*))
  %1 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 1 to %Result*))
  %"46_2.0" = zext i1 %0 to i64
  %2 = select i1 %0, i64 2, i64 1
  %"61_2.0" = select i1 %1, i64 %2, i64 %"46_2.0"
  br i1 %1, label %alloca_blockselect.merge_dupselect.merge_dup, label %alloca_blockselect.merge_dup1758select.merge_dup1793

alloca_blockselect.merge_dupselect.merge_dup:     ; preds = %alloca_block
  br i1 %0, label %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup, label %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup1777

alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup: ; preds = %alloca_blockselect.merge_dupselect.merge_dup
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* null)
  %3 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 1 to %Qubit*))
  %4 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 2 to %Qubit*))
  %5 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 3 to %Qubit*))
  %6 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 5 to %Result*))
  br label %record_block

alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup1777: ; preds = %alloca_blockselect.merge_dupselect.merge_dup
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 2 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* null)
  %7 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 1 to %Qubit*))
  %8 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 2 to %Qubit*))
  %9 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 3 to %Qubit*))
  %10 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 5 to %Result*))
  br label %record_block

alloca_blockselect.merge_dup1758select.merge_dup1793: ; preds = %alloca_block
  br i1 %0, label %alloca_blockselect.merge_dup1758select.merge_dup1793select.merge_dup, label %alloca_blockselect.merge_dup1758select.merge_dup1793select.merge_dup1808

alloca_blockselect.merge_dup1758select.merge_dup1793select.merge_dup: ; preds = %alloca_blockselect.merge_dup1758select.merge_dup1793
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 1 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* null)
  %11 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 1 to %Qubit*))
  %12 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 2 to %Qubit*))
  %13 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 3 to %Qubit*))
  %14 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 5 to %Result*))
  br label %record_block

alloca_blockselect.merge_dup1758select.merge_dup1793select.merge_dup1808: ; preds = %alloca_blockselect.merge_dup1758select.merge_dup1793
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 3 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* null)
  %15 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 1 to %Qubit*))
  %16 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 2 to %Qubit*))
  %17 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 3 to %Qubit*))
  %18 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 5 to %Result*))
  br label %record_block

record_block:                                     ; preds = %alloca_blockselect.merge_dup1758select.merge_dup1793select.merge_dup1808, %alloca_blockselect.merge_dup1758select.merge_dup1793select.merge_dup, %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup1777, %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup
  %phi.calluser1811 = phi i1 [ %6, %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup ], [ %10, %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup1777 ], [ %14, %alloca_blockselect.merge_dup1758select.merge_dup1793select.merge_dup ], [ %18, %alloca_blockselect.merge_dup1758select.merge_dup1793select.merge_dup1808 ]
  %phi.calluser1810 = phi i1 [ %5, %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup ], [ %9, %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup1777 ], [ %13, %alloca_blockselect.merge_dup1758select.merge_dup1793select.merge_dup ], [ %17, %alloca_blockselect.merge_dup1758select.merge_dup1793select.merge_dup1808 ]
  %phi.calluser1809 = phi i1 [ %4, %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup ], [ %8, %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup1777 ], [ %12, %alloca_blockselect.merge_dup1758select.merge_dup1793select.merge_dup ], [ %16, %alloca_blockselect.merge_dup1758select.merge_dup1793select.merge_dup1808 ]
  %phi.calluser = phi i1 [ %3, %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup ], [ %7, %alloca_blockselect.merge_dupselect.merge_dupselect.merge_dup1777 ], [ %11, %alloca_blockselect.merge_dup1758select.merge_dup1793select.merge_dup ], [ %15, %alloca_blockselect.merge_dup1758select.merge_dup1793select.merge_dup1808 ]
  call void @__quantum__rt__bool_record_output(i1 %0, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @0, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %1, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @1, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @2, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser1809, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @3, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser1810, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @4, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser1811, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @5, i64 0, i64 0))
  call void @__quantum__rt__int_record_output(i64 %"61_2.0", i8* getelementptr inbounds ([8 x i8], [8 x i8]* @6, i64 0, i64 0))
  br i1 %0, label %30, label %cond_exit_617

cond_646_case_0:                                  ; preds = %cond_exit_617, %31
  tail call void @__quantum__qis__mz__body(%Qubit* null, %Result* nonnull inttoptr (i64 6 to %Result*))
  %19 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 6 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 1 to %Qubit*), %Result* nonnull inttoptr (i64 7 to %Result*))
  %20 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 7 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 2 to %Qubit*), %Result* nonnull inttoptr (i64 8 to %Result*))
  %21 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 8 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 3 to %Qubit*), %Result* nonnull inttoptr (i64 9 to %Result*))
  %22 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 9 to %Result*))
  %"1018_0.0" = select i1 %19, i64 8, i64 0
  %"1053_0.0" = select i1 %20, i64 4, i64 0
  %"1088_0.0" = select i1 %21, i64 2, i64 0
  %"1123_0.0" = zext i1 %22 to i64
  %23 = or i64 %"1053_0.0", %"1018_0.0"
  %24 = or i64 %23, %"1088_0.0"
  %25 = or i64 %24, %"1123_0.0"
  %Pivot = icmp ult i64 %"61_2.0", 2
  call void @__quantum__rt__int_record_output(i64 %25, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @7, i64 0, i64 0))
  br i1 %Pivot, label %LeafBlock, label %cond_686_case_1.sink.split_dup1815

LeafBlock:                                        ; preds = %cond_646_case_0
  %SwitchLeaf = icmp eq i64 %"61_2.0", 1
  br i1 %SwitchLeaf, label %cond_686_case_1.sink.split_dup, label %cond_686_case_1.sink.split_dup1814

cond_686_case_1.sink.split_dup:                   ; preds = %LeafBlock
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 7 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 6 to %Qubit*), %Result* inttoptr (i64 10 to %Result*))
  %26 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 10 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 7 to %Qubit*), %Result* inttoptr (i64 11 to %Result*))
  %27 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 11 to %Result*))
  br label %record_block1753

cond_686_case_1.sink.split_dup1814:               ; preds = %LeafBlock
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 6 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 6 to %Qubit*), %Result* inttoptr (i64 10 to %Result*))
  %28 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 10 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 7 to %Qubit*), %Result* inttoptr (i64 11 to %Result*))
  %29 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 11 to %Result*))
  br label %record_block1753

record_block1753:                                 ; preds = %cond_686_case_1.sink.split_dup1815, %cond_686_case_1.sink.split_dup1814, %cond_686_case_1.sink.split_dup
  %phi.calluser1817 = phi i1 [ %33, %cond_686_case_1.sink.split_dup1815 ], [ %27, %cond_686_case_1.sink.split_dup ], [ %29, %cond_686_case_1.sink.split_dup1814 ]
  %phi.calluser1816 = phi i1 [ %32, %cond_686_case_1.sink.split_dup1815 ], [ %26, %cond_686_case_1.sink.split_dup ], [ %28, %cond_686_case_1.sink.split_dup1814 ]
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser1816, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @8, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser1817, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @9, i64 0, i64 0))
  ret void

30:                                               ; preds = %record_block
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_exit_617

cond_exit_617:                                    ; preds = %record_block, %30
  br i1 %1, label %31, label %cond_646_case_0

31:                                               ; preds = %cond_exit_617
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  br label %cond_646_case_0

cond_686_case_1.sink.split_dup1815:               ; preds = %cond_646_case_0
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 6 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 6 to %Qubit*), %Result* inttoptr (i64 10 to %Result*))
  %32 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 10 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 7 to %Qubit*), %Result* inttoptr (i64 11 to %Result*))
  %33 = call i1 @__quantum__qis__read_result__body(%Result* inttoptr (i64 11 to %Result*))
  br label %record_block1753
}

declare void @__quantum__qis__mz__body(%Qubit*, %Result*) local_unnamed_addr

declare i1 @__quantum__qis__read_result__body(%Result*) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, %Qubit*) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, i8*) local_unnamed_addr

declare void @__quantum__qis__reset__body(%Qubit*) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, i8*) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="custom" "required_num_qubits"="8" "required_num_results"="12" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
