; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [4 x i8] c"qb0\00", align 1
@1 = private unnamed_addr constant [4 x i8] c"qb1\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr null)
  tail call void @__quantum__qis__mz__body(ptr null, ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  br i1 %0, label %alloca_block.dup378, label %alloca_block.dup

alloca_block.dup378:                              ; preds = %alloca_block
  call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 1 to ptr))
  %1 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 2 to ptr))
  %2 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  br label %__prepare_module_record_output_final

alloca_block.dup:                                 ; preds = %alloca_block
  call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__rz__body(double 0x400921FB54442D18, ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 1 to ptr))
  %3 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 2 to ptr))
  %4 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  br label %__prepare_module_record_output_final

__prepare_module_record_output_final:             ; preds = %alloca_block.dup378, %alloca_block.dup
  %phi.calluser.edge379 = phi i1 [ %4, %alloca_block.dup ], [ %2, %alloca_block.dup378 ]
  %phi.calluser.edge = phi i1 [ %3, %alloca_block.dup ], [ %1, %alloca_block.dup378 ]
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge, ptr @0)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge379, ptr @1)
  ret void
}

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__qis__rz__body(double, ptr) local_unnamed_addr

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="3" "required_num_results"="3" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
