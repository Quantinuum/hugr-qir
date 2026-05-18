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

define void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 4 to ptr), ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 1 to ptr))
  %1 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 1 to ptr))
  %2 = select i1 %0, i1 %1, i1 false
  br i1 %2, label %alloca_block.dup628, label %alloca_block.dup627

alloca_block.dup628:                              ; preds = %alloca_block
  br i1 %1, label %alloca_block.dup633, label %alloca_block.dup636

alloca_block.dup636:                              ; preds = %alloca_block.dup628
  br i1 %0, label %alloca_block.dup641, label %alloca_block.dup649

alloca_block.dup649:                              ; preds = %alloca_block.dup636
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %3 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %4 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %5 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %6 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %__prepare_module_record_output_final

alloca_block.dup641:                              ; preds = %alloca_block.dup636
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %7 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %8 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %9 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %10 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %__prepare_module_record_output_final

alloca_block.dup633:                              ; preds = %alloca_block.dup628
  br i1 %0, label %alloca_block.dup639, label %alloca_block.dup647

alloca_block.dup647:                              ; preds = %alloca_block.dup633
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %11 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %12 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %13 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %14 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %__prepare_module_record_output_final

alloca_block.dup639:                              ; preds = %alloca_block.dup633
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %15 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %16 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %17 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %18 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %__prepare_module_record_output_final

alloca_block.dup627:                              ; preds = %alloca_block
  br i1 %1, label %alloca_block.dup632, label %alloca_block.dup635

alloca_block.dup635:                              ; preds = %alloca_block.dup627
  br i1 %0, label %alloca_block.dup640, label %alloca_block.dup648

alloca_block.dup648:                              ; preds = %alloca_block.dup635
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %19 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %20 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %21 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %22 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %__prepare_module_record_output_final

alloca_block.dup640:                              ; preds = %alloca_block.dup635
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %23 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %24 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %25 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %26 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %__prepare_module_record_output_final

alloca_block.dup632:                              ; preds = %alloca_block.dup627
  br i1 %0, label %alloca_block.dup638, label %alloca_block.dup646

alloca_block.dup646:                              ; preds = %alloca_block.dup632
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %27 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %28 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %29 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %30 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %__prepare_module_record_output_final

alloca_block.dup638:                              ; preds = %alloca_block.dup632
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %31 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %32 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %33 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %34 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %__prepare_module_record_output_final

__prepare_module_record_output_final:             ; preds = %alloca_block.dup649, %alloca_block.dup648, %alloca_block.dup647, %alloca_block.dup646, %alloca_block.dup641, %alloca_block.dup640, %alloca_block.dup639, %alloca_block.dup638
  %phi.edge = phi i1 [ %30, %alloca_block.dup646 ], [ %14, %alloca_block.dup647 ], [ %22, %alloca_block.dup648 ], [ %6, %alloca_block.dup649 ], [ %34, %alloca_block.dup638 ], [ %18, %alloca_block.dup639 ], [ %26, %alloca_block.dup640 ], [ %10, %alloca_block.dup641 ]
  %phi.edge650 = phi i1 [ %29, %alloca_block.dup646 ], [ %13, %alloca_block.dup647 ], [ %21, %alloca_block.dup648 ], [ %5, %alloca_block.dup649 ], [ %33, %alloca_block.dup638 ], [ %17, %alloca_block.dup639 ], [ %25, %alloca_block.dup640 ], [ %9, %alloca_block.dup641 ]
  %phi.edge651 = phi i1 [ %28, %alloca_block.dup646 ], [ %12, %alloca_block.dup647 ], [ %20, %alloca_block.dup648 ], [ %4, %alloca_block.dup649 ], [ %32, %alloca_block.dup638 ], [ %16, %alloca_block.dup639 ], [ %24, %alloca_block.dup640 ], [ %8, %alloca_block.dup641 ]
  %phi.edge652 = phi i1 [ %27, %alloca_block.dup646 ], [ %11, %alloca_block.dup647 ], [ %19, %alloca_block.dup648 ], [ %3, %alloca_block.dup649 ], [ %31, %alloca_block.dup638 ], [ %15, %alloca_block.dup639 ], [ %23, %alloca_block.dup640 ], [ %7, %alloca_block.dup641 ]
  call void @__quantum__rt__bool_record_output(i1 %0, ptr @0)
  call void @__quantum__rt__bool_record_output(i1 %1, ptr @1)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge652, ptr @2)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge651, ptr @3)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge650, ptr @4)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge, ptr @5)
  ret void
}

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="6" "required_num_results"="6" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
