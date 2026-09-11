; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [9 x i8] c"0___BOOL\00", align 1
@1 = private unnamed_addr constant [11 x i8] c"shot___INT\00", align 1
@2 = private unnamed_addr constant [16 x i8] c"random_nr___INT\00", align 1
@3 = private unnamed_addr constant [17 x i8] c"random_nr2___INT\00", align 1
@4 = private unnamed_addr constant [12 x i8] c"shot____INT\00", align 1
@5 = private unnamed_addr constant [17 x i8] c"random_nr____INT\00", align 1
@6 = private unnamed_addr constant [18 x i8] c"random_nr2____INT\00", align 1
@7 = private unnamed_addr constant [9 x i8] c"q___BOOL\00", align 1
@8 = private unnamed_addr constant [10 x i8] c"q2___BOOL\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
  tail call void @___random_seed(i64 11)
  %shot = tail call i64 @___get_current_shot()
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__mz__body(ptr null, ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__rt__bool_record_output(i1 %0, ptr nonnull @0)
  tail call void @__quantum__rt__int_record_output(i64 %shot, ptr nonnull @1)
  %rintb = tail call i32 @___random_int_bounded(i32 10)
  %rint = tail call i32 @___random_int()
  %1 = zext i32 %rint to i64
  %2 = zext i32 %rintb to i64
  %urem.quotient = udiv i32 %rintb, 3
  %urem.product = mul i32 %urem.quotient, 3
  %urem.lowered = sub i32 %rintb, %urem.product
  tail call void @__quantum__rt__int_record_output(i64 %2, ptr nonnull @2)
  tail call void @__quantum__rt__int_record_output(i64 %1, ptr nonnull @3)
  tail call void @__quantum__rt__int_record_output(i64 %shot, ptr nonnull @4)
  tail call void @__quantum__rt__int_record_output(i64 %2, ptr nonnull @5)
  tail call void @__quantum__rt__int_record_output(i64 %1, ptr nonnull @6)
  br label %NodeBlock

NodeBlock:                                        ; preds = %alloca_block
  %Pivot = icmp slt i32 %urem.lowered, 1
  br i1 %Pivot, label %LeafBlock, label %LeafBlock431

LeafBlock431:                                     ; preds = %NodeBlock
  %SwitchLeaf = icmp eq i32 %urem.lowered, 1
  br i1 %SwitchLeaf, label %bb2, label %bb1

bb:                                               ; preds = %LeafBlock425
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 2 to ptr))
  br label %bb0

bb0:                                              ; preds = %LeafBlock425, %bb4, %bb, %bb3
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 1 to ptr))
  %3 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %3, ptr nonnull @8)
  ret void

LeafBlock:                                        ; preds = %NodeBlock
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  br label %exit208

bb1:                                              ; preds = %LeafBlock431
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 1 to ptr))
  br label %exit208

bb2:                                              ; preds = %LeafBlock431
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 1 to ptr))
  br label %exit208

exit208:                                          ; preds = %LeafBlock, %bb1, %bb2
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 2 to ptr))
  %4 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %4, ptr nonnull @7)
  %Pivot430 = icmp ult i32 %rintb, 3
  br i1 %Pivot430, label %bb3, label %NodeBlock427

NodeBlock427:                                     ; preds = %exit208
  %Pivot428 = icmp ult i32 %rintb, 6
  br i1 %Pivot428, label %bb4, label %LeafBlock425

LeafBlock425:                                     ; preds = %NodeBlock427
  %rintb.off = add i32 %rintb, -6
  %SwitchLeaf426 = icmp ult i32 %rintb.off, 3
  br i1 %SwitchLeaf426, label %bb, label %bb0

bb3:                                              ; preds = %exit208
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  br label %bb0

bb4:                                              ; preds = %NodeBlock427
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 2 to ptr))
  br label %bb0
}

declare void @___random_seed(i64) local_unnamed_addr

declare noundef range(i64 0, 4294967296) i64 @___get_current_shot() local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__qis__rz__body(double, ptr) local_unnamed_addr

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, ptr) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, ptr) local_unnamed_addr

declare noundef i32 @___random_int_bounded(i32) local_unnamed_addr

declare noundef i32 @___random_int() local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="3" "required_num_results"="3" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
