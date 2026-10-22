; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [10 x i8] c"c0___BOOL\00", align 1
@1 = private unnamed_addr constant [10 x i8] c"c1___BOOL\00", align 1
@2 = private unnamed_addr constant [10 x i8] c"q0___BOOL\00", align 1
@3 = private unnamed_addr constant [10 x i8] c"q1___BOOL\00", align 1
@4 = private unnamed_addr constant [10 x i8] c"q2___BOOL\00", align 1
@5 = private unnamed_addr constant [10 x i8] c"q3___BOOL\00", align 1
@6 = private unnamed_addr constant [14 x i8] c"c0 + c1___INT\00", align 1
@7 = private unnamed_addr constant [24 x i8] c"2nd result as int___INT\00", align 1
@8 = private unnamed_addr constant [10 x i8] c"q4___BOOL\00", align 1
@9 = private unnamed_addr constant [10 x i8] c"q5___BOOL\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 4 to ptr), ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 1 to ptr))
  %1 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 1 to ptr))
  %"39_2.0" = zext i1 %0 to i64
  %2 = select i1 %0, i64 2, i64 1
  %"55_2.0" = select i1 %1, i64 %2, i64 %"39_2.0"
  br i1 %1, label %alloca_block.dup1006, label %alloca_block.dup1008

alloca_block.dup1006:                             ; preds = %alloca_block
  br i1 %0, label %alloca_block.dup1012, label %alloca_block.dup1024

alloca_block.dup1024:                             ; preds = %alloca_block.dup1006
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %3 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %4 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %5 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %6 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %bb0

alloca_block.dup1012:                             ; preds = %alloca_block.dup1006
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %7 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %8 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %9 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %10 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %bb

alloca_block.dup1008:                             ; preds = %alloca_block
  br i1 %0, label %alloca_block.dup1013, label %alloca_block.dup1025

alloca_block.dup1025:                             ; preds = %alloca_block.dup1008
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %11 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %12 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %13 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %14 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %bb0

alloca_block.dup1013:                             ; preds = %alloca_block.dup1008
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %15 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %16 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %17 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %18 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %bb

bb:                                               ; preds = %alloca_block.dup1013, %alloca_block.dup1012
  %phi.edge1030 = phi i1 [ %10, %alloca_block.dup1012 ], [ %18, %alloca_block.dup1013 ]
  %phi.edge1031 = phi i1 [ %9, %alloca_block.dup1012 ], [ %17, %alloca_block.dup1013 ]
  %phi.edge1032 = phi i1 [ %8, %alloca_block.dup1012 ], [ %16, %alloca_block.dup1013 ]
  %phi.edge1033 = phi i1 [ %7, %alloca_block.dup1012 ], [ %15, %alloca_block.dup1013 ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  br label %bb0

bb0:                                              ; preds = %alloca_block.dup1025, %alloca_block.dup1024, %bb
  %phi.edge = phi i1 [ %phi.edge1030, %bb ], [ %6, %alloca_block.dup1024 ], [ %14, %alloca_block.dup1025 ]
  %phi.edge1027 = phi i1 [ %phi.edge1031, %bb ], [ %5, %alloca_block.dup1024 ], [ %13, %alloca_block.dup1025 ]
  %phi.edge1028 = phi i1 [ %phi.edge1032, %bb ], [ %4, %alloca_block.dup1024 ], [ %12, %alloca_block.dup1025 ]
  %phi.edge1029 = phi i1 [ %phi.edge1033, %bb ], [ %3, %alloca_block.dup1024 ], [ %11, %alloca_block.dup1025 ]
  br i1 %1, label %bb1, label %cond_exit_163

bb1:                                              ; preds = %bb0
  %phi.calluser.edge996 = phi i1 [ %phi.edge, %bb0 ]
  %phi.calluser.edge984 = phi i1 [ %phi.edge1027, %bb0 ]
  %phi.calluser.edge972 = phi i1 [ %phi.edge1028, %bb0 ]
  %phi.calluser.edge960 = phi i1 [ %phi.edge1029, %bb0 ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 1 to ptr))
  br label %cond_exit_163

cond_exit_163:                                    ; preds = %bb0, %bb1
  %phi.calluser.edge993 = phi i1 [ %phi.edge, %bb0 ], [ %phi.calluser.edge996, %bb1 ]
  %phi.calluser.edge981 = phi i1 [ %phi.edge1027, %bb0 ], [ %phi.calluser.edge984, %bb1 ]
  %phi.calluser.edge969 = phi i1 [ %phi.edge1028, %bb0 ], [ %phi.calluser.edge972, %bb1 ]
  %phi.calluser.edge957 = phi i1 [ %phi.edge1029, %bb0 ], [ %phi.calluser.edge960, %bb1 ]
  tail call void @__quantum__qis__mz__body(ptr null, ptr nonnull inttoptr (i64 6 to ptr))
  %19 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 7 to ptr))
  %20 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 8 to ptr))
  %21 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  %22 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 9 to ptr))
  %. = zext i1 %22 to i64
  %"0617.0" = select i1 %21, i64 2, i64 0
  %"0631.0" = zext i1 %21 to i64
  %23 = add nuw nsw i64 %"55_2.0", %"0631.0"
  %"0661.0" = select i1 %20, i64 4, i64 0
  %"0676.0" = select i1 %19, i64 8, i64 0
  %24 = or disjoint i64 %"0661.0", %"0676.0"
  %25 = or disjoint i64 %24, %"0617.0"
  %26 = or disjoint i64 %25, %.
  %Pivot949 = icmp slt i64 %23, 1
  br i1 %Pivot949, label %.sink.split.dup1035, label %NodeBlock

.sink.split.dup1035:                              ; preds = %cond_exit_163
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb2

NodeBlock:                                        ; preds = %cond_exit_163
  %phi.calluser.edge991 = phi i1 [ %phi.calluser.edge993, %cond_exit_163 ]
  %phi.calluser.edge979 = phi i1 [ %phi.calluser.edge981, %cond_exit_163 ]
  %phi.calluser.edge967 = phi i1 [ %phi.calluser.edge969, %cond_exit_163 ]
  %phi.calluser.edge955 = phi i1 [ %phi.calluser.edge957, %cond_exit_163 ]
  %Pivot = icmp slt i64 %23, 2
  br i1 %Pivot, label %.sink.split.dup1034, label %LeafBlock

LeafBlock:                                        ; preds = %NodeBlock
  %phi.calluser.edge990 = phi i1 [ %phi.calluser.edge991, %NodeBlock ]
  %phi.calluser.edge978 = phi i1 [ %phi.calluser.edge979, %NodeBlock ]
  %phi.calluser.edge966 = phi i1 [ %phi.calluser.edge967, %NodeBlock ]
  %phi.calluser.edge954 = phi i1 [ %phi.calluser.edge955, %NodeBlock ]
  %SwitchLeaf = icmp eq i64 %23, 2
  br i1 %SwitchLeaf, label %.sink.split.dup, label %bb2

.sink.split.dup:                                  ; preds = %LeafBlock
  %phi.calluser.edge989 = phi i1 [ %phi.calluser.edge990, %LeafBlock ]
  %phi.calluser.edge977 = phi i1 [ %phi.calluser.edge978, %LeafBlock ]
  %phi.calluser.edge965 = phi i1 [ %phi.calluser.edge966, %LeafBlock ]
  %phi.calluser.edge953 = phi i1 [ %phi.calluser.edge954, %LeafBlock ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb2

.sink.split.dup1034:                              ; preds = %NodeBlock
  %phi.calluser.edge997 = phi i1 [ %phi.calluser.edge991, %NodeBlock ]
  %phi.calluser.edge985 = phi i1 [ %phi.calluser.edge979, %NodeBlock ]
  %phi.calluser.edge973 = phi i1 [ %phi.calluser.edge967, %NodeBlock ]
  %phi.calluser.edge961 = phi i1 [ %phi.calluser.edge955, %NodeBlock ]
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  br label %bb2

bb2:                                              ; preds = %.sink.split.dup1035, %.sink.split.dup1034, %.sink.split.dup, %LeafBlock
  %phi.edge1036 = phi i1 [ %phi.calluser.edge989, %.sink.split.dup ], [ %phi.calluser.edge997, %.sink.split.dup1034 ], [ %phi.calluser.edge993, %.sink.split.dup1035 ], [ %phi.calluser.edge990, %LeafBlock ]
  %phi.edge1037 = phi i1 [ %phi.calluser.edge977, %.sink.split.dup ], [ %phi.calluser.edge985, %.sink.split.dup1034 ], [ %phi.calluser.edge981, %.sink.split.dup1035 ], [ %phi.calluser.edge978, %LeafBlock ]
  %phi.edge1038 = phi i1 [ %phi.calluser.edge965, %.sink.split.dup ], [ %phi.calluser.edge973, %.sink.split.dup1034 ], [ %phi.calluser.edge969, %.sink.split.dup1035 ], [ %phi.calluser.edge966, %LeafBlock ]
  %phi.edge1039 = phi i1 [ %phi.calluser.edge953, %.sink.split.dup ], [ %phi.calluser.edge961, %.sink.split.dup1034 ], [ %phi.calluser.edge957, %.sink.split.dup1035 ], [ %phi.calluser.edge954, %LeafBlock ]
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 10 to ptr))
  %27 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  %28 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 11 to ptr))
  br label %__prepare_module_record_output_final

__prepare_module_record_output_final:             ; preds = %bb2
  call void @__quantum__rt__bool_record_output(i1 %0, ptr @0)
  call void @__quantum__rt__bool_record_output(i1 %1, ptr @1)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge1036, ptr @2)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge1037, ptr @3)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge1038, ptr @4)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge1039, ptr @5)
  call void @__quantum__rt__int_record_output(i64 %"55_2.0", ptr @6)
  call void @__quantum__rt__int_record_output(i64 %26, ptr @7)
  call void @__quantum__rt__bool_record_output(i1 %27, ptr @8)
  call void @__quantum__rt__bool_record_output(i1 %28, ptr @9)
  ret void
}

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, ptr) local_unnamed_addr

declare void @__quantum__qis__reset__body(ptr) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="8" "required_num_results"="12" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
