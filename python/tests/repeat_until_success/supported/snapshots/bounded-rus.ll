; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [9 x i8] c"attempts\00", align 1
@1 = private unnamed_addr constant [8 x i8] c"success\00", align 1
@2 = private unnamed_addr constant [2 x i8] c"q\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 1 to ptr), ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  br i1 %0, label %.critedge, label %bb0

bb:                                               ; preds = %bb0
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %.critedge

bb0:                                              ; preds = %alloca_block
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 1 to ptr))
  %1 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 1 to ptr))
  br i1 %1, label %bb, label %.thread2094

.critedge:                                        ; preds = %bb, %alloca_block
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 2 to ptr))
  %2 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 2 to ptr))
  br i1 %2, label %cond_1126_case_1, label %bb2

bb1:                                              ; preds = %bb2
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_1126_case_1

bb2:                                              ; preds = %.critedge
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 3 to ptr))
  %3 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 3 to ptr))
  br i1 %3, label %bb1, label %.thread2094

cond_1126_case_1:                                 ; preds = %bb1, %.critedge
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 4 to ptr))
  %4 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 4 to ptr))
  br i1 %4, label %cond_1256_case_1, label %bb4

bb3:                                              ; preds = %bb4
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_1256_case_1

bb4:                                              ; preds = %cond_1126_case_1
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 5 to ptr))
  %5 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 5 to ptr))
  br i1 %5, label %bb3, label %.thread2094

cond_1256_case_1:                                 ; preds = %bb3, %cond_1126_case_1
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 6 to ptr))
  %6 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 6 to ptr))
  br i1 %6, label %cond_1386_case_1, label %bb6

bb5:                                              ; preds = %bb6
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_1386_case_1

bb6:                                              ; preds = %cond_1256_case_1
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 7 to ptr))
  %7 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 7 to ptr))
  br i1 %7, label %bb5, label %.thread2094

cond_1386_case_1:                                 ; preds = %bb5, %cond_1256_case_1
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 8 to ptr))
  %8 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 8 to ptr))
  br i1 %8, label %cond_1516_case_1, label %bb8

bb7:                                              ; preds = %bb8
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_1516_case_1

bb8:                                              ; preds = %cond_1386_case_1
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  %9 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 9 to ptr))
  br i1 %9, label %bb7, label %.thread2094

cond_1516_case_1:                                 ; preds = %bb7, %cond_1386_case_1
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 10 to ptr))
  %10 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 10 to ptr))
  br i1 %10, label %cond_1646_case_1, label %bb10

bb9:                                              ; preds = %bb10
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_1646_case_1

bb10:                                             ; preds = %cond_1516_case_1
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  %11 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 11 to ptr))
  br i1 %11, label %bb9, label %.thread2094

cond_1646_case_1:                                 ; preds = %bb9, %cond_1516_case_1
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 12 to ptr))
  %12 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 12 to ptr))
  br i1 %12, label %cond_1776_case_1, label %bb12

bb11:                                             ; preds = %bb12
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_1776_case_1

bb12:                                             ; preds = %cond_1646_case_1
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 13 to ptr))
  %13 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 13 to ptr))
  br i1 %13, label %bb11, label %.thread2094

cond_1776_case_1:                                 ; preds = %bb11, %cond_1646_case_1
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr), ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 15 to ptr), ptr nonnull inttoptr (i64 14 to ptr))
  %14 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 14 to ptr))
  br i1 %14, label %cond_1906_case_1, label %bb14

bb13:                                             ; preds = %bb14
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_1906_case_1

bb14:                                             ; preds = %cond_1776_case_1
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 16 to ptr), ptr nonnull inttoptr (i64 15 to ptr))
  %15 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 15 to ptr))
  br i1 %15, label %bb13, label %.thread2094

cond_1906_case_1:                                 ; preds = %bb13, %cond_1776_case_1
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr), ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 17 to ptr), ptr nonnull inttoptr (i64 16 to ptr))
  %16 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 16 to ptr))
  br i1 %16, label %cond_2036_case_1, label %bb16

bb15:                                             ; preds = %bb16
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_2036_case_1

bb16:                                             ; preds = %cond_1906_case_1
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 18 to ptr), ptr nonnull inttoptr (i64 17 to ptr))
  %17 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 17 to ptr))
  br i1 %17, label %bb15, label %.thread2094

cond_2036_case_1:                                 ; preds = %bb15, %cond_1906_case_1
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr), ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 19 to ptr), ptr nonnull inttoptr (i64 18 to ptr))
  %18 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 18 to ptr))
  br i1 %18, label %.thread2094, label %bb18

.thread2094:                                      ; preds = %bb17, %bb18, %cond_2036_case_1, %bb16, %bb14, %bb12, %bb10, %bb8, %bb6, %bb4, %bb0, %bb2
  %"11715.0" = phi i64 [ 2, %bb2 ], [ 1, %bb0 ], [ 3, %bb4 ], [ 4, %bb6 ], [ 5, %bb8 ], [ 6, %bb10 ], [ 7, %bb12 ], [ 8, %bb14 ], [ 9, %bb16 ], [ 10, %cond_2036_case_1 ], [ 10, %bb18 ], [ 10, %bb17 ]
  %"01714.0" = phi i1 [ true, %bb2 ], [ true, %bb0 ], [ true, %bb4 ], [ true, %bb6 ], [ true, %bb8 ], [ true, %bb10 ], [ true, %bb12 ], [ true, %bb14 ], [ true, %bb16 ], [ false, %cond_2036_case_1 ], [ true, %bb18 ], [ false, %bb17 ]
  tail call void @__quantum__rt__int_record_output(i64 %"11715.0", ptr nonnull @0)
  tail call void @__quantum__rt__bool_record_output(i1 %"01714.0", ptr nonnull @1)
  tail call void @__quantum__qis__mz__body(ptr null, ptr nonnull inttoptr (i64 19 to ptr))
  %19 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %19, ptr nonnull @2)
  ret void

bb17:                                             ; preds = %bb18
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %.thread2094

bb18:                                             ; preds = %cond_2036_case_1
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FE921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 20 to ptr), ptr nonnull inttoptr (i64 20 to ptr))
  %20 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 20 to ptr))
  br i1 %20, label %bb17, label %.thread2094
}

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__qis__rz__body(double, ptr) local_unnamed_addr

declare void @__quantum__qis__rzz__body(double, ptr, ptr) local_unnamed_addr

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, ptr) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="21" "required_num_results"="21" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
