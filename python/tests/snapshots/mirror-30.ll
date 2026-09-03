; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@"sa.static_pyarray.%tmp913.894387fa.0" = local_unnamed_addr constant { i64, [5 x i64] } { i64 5, [5 x i64] [i64 0, i64 2, i64 4, i64 6, i64 8] }
@0 = private unnamed_addr constant [7 x i8] c"mirror\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
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
  %0 = icmp eq i32 %rintb, 1
  %shot = tail call i64 @___get_current_shot()
  %Pivot3499 = icmp slt i64 %shot, 4
  br i1 %Pivot3499, label %NodeBlock, label %NodeBlock3496

NodeBlock3496:                                    ; preds = %alloca_block
  %Pivot3497 = icmp samesign ult i64 %shot, 6
  br i1 %Pivot3497, label %LeafBlock3488, label %NodeBlock3494

NodeBlock3494:                                    ; preds = %NodeBlock3496
  %Pivot3495 = icmp samesign ult i64 %shot, 8
  br i1 %Pivot3495, label %LeafBlock3490, label %LeafBlock3492

LeafBlock3492:                                    ; preds = %NodeBlock3494
  %SwitchLeaf3493 = icmp eq i64 %shot, 8
  br i1 %SwitchLeaf3493, label %__barray_mask_return.exit2887, label %cond_exit_1807.5

LeafBlock3490:                                    ; preds = %NodeBlock3494
  %SwitchLeaf3491 = icmp eq i64 %shot, 6
  br i1 %SwitchLeaf3491, label %__barray_mask_return.exit2887, label %cond_exit_1807.5

LeafBlock3488:                                    ; preds = %NodeBlock3496
  %SwitchLeaf3489 = icmp eq i64 %shot, 4
  br i1 %SwitchLeaf3489, label %__barray_mask_return.exit2887, label %cond_exit_1807.5

NodeBlock:                                        ; preds = %alloca_block
  %Pivot = icmp slt i64 %shot, 2
  br i1 %Pivot, label %LeafBlock, label %LeafBlock3486

LeafBlock3486:                                    ; preds = %NodeBlock
  %SwitchLeaf3487 = icmp eq i64 %shot, 2
  br i1 %SwitchLeaf3487, label %__barray_mask_return.exit2887, label %cond_exit_1807.5

LeafBlock:                                        ; preds = %NodeBlock
  %SwitchLeaf = icmp eq i64 %shot, 0
  br i1 %SwitchLeaf, label %__barray_mask_return.exit2887, label %cond_exit_1807.5

__barray_mask_return.exit2887:                    ; preds = %LeafBlock3492, %LeafBlock3490, %LeafBlock3488, %LeafBlock3486, %LeafBlock, %cond_exit_1807.5
  %1 = phi i1 [ true, %LeafBlock ], [ false, %cond_exit_1807.5 ], [ true, %LeafBlock3486 ], [ true, %LeafBlock3488 ], [ true, %LeafBlock3490 ], [ true, %LeafBlock3492 ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x4025FDBBE9BBA775, ptr nonnull inttoptr (i64 2 to ptr))
  br i1 %0, label %__barray_mask_return.exit2908, label %bb

cond_exit_1807.5:                                 ; preds = %LeafBlock3492, %LeafBlock3490, %LeafBlock3488, %LeafBlock3486, %LeafBlock
  br label %__barray_mask_return.exit2887

__barray_mask_return.exit2908:                    ; preds = %__barray_mask_return.exit2887
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 25 to ptr))
  br label %bb

bb:                                               ; preds = %__barray_mask_return.exit2887, %__barray_mask_return.exit2908
  br i1 %1, label %__barray_mask_return.exit2916, label %__barray_mask_check_not_borrowed.exit3102

__barray_mask_return.exit2916:                    ; preds = %bb
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 21 to ptr))
  br label %__barray_mask_check_not_borrowed.exit3102

__barray_mask_check_not_borrowed.exit3102:        ; preds = %bb, %__barray_mask_return.exit2916
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__barrier30__body(ptr null, ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 15 to ptr), ptr nonnull inttoptr (i64 16 to ptr), ptr nonnull inttoptr (i64 17 to ptr), ptr nonnull inttoptr (i64 18 to ptr), ptr nonnull inttoptr (i64 19 to ptr), ptr nonnull inttoptr (i64 20 to ptr), ptr nonnull inttoptr (i64 21 to ptr), ptr nonnull inttoptr (i64 22 to ptr), ptr nonnull inttoptr (i64 23 to ptr), ptr nonnull inttoptr (i64 24 to ptr), ptr nonnull inttoptr (i64 25 to ptr), ptr nonnull inttoptr (i64 26 to ptr), ptr nonnull inttoptr (i64 27 to ptr), ptr nonnull inttoptr (i64 28 to ptr), ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  br i1 %1, label %__barray_mask_return.exit3110, label %bb0

__barray_mask_return.exit3110:                    ; preds = %__barray_mask_check_not_borrowed.exit3102
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 4 to ptr))
  br label %bb0

bb0:                                              ; preds = %__barray_mask_check_not_borrowed.exit3102, %__barray_mask_return.exit3110
  br i1 %0, label %__barray_mask_borrow.exit3128, label %__barray_mask_check_not_borrowed.exit3254

__barray_mask_borrow.exit3128:                    ; preds = %bb0
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 25 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  br label %__barray_mask_check_not_borrowed.exit3254

__barray_mask_check_not_borrowed.exit3254:        ; preds = %bb0, %__barray_mask_borrow.exit3128
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
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr), ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr), ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr), ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr), ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr), ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr), ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr), ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr), ptr nonnull inttoptr (i64 24 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr), ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 25 to ptr), ptr nonnull inttoptr (i64 26 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 24 to ptr), ptr nonnull inttoptr (i64 25 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 24 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 25 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 27 to ptr), ptr nonnull inttoptr (i64 28 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 26 to ptr), ptr nonnull inttoptr (i64 27 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 26 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 27 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 28 to ptr), ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 28 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__barrier30__body(ptr null, ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 15 to ptr), ptr nonnull inttoptr (i64 16 to ptr), ptr nonnull inttoptr (i64 17 to ptr), ptr nonnull inttoptr (i64 18 to ptr), ptr nonnull inttoptr (i64 19 to ptr), ptr nonnull inttoptr (i64 20 to ptr), ptr nonnull inttoptr (i64 21 to ptr), ptr nonnull inttoptr (i64 22 to ptr), ptr nonnull inttoptr (i64 23 to ptr), ptr nonnull inttoptr (i64 24 to ptr), ptr nonnull inttoptr (i64 25 to ptr), ptr nonnull inttoptr (i64 26 to ptr), ptr nonnull inttoptr (i64 27 to ptr), ptr nonnull inttoptr (i64 28 to ptr), ptr nonnull inttoptr (i64 29 to ptr))
  tail call void @__quantum__qis__mz__body(ptr null, ptr null)
  %2 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 1 to ptr))
  %3 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 2 to ptr))
  %4 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 3 to ptr))
  %5 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 4 to ptr))
  %6 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 5 to ptr))
  %7 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 6 to ptr))
  %8 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 7 to ptr))
  %9 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 8 to ptr))
  %10 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  %11 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 10 to ptr))
  %12 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  %13 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 12 to ptr))
  %14 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 13 to ptr))
  %15 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 14 to ptr))
  %16 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 15 to ptr), ptr nonnull inttoptr (i64 15 to ptr))
  %17 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 16 to ptr), ptr nonnull inttoptr (i64 16 to ptr))
  %18 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 17 to ptr), ptr nonnull inttoptr (i64 17 to ptr))
  %19 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 18 to ptr), ptr nonnull inttoptr (i64 18 to ptr))
  %20 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 19 to ptr), ptr nonnull inttoptr (i64 19 to ptr))
  %21 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 20 to ptr), ptr nonnull inttoptr (i64 20 to ptr))
  %22 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 21 to ptr), ptr nonnull inttoptr (i64 21 to ptr))
  %23 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 22 to ptr), ptr nonnull inttoptr (i64 22 to ptr))
  %24 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 23 to ptr), ptr nonnull inttoptr (i64 23 to ptr))
  %25 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 24 to ptr), ptr nonnull inttoptr (i64 24 to ptr))
  %26 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 24 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 25 to ptr), ptr nonnull inttoptr (i64 25 to ptr))
  %27 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 25 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 26 to ptr), ptr nonnull inttoptr (i64 26 to ptr))
  %28 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 26 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 27 to ptr), ptr nonnull inttoptr (i64 27 to ptr))
  %29 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 27 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 28 to ptr), ptr nonnull inttoptr (i64 28 to ptr))
  %30 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 28 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 29 to ptr), ptr nonnull inttoptr (i64 29 to ptr))
  %31 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 29 to ptr))
  %32 = zext i1 %3 to i64
  %33 = select i1 %2, i64 2, i64 0
  %34 = or disjoint i64 %33, %32
  %35 = zext i1 %5 to i64
  %36 = shl nuw nsw i64 %34, 2
  %37 = select i1 %4, i64 2, i64 0
  %38 = or disjoint i64 %36, %37
  %39 = or disjoint i64 %38, %35
  %40 = zext i1 %7 to i64
  %41 = shl nuw nsw i64 %39, 2
  %42 = select i1 %6, i64 2, i64 0
  %43 = or disjoint i64 %41, %42
  %44 = or disjoint i64 %43, %40
  %45 = zext i1 %9 to i64
  %46 = shl nuw nsw i64 %44, 2
  %47 = select i1 %8, i64 2, i64 0
  %48 = or disjoint i64 %46, %47
  %49 = or disjoint i64 %48, %45
  %50 = zext i1 %11 to i64
  %51 = shl nuw nsw i64 %49, 2
  %52 = select i1 %10, i64 2, i64 0
  %53 = or disjoint i64 %51, %52
  %54 = or disjoint i64 %53, %50
  %55 = zext i1 %13 to i64
  %56 = shl nuw nsw i64 %54, 2
  %57 = select i1 %12, i64 2, i64 0
  %58 = or disjoint i64 %56, %57
  %59 = or disjoint i64 %58, %55
  %60 = zext i1 %15 to i64
  %61 = shl nuw nsw i64 %59, 2
  %62 = select i1 %14, i64 2, i64 0
  %63 = or disjoint i64 %61, %62
  %64 = or disjoint i64 %63, %60
  %65 = zext i1 %17 to i64
  %66 = shl nuw nsw i64 %64, 2
  %67 = select i1 %16, i64 2, i64 0
  %68 = or disjoint i64 %66, %67
  %69 = or disjoint i64 %68, %65
  %70 = zext i1 %19 to i64
  %71 = shl nuw nsw i64 %69, 2
  %72 = select i1 %18, i64 2, i64 0
  %73 = or disjoint i64 %71, %72
  %74 = or disjoint i64 %73, %70
  %75 = zext i1 %21 to i64
  %76 = shl nuw nsw i64 %74, 2
  %77 = select i1 %20, i64 2, i64 0
  %78 = or disjoint i64 %76, %77
  %79 = or disjoint i64 %78, %75
  %80 = zext i1 %23 to i64
  %81 = shl nuw nsw i64 %79, 2
  %82 = select i1 %22, i64 2, i64 0
  %83 = or disjoint i64 %81, %82
  %84 = or disjoint i64 %83, %80
  %85 = zext i1 %25 to i64
  %86 = shl nuw nsw i64 %84, 2
  %87 = select i1 %24, i64 2, i64 0
  %88 = or disjoint i64 %86, %87
  %89 = or disjoint i64 %88, %85
  %90 = zext i1 %27 to i64
  %91 = shl nuw nsw i64 %89, 2
  %92 = select i1 %26, i64 2, i64 0
  %93 = or disjoint i64 %91, %92
  %94 = or disjoint i64 %93, %90
  %95 = zext i1 %29 to i64
  %96 = shl nuw nsw i64 %94, 2
  %97 = select i1 %28, i64 2, i64 0
  %98 = or disjoint i64 %96, %97
  %99 = or disjoint i64 %98, %95
  %100 = zext i1 %31 to i64
  %101 = shl nuw nsw i64 %99, 2
  %102 = select i1 %30, i64 2, i64 0
  %103 = or disjoint i64 %101, %102
  %104 = or disjoint i64 %103, %100
  tail call void @__quantum__rt__int_record_output(i64 %104, ptr nonnull @0)
  ret void
}

declare void @___random_seed(i64) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__qis__rzz__body(double, ptr, ptr) local_unnamed_addr

declare i32 @___random_int_bounded(i32) local_unnamed_addr

declare i64 @___get_current_shot() local_unnamed_addr

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
