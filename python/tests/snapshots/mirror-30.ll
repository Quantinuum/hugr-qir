; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [7 x i8] c"mirror\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
  %shot = tail call i64 @___get_current_shot()
  %remainder = srem i64 %shot, 2
  %trunc = icmp slt i64 %shot, 0
  %0 = add nsw i64 %remainder, 2
  %is_rem_0.not = icmp eq i64 %remainder, 0
  %.elt2256 = select i1 %is_rem_0.not, i64 0, i64 %0
  %result.sroa.2.0 = select i1 %trunc, i64 %.elt2256, i64 %remainder
  %1 = icmp eq i64 %result.sroa.2.0, 1
  tail call void @___random_seed(i64 2026)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr), ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr), ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr), ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr), ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr), ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr), ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr), ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr), ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 24 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 25 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 24 to ptr), ptr nonnull inttoptr (i64 25 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr), ptr nonnull inttoptr (i64 24 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 26 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 27 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 26 to ptr), ptr nonnull inttoptr (i64 27 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 25 to ptr), ptr nonnull inttoptr (i64 26 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 28 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 28 to ptr), ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 27 to ptr), ptr nonnull inttoptr (i64 28 to ptr))
  %rintb = tail call i32 @___random_int_bounded(i32 2)
  %2 = icmp eq i32 %rintb, 1
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x4025FDBBE9BBA775, ptr nonnull inttoptr (i64 2 to ptr))
  br i1 %2, label %bb, label %bb0

bb:                                               ; preds = %alloca_block
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 25 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  br label %bb0

bb0:                                              ; preds = %alloca_block, %bb
  br i1 %1, label %bb1, label %__barray_mask_check_not_borrowed.exit2283

bb1:                                              ; preds = %bb0
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 21 to ptr))
  br label %__barray_mask_check_not_borrowed.exit2283

__barray_mask_check_not_borrowed.exit2283:        ; preds = %bb1, %bb0
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__barrier30__body(ptr null, ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 15 to ptr), ptr nonnull inttoptr (i64 16 to ptr), ptr nonnull inttoptr (i64 17 to ptr), ptr nonnull inttoptr (i64 18 to ptr), ptr nonnull inttoptr (i64 19 to ptr), ptr nonnull inttoptr (i64 20 to ptr), ptr nonnull inttoptr (i64 21 to ptr), ptr nonnull inttoptr (i64 22 to ptr), ptr nonnull inttoptr (i64 23 to ptr), ptr nonnull inttoptr (i64 24 to ptr), ptr nonnull inttoptr (i64 25 to ptr), ptr nonnull inttoptr (i64 26 to ptr), ptr nonnull inttoptr (i64 27 to ptr), ptr nonnull inttoptr (i64 28 to ptr), ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr), ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr), ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr), ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr), ptr nonnull inttoptr (i64 24 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 27 to ptr), ptr nonnull inttoptr (i64 28 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 28 to ptr), ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 28 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  br i1 %1, label %bb2, label %bb3

bb2:                                              ; preds = %__barray_mask_check_not_borrowed.exit2283
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 21 to ptr))
  br label %bb3

bb3:                                              ; preds = %__barray_mask_check_not_borrowed.exit2283, %bb2
  br i1 %2, label %bb4, label %__barray_mask_check_not_borrowed.exit2343

bb4:                                              ; preds = %bb3
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 25 to ptr))
  br label %__barray_mask_check_not_borrowed.exit2343

__barray_mask_check_not_borrowed.exit2343:        ; preds = %bb3, %bb4
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr), ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr), ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr), ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr), ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr), ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 25 to ptr), ptr nonnull inttoptr (i64 26 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 24 to ptr), ptr nonnull inttoptr (i64 25 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 24 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 25 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 26 to ptr), ptr nonnull inttoptr (i64 27 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 26 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 27 to ptr))
  tail call void @__quantum__qis__barrier30__body(ptr null, ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 15 to ptr), ptr nonnull inttoptr (i64 16 to ptr), ptr nonnull inttoptr (i64 17 to ptr), ptr nonnull inttoptr (i64 18 to ptr), ptr nonnull inttoptr (i64 19 to ptr), ptr nonnull inttoptr (i64 20 to ptr), ptr nonnull inttoptr (i64 21 to ptr), ptr nonnull inttoptr (i64 22 to ptr), ptr nonnull inttoptr (i64 23 to ptr), ptr nonnull inttoptr (i64 24 to ptr), ptr nonnull inttoptr (i64 25 to ptr), ptr nonnull inttoptr (i64 26 to ptr), ptr nonnull inttoptr (i64 27 to ptr), ptr nonnull inttoptr (i64 28 to ptr), ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__mz__body(ptr null, ptr null)
  %3 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 1 to ptr))
  %4 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 2 to ptr))
  %5 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 3 to ptr))
  %6 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 4 to ptr))
  %7 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 5 to ptr))
  %8 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 6 to ptr))
  %9 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 7 to ptr))
  %10 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 8 to ptr))
  %11 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  %12 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 10 to ptr))
  %13 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  %14 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 12 to ptr))
  %15 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 13 to ptr))
  %16 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 14 to ptr))
  %17 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 15 to ptr), ptr nonnull inttoptr (i64 15 to ptr))
  %18 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 16 to ptr), ptr nonnull inttoptr (i64 16 to ptr))
  %19 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 17 to ptr), ptr nonnull inttoptr (i64 17 to ptr))
  %20 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 18 to ptr), ptr nonnull inttoptr (i64 18 to ptr))
  %21 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 19 to ptr), ptr nonnull inttoptr (i64 19 to ptr))
  %22 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 20 to ptr), ptr nonnull inttoptr (i64 20 to ptr))
  %23 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 21 to ptr), ptr nonnull inttoptr (i64 21 to ptr))
  %24 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 22 to ptr), ptr nonnull inttoptr (i64 22 to ptr))
  %25 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 23 to ptr), ptr nonnull inttoptr (i64 23 to ptr))
  %26 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 24 to ptr), ptr nonnull inttoptr (i64 24 to ptr))
  %27 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 24 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 25 to ptr), ptr nonnull inttoptr (i64 25 to ptr))
  %28 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 25 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 26 to ptr), ptr nonnull inttoptr (i64 26 to ptr))
  %29 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 26 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 27 to ptr), ptr nonnull inttoptr (i64 27 to ptr))
  %30 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 27 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 28 to ptr), ptr nonnull inttoptr (i64 28 to ptr))
  %31 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 28 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 29 to ptr), ptr nonnull inttoptr (i64 29 to ptr))
  %32 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 29 to ptr))
  %33 = zext i1 %4 to i64
  %34 = select i1 %3, i64 2, i64 0
  %35 = or disjoint i64 %34, %33
  %36 = zext i1 %6 to i64
  %37 = shl nuw nsw i64 %35, 2
  %38 = select i1 %5, i64 2, i64 0
  %39 = or disjoint i64 %37, %38
  %40 = or disjoint i64 %39, %36
  %41 = zext i1 %8 to i64
  %42 = shl nuw nsw i64 %40, 2
  %43 = select i1 %7, i64 2, i64 0
  %44 = or disjoint i64 %42, %43
  %45 = or disjoint i64 %44, %41
  %46 = zext i1 %10 to i64
  %47 = shl nuw nsw i64 %45, 2
  %48 = select i1 %9, i64 2, i64 0
  %49 = or disjoint i64 %47, %48
  %50 = or disjoint i64 %49, %46
  %51 = zext i1 %12 to i64
  %52 = shl nuw nsw i64 %50, 2
  %53 = select i1 %11, i64 2, i64 0
  %54 = or disjoint i64 %52, %53
  %55 = or disjoint i64 %54, %51
  %56 = zext i1 %14 to i64
  %57 = shl nuw nsw i64 %55, 2
  %58 = select i1 %13, i64 2, i64 0
  %59 = or disjoint i64 %57, %58
  %60 = or disjoint i64 %59, %56
  %61 = zext i1 %16 to i64
  %62 = shl nuw nsw i64 %60, 2
  %63 = select i1 %15, i64 2, i64 0
  %64 = or disjoint i64 %62, %63
  %65 = or disjoint i64 %64, %61
  %66 = zext i1 %18 to i64
  %67 = shl nuw nsw i64 %65, 2
  %68 = select i1 %17, i64 2, i64 0
  %69 = or disjoint i64 %67, %68
  %70 = or disjoint i64 %69, %66
  %71 = zext i1 %20 to i64
  %72 = shl nuw nsw i64 %70, 2
  %73 = select i1 %19, i64 2, i64 0
  %74 = or disjoint i64 %72, %73
  %75 = or disjoint i64 %74, %71
  %76 = zext i1 %22 to i64
  %77 = shl nuw nsw i64 %75, 2
  %78 = select i1 %21, i64 2, i64 0
  %79 = or disjoint i64 %77, %78
  %80 = or disjoint i64 %79, %76
  %81 = zext i1 %24 to i64
  %82 = shl nuw nsw i64 %80, 2
  %83 = select i1 %23, i64 2, i64 0
  %84 = or disjoint i64 %82, %83
  %85 = or disjoint i64 %84, %81
  %86 = zext i1 %26 to i64
  %87 = shl nuw nsw i64 %85, 2
  %88 = select i1 %25, i64 2, i64 0
  %89 = or disjoint i64 %87, %88
  %90 = or disjoint i64 %89, %86
  %91 = zext i1 %28 to i64
  %92 = shl nuw nsw i64 %90, 2
  %93 = select i1 %27, i64 2, i64 0
  %94 = or disjoint i64 %92, %93
  %95 = or disjoint i64 %94, %91
  %96 = zext i1 %30 to i64
  %97 = shl nuw nsw i64 %95, 2
  %98 = select i1 %29, i64 2, i64 0
  %99 = or disjoint i64 %97, %98
  %100 = or disjoint i64 %99, %96
  %101 = zext i1 %32 to i64
  %102 = shl nuw nsw i64 %100, 2
  %103 = select i1 %31, i64 2, i64 0
  %104 = or disjoint i64 %102, %103
  %105 = or disjoint i64 %104, %101
  tail call void @__quantum__rt__int_record_output(i64 %105, ptr nonnull @0)
  ret void
}

declare i64 @___get_current_shot() local_unnamed_addr

declare void @___random_seed(i64) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__qis__rzz__body(double, ptr, ptr) local_unnamed_addr

declare i32 @___random_int_bounded(i32) local_unnamed_addr

declare void @__quantum__qis__rz__body(double, ptr) local_unnamed_addr

declare void @__quantum__qis__barrier30__body(ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr) local_unnamed_addr

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="30" "required_num_results"="30" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
