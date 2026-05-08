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
  br i1 %3, label %alloca_block.dup1875, label %alloca_block.dup1876

alloca_block.dup1875:                             ; preds = %alloca_block
  br i1 %1, label %alloca_block.dup1880, label %alloca_block.dup1883

alloca_block.dup1883:                             ; preds = %alloca_block.dup1875
  br i1 %0, label %alloca_block.dup1886, label %alloca_block.dup

alloca_block.dup:                                 ; preds = %alloca_block.dup1883
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %4 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %5 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %6 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %7 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %cond_exit_796

alloca_block.dup1886:                             ; preds = %alloca_block.dup1883
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %8 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %9 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %10 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %11 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %bb

alloca_block.dup1880:                             ; preds = %alloca_block.dup1875
  br i1 %0, label %alloca_block.dup1887, label %alloca_block.dup1898

alloca_block.dup1898:                             ; preds = %alloca_block.dup1880
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %12 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %13 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %14 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %15 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %cond_exit_796

alloca_block.dup1887:                             ; preds = %alloca_block.dup1880
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %16 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %17 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %18 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %19 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %bb

alloca_block.dup1876:                             ; preds = %alloca_block
  br i1 %1, label %alloca_block.dup1881, label %alloca_block.dup1884

alloca_block.dup1884:                             ; preds = %alloca_block.dup1876
  br i1 %0, label %alloca_block.dup1888, label %alloca_block.dup1899

alloca_block.dup1899:                             ; preds = %alloca_block.dup1884
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %20 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %21 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %22 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %23 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %cond_exit_796

alloca_block.dup1888:                             ; preds = %alloca_block.dup1884
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %24 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %25 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %26 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %27 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %bb

alloca_block.dup1881:                             ; preds = %alloca_block.dup1876
  br i1 %0, label %alloca_block.dup1889, label %alloca_block.dup1900

alloca_block.dup1900:                             ; preds = %alloca_block.dup1881
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %28 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %29 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %30 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %31 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %cond_exit_796

alloca_block.dup1889:                             ; preds = %alloca_block.dup1881
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %32 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %33 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %34 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %35 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  br label %bb

cond_336_case_1:                                  ; preds = %cond_exit_796, %bb0
  %phi.calluser.edge1866 = phi i1 [ %phi.edge, %cond_exit_796 ], [ %phi.calluser.edge1869, %bb0 ]
  %phi.calluser.edge1854 = phi i1 [ %phi.edge1901, %cond_exit_796 ], [ %phi.calluser.edge1857, %bb0 ]
  %phi.calluser.edge1842 = phi i1 [ %phi.edge1902, %cond_exit_796 ], [ %phi.calluser.edge1845, %bb0 ]
  %phi.calluser.edge1830 = phi i1 [ %phi.edge1903, %cond_exit_796 ], [ %phi.calluser.edge1833, %bb0 ]
  tail call void @__quantum__qis__mz__body(ptr null, ptr nonnull inttoptr (i64 6 to ptr))
  %36 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 6 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 1 to ptr), ptr nonnull inttoptr (i64 7 to ptr))
  %37 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 7 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 2 to ptr), ptr nonnull inttoptr (i64 8 to ptr))
  %38 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 8 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 3 to ptr), ptr nonnull inttoptr (i64 9 to ptr))
  %39 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 9 to ptr))
  %"1259_0.0" = select i1 %36, i64 8, i64 0
  %"1297_0.0" = select i1 %37, i64 4, i64 0
  %"1335_0.0" = select i1 %38, i64 2, i64 0
  %"1373_0.0" = zext i1 %39 to i64
  %40 = or disjoint i64 %"1297_0.0", %"1259_0.0"
  %41 = or disjoint i64 %40, %"1335_0.0"
  %42 = or disjoint i64 %41, %"1373_0.0"
  %"1193_0.0" = zext i1 %38 to i64
  %43 = add nuw nsw i64 %"61_2.0", %"1193_0.0"
  %Pivot1824 = icmp slt i64 %43, 1
  br i1 %Pivot1824, label %cond_880_case_1.sink.split.dup, label %NodeBlock

cond_880_case_1.sink.split.dup:                   ; preds = %cond_336_case_1
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %cond_880_case_1

NodeBlock:                                        ; preds = %cond_336_case_1
  %phi.calluser.edge1864 = phi i1 [ %phi.calluser.edge1866, %cond_336_case_1 ]
  %phi.calluser.edge1852 = phi i1 [ %phi.calluser.edge1854, %cond_336_case_1 ]
  %phi.calluser.edge1840 = phi i1 [ %phi.calluser.edge1842, %cond_336_case_1 ]
  %phi.calluser.edge1828 = phi i1 [ %phi.calluser.edge1830, %cond_336_case_1 ]
  %Pivot = icmp slt i64 %43, 2
  br i1 %Pivot, label %cond_880_case_1.sink.split.dup1908, label %LeafBlock

LeafBlock:                                        ; preds = %NodeBlock
  %phi.calluser.edge1863 = phi i1 [ %phi.calluser.edge1864, %NodeBlock ]
  %phi.calluser.edge1851 = phi i1 [ %phi.calluser.edge1852, %NodeBlock ]
  %phi.calluser.edge1839 = phi i1 [ %phi.calluser.edge1840, %NodeBlock ]
  %phi.calluser.edge1827 = phi i1 [ %phi.calluser.edge1828, %NodeBlock ]
  %SwitchLeaf = icmp eq i64 %43, 2
  br i1 %SwitchLeaf, label %cond_880_case_1.sink.split.dup1909, label %cond_880_case_1

cond_880_case_1.sink.split.dup1908:               ; preds = %NodeBlock
  %phi.calluser.edge1871 = phi i1 [ %phi.calluser.edge1864, %NodeBlock ]
  %phi.calluser.edge1859 = phi i1 [ %phi.calluser.edge1852, %NodeBlock ]
  %phi.calluser.edge1847 = phi i1 [ %phi.calluser.edge1840, %NodeBlock ]
  %phi.calluser.edge1835 = phi i1 [ %phi.calluser.edge1828, %NodeBlock ]
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  br label %cond_880_case_1

cond_880_case_1:                                  ; preds = %cond_880_case_1.sink.split.dup1909, %cond_880_case_1.sink.split.dup1908, %cond_880_case_1.sink.split.dup, %LeafBlock
  %phi.edge1910 = phi i1 [ %phi.calluser.edge1863, %LeafBlock ], [ %phi.calluser.edge1872, %cond_880_case_1.sink.split.dup1909 ], [ %phi.calluser.edge1866, %cond_880_case_1.sink.split.dup ], [ %phi.calluser.edge1871, %cond_880_case_1.sink.split.dup1908 ]
  %phi.edge1911 = phi i1 [ %phi.calluser.edge1851, %LeafBlock ], [ %phi.calluser.edge1860, %cond_880_case_1.sink.split.dup1909 ], [ %phi.calluser.edge1854, %cond_880_case_1.sink.split.dup ], [ %phi.calluser.edge1859, %cond_880_case_1.sink.split.dup1908 ]
  %phi.edge1912 = phi i1 [ %phi.calluser.edge1839, %LeafBlock ], [ %phi.calluser.edge1848, %cond_880_case_1.sink.split.dup1909 ], [ %phi.calluser.edge1842, %cond_880_case_1.sink.split.dup ], [ %phi.calluser.edge1847, %cond_880_case_1.sink.split.dup1908 ]
  %phi.edge1913 = phi i1 [ %phi.calluser.edge1827, %LeafBlock ], [ %phi.calluser.edge1836, %cond_880_case_1.sink.split.dup1909 ], [ %phi.calluser.edge1830, %cond_880_case_1.sink.split.dup ], [ %phi.calluser.edge1835, %cond_880_case_1.sink.split.dup1908 ]
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 6 to ptr), ptr nonnull inttoptr (i64 10 to ptr))
  %44 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 10 to ptr))
  tail call void @__quantum__qis__mz__body(ptr nonnull inttoptr (i64 7 to ptr), ptr nonnull inttoptr (i64 11 to ptr))
  %45 = tail call i1 @__quantum__rt__read_result(ptr nonnull inttoptr (i64 11 to ptr))
  br label %__prepare_module_record_output_final

bb:                                               ; preds = %alloca_block.dup1889, %alloca_block.dup1888, %alloca_block.dup1887, %alloca_block.dup1886
  %phi.edge1904 = phi i1 [ %19, %alloca_block.dup1887 ], [ %35, %alloca_block.dup1889 ], [ %11, %alloca_block.dup1886 ], [ %27, %alloca_block.dup1888 ]
  %phi.edge1905 = phi i1 [ %18, %alloca_block.dup1887 ], [ %34, %alloca_block.dup1889 ], [ %10, %alloca_block.dup1886 ], [ %26, %alloca_block.dup1888 ]
  %phi.edge1906 = phi i1 [ %17, %alloca_block.dup1887 ], [ %33, %alloca_block.dup1889 ], [ %9, %alloca_block.dup1886 ], [ %25, %alloca_block.dup1888 ]
  %phi.edge1907 = phi i1 [ %16, %alloca_block.dup1887 ], [ %32, %alloca_block.dup1889 ], [ %8, %alloca_block.dup1886 ], [ %24, %alloca_block.dup1888 ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  br label %cond_exit_796

cond_exit_796:                                    ; preds = %alloca_block.dup1900, %alloca_block.dup1899, %alloca_block.dup1898, %alloca_block.dup, %bb
  %phi.edge = phi i1 [ %15, %alloca_block.dup1898 ], [ %31, %alloca_block.dup1900 ], [ %7, %alloca_block.dup ], [ %23, %alloca_block.dup1899 ], [ %phi.edge1904, %bb ]
  %phi.edge1901 = phi i1 [ %14, %alloca_block.dup1898 ], [ %30, %alloca_block.dup1900 ], [ %6, %alloca_block.dup ], [ %22, %alloca_block.dup1899 ], [ %phi.edge1905, %bb ]
  %phi.edge1902 = phi i1 [ %13, %alloca_block.dup1898 ], [ %29, %alloca_block.dup1900 ], [ %5, %alloca_block.dup ], [ %21, %alloca_block.dup1899 ], [ %phi.edge1906, %bb ]
  %phi.edge1903 = phi i1 [ %12, %alloca_block.dup1898 ], [ %28, %alloca_block.dup1900 ], [ %4, %alloca_block.dup ], [ %20, %alloca_block.dup1899 ], [ %phi.edge1907, %bb ]
  br i1 %1, label %bb0, label %cond_336_case_1

bb0:                                              ; preds = %cond_exit_796
  %phi.calluser.edge1869 = phi i1 [ %phi.edge, %cond_exit_796 ]
  %phi.calluser.edge1857 = phi i1 [ %phi.edge1901, %cond_exit_796 ]
  %phi.calluser.edge1845 = phi i1 [ %phi.edge1902, %cond_exit_796 ]
  %phi.calluser.edge1833 = phi i1 [ %phi.edge1903, %cond_exit_796 ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 1 to ptr))
  br label %cond_336_case_1

cond_880_case_1.sink.split.dup1909:               ; preds = %LeafBlock
  %phi.calluser.edge1872 = phi i1 [ %phi.calluser.edge1863, %LeafBlock ]
  %phi.calluser.edge1860 = phi i1 [ %phi.calluser.edge1851, %LeafBlock ]
  %phi.calluser.edge1848 = phi i1 [ %phi.calluser.edge1839, %LeafBlock ]
  %phi.calluser.edge1836 = phi i1 [ %phi.calluser.edge1827, %LeafBlock ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  br label %cond_880_case_1

__prepare_module_record_output_final:             ; preds = %cond_880_case_1
  call void @__quantum__rt__bool_record_output(i1 %0, ptr @0)
  call void @__quantum__rt__bool_record_output(i1 %1, ptr @1)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge1913, ptr @2)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge1912, ptr @3)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge1911, ptr @4)
  call void @__quantum__rt__bool_record_output(i1 %phi.edge1910, ptr @5)
  call void @__quantum__rt__int_record_output(i64 %"61_2.0", ptr @6)
  call void @__quantum__rt__int_record_output(i64 %42, ptr @7)
  call void @__quantum__rt__bool_record_output(i1 %44, ptr @8)
  call void @__quantum__rt__bool_record_output(i1 %45, ptr @9)
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
