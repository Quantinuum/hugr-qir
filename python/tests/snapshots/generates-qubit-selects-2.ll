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

define void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 4 to ptr), ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 5 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 5 to ptr), ptr nonnull inttoptr (i64 1 to ptr))
  %1 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 1 to ptr))
  %"46_2.0" = zext i1 %0 to i64
  %2 = select i1 %0, i64 2, i64 1
  %"61_2.0" = select i1 %1, i64 %2, i64 %"46_2.0"
  %3 = select i1 %0, i1 %1, i1 false
  br i1 %0, label %alloca_block.route1828, label %alloca_block.route1825

cond_336_case_1:                                  ; preds = %cond_exit_796, %bb0
  %val.available1835 = phi i1 [ %val.available1836, %cond_exit_796 ], [ %val.available1838, %bb0 ]
  %val.available1847 = phi i1 [ %val.available1848, %cond_exit_796 ], [ %val.available1850, %bb0 ]
  %val.available1859 = phi i1 [ %val.available1860, %cond_exit_796 ], [ %val.available1862, %bb0 ]
  %val.available1871 = phi i1 [ %val.available1872, %cond_exit_796 ], [ %val.available1874, %bb0 ]
  tail call void @__quantum__qis__mz__body(ptr null, ptr nonnull inttoptr (i64 6 to ptr))
  %4 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 7 to ptr))
  %5 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 8 to ptr))
  %6 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  %7 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 9 to ptr))
  %"1259_0.0" = select i1 %4, i64 8, i64 0
  %"1297_0.0" = select i1 %5, i64 4, i64 0
  %"1335_0.0" = select i1 %6, i64 2, i64 0
  %"1373_0.0" = zext i1 %7 to i64
  %8 = or disjoint i64 %"1297_0.0", %"1259_0.0"
  %9 = or disjoint i64 %8, %"1335_0.0"
  %10 = or disjoint i64 %9, %"1373_0.0"
  %"1193_0.0" = zext i1 %6 to i64
  %11 = add nuw nsw i64 %"61_2.0", %"1193_0.0"
  %Pivot1824 = icmp slt i64 %11, 1
  br i1 %Pivot1824, label %cond_880_case_1.sink.split.dup.p0.0, label %NodeBlock

NodeBlock:                                        ; preds = %cond_336_case_1
  %val.available1833 = phi i1 [ %val.available1835, %cond_336_case_1 ]
  %val.available1845 = phi i1 [ %val.available1847, %cond_336_case_1 ]
  %val.available1857 = phi i1 [ %val.available1859, %cond_336_case_1 ]
  %val.available1869 = phi i1 [ %val.available1871, %cond_336_case_1 ]
  %Pivot = icmp slt i64 %11, 2
  br i1 %Pivot, label %cond_880_case_1.sink.split.dup.p1.0, label %LeafBlock

LeafBlock:                                        ; preds = %NodeBlock
  %val.available1832 = phi i1 [ %val.available1833, %NodeBlock ]
  %val.available1844 = phi i1 [ %val.available1845, %NodeBlock ]
  %val.available1856 = phi i1 [ %val.available1857, %NodeBlock ]
  %val.available1868 = phi i1 [ %val.available1869, %NodeBlock ]
  %SwitchLeaf = icmp eq i64 %11, 2
  br i1 %SwitchLeaf, label %cond_880_case_1.sink.split.dup.p2.0, label %cond_880_case_1

cond_880_case_1:                                  ; preds = %cond_880_case_1.sink.split.dup.p2.0, %cond_880_case_1.sink.split.dup.p1.0, %cond_880_case_1.sink.split.dup.p0.0, %LeafBlock
  %phi.fix = phi i1 [ %val.available1832, %LeafBlock ], [ %val.available1835, %cond_880_case_1.sink.split.dup.p0.0 ], [ %val.available1840, %cond_880_case_1.sink.split.dup.p1.0 ], [ %val.available1841, %cond_880_case_1.sink.split.dup.p2.0 ]
  %phi.fix1878 = phi i1 [ %val.available1844, %LeafBlock ], [ %val.available1847, %cond_880_case_1.sink.split.dup.p0.0 ], [ %val.available1852, %cond_880_case_1.sink.split.dup.p1.0 ], [ %val.available1853, %cond_880_case_1.sink.split.dup.p2.0 ]
  %phi.fix1879 = phi i1 [ %val.available1856, %LeafBlock ], [ %val.available1859, %cond_880_case_1.sink.split.dup.p0.0 ], [ %val.available1864, %cond_880_case_1.sink.split.dup.p1.0 ], [ %val.available1865, %cond_880_case_1.sink.split.dup.p2.0 ]
  %phi.fix1880 = phi i1 [ %val.available1868, %LeafBlock ], [ %val.available1871, %cond_880_case_1.sink.split.dup.p0.0 ], [ %val.available1876, %cond_880_case_1.sink.split.dup.p1.0 ], [ %val.available1877, %cond_880_case_1.sink.split.dup.p2.0 ]
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 10 to ptr))
  %12 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  %13 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 11 to ptr))
  br label %__prepare_module_record_output_final

bb:                                               ; preds = %alloca_block.route1827, %alloca_block.dup.7, %alloca_block.dup.6, %alloca_block.dup.4, %alloca_block.dup.0
  %val.available1837 = phi i1 [ %26, %alloca_block.dup.7 ], [ %22, %alloca_block.dup.6 ], [ %18, %alloca_block.dup.4 ], [ %14, %alloca_block.dup.0 ], [ %30, %alloca_block.route1827 ]
  %val.available1849 = phi i1 [ %27, %alloca_block.dup.7 ], [ %23, %alloca_block.dup.6 ], [ %19, %alloca_block.dup.4 ], [ %15, %alloca_block.dup.0 ], [ %31, %alloca_block.route1827 ]
  %val.available1861 = phi i1 [ %28, %alloca_block.dup.7 ], [ %24, %alloca_block.dup.6 ], [ %20, %alloca_block.dup.4 ], [ %16, %alloca_block.dup.0 ], [ %32, %alloca_block.route1827 ]
  %val.available1873 = phi i1 [ %29, %alloca_block.dup.7 ], [ %25, %alloca_block.dup.6 ], [ %21, %alloca_block.dup.4 ], [ %17, %alloca_block.dup.0 ], [ %33, %alloca_block.route1827 ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  br label %cond_exit_796

cond_exit_796:                                    ; preds = %alloca_block.route1827, %alloca_block.dup.7, %alloca_block.dup.6, %alloca_block.dup.4, %alloca_block.dup.0, %bb
  %val.available1836 = phi i1 [ %26, %alloca_block.dup.7 ], [ %22, %alloca_block.dup.6 ], [ %18, %alloca_block.dup.4 ], [ %14, %alloca_block.dup.0 ], [ %val.available1837, %bb ], [ %30, %alloca_block.route1827 ]
  %val.available1848 = phi i1 [ %27, %alloca_block.dup.7 ], [ %23, %alloca_block.dup.6 ], [ %19, %alloca_block.dup.4 ], [ %15, %alloca_block.dup.0 ], [ %val.available1849, %bb ], [ %31, %alloca_block.route1827 ]
  %val.available1860 = phi i1 [ %28, %alloca_block.dup.7 ], [ %24, %alloca_block.dup.6 ], [ %20, %alloca_block.dup.4 ], [ %16, %alloca_block.dup.0 ], [ %val.available1861, %bb ], [ %32, %alloca_block.route1827 ]
  %val.available1872 = phi i1 [ %29, %alloca_block.dup.7 ], [ %25, %alloca_block.dup.6 ], [ %21, %alloca_block.dup.4 ], [ %17, %alloca_block.dup.0 ], [ %val.available1873, %bb ], [ %33, %alloca_block.route1827 ]
  br i1 %1, label %bb0, label %cond_336_case_1

bb0:                                              ; preds = %cond_exit_796
  %val.available1838 = phi i1 [ %val.available1836, %cond_exit_796 ]
  %val.available1850 = phi i1 [ %val.available1848, %cond_exit_796 ]
  %val.available1862 = phi i1 [ %val.available1860, %cond_exit_796 ]
  %val.available1874 = phi i1 [ %val.available1872, %cond_exit_796 ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 1 to ptr))
  br label %cond_336_case_1

cond_880_case_1.sink.split.dup.p2.0:              ; preds = %LeafBlock
  %val.available1841 = phi i1 [ %val.available1832, %LeafBlock ]
  %val.available1853 = phi i1 [ %val.available1844, %LeafBlock ]
  %val.available1865 = phi i1 [ %val.available1856, %LeafBlock ]
  %val.available1877 = phi i1 [ %val.available1868, %LeafBlock ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %cond_880_case_1

alloca_block.dup.0:                               ; preds = %alloca_block.route1825
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %14 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %15 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %16 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %17 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br i1 %0, label %bb, label %cond_exit_796

alloca_block.dup.4:                               ; preds = %alloca_block.route1828
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %18 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %19 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %20 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %21 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br i1 %0, label %bb, label %cond_exit_796

alloca_block.dup.6:                               ; preds = %alloca_block.route1830
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %22 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %23 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %24 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %25 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br i1 %0, label %bb, label %cond_exit_796

alloca_block.dup.7:                               ; preds = %alloca_block.route1830
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %26 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %27 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %28 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %29 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br i1 %0, label %bb, label %cond_exit_796

alloca_block.route1825:                           ; preds = %alloca_block
  br i1 %1, label %alloca_block.route1827, label %alloca_block.dup.0

alloca_block.route1827:                           ; preds = %alloca_block.route1825
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %30 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %31 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %32 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %33 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br i1 %0, label %bb, label %cond_exit_796

alloca_block.route1828:                           ; preds = %alloca_block
  br i1 %1, label %alloca_block.route1830, label %alloca_block.dup.4

alloca_block.route1830:                           ; preds = %alloca_block.route1828
  br i1 %3, label %alloca_block.dup.7, label %alloca_block.dup.6

cond_880_case_1.sink.split.dup.p0.0:              ; preds = %cond_336_case_1
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %cond_880_case_1

cond_880_case_1.sink.split.dup.p1.0:              ; preds = %NodeBlock
  %val.available1840 = phi i1 [ %val.available1833, %NodeBlock ]
  %val.available1852 = phi i1 [ %val.available1845, %NodeBlock ]
  %val.available1864 = phi i1 [ %val.available1857, %NodeBlock ]
  %val.available1876 = phi i1 [ %val.available1869, %NodeBlock ]
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  br label %cond_880_case_1

__prepare_module_record_output_final:             ; preds = %cond_880_case_1
  call void @__quantum__rt__bool_record_output(i1 %0, ptr @0)
  call void @__quantum__rt__bool_record_output(i1 %1, ptr @1)
  call void @__quantum__rt__bool_record_output(i1 %phi.fix, ptr @2)
  call void @__quantum__rt__bool_record_output(i1 %phi.fix1878, ptr @3)
  call void @__quantum__rt__bool_record_output(i1 %phi.fix1879, ptr @4)
  call void @__quantum__rt__bool_record_output(i1 %phi.fix1880, ptr @5)
  call void @__quantum__rt__int_record_output(i64 %"61_2.0", ptr @6)
  call void @__quantum__rt__int_record_output(i64 %10, ptr @7)
  call void @__quantum__rt__bool_record_output(i1 %12, ptr @8)
  call void @__quantum__rt__bool_record_output(i1 %13, ptr @9)
  ret void
}

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, ptr) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, ptr) local_unnamed_addr

declare void @__quantum__qis__reset__body(ptr) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="8" "required_num_results"="12" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
