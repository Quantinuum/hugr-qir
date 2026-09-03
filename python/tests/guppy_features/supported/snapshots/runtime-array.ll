; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [10 x i8] c"steane_q1\00", align 1
@1 = private unnamed_addr constant [10 x i8] c"steane_q2\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
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
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr null, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0xBFF921FB54442D18, double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rzz__body(double 0x3FF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0x400921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__rz__body(double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__qis__mz__body(ptr null, ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 1 to ptr))
  %1 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 2 to ptr))
  %2 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 3 to ptr))
  %3 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 4 to ptr))
  %4 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 5 to ptr))
  %5 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 6 to ptr))
  %6 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 6 to ptr))
  %7 = zext i1 %1 to i64
  %8 = select i1 %0, i64 2, i64 0
  %9 = or disjoint i64 %8, %7
  %10 = zext i1 %3 to i64
  %11 = shl nuw nsw i64 %9, 2
  %12 = select i1 %2, i64 2, i64 0
  %13 = or disjoint i64 %11, %12
  %14 = or disjoint i64 %13, %10
  %15 = zext i1 %5 to i64
  %16 = shl nuw nsw i64 %14, 2
  %17 = select i1 %4, i64 2, i64 0
  %18 = or disjoint i64 %16, %17
  %19 = or disjoint i64 %18, %15
  %20 = zext i1 %6 to i64
  %21 = shl nuw nsw i64 %19, 1
  %22 = or disjoint i64 %21, %20
  tail call void @__quantum__rt__int_record_output(i64 %22, ptr nonnull @0)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 7 to ptr))
  %23 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 8 to ptr))
  %24 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  %25 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 10 to ptr))
  %26 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  %27 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 12 to ptr))
  %28 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 13 to ptr))
  %29 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 13 to ptr))
  %30 = zext i1 %24 to i64
  %31 = select i1 %23, i64 2, i64 0
  %32 = or disjoint i64 %31, %30
  %33 = zext i1 %26 to i64
  %34 = shl nuw nsw i64 %32, 2
  %35 = select i1 %25, i64 2, i64 0
  %36 = or disjoint i64 %34, %35
  %37 = or disjoint i64 %36, %33
  %38 = zext i1 %28 to i64
  %39 = shl nuw nsw i64 %37, 2
  %40 = select i1 %27, i64 2, i64 0
  %41 = or disjoint i64 %39, %40
  %42 = or disjoint i64 %41, %38
  %43 = zext i1 %29 to i64
  %44 = shl nuw nsw i64 %42, 1
  %45 = or disjoint i64 %44, %43
  tail call void @__quantum__rt__int_record_output(i64 %45, ptr nonnull @1)
  ret void
}

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__qis__rz__body(double, ptr) local_unnamed_addr

declare void @__quantum__qis__rzz__body(double, ptr, ptr) local_unnamed_addr

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="14" "required_num_results"="14" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
