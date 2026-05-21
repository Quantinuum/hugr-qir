; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

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

define dso_local void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(i8* null)
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 4 to %Qubit*), %Result* null)
  %0 = tail call i1 @__quantum__rt__read_result(%Result* null)
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 5 to %Qubit*))
  tail call void @__quantum__qis__mz__body(%Qubit* nonnull inttoptr (i64 5 to %Qubit*), %Result* nonnull inttoptr (i64 1 to %Result*))
  %1 = tail call i1 @__quantum__rt__read_result(%Result* nonnull inttoptr (i64 1 to %Result*))
  %"48_2.0" = zext i1 %0 to i64
  %2 = select i1 %0, i64 2, i64 1
  %"74_2.0" = select i1 %1, i64 %2, i64 %"48_2.0"
  br i1 %1, label %alloca_block.dup2153, label %alloca_block.dup2157

alloca_block.dup2153:                             ; preds = %alloca_block
  br i1 %0, label %alloca_block.dup2160, label %alloca_block.dup2171

alloca_block.dup2171:                             ; preds = %alloca_block.dup2153
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 2 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* null)
  %3 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 1 to %Qubit*))
  %4 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 2 to %Qubit*))
  %5 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 3 to %Qubit*))
  %6 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 5 to %Result*))
  br label %cond_exit_176

alloca_block.dup2160:                             ; preds = %alloca_block.dup2153
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* null)
  %7 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 1 to %Qubit*))
  %8 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 2 to %Qubit*))
  %9 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 3 to %Qubit*))
  %10 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 5 to %Result*))
  br label %bb

alloca_block.dup2157:                             ; preds = %alloca_block
  br i1 %0, label %alloca_block.dup2161, label %alloca_block.dup2172

alloca_block.dup2172:                             ; preds = %alloca_block.dup2157
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 3 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* null)
  %11 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 1 to %Qubit*))
  %12 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 2 to %Qubit*))
  %13 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 3 to %Qubit*))
  %14 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 5 to %Result*))
  br label %cond_exit_176

alloca_block.dup2161:                             ; preds = %alloca_block.dup2157
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 1 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* null)
  %15 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 2 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 1 to %Qubit*))
  %16 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 3 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 2 to %Qubit*))
  %17 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 4 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 5 to %Result*))
  call void @__quantum__qis__reset__body(%Qubit* inttoptr (i64 3 to %Qubit*))
  %18 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 5 to %Result*))
  br label %bb

bb:                                               ; preds = %alloca_block.dup2161, %alloca_block.dup2160
  %phi.edge2177 = phi i1 [ %10, %alloca_block.dup2160 ], [ %18, %alloca_block.dup2161 ]
  %phi.edge2178 = phi i1 [ %9, %alloca_block.dup2160 ], [ %17, %alloca_block.dup2161 ]
  %phi.edge2179 = phi i1 [ %8, %alloca_block.dup2160 ], [ %16, %alloca_block.dup2161 ]
  %phi.edge2180 = phi i1 [ %7, %alloca_block.dup2160 ], [ %15, %alloca_block.dup2161 ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* null)
  br label %cond_exit_176

cond_exit_176:                                    ; preds = %alloca_block.dup2172, %alloca_block.dup2171, %bb
  %phi.edge = phi i1 [ %6, %alloca_block.dup2171 ], [ %14, %alloca_block.dup2172 ], [ %phi.edge2177, %bb ]
  %phi.edge2174 = phi i1 [ %5, %alloca_block.dup2171 ], [ %13, %alloca_block.dup2172 ], [ %phi.edge2178, %bb ]
  %phi.edge2175 = phi i1 [ %4, %alloca_block.dup2171 ], [ %12, %alloca_block.dup2172 ], [ %phi.edge2179, %bb ]
  %phi.edge2176 = phi i1 [ %3, %alloca_block.dup2171 ], [ %11, %alloca_block.dup2172 ], [ %phi.edge2180, %bb ]
  br i1 %1, label %bb0, label %cond_374_case_1.dup

cond_374_case_1.dup:                              ; preds = %cond_exit_176
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 6 to %Result*))
  %19 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 6 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 7 to %Result*))
  %20 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 7 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 8 to %Result*))
  %21 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 8 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 9 to %Result*))
  %22 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 9 to %Result*))
  %"1162_0.02187" = select i1 %19, i64 8, i64 0
  %"1197_0.02188" = select i1 %20, i64 4, i64 0
  %"1232_0.02189" = select i1 %21, i64 2, i64 0
  %"1267_0.02190" = zext i1 %22 to i64
  %23 = or i64 %"1197_0.02188", %"1162_0.02187"
  %24 = or i64 %23, %"1232_0.02189"
  %25 = or i64 %24, %"1267_0.02190"
  %"1077_0.02191" = zext i1 %21 to i64
  %26 = add i64 %"74_2.0", %"1077_0.02191"
  %Pivot20932192 = icmp slt i64 %26, 1
  br i1 %Pivot20932192, label %cond_759_case_1.sink.split.dup2224, label %NodeBlock.dup

NodeBlock.dup:                                    ; preds = %cond_374_case_1.dup
  %Pivot2232 = icmp slt i64 %26, 2
  br i1 %Pivot2232, label %cond_759_case_1.sink.split.dup2270, label %LeafBlock.dup

cond_759_case_1.sink.split.dup2270:               ; preds = %NodeBlock.dup
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 7 to %Qubit*))
  br label %cond_759_case_1.dup

cond_759_case_1.dup:                              ; preds = %cond_759_case_1.sink.split.dup2270
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 6 to %Qubit*), %Result* inttoptr (i64 10 to %Result*))
  %27 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 10 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 7 to %Qubit*), %Result* inttoptr (i64 11 to %Result*))
  %28 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 11 to %Result*))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, %Qubit* inttoptr (i64 8 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 8 to %Qubit*), %Result* inttoptr (i64 12 to %Result*))
  %29 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 12 to %Result*))
  br label %__prepare_module_record_output_final

LeafBlock.dup:                                    ; preds = %NodeBlock.dup
  %SwitchLeaf2248 = icmp eq i64 %26, 2
  br i1 %SwitchLeaf2248, label %cond_759_case_1.sink.split.dup, label %cond_759_case_1.dup2278

cond_759_case_1.dup2278:                          ; preds = %LeafBlock.dup
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 6 to %Qubit*), %Result* inttoptr (i64 10 to %Result*))
  %30 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 10 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 7 to %Qubit*), %Result* inttoptr (i64 11 to %Result*))
  %31 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 11 to %Result*))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, %Qubit* inttoptr (i64 8 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 8 to %Qubit*), %Result* inttoptr (i64 12 to %Result*))
  %32 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 12 to %Result*))
  br label %__prepare_module_record_output_final

cond_759_case_1.sink.split.dup:                   ; preds = %LeafBlock.dup
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 7 to %Qubit*))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 6 to %Qubit*))
  br label %cond_759_case_1.dup2279

cond_759_case_1.dup2279:                          ; preds = %cond_759_case_1.sink.split.dup
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 6 to %Qubit*), %Result* inttoptr (i64 10 to %Result*))
  %33 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 10 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 7 to %Qubit*), %Result* inttoptr (i64 11 to %Result*))
  %34 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 11 to %Result*))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, %Qubit* inttoptr (i64 8 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 8 to %Qubit*), %Result* inttoptr (i64 12 to %Result*))
  %35 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 12 to %Result*))
  br label %__prepare_module_record_output_final

cond_759_case_1.sink.split.dup2224:               ; preds = %cond_374_case_1.dup
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 6 to %Qubit*))
  br label %cond_759_case_1.dup2280

cond_759_case_1.dup2280:                          ; preds = %cond_759_case_1.sink.split.dup2224
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 6 to %Qubit*), %Result* inttoptr (i64 10 to %Result*))
  %36 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 10 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 7 to %Qubit*), %Result* inttoptr (i64 11 to %Result*))
  %37 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 11 to %Result*))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, %Qubit* inttoptr (i64 8 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 8 to %Qubit*), %Result* inttoptr (i64 12 to %Result*))
  %38 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 12 to %Result*))
  br label %__prepare_module_record_output_final

bb0:                                              ; preds = %cond_exit_176
  %phi.calluser.edge2140 = phi i1 [ %phi.edge, %cond_exit_176 ]
  %phi.calluser.edge2127 = phi i1 [ %phi.edge2174, %cond_exit_176 ]
  %phi.calluser.edge2114 = phi i1 [ %phi.edge2175, %cond_exit_176 ]
  %phi.calluser.edge2101 = phi i1 [ %phi.edge2176, %cond_exit_176 ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* nonnull inttoptr (i64 1 to %Qubit*))
  br label %cond_374_case_1.dup2193

cond_374_case_1.dup2193:                          ; preds = %bb0
  call void @__quantum__qis__mz__body(%Qubit* null, %Result* inttoptr (i64 6 to %Result*))
  %39 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 6 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 1 to %Qubit*), %Result* inttoptr (i64 7 to %Result*))
  %40 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 7 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 2 to %Qubit*), %Result* inttoptr (i64 8 to %Result*))
  %41 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 8 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 3 to %Qubit*), %Result* inttoptr (i64 9 to %Result*))
  %42 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 9 to %Result*))
  %"1162_0.02194" = select i1 %39, i64 8, i64 0
  %"1197_0.02195" = select i1 %40, i64 4, i64 0
  %"1232_0.02196" = select i1 %41, i64 2, i64 0
  %"1267_0.02197" = zext i1 %42 to i64
  %43 = or i64 %"1197_0.02195", %"1162_0.02194"
  %44 = or i64 %43, %"1232_0.02196"
  %45 = or i64 %44, %"1267_0.02197"
  %"1077_0.02198" = zext i1 %41 to i64
  %46 = add i64 %"74_2.0", %"1077_0.02198"
  %Pivot20932199 = icmp slt i64 %46, 1
  br i1 %Pivot20932199, label %cond_759_case_1.sink.split.dup2225, label %NodeBlock.dup2233

NodeBlock.dup2233:                                ; preds = %cond_374_case_1.dup2193
  %Pivot2234 = icmp slt i64 %46, 2
  br i1 %Pivot2234, label %cond_759_case_1.sink.split.dup2271, label %LeafBlock.dup2249

cond_759_case_1.sink.split.dup2271:               ; preds = %NodeBlock.dup2233
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 7 to %Qubit*))
  br label %cond_759_case_1.dup2281

cond_759_case_1.dup2281:                          ; preds = %cond_759_case_1.sink.split.dup2271
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 6 to %Qubit*), %Result* inttoptr (i64 10 to %Result*))
  %47 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 10 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 7 to %Qubit*), %Result* inttoptr (i64 11 to %Result*))
  %48 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 11 to %Result*))
  call void @__quantum__qis__phasedx__body(double 0x3FE41B2F769CF0E0, double 0.000000e+00, %Qubit* inttoptr (i64 8 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 8 to %Qubit*), %Result* inttoptr (i64 12 to %Result*))
  %49 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 12 to %Result*))
  br label %__prepare_module_record_output_final

LeafBlock.dup2249:                                ; preds = %NodeBlock.dup2233
  %SwitchLeaf2250 = icmp eq i64 %46, 2
  br i1 %SwitchLeaf2250, label %cond_759_case_1.sink.split.dup2263, label %cond_759_case_1.dup2282

cond_759_case_1.dup2282:                          ; preds = %LeafBlock.dup2249
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 6 to %Qubit*), %Result* inttoptr (i64 10 to %Result*))
  %50 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 10 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 7 to %Qubit*), %Result* inttoptr (i64 11 to %Result*))
  %51 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 11 to %Result*))
  call void @__quantum__qis__phasedx__body(double 0x3FE41B2F769CF0E0, double 0.000000e+00, %Qubit* inttoptr (i64 8 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 8 to %Qubit*), %Result* inttoptr (i64 12 to %Result*))
  %52 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 12 to %Result*))
  br label %__prepare_module_record_output_final

cond_759_case_1.sink.split.dup2263:               ; preds = %LeafBlock.dup2249
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 7 to %Qubit*))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 6 to %Qubit*))
  br label %cond_759_case_1.dup2283

cond_759_case_1.dup2283:                          ; preds = %cond_759_case_1.sink.split.dup2263
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 6 to %Qubit*), %Result* inttoptr (i64 10 to %Result*))
  %53 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 10 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 7 to %Qubit*), %Result* inttoptr (i64 11 to %Result*))
  %54 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 11 to %Result*))
  call void @__quantum__qis__phasedx__body(double 0x3FE41B2F769CF0E0, double 0.000000e+00, %Qubit* inttoptr (i64 8 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 8 to %Qubit*), %Result* inttoptr (i64 12 to %Result*))
  %55 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 12 to %Result*))
  br label %__prepare_module_record_output_final

cond_759_case_1.sink.split.dup2225:               ; preds = %cond_374_case_1.dup2193
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, %Qubit* inttoptr (i64 6 to %Qubit*))
  br label %cond_759_case_1.dup2284

cond_759_case_1.dup2284:                          ; preds = %cond_759_case_1.sink.split.dup2225
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 6 to %Qubit*), %Result* inttoptr (i64 10 to %Result*))
  %56 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 10 to %Result*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 7 to %Qubit*), %Result* inttoptr (i64 11 to %Result*))
  %57 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 11 to %Result*))
  call void @__quantum__qis__phasedx__body(double 0x3FE41B2F769CF0E0, double 0.000000e+00, %Qubit* inttoptr (i64 8 to %Qubit*))
  call void @__quantum__qis__mz__body(%Qubit* inttoptr (i64 8 to %Qubit*), %Result* inttoptr (i64 12 to %Result*))
  %58 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 12 to %Result*))
  br label %__prepare_module_record_output_final

__prepare_module_record_output_final:             ; preds = %cond_759_case_1.dup2284, %cond_759_case_1.dup2283, %cond_759_case_1.dup2282, %cond_759_case_1.dup2281, %cond_759_case_1.dup2280, %cond_759_case_1.dup2279, %cond_759_case_1.dup2278, %cond_759_case_1.dup
  %phi.calluser.edge2291 = phi i1 [ %29, %cond_759_case_1.dup ], [ %32, %cond_759_case_1.dup2278 ], [ %35, %cond_759_case_1.dup2279 ], [ %38, %cond_759_case_1.dup2280 ], [ %49, %cond_759_case_1.dup2281 ], [ %52, %cond_759_case_1.dup2282 ], [ %55, %cond_759_case_1.dup2283 ], [ %58, %cond_759_case_1.dup2284 ]
  %phi.calluser.edge2290 = phi i1 [ %28, %cond_759_case_1.dup ], [ %31, %cond_759_case_1.dup2278 ], [ %34, %cond_759_case_1.dup2279 ], [ %37, %cond_759_case_1.dup2280 ], [ %48, %cond_759_case_1.dup2281 ], [ %51, %cond_759_case_1.dup2282 ], [ %54, %cond_759_case_1.dup2283 ], [ %57, %cond_759_case_1.dup2284 ]
  %phi.calluser.edge2289 = phi i1 [ %27, %cond_759_case_1.dup ], [ %30, %cond_759_case_1.dup2278 ], [ %33, %cond_759_case_1.dup2279 ], [ %36, %cond_759_case_1.dup2280 ], [ %47, %cond_759_case_1.dup2281 ], [ %50, %cond_759_case_1.dup2282 ], [ %53, %cond_759_case_1.dup2283 ], [ %56, %cond_759_case_1.dup2284 ]
  %phi.calluser.edge2288 = phi i1 [ %phi.edge2176, %cond_759_case_1.dup ], [ %phi.edge2176, %cond_759_case_1.dup2278 ], [ %phi.edge2176, %cond_759_case_1.dup2279 ], [ %phi.edge2176, %cond_759_case_1.dup2280 ], [ %phi.calluser.edge2101, %cond_759_case_1.dup2281 ], [ %phi.calluser.edge2101, %cond_759_case_1.dup2282 ], [ %phi.calluser.edge2101, %cond_759_case_1.dup2283 ], [ %phi.calluser.edge2101, %cond_759_case_1.dup2284 ]
  %phi.calluser.edge2287 = phi i1 [ %phi.edge2175, %cond_759_case_1.dup ], [ %phi.edge2175, %cond_759_case_1.dup2278 ], [ %phi.edge2175, %cond_759_case_1.dup2279 ], [ %phi.edge2175, %cond_759_case_1.dup2280 ], [ %phi.calluser.edge2114, %cond_759_case_1.dup2281 ], [ %phi.calluser.edge2114, %cond_759_case_1.dup2282 ], [ %phi.calluser.edge2114, %cond_759_case_1.dup2283 ], [ %phi.calluser.edge2114, %cond_759_case_1.dup2284 ]
  %phi.calluser.edge2286 = phi i1 [ %phi.edge2174, %cond_759_case_1.dup ], [ %phi.edge2174, %cond_759_case_1.dup2278 ], [ %phi.edge2174, %cond_759_case_1.dup2279 ], [ %phi.edge2174, %cond_759_case_1.dup2280 ], [ %phi.calluser.edge2127, %cond_759_case_1.dup2281 ], [ %phi.calluser.edge2127, %cond_759_case_1.dup2282 ], [ %phi.calluser.edge2127, %cond_759_case_1.dup2283 ], [ %phi.calluser.edge2127, %cond_759_case_1.dup2284 ]
  %phi.calluser.edge = phi i1 [ %phi.edge, %cond_759_case_1.dup ], [ %phi.edge, %cond_759_case_1.dup2278 ], [ %phi.edge, %cond_759_case_1.dup2279 ], [ %phi.edge, %cond_759_case_1.dup2280 ], [ %phi.calluser.edge2140, %cond_759_case_1.dup2281 ], [ %phi.calluser.edge2140, %cond_759_case_1.dup2282 ], [ %phi.calluser.edge2140, %cond_759_case_1.dup2283 ], [ %phi.calluser.edge2140, %cond_759_case_1.dup2284 ]
  %phi.edge2285 = phi i64 [ %25, %cond_759_case_1.dup2278 ], [ %45, %cond_759_case_1.dup2282 ], [ %25, %cond_759_case_1.dup2279 ], [ %25, %cond_759_case_1.dup2280 ], [ %45, %cond_759_case_1.dup2284 ], [ %45, %cond_759_case_1.dup2283 ], [ %25, %cond_759_case_1.dup ], [ %45, %cond_759_case_1.dup2281 ]
  call void @__quantum__rt__bool_record_output(i1 %0, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @0, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %1, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @1, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2288, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @2, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2287, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @3, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2286, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @4, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @5, i64 0, i64 0))
  call void @__quantum__rt__int_record_output(i64 %"74_2.0", i8* getelementptr inbounds ([8 x i8], [8 x i8]* @6, i64 0, i64 0))
  call void @__quantum__rt__int_record_output(i64 %phi.edge2285, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @7, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2289, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @8, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2290, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @9, i64 0, i64 0))
  call void @__quantum__rt__bool_record_output(i1 %phi.calluser.edge2291, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @10, i64 0, i64 0))
  ret void
}

declare void @__quantum__qis__mz__body(%Qubit*, %Result* writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(%Result* readonly) local_unnamed_addr

declare void @__quantum__qis__phasedx__body(double, double, %Qubit*) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, i8*) local_unnamed_addr

declare void @__quantum__qis__reset__body(%Qubit*) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, i8*) local_unnamed_addr

declare void @__quantum__rt__initialize(i8*) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="9" "required_num_results"="13" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
