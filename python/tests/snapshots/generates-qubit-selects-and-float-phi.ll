; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [3 x i8] c"c0\00", align 1
@1 = private unnamed_addr constant [3 x i8] c"c1\00", align 1
@2 = private unnamed_addr constant [3 x i8] c"q0\00", align 1
@3 = private unnamed_addr constant [3 x i8] c"q1\00", align 1
@4 = private unnamed_addr constant [3 x i8] c"q2\00", align 1
@5 = private unnamed_addr constant [3 x i8] c"q3\00", align 1
@6 = private unnamed_addr constant [8 x i8] c"c0 + c1\00", align 1
@7 = private unnamed_addr constant [18 x i8] c"2nd result as int\00", align 1
@8 = private unnamed_addr constant [3 x i8] c"q4\00", align 1
@9 = private unnamed_addr constant [3 x i8] c"q5\00", align 1
@10 = private unnamed_addr constant [3 x i8] c"q6\00", align 1

define void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
__prepare_module_record_output_final:
  call void @__quantum__rt__bool_record_output(i1 poison, ptr @0)
  call void @__quantum__rt__bool_record_output(i1 poison, ptr @1)
  call void @__quantum__rt__int_record_output(i64 poison, ptr @7)
  call void @__quantum__rt__bool_record_output(i1 poison, ptr @2)
  call void @__quantum__rt__bool_record_output(i1 poison, ptr @3)
  call void @__quantum__rt__bool_record_output(i1 poison, ptr @4)
  call void @__quantum__rt__bool_record_output(i1 poison, ptr @5)
  call void @__quantum__rt__int_record_output(i64 poison, ptr @6)
  call void @__quantum__rt__bool_record_output(i1 poison, ptr @8)
  call void @__quantum__rt__bool_record_output(i1 poison, ptr @9)
  call void @__quantum__rt__bool_record_output(i1 poison, ptr @10)
  ret void
}

; Function Attrs: cold nofree noreturn nounwind
declare void @abort() local_unnamed_addr #1

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #2

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, ptr) local_unnamed_addr

declare void @__quantum__qis__reset__body(ptr) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, ptr) local_unnamed_addr

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fabs.f64(double) #3

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="9" "required_num_results"="13" }
attributes #1 = { cold nofree noreturn nounwind }
attributes #2 = { "irreversible" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
