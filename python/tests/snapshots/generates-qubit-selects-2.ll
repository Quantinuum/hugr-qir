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
  %"55_2.0" = select i1 %1, i64 2, i64 0
  br i1 %1, label %alloca_block.dup949, label %alloca_block.dup

alloca_block.dup949:                              ; preds = %alloca_block
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %2 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %3 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %4 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %5 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 1 to ptr))
  br label %.critedge

alloca_block.dup:                                 ; preds = %alloca_block
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %6 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %7 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %8 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %9 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %.critedge

.critedge:                                        ; preds = %alloca_block.dup, %alloca_block.dup949
  %phi.calluser.edge984 = phi i1 [ %5, %alloca_block.dup949 ], [ %9, %alloca_block.dup ]
  %phi.calluser.edge974 = phi i1 [ %4, %alloca_block.dup949 ], [ %8, %alloca_block.dup ]
  %phi.calluser.edge964 = phi i1 [ %3, %alloca_block.dup949 ], [ %7, %alloca_block.dup ]
  %phi.calluser.edge954 = phi i1 [ %2, %alloca_block.dup949 ], [ %6, %alloca_block.dup ]
  tail call void @__quantum__qis__mz__body(ptr null, ptr nonnull inttoptr (i64 6 to ptr))
  %10 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 7 to ptr))
  %11 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 8 to ptr))
  %12 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  %13 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 9 to ptr))
  %. = zext i1 %13 to i64
  %"0617.0" = select i1 %12, i64 2, i64 0
  %"0631.0" = zext i1 %12 to i64
  %14 = or disjoint i64 %"55_2.0", %"0631.0"
  %"0661.0" = select i1 %11, i64 4, i64 0
  %"0676.0" = select i1 %10, i64 8, i64 0
  %15 = or disjoint i64 %"0661.0", %"0676.0"
  %16 = or disjoint i64 %15, %"0617.0"
  %17 = or disjoint i64 %16, %.
  br i1 %1, label %NodeBlock, label %LeafBlock

NodeBlock:                                        ; preds = %.critedge
  %phi.calluser.edge983 = phi i1 [ %phi.calluser.edge984, %.critedge ]
  %phi.calluser.edge973 = phi i1 [ %phi.calluser.edge974, %.critedge ]
  %phi.calluser.edge963 = phi i1 [ %phi.calluser.edge964, %.critedge ]
  %phi.calluser.edge953 = phi i1 [ %phi.calluser.edge954, %.critedge ]
  %Pivot.not = icmp eq i64 %14, 3
  br i1 %Pivot.not, label %bb, label %.sink.split.dup

LeafBlock:                                        ; preds = %.critedge
  %phi.calluser.edge987 = phi i1 [ %phi.calluser.edge984, %.critedge ]
  %phi.calluser.edge977 = phi i1 [ %phi.calluser.edge974, %.critedge ]
  %phi.calluser.edge967 = phi i1 [ %phi.calluser.edge964, %.critedge ]
  %phi.calluser.edge957 = phi i1 [ %phi.calluser.edge954, %.critedge ]
  %SwitchLeaf = icmp eq i64 %14, 1
  br i1 %SwitchLeaf, label %.sink.split.dup990, label %.sink.split.dup989

.sink.split.dup990:                               ; preds = %LeafBlock
  %phi.calluser.edge988 = phi i1 [ %phi.calluser.edge987, %LeafBlock ]
  %phi.calluser.edge978 = phi i1 [ %phi.calluser.edge977, %LeafBlock ]
  %phi.calluser.edge968 = phi i1 [ %phi.calluser.edge967, %LeafBlock ]
  %phi.calluser.edge958 = phi i1 [ %phi.calluser.edge957, %LeafBlock ]
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  br label %bb

.sink.split.dup989:                               ; preds = %LeafBlock
  %phi.calluser.edge986 = phi i1 [ %phi.calluser.edge987, %LeafBlock ]
  %phi.calluser.edge976 = phi i1 [ %phi.calluser.edge977, %LeafBlock ]
  %phi.calluser.edge966 = phi i1 [ %phi.calluser.edge967, %LeafBlock ]
  %phi.calluser.edge956 = phi i1 [ %phi.calluser.edge957, %LeafBlock ]
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb

.sink.split.dup:                                  ; preds = %NodeBlock
  %phi.calluser.edge982 = phi i1 [ %phi.calluser.edge983, %NodeBlock ]
  %phi.calluser.edge972 = phi i1 [ %phi.calluser.edge973, %NodeBlock ]
  %phi.calluser.edge962 = phi i1 [ %phi.calluser.edge963, %NodeBlock ]
  %phi.calluser.edge952 = phi i1 [ %phi.calluser.edge953, %NodeBlock ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb

bb:                                               ; preds = %.sink.split.dup990, %.sink.split.dup989, %.sink.split.dup, %NodeBlock
  %phi.edge991 = phi i1 [ %phi.calluser.edge982, %.sink.split.dup ], [ %phi.calluser.edge986, %.sink.split.dup989 ], [ %phi.calluser.edge988, %.sink.split.dup990 ], [ %phi.calluser.edge983, %NodeBlock ]
  %phi.edge992 = phi i1 [ %phi.calluser.edge972, %.sink.split.dup ], [ %phi.calluser.edge976, %.sink.split.dup989 ], [ %phi.calluser.edge978, %.sink.split.dup990 ], [ %phi.calluser.edge973, %NodeBlock ]
  %phi.edge993 = phi i1 [ %phi.calluser.edge962, %.sink.split.dup ], [ %phi.calluser.edge966, %.sink.split.dup989 ], [ %phi.calluser.edge968, %.sink.split.dup990 ], [ %phi.calluser.edge963, %NodeBlock ]
  %phi.edge994 = phi i1 [ %phi.calluser.edge952, %.sink.split.dup ], [ %phi.calluser.edge956, %.sink.split.dup989 ], [ %phi.calluser.edge958, %.sink.split.dup990 ], [ %phi.calluser.edge953, %NodeBlock ]
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 10 to ptr))
  %18 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  %19 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 11 to ptr))
  br label %__prepare_module_record_output_final

__prepare_module_record_output_final:             ; preds = %bb
  call void @__quantum__rt__bool_record_output(i1 %0, ptr @0)
  call void @__quantum__rt__bool_record_output(i1 %1, ptr @1)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge991, ptr @2)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge992, ptr @3)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge993, ptr @4)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge994, ptr @5)
  call void @__quantum__rt__int_record_output(i64 %"55_2.0", ptr @6)
  call void @__quantum__rt__int_record_output(i64 %17, ptr @7)
  call void @__quantum__rt__bool_record_output(i1 %18, ptr @8)
  call void @__quantum__rt__bool_record_output(i1 %19, ptr @9)
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
