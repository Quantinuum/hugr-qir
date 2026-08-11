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
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr noundef null)
  tail call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 4 to ptr), ptr noundef null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr noundef null)
  tail call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 5 to ptr), ptr noundef nonnull inttoptr (i64 1 to ptr))
  %1 = tail call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 1 to ptr))
  %"79_2.0" = select i1 %1, i64 2, i64 0
  br i1 %1, label %alloca_block.dup1166, label %alloca_block.dup

alloca_block.dup1166:                             ; preds = %alloca_block
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef null)
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 3 to ptr))
  %2 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 2 to ptr))
  %3 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 1 to ptr))
  %4 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef null)
  %5 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef null)
  tail call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 1 to ptr))
  br label %.critedge.dup1218

.critedge.dup1218:                                ; preds = %alloca_block.dup1166
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 6 to ptr))
  %6 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 7 to ptr))
  %7 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 8 to ptr))
  %8 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 9 to ptr))
  %9 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 9 to ptr))
  %.1219 = zext i1 %9 to i64
  %"0745.01220" = select i1 %8, i64 2, i64 0
  %"0796.01222" = select i1 %7, i64 4, i64 0
  %"0811.01223" = select i1 %6, i64 8, i64 0
  %10 = or disjoint i64 %"0796.01222", %"0811.01223"
  %11 = or disjoint i64 %10, %"0745.01220"
  %12 = or disjoint i64 %11, %.1219
  br label %NodeBlock.dup1245

NodeBlock.dup1245:                                ; preds = %.critedge.dup1218
  %"0759.01221" = zext i1 %8 to i64
  %13 = or disjoint i64 %"79_2.0", %"0759.01221"
  %Pivot.not1246 = icmp eq i64 %13, 3
  br i1 %Pivot.not1246, label %cond_460_case_1.dup1295, label %cond_460_case_1.sink.split.dup1289

cond_460_case_1.dup1295:                          ; preds = %NodeBlock.dup1245
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %14 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %15 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %16 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_460_case_1.sink.split.dup1289:               ; preds = %NodeBlock.dup1245
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %cond_460_case_1.dup1301

cond_460_case_1.dup1301:                          ; preds = %cond_460_case_1.sink.split.dup1289
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %17 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %18 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %19 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

alloca_block.dup:                                 ; preds = %alloca_block
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 3 to ptr))
  %20 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 2 to ptr))
  %21 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 1 to ptr))
  %22 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef null)
  %23 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 5 to ptr))
  br label %.critedge.dup

.critedge.dup:                                    ; preds = %alloca_block.dup
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 6 to ptr))
  %24 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 7 to ptr))
  %25 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 8 to ptr))
  %26 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 9 to ptr))
  %27 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 9 to ptr))
  %.1213 = zext i1 %27 to i64
  %"0745.01214" = select i1 %26, i64 2, i64 0
  %"0796.01216" = select i1 %25, i64 4, i64 0
  %"0811.01217" = select i1 %24, i64 8, i64 0
  %28 = or disjoint i64 %"0796.01216", %"0811.01217"
  %29 = or disjoint i64 %28, %"0745.01214"
  %30 = or disjoint i64 %29, %.1213
  br label %LeafBlock.dup

LeafBlock.dup:                                    ; preds = %.critedge.dup
  %"0759.01215" = zext i1 %26 to i64
  %31 = or disjoint i64 %"79_2.0", %"0759.01215"
  %SwitchLeaf1259 = icmp eq i64 %31, 1
  br i1 %SwitchLeaf1259, label %cond_460_case_1.sink.split.dup1274, label %cond_460_case_1.sink.split.dup1281

cond_460_case_1.sink.split.dup1281:               ; preds = %LeafBlock.dup
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %cond_460_case_1.dup1298

cond_460_case_1.dup1298:                          ; preds = %cond_460_case_1.sink.split.dup1281
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %32 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %33 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %34 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_460_case_1.sink.split.dup1274:               ; preds = %LeafBlock.dup
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  br label %cond_460_case_1.dup1296

cond_460_case_1.dup1296:                          ; preds = %cond_460_case_1.sink.split.dup1274
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %35 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %36 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %37 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

__prepare_module_record_output_final:             ; preds = %cond_460_case_1.dup1301, %cond_460_case_1.dup1298, %cond_460_case_1.dup1296, %cond_460_case_1.dup1295
  %phi.calluser.edge1308 = phi i1 [ %16, %cond_460_case_1.dup1295 ], [ %37, %cond_460_case_1.dup1296 ], [ %34, %cond_460_case_1.dup1298 ], [ %19, %cond_460_case_1.dup1301 ]
  %phi.calluser.edge1307 = phi i1 [ %15, %cond_460_case_1.dup1295 ], [ %36, %cond_460_case_1.dup1296 ], [ %33, %cond_460_case_1.dup1298 ], [ %18, %cond_460_case_1.dup1301 ]
  %phi.calluser.edge1306 = phi i1 [ %14, %cond_460_case_1.dup1295 ], [ %35, %cond_460_case_1.dup1296 ], [ %32, %cond_460_case_1.dup1298 ], [ %17, %cond_460_case_1.dup1301 ]
  %phi.calluser.edge1305 = phi i1 [ %2, %cond_460_case_1.dup1295 ], [ %20, %cond_460_case_1.dup1296 ], [ %20, %cond_460_case_1.dup1298 ], [ %2, %cond_460_case_1.dup1301 ]
  %phi.calluser.edge1304 = phi i1 [ %3, %cond_460_case_1.dup1295 ], [ %21, %cond_460_case_1.dup1296 ], [ %21, %cond_460_case_1.dup1298 ], [ %3, %cond_460_case_1.dup1301 ]
  %phi.calluser.edge1303 = phi i1 [ %4, %cond_460_case_1.dup1295 ], [ %22, %cond_460_case_1.dup1296 ], [ %22, %cond_460_case_1.dup1298 ], [ %4, %cond_460_case_1.dup1301 ]
  %phi.calluser.edge = phi i1 [ %5, %cond_460_case_1.dup1295 ], [ %23, %cond_460_case_1.dup1296 ], [ %23, %cond_460_case_1.dup1298 ], [ %5, %cond_460_case_1.dup1301 ]
  %phi.edge1302 = phi i64 [ %12, %cond_460_case_1.dup1295 ], [ %30, %cond_460_case_1.dup1296 ], [ %30, %cond_460_case_1.dup1298 ], [ %12, %cond_460_case_1.dup1301 ]
  call void @__quantum__rt__bool_record_output(i1 %0, ptr noundef nonnull @0)
  call void @__quantum__rt__bool_record_output(i1 noundef %1, ptr noundef nonnull @1)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge, ptr noundef nonnull @2)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1303, ptr noundef nonnull @3)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1304, ptr noundef nonnull @4)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1305, ptr noundef nonnull @5)
  call void @__quantum__rt__int_record_output(i64 noundef %"79_2.0", ptr noundef nonnull @6)
  call void @__quantum__rt__int_record_output(i64 %phi.edge1302, ptr noundef nonnull @7)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1306, ptr noundef nonnull @8)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1307, ptr noundef nonnull @9)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1308, ptr noundef nonnull @10)
  ret void
}

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, ptr) local_unnamed_addr

declare void @__quantum__qis__reset__body(ptr) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="9" "required_num_results"="13" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
