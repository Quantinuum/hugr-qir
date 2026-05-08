; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [9 x i8] c"attempts\00", align 1
@1 = private unnamed_addr constant [8 x i8] c"success\00", align 1
@2 = private unnamed_addr constant [2 x i8] c"q\00", align 1

define void @__hugr__.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
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
  br i1 %0, label %.critedge, label %cond_869_case_1

cond_869_case_1:                                  ; preds = %alloca_block
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
  br i1 %1, label %bb, label %cond_exit_285

bb:                                               ; preds = %cond_869_case_1
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %.critedge

.critedge:                                        ; preds = %alloca_block, %bb
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
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
  br i1 %2, label %cond_1896_case_1, label %cond_961_case_1

cond_961_case_1:                                  ; preds = %.critedge
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
  br i1 %3, label %bb0, label %cond_exit_285

bb0:                                              ; preds = %cond_961_case_1
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_1896_case_1

cond_1896_case_1:                                 ; preds = %.critedge, %bb0
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
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
  br i1 %4, label %cond_2026_case_1, label %cond_1043_case_1

cond_1043_case_1:                                 ; preds = %cond_1896_case_1
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
  br i1 %5, label %bb1, label %cond_exit_285

bb1:                                              ; preds = %cond_1043_case_1
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_2026_case_1

cond_2026_case_1:                                 ; preds = %cond_1896_case_1, %bb1
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
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
  br i1 %6, label %cond_2156_case_1, label %cond_1125_case_1

cond_1125_case_1:                                 ; preds = %cond_2026_case_1
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
  br i1 %7, label %bb2, label %cond_exit_285

bb2:                                              ; preds = %cond_1125_case_1
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_2156_case_1

cond_2156_case_1:                                 ; preds = %cond_2026_case_1, %bb2
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
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
  br i1 %8, label %cond_2286_case_1, label %cond_1207_case_1

cond_1207_case_1:                                 ; preds = %cond_2156_case_1
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
  br i1 %9, label %bb3, label %cond_exit_285

bb3:                                              ; preds = %cond_1207_case_1
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_2286_case_1

cond_2286_case_1:                                 ; preds = %cond_2156_case_1, %bb3
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
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
  br i1 %10, label %cond_2416_case_1, label %cond_1289_case_1

cond_1289_case_1:                                 ; preds = %cond_2286_case_1
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
  br i1 %11, label %bb4, label %cond_exit_285

bb4:                                              ; preds = %cond_1289_case_1
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_2416_case_1

cond_2416_case_1:                                 ; preds = %cond_2286_case_1, %bb4
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
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
  br i1 %12, label %cond_2546_case_1, label %cond_1371_case_1

cond_1371_case_1:                                 ; preds = %cond_2416_case_1
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
  br i1 %13, label %bb5, label %cond_exit_285

bb5:                                              ; preds = %cond_1371_case_1
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_2546_case_1

cond_2546_case_1:                                 ; preds = %cond_2416_case_1, %bb5
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
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
  br i1 %14, label %cond_2676_case_1, label %cond_1453_case_1

cond_1453_case_1:                                 ; preds = %cond_2546_case_1
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
  br i1 %15, label %bb6, label %cond_exit_285

bb6:                                              ; preds = %cond_1453_case_1
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_2676_case_1

cond_2676_case_1:                                 ; preds = %cond_2546_case_1, %bb6
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
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
  br i1 %16, label %cond_2806_case_1, label %cond_1535_case_1

cond_1535_case_1:                                 ; preds = %cond_2676_case_1
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
  br i1 %17, label %bb7, label %cond_exit_285

bb7:                                              ; preds = %cond_1535_case_1
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_2806_case_1

cond_2806_case_1:                                 ; preds = %cond_2676_case_1, %bb7
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFE921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
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
  br i1 %18, label %cond_exit_285, label %cond_1617_case_1

cond_1617_case_1:                                 ; preds = %cond_2806_case_1
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
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 20 to ptr), ptr nonnull inttoptr (i64 19 to ptr))
  %19 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 19 to ptr))
  br i1 %19, label %bb8, label %cond_exit_285

bb8:                                              ; preds = %cond_1617_case_1
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %cond_exit_285

cond_exit_285:                                    ; preds = %cond_961_case_1, %cond_869_case_1, %cond_1043_case_1, %cond_1125_case_1, %cond_1207_case_1, %cond_1289_case_1, %cond_1371_case_1, %cond_1453_case_1, %cond_1535_case_1, %cond_1617_case_1, %cond_2806_case_1, %bb8
  %"12641.0" = phi i64 [ 10, %bb8 ], [ 10, %cond_2806_case_1 ], [ 10, %cond_1617_case_1 ], [ 9, %cond_1535_case_1 ], [ 8, %cond_1453_case_1 ], [ 7, %cond_1371_case_1 ], [ 6, %cond_1289_case_1 ], [ 5, %cond_1207_case_1 ], [ 4, %cond_1125_case_1 ], [ 3, %cond_1043_case_1 ], [ 2, %cond_961_case_1 ], [ 1, %cond_869_case_1 ]
  %"02640.sroa.3.0" = phi i1 [ false, %bb8 ], [ false, %cond_2806_case_1 ], [ true, %cond_1617_case_1 ], [ true, %cond_1535_case_1 ], [ true, %cond_1453_case_1 ], [ true, %cond_1371_case_1 ], [ true, %cond_1289_case_1 ], [ true, %cond_1207_case_1 ], [ true, %cond_1125_case_1 ], [ true, %cond_1043_case_1 ], [ true, %cond_961_case_1 ], [ true, %cond_869_case_1 ]
  tail call void @__quantum__rt__int_record_output(i64 %"12641.0", ptr nonnull @0)
  tail call void @__quantum__rt__bool_record_output(i1 %"02640.sroa.3.0", ptr nonnull @1)
  tail call void @__quantum__qis__mz__body(ptr null, ptr nonnull inttoptr (i64 20 to ptr))
  %20 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %20, ptr nonnull @2)
  ret void
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
