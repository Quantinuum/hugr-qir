; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [9 x i8] c"s0___INT\00", align 1
@1 = private unnamed_addr constant [9 x i8] c"s1___INT\00", align 1
@2 = private unnamed_addr constant [8 x i8] c"c___INT\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 16 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 16 to ptr), ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 17 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 17 to ptr), ptr nonnull inttoptr (i64 1 to ptr))
  %1 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 18 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 18 to ptr), ptr nonnull inttoptr (i64 2 to ptr))
  %2 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr), ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 19 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 19 to ptr), ptr nonnull inttoptr (i64 3 to ptr))
  %3 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  %. = zext i1 %3 to i64
  %"0756.0" = select i1 %2, i64 2, i64 0
  %.6386 = select i1 %1, i64 4, i64 0
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  br i1 %2, label %bb, label %bb0

bb:                                               ; preds = %alloca_block
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %bb0

bb0:                                              ; preds = %alloca_block, %bb
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  br i1 %1, label %bb1, label %bb2

bb1:                                              ; preds = %bb0
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  br label %bb2

bb2:                                              ; preds = %bb0, %bb1
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  br i1 %0, label %bb3, label %bb4

bb3:                                              ; preds = %bb2
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  br label %bb4

bb4:                                              ; preds = %bb2, %bb3
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  br i1 %3, label %bb5, label %cond_4934_case_1

bb5:                                              ; preds = %bb4
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  br label %cond_4934_case_1

cond_4934_case_1:                                 ; preds = %bb4, %bb5
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  %.6387 = select i1 %0, i64 8, i64 0
  %4 = or disjoint i64 %.6386, %.6387
  %5 = or disjoint i64 %4, %"0756.0"
  %6 = or disjoint i64 %5, %.
  tail call void @__quantum__rt__int_record_output(i64 %6, ptr nonnull @0)
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 20 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 20 to ptr), ptr nonnull inttoptr (i64 4 to ptr))
  %7 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 21 to ptr), ptr nonnull inttoptr (i64 5 to ptr))
  %8 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 22 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 22 to ptr), ptr nonnull inttoptr (i64 6 to ptr))
  %9 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr), ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 23 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 23 to ptr), ptr nonnull inttoptr (i64 7 to ptr))
  %10 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  %"03072.0" = select i1 %10, i64 8, i64 -1
  %"03114.0" = select i1 %9, i64 4, i64 -1
  %"03156.0" = select i1 %8, i64 2, i64 -1
  %"03198.0" = select i1 %7, i64 1, i64 -1
  %11 = add nsw i64 %"03156.0", %"03198.0"
  %12 = add nsw i64 %11, %"03114.0"
  %13 = add nsw i64 %12, %"03072.0"
  %Pivot6425 = icmp slt i64 %13, 9
  br i1 %Pivot6425, label %NodeBlock6412, label %NodeBlock6422

NodeBlock6422:                                    ; preds = %cond_4934_case_1
  %Pivot6423 = icmp samesign ult i64 %13, 12
  br i1 %Pivot6423, label %NodeBlock6416, label %NodeBlock6420

NodeBlock6420:                                    ; preds = %NodeBlock6422
  %Pivot6421 = icmp samesign ult i64 %13, 15
  br i1 %Pivot6421, label %LeafBlock6418, label %bb6

LeafBlock6418:                                    ; preds = %NodeBlock6420
  %SwitchLeaf6419 = icmp eq i64 %13, 12
  br i1 %SwitchLeaf6419, label %.thread6402, label %.fold.split6393

NodeBlock6416:                                    ; preds = %NodeBlock6422
  br label %NodeBlock6428

NodeBlock6428:                                    ; preds = %NodeBlock6416
  %Pivot = icmp slt i64 %13, 10
  br i1 %Pivot, label %.thread6400, label %LeafBlock6426

LeafBlock6426:                                    ; preds = %NodeBlock6428
  %SwitchLeaf6427 = icmp eq i64 %13, 10
  br i1 %SwitchLeaf6427, label %.thread6402, label %.fold.split6393

NodeBlock6412:                                    ; preds = %cond_4934_case_1
  %Pivot6413 = icmp slt i64 %13, 5
  br i1 %Pivot6413, label %LeafBlock, label %NodeBlock

NodeBlock:                                        ; preds = %NodeBlock6412
  br label %NodeBlock6431

NodeBlock6431:                                    ; preds = %NodeBlock
  %Pivot6432 = icmp slt i64 %13, 6
  br i1 %Pivot6432, label %.thread6402, label %LeafBlock6429

LeafBlock6429:                                    ; preds = %NodeBlock6431
  %SwitchLeaf6430 = icmp eq i64 %13, 6
  br i1 %SwitchLeaf6430, label %.thread6402.fold.split, label %.fold.split6393

LeafBlock:                                        ; preds = %NodeBlock6412
  %SwitchLeaf = icmp eq i64 %13, 3
  br i1 %SwitchLeaf, label %.thread6402, label %.fold.split6393

.fold.split6393:                                  ; preds = %LeafBlock6429, %LeafBlock6426, %LeafBlock6418, %LeafBlock
  br label %.thread6402

.thread6400:                                      ; preds = %NodeBlock6428
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  br label %.thread6402

bb6:                                              ; preds = %NodeBlock6420
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  br label %.thread6402

.thread6402.fold.split:                           ; preds = %LeafBlock6429
  br label %.thread6402

.thread6402:                                      ; preds = %NodeBlock6431, %LeafBlock6426, %.thread6402.fold.split, %LeafBlock, %LeafBlock6418, %.fold.split6393, %.thread6400, %bb6
  %14 = phi i1 [ false, %.thread6400 ], [ true, %bb6 ], [ false, %.fold.split6393 ], [ false, %LeafBlock6418 ], [ false, %NodeBlock6431 ], [ false, %LeafBlock ], [ false, %LeafBlock6426 ], [ false, %.thread6402.fold.split ]
  %15 = phi i1 [ false, %.thread6400 ], [ false, %bb6 ], [ false, %.fold.split6393 ], [ false, %LeafBlock6418 ], [ false, %NodeBlock6431 ], [ false, %LeafBlock ], [ false, %LeafBlock6426 ], [ true, %.thread6402.fold.split ]
  %16 = phi i1 [ false, %.thread6400 ], [ false, %bb6 ], [ false, %.fold.split6393 ], [ true, %LeafBlock6418 ], [ false, %NodeBlock6431 ], [ false, %LeafBlock ], [ false, %LeafBlock6426 ], [ false, %.thread6402.fold.split ]
  %17 = phi i1 [ false, %.thread6400 ], [ false, %bb6 ], [ false, %.fold.split6393 ], [ false, %LeafBlock6418 ], [ true, %NodeBlock6431 ], [ false, %LeafBlock ], [ false, %LeafBlock6426 ], [ false, %.thread6402.fold.split ]
  %18 = phi i1 [ false, %.thread6400 ], [ false, %bb6 ], [ false, %.fold.split6393 ], [ false, %LeafBlock6418 ], [ false, %NodeBlock6431 ], [ false, %LeafBlock ], [ true, %LeafBlock6426 ], [ false, %.thread6402.fold.split ]
  %19 = phi i1 [ false, %.thread6400 ], [ false, %bb6 ], [ false, %.fold.split6393 ], [ false, %LeafBlock6418 ], [ false, %NodeBlock6431 ], [ true, %LeafBlock ], [ false, %LeafBlock6426 ], [ false, %.thread6402.fold.split ]
  %20 = phi i1 [ true, %.thread6400 ], [ true, %bb6 ], [ false, %.fold.split6393 ], [ false, %LeafBlock6418 ], [ false, %NodeBlock6431 ], [ false, %LeafBlock ], [ false, %LeafBlock6426 ], [ false, %.thread6402.fold.split ]
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 15 to ptr), ptr nonnull inttoptr (i64 8 to ptr))
  %21 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 8 to ptr))
  br i1 %14, label %bb7, label %bb8

bb7:                                              ; preds = %.thread6402
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  br label %bb8

bb8:                                              ; preds = %bb7, %.thread6402
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  %22 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 9 to ptr))
  br i1 %15, label %bb9, label %bb10

bb9:                                              ; preds = %bb8
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  br label %bb10

bb10:                                             ; preds = %bb9, %bb8
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 10 to ptr))
  %23 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  %24 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 11 to ptr))
  br i1 %16, label %bb11, label %bb12

bb11:                                             ; preds = %bb10
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  br label %bb12

bb12:                                             ; preds = %bb10, %bb11
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 12 to ptr))
  %25 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 12 to ptr))
  br i1 %16, label %bb13, label %bb14

bb13:                                             ; preds = %bb12
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  br label %bb14

bb14:                                             ; preds = %bb12, %bb13
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 13 to ptr))
  %26 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 13 to ptr))
  br i1 %17, label %bb15, label %bb16

bb15:                                             ; preds = %bb14
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  br label %bb16

bb16:                                             ; preds = %bb15, %bb14
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 14 to ptr))
  %27 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 14 to ptr))
  br i1 %18, label %bb17, label %bb18

bb17:                                             ; preds = %bb16
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  br label %bb18

bb18:                                             ; preds = %bb17, %bb16
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 15 to ptr))
  %28 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 15 to ptr))
  br i1 %19, label %bb19, label %bb20

bb19:                                             ; preds = %bb18
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  br label %bb20

bb20:                                             ; preds = %bb18, %bb19
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 16 to ptr))
  %29 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 16 to ptr))
  br i1 %19, label %bb21, label %bb22

bb21:                                             ; preds = %bb20
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  br label %bb22

bb22:                                             ; preds = %bb21, %bb20
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 17 to ptr))
  %30 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 17 to ptr))
  br i1 %17, label %bb23, label %bb24

bb23:                                             ; preds = %bb22
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  br label %bb24

bb24:                                             ; preds = %bb23, %bb22
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 18 to ptr))
  %31 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 18 to ptr))
  br i1 %18, label %bb25, label %bb26

bb25:                                             ; preds = %bb24
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  br label %bb26

bb26:                                             ; preds = %bb24, %bb25
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 19 to ptr))
  %32 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 19 to ptr))
  br i1 %14, label %bb27, label %bb28

bb27:                                             ; preds = %bb26
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  br label %bb28

bb28:                                             ; preds = %bb26, %bb27
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 20 to ptr))
  %33 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 20 to ptr))
  br i1 %20, label %bb29, label %bb30

bb29:                                             ; preds = %bb28
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  br label %bb30

bb30:                                             ; preds = %bb29, %bb28
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 21 to ptr))
  %34 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 21 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 22 to ptr))
  %35 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 22 to ptr))
  br i1 %15, label %bb31, label %bb32

bb31:                                             ; preds = %bb30
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  br label %bb32

bb32:                                             ; preds = %bb31, %bb30
  %"03224.0" = select i1 %7, i64 8, i64 0
  %"03182.0" = select i1 %8, i64 4, i64 0
  %"03140.0" = select i1 %9, i64 2, i64 0
  %"03098.0" = zext i1 %10 to i64
  tail call void @__quantum__qis__mz__body(ptr null, ptr nonnull inttoptr (i64 23 to ptr))
  %36 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 23 to ptr))
  %37 = or disjoint i64 %"03182.0", %"03224.0"
  %38 = or disjoint i64 %37, %"03140.0"
  %39 = or disjoint i64 %38, %"03098.0"
  tail call void @__quantum__rt__int_record_output(i64 %39, ptr nonnull @1)
  %.6388 = zext i1 %21 to i64
  %"05450.0" = select i1 %22, i64 2, i64 0
  %"05465.0" = select i1 %23, i64 4, i64 0
  %"05480.0" = select i1 %24, i64 8, i64 0
  %"05495.0" = select i1 %25, i64 16, i64 0
  %"05510.0" = select i1 %26, i64 32, i64 0
  %"05525.0" = select i1 %27, i64 64, i64 0
  %"05540.0" = select i1 %28, i64 128, i64 0
  %"05555.0" = select i1 %29, i64 256, i64 0
  %"05570.0" = select i1 %30, i64 512, i64 0
  %"05585.0" = select i1 %31, i64 1024, i64 0
  %"05600.0" = select i1 %32, i64 2048, i64 0
  %"05615.0" = select i1 %33, i64 4096, i64 0
  %"05630.0" = select i1 %34, i64 8192, i64 0
  %"05645.0" = select i1 %35, i64 16384, i64 0
  %"05660.0" = select i1 %36, i64 32768, i64 0
  %40 = or disjoint i64 %"05450.0", %.6388
  %41 = or disjoint i64 %40, %"05465.0"
  %42 = or disjoint i64 %41, %"05480.0"
  %43 = or disjoint i64 %42, %"05495.0"
  %44 = or disjoint i64 %43, %"05510.0"
  %45 = or i64 %44, %"05525.0"
  %46 = or i64 %45, %"05540.0"
  %47 = or i64 %46, %"05555.0"
  %48 = or i64 %47, %"05570.0"
  %49 = or i64 %48, %"05585.0"
  %50 = or i64 %49, %"05600.0"
  %51 = or i64 %50, %"05615.0"
  %52 = or i64 %51, %"05630.0"
  %53 = or i64 %52, %"05645.0"
  %54 = or i64 %53, %"05660.0"
  tail call void @__quantum__rt__int_record_output(i64 %54, ptr nonnull @2)
  ret void
}

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__qis__rz__body(double, ptr) local_unnamed_addr

declare void @__quantum__qis__rzz__body(double, ptr, ptr) local_unnamed_addr

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="24" "required_num_results"="24" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
