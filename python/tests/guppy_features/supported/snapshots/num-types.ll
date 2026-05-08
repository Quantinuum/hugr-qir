; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [3 x i8] c"q0\00", align 1
@1 = private unnamed_addr constant [3 x i8] c"q1\00", align 1
@2 = private unnamed_addr constant [3 x i8] c"q2\00", align 1
@3 = private unnamed_addr constant [3 x i8] c"q3\00", align 1
@4 = private unnamed_addr constant [15 x i8] c"big_endian_res\00", align 1
@5 = private unnamed_addr constant [11 x i8] c"random_sum\00", align 1
@6 = private unnamed_addr constant [8 x i8] c"int_res\00", align 1

define void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x3FF41B2F769CF0E0, ptr null)
  tail call void @__quantum__qis__mz__body(ptr null, ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 1 to ptr))
  %1 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 2 to ptr))
  %2 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 3 to ptr))
  %3 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 3 to ptr))
  %"872_0.0" = select i1 %0, i64 8, i64 0
  %"910_0.0" = select i1 %1, i64 4, i64 0
  %"948_0.0" = select i1 %2, i64 2, i64 0
  %"986_0.0" = zext i1 %3 to i64
  %4 = or disjoint i64 %"910_0.0", %"872_0.0"
  %5 = or disjoint i64 %4, %"948_0.0"
  %6 = or disjoint i64 %5, %"986_0.0"
  tail call void @__quantum__rt__bool_record_output(i1 %0, ptr nonnull @0)
  tail call void @__quantum__rt__bool_record_output(i1 %1, ptr nonnull @1)
  tail call void @__quantum__rt__bool_record_output(i1 %2, ptr nonnull @2)
  tail call void @__quantum__rt__bool_record_output(i1 %3, ptr nonnull @3)
  tail call void @__quantum__rt__int_record_output(i64 %6, ptr nonnull @4)
  %"0495.0" = select i1 %0, i64 1, i64 -1
  %"0523.0" = select i1 %1, i64 1, i64 -1
  %"0551.0" = select i1 %2, i64 1, i64 -1
  %"0579.0" = select i1 %3, i64 1, i64 -1
  %7 = add nsw i64 %"0523.0", %"0495.0"
  %8 = add nsw i64 %7, %"0551.0"
  %9 = add nsw i64 %8, %"0579.0"
  %10 = mul nsw i64 %9, %9
  %11 = sub nsw i64 10, %10
  tail call void @__quantum__rt__int_record_output(i64 %9, ptr nonnull @5)
  tail call void @__quantum__rt__int_record_output(i64 %11, ptr nonnull @6)
  ret void
}

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__qis__rz__body(double, ptr) local_unnamed_addr

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, ptr) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="4" "required_num_results"="4" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
