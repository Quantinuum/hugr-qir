; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@"sa.static_pyarray.%tmp82.5ab632cc.0" = local_unnamed_addr constant { i64, [4 x i64] } { i64 4, [4 x i64] [i64 3, i64 4, i64 5, i64 6] }
@0 = private unnamed_addr constant [10 x i8] c"arr_res_0\00", align 1
@1 = private unnamed_addr constant [10 x i8] c"arr_res_1\00", align 1
@2 = private unnamed_addr constant [10 x i8] c"arr_res_2\00", align 1
@3 = private unnamed_addr constant [10 x i8] c"arr_res_3\00", align 1
@4 = private unnamed_addr constant [10 x i8] c"arr_res_4\00", align 1
@5 = private unnamed_addr constant [10 x i8] c"arr_res_5\00", align 1
@6 = private unnamed_addr constant [10 x i8] c"arr_res_6\00", align 1
@7 = private unnamed_addr constant [10 x i8] c"arr_res_7\00", align 1
@8 = private unnamed_addr constant [10 x i8] c"arr_res_8\00", align 1
@9 = private unnamed_addr constant [10 x i8] c"arr_res_9\00", align 1
@10 = private unnamed_addr constant [11 x i8] c"arr_res_10\00", align 1
@11 = private unnamed_addr constant [11 x i8] c"arr_res_11\00", align 1
@12 = private unnamed_addr constant [11 x i8] c"arr_res_12\00", align 1
@13 = private unnamed_addr constant [11 x i8] c"arr_res_13\00", align 1
@14 = private unnamed_addr constant [11 x i8] c"arr_res_14\00", align 1
@15 = private unnamed_addr constant [11 x i8] c"arr_res_15\00", align 1
@16 = private unnamed_addr constant [6 x i8] c"iar_0\00", align 1
@17 = private unnamed_addr constant [6 x i8] c"iar_1\00", align 1
@18 = private unnamed_addr constant [6 x i8] c"iar_2\00", align 1
@19 = private unnamed_addr constant [6 x i8] c"iar_3\00", align 1
@20 = private unnamed_addr constant [6 x i8] c"iar_4\00", align 1
@21 = private unnamed_addr constant [6 x i8] c"iar_5\00", align 1
@22 = private unnamed_addr constant [6 x i8] c"iar_6\00", align 1
@23 = private unnamed_addr constant [6 x i8] c"iar_7\00", align 1
@24 = private unnamed_addr constant [6 x i8] c"iar_8\00", align 1
@25 = private unnamed_addr constant [6 x i8] c"iar_9\00", align 1
@26 = private unnamed_addr constant [7 x i8] c"iar_10\00", align 1
@27 = private unnamed_addr constant [7 x i8] c"iar_11\00", align 1
@28 = private unnamed_addr constant [7 x i8] c"iar_12\00", align 1
@29 = private unnamed_addr constant [7 x i8] c"iar_13\00", align 1
@30 = private unnamed_addr constant [7 x i8] c"iar_14\00", align 1
@31 = private unnamed_addr constant [7 x i8] c"iar_15\00", align 1
@32 = private unnamed_addr constant [7 x i8] c"siar_0\00", align 1
@33 = private unnamed_addr constant [7 x i8] c"siar_1\00", align 1
@34 = private unnamed_addr constant [7 x i8] c"siar_2\00", align 1
@35 = private unnamed_addr constant [7 x i8] c"siar_3\00", align 1
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
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__qis__mz__body(ptr null, ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__rt__bool_record_output(i1 %0, ptr nonnull @0)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 1 to ptr))
  %1 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 1 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %1, ptr nonnull @1)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 2 to ptr))
  %2 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 2 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %2, ptr nonnull @2)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 3 to ptr))
  %3 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 3 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %3, ptr nonnull @3)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 4 to ptr), ptr nonnull inttoptr (i64 4 to ptr))
  %4 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 4 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %4, ptr nonnull @4)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 5 to ptr))
  %5 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %5, ptr nonnull @5)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 6 to ptr))
  %6 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %6, ptr nonnull @6)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 7 to ptr))
  %7 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %7, ptr nonnull @7)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 8 to ptr), ptr nonnull inttoptr (i64 8 to ptr))
  %8 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %8, ptr nonnull @8)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 9 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  %9 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 9 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %9, ptr nonnull @9)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 10 to ptr), ptr nonnull inttoptr (i64 10 to ptr))
  %10 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %10, ptr nonnull @10)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 11 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  %11 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 11 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %11, ptr nonnull @11)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 12 to ptr), ptr nonnull inttoptr (i64 12 to ptr))
  %12 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 12 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %12, ptr nonnull @12)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 13 to ptr), ptr nonnull inttoptr (i64 13 to ptr))
  %13 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 13 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %13, ptr nonnull @13)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 14 to ptr), ptr nonnull inttoptr (i64 14 to ptr))
  %14 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 14 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %14, ptr nonnull @14)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 15 to ptr), ptr nonnull inttoptr (i64 15 to ptr))
  %15 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 15 to ptr))
  tail call void @__quantum__rt__bool_record_output(i1 %15, ptr nonnull @15)
  tail call void @__quantum__rt__int_record_output(i64 0, ptr nonnull @16)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @17)
  tail call void @__quantum__rt__int_record_output(i64 2, ptr nonnull @18)
  tail call void @__quantum__rt__int_record_output(i64 3, ptr nonnull @19)
  tail call void @__quantum__rt__int_record_output(i64 4, ptr nonnull @20)
  tail call void @__quantum__rt__int_record_output(i64 5, ptr nonnull @21)
  tail call void @__quantum__rt__int_record_output(i64 6, ptr nonnull @22)
  tail call void @__quantum__rt__int_record_output(i64 7, ptr nonnull @23)
  tail call void @__quantum__rt__int_record_output(i64 8, ptr nonnull @24)
  tail call void @__quantum__rt__int_record_output(i64 9, ptr nonnull @25)
  tail call void @__quantum__rt__int_record_output(i64 10, ptr nonnull @26)
  tail call void @__quantum__rt__int_record_output(i64 11, ptr nonnull @27)
  tail call void @__quantum__rt__int_record_output(i64 12, ptr nonnull @28)
  tail call void @__quantum__rt__int_record_output(i64 13, ptr nonnull @29)
  tail call void @__quantum__rt__int_record_output(i64 14, ptr nonnull @30)
  tail call void @__quantum__rt__int_record_output(i64 15, ptr nonnull @31)
  tail call void @__quantum__rt__int_record_output(i64 3, ptr nonnull @32)
  tail call void @__quantum__rt__int_record_output(i64 4, ptr nonnull @33)
  tail call void @__quantum__rt__int_record_output(i64 5, ptr nonnull @34)
  tail call void @__quantum__rt__int_record_output(i64 6, ptr nonnull @35)
  ret void
}

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__qis__rz__body(double, ptr) local_unnamed_addr

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, ptr) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="16" "required_num_results"="16" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
