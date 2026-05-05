; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

@0 = private unnamed_addr constant [3 x i8] c"s0\00", align 1
@1 = private unnamed_addr constant [3 x i8] c"s1\00", align 1
@2 = private unnamed_addr constant [2 x i8] c"c\00", align 1

define dso_local void @__hugr__.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 4 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 4 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 6 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 6 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 8 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 8 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 9 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 9 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 10 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 10 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 11 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 11 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 12 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 12 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 13 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 13 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 14 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 14 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 4 to %Qubit*), %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 4 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 5 to %Qubit*), %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 8 to %Qubit*), %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 8 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 9 to %Qubit*), %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 9 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 16 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 16 to %Qubit*), %Result* null)
  %0 = tail call i1 @__quantum__qis__read_result__body(%Result* null)
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 6 to %Qubit*), %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 6 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 7 to %Qubit*), %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 10 to %Qubit*), %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 10 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 11 to %Qubit*), %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 11 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 17 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 17 to %Qubit*), %Result* nonnull inttoptr (i64 1 to %Result*))
  %1 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 1 to %Result*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 12 to %Qubit*), %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 12 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 13 to %Qubit*), %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 13 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* null, %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 1 to %Qubit*), %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 18 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 18 to %Qubit*), %Result* nonnull inttoptr (i64 2 to %Result*))
  %2 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 2 to %Result*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 14 to %Qubit*), %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 14 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*), %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*), %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*), %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 19 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 19 to %Qubit*), %Result* nonnull inttoptr (i64 3 to %Result*))
  %3 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 3 to %Result*))
  %"2706_0.0" = select i1 %0, i64 8, i64 0
  %"2741_0.0" = select i1 %1, i64 4, i64 0
  %"2776_0.0" = select i1 %2, i64 2, i64 0
  %"2811_0.0" = zext i1 %3 to i64
  %4 = or i64 %"2741_0.0", %"2706_0.0"
  %5 = or i64 %4, %"2776_0.0"
  %6 = or i64 %5, %"2811_0.0"
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 14 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 14 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* null)
  br i1 %2, label %7, label %cond_exit_3153

7:                                                ; preds = %alloca_block
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* null)
  br label %cond_exit_3153

cond_exit_3153:                                   ; preds = %alloca_block, %7
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  br i1 %3, label %8, label %cond_3567_case_0

cond_3567_case_0:                                 ; preds = %cond_exit_3153, %8
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 13 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 13 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 12 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 12 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 11 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 11 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 10 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 10 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 6 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 6 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 9 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 9 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 8 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 8 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 4 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 4 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 4 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 4 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 6 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 6 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  br i1 %0, label %9, label %cond_exit_4625

8:                                                ; preds = %cond_exit_3153
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  br label %cond_3567_case_0

9:                                                ; preds = %cond_3567_case_0
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 8 to %Qubit*))
  br label %cond_exit_4625

cond_exit_4625:                                   ; preds = %cond_3567_case_0, %9
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 8 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 8 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 9 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 9 to %Qubit*))
  br i1 %1, label %10, label %cond_exit_4993

10:                                               ; preds = %cond_exit_4625
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 10 to %Qubit*))
  br label %cond_exit_4993

cond_exit_4993:                                   ; preds = %10, %cond_exit_4625
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 10 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 10 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 11 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 11 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 12 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 12 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 13 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 13 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 14 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 14 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 1 to %Qubit*), %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*), %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 5 to %Qubit*), %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 6 to %Qubit*), %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 6 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 20 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 20 to %Qubit*), %Result* nonnull inttoptr (i64 4 to %Result*))
  %11 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 4 to %Result*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*), %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* null, %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 7 to %Qubit*), %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 4 to %Qubit*), %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 4 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 21 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 21 to %Qubit*), %Result* nonnull inttoptr (i64 5 to %Result*))
  %12 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 5 to %Result*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 9 to %Qubit*), %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 9 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 10 to %Qubit*), %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 10 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 13 to %Qubit*), %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 13 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 14 to %Qubit*), %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 14 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 22 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 22 to %Qubit*), %Result* nonnull inttoptr (i64 6 to %Result*))
  %13 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 6 to %Result*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 11 to %Qubit*), %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 11 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 8 to %Qubit*), %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 8 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*), %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, %Qubit* nonnull inttoptr (i64 12 to %Qubit*), %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 12 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 23 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 23 to %Qubit*), %Result* nonnull inttoptr (i64 7 to %Result*))
  %14 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 7 to %Result*))
  %"6587_0.0" = select i1 %11, i64 8, i64 0
  %"6622_0.0" = select i1 %12, i64 4, i64 0
  %"6657_0.0" = select i1 %13, i64 2, i64 0
  %"6692_0.0" = zext i1 %14 to i64
  %15 = or i64 %"6622_0.0", %"6587_0.0"
  %16 = or i64 %15, %"6657_0.0"
  %17 = or i64 %16, %"6692_0.0"
  %"05733.0" = select i1 %11, i64 1, i64 -1
  %"05776.0" = select i1 %12, i64 2, i64 -1
  %"05819.0" = select i1 %13, i64 4, i64 -1
  %"05862.0" = select i1 %14, i64 8, i64 -1
  %18 = add nsw i64 %"05776.0", %"05733.0"
  %19 = add nsw i64 %18, %"05819.0"
  %20 = add nsw i64 %19, %"05862.0"
  %Pivot12891 = icmp slt i64 %20, 9
  br i1 %Pivot12891, label %NodeBlock12878, label %NodeBlock12888

NodeBlock12888:                                   ; preds = %cond_exit_4993
  %Pivot12889 = icmp ult i64 %20, 12
  br i1 %Pivot12889, label %NodeBlock12882, label %NodeBlock12886

NodeBlock12886:                                   ; preds = %NodeBlock12888
  %Pivot12887 = icmp ult i64 %20, 15
  br i1 %Pivot12887, label %LeafBlock12884, label %cond_7219_case_0

LeafBlock12884:                                   ; preds = %NodeBlock12886
  %SwitchLeaf12885 = icmp eq i64 %20, 12
  br i1 %SwitchLeaf12885, label %cond_7219_case_0, label %cond_7219_case_0.fold.split12873

NodeBlock12882:                                   ; preds = %NodeBlock12888
  %Pivot12883 = icmp ult i64 %20, 10
  br i1 %Pivot12883, label %cond_7219_case_0, label %LeafBlock12880

LeafBlock12880:                                   ; preds = %NodeBlock12882
  %SwitchLeaf12881 = icmp eq i64 %20, 10
  br i1 %SwitchLeaf12881, label %cond_7219_case_0, label %cond_7219_case_0.fold.split12873

NodeBlock12878:                                   ; preds = %cond_exit_4993
  %Pivot12879 = icmp slt i64 %20, 5
  br i1 %Pivot12879, label %LeafBlock, label %NodeBlock12924

NodeBlock12924:                                   ; preds = %NodeBlock12878
  %Pivot = icmp slt i64 %20, 6
  br i1 %Pivot, label %cond_7219_case_0, label %LeafBlock12922

LeafBlock12922:                                   ; preds = %NodeBlock12924
  %SwitchLeaf12923 = icmp eq i64 %20, 6
  br i1 %SwitchLeaf12923, label %cond_7219_case_0, label %cond_7219_case_0.fold.split12873

LeafBlock:                                        ; preds = %NodeBlock12878
  %SwitchLeaf = icmp eq i64 %20, 3
  br i1 %SwitchLeaf, label %cond_7219_case_0, label %cond_7219_case_0.fold.split12873

cond_7219_case_0.fold.split12873:                 ; preds = %LeafBlock12922, %LeafBlock, %LeafBlock12880, %LeafBlock12884
  br label %cond_7219_case_0

cond_7219_case_0:                                 ; preds = %LeafBlock12922, %NodeBlock12924, %NodeBlock12886, %LeafBlock, %NodeBlock12882, %LeafBlock12880, %LeafBlock12884, %cond_7219_case_0.fold.split12873
  %21 = phi i1 [ false, %LeafBlock12884 ], [ false, %cond_7219_case_0.fold.split12873 ], [ false, %LeafBlock12880 ], [ false, %NodeBlock12882 ], [ false, %NodeBlock12924 ], [ false, %LeafBlock ], [ true, %NodeBlock12886 ], [ false, %LeafBlock12922 ]
  %22 = phi i1 [ false, %LeafBlock12884 ], [ false, %cond_7219_case_0.fold.split12873 ], [ false, %LeafBlock12880 ], [ true, %NodeBlock12882 ], [ false, %NodeBlock12924 ], [ false, %LeafBlock ], [ false, %NodeBlock12886 ], [ false, %LeafBlock12922 ]
  %Pivot12909 = phi i1 [ false, %LeafBlock12884 ], [ true, %cond_7219_case_0.fold.split12873 ], [ false, %LeafBlock12880 ], [ false, %NodeBlock12882 ], [ false, %NodeBlock12924 ], [ true, %LeafBlock ], [ true, %NodeBlock12886 ], [ false, %LeafBlock12922 ]
  %Pivot12907 = phi i1 [ false, %LeafBlock12884 ], [ true, %cond_7219_case_0.fold.split12873 ], [ true, %LeafBlock12880 ], [ false, %NodeBlock12882 ], [ false, %NodeBlock12924 ], [ true, %LeafBlock ], [ true, %NodeBlock12886 ], [ false, %LeafBlock12922 ]
  %SwitchLeaf12905 = phi i1 [ false, %LeafBlock12884 ], [ false, %cond_7219_case_0.fold.split12873 ], [ false, %LeafBlock12880 ], [ false, %NodeBlock12882 ], [ true, %NodeBlock12924 ], [ false, %LeafBlock ], [ false, %NodeBlock12886 ], [ false, %LeafBlock12922 ]
  %Pivot12916 = phi i1 [ true, %LeafBlock12884 ], [ true, %cond_7219_case_0.fold.split12873 ], [ true, %LeafBlock12880 ], [ false, %NodeBlock12882 ], [ true, %NodeBlock12924 ], [ true, %LeafBlock ], [ true, %NodeBlock12886 ], [ false, %LeafBlock12922 ]
  %23 = phi i1 [ false, %LeafBlock12884 ], [ false, %cond_7219_case_0.fold.split12873 ], [ false, %LeafBlock12880 ], [ false, %NodeBlock12882 ], [ false, %NodeBlock12924 ], [ false, %LeafBlock ], [ false, %NodeBlock12886 ], [ true, %LeafBlock12922 ]
  %24 = phi i1 [ false, %LeafBlock12884 ], [ false, %cond_7219_case_0.fold.split12873 ], [ false, %LeafBlock12880 ], [ true, %NodeBlock12882 ], [ false, %NodeBlock12924 ], [ false, %LeafBlock ], [ true, %NodeBlock12886 ], [ false, %LeafBlock12922 ]
  %25 = phi i1 [ true, %LeafBlock12884 ], [ false, %cond_7219_case_0.fold.split12873 ], [ false, %LeafBlock12880 ], [ false, %NodeBlock12882 ], [ false, %NodeBlock12924 ], [ false, %LeafBlock ], [ false, %NodeBlock12886 ], [ false, %LeafBlock12922 ]
  %Pivot12900 = phi i1 [ false, %LeafBlock12884 ], [ true, %cond_7219_case_0.fold.split12873 ], [ true, %LeafBlock12880 ], [ true, %NodeBlock12882 ], [ false, %NodeBlock12924 ], [ false, %LeafBlock ], [ true, %NodeBlock12886 ], [ true, %LeafBlock12922 ]
  %Pivot12898 = phi i1 [ false, %LeafBlock12884 ], [ true, %cond_7219_case_0.fold.split12873 ], [ true, %LeafBlock12880 ], [ true, %NodeBlock12882 ], [ true, %NodeBlock12924 ], [ false, %LeafBlock ], [ true, %NodeBlock12886 ], [ true, %LeafBlock12922 ]
  %SwitchLeaf12896 = phi i1 [ false, %LeafBlock12884 ], [ false, %cond_7219_case_0.fold.split12873 ], [ false, %LeafBlock12880 ], [ false, %NodeBlock12882 ], [ false, %NodeBlock12924 ], [ true, %LeafBlock ], [ false, %NodeBlock12886 ], [ false, %LeafBlock12922 ]
  %SwitchLeaf12894 = phi i1 [ false, %LeafBlock12884 ], [ false, %cond_7219_case_0.fold.split12873 ], [ true, %LeafBlock12880 ], [ false, %NodeBlock12882 ], [ false, %NodeBlock12924 ], [ false, %LeafBlock ], [ false, %NodeBlock12886 ], [ false, %LeafBlock12922 ]
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 12 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 12 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 8 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 8 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 11 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 11 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 14 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 14 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 13 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 13 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 10 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 10 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 9 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 9 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 4 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 4 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 7 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* null)
  br i1 %23, label %26, label %cond_7587_case_0

26:                                               ; preds = %cond_7219_case_0
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* null)
  br label %cond_7587_case_0

cond_7587_case_0:                                 ; preds = %cond_7219_case_0, %26
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 6 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 6 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  br i1 %24, label %27, label %cond_7817_case_0

27:                                               ; preds = %cond_7587_case_0
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 2 to %Qubit*))
  br label %cond_7817_case_0

cond_7817_case_0:                                 ; preds = %cond_7587_case_0, %27
  br i1 %21, label %28, label %NodeBlock12899

28:                                               ; preds = %cond_7817_case_0
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 3 to %Qubit*))
  br label %NodeBlock12899

NodeBlock12899:                                   ; preds = %28, %cond_7817_case_0
  br i1 %Pivot12900, label %LeafBlock12893, label %NodeBlock12897

NodeBlock12897:                                   ; preds = %NodeBlock12899
  %brmerge = or i1 %Pivot12898, %SwitchLeaf12896
  br i1 %Pivot12898, label %NodeBlock12897.dup, label %NodeBlock12897.dup12928

NodeBlock12897.dup:                               ; preds = %NodeBlock12897
  br i1 %brmerge, label %cond_8553_case_0.sink.split.dup, label %NodeBlock12908

cond_8553_case_0.sink.split.dup:                  ; preds = %NodeBlock12897.dup
  call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* inttoptr (i64 5 to %Qubit*))
  br label %NodeBlock12908

NodeBlock12897.dup12928:                          ; preds = %NodeBlock12897
  br i1 %brmerge, label %cond_8553_case_0.sink.split.dup12930, label %NodeBlock12908

cond_8553_case_0.sink.split.dup12930:             ; preds = %NodeBlock12897.dup12928
  call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* inttoptr (i64 6 to %Qubit*))
  br label %NodeBlock12908

LeafBlock12893:                                   ; preds = %NodeBlock12899
  br i1 %SwitchLeaf12894, label %cond_8553_case_0.sink.split.dup12931, label %NodeBlock12908

cond_8553_case_0.sink.split.dup12931:             ; preds = %LeafBlock12893
  call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* inttoptr (i64 4 to %Qubit*))
  br label %NodeBlock12908

NodeBlock12908:                                   ; preds = %LeafBlock12893, %cond_8553_case_0.sink.split.dup12931, %NodeBlock12897.dup12928, %cond_8553_case_0.sink.split.dup12930, %NodeBlock12897.dup, %cond_8553_case_0.sink.split.dup
  br i1 %Pivot12909, label %LeafBlock12902, label %NodeBlock12906

NodeBlock12906:                                   ; preds = %NodeBlock12908
  %brmerge12917 = or i1 %Pivot12907, %SwitchLeaf12905
  br i1 %Pivot12907, label %NodeBlock12906.dup, label %NodeBlock12906.dup12926

NodeBlock12906.dup:                               ; preds = %NodeBlock12906
  br i1 %brmerge12917, label %cond_9059_case_0.sink.split.dup, label %cond_9059_case_0

cond_9059_case_0.sink.split.dup:                  ; preds = %NodeBlock12906.dup
  call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* inttoptr (i64 8 to %Qubit*))
  br label %cond_9059_case_0

NodeBlock12906.dup12926:                          ; preds = %NodeBlock12906
  br i1 %brmerge12917, label %cond_9059_case_0.sink.split.dup12932, label %cond_9059_case_0

cond_9059_case_0.sink.split.dup12932:             ; preds = %NodeBlock12906.dup12926
  call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* inttoptr (i64 9 to %Qubit*))
  br label %cond_9059_case_0

LeafBlock12902:                                   ; preds = %NodeBlock12908
  br i1 %SwitchLeaf12896, label %cond_9059_case_0.sink.split.dup12933, label %cond_9059_case_0

cond_9059_case_0.sink.split.dup12933:             ; preds = %LeafBlock12902
  call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* inttoptr (i64 7 to %Qubit*))
  br label %cond_9059_case_0

cond_9059_case_0:                                 ; preds = %LeafBlock12902, %cond_9059_case_0.sink.split.dup12933, %NodeBlock12906.dup12926, %cond_9059_case_0.sink.split.dup12932, %NodeBlock12906.dup, %cond_9059_case_0.sink.split.dup
  br i1 %25, label %NodeBlock12915, label %NodeBlock12915.thread

NodeBlock12915:                                   ; preds = %cond_9059_case_0
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 10 to %Qubit*))
  %brmerge12920 = or i1 %Pivot12916, %23
  br i1 %Pivot12916, label %NodeBlock12915.dup, label %NodeBlock12915.dup12925

NodeBlock12915.dup:                               ; preds = %NodeBlock12915
  br i1 %brmerge12920, label %cond_9887_case_0.sink.split.dup, label %cond_9887_case_0

cond_9887_case_0.sink.split.dup:                  ; preds = %NodeBlock12915.dup
  call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* inttoptr (i64 11 to %Qubit*))
  br label %cond_9887_case_0

NodeBlock12915.dup12925:                          ; preds = %NodeBlock12915
  br i1 %brmerge12920, label %cond_9887_case_0.sink.split.dup12934, label %cond_9887_case_0

cond_9887_case_0.sink.split.dup12934:             ; preds = %NodeBlock12915.dup12925
  call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* inttoptr (i64 13 to %Qubit*))
  br label %cond_9887_case_0

NodeBlock12915.thread:                            ; preds = %cond_9059_case_0
  %.not = xor i1 %23, true
  %brmerge12919 = or i1 %Pivot12916, %.not
  br i1 %brmerge12919, label %cond_9887_case_0, label %cond_9887_case_0.sink.split.dup12935

cond_9887_case_0.sink.split.dup12935:             ; preds = %NodeBlock12915.thread
  call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* inttoptr (i64 13 to %Qubit*))
  br label %cond_9887_case_0

cond_9887_case_0:                                 ; preds = %NodeBlock12915.thread, %cond_9887_case_0.sink.split.dup12935, %NodeBlock12915.dup12925, %cond_9887_case_0.sink.split.dup12934, %NodeBlock12915.dup, %cond_9887_case_0.sink.split.dup
  br i1 %21, label %29, label %cond_10025_case_0

29:                                               ; preds = %cond_9887_case_0
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 14 to %Qubit*))
  br label %cond_10025_case_0

cond_10025_case_0:                                ; preds = %cond_9887_case_0, %29
  br i1 %22, label %30, label %cond_10117_case_0

30:                                               ; preds = %cond_10025_case_0
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*))
  br label %cond_10117_case_0

cond_10117_case_0:                                ; preds = %30, %cond_10025_case_0
  br i1 %21, label %62, label %cond_10152_case_1

cond_10152_case_1:                                ; preds = %cond_10117_case_0, %62
  tail call void @__quantum__qis__mz__body(%Qubit* null, %Result* nonnull inttoptr (i64 8 to %Result*))
  %31 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 8 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 1 to %Qubit*), %Result* nonnull inttoptr (i64 9 to %Result*))
  %32 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 9 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 2 to %Qubit*), %Result* nonnull inttoptr (i64 10 to %Result*))
  %33 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 10 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 3 to %Qubit*), %Result* nonnull inttoptr (i64 11 to %Result*))
  %34 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 11 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 4 to %Qubit*), %Result* nonnull inttoptr (i64 12 to %Result*))
  %35 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 12 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 5 to %Qubit*), %Result* nonnull inttoptr (i64 13 to %Result*))
  %36 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 13 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 6 to %Qubit*), %Result* nonnull inttoptr (i64 14 to %Result*))
  %37 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 14 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 7 to %Qubit*), %Result* nonnull inttoptr (i64 15 to %Result*))
  %38 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 15 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 8 to %Qubit*), %Result* nonnull inttoptr (i64 16 to %Result*))
  %39 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 16 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 9 to %Qubit*), %Result* nonnull inttoptr (i64 17 to %Result*))
  %40 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 17 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 10 to %Qubit*), %Result* nonnull inttoptr (i64 18 to %Result*))
  %41 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 18 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 11 to %Qubit*), %Result* nonnull inttoptr (i64 19 to %Result*))
  %42 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 19 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 12 to %Qubit*), %Result* nonnull inttoptr (i64 20 to %Result*))
  %43 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 20 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 13 to %Qubit*), %Result* nonnull inttoptr (i64 21 to %Result*))
  %44 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 21 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 14 to %Qubit*), %Result* nonnull inttoptr (i64 22 to %Result*))
  %45 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 22 to %Result*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 15 to %Qubit*), %Result* nonnull inttoptr (i64 23 to %Result*))
  %46 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 23 to %Result*))
  %"10147_0.0" = select i1 %31, i64 32768, i64 0
  %"10182_0.0" = select i1 %32, i64 16384, i64 0
  %"10217_0.0" = select i1 %33, i64 8192, i64 0
  %"10252_0.0" = select i1 %34, i64 4096, i64 0
  %"10287_0.0" = select i1 %35, i64 2048, i64 0
  %"10322_0.0" = select i1 %36, i64 1024, i64 0
  %"10357_0.0" = select i1 %37, i64 512, i64 0
  %"10392_0.0" = select i1 %38, i64 256, i64 0
  %"10427_0.0" = select i1 %39, i64 128, i64 0
  %"10462_0.0" = select i1 %40, i64 64, i64 0
  %"10497_0.0" = select i1 %41, i64 32, i64 0
  %"10532_0.0" = select i1 %42, i64 16, i64 0
  %"10567_0.0" = select i1 %43, i64 8, i64 0
  %"10602_0.0" = select i1 %44, i64 4, i64 0
  %"10637_0.0" = select i1 %45, i64 2, i64 0
  %"10672_0.0" = zext i1 %46 to i64
  %47 = or i64 %"10182_0.0", %"10147_0.0"
  %48 = or i64 %47, %"10217_0.0"
  %49 = or i64 %48, %"10252_0.0"
  %50 = or i64 %49, %"10287_0.0"
  %51 = or i64 %50, %"10322_0.0"
  %52 = or i64 %51, %"10357_0.0"
  %53 = or i64 %52, %"10392_0.0"
  %54 = or i64 %53, %"10427_0.0"
  %55 = or i64 %54, %"10462_0.0"
  %56 = or i64 %55, %"10497_0.0"
  %57 = or i64 %56, %"10532_0.0"
  %58 = or i64 %57, %"10567_0.0"
  %59 = or i64 %58, %"10602_0.0"
  %60 = or i64 %59, %"10637_0.0"
  %61 = or i64 %60, %"10672_0.0"
  call void @__quantum__rt__int_record_output(i64 %6, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @0, i64 0, i64 0))
  call void @__quantum__rt__int_record_output(i64 %17, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @1, i64 0, i64 0))
  call void @__quantum__rt__int_record_output(i64 %61, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @2, i64 0, i64 0))
  ret void

62:                                               ; preds = %cond_10117_case_0
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*))
  br label %cond_10152_case_1
}

declare void @__quantum__qis__phasedx__body(double, double, %Qubit*) local_unnamed_addr

declare void @__quantum__qis__rz__body(double, %Qubit*) local_unnamed_addr

declare void @__quantum__qis__rzz__body(double, %Qubit*, %Qubit*) local_unnamed_addr

declare void @__quantum__qis__mz__body(%Qubit*, %Result*) local_unnamed_addr

declare i1 @__quantum__qis__read_result__body(%Result*) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, i8*) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="custom" "required_num_qubits"="24" "required_num_results"="24" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
