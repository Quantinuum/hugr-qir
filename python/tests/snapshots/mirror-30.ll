; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@"sa.static_pyarray.%tmp2231.d8bbe7da.0" = local_unnamed_addr constant { i64, [5 x i64] } { i64 5, [5 x i64] [i64 0, i64 2, i64 4, i64 6, i64 8] }
@0 = private unnamed_addr constant [19 x i8] c"mirror___ARRBOOL_0\00", align 1
@1 = private unnamed_addr constant [19 x i8] c"mirror___ARRBOOL_1\00", align 1
@2 = private unnamed_addr constant [19 x i8] c"mirror___ARRBOOL_2\00", align 1
@3 = private unnamed_addr constant [19 x i8] c"mirror___ARRBOOL_3\00", align 1
@4 = private unnamed_addr constant [19 x i8] c"mirror___ARRBOOL_4\00", align 1
@5 = private unnamed_addr constant [19 x i8] c"mirror___ARRBOOL_5\00", align 1
@6 = private unnamed_addr constant [19 x i8] c"mirror___ARRBOOL_6\00", align 1
@7 = private unnamed_addr constant [19 x i8] c"mirror___ARRBOOL_7\00", align 1
@8 = private unnamed_addr constant [19 x i8] c"mirror___ARRBOOL_8\00", align 1
@9 = private unnamed_addr constant [19 x i8] c"mirror___ARRBOOL_9\00", align 1
@10 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_10\00", align 1
@11 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_11\00", align 1
@12 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_12\00", align 1
@13 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_13\00", align 1
@14 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_14\00", align 1
@15 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_15\00", align 1
@16 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_16\00", align 1
@17 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_17\00", align 1
@18 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_18\00", align 1
@19 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_19\00", align 1
@20 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_20\00", align 1
@21 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_21\00", align 1
@22 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_22\00", align 1
@23 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_23\00", align 1
@24 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_24\00", align 1
@25 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_25\00", align 1
@26 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_26\00", align 1
@27 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_27\00", align 1
@28 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_28\00", align 1
@29 = private unnamed_addr constant [20 x i8] c"mirror___ARRBOOL_29\00", align 1
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
  %Pivot3546 = icmp samesign ult i64 %shot, 4
  br i1 %Pivot3546, label %NodeBlock, label %NodeBlock3543

NodeBlock3543:                                    ; preds = %alloca_block
  %Pivot3544 = icmp samesign ult i64 %shot, 6
  br i1 %Pivot3544, label %LeafBlock3535, label %NodeBlock3541

NodeBlock3541:                                    ; preds = %NodeBlock3543
  %Pivot3542 = icmp samesign ult i64 %shot, 8
  br i1 %Pivot3542, label %LeafBlock3537, label %LeafBlock3539

LeafBlock3539:                                    ; preds = %NodeBlock3541
  %SwitchLeaf3540 = icmp eq i64 %shot, 8
  br i1 %SwitchLeaf3540, label %__barray_mask_return.exit2887, label %cond_exit_1807.5

LeafBlock3537:                                    ; preds = %NodeBlock3541
  %SwitchLeaf3538 = icmp eq i64 %shot, 6
  br i1 %SwitchLeaf3538, label %__barray_mask_return.exit2887, label %cond_exit_1807.5

LeafBlock3535:                                    ; preds = %NodeBlock3543
  %SwitchLeaf3536 = icmp eq i64 %shot, 4
  br i1 %SwitchLeaf3536, label %__barray_mask_return.exit2887, label %cond_exit_1807.5

NodeBlock:                                        ; preds = %alloca_block
  %Pivot = icmp samesign ult i64 %shot, 2
  br i1 %Pivot, label %LeafBlock, label %LeafBlock3533

LeafBlock3533:                                    ; preds = %NodeBlock
  %SwitchLeaf3534 = icmp eq i64 %shot, 2
  br i1 %SwitchLeaf3534, label %__barray_mask_return.exit2887, label %cond_exit_1807.5

LeafBlock:                                        ; preds = %NodeBlock
  %SwitchLeaf = icmp eq i64 %shot, 0
  br i1 %SwitchLeaf, label %__barray_mask_return.exit2887, label %cond_exit_1807.5

__barray_mask_return.exit2887:                    ; preds = %LeafBlock3539, %LeafBlock3537, %LeafBlock3535, %LeafBlock3533, %LeafBlock, %cond_exit_1807.5
  %1 = phi i1 [ true, %LeafBlock ], [ false, %cond_exit_1807.5 ], [ true, %LeafBlock3533 ], [ true, %LeafBlock3535 ], [ true, %LeafBlock3537 ], [ true, %LeafBlock3539 ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x4025FDBBE9BBA775, ptr nonnull inttoptr (i64 2 to ptr))
  br i1 %0, label %__barray_mask_return.exit2908, label %bb

cond_exit_1807.5:                                 ; preds = %LeafBlock3539, %LeafBlock3537, %LeafBlock3535, %LeafBlock3533, %LeafBlock
  br label %__barray_mask_return.exit2887

__barray_mask_return.exit2908:                    ; preds = %__barray_mask_return.exit2887
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 25 to ptr))
  br label %bb

bb:                                               ; preds = %__barray_mask_return.exit2887, %__barray_mask_return.exit2908
  br i1 %1, label %__barray_mask_return.exit2916, label %__barray_mask_check_not_borrowed.exit3104

__barray_mask_return.exit2916:                    ; preds = %bb
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 21 to ptr))
  br label %__barray_mask_check_not_borrowed.exit3104

__barray_mask_check_not_borrowed.exit3104:        ; preds = %__barray_mask_return.exit2916, %bb
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
  br i1 %1, label %__barray_mask_return.exit3112, label %bb0

__barray_mask_return.exit3112:                    ; preds = %__barray_mask_check_not_borrowed.exit3104
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 4 to ptr))
  br label %bb0

bb0:                                              ; preds = %__barray_mask_check_not_borrowed.exit3104, %__barray_mask_return.exit3112
  br i1 %0, label %__barray_mask_borrow.exit3130, label %__barray_mask_check_not_borrowed.exit3258

__barray_mask_borrow.exit3130:                    ; preds = %bb0
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 25 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  br label %__barray_mask_check_not_borrowed.exit3258

__barray_mask_check_not_borrowed.exit3258:        ; preds = %bb0, %__barray_mask_borrow.exit3130
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
  tail call void @__quantum__rt__bool_record_output(i1 %2, ptr nonnull @0)
  tail call void @__quantum__rt__bool_record_output(i1 %3, ptr nonnull @1)
  tail call void @__quantum__rt__bool_record_output(i1 %4, ptr nonnull @2)
  tail call void @__quantum__rt__bool_record_output(i1 %5, ptr nonnull @3)
  tail call void @__quantum__rt__bool_record_output(i1 %6, ptr nonnull @4)
  tail call void @__quantum__rt__bool_record_output(i1 %7, ptr nonnull @5)
  tail call void @__quantum__rt__bool_record_output(i1 %8, ptr nonnull @6)
  tail call void @__quantum__rt__bool_record_output(i1 %9, ptr nonnull @7)
  tail call void @__quantum__rt__bool_record_output(i1 %10, ptr nonnull @8)
  tail call void @__quantum__rt__bool_record_output(i1 %11, ptr nonnull @9)
  tail call void @__quantum__rt__bool_record_output(i1 %12, ptr nonnull @10)
  tail call void @__quantum__rt__bool_record_output(i1 %13, ptr nonnull @11)
  tail call void @__quantum__rt__bool_record_output(i1 %14, ptr nonnull @12)
  tail call void @__quantum__rt__bool_record_output(i1 %15, ptr nonnull @13)
  tail call void @__quantum__rt__bool_record_output(i1 %16, ptr nonnull @14)
  tail call void @__quantum__rt__bool_record_output(i1 %17, ptr nonnull @15)
  tail call void @__quantum__rt__bool_record_output(i1 %18, ptr nonnull @16)
  tail call void @__quantum__rt__bool_record_output(i1 %19, ptr nonnull @17)
  tail call void @__quantum__rt__bool_record_output(i1 %20, ptr nonnull @18)
  tail call void @__quantum__rt__bool_record_output(i1 %21, ptr nonnull @19)
  tail call void @__quantum__rt__bool_record_output(i1 %22, ptr nonnull @20)
  tail call void @__quantum__rt__bool_record_output(i1 %23, ptr nonnull @21)
  tail call void @__quantum__rt__bool_record_output(i1 %24, ptr nonnull @22)
  tail call void @__quantum__rt__bool_record_output(i1 %25, ptr nonnull @23)
  tail call void @__quantum__rt__bool_record_output(i1 %26, ptr nonnull @24)
  tail call void @__quantum__rt__bool_record_output(i1 %27, ptr nonnull @25)
  tail call void @__quantum__rt__bool_record_output(i1 %28, ptr nonnull @26)
  tail call void @__quantum__rt__bool_record_output(i1 %29, ptr nonnull @27)
  tail call void @__quantum__rt__bool_record_output(i1 %30, ptr nonnull @28)
  tail call void @__quantum__rt__bool_record_output(i1 %31, ptr nonnull @29)
  ret void
}

declare void @___random_seed(i64) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__qis__rzz__body(double, ptr, ptr) local_unnamed_addr

declare noundef i32 @___random_int_bounded(i32) local_unnamed_addr

declare noundef range(i64 0, 4294967296) i64 @___get_current_shot() local_unnamed_addr

declare void @__quantum__qis__rz__body(double, ptr) local_unnamed_addr

declare void @__quantum__qis__barrier30__body(ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr) local_unnamed_addr

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="30" "required_num_results"="30" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
