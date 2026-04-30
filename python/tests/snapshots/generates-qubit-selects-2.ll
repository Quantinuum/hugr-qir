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

define dso_local void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(i8* null)
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 4 to %Qubit*), %Result* null)
  %0 = tail call i1 @__quantum__rt__read_result(%Result* null)
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 5 to %Qubit*), %Result* nonnull inttoptr (i64 1 to %Result*))
  %1 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 1 to %Result*))
  %"46_2.0" = zext i1 %0 to i64
  %2 = select i1 %0, i64 2, i64 1
  %"61_2.0" = select i1 %1, i64 %2, i64 %"46_2.0"
  br i1 %1, label %alloca_block.select.merge.dup.select.merge.dup, label %alloca_block.select.merge.dup1832.select.merge.dup1867

alloca_block.select.merge.dup.select.merge.dup:   ; preds = %alloca_block
  br i1 %0, label %alloca_block.select.merge.dup.select.merge.dup.select.merge.dup, label %alloca_block.select.merge.dup.select.merge.dup.select.merge.dup1851

alloca_block.select.merge.dup.select.merge.dup.select.merge.dup: ; preds = %alloca_block.select.merge.dup.select.merge.dup
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* null)
  %3 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 1 to %Qubit*))
  %4 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 2 to %Qubit*))
  %5 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 3 to %Qubit*))
  %6 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 5 to %Result*))
  br label %record_block

alloca_block.select.merge.dup.select.merge.dup.select.merge.dup1851: ; preds = %alloca_block.select.merge.dup.select.merge.dup
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 2 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* null)
  %7 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 1 to %Qubit*))
  %8 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 2 to %Qubit*))
  %9 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 3 to %Qubit*))
  %10 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 5 to %Result*))
  br label %record_block

alloca_block.select.merge.dup1832.select.merge.dup1867: ; preds = %alloca_block
  br i1 %0, label %alloca_block.select.merge.dup1832.select.merge.dup1867.select.merge.dup, label %alloca_block.select.merge.dup1832.select.merge.dup1867.select.merge.dup1882

alloca_block.select.merge.dup1832.select.merge.dup1867.select.merge.dup: ; preds = %alloca_block.select.merge.dup1832.select.merge.dup1867
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 1 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* null)
  %11 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 1 to %Qubit*))
  %12 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 2 to %Qubit*))
  %13 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 3 to %Qubit*))
  %14 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 5 to %Result*))
  br label %record_block

alloca_block.select.merge.dup1832.select.merge.dup1867.select.merge.dup1882: ; preds = %alloca_block.select.merge.dup1832.select.merge.dup1867
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 3 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* null)
  %15 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 1 to %Qubit*))
  %16 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 2 to %Qubit*))
  %17 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 3 to %Qubit*))
  %18 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 5 to %Result*))
  br label %record_block

record_block:                                     ; preds = %alloca_block.select.merge.dup1832.select.merge.dup1867.select.merge.dup1882, %alloca_block.select.merge.dup1832.select.merge.dup1867.select.merge.dup, %alloca_block.select.merge.dup.select.merge.dup.select.merge.dup1851, %alloca_block.select.merge.dup.select.merge.dup.select.merge.dup
  %phi.calluser1885 = phi i1 [ %10, %alloca_block.select.merge.dup.select.merge.dup.select.merge.dup1851 ], [ %6, %alloca_block.select.merge.dup.select.merge.dup.select.merge.dup ], [ %18, %alloca_block.select.merge.dup1832.select.merge.dup1867.select.merge.dup1882 ], [ %14, %alloca_block.select.merge.dup1832.select.merge.dup1867.select.merge.dup ]
  %phi.calluser1884 = phi i1 [ %9, %alloca_block.select.merge.dup.select.merge.dup.select.merge.dup1851 ], [ %5, %alloca_block.select.merge.dup.select.merge.dup.select.merge.dup ], [ %17, %alloca_block.select.merge.dup1832.select.merge.dup1867.select.merge.dup1882 ], [ %13, %alloca_block.select.merge.dup1832.select.merge.dup1867.select.merge.dup ]
  %phi.calluser1883 = phi i1 [ %8, %alloca_block.select.merge.dup.select.merge.dup.select.merge.dup1851 ], [ %4, %alloca_block.select.merge.dup.select.merge.dup.select.merge.dup ], [ %16, %alloca_block.select.merge.dup1832.select.merge.dup1867.select.merge.dup1882 ], [ %12, %alloca_block.select.merge.dup1832.select.merge.dup1867.select.merge.dup ]
  %phi.calluser = phi i1 [ %7, %alloca_block.select.merge.dup.select.merge.dup.select.merge.dup1851 ], [ %3, %alloca_block.select.merge.dup.select.merge.dup.select.merge.dup ], [ %15, %alloca_block.select.merge.dup1832.select.merge.dup1867.select.merge.dup1882 ], [ %11, %alloca_block.select.merge.dup1832.select.merge.dup1867.select.merge.dup ]
  call void @__quantum__rt__bool_record_output(i1 %0, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @0, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %1, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @1, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @2, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser1883, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @3, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser1884, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @4, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser1885, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @5, i64 0, i64 0))
  call void @__quantum__rt__int_record_output(i64 %"61_2.0", i8* getelementptr inbounds ([8 x i8], [8 x i8]* @6, i64 0, i64 0))
  br i1 %0, label %29, label %cond_exit_620

cond_336_case_1:                                  ; preds = %cond_exit_620, %30
  tail call void @__quantum__qis__mz__body(%Qubit* null, %Result* nonnull inttoptr (i64 6 to %Result*))
  %19 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 6 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 1 to %Qubit*), %Result* nonnull inttoptr (i64 7 to %Result*))
  %20 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 7 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 2 to %Qubit*), %Result* nonnull inttoptr (i64 8 to %Result*))
  %21 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 8 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 3 to %Qubit*), %Result* nonnull inttoptr (i64 9 to %Result*))
  %22 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 9 to %Result*))
  %"1071_0.0" = select i1 %19, i64 8, i64 0
  %"1106_0.0" = select i1 %20, i64 4, i64 0
  %"1141_0.0" = select i1 %21, i64 2, i64 0
  %"1176_0.0" = zext i1 %22 to i64
  %23 = or i64 %"1106_0.0", %"1071_0.0"
  %24 = or i64 %23, %"1141_0.0"
  %25 = or i64 %24, %"1176_0.0"
  %"1008_0.0" = zext i1 %21 to i64
  %26 = add nuw nsw i64 %"61_2.0", %"1008_0.0"
  call void @__quantum__rt__int_record_output(i64 %25, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @7, i64 0, i64 0))
  %Pivot1825 = icmp slt i64 %26, 1
  br i1 %Pivot1825, label %cond_704_case_1.sink.split.dup, label %NodeBlock

cond_704_case_1.sink.split.dup:                   ; preds = %cond_336_case_1
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 6 to %Qubit*))
  br label %cond_704_case_1

NodeBlock:                                        ; preds = %cond_336_case_1
  %Pivot = icmp slt i64 %26, 2
  br i1 %Pivot, label %cond_704_case_1.sink.split.dup1886, label %LeafBlock

LeafBlock:                                        ; preds = %NodeBlock
  %SwitchLeaf = icmp eq i64 %26, 2
  br i1 %SwitchLeaf, label %cond_704_case_1.sink.split.dup1887, label %cond_704_case_1

cond_704_case_1.sink.split.dup1886:               ; preds = %NodeBlock
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 7 to %Qubit*))
  br label %cond_704_case_1

cond_704_case_1:                                  ; preds = %LeafBlock, %cond_704_case_1.sink.split.dup1887, %cond_704_case_1.sink.split.dup1886, %cond_704_case_1.sink.split.dup
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 6 to %Qubit*), %Result* nonnull inttoptr (i64 10 to %Result*))
  %27 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 10 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 7 to %Qubit*), %Result* nonnull inttoptr (i64 11 to %Result*))
  %28 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 11 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %27, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @8, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %28, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @9, i64 0, i64 0))
  ret void

29:                                               ; preds = %record_block
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_exit_620

cond_exit_620:                                    ; preds = %record_block, %29
  br i1 %1, label %30, label %cond_336_case_1

30:                                               ; preds = %cond_exit_620
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  br label %cond_336_case_1

cond_704_case_1.sink.split.dup1887:               ; preds = %LeafBlock
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 6 to %Qubit*))
  br label %cond_704_case_1
}

declare void @__quantum__qis__mz__body(%Qubit*, %Result* writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(%Result* readonly) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, %Qubit*) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, i8*) local_unnamed_addr

declare void @__quantum__qis__reset__body(%Qubit*) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, i8*) local_unnamed_addr

declare void @__quantum__rt__initialize(i8*) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="8" "required_num_results"="12" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
