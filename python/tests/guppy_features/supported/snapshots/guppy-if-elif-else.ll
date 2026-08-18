; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@1 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@2 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@3 = private unnamed_addr constant [2 x i8] c"d\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
  tail call void @__quantum__qis__mz__body(ptr null, ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 1 to ptr))
  %1 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 2 to ptr))
  %2 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 2 to ptr))
  %"36_3.0" = zext i1 %0 to i64
  %3 = select i1 %0, i64 2, i64 1
  %"52_3.0" = select i1 %1, i64 %3, i64 %"36_3.0"
  %4 = zext i1 %2 to i64
  %"68_3.0" = add nuw nsw i64 %"52_3.0", %4
  br label %NodeBlock471

NodeBlock471:                                     ; preds = %alloca_block
  %Pivot472 = icmp slt i64 %"68_3.0", 1
  br i1 %Pivot472, label %bb2, label %NodeBlock

NodeBlock:                                        ; preds = %NodeBlock471
  %Pivot = icmp slt i64 %"68_3.0", 2
  br i1 %Pivot, label %bb3, label %LeafBlock

LeafBlock:                                        ; preds = %NodeBlock
  %SwitchLeaf = icmp eq i64 %"68_3.0", 2
  br i1 %SwitchLeaf, label %bb0, label %bb

bb:                                               ; preds = %LeafBlock
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  br label %bb1

bb0:                                              ; preds = %LeafBlock
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  br label %bb1

bb1:                                              ; preds = %bb3, %bb, %bb0, %bb2
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 3 to ptr))
  %5 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %0, ptr nonnull @0)
  tail call void @__quantum__rt__bool_record_output(i1 %1, ptr nonnull @1)
  tail call void @__quantum__rt__bool_record_output(i1 %2, ptr nonnull @2)
  tail call void @__quantum__rt__bool_record_output(i1 %5, ptr nonnull @3)
  ret void

bb2:                                              ; preds = %NodeBlock471
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 3 to ptr))
  br label %bb1

bb3:                                              ; preds = %NodeBlock
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  br label %bb1
}

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__qis__rz__body(double, ptr) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="4" "required_num_results"="4" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
