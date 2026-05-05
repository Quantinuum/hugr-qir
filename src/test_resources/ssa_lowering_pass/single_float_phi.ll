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
@10 = private unnamed_addr constant [3 x i8] c"q6\00", align 1

define dso_local void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 4 to %Qubit*), %Result* null)
  %0 = tail call i1 @__quantum__qis__read_result__body(%Result* null)
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 5 to %Qubit*), %Result* nonnull inttoptr (i64 1 to %Result*))
  %1 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 1 to %Result*))
  %"48_2.0" = zext i1 %0 to i64
  %2 = select i1 %0, i64 2, i64 1
  %"74_2.0" = select i1 %1, i64 %2, i64 %"48_2.0"
  br i1 %1, label %alloca_block.dup2105, label %alloca_block.dup2109

alloca_block.dup2105:                             ; preds = %alloca_block
  br i1 %0, label %alloca_block.dup2112, label %alloca_block.dup2119

alloca_block.dup2119:                             ; preds = %alloca_block.dup2105
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 2 to %Qubit*))
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
  br label %alloca_block.record

alloca_block.dup2112:                             ; preds = %alloca_block.dup2105
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
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
  br label %alloca_block.record

alloca_block.dup2109:                             ; preds = %alloca_block
  br i1 %0, label %alloca_block.dup2113, label %alloca_block.dup2120

alloca_block.dup2120:                             ; preds = %alloca_block.dup2109
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 3 to %Qubit*))
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
  br label %alloca_block.record

alloca_block.dup2113:                             ; preds = %alloca_block.dup2109
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 1 to %Qubit*))
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
  br label %alloca_block.record

alloca_block.record:                              ; preds = %alloca_block.dup2120, %alloca_block.dup2119, %alloca_block.dup2113, %alloca_block.dup2112
  %phi.edge = phi i1 [ %10, %alloca_block.dup2112 ], [ %18, %alloca_block.dup2113 ], [ %6, %alloca_block.dup2119 ], [ %14, %alloca_block.dup2120 ]
  %phi.edge2122 = phi i1 [ %9, %alloca_block.dup2112 ], [ %17, %alloca_block.dup2113 ], [ %5, %alloca_block.dup2119 ], [ %13, %alloca_block.dup2120 ]
  %phi.edge2123 = phi i1 [ %8, %alloca_block.dup2112 ], [ %16, %alloca_block.dup2113 ], [ %4, %alloca_block.dup2119 ], [ %12, %alloca_block.dup2120 ]
  %phi.edge2124 = phi i1 [ %7, %alloca_block.dup2112 ], [ %15, %alloca_block.dup2113 ], [ %3, %alloca_block.dup2119 ], [ %11, %alloca_block.dup2120 ]
  call void @__quantum__rt__bool_record_output(i1 %0, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @0, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %1, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @1, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.edge2124, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @2, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.edge2123, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @3, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.edge2122, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @4, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.edge, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @5, i64 0, i64 0))
  call void @__quantum__rt__int_record_output(i64 %"74_2.0", i8* getelementptr inbounds ([8 x i8], [8 x i8]* @6, i64 0, i64 0))
  br i1 %0, label %27, label %cond_exit_176

cond_374_case_1:                                  ; preds = %cond_exit_176, %28
  %"198_1.0" = phi double [ 0x3FE41B2F769CF0E0, %28 ], [ 0x3FEE28C731EB6950, %cond_exit_176 ]
  tail call void @__quantum__qis__mz__body(%Qubit* null, %Result* nonnull inttoptr (i64 6 to %Result*))
  %19 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 6 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 1 to %Qubit*), %Result* nonnull inttoptr (i64 7 to %Result*))
  %20 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 7 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 2 to %Qubit*), %Result* nonnull inttoptr (i64 8 to %Result*))
  %21 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 8 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 3 to %Qubit*), %Result* nonnull inttoptr (i64 9 to %Result*))
  %22 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 9 to %Result*))
  %"1162_0.0" = select i1 %19, i64 8, i64 0
  %"1197_0.0" = select i1 %20, i64 4, i64 0
  %"1232_0.0" = select i1 %21, i64 2, i64 0
  %"1267_0.0" = zext i1 %22 to i64
  %23 = or i64 %"1197_0.0", %"1162_0.0"
  %24 = or i64 %23, %"1232_0.0"
  %25 = or i64 %24, %"1267_0.0"
  %"1077_0.0" = zext i1 %21 to i64
  %26 = add nuw nsw i64 %"74_2.0", %"1077_0.0"
  call void @__quantum__rt__int_record_output(i64 %25, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @7, i64 0, i64 0))
  %Pivot2093 = icmp slt i64 %26, 1
  br i1 %Pivot2093, label %cond_759_case_1.sink.split.dup, label %NodeBlock

cond_759_case_1.sink.split.dup:                   ; preds = %cond_374_case_1
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 6 to %Qubit*))
  br label %cond_759_case_1

NodeBlock:                                        ; preds = %cond_374_case_1
  %Pivot = icmp slt i64 %26, 2
  br i1 %Pivot, label %cond_759_case_1.sink.split.dup2126, label %LeafBlock

LeafBlock:                                        ; preds = %NodeBlock
  %SwitchLeaf = icmp eq i64 %26, 2
  br i1 %SwitchLeaf, label %cond_759_case_1.sink.split.dup2125, label %cond_759_case_1

27:                                               ; preds = %alloca_block.record
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_exit_176

cond_exit_176:                                    ; preds = %alloca_block.record, %27
  br i1 %1, label %28, label %cond_374_case_1

28:                                               ; preds = %cond_exit_176
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  br label %cond_374_case_1

cond_759_case_1.sink.split.dup2125:               ; preds = %LeafBlock
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 6 to %Qubit*))
  br label %cond_759_case_1

cond_759_case_1.sink.split.dup2126:               ; preds = %NodeBlock
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 7 to %Qubit*))
  br label %cond_759_case_1

cond_759_case_1:                                  ; preds = %LeafBlock, %cond_759_case_1.sink.split.dup2126, %cond_759_case_1.sink.split.dup2125, %cond_759_case_1.sink.split.dup
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 6 to %Qubit*), %Result* nonnull inttoptr (i64 10 to %Result*))
  %29 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 10 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 7 to %Qubit*), %Result* nonnull inttoptr (i64 11 to %Result*))
  %30 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 11 to %Result*))
  tail call void @__quantum__qis__phasedx__body(double %"198_1.0", double 0.000000e+00, %Qubit* nonnull inttoptr (i64 8 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 8 to %Qubit*), %Result* nonnull inttoptr (i64 12 to %Result*))
  %31 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 12 to %Result*))
  call void @__quantum__rt__bool_record_output(i1 %29, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @8, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %30, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @9, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %31, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @10, i64 0, i64 0))
  ret void
}

declare void @__quantum__qis__mz__body(%Qubit*, %Result*) local_unnamed_addr

declare i1 @__quantum__qis__read_result__body(%Result*) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, %Qubit*) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, i8*) local_unnamed_addr

declare void @__quantum__qis__reset__body(%Qubit*) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, i8*) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="custom" "required_num_qubits"="9" "required_num_results"="13" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
