; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [10 x i8] c"c0___BOOL\00", align 1
@1 = private unnamed_addr constant [10 x i8] c"c1___BOOL\00", align 1
@2 = private unnamed_addr constant [10 x i8] c"q0___BOOL\00", align 1
@3 = private unnamed_addr constant [10 x i8] c"q1___BOOL\00", align 1
@4 = private unnamed_addr constant [10 x i8] c"q2___BOOL\00", align 1
@5 = private unnamed_addr constant [10 x i8] c"q3___BOOL\00", align 1
@6 = private unnamed_addr constant [14 x i8] c"c0 + c1___INT\00", align 1
@7 = private unnamed_addr constant [24 x i8] c"2nd result as int___INT\00", align 1
@8 = private unnamed_addr constant [10 x i8] c"q4___BOOL\00", align 1
@9 = private unnamed_addr constant [10 x i8] c"q5___BOOL\00", align 1
@10 = private unnamed_addr constant [10 x i8] c"q6___BOOL\00", align 1
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
  br i1 %1, label %alloca_block.dup1172, label %alloca_block.dup

alloca_block.dup1172:                             ; preds = %alloca_block
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
  br label %.critedge.dup1224

.critedge.dup1224:                                ; preds = %alloca_block.dup1172
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 6 to ptr))
  %6 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 7 to ptr))
  %7 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 8 to ptr))
  %8 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 9 to ptr))
  %9 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 9 to ptr))
  %.1225 = zext i1 %9 to i64
  %"0745.01226" = select i1 %8, i64 2, i64 0
  %"0796.01228" = select i1 %7, i64 4, i64 0
  %"0811.01229" = select i1 %6, i64 8, i64 0
  %10 = or disjoint i64 %"0796.01228", %"0811.01229"
  %11 = or disjoint i64 %10, %"0745.01226"
  %12 = or disjoint i64 %11, %.1225
  br label %NodeBlock.dup1251

NodeBlock.dup1251:                                ; preds = %.critedge.dup1224
  %"0759.01227" = zext i1 %8 to i64
  %13 = or disjoint i64 %"79_2.0", %"0759.01227"
  %Pivot.not1252 = icmp eq i64 %13, 3
  br i1 %Pivot.not1252, label %cond_465_case_1.dup1301, label %cond_465_case_1.sink.split.dup1295

cond_465_case_1.dup1301:                          ; preds = %NodeBlock.dup1251
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %14 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %15 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %16 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_465_case_1.sink.split.dup1295:               ; preds = %NodeBlock.dup1251
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %cond_465_case_1.dup1307

cond_465_case_1.dup1307:                          ; preds = %cond_465_case_1.sink.split.dup1295
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
  %.1219 = zext i1 %27 to i64
  %"0745.01220" = select i1 %26, i64 2, i64 0
  %"0796.01222" = select i1 %25, i64 4, i64 0
  %"0811.01223" = select i1 %24, i64 8, i64 0
  %28 = or disjoint i64 %"0796.01222", %"0811.01223"
  %29 = or disjoint i64 %28, %"0745.01220"
  %30 = or disjoint i64 %29, %.1219
  br label %LeafBlock.dup

LeafBlock.dup:                                    ; preds = %.critedge.dup
  %"0759.01221" = zext i1 %26 to i64
  %31 = or disjoint i64 %"79_2.0", %"0759.01221"
  %SwitchLeaf1265 = icmp eq i64 %31, 1
  br i1 %SwitchLeaf1265, label %cond_465_case_1.sink.split.dup1280, label %cond_465_case_1.sink.split.dup1287

cond_465_case_1.sink.split.dup1287:               ; preds = %LeafBlock.dup
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %cond_465_case_1.dup1304

cond_465_case_1.dup1304:                          ; preds = %cond_465_case_1.sink.split.dup1287
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %32 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %33 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %34 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_465_case_1.sink.split.dup1280:               ; preds = %LeafBlock.dup
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  br label %cond_465_case_1.dup1302

cond_465_case_1.dup1302:                          ; preds = %cond_465_case_1.sink.split.dup1280
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %35 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %36 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %37 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

__prepare_module_record_output_final:             ; preds = %cond_465_case_1.dup1307, %cond_465_case_1.dup1304, %cond_465_case_1.dup1302, %cond_465_case_1.dup1301
  %phi.calluser.edge1314 = phi i1 [ %16, %cond_465_case_1.dup1301 ], [ %37, %cond_465_case_1.dup1302 ], [ %34, %cond_465_case_1.dup1304 ], [ %19, %cond_465_case_1.dup1307 ]
  %phi.calluser.edge1313 = phi i1 [ %15, %cond_465_case_1.dup1301 ], [ %36, %cond_465_case_1.dup1302 ], [ %33, %cond_465_case_1.dup1304 ], [ %18, %cond_465_case_1.dup1307 ]
  %phi.calluser.edge1312 = phi i1 [ %14, %cond_465_case_1.dup1301 ], [ %35, %cond_465_case_1.dup1302 ], [ %32, %cond_465_case_1.dup1304 ], [ %17, %cond_465_case_1.dup1307 ]
  %phi.calluser.edge1311 = phi i1 [ %2, %cond_465_case_1.dup1301 ], [ %20, %cond_465_case_1.dup1302 ], [ %20, %cond_465_case_1.dup1304 ], [ %2, %cond_465_case_1.dup1307 ]
  %phi.calluser.edge1310 = phi i1 [ %3, %cond_465_case_1.dup1301 ], [ %21, %cond_465_case_1.dup1302 ], [ %21, %cond_465_case_1.dup1304 ], [ %3, %cond_465_case_1.dup1307 ]
  %phi.calluser.edge1309 = phi i1 [ %4, %cond_465_case_1.dup1301 ], [ %22, %cond_465_case_1.dup1302 ], [ %22, %cond_465_case_1.dup1304 ], [ %4, %cond_465_case_1.dup1307 ]
  %phi.calluser.edge = phi i1 [ %5, %cond_465_case_1.dup1301 ], [ %23, %cond_465_case_1.dup1302 ], [ %23, %cond_465_case_1.dup1304 ], [ %5, %cond_465_case_1.dup1307 ]
  %phi.edge1308 = phi i64 [ %12, %cond_465_case_1.dup1301 ], [ %30, %cond_465_case_1.dup1302 ], [ %30, %cond_465_case_1.dup1304 ], [ %12, %cond_465_case_1.dup1307 ]
  call void @__quantum__rt__bool_record_output(i1 %0, ptr noundef nonnull @0)
  call void @__quantum__rt__bool_record_output(i1 noundef %1, ptr noundef nonnull @1)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge, ptr noundef nonnull @2)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1309, ptr noundef nonnull @3)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1310, ptr noundef nonnull @4)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1311, ptr noundef nonnull @5)
  call void @__quantum__rt__int_record_output(i64 noundef %"79_2.0", ptr noundef nonnull @6)
  call void @__quantum__rt__int_record_output(i64 %phi.edge1308, ptr noundef nonnull @7)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1312, ptr noundef nonnull @8)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1313, ptr noundef nonnull @9)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1314, ptr noundef nonnull @10)
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
