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
  br i1 %1, label %alloca_block.dup, label %alloca_block.dup2194

alloca_block.dup:                                 ; preds = %alloca_block
  %2 = select i1 %0, i64 2, i64 1
  br i1 %0, label %cond_exit_855.dup2220, label %cond_exit_755.dup

cond_exit_755.dup:                                ; preds = %alloca_block.dup
  br label %cond_exit_101

cond_exit_855.dup2220:                            ; preds = %alloca_block.dup
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
  br label %bb.dup2346

bb.dup2346:                                       ; preds = %cond_exit_855.dup2220
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef null)
  br label %cond_exit_176.dup2355

cond_exit_176.dup2355:                            ; preds = %bb.dup2346
  br label %bb

alloca_block.dup2194:                             ; preds = %alloca_block
  br label %cond_exit_755.dup2333

cond_exit_755.dup2333:                            ; preds = %alloca_block.dup2194
  br i1 %0, label %cond_exit_855.dup2337, label %cond_exit_101

cond_exit_855.dup2337:                            ; preds = %cond_exit_755.dup2333
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
  br label %bb.dup2347

bb.dup2347:                                       ; preds = %cond_exit_855.dup2337
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef null)
  br label %cond_exit_176.dup2356

cond_exit_176.dup2356:                            ; preds = %bb.dup2347
  br label %cond_374_case_1.dup2437

cond_374_case_1.dup2437:                          ; preds = %cond_exit_176.dup2356
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 2 to ptr))
  %11 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 3 to ptr))
  %12 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 4 to ptr))
  %13 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 5 to ptr))
  %14 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 5 to ptr))
  %"1370_0.022292438" = select i1 %11, i64 8, i64 0
  %"1408_0.022302439" = select i1 %12, i64 4, i64 0
  %"1446_0.022312440" = select i1 %13, i64 2, i64 0
  %"1484_0.022322441" = zext i1 %14 to i64
  %15 = or disjoint i64 %"1408_0.022302439", %"1370_0.022292438"
  %16 = or disjoint i64 %15, %"1446_0.022312440"
  %17 = or disjoint i64 %16, %"1484_0.022322441"
  br label %NodeBlock.dup2505

NodeBlock.dup2505:                                ; preds = %cond_374_case_1.dup2437
  br i1 %13, label %LeafBlock.dup2565, label %.sink.split.dup2534

LeafBlock.dup2565:                                ; preds = %NodeBlock.dup2505
  br label %.sink.split.dup2634

.sink.split.dup2634:                              ; preds = %LeafBlock.dup2565
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %bb.dup2653

bb.dup2653:                                       ; preds = %.sink.split.dup2634
  br label %cond_949_case_1.dup2674

cond_949_case_1.dup2674:                          ; preds = %bb.dup2653
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %18 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %19 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %20 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2534:                              ; preds = %NodeBlock.dup2505
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  br label %bb.dup2548

bb.dup2548:                                       ; preds = %.sink.split.dup2534
  br label %cond_949_case_1.dup2676

cond_949_case_1.dup2676:                          ; preds = %bb.dup2548
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %21 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %22 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %23 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_exit_101:                                    ; preds = %cond_exit_755.dup, %cond_exit_755.dup2333
  %phi.edge2334 = phi i64 [ %2, %cond_exit_755.dup ], [ %"48_2.0", %cond_exit_755.dup2333 ]
  br i1 %1, label %cond_exit_101.dup, label %cond_exit_101.dup2095

cond_exit_101.dup:                                ; preds = %cond_exit_101
  br label %cond_exit_101.dup2185

cond_exit_101.dup2185:                            ; preds = %cond_exit_101.dup
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
  br label %cond_exit_176.dup2358

cond_exit_176.dup2358:                            ; preds = %cond_exit_101.dup2185
  br label %bb

cond_exit_101.dup2095:                            ; preds = %cond_exit_101
  br label %cond_exit_101.dup2174

cond_exit_101.dup2174:                            ; preds = %cond_exit_101.dup2095
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
  br label %cond_exit_176.dup2361

cond_exit_176.dup2361:                            ; preds = %cond_exit_101.dup2174
  br label %cond_374_case_1.dup2472

cond_374_case_1.dup2472:                          ; preds = %cond_exit_176.dup2361
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 2 to ptr))
  %32 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 3 to ptr))
  %33 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 4 to ptr))
  %34 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 5 to ptr))
  %35 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 5 to ptr))
  %"1370_0.022292473" = select i1 %32, i64 8, i64 0
  %"1408_0.022302474" = select i1 %33, i64 4, i64 0
  %"1446_0.022312475" = select i1 %34, i64 2, i64 0
  %"1484_0.022322476" = zext i1 %35 to i64
  %36 = or disjoint i64 %"1408_0.022302474", %"1370_0.022292473"
  %37 = or disjoint i64 %36, %"1446_0.022312475"
  %38 = or disjoint i64 %37, %"1484_0.022322476"
  %"1282_0.022332477" = zext i1 %34 to i64
  %39 = add nuw nsw i64 %phi.edge2334, %"1282_0.022332477"
  %Pivot208922342478 = icmp eq i64 %39, 0
  br i1 %Pivot208922342478, label %.sink.split.dup2610, label %NodeBlock.dup2515

.sink.split.dup2610:                              ; preds = %cond_374_case_1.dup2472
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %bb.dup2624

bb.dup2624:                                       ; preds = %.sink.split.dup2610
  br label %cond_949_case_1.dup2693

cond_949_case_1.dup2693:                          ; preds = %bb.dup2624
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %40 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %41 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %42 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

NodeBlock.dup2515:                                ; preds = %cond_374_case_1.dup2472
  %Pivot22772516 = icmp eq i64 %39, 1
  br i1 %Pivot22772516, label %.sink.split.dup2539, label %LeafBlock.dup2575

LeafBlock.dup2575:                                ; preds = %NodeBlock.dup2515
  %SwitchLeaf22952576 = icmp eq i64 %39, 2
  br i1 %SwitchLeaf22952576, label %.sink.split.dup2639, label %bb.dup2596

.sink.split.dup2639:                              ; preds = %LeafBlock.dup2575
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %bb.dup2658

bb.dup2658:                                       ; preds = %.sink.split.dup2639
  br label %cond_949_case_1.dup2694

cond_949_case_1.dup2694:                          ; preds = %bb.dup2658
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %43 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %44 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %45 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb.dup2596:                                       ; preds = %LeafBlock.dup2575
  br label %cond_949_case_1.dup2695

cond_949_case_1.dup2695:                          ; preds = %bb.dup2596
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %46 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %47 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %48 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2539:                              ; preds = %NodeBlock.dup2515
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  br label %bb.dup2553

bb.dup2553:                                       ; preds = %.sink.split.dup2539
  br label %cond_949_case_1.dup2696

cond_949_case_1.dup2696:                          ; preds = %bb.dup2553
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %49 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %50 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FEE28C731EB6950, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %51 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb:                                               ; preds = %cond_exit_176.dup2358, %cond_exit_176.dup2355
  %phi.edge2362 = phi i64 [ %2, %cond_exit_176.dup2355 ], [ %phi.edge2334, %cond_exit_176.dup2358 ]
  %phi.edge2363 = phi i1 [ %6, %cond_exit_176.dup2355 ], [ %27, %cond_exit_176.dup2358 ]
  %phi.edge2364 = phi i1 [ %5, %cond_exit_176.dup2355 ], [ %26, %cond_exit_176.dup2358 ]
  %phi.edge2365 = phi i1 [ %4, %cond_exit_176.dup2355 ], [ %25, %cond_exit_176.dup2358 ]
  %phi.edge2366 = phi i1 [ %3, %cond_exit_176.dup2355 ], [ %24, %cond_exit_176.dup2358 ]
  tail call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 1 to ptr))
  br label %cond_374_case_1.dup2235

cond_374_case_1.dup2235:                          ; preds = %bb
  call void @__quantum__qis__mz__body(ptr noundef null, ptr noundef nonnull inttoptr (i64 2 to ptr))
  %52 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 1 to ptr), ptr noundef nonnull inttoptr (i64 3 to ptr))
  %53 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 2 to ptr), ptr noundef nonnull inttoptr (i64 4 to ptr))
  %54 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 3 to ptr), ptr noundef nonnull inttoptr (i64 5 to ptr))
  %55 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 5 to ptr))
  %"1370_0.02236" = select i1 %52, i64 8, i64 0
  %"1408_0.02237" = select i1 %53, i64 4, i64 0
  %"1446_0.02238" = select i1 %54, i64 2, i64 0
  %"1484_0.02239" = zext i1 %55 to i64
  %56 = or disjoint i64 %"1408_0.02237", %"1370_0.02236"
  %57 = or disjoint i64 %56, %"1446_0.02238"
  %58 = or disjoint i64 %57, %"1484_0.02239"
  %"1282_0.02240" = zext i1 %54 to i64
  %59 = add nuw nsw i64 %phi.edge2362, %"1282_0.02240"
  %Pivot20892241 = icmp slt i64 %59, 1
  br i1 %Pivot20892241, label %.sink.split.dup2269, label %NodeBlock.dup2278

NodeBlock.dup2278:                                ; preds = %cond_374_case_1.dup2235
  %Pivot2279 = icmp eq i64 %59, 1
  br i1 %Pivot2279, label %.sink.split.dup2312, label %LeafBlock.dup2296

.sink.split.dup2312:                              ; preds = %NodeBlock.dup2278
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  br label %bb.dup2322

bb.dup2322:                                       ; preds = %.sink.split.dup2312
  br label %cond_949_case_1.dup2697

cond_949_case_1.dup2697:                          ; preds = %bb.dup2322
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %60 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %61 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %62 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

LeafBlock.dup2296:                                ; preds = %NodeBlock.dup2278
  %SwitchLeaf2297 = icmp eq i64 %59, 2
  br i1 %SwitchLeaf2297, label %.sink.split.dup2640, label %bb.dup2323

.sink.split.dup2640:                              ; preds = %LeafBlock.dup2296
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %bb.dup2659

bb.dup2659:                                       ; preds = %.sink.split.dup2640
  br label %cond_949_case_1.dup2698

cond_949_case_1.dup2698:                          ; preds = %bb.dup2659
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %63 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %64 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %65 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb.dup2323:                                       ; preds = %LeafBlock.dup2296
  br label %cond_949_case_1.dup2699

cond_949_case_1.dup2699:                          ; preds = %bb.dup2323
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %66 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %67 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %68 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2269:                              ; preds = %cond_374_case_1.dup2235
  call void @__quantum__qis__phasedx__body(double noundef 0x400921FB54442D18, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 6 to ptr))
  br label %bb.dup2324

bb.dup2324:                                       ; preds = %.sink.split.dup2269
  br label %cond_949_case_1.dup2700

cond_949_case_1.dup2700:                          ; preds = %bb.dup2324
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 6 to ptr), ptr noundef nonnull inttoptr (i64 10 to ptr))
  %69 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 7 to ptr), ptr noundef nonnull inttoptr (i64 11 to ptr))
  %70 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double noundef 0x3FE41B2F769CF0E0, double noundef 0.000000e+00, ptr noundef nonnull inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr noundef nonnull inttoptr (i64 8 to ptr), ptr noundef nonnull inttoptr (i64 12 to ptr))
  %71 = call i1 @__quantum__rt__read_result(ptr noundef nonnull inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

__prepare_module_record_output_final:             ; preds = %cond_949_case_1.dup2700, %cond_949_case_1.dup2699, %cond_949_case_1.dup2698, %cond_949_case_1.dup2697, %cond_949_case_1.dup2696, %cond_949_case_1.dup2695, %cond_949_case_1.dup2694, %cond_949_case_1.dup2693, %cond_949_case_1.dup2676, %cond_949_case_1.dup2674
  %phi.calluser.edge2708 = phi i1 [ %20, %cond_949_case_1.dup2674 ], [ %23, %cond_949_case_1.dup2676 ], [ %42, %cond_949_case_1.dup2693 ], [ %45, %cond_949_case_1.dup2694 ], [ %48, %cond_949_case_1.dup2695 ], [ %51, %cond_949_case_1.dup2696 ], [ %62, %cond_949_case_1.dup2697 ], [ %65, %cond_949_case_1.dup2698 ], [ %68, %cond_949_case_1.dup2699 ], [ %71, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2707 = phi i1 [ %19, %cond_949_case_1.dup2674 ], [ %22, %cond_949_case_1.dup2676 ], [ %41, %cond_949_case_1.dup2693 ], [ %44, %cond_949_case_1.dup2694 ], [ %47, %cond_949_case_1.dup2695 ], [ %50, %cond_949_case_1.dup2696 ], [ %61, %cond_949_case_1.dup2697 ], [ %64, %cond_949_case_1.dup2698 ], [ %67, %cond_949_case_1.dup2699 ], [ %70, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2706 = phi i1 [ %18, %cond_949_case_1.dup2674 ], [ %21, %cond_949_case_1.dup2676 ], [ %40, %cond_949_case_1.dup2693 ], [ %43, %cond_949_case_1.dup2694 ], [ %46, %cond_949_case_1.dup2695 ], [ %49, %cond_949_case_1.dup2696 ], [ %60, %cond_949_case_1.dup2697 ], [ %63, %cond_949_case_1.dup2698 ], [ %66, %cond_949_case_1.dup2699 ], [ %69, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2705 = phi i1 [ %7, %cond_949_case_1.dup2674 ], [ %7, %cond_949_case_1.dup2676 ], [ %28, %cond_949_case_1.dup2693 ], [ %28, %cond_949_case_1.dup2694 ], [ %28, %cond_949_case_1.dup2695 ], [ %28, %cond_949_case_1.dup2696 ], [ %phi.edge2366, %cond_949_case_1.dup2697 ], [ %phi.edge2366, %cond_949_case_1.dup2698 ], [ %phi.edge2366, %cond_949_case_1.dup2699 ], [ %phi.edge2366, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2704 = phi i1 [ %8, %cond_949_case_1.dup2674 ], [ %8, %cond_949_case_1.dup2676 ], [ %29, %cond_949_case_1.dup2693 ], [ %29, %cond_949_case_1.dup2694 ], [ %29, %cond_949_case_1.dup2695 ], [ %29, %cond_949_case_1.dup2696 ], [ %phi.edge2365, %cond_949_case_1.dup2697 ], [ %phi.edge2365, %cond_949_case_1.dup2698 ], [ %phi.edge2365, %cond_949_case_1.dup2699 ], [ %phi.edge2365, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2703 = phi i1 [ %9, %cond_949_case_1.dup2674 ], [ %9, %cond_949_case_1.dup2676 ], [ %30, %cond_949_case_1.dup2693 ], [ %30, %cond_949_case_1.dup2694 ], [ %30, %cond_949_case_1.dup2695 ], [ %30, %cond_949_case_1.dup2696 ], [ %phi.edge2364, %cond_949_case_1.dup2697 ], [ %phi.edge2364, %cond_949_case_1.dup2698 ], [ %phi.edge2364, %cond_949_case_1.dup2699 ], [ %phi.edge2364, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge = phi i1 [ %10, %cond_949_case_1.dup2674 ], [ %10, %cond_949_case_1.dup2676 ], [ %31, %cond_949_case_1.dup2693 ], [ %31, %cond_949_case_1.dup2694 ], [ %31, %cond_949_case_1.dup2695 ], [ %31, %cond_949_case_1.dup2696 ], [ %phi.edge2363, %cond_949_case_1.dup2697 ], [ %phi.edge2363, %cond_949_case_1.dup2698 ], [ %phi.edge2363, %cond_949_case_1.dup2699 ], [ %phi.edge2363, %cond_949_case_1.dup2700 ]
  %phi.edge2701 = phi i64 [ %17, %cond_949_case_1.dup2674 ], [ %17, %cond_949_case_1.dup2676 ], [ %38, %cond_949_case_1.dup2693 ], [ %38, %cond_949_case_1.dup2694 ], [ %38, %cond_949_case_1.dup2695 ], [ %38, %cond_949_case_1.dup2696 ], [ %58, %cond_949_case_1.dup2697 ], [ %58, %cond_949_case_1.dup2698 ], [ %58, %cond_949_case_1.dup2699 ], [ %58, %cond_949_case_1.dup2700 ]
  %phi.edge2702 = phi i64 [ %"48_2.0", %cond_949_case_1.dup2674 ], [ %"48_2.0", %cond_949_case_1.dup2676 ], [ %phi.edge2334, %cond_949_case_1.dup2693 ], [ %phi.edge2334, %cond_949_case_1.dup2694 ], [ %phi.edge2334, %cond_949_case_1.dup2695 ], [ %phi.edge2334, %cond_949_case_1.dup2696 ], [ %phi.edge2362, %cond_949_case_1.dup2697 ], [ %phi.edge2362, %cond_949_case_1.dup2698 ], [ %phi.edge2362, %cond_949_case_1.dup2699 ], [ %phi.edge2362, %cond_949_case_1.dup2700 ]
  call void @__quantum__rt__bool_record_output(i1 %0, ptr noundef nonnull @0)
  call void @__quantum__rt__bool_record_output(i1 noundef %1, ptr noundef nonnull @1)
  call void @__quantum__rt__int_record_output(i64 %phi.edge2701, ptr noundef nonnull @7)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2705, ptr noundef nonnull @2)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2704, ptr noundef nonnull @3)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2703, ptr noundef nonnull @4)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge, ptr noundef nonnull @5)
  call void @__quantum__rt__int_record_output(i64 %phi.edge2702, ptr noundef nonnull @6)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2706, ptr noundef nonnull @8)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2707, ptr noundef nonnull @9)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2708, ptr noundef nonnull @10)
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
