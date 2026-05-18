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
  tail call void @__quantum__rt__initialize(ptr null)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 4 to ptr), ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 1 to ptr))
  %1 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 1 to ptr))
  %"48_2.0" = zext i1 %0 to i64
  %2 = select i1 %0, i64 2, i64 1
  br i1 %1, label %alloca_block.dup, label %alloca_block.dup2194

alloca_block.dup:                                 ; preds = %alloca_block
  %"74_2.021922193" = select i1 %1, i64 %2, i64 %"48_2.0"
  %3 = select i1 %0, i1 %1, i1 false
  br i1 %3, label %cond_exit_855.dup2220, label %cond_exit_755.dup

cond_exit_755.dup:                                ; preds = %alloca_block.dup
  br i1 %0, label %cond_exit_855.dup, label %cond_exit_101

cond_exit_855.dup:                                ; preds = %cond_exit_755.dup
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %4 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %5 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %6 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %7 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  br label %bb.dup2345

bb.dup2345:                                       ; preds = %cond_exit_855.dup
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  br label %cond_exit_176.dup

cond_exit_176.dup:                                ; preds = %bb.dup2345
  br i1 false, label %bb, label %cond_374_case_1.dup2423

cond_374_case_1.dup2423:                          ; preds = %cond_exit_176.dup
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %8 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %9 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %10 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %11 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  %"1370_0.022292424" = select i1 %8, i64 8, i64 0
  %"1408_0.022302425" = select i1 %9, i64 4, i64 0
  %"1446_0.022312426" = select i1 %10, i64 2, i64 0
  %"1484_0.022322427" = zext i1 %11 to i64
  %12 = or i64 %"1408_0.022302425", %"1370_0.022292424"
  %13 = or i64 %12, %"1446_0.022312426"
  %14 = or i64 %13, %"1484_0.022322427"
  %"1282_0.022332428" = zext i1 %10 to i64
  %15 = add i64 %"74_2.021922193", %"1282_0.022332428"
  %Pivot208922342429 = icmp slt i64 %15, 1
  br i1 %Pivot208922342429, label %.sink.split.dup, label %NodeBlock.dup2501

.sink.split.dup:                                  ; preds = %cond_374_case_1.dup2423
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2617

bb.dup2617:                                       ; preds = %.sink.split.dup
  %16 = call double @llvm.fabs.f64(double 6.000000e-01)
  %17 = fcmp ueq double %16, 0x7FF0000000000000
  br i1 %17, label %bb0, label %cond_949_case_1.dup

cond_949_case_1.dup:                              ; preds = %bb.dup2617
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %18 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %19 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FFE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %20 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

NodeBlock.dup2501:                                ; preds = %cond_374_case_1.dup2423
  %Pivot22772502 = icmp slt i64 %15, 2
  br i1 %Pivot22772502, label %.sink.split.dup2532, label %LeafBlock.dup2561

LeafBlock.dup2561:                                ; preds = %NodeBlock.dup2501
  %SwitchLeaf22952562 = icmp eq i64 %15, 2
  br i1 %SwitchLeaf22952562, label %.sink.split.dup2632, label %bb.dup

.sink.split.dup2632:                              ; preds = %LeafBlock.dup2561
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2651

bb.dup2651:                                       ; preds = %.sink.split.dup2632
  %21 = call double @llvm.fabs.f64(double 6.000000e-01)
  %22 = fcmp ueq double %21, 0x7FF0000000000000
  br i1 %22, label %bb0, label %cond_949_case_1.dup2666

cond_949_case_1.dup2666:                          ; preds = %bb.dup2651
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %23 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %24 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FFE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %25 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb.dup:                                           ; preds = %LeafBlock.dup2561
  %26 = call double @llvm.fabs.f64(double 6.000000e-01)
  %27 = fcmp ueq double %26, 0x7FF0000000000000
  br i1 %27, label %bb0, label %cond_949_case_1.dup2667

cond_949_case_1.dup2667:                          ; preds = %bb.dup
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %28 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %29 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FFE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %30 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2532:                              ; preds = %NodeBlock.dup2501
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  br label %bb.dup2546

bb.dup2546:                                       ; preds = %.sink.split.dup2532
  %31 = call double @llvm.fabs.f64(double 6.000000e-01)
  %32 = fcmp ueq double %31, 0x7FF0000000000000
  br i1 %32, label %bb0, label %cond_949_case_1.dup2668

cond_949_case_1.dup2668:                          ; preds = %bb.dup2546
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %33 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %34 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FFE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %35 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_exit_855.dup2220:                            ; preds = %alloca_block.dup
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %36 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %37 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %38 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %39 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  br label %bb.dup2346

bb.dup2346:                                       ; preds = %cond_exit_855.dup2220
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  br label %cond_exit_176.dup2355

cond_exit_176.dup2355:                            ; preds = %bb.dup2346
  br i1 true, label %bb, label %cond_374_case_1.dup2430

cond_374_case_1.dup2430:                          ; preds = %cond_exit_176.dup2355
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %40 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %41 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %42 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %43 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  %"1370_0.022292431" = select i1 %40, i64 8, i64 0
  %"1408_0.022302432" = select i1 %41, i64 4, i64 0
  %"1446_0.022312433" = select i1 %42, i64 2, i64 0
  %"1484_0.022322434" = zext i1 %43 to i64
  %44 = or i64 %"1408_0.022302432", %"1370_0.022292431"
  %45 = or i64 %44, %"1446_0.022312433"
  %46 = or i64 %45, %"1484_0.022322434"
  %"1282_0.022332435" = zext i1 %42 to i64
  %47 = add i64 %"74_2.021922193", %"1282_0.022332435"
  %Pivot208922342436 = icmp slt i64 %47, 1
  br i1 %Pivot208922342436, label %.sink.split.dup2604, label %NodeBlock.dup2503

.sink.split.dup2604:                              ; preds = %cond_374_case_1.dup2430
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2618

bb.dup2618:                                       ; preds = %.sink.split.dup2604
  %48 = call double @llvm.fabs.f64(double 6.000000e-01)
  %49 = fcmp ueq double %48, 0x7FF0000000000000
  br i1 %49, label %bb0, label %cond_949_case_1.dup2669

cond_949_case_1.dup2669:                          ; preds = %bb.dup2618
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %50 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %51 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FFE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %52 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

NodeBlock.dup2503:                                ; preds = %cond_374_case_1.dup2430
  %Pivot22772504 = icmp slt i64 %47, 2
  br i1 %Pivot22772504, label %.sink.split.dup2533, label %LeafBlock.dup2563

LeafBlock.dup2563:                                ; preds = %NodeBlock.dup2503
  %SwitchLeaf22952564 = icmp eq i64 %47, 2
  br i1 %SwitchLeaf22952564, label %.sink.split.dup2633, label %bb.dup2590

.sink.split.dup2633:                              ; preds = %LeafBlock.dup2563
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2652

bb.dup2652:                                       ; preds = %.sink.split.dup2633
  %53 = call double @llvm.fabs.f64(double 6.000000e-01)
  %54 = fcmp ueq double %53, 0x7FF0000000000000
  br i1 %54, label %bb0, label %cond_949_case_1.dup2670

cond_949_case_1.dup2670:                          ; preds = %bb.dup2652
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %55 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %56 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FFE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %57 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb.dup2590:                                       ; preds = %LeafBlock.dup2563
  %58 = call double @llvm.fabs.f64(double 6.000000e-01)
  %59 = fcmp ueq double %58, 0x7FF0000000000000
  br i1 %59, label %bb0, label %cond_949_case_1.dup2671

cond_949_case_1.dup2671:                          ; preds = %bb.dup2590
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %60 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %61 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FFE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %62 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2533:                              ; preds = %NodeBlock.dup2503
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  br label %bb.dup2547

bb.dup2547:                                       ; preds = %.sink.split.dup2533
  %63 = call double @llvm.fabs.f64(double 6.000000e-01)
  %64 = fcmp ueq double %63, 0x7FF0000000000000
  br i1 %64, label %bb0, label %cond_949_case_1.dup2672

cond_949_case_1.dup2672:                          ; preds = %bb.dup2547
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %65 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %66 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FFE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %67 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

alloca_block.dup2194:                             ; preds = %alloca_block
  %"74_2.021922195" = select i1 %1, i64 %2, i64 %"48_2.0"
  %68 = select i1 %0, i1 %1, i1 false
  br i1 %68, label %cond_exit_855.dup2221, label %cond_exit_755.dup2333

cond_exit_755.dup2333:                            ; preds = %alloca_block.dup2194
  br i1 %0, label %cond_exit_855.dup2337, label %cond_exit_101

cond_exit_855.dup2337:                            ; preds = %cond_exit_755.dup2333
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %69 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %70 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %71 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %72 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  br label %bb.dup2347

bb.dup2347:                                       ; preds = %cond_exit_855.dup2337
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  br label %cond_exit_176.dup2356

cond_exit_176.dup2356:                            ; preds = %bb.dup2347
  br i1 false, label %bb, label %cond_374_case_1.dup2437

cond_374_case_1.dup2437:                          ; preds = %cond_exit_176.dup2356
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %73 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %74 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %75 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %76 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  %"1370_0.022292438" = select i1 %73, i64 8, i64 0
  %"1408_0.022302439" = select i1 %74, i64 4, i64 0
  %"1446_0.022312440" = select i1 %75, i64 2, i64 0
  %"1484_0.022322441" = zext i1 %76 to i64
  %77 = or i64 %"1408_0.022302439", %"1370_0.022292438"
  %78 = or i64 %77, %"1446_0.022312440"
  %79 = or i64 %78, %"1484_0.022322441"
  %"1282_0.022332442" = zext i1 %75 to i64
  %80 = add i64 %"74_2.021922195", %"1282_0.022332442"
  %Pivot208922342443 = icmp slt i64 %80, 1
  br i1 %Pivot208922342443, label %.sink.split.dup2605, label %NodeBlock.dup2505

.sink.split.dup2605:                              ; preds = %cond_374_case_1.dup2437
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2619

bb.dup2619:                                       ; preds = %.sink.split.dup2605
  %81 = call double @llvm.fabs.f64(double 3.000000e-01)
  %82 = fcmp ueq double %81, 0x7FF0000000000000
  br i1 %82, label %bb0, label %cond_949_case_1.dup2673

cond_949_case_1.dup2673:                          ; preds = %bb.dup2619
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %83 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %84 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %85 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

NodeBlock.dup2505:                                ; preds = %cond_374_case_1.dup2437
  %Pivot22772506 = icmp slt i64 %80, 2
  br i1 %Pivot22772506, label %.sink.split.dup2534, label %LeafBlock.dup2565

LeafBlock.dup2565:                                ; preds = %NodeBlock.dup2505
  %SwitchLeaf22952566 = icmp eq i64 %80, 2
  br i1 %SwitchLeaf22952566, label %.sink.split.dup2634, label %bb.dup2591

.sink.split.dup2634:                              ; preds = %LeafBlock.dup2565
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2653

bb.dup2653:                                       ; preds = %.sink.split.dup2634
  %86 = call double @llvm.fabs.f64(double 3.000000e-01)
  %87 = fcmp ueq double %86, 0x7FF0000000000000
  br i1 %87, label %bb0, label %cond_949_case_1.dup2674

cond_949_case_1.dup2674:                          ; preds = %bb.dup2653
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %88 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %89 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %90 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb.dup2591:                                       ; preds = %LeafBlock.dup2565
  %91 = call double @llvm.fabs.f64(double 3.000000e-01)
  %92 = fcmp ueq double %91, 0x7FF0000000000000
  br i1 %92, label %bb0, label %cond_949_case_1.dup2675

cond_949_case_1.dup2675:                          ; preds = %bb.dup2591
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %93 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %94 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %95 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2534:                              ; preds = %NodeBlock.dup2505
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  br label %bb.dup2548

bb.dup2548:                                       ; preds = %.sink.split.dup2534
  %96 = call double @llvm.fabs.f64(double 3.000000e-01)
  %97 = fcmp ueq double %96, 0x7FF0000000000000
  br i1 %97, label %bb0, label %cond_949_case_1.dup2676

cond_949_case_1.dup2676:                          ; preds = %bb.dup2548
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %98 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %99 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %100 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_exit_855.dup2221:                            ; preds = %alloca_block.dup2194
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %101 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %102 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %103 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %104 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  br label %bb.dup2348

bb.dup2348:                                       ; preds = %cond_exit_855.dup2221
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  br label %cond_exit_176.dup2357

cond_exit_176.dup2357:                            ; preds = %bb.dup2348
  br i1 true, label %bb, label %cond_374_case_1.dup2444

cond_374_case_1.dup2444:                          ; preds = %cond_exit_176.dup2357
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %105 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %106 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %107 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %108 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  %"1370_0.022292445" = select i1 %105, i64 8, i64 0
  %"1408_0.022302446" = select i1 %106, i64 4, i64 0
  %"1446_0.022312447" = select i1 %107, i64 2, i64 0
  %"1484_0.022322448" = zext i1 %108 to i64
  %109 = or i64 %"1408_0.022302446", %"1370_0.022292445"
  %110 = or i64 %109, %"1446_0.022312447"
  %111 = or i64 %110, %"1484_0.022322448"
  %"1282_0.022332449" = zext i1 %107 to i64
  %112 = add i64 %"74_2.021922195", %"1282_0.022332449"
  %Pivot208922342450 = icmp slt i64 %112, 1
  br i1 %Pivot208922342450, label %.sink.split.dup2606, label %NodeBlock.dup2507

.sink.split.dup2606:                              ; preds = %cond_374_case_1.dup2444
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2620

bb.dup2620:                                       ; preds = %.sink.split.dup2606
  %113 = call double @llvm.fabs.f64(double 3.000000e-01)
  %114 = fcmp ueq double %113, 0x7FF0000000000000
  br i1 %114, label %bb0, label %cond_949_case_1.dup2677

cond_949_case_1.dup2677:                          ; preds = %bb.dup2620
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %115 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %116 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %117 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

NodeBlock.dup2507:                                ; preds = %cond_374_case_1.dup2444
  %Pivot22772508 = icmp slt i64 %112, 2
  br i1 %Pivot22772508, label %.sink.split.dup2535, label %LeafBlock.dup2567

LeafBlock.dup2567:                                ; preds = %NodeBlock.dup2507
  %SwitchLeaf22952568 = icmp eq i64 %112, 2
  br i1 %SwitchLeaf22952568, label %.sink.split.dup2635, label %bb.dup2592

.sink.split.dup2635:                              ; preds = %LeafBlock.dup2567
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2654

bb.dup2654:                                       ; preds = %.sink.split.dup2635
  %118 = call double @llvm.fabs.f64(double 3.000000e-01)
  %119 = fcmp ueq double %118, 0x7FF0000000000000
  br i1 %119, label %bb0, label %cond_949_case_1.dup2678

cond_949_case_1.dup2678:                          ; preds = %bb.dup2654
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %120 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %121 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %122 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb.dup2592:                                       ; preds = %LeafBlock.dup2567
  %123 = call double @llvm.fabs.f64(double 3.000000e-01)
  %124 = fcmp ueq double %123, 0x7FF0000000000000
  br i1 %124, label %bb0, label %cond_949_case_1.dup2679

cond_949_case_1.dup2679:                          ; preds = %bb.dup2592
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %125 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %126 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %127 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2535:                              ; preds = %NodeBlock.dup2507
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  br label %bb.dup2549

bb.dup2549:                                       ; preds = %.sink.split.dup2535
  %128 = call double @llvm.fabs.f64(double 3.000000e-01)
  %129 = fcmp ueq double %128, 0x7FF0000000000000
  br i1 %129, label %bb0, label %cond_949_case_1.dup2680

cond_949_case_1.dup2680:                          ; preds = %bb.dup2549
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %130 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %131 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %132 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_exit_101:                                    ; preds = %cond_exit_755.dup2333, %cond_exit_755.dup
  %phi.edge2334 = phi i64 [ %"74_2.021922193", %cond_exit_755.dup ], [ %"74_2.021922195", %cond_exit_755.dup2333 ]
  br i1 %1, label %cond_exit_101.dup, label %cond_exit_101.dup2095

cond_exit_101.dup:                                ; preds = %cond_exit_101
  %phi.calluser.edge2198 = phi i64 [ %phi.edge2334, %cond_exit_101 ]
  br i1 %1, label %cond_exit_101.dup2185, label %cond_exit_101.dup2186

cond_exit_101.dup2185:                            ; preds = %cond_exit_101.dup
  %phi.calluser.edge2197 = phi i64 [ %phi.calluser.edge2198, %cond_exit_101.dup ]
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %133 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %134 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %135 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %136 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  br label %cond_exit_176.dup2358

cond_exit_176.dup2358:                            ; preds = %cond_exit_101.dup2185
  br i1 %1, label %bb, label %cond_374_case_1.dup2451

cond_374_case_1.dup2451:                          ; preds = %cond_exit_176.dup2358
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %137 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %138 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %139 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %140 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  %"1370_0.022292452" = select i1 %137, i64 8, i64 0
  %"1408_0.022302453" = select i1 %138, i64 4, i64 0
  %"1446_0.022312454" = select i1 %139, i64 2, i64 0
  %"1484_0.022322455" = zext i1 %140 to i64
  %141 = or i64 %"1408_0.022302453", %"1370_0.022292452"
  %142 = or i64 %141, %"1446_0.022312454"
  %143 = or i64 %142, %"1484_0.022322455"
  %"1282_0.022332456" = zext i1 %139 to i64
  %144 = add i64 %phi.calluser.edge2197, %"1282_0.022332456"
  %Pivot208922342457 = icmp slt i64 %144, 1
  br i1 %Pivot208922342457, label %.sink.split.dup2607, label %NodeBlock.dup2509

.sink.split.dup2607:                              ; preds = %cond_374_case_1.dup2451
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2621

bb.dup2621:                                       ; preds = %.sink.split.dup2607
  %145 = call double @llvm.fabs.f64(double 9.000000e-01)
  %146 = fcmp ueq double %145, 0x7FF0000000000000
  br i1 %146, label %bb0, label %cond_949_case_1.dup2681

cond_949_case_1.dup2681:                          ; preds = %bb.dup2621
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %147 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %148 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x40069E9565708EFC, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %149 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

NodeBlock.dup2509:                                ; preds = %cond_374_case_1.dup2451
  %Pivot22772510 = icmp slt i64 %144, 2
  br i1 %Pivot22772510, label %.sink.split.dup2536, label %LeafBlock.dup2569

LeafBlock.dup2569:                                ; preds = %NodeBlock.dup2509
  %SwitchLeaf22952570 = icmp eq i64 %144, 2
  br i1 %SwitchLeaf22952570, label %.sink.split.dup2636, label %bb.dup2593

.sink.split.dup2636:                              ; preds = %LeafBlock.dup2569
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2655

bb.dup2655:                                       ; preds = %.sink.split.dup2636
  %150 = call double @llvm.fabs.f64(double 9.000000e-01)
  %151 = fcmp ueq double %150, 0x7FF0000000000000
  br i1 %151, label %bb0, label %cond_949_case_1.dup2682

cond_949_case_1.dup2682:                          ; preds = %bb.dup2655
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %152 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %153 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x40069E9565708EFC, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %154 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb.dup2593:                                       ; preds = %LeafBlock.dup2569
  %155 = call double @llvm.fabs.f64(double 9.000000e-01)
  %156 = fcmp ueq double %155, 0x7FF0000000000000
  br i1 %156, label %bb0, label %cond_949_case_1.dup2683

cond_949_case_1.dup2683:                          ; preds = %bb.dup2593
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %157 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %158 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x40069E9565708EFC, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %159 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2536:                              ; preds = %NodeBlock.dup2509
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  br label %bb.dup2550

bb.dup2550:                                       ; preds = %.sink.split.dup2536
  %160 = call double @llvm.fabs.f64(double 9.000000e-01)
  %161 = fcmp ueq double %160, 0x7FF0000000000000
  br i1 %161, label %bb0, label %cond_949_case_1.dup2684

cond_949_case_1.dup2684:                          ; preds = %bb.dup2550
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %162 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %163 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x40069E9565708EFC, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %164 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_exit_101.dup2186:                            ; preds = %cond_exit_101.dup
  %phi.calluser.edge2201 = phi i64 [ %phi.calluser.edge2198, %cond_exit_101.dup ]
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %165 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %166 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %167 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %168 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  br label %cond_exit_176.dup2359

cond_exit_176.dup2359:                            ; preds = %cond_exit_101.dup2186
  br i1 %1, label %bb, label %cond_374_case_1.dup2458

cond_374_case_1.dup2458:                          ; preds = %cond_exit_176.dup2359
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %169 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %170 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %171 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %172 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  %"1370_0.022292459" = select i1 %169, i64 8, i64 0
  %"1408_0.022302460" = select i1 %170, i64 4, i64 0
  %"1446_0.022312461" = select i1 %171, i64 2, i64 0
  %"1484_0.022322462" = zext i1 %172 to i64
  %173 = or i64 %"1408_0.022302460", %"1370_0.022292459"
  %174 = or i64 %173, %"1446_0.022312461"
  %175 = or i64 %174, %"1484_0.022322462"
  %"1282_0.022332463" = zext i1 %171 to i64
  %176 = add i64 %phi.calluser.edge2201, %"1282_0.022332463"
  %Pivot208922342464 = icmp slt i64 %176, 1
  br i1 %Pivot208922342464, label %.sink.split.dup2608, label %NodeBlock.dup2511

.sink.split.dup2608:                              ; preds = %cond_374_case_1.dup2458
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2622

bb.dup2622:                                       ; preds = %.sink.split.dup2608
  %177 = call double @llvm.fabs.f64(double 3.000000e-01)
  %178 = fcmp ueq double %177, 0x7FF0000000000000
  br i1 %178, label %bb0, label %cond_949_case_1.dup2685

cond_949_case_1.dup2685:                          ; preds = %bb.dup2622
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %179 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %180 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %181 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

NodeBlock.dup2511:                                ; preds = %cond_374_case_1.dup2458
  %Pivot22772512 = icmp slt i64 %176, 2
  br i1 %Pivot22772512, label %.sink.split.dup2537, label %LeafBlock.dup2571

LeafBlock.dup2571:                                ; preds = %NodeBlock.dup2511
  %SwitchLeaf22952572 = icmp eq i64 %176, 2
  br i1 %SwitchLeaf22952572, label %.sink.split.dup2637, label %bb.dup2594

.sink.split.dup2637:                              ; preds = %LeafBlock.dup2571
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2656

bb.dup2656:                                       ; preds = %.sink.split.dup2637
  %182 = call double @llvm.fabs.f64(double 3.000000e-01)
  %183 = fcmp ueq double %182, 0x7FF0000000000000
  br i1 %183, label %bb0, label %cond_949_case_1.dup2686

cond_949_case_1.dup2686:                          ; preds = %bb.dup2656
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %184 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %185 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %186 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb.dup2594:                                       ; preds = %LeafBlock.dup2571
  %187 = call double @llvm.fabs.f64(double 3.000000e-01)
  %188 = fcmp ueq double %187, 0x7FF0000000000000
  br i1 %188, label %bb0, label %cond_949_case_1.dup2687

cond_949_case_1.dup2687:                          ; preds = %bb.dup2594
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %189 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %190 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %191 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2537:                              ; preds = %NodeBlock.dup2511
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  br label %bb.dup2551

bb.dup2551:                                       ; preds = %.sink.split.dup2537
  %192 = call double @llvm.fabs.f64(double 3.000000e-01)
  %193 = fcmp ueq double %192, 0x7FF0000000000000
  br i1 %193, label %bb0, label %cond_949_case_1.dup2688

cond_949_case_1.dup2688:                          ; preds = %bb.dup2551
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %194 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %195 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %196 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_exit_101.dup2095:                            ; preds = %cond_exit_101
  %phi.calluser.edge2203 = phi i64 [ %phi.edge2334, %cond_exit_101 ]
  br i1 %1, label %cond_exit_101.dup2173, label %cond_exit_101.dup2174

cond_exit_101.dup2173:                            ; preds = %cond_exit_101.dup2095
  %phi.calluser.edge2202 = phi i64 [ %phi.calluser.edge2203, %cond_exit_101.dup2095 ]
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %197 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %198 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %199 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %200 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  br label %cond_exit_176.dup2360

cond_exit_176.dup2360:                            ; preds = %cond_exit_101.dup2173
  br i1 %1, label %bb, label %cond_374_case_1.dup2465

cond_374_case_1.dup2465:                          ; preds = %cond_exit_176.dup2360
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %201 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %202 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %203 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %204 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  %"1370_0.022292466" = select i1 %201, i64 8, i64 0
  %"1408_0.022302467" = select i1 %202, i64 4, i64 0
  %"1446_0.022312468" = select i1 %203, i64 2, i64 0
  %"1484_0.022322469" = zext i1 %204 to i64
  %205 = or i64 %"1408_0.022302467", %"1370_0.022292466"
  %206 = or i64 %205, %"1446_0.022312468"
  %207 = or i64 %206, %"1484_0.022322469"
  %"1282_0.022332470" = zext i1 %203 to i64
  %208 = add i64 %phi.calluser.edge2202, %"1282_0.022332470"
  %Pivot208922342471 = icmp slt i64 %208, 1
  br i1 %Pivot208922342471, label %.sink.split.dup2609, label %NodeBlock.dup2513

.sink.split.dup2609:                              ; preds = %cond_374_case_1.dup2465
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2623

bb.dup2623:                                       ; preds = %.sink.split.dup2609
  %209 = call double @llvm.fabs.f64(double 9.000000e-01)
  %210 = fcmp ueq double %209, 0x7FF0000000000000
  br i1 %210, label %bb0, label %cond_949_case_1.dup2689

cond_949_case_1.dup2689:                          ; preds = %bb.dup2623
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %211 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %212 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x40069E9565708EFC, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %213 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

NodeBlock.dup2513:                                ; preds = %cond_374_case_1.dup2465
  %Pivot22772514 = icmp slt i64 %208, 2
  br i1 %Pivot22772514, label %.sink.split.dup2538, label %LeafBlock.dup2573

LeafBlock.dup2573:                                ; preds = %NodeBlock.dup2513
  %SwitchLeaf22952574 = icmp eq i64 %208, 2
  br i1 %SwitchLeaf22952574, label %.sink.split.dup2638, label %bb.dup2595

.sink.split.dup2638:                              ; preds = %LeafBlock.dup2573
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2657

bb.dup2657:                                       ; preds = %.sink.split.dup2638
  %214 = call double @llvm.fabs.f64(double 9.000000e-01)
  %215 = fcmp ueq double %214, 0x7FF0000000000000
  br i1 %215, label %bb0, label %cond_949_case_1.dup2690

cond_949_case_1.dup2690:                          ; preds = %bb.dup2657
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %216 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %217 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x40069E9565708EFC, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %218 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb.dup2595:                                       ; preds = %LeafBlock.dup2573
  %219 = call double @llvm.fabs.f64(double 9.000000e-01)
  %220 = fcmp ueq double %219, 0x7FF0000000000000
  br i1 %220, label %bb0, label %cond_949_case_1.dup2691

cond_949_case_1.dup2691:                          ; preds = %bb.dup2595
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %221 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %222 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x40069E9565708EFC, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %223 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2538:                              ; preds = %NodeBlock.dup2513
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  br label %bb.dup2552

bb.dup2552:                                       ; preds = %.sink.split.dup2538
  %224 = call double @llvm.fabs.f64(double 9.000000e-01)
  %225 = fcmp ueq double %224, 0x7FF0000000000000
  br i1 %225, label %bb0, label %cond_949_case_1.dup2692

cond_949_case_1.dup2692:                          ; preds = %bb.dup2552
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %226 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %227 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x40069E9565708EFC, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %228 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_exit_101.dup2174:                            ; preds = %cond_exit_101.dup2095
  %phi.calluser.edge2204 = phi i64 [ %phi.calluser.edge2203, %cond_exit_101.dup2095 ]
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %229 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %230 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %231 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %232 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  br label %cond_exit_176.dup2361

cond_exit_176.dup2361:                            ; preds = %cond_exit_101.dup2174
  br i1 %1, label %bb, label %cond_374_case_1.dup2472

cond_374_case_1.dup2472:                          ; preds = %cond_exit_176.dup2361
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %233 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %234 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %235 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %236 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  %"1370_0.022292473" = select i1 %233, i64 8, i64 0
  %"1408_0.022302474" = select i1 %234, i64 4, i64 0
  %"1446_0.022312475" = select i1 %235, i64 2, i64 0
  %"1484_0.022322476" = zext i1 %236 to i64
  %237 = or i64 %"1408_0.022302474", %"1370_0.022292473"
  %238 = or i64 %237, %"1446_0.022312475"
  %239 = or i64 %238, %"1484_0.022322476"
  %"1282_0.022332477" = zext i1 %235 to i64
  %240 = add i64 %phi.calluser.edge2204, %"1282_0.022332477"
  %Pivot208922342478 = icmp slt i64 %240, 1
  br i1 %Pivot208922342478, label %.sink.split.dup2610, label %NodeBlock.dup2515

.sink.split.dup2610:                              ; preds = %cond_374_case_1.dup2472
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2624

bb.dup2624:                                       ; preds = %.sink.split.dup2610
  %241 = call double @llvm.fabs.f64(double 3.000000e-01)
  %242 = fcmp ueq double %241, 0x7FF0000000000000
  br i1 %242, label %bb0, label %cond_949_case_1.dup2693

cond_949_case_1.dup2693:                          ; preds = %bb.dup2624
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %243 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %244 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %245 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

NodeBlock.dup2515:                                ; preds = %cond_374_case_1.dup2472
  %Pivot22772516 = icmp slt i64 %240, 2
  br i1 %Pivot22772516, label %.sink.split.dup2539, label %LeafBlock.dup2575

LeafBlock.dup2575:                                ; preds = %NodeBlock.dup2515
  %SwitchLeaf22952576 = icmp eq i64 %240, 2
  br i1 %SwitchLeaf22952576, label %.sink.split.dup2639, label %bb.dup2596

.sink.split.dup2639:                              ; preds = %LeafBlock.dup2575
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2658

bb.dup2658:                                       ; preds = %.sink.split.dup2639
  %246 = call double @llvm.fabs.f64(double 3.000000e-01)
  %247 = fcmp ueq double %246, 0x7FF0000000000000
  br i1 %247, label %bb0, label %cond_949_case_1.dup2694

cond_949_case_1.dup2694:                          ; preds = %bb.dup2658
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %248 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %249 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %250 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb.dup2596:                                       ; preds = %LeafBlock.dup2575
  %251 = call double @llvm.fabs.f64(double 3.000000e-01)
  %252 = fcmp ueq double %251, 0x7FF0000000000000
  br i1 %252, label %bb0, label %cond_949_case_1.dup2695

cond_949_case_1.dup2695:                          ; preds = %bb.dup2596
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %253 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %254 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %255 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2539:                              ; preds = %NodeBlock.dup2515
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  br label %bb.dup2553

bb.dup2553:                                       ; preds = %.sink.split.dup2539
  %256 = call double @llvm.fabs.f64(double 3.000000e-01)
  %257 = fcmp ueq double %256, 0x7FF0000000000000
  br i1 %257, label %bb0, label %cond_949_case_1.dup2696

cond_949_case_1.dup2696:                          ; preds = %bb.dup2553
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %258 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %259 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %260 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb:                                               ; preds = %cond_exit_176.dup2361, %cond_exit_176.dup2360, %cond_exit_176.dup2359, %cond_exit_176.dup2358, %cond_exit_176.dup2357, %cond_exit_176.dup2356, %cond_exit_176.dup2355, %cond_exit_176.dup
  %phi.edge2362 = phi i64 [ %"74_2.021922193", %cond_exit_176.dup ], [ %"74_2.021922193", %cond_exit_176.dup2355 ], [ %"74_2.021922195", %cond_exit_176.dup2356 ], [ %"74_2.021922195", %cond_exit_176.dup2357 ], [ %phi.calluser.edge2202, %cond_exit_176.dup2360 ], [ %phi.calluser.edge2204, %cond_exit_176.dup2361 ], [ %phi.calluser.edge2197, %cond_exit_176.dup2358 ], [ %phi.calluser.edge2201, %cond_exit_176.dup2359 ]
  %phi.edge2363 = phi i1 [ %7, %cond_exit_176.dup ], [ %39, %cond_exit_176.dup2355 ], [ %72, %cond_exit_176.dup2356 ], [ %104, %cond_exit_176.dup2357 ], [ %200, %cond_exit_176.dup2360 ], [ %232, %cond_exit_176.dup2361 ], [ %136, %cond_exit_176.dup2358 ], [ %168, %cond_exit_176.dup2359 ]
  %phi.edge2364 = phi i1 [ %6, %cond_exit_176.dup ], [ %38, %cond_exit_176.dup2355 ], [ %71, %cond_exit_176.dup2356 ], [ %103, %cond_exit_176.dup2357 ], [ %199, %cond_exit_176.dup2360 ], [ %231, %cond_exit_176.dup2361 ], [ %135, %cond_exit_176.dup2358 ], [ %167, %cond_exit_176.dup2359 ]
  %phi.edge2365 = phi i1 [ %5, %cond_exit_176.dup ], [ %37, %cond_exit_176.dup2355 ], [ %70, %cond_exit_176.dup2356 ], [ %102, %cond_exit_176.dup2357 ], [ %198, %cond_exit_176.dup2360 ], [ %230, %cond_exit_176.dup2361 ], [ %134, %cond_exit_176.dup2358 ], [ %166, %cond_exit_176.dup2359 ]
  %phi.edge2366 = phi i1 [ %4, %cond_exit_176.dup ], [ %36, %cond_exit_176.dup2355 ], [ %69, %cond_exit_176.dup2356 ], [ %101, %cond_exit_176.dup2357 ], [ %197, %cond_exit_176.dup2360 ], [ %229, %cond_exit_176.dup2361 ], [ %133, %cond_exit_176.dup2358 ], [ %165, %cond_exit_176.dup2359 ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 1 to ptr))
  br label %cond_374_case_1.dup2235

cond_374_case_1.dup2235:                          ; preds = %bb
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %261 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %262 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %263 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %264 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  %"1370_0.02236" = select i1 %261, i64 8, i64 0
  %"1408_0.02237" = select i1 %262, i64 4, i64 0
  %"1446_0.02238" = select i1 %263, i64 2, i64 0
  %"1484_0.02239" = zext i1 %264 to i64
  %265 = or i64 %"1408_0.02237", %"1370_0.02236"
  %266 = or i64 %265, %"1446_0.02238"
  %267 = or i64 %266, %"1484_0.02239"
  %"1282_0.02240" = zext i1 %263 to i64
  %268 = add i64 %phi.edge2362, %"1282_0.02240"
  %Pivot20892241 = icmp slt i64 %268, 1
  br i1 %Pivot20892241, label %.sink.split.dup2269, label %NodeBlock.dup2278

NodeBlock.dup2278:                                ; preds = %cond_374_case_1.dup2235
  %Pivot2279 = icmp slt i64 %268, 2
  br i1 %Pivot2279, label %.sink.split.dup2312, label %LeafBlock.dup2296

.sink.split.dup2312:                              ; preds = %NodeBlock.dup2278
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  br label %bb.dup2322

bb.dup2322:                                       ; preds = %.sink.split.dup2312
  %269 = call double @llvm.fabs.f64(double 2.000000e-01)
  %270 = fcmp ueq double %269, 0x7FF0000000000000
  br i1 %270, label %bb0, label %cond_949_case_1.dup2697

cond_949_case_1.dup2697:                          ; preds = %bb.dup2322
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %271 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %272 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FE41B2F769CF0E0, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %273 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

LeafBlock.dup2296:                                ; preds = %NodeBlock.dup2278
  %SwitchLeaf2297 = icmp eq i64 %268, 2
  br i1 %SwitchLeaf2297, label %.sink.split.dup2640, label %bb.dup2323

.sink.split.dup2640:                              ; preds = %LeafBlock.dup2296
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2659

bb.dup2659:                                       ; preds = %.sink.split.dup2640
  %274 = call double @llvm.fabs.f64(double 2.000000e-01)
  %275 = fcmp ueq double %274, 0x7FF0000000000000
  br i1 %275, label %bb0, label %cond_949_case_1.dup2698

cond_949_case_1.dup2698:                          ; preds = %bb.dup2659
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %276 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %277 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FE41B2F769CF0E0, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %278 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb.dup2323:                                       ; preds = %LeafBlock.dup2296
  %279 = call double @llvm.fabs.f64(double 2.000000e-01)
  %280 = fcmp ueq double %279, 0x7FF0000000000000
  br i1 %280, label %bb0, label %cond_949_case_1.dup2699

cond_949_case_1.dup2699:                          ; preds = %bb.dup2323
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %281 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %282 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FE41B2F769CF0E0, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %283 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

.sink.split.dup2269:                              ; preds = %cond_374_case_1.dup2235
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %bb.dup2324

bb.dup2324:                                       ; preds = %.sink.split.dup2269
  %284 = call double @llvm.fabs.f64(double 2.000000e-01)
  %285 = fcmp ueq double %284, 0x7FF0000000000000
  br i1 %285, label %bb0, label %cond_949_case_1.dup2700

cond_949_case_1.dup2700:                          ; preds = %bb.dup2324
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %286 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %287 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FE41B2F769CF0E0, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %288 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

bb0:                                              ; preds = %bb.dup2324, %bb.dup2323, %bb.dup2659, %bb.dup2322, %bb.dup2553, %bb.dup2596, %bb.dup2658, %bb.dup2624, %bb.dup2552, %bb.dup2595, %bb.dup2657, %bb.dup2623, %bb.dup2551, %bb.dup2594, %bb.dup2656, %bb.dup2622, %bb.dup2550, %bb.dup2593, %bb.dup2655, %bb.dup2621, %bb.dup2549, %bb.dup2592, %bb.dup2654, %bb.dup2620, %bb.dup2548, %bb.dup2591, %bb.dup2653, %bb.dup2619, %bb.dup2547, %bb.dup2590, %bb.dup2652, %bb.dup2618, %bb.dup2546, %bb.dup, %bb.dup2651, %bb.dup2617
  tail call void @abort()
  unreachable

__prepare_module_record_output_final:             ; preds = %cond_949_case_1.dup2700, %cond_949_case_1.dup2699, %cond_949_case_1.dup2698, %cond_949_case_1.dup2697, %cond_949_case_1.dup2696, %cond_949_case_1.dup2695, %cond_949_case_1.dup2694, %cond_949_case_1.dup2693, %cond_949_case_1.dup2692, %cond_949_case_1.dup2691, %cond_949_case_1.dup2690, %cond_949_case_1.dup2689, %cond_949_case_1.dup2688, %cond_949_case_1.dup2687, %cond_949_case_1.dup2686, %cond_949_case_1.dup2685, %cond_949_case_1.dup2684, %cond_949_case_1.dup2683, %cond_949_case_1.dup2682, %cond_949_case_1.dup2681, %cond_949_case_1.dup2680, %cond_949_case_1.dup2679, %cond_949_case_1.dup2678, %cond_949_case_1.dup2677, %cond_949_case_1.dup2676, %cond_949_case_1.dup2675, %cond_949_case_1.dup2674, %cond_949_case_1.dup2673, %cond_949_case_1.dup2672, %cond_949_case_1.dup2671, %cond_949_case_1.dup2670, %cond_949_case_1.dup2669, %cond_949_case_1.dup2668, %cond_949_case_1.dup2667, %cond_949_case_1.dup2666, %cond_949_case_1.dup
  %phi.calluser.edge2708 = phi i1 [ %20, %cond_949_case_1.dup ], [ %25, %cond_949_case_1.dup2666 ], [ %30, %cond_949_case_1.dup2667 ], [ %35, %cond_949_case_1.dup2668 ], [ %52, %cond_949_case_1.dup2669 ], [ %57, %cond_949_case_1.dup2670 ], [ %62, %cond_949_case_1.dup2671 ], [ %67, %cond_949_case_1.dup2672 ], [ %85, %cond_949_case_1.dup2673 ], [ %90, %cond_949_case_1.dup2674 ], [ %95, %cond_949_case_1.dup2675 ], [ %100, %cond_949_case_1.dup2676 ], [ %117, %cond_949_case_1.dup2677 ], [ %122, %cond_949_case_1.dup2678 ], [ %127, %cond_949_case_1.dup2679 ], [ %132, %cond_949_case_1.dup2680 ], [ %149, %cond_949_case_1.dup2681 ], [ %154, %cond_949_case_1.dup2682 ], [ %159, %cond_949_case_1.dup2683 ], [ %164, %cond_949_case_1.dup2684 ], [ %181, %cond_949_case_1.dup2685 ], [ %186, %cond_949_case_1.dup2686 ], [ %191, %cond_949_case_1.dup2687 ], [ %196, %cond_949_case_1.dup2688 ], [ %213, %cond_949_case_1.dup2689 ], [ %218, %cond_949_case_1.dup2690 ], [ %223, %cond_949_case_1.dup2691 ], [ %228, %cond_949_case_1.dup2692 ], [ %245, %cond_949_case_1.dup2693 ], [ %250, %cond_949_case_1.dup2694 ], [ %255, %cond_949_case_1.dup2695 ], [ %260, %cond_949_case_1.dup2696 ], [ %273, %cond_949_case_1.dup2697 ], [ %278, %cond_949_case_1.dup2698 ], [ %283, %cond_949_case_1.dup2699 ], [ %288, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2707 = phi i1 [ %19, %cond_949_case_1.dup ], [ %24, %cond_949_case_1.dup2666 ], [ %29, %cond_949_case_1.dup2667 ], [ %34, %cond_949_case_1.dup2668 ], [ %51, %cond_949_case_1.dup2669 ], [ %56, %cond_949_case_1.dup2670 ], [ %61, %cond_949_case_1.dup2671 ], [ %66, %cond_949_case_1.dup2672 ], [ %84, %cond_949_case_1.dup2673 ], [ %89, %cond_949_case_1.dup2674 ], [ %94, %cond_949_case_1.dup2675 ], [ %99, %cond_949_case_1.dup2676 ], [ %116, %cond_949_case_1.dup2677 ], [ %121, %cond_949_case_1.dup2678 ], [ %126, %cond_949_case_1.dup2679 ], [ %131, %cond_949_case_1.dup2680 ], [ %148, %cond_949_case_1.dup2681 ], [ %153, %cond_949_case_1.dup2682 ], [ %158, %cond_949_case_1.dup2683 ], [ %163, %cond_949_case_1.dup2684 ], [ %180, %cond_949_case_1.dup2685 ], [ %185, %cond_949_case_1.dup2686 ], [ %190, %cond_949_case_1.dup2687 ], [ %195, %cond_949_case_1.dup2688 ], [ %212, %cond_949_case_1.dup2689 ], [ %217, %cond_949_case_1.dup2690 ], [ %222, %cond_949_case_1.dup2691 ], [ %227, %cond_949_case_1.dup2692 ], [ %244, %cond_949_case_1.dup2693 ], [ %249, %cond_949_case_1.dup2694 ], [ %254, %cond_949_case_1.dup2695 ], [ %259, %cond_949_case_1.dup2696 ], [ %272, %cond_949_case_1.dup2697 ], [ %277, %cond_949_case_1.dup2698 ], [ %282, %cond_949_case_1.dup2699 ], [ %287, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2706 = phi i1 [ %18, %cond_949_case_1.dup ], [ %23, %cond_949_case_1.dup2666 ], [ %28, %cond_949_case_1.dup2667 ], [ %33, %cond_949_case_1.dup2668 ], [ %50, %cond_949_case_1.dup2669 ], [ %55, %cond_949_case_1.dup2670 ], [ %60, %cond_949_case_1.dup2671 ], [ %65, %cond_949_case_1.dup2672 ], [ %83, %cond_949_case_1.dup2673 ], [ %88, %cond_949_case_1.dup2674 ], [ %93, %cond_949_case_1.dup2675 ], [ %98, %cond_949_case_1.dup2676 ], [ %115, %cond_949_case_1.dup2677 ], [ %120, %cond_949_case_1.dup2678 ], [ %125, %cond_949_case_1.dup2679 ], [ %130, %cond_949_case_1.dup2680 ], [ %147, %cond_949_case_1.dup2681 ], [ %152, %cond_949_case_1.dup2682 ], [ %157, %cond_949_case_1.dup2683 ], [ %162, %cond_949_case_1.dup2684 ], [ %179, %cond_949_case_1.dup2685 ], [ %184, %cond_949_case_1.dup2686 ], [ %189, %cond_949_case_1.dup2687 ], [ %194, %cond_949_case_1.dup2688 ], [ %211, %cond_949_case_1.dup2689 ], [ %216, %cond_949_case_1.dup2690 ], [ %221, %cond_949_case_1.dup2691 ], [ %226, %cond_949_case_1.dup2692 ], [ %243, %cond_949_case_1.dup2693 ], [ %248, %cond_949_case_1.dup2694 ], [ %253, %cond_949_case_1.dup2695 ], [ %258, %cond_949_case_1.dup2696 ], [ %271, %cond_949_case_1.dup2697 ], [ %276, %cond_949_case_1.dup2698 ], [ %281, %cond_949_case_1.dup2699 ], [ %286, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2705 = phi i1 [ %4, %cond_949_case_1.dup ], [ %4, %cond_949_case_1.dup2666 ], [ %4, %cond_949_case_1.dup2667 ], [ %4, %cond_949_case_1.dup2668 ], [ %36, %cond_949_case_1.dup2669 ], [ %36, %cond_949_case_1.dup2670 ], [ %36, %cond_949_case_1.dup2671 ], [ %36, %cond_949_case_1.dup2672 ], [ %69, %cond_949_case_1.dup2673 ], [ %69, %cond_949_case_1.dup2674 ], [ %69, %cond_949_case_1.dup2675 ], [ %69, %cond_949_case_1.dup2676 ], [ %101, %cond_949_case_1.dup2677 ], [ %101, %cond_949_case_1.dup2678 ], [ %101, %cond_949_case_1.dup2679 ], [ %101, %cond_949_case_1.dup2680 ], [ %133, %cond_949_case_1.dup2681 ], [ %133, %cond_949_case_1.dup2682 ], [ %133, %cond_949_case_1.dup2683 ], [ %133, %cond_949_case_1.dup2684 ], [ %165, %cond_949_case_1.dup2685 ], [ %165, %cond_949_case_1.dup2686 ], [ %165, %cond_949_case_1.dup2687 ], [ %165, %cond_949_case_1.dup2688 ], [ %197, %cond_949_case_1.dup2689 ], [ %197, %cond_949_case_1.dup2690 ], [ %197, %cond_949_case_1.dup2691 ], [ %197, %cond_949_case_1.dup2692 ], [ %229, %cond_949_case_1.dup2693 ], [ %229, %cond_949_case_1.dup2694 ], [ %229, %cond_949_case_1.dup2695 ], [ %229, %cond_949_case_1.dup2696 ], [ %phi.edge2366, %cond_949_case_1.dup2697 ], [ %phi.edge2366, %cond_949_case_1.dup2698 ], [ %phi.edge2366, %cond_949_case_1.dup2699 ], [ %phi.edge2366, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2704 = phi i1 [ %5, %cond_949_case_1.dup ], [ %5, %cond_949_case_1.dup2666 ], [ %5, %cond_949_case_1.dup2667 ], [ %5, %cond_949_case_1.dup2668 ], [ %37, %cond_949_case_1.dup2669 ], [ %37, %cond_949_case_1.dup2670 ], [ %37, %cond_949_case_1.dup2671 ], [ %37, %cond_949_case_1.dup2672 ], [ %70, %cond_949_case_1.dup2673 ], [ %70, %cond_949_case_1.dup2674 ], [ %70, %cond_949_case_1.dup2675 ], [ %70, %cond_949_case_1.dup2676 ], [ %102, %cond_949_case_1.dup2677 ], [ %102, %cond_949_case_1.dup2678 ], [ %102, %cond_949_case_1.dup2679 ], [ %102, %cond_949_case_1.dup2680 ], [ %134, %cond_949_case_1.dup2681 ], [ %134, %cond_949_case_1.dup2682 ], [ %134, %cond_949_case_1.dup2683 ], [ %134, %cond_949_case_1.dup2684 ], [ %166, %cond_949_case_1.dup2685 ], [ %166, %cond_949_case_1.dup2686 ], [ %166, %cond_949_case_1.dup2687 ], [ %166, %cond_949_case_1.dup2688 ], [ %198, %cond_949_case_1.dup2689 ], [ %198, %cond_949_case_1.dup2690 ], [ %198, %cond_949_case_1.dup2691 ], [ %198, %cond_949_case_1.dup2692 ], [ %230, %cond_949_case_1.dup2693 ], [ %230, %cond_949_case_1.dup2694 ], [ %230, %cond_949_case_1.dup2695 ], [ %230, %cond_949_case_1.dup2696 ], [ %phi.edge2365, %cond_949_case_1.dup2697 ], [ %phi.edge2365, %cond_949_case_1.dup2698 ], [ %phi.edge2365, %cond_949_case_1.dup2699 ], [ %phi.edge2365, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge2703 = phi i1 [ %6, %cond_949_case_1.dup ], [ %6, %cond_949_case_1.dup2666 ], [ %6, %cond_949_case_1.dup2667 ], [ %6, %cond_949_case_1.dup2668 ], [ %38, %cond_949_case_1.dup2669 ], [ %38, %cond_949_case_1.dup2670 ], [ %38, %cond_949_case_1.dup2671 ], [ %38, %cond_949_case_1.dup2672 ], [ %71, %cond_949_case_1.dup2673 ], [ %71, %cond_949_case_1.dup2674 ], [ %71, %cond_949_case_1.dup2675 ], [ %71, %cond_949_case_1.dup2676 ], [ %103, %cond_949_case_1.dup2677 ], [ %103, %cond_949_case_1.dup2678 ], [ %103, %cond_949_case_1.dup2679 ], [ %103, %cond_949_case_1.dup2680 ], [ %135, %cond_949_case_1.dup2681 ], [ %135, %cond_949_case_1.dup2682 ], [ %135, %cond_949_case_1.dup2683 ], [ %135, %cond_949_case_1.dup2684 ], [ %167, %cond_949_case_1.dup2685 ], [ %167, %cond_949_case_1.dup2686 ], [ %167, %cond_949_case_1.dup2687 ], [ %167, %cond_949_case_1.dup2688 ], [ %199, %cond_949_case_1.dup2689 ], [ %199, %cond_949_case_1.dup2690 ], [ %199, %cond_949_case_1.dup2691 ], [ %199, %cond_949_case_1.dup2692 ], [ %231, %cond_949_case_1.dup2693 ], [ %231, %cond_949_case_1.dup2694 ], [ %231, %cond_949_case_1.dup2695 ], [ %231, %cond_949_case_1.dup2696 ], [ %phi.edge2364, %cond_949_case_1.dup2697 ], [ %phi.edge2364, %cond_949_case_1.dup2698 ], [ %phi.edge2364, %cond_949_case_1.dup2699 ], [ %phi.edge2364, %cond_949_case_1.dup2700 ]
  %phi.calluser.edge = phi i1 [ %7, %cond_949_case_1.dup ], [ %7, %cond_949_case_1.dup2666 ], [ %7, %cond_949_case_1.dup2667 ], [ %7, %cond_949_case_1.dup2668 ], [ %39, %cond_949_case_1.dup2669 ], [ %39, %cond_949_case_1.dup2670 ], [ %39, %cond_949_case_1.dup2671 ], [ %39, %cond_949_case_1.dup2672 ], [ %72, %cond_949_case_1.dup2673 ], [ %72, %cond_949_case_1.dup2674 ], [ %72, %cond_949_case_1.dup2675 ], [ %72, %cond_949_case_1.dup2676 ], [ %104, %cond_949_case_1.dup2677 ], [ %104, %cond_949_case_1.dup2678 ], [ %104, %cond_949_case_1.dup2679 ], [ %104, %cond_949_case_1.dup2680 ], [ %136, %cond_949_case_1.dup2681 ], [ %136, %cond_949_case_1.dup2682 ], [ %136, %cond_949_case_1.dup2683 ], [ %136, %cond_949_case_1.dup2684 ], [ %168, %cond_949_case_1.dup2685 ], [ %168, %cond_949_case_1.dup2686 ], [ %168, %cond_949_case_1.dup2687 ], [ %168, %cond_949_case_1.dup2688 ], [ %200, %cond_949_case_1.dup2689 ], [ %200, %cond_949_case_1.dup2690 ], [ %200, %cond_949_case_1.dup2691 ], [ %200, %cond_949_case_1.dup2692 ], [ %232, %cond_949_case_1.dup2693 ], [ %232, %cond_949_case_1.dup2694 ], [ %232, %cond_949_case_1.dup2695 ], [ %232, %cond_949_case_1.dup2696 ], [ %phi.edge2363, %cond_949_case_1.dup2697 ], [ %phi.edge2363, %cond_949_case_1.dup2698 ], [ %phi.edge2363, %cond_949_case_1.dup2699 ], [ %phi.edge2363, %cond_949_case_1.dup2700 ]
  %phi.edge2701 = phi i64 [ %14, %cond_949_case_1.dup2667 ], [ %267, %cond_949_case_1.dup2697 ], [ %267, %cond_949_case_1.dup2699 ], [ %267, %cond_949_case_1.dup2700 ], [ %14, %cond_949_case_1.dup2668 ], [ %46, %cond_949_case_1.dup2672 ], [ %79, %cond_949_case_1.dup2676 ], [ %111, %cond_949_case_1.dup2680 ], [ %143, %cond_949_case_1.dup2684 ], [ %175, %cond_949_case_1.dup2688 ], [ %207, %cond_949_case_1.dup2692 ], [ %239, %cond_949_case_1.dup2696 ], [ %46, %cond_949_case_1.dup2671 ], [ %79, %cond_949_case_1.dup2675 ], [ %111, %cond_949_case_1.dup2679 ], [ %143, %cond_949_case_1.dup2683 ], [ %175, %cond_949_case_1.dup2687 ], [ %207, %cond_949_case_1.dup2691 ], [ %239, %cond_949_case_1.dup2695 ], [ %14, %cond_949_case_1.dup ], [ %46, %cond_949_case_1.dup2669 ], [ %79, %cond_949_case_1.dup2673 ], [ %111, %cond_949_case_1.dup2677 ], [ %143, %cond_949_case_1.dup2681 ], [ %175, %cond_949_case_1.dup2685 ], [ %207, %cond_949_case_1.dup2689 ], [ %239, %cond_949_case_1.dup2693 ], [ %14, %cond_949_case_1.dup2666 ], [ %46, %cond_949_case_1.dup2670 ], [ %79, %cond_949_case_1.dup2674 ], [ %111, %cond_949_case_1.dup2678 ], [ %143, %cond_949_case_1.dup2682 ], [ %175, %cond_949_case_1.dup2686 ], [ %207, %cond_949_case_1.dup2690 ], [ %239, %cond_949_case_1.dup2694 ], [ %267, %cond_949_case_1.dup2698 ]
  %phi.edge2702 = phi i64 [ %"74_2.021922193", %cond_949_case_1.dup2667 ], [ %phi.edge2362, %cond_949_case_1.dup2697 ], [ %phi.edge2362, %cond_949_case_1.dup2699 ], [ %phi.edge2362, %cond_949_case_1.dup2700 ], [ %"74_2.021922193", %cond_949_case_1.dup2668 ], [ %"74_2.021922193", %cond_949_case_1.dup2672 ], [ %"74_2.021922195", %cond_949_case_1.dup2676 ], [ %"74_2.021922195", %cond_949_case_1.dup2680 ], [ %phi.calluser.edge2197, %cond_949_case_1.dup2684 ], [ %phi.calluser.edge2201, %cond_949_case_1.dup2688 ], [ %phi.calluser.edge2202, %cond_949_case_1.dup2692 ], [ %phi.calluser.edge2204, %cond_949_case_1.dup2696 ], [ %"74_2.021922193", %cond_949_case_1.dup2671 ], [ %"74_2.021922195", %cond_949_case_1.dup2675 ], [ %"74_2.021922195", %cond_949_case_1.dup2679 ], [ %phi.calluser.edge2197, %cond_949_case_1.dup2683 ], [ %phi.calluser.edge2201, %cond_949_case_1.dup2687 ], [ %phi.calluser.edge2202, %cond_949_case_1.dup2691 ], [ %phi.calluser.edge2204, %cond_949_case_1.dup2695 ], [ %"74_2.021922193", %cond_949_case_1.dup ], [ %"74_2.021922193", %cond_949_case_1.dup2669 ], [ %"74_2.021922195", %cond_949_case_1.dup2673 ], [ %"74_2.021922195", %cond_949_case_1.dup2677 ], [ %phi.calluser.edge2197, %cond_949_case_1.dup2681 ], [ %phi.calluser.edge2201, %cond_949_case_1.dup2685 ], [ %phi.calluser.edge2202, %cond_949_case_1.dup2689 ], [ %phi.calluser.edge2204, %cond_949_case_1.dup2693 ], [ %"74_2.021922193", %cond_949_case_1.dup2666 ], [ %"74_2.021922193", %cond_949_case_1.dup2670 ], [ %"74_2.021922195", %cond_949_case_1.dup2674 ], [ %"74_2.021922195", %cond_949_case_1.dup2678 ], [ %phi.calluser.edge2197, %cond_949_case_1.dup2682 ], [ %phi.calluser.edge2201, %cond_949_case_1.dup2686 ], [ %phi.calluser.edge2202, %cond_949_case_1.dup2690 ], [ %phi.calluser.edge2204, %cond_949_case_1.dup2694 ], [ %phi.edge2362, %cond_949_case_1.dup2698 ]
  call void @__quantum__rt__bool_record_output(i1 %0, ptr @0)
  call void @__quantum__rt__bool_record_output(i1 %1, ptr @1)
  call void @__quantum__rt__int_record_output(i64 %phi.edge2701, ptr @7)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2705, ptr @2)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2704, ptr @3)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2703, ptr @4)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge, ptr @5)
  call void @__quantum__rt__int_record_output(i64 %phi.edge2702, ptr @6)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2706, ptr @8)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2707, ptr @9)
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2708, ptr @10)
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
