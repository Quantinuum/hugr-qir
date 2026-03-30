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
  tail call void @__quantum__rt__bool_record_output(i1 %0, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @0, i64 0, i64 0))
  tail call void @__quantum__rt__bool_record_output(i1 %1, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @1, i64 0, i64 0))
  %"46_2.0" = zext i1 %0 to i64
  %2 = select i1 %0, i64 2, i64 1
  %"61_2.0" = select i1 %1, i64 %2, i64 %"46_2.0"
  %spec.select = select i1 %1, %Qubit* null, %Qubit* inttoptr (i64 1 to %Qubit*)
  %. = select i1 %1, %Qubit* inttoptr (i64 2 to %Qubit*), %Qubit* inttoptr (i64 3 to %Qubit*)
  %.sink1821 = select i1 %0, %Qubit* %spec.select, %Qubit* %.
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* %.sink1821)
  tail call void @__quantum__qis__mz__body(%Qubit* null, %Result* nonnull inttoptr (i64 2 to %Result*))
  tail call void @__quantum__qis__reset__body(%Qubit* null)
  %3 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 2 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 1 to %Qubit*), %Result* nonnull inttoptr (i64 3 to %Result*))
  tail call void @__quantum__qis__reset__body(%Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  %4 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 3 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 2 to %Qubit*), %Result* nonnull inttoptr (i64 4 to %Result*))
  tail call void @__quantum__qis__reset__body(%Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  %5 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 4 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 3 to %Qubit*), %Result* nonnull inttoptr (i64 5 to %Result*))
  tail call void @__quantum__qis__reset__body(%Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  %6 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 5 to %Result*))
  tail call void @__quantum__rt__bool_record_output(i1 %3, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @2, i64 0, i64 0))
  tail call void @__quantum__rt__bool_record_output(i1 %4, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @3, i64 0, i64 0))
  tail call void @__quantum__rt__bool_record_output(i1 %5, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @4, i64 0, i64 0))
  tail call void @__quantum__rt__bool_record_output(i1 %6, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @5, i64 0, i64 0))
  tail call void @__quantum__rt__int_record_output(i64 %"61_2.0", i8* getelementptr inbounds ([8 x i8], [8 x i8]* @6, i64 0, i64 0))
  br i1 %0, label %17, label %cond_exit_620

cond_336_case_1:                                  ; preds = %cond_exit_620, %18
  tail call void @__quantum__qis__mz__body(%Qubit* null, %Result* nonnull inttoptr (i64 6 to %Result*))
  %7 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 6 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 1 to %Qubit*), %Result* nonnull inttoptr (i64 7 to %Result*))
  %8 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 7 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 2 to %Qubit*), %Result* nonnull inttoptr (i64 8 to %Result*))
  %9 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 8 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 3 to %Qubit*), %Result* nonnull inttoptr (i64 9 to %Result*))
  %10 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 9 to %Result*))
  %"1071_0.0" = select i1 %7, i64 8, i64 0
  %"1106_0.0" = select i1 %8, i64 4, i64 0
  %"1141_0.0" = select i1 %9, i64 2, i64 0
  %"1176_0.0" = zext i1 %10 to i64
  %11 = or i64 %"1106_0.0", %"1071_0.0"
  %12 = or i64 %11, %"1141_0.0"
  %13 = or i64 %12, %"1176_0.0"
  tail call void @__quantum__rt__int_record_output(i64 %13, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @7, i64 0, i64 0))
  %"1008_0.0" = zext i1 %9 to i64
  %14 = add nuw nsw i64 %"61_2.0", %"1008_0.0"
  br label %NodeBlock1824

NodeBlock1824:                                    ; preds = %cond_336_case_1
  %Pivot1825 = icmp slt i64 %14, 1
  br i1 %Pivot1825, label %cond_704_case_1.sink.split, label %NodeBlock

NodeBlock:                                        ; preds = %NodeBlock1824
  %Pivot = icmp slt i64 %14, 2
  br i1 %Pivot, label %cond_704_case_1.sink.split.fold.split, label %LeafBlock

LeafBlock:                                        ; preds = %NodeBlock
  %SwitchLeaf = icmp eq i64 %14, 2
  br i1 %SwitchLeaf, label %19, label %NewDefault

cond_704_case_1.sink.split.fold.split:            ; preds = %NodeBlock
  br label %cond_704_case_1.sink.split

cond_704_case_1.sink.split:                       ; preds = %NodeBlock1824, %cond_704_case_1.sink.split.fold.split, %19
  %.sink = phi %Qubit* [ inttoptr (i64 6 to %Qubit*), %19 ], [ inttoptr (i64 6 to %Qubit*), %NodeBlock1824 ], [ inttoptr (i64 7 to %Qubit*), %cond_704_case_1.sink.split.fold.split ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull %.sink)
  br label %cond_704_case_1

NewDefault:                                       ; preds = %LeafBlock
  br label %cond_704_case_1

cond_704_case_1:                                  ; preds = %NewDefault, %cond_704_case_1.sink.split
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 6 to %Qubit*), %Result* nonnull inttoptr (i64 10 to %Result*))
  %15 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 10 to %Result*))
  tail call void @__quantum__rt__bool_record_output(i1 %15, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @8, i64 0, i64 0))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 7 to %Qubit*), %Result* nonnull inttoptr (i64 11 to %Result*))
  %16 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 11 to %Result*))
  tail call void @__quantum__rt__bool_record_output(i1 %16, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @9, i64 0, i64 0))
  ret void

17:                                               ; preds = %alloca_block
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_exit_620

cond_exit_620:                                    ; preds = %alloca_block, %17
  br i1 %1, label %18, label %cond_336_case_1

18:                                               ; preds = %cond_exit_620
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  br label %cond_336_case_1

19:                                               ; preds = %LeafBlock
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  br label %cond_704_case_1.sink.split
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
