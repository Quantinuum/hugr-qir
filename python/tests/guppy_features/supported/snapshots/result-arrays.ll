; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [6 x i8] c"bools\00", align 1
@1 = private unnamed_addr constant [8 x i8] c"uints:0\00", align 1
@2 = private unnamed_addr constant [8 x i8] c"uints:1\00", align 1
@3 = private unnamed_addr constant [8 x i8] c"uints:2\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
__barray_check_none_borrowed.exit66:
  tail call void @__quantum__rt__initialize(ptr null)
  tail call void @__quantum__rt__int_record_output(i64 5, ptr nonnull @0)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @1)
  tail call void @__quantum__rt__int_record_output(i64 2, ptr nonnull @2)
  tail call void @__quantum__rt__int_record_output(i64 3, ptr nonnull @3)
  ret void
}

declare void @__quantum__rt__int_record_output(i64, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="0" "required_num_results"="0" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
