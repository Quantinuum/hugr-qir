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
alloca_block:
  tail call void @__quantum__rt__initialize(ptr noundef null)
  tail call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 4 to ptr), ptr noundef null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr noundef null)
  tail call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 5 to ptr), ptr noundef nonnull inttoptr (i64 1 to ptr))
  %1 = tail call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 1 to ptr))
  %"48_2.0" = zext i1 %0 to i64
  br i1 %1, label %alloca_block.dup2194, label %alloca_block.dup

alloca_block.dup2194:                             ; preds = %alloca_block
  %2 = select i1 %0, i64 2, i64 1
  br i1 %0, label %cond_exit_855.dup2221, label %cond_exit_755.dup2334

cond_exit_755.dup2334:                            ; preds = %alloca_block.dup2194
  br label %cond_exit_101

cond_exit_855.dup2221:                            ; preds = %alloca_block.dup2194
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef null)
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef null)
  %3 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 1 to ptr))
  %4 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 2 to ptr))
  %5 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 3 to ptr))
  %6 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 9 to ptr))
  br label %bb.dup2348

bb.dup2348:                                       ; preds = %cond_exit_855.dup2221
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef null)
  br label %cond_exit_176.dup2357

cond_exit_176.dup2357:                            ; preds = %bb.dup2348
  br label %bb

alloca_block.dup:                                 ; preds = %alloca_block
  br label %cond_exit_755.dup

cond_exit_755.dup:                                ; preds = %alloca_block.dup
  br i1 %0, label %cond_exit_855.dup, label %cond_exit_101

cond_exit_855.dup:                                ; preds = %cond_exit_755.dup
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef null)
  %7 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 1 to ptr))
  %8 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 2 to ptr))
  %9 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 3 to ptr))
  %10 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 9 to ptr))
  br label %bb.dup2346

bb.dup2346:                                       ; preds = %cond_exit_855.dup
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef null)
  br label %cond_exit_176.dup

cond_exit_176.dup:                                ; preds = %bb.dup2346
  br label %cond_374_case_1.dup2424

cond_374_case_1.dup2424:                          ; preds = %cond_exit_176.dup
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 2 to ptr))
  %11 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 3 to ptr))
  %12 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 4 to ptr))
  %13 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 5 to ptr))
  %14 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 5 to ptr))
  %"1370_0.022362425" = select i1 %11, i64 8, i64 0
  %"1408_0.022372426" = select i1 %12, i64 4, i64 0
  %"1446_0.022382427" = select i1 %13, i64 2, i64 0
  %"1484_0.022392428" = zext i1 %14 to i64
  %15 = or disjoint i64 %"1408_0.022372426", %"1370_0.022362425"
  %16 = or disjoint i64 %15, %"1446_0.022382427"
  %17 = or disjoint i64 %16, %"1484_0.022392428"
  br label %NodeBlock.dup2502

NodeBlock.dup2502:                                ; preds = %cond_374_case_1.dup2424
  br i1 %13, label %LeafBlock.dup2562, label %.sink.split.dup2533

LeafBlock.dup2562:                                ; preds = %NodeBlock.dup2502
  br label %.sink.split.dup2636

.sink.split.dup2636:                              ; preds = %LeafBlock.dup2562
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %bb.dup2655

bb.dup2655:                                       ; preds = %.sink.split.dup2636
  br label %cond_949_case_1.dup2696

cond_949_case_1.dup2696:                          ; preds = %bb.dup2655
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %18 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %19 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %20 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2533:                              ; preds = %NodeBlock.dup2502
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  br label %bb.dup2547

bb.dup2547:                                       ; preds = %.sink.split.dup2533
  br label %cond_949_case_1.dup2671

cond_949_case_1.dup2671:                          ; preds = %bb.dup2547
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %21 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %22 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %23 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_exit_101:                                    ; preds = %cond_exit_755.dup2334, %cond_exit_755.dup
  %phi.edge2335 = phi i64 [ %"48_2.0", %cond_exit_755.dup ], [ %2, %cond_exit_755.dup2334 ]
  br i1 %1, label %cond_exit_101.dup2095, label %cond_exit_101.dup

cond_exit_101.dup2095:                            ; preds = %cond_exit_101
  br label %cond_exit_101.dup2186

cond_exit_101.dup2186:                            ; preds = %cond_exit_101.dup2095
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef null)
  %24 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 1 to ptr))
  %25 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 2 to ptr))
  %26 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 3 to ptr))
  %27 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 9 to ptr))
  br label %cond_exit_176.dup2362

cond_exit_176.dup2362:                            ; preds = %cond_exit_101.dup2186
  br label %bb

cond_exit_101.dup:                                ; preds = %cond_exit_101
  br label %cond_exit_101.dup2173

cond_exit_101.dup2173:                            ; preds = %cond_exit_101.dup
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef null)
  %28 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 1 to ptr))
  %29 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 2 to ptr))
  %30 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr noundef nonnull inttoptr (i64 3 to ptr))
  %31 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 9 to ptr))
  br label %cond_exit_176.dup2359

cond_exit_176.dup2359:                            ; preds = %cond_exit_101.dup2173
  br label %cond_374_case_1.dup2452

cond_374_case_1.dup2452:                          ; preds = %cond_exit_176.dup2359
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 2 to ptr))
  %32 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 3 to ptr))
  %33 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 4 to ptr))
  %34 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 5 to ptr))
  %35 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 5 to ptr))
  %"1370_0.022362453" = select i1 %32, i64 8, i64 0
  %"1408_0.022372454" = select i1 %33, i64 4, i64 0
  %"1446_0.022382455" = select i1 %34, i64 2, i64 0
  %"1484_0.022392456" = zext i1 %35 to i64
  %36 = or disjoint i64 %"1408_0.022372454", %"1370_0.022362453"
  %37 = or disjoint i64 %36, %"1446_0.022382455"
  %38 = or disjoint i64 %37, %"1484_0.022392456"
  %"1282_0.022402457" = zext i1 %34 to i64
  %39 = add nuw nsw i64 %phi.edge2335, %"1282_0.022402457"
  %Pivot208922412458 = icmp eq i64 %39, 0
  br i1 %Pivot208922412458, label %.sink.split.dup2610, label %NodeBlock.dup2510

.sink.split.dup2610:                              ; preds = %cond_374_case_1.dup2452
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %bb.dup2624

bb.dup2624:                                       ; preds = %.sink.split.dup2610
  br label %cond_949_case_1.dup2691

cond_949_case_1.dup2691:                          ; preds = %bb.dup2624
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %40 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %41 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %42 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

NodeBlock.dup2510:                                ; preds = %cond_374_case_1.dup2452
  %Pivot22792511 = icmp eq i64 %39, 1
  br i1 %Pivot22792511, label %.sink.split.dup2537, label %LeafBlock.dup2570

LeafBlock.dup2570:                                ; preds = %NodeBlock.dup2510
  %SwitchLeaf22972571 = icmp eq i64 %39, 2
  br i1 %SwitchLeaf22972571, label %.sink.split.dup2640, label %bb.dup2595

.sink.split.dup2640:                              ; preds = %LeafBlock.dup2570
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %bb.dup2659

bb.dup2659:                                       ; preds = %.sink.split.dup2640
  br label %cond_949_case_1.dup2700

cond_949_case_1.dup2700:                          ; preds = %bb.dup2659
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %43 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %44 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %45 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb.dup2595:                                       ; preds = %LeafBlock.dup2570
  br label %cond_949_case_1.dup2683

cond_949_case_1.dup2683:                          ; preds = %bb.dup2595
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %46 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %47 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %48 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2537:                              ; preds = %NodeBlock.dup2510
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  br label %bb.dup2551

bb.dup2551:                                       ; preds = %.sink.split.dup2537
  br label %cond_949_case_1.dup2675

cond_949_case_1.dup2675:                          ; preds = %bb.dup2551
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %49 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %50 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %51 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb:                                               ; preds = %cond_exit_176.dup2362, %cond_exit_176.dup2357
  %phi.edge2363 = phi i64 [ %2, %cond_exit_176.dup2357 ], [ %phi.edge2335, %cond_exit_176.dup2362 ]
  %phi.edge2364 = phi i1 [ %6, %cond_exit_176.dup2357 ], [ %27, %cond_exit_176.dup2362 ]
  %phi.edge2365 = phi i1 [ %5, %cond_exit_176.dup2357 ], [ %26, %cond_exit_176.dup2362 ]
  %phi.edge2366 = phi i1 [ %4, %cond_exit_176.dup2357 ], [ %25, %cond_exit_176.dup2362 ]
  %phi.edge2367 = phi i1 [ %3, %cond_exit_176.dup2357 ], [ %24, %cond_exit_176.dup2362 ]
  tail call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 1 to ptr))
  br label %cond_374_case_1.dup

cond_374_case_1.dup:                              ; preds = %bb
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 2 to ptr))
  %52 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 3 to ptr))
  %53 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 4 to ptr))
  %54 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 5 to ptr))
  %55 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 5 to ptr))
  %"1370_0.02229" = select i1 %52, i64 8, i64 0
  %"1408_0.02230" = select i1 %53, i64 4, i64 0
  %"1446_0.02231" = select i1 %54, i64 2, i64 0
  %"1484_0.02232" = zext i1 %55 to i64
  %56 = or disjoint i64 %"1408_0.02230", %"1370_0.02229"
  %57 = or disjoint i64 %56, %"1446_0.02231"
  %58 = or disjoint i64 %57, %"1484_0.02232"
  %"1282_0.02233" = zext i1 %54 to i64
  %59 = add nuw nsw i64 %phi.edge2363, %"1282_0.02233"
  %Pivot20892234 = icmp slt i64 %59, 1
  br i1 %Pivot20892234, label %.sink.split.dup2268, label %NodeBlock.dup

NodeBlock.dup:                                    ; preds = %cond_374_case_1.dup
  %Pivot2277 = icmp eq i64 %59, 1
  br i1 %Pivot2277, label %.sink.split.dup2312, label %LeafBlock.dup

.sink.split.dup2312:                              ; preds = %NodeBlock.dup
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  br label %bb.dup2323

bb.dup2323:                                       ; preds = %.sink.split.dup2312
  br label %cond_949_case_1.dup2669

cond_949_case_1.dup2669:                          ; preds = %bb.dup2323
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %60 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %61 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %62 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

LeafBlock.dup:                                    ; preds = %NodeBlock.dup
  %SwitchLeaf2295 = icmp eq i64 %59, 2
  br i1 %SwitchLeaf2295, label %.sink.split.dup2635, label %bb.dup2325

.sink.split.dup2635:                              ; preds = %LeafBlock.dup
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %bb.dup2654

bb.dup2654:                                       ; preds = %.sink.split.dup2635
  br label %cond_949_case_1.dup2695

cond_949_case_1.dup2695:                          ; preds = %bb.dup2654
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %63 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %64 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %65 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb.dup2325:                                       ; preds = %LeafBlock.dup
  br label %cond_949_case_1.dup2670

cond_949_case_1.dup2670:                          ; preds = %bb.dup2325
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %66 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %67 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %68 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2268:                              ; preds = %cond_374_case_1.dup
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %bb.dup2321

bb.dup2321:                                       ; preds = %.sink.split.dup2268
  br label %cond_949_case_1.dup

cond_949_case_1.dup:                              ; preds = %bb.dup2321
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %69 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %70 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %71 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

__prepare_module_record_output_final:             ; preds = %cond_949_case_1.dup2700, %cond_949_case_1.dup2696, %cond_949_case_1.dup2695, %cond_949_case_1.dup2691, %cond_949_case_1.dup2683, %cond_949_case_1.dup2675, %cond_949_case_1.dup2671, %cond_949_case_1.dup2670, %cond_949_case_1.dup2669, %cond_949_case_1.dup
  %phi.calluser.edge2711 = phi i1 [ %71, %cond_949_case_1.dup ], [ %62, %cond_949_case_1.dup2669 ], [ %68, %cond_949_case_1.dup2670 ], [ %23, %cond_949_case_1.dup2671 ], [ %51, %cond_949_case_1.dup2675 ], [ %48, %cond_949_case_1.dup2683 ], [ %42, %cond_949_case_1.dup2691 ], [ %65, %cond_949_case_1.dup2695 ], [ %20, %cond_949_case_1.dup2696 ], [ %45, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2710 = phi i1 [ %70, %cond_949_case_1.dup ], [ %61, %cond_949_case_1.dup2669 ], [ %67, %cond_949_case_1.dup2670 ], [ %22, %cond_949_case_1.dup2671 ], [ %50, %cond_949_case_1.dup2675 ], [ %47, %cond_949_case_1.dup2683 ], [ %41, %cond_949_case_1.dup2691 ], [ %64, %cond_949_case_1.dup2695 ], [ %19, %cond_949_case_1.dup2696 ], [ %44, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2709 = phi i1 [ %69, %cond_949_case_1.dup ], [ %60, %cond_949_case_1.dup2669 ], [ %66, %cond_949_case_1.dup2670 ], [ %21, %cond_949_case_1.dup2671 ], [ %49, %cond_949_case_1.dup2675 ], [ %46, %cond_949_case_1.dup2683 ], [ %40, %cond_949_case_1.dup2691 ], [ %63, %cond_949_case_1.dup2695 ], [ %18, %cond_949_case_1.dup2696 ], [ %43, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2708 = phi i1 [ %phi.edge2367, %cond_949_case_1.dup ], [ %phi.edge2367, %cond_949_case_1.dup2669 ], [ %phi.edge2367, %cond_949_case_1.dup2670 ], [ %7, %cond_949_case_1.dup2671 ], [ %28, %cond_949_case_1.dup2675 ], [ %28, %cond_949_case_1.dup2683 ], [ %28, %cond_949_case_1.dup2691 ], [ %phi.edge2367, %cond_949_case_1.dup2695 ], [ %7, %cond_949_case_1.dup2696 ], [ %28, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2707 = phi i1 [ %phi.edge2366, %cond_949_case_1.dup ], [ %phi.edge2366, %cond_949_case_1.dup2669 ], [ %phi.edge2366, %cond_949_case_1.dup2670 ], [ %8, %cond_949_case_1.dup2671 ], [ %29, %cond_949_case_1.dup2675 ], [ %29, %cond_949_case_1.dup2683 ], [ %29, %cond_949_case_1.dup2691 ], [ %phi.edge2366, %cond_949_case_1.dup2695 ], [ %8, %cond_949_case_1.dup2696 ], [ %29, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2706 = phi i1 [ %phi.edge2365, %cond_949_case_1.dup ], [ %phi.edge2365, %cond_949_case_1.dup2669 ], [ %phi.edge2365, %cond_949_case_1.dup2670 ], [ %9, %cond_949_case_1.dup2671 ], [ %30, %cond_949_case_1.dup2675 ], [ %30, %cond_949_case_1.dup2683 ], [ %30, %cond_949_case_1.dup2691 ], [ %phi.edge2365, %cond_949_case_1.dup2695 ], [ %9, %cond_949_case_1.dup2696 ], [ %30, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge = phi i1 [ %phi.edge2364, %cond_949_case_1.dup ], [ %phi.edge2364, %cond_949_case_1.dup2669 ], [ %phi.edge2364, %cond_949_case_1.dup2670 ], [ %10, %cond_949_case_1.dup2671 ], [ %31, %cond_949_case_1.dup2675 ], [ %31, %cond_949_case_1.dup2683 ], [ %31, %cond_949_case_1.dup2691 ], [ %phi.edge2364, %cond_949_case_1.dup2695 ], [ %10, %cond_949_case_1.dup2696 ], [ %31, %cond_949_case_1.dup2700 ]
  %phi.edge2704 = phi i64 [ %58, %cond_949_case_1.dup ], [ %58, %cond_949_case_1.dup2669 ], [ %58, %cond_949_case_1.dup2670 ], [ %17, %cond_949_case_1.dup2671 ], [ %38, %cond_949_case_1.dup2675 ], [ %38, %cond_949_case_1.dup2683 ], [ %38, %cond_949_case_1.dup2691 ], [ %58, %cond_949_case_1.dup2695 ], [ %17, %cond_949_case_1.dup2696 ], [ %38, %cond_949_case_1.dup2700 ]
  %phi.edge2705 = phi i64 [ %phi.edge2363, %cond_949_case_1.dup ], [ %phi.edge2363, %cond_949_case_1.dup2669 ], [ %phi.edge2363, %cond_949_case_1.dup2670 ], [ %"48_2.0", %cond_949_case_1.dup2671 ], [ %phi.edge2335, %cond_949_case_1.dup2675 ], [ %phi.edge2335, %cond_949_case_1.dup2683 ], [ %phi.edge2335, %cond_949_case_1.dup2691 ], [ %phi.edge2363, %cond_949_case_1.dup2695 ], [ %"48_2.0", %cond_949_case_1.dup2696 ], [ %phi.edge2335, %cond_949_case_1.dup2700 ]
  call void @__quantum__rt__bool_record_output(i1 %0, ptr noundef nonnull @0)
  call void @__quantum__rt__bool_record_output(i1 noundef %1, ptr noundef nonnull @1)
  call void @__quantum__rt__int_record_output(i64 %phi.edge2704, ptr noundef nonnull @7)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2708, ptr noundef nonnull @2)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2707, ptr noundef nonnull @3)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2706, ptr noundef nonnull @4)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge, ptr noundef nonnull @5)
  call void @__quantum__rt__int_record_output(i64 %phi.edge2705, ptr noundef nonnull @6)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2709, ptr noundef nonnull @8)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2710, ptr noundef nonnull @9)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2711, ptr noundef nonnull @10)
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
