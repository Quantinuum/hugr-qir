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
  %"46_2.0" = zext i1 %0 to i64
  %2 = select i1 %0, i64 2, i64 1
  %"79_2.0" = select i1 %1, i64 %2, i64 %"46_2.0"
  br i1 %1, label %alloca_block.dup1235, label %alloca_block.dup1237

alloca_block.dup1235:                             ; preds = %alloca_block
  br i1 %0, label %alloca_block.dup1241, label %alloca_block.dup1253

alloca_block.dup1253:                             ; preds = %alloca_block.dup1235
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 3 to ptr))
  %3 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 2 to ptr))
  %4 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 1 to ptr))
  %5 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef null)
  %6 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 5 to ptr))
  br label %cond_exit_170

alloca_block.dup1241:                             ; preds = %alloca_block.dup1235
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef null)
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 3 to ptr))
  %7 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 2 to ptr))
  %8 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 1 to ptr))
  %9 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef null)
  %10 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 5 to ptr))
  br label %bb

alloca_block.dup1237:                             ; preds = %alloca_block
  br i1 %0, label %alloca_block.dup1242, label %alloca_block.dup1254

alloca_block.dup1254:                             ; preds = %alloca_block.dup1237
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 3 to ptr))
  %11 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 2 to ptr))
  %12 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 1 to ptr))
  %13 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef null)
  %14 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 5 to ptr))
  br label %cond_exit_170

alloca_block.dup1242:                             ; preds = %alloca_block.dup1237
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 3 to ptr))
  %15 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 2 to ptr))
  %16 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 1 to ptr))
  %17 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef null)
  %18 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 5 to ptr))
  br label %bb

bb:                                               ; preds = %alloca_block.dup1242, %alloca_block.dup1241
  %phi.edge1259 = phi i1 [ %10, %alloca_block.dup1241 ], [ %18, %alloca_block.dup1242 ]
  %phi.edge1260 = phi i1 [ %9, %alloca_block.dup1241 ], [ %17, %alloca_block.dup1242 ]
  %phi.edge1261 = phi i1 [ %8, %alloca_block.dup1241 ], [ %16, %alloca_block.dup1242 ]
  %phi.edge1262 = phi i1 [ %7, %alloca_block.dup1241 ], [ %15, %alloca_block.dup1242 ]
  tail call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef null)
  br label %cond_exit_170

cond_exit_170:                                    ; preds = %alloca_block.dup1254, %alloca_block.dup1253, %bb
  %phi.edge = phi i1 [ %phi.edge1259, %bb ], [ %6, %alloca_block.dup1253 ], [ %14, %alloca_block.dup1254 ]
  %phi.edge1256 = phi i1 [ %phi.edge1260, %bb ], [ %5, %alloca_block.dup1253 ], [ %13, %alloca_block.dup1254 ]
  %phi.edge1257 = phi i1 [ %phi.edge1261, %bb ], [ %4, %alloca_block.dup1253 ], [ %12, %alloca_block.dup1254 ]
  %phi.edge1258 = phi i1 [ %phi.edge1262, %bb ], [ %3, %alloca_block.dup1253 ], [ %11, %alloca_block.dup1254 ]
  br i1 %1, label %bb0, label %cond_exit_211.dup1275

cond_exit_211.dup1275:                            ; preds = %cond_exit_170
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 6 to ptr))
  %19 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 7 to ptr))
  %20 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 8 to ptr))
  %21 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 9 to ptr))
  %22 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 9 to ptr))
  %.1276 = zext i1 %22 to i64
  %"0745.01277" = select i1 %21, i64 2, i64 0
  %"0759.01278" = zext i1 %21 to i64
  %23 = add nuw nsw i64 %"79_2.0", %"0759.01278"
  %"0796.01279" = select i1 %20, i64 4, i64 0
  %"0811.01280" = select i1 %19, i64 8, i64 0
  %24 = or disjoint i64 %"0796.01279", %"0811.01280"
  %25 = or disjoint i64 %24, %"0745.01277"
  %26 = or disjoint i64 %25, %.1276
  %Pivot11781281 = icmp eq i64 %23, 0
  br i1 %Pivot11781281, label %.sink.split.dup1307, label %NodeBlock.dup1315

NodeBlock.dup1315:                                ; preds = %cond_exit_211.dup1275
  %Pivot1316 = icmp eq i64 %23, 1
  br i1 %Pivot1316, label %.sink.split.dup1353, label %LeafBlock.dup1331

.sink.split.dup1353:                              ; preds = %NodeBlock.dup1315
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  br label %cond_466_case_1.dup1364

cond_466_case_1.dup1364:                          ; preds = %.sink.split.dup1353
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %27 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %28 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %29 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

LeafBlock.dup1331:                                ; preds = %NodeBlock.dup1315
  %SwitchLeaf1332 = icmp eq i64 %23, 2
  br i1 %SwitchLeaf1332, label %.sink.split.dup1346, label %cond_466_case_1.dup1366

cond_466_case_1.dup1366:                          ; preds = %LeafBlock.dup1331
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %30 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %31 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %32 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup1346:                              ; preds = %LeafBlock.dup1331
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %cond_466_case_1.dup1363

cond_466_case_1.dup1363:                          ; preds = %.sink.split.dup1346
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %33 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %34 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %35 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup1307:                              ; preds = %cond_exit_211.dup1275
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %cond_466_case_1.dup1361

cond_466_case_1.dup1361:                          ; preds = %.sink.split.dup1307
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %36 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %37 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %38 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb0:                                              ; preds = %cond_exit_170
  tail call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 1 to ptr))
  br label %cond_exit_211.dup

cond_exit_211.dup:                                ; preds = %bb0
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 6 to ptr))
  %39 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 7 to ptr))
  %40 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 8 to ptr))
  %41 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 9 to ptr))
  %42 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 9 to ptr))
  %.1269 = zext i1 %42 to i64
  %"0745.01270" = select i1 %41, i64 2, i64 0
  %"0759.01271" = zext i1 %41 to i64
  %43 = add nuw nsw i64 %"79_2.0", %"0759.01271"
  %"0796.01272" = select i1 %40, i64 4, i64 0
  %"0811.01273" = select i1 %39, i64 8, i64 0
  %44 = or disjoint i64 %"0796.01272", %"0811.01273"
  %45 = or disjoint i64 %44, %"0745.01270"
  %46 = or disjoint i64 %45, %.1269
  %Pivot11781274 = icmp eq i64 %43, 0
  br i1 %Pivot11781274, label %.sink.split.dup1306, label %NodeBlock.dup

NodeBlock.dup:                                    ; preds = %cond_exit_211.dup
  %Pivot1314 = icmp eq i64 %43, 1
  br i1 %Pivot1314, label %.sink.split.dup, label %LeafBlock.dup

.sink.split.dup:                                  ; preds = %NodeBlock.dup
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  br label %cond_466_case_1.dup

cond_466_case_1.dup:                              ; preds = %.sink.split.dup
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %47 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %48 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %49 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

LeafBlock.dup:                                    ; preds = %NodeBlock.dup
  %SwitchLeaf1330 = icmp eq i64 %43, 2
  br i1 %SwitchLeaf1330, label %.sink.split.dup1345, label %cond_466_case_1.dup1365

cond_466_case_1.dup1365:                          ; preds = %LeafBlock.dup
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %50 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %51 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %52 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup1345:                              ; preds = %LeafBlock.dup
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %cond_466_case_1.dup1362

cond_466_case_1.dup1362:                          ; preds = %.sink.split.dup1345
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %53 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %54 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %55 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup1306:                              ; preds = %cond_exit_211.dup
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %cond_466_case_1.dup1360

cond_466_case_1.dup1360:                          ; preds = %.sink.split.dup1306
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %56 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %57 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %58 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

__prepare_module_record_output_final:             ; preds = %cond_466_case_1.dup1366, %cond_466_case_1.dup1365, %cond_466_case_1.dup1364, %cond_466_case_1.dup1363, %cond_466_case_1.dup1362, %cond_466_case_1.dup1361, %cond_466_case_1.dup1360, %cond_466_case_1.dup
  %phi.calluser.edge1373 = phi i1 [ %49, %cond_466_case_1.dup ], [ %58, %cond_466_case_1.dup1360 ], [ %38, %cond_466_case_1.dup1361 ], [ %55, %cond_466_case_1.dup1362 ], [ %35, %cond_466_case_1.dup1363 ], [ %29, %cond_466_case_1.dup1364 ], [ %52, %cond_466_case_1.dup1365 ], [ %32, %cond_466_case_1.dup1366 ]
  %phi.calluser.edge1372 = phi i1 [ %48, %cond_466_case_1.dup ], [ %57, %cond_466_case_1.dup1360 ], [ %37, %cond_466_case_1.dup1361 ], [ %54, %cond_466_case_1.dup1362 ], [ %34, %cond_466_case_1.dup1363 ], [ %28, %cond_466_case_1.dup1364 ], [ %51, %cond_466_case_1.dup1365 ], [ %31, %cond_466_case_1.dup1366 ]
  %phi.calluser.edge1371 = phi i1 [ %47, %cond_466_case_1.dup ], [ %56, %cond_466_case_1.dup1360 ], [ %36, %cond_466_case_1.dup1361 ], [ %53, %cond_466_case_1.dup1362 ], [ %33, %cond_466_case_1.dup1363 ], [ %27, %cond_466_case_1.dup1364 ], [ %50, %cond_466_case_1.dup1365 ], [ %30, %cond_466_case_1.dup1366 ]
  %phi.edge1367 = phi i64 [ %46, %cond_466_case_1.dup ], [ %46, %cond_466_case_1.dup1360 ], [ %26, %cond_466_case_1.dup1361 ], [ %46, %cond_466_case_1.dup1362 ], [ %26, %cond_466_case_1.dup1363 ], [ %26, %cond_466_case_1.dup1364 ], [ %46, %cond_466_case_1.dup1365 ], [ %26, %cond_466_case_1.dup1366 ]
  call void @__quantum__rt__bool_record_output(i1 %0, ptr noundef nonnull @0)
  call void @__quantum__rt__bool_record_output(i1 noundef %1, ptr noundef nonnull @1)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge, ptr noundef nonnull @2)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge1256, ptr noundef nonnull @3)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge1257, ptr noundef nonnull @4)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge1258, ptr noundef nonnull @5)
  call void @__quantum__rt__int_record_output(i64 %"79_2.0", ptr noundef nonnull @6)
  call void @__quantum__rt__int_record_output(i64 %phi.edge1367, ptr noundef nonnull @7)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1371, ptr noundef nonnull @8)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1372, ptr noundef nonnull @9)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge1373, ptr noundef nonnull @10)
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
