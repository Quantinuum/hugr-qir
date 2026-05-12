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
  br i1 %1, label %alloca_block.dup.1, label %alloca_block.dup.0

cond_374_case_1.dup.p1.0:                         ; preds = %cond_exit_855.dup.p4.0, %cond_exit_855.dup.p2.0, %cond_exit_855.dup.p7.0
  %phi.fix2334 = phi i64 [ %"74_2.02091", %cond_exit_855.dup.p2.0 ], [ %"74_2.02090", %cond_exit_855.dup.p4.0 ], [ %"74_2.02091", %cond_exit_855.dup.p7.0 ]
  %phi.fix2335 = phi i1 [ %42, %cond_exit_855.dup.p2.0 ], [ %58, %cond_exit_855.dup.p4.0 ], [ %74, %cond_exit_855.dup.p7.0 ]
  %phi.fix2336 = phi i1 [ %43, %cond_exit_855.dup.p2.0 ], [ %59, %cond_exit_855.dup.p4.0 ], [ %75, %cond_exit_855.dup.p7.0 ]
  %phi.fix2337 = phi i1 [ %44, %cond_exit_855.dup.p2.0 ], [ %60, %cond_exit_855.dup.p4.0 ], [ %76, %cond_exit_855.dup.p7.0 ]
  %phi.fix2338 = phi i1 [ %45, %cond_exit_855.dup.p2.0 ], [ %61, %cond_exit_855.dup.p4.0 ], [ %77, %cond_exit_855.dup.p7.0 ]
  tail call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr nonnull inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %3 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %4 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %5 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %6 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  %"1370_0.02116" = select i1 %3, i64 8, i64 0
  %"1408_0.02117" = select i1 %4, i64 4, i64 0
  %"1446_0.02118" = select i1 %5, i64 2, i64 0
  %"1484_0.02119" = zext i1 %6 to i64
  %7 = or i64 %"1408_0.02117", %"1370_0.02116"
  %8 = or i64 %7, %"1446_0.02118"
  %9 = or i64 %8, %"1484_0.02119"
  %"1282_0.02120" = zext i1 %5 to i64
  %10 = add i64 %phi.fix2334, %"1282_0.02120"
  %Pivot20892142 = icmp slt i64 %10, 1
  br i1 %Pivot20892142, label %.sink.split.dup.p2.0, label %NodeBlock.dup.p1.0

bb:                                               ; preds = %bb.dup.p3.02718, %bb.dup.p5.0, %bb.dup.p8.02722, %bb.dup.p9.02723, %bb.dup.p0.02351, %.sink.split.dup.p9.02610, %.sink.split.dup.p8.02609, %.sink.split.dup.p5.02606, %.sink.split.dup.p3.02604, %.sink.split.dup.p9.0, %.sink.split.dup.p8.0, %.sink.split.dup.p5.0, %.sink.split.dup.p3.02593, %bb.dup.p6.02694, %bb.dup.p7.02695, %bb.dup.p10.02698, %bb.dup.p12.02700, %.sink.split.dup.p2.0, %.sink.split.dup.p0.0, %bb.dup.p6.0
  tail call void @abort()
  unreachable

__prepare_module_record_output_final:             ; preds = %cond_949_case_1.dup.p12.02881, %cond_949_case_1.dup.p10.02879, %cond_949_case_1.dup.p7.02876, %cond_949_case_1.dup.p6.0, %cond_949_case_1.dup.p1.02814, %cond_949_case_1.dup.p9.02798, %cond_949_case_1.dup.p8.02797, %cond_949_case_1.dup.p5.02794, %cond_949_case_1.dup.p3.0, %cond_949_case_1.dup.p9.02774, %cond_949_case_1.dup.p8.02773, %cond_949_case_1.dup.p5.02770, %cond_949_case_1.dup.p3.02768, %cond_949_case_1.dup.p9.0, %cond_949_case_1.dup.p8.0, %cond_949_case_1.dup.p5.02755, %cond_949_case_1.dup.p3.02753, %cond_949_case_1.dup.p4.0, %cond_949_case_1.dup.p2.0, %cond_949_case_1.dup.p0.0
  %phi.fix = phi i64 [ %phi.fix2334, %cond_949_case_1.dup.p0.0 ], [ %"74_2.02091", %cond_949_case_1.dup.p3.02753 ], [ %"74_2.02090", %cond_949_case_1.dup.p5.02755 ], [ %"74_2.02091", %cond_949_case_1.dup.p8.0 ], [ %"74_2.02090", %cond_949_case_1.dup.p9.0 ], [ %phi.fix2334, %cond_949_case_1.dup.p2.0 ], [ %"74_2.02091", %cond_949_case_1.dup.p3.02768 ], [ %"74_2.02090", %cond_949_case_1.dup.p5.02770 ], [ %"74_2.02091", %cond_949_case_1.dup.p8.02773 ], [ %"74_2.02090", %cond_949_case_1.dup.p9.02774 ], [ %phi.fix2334, %cond_949_case_1.dup.p4.0 ], [ %"74_2.02091", %cond_949_case_1.dup.p3.0 ], [ %"74_2.02090", %cond_949_case_1.dup.p5.02794 ], [ %"74_2.02091", %cond_949_case_1.dup.p8.02797 ], [ %"74_2.02090", %cond_949_case_1.dup.p9.02798 ], [ %"74_2.02090", %cond_949_case_1.dup.p6.0 ], [ %"74_2.02091", %cond_949_case_1.dup.p7.02876 ], [ %"74_2.02090", %cond_949_case_1.dup.p10.02879 ], [ %"74_2.02091", %cond_949_case_1.dup.p12.02881 ], [ %phi.fix2334, %cond_949_case_1.dup.p1.02814 ]
  %phi.fix2885 = phi i64 [ %9, %cond_949_case_1.dup.p0.0 ], [ %56, %cond_949_case_1.dup.p3.02753 ], [ %72, %cond_949_case_1.dup.p5.02755 ], [ %28, %cond_949_case_1.dup.p8.0 ], [ %40, %cond_949_case_1.dup.p9.0 ], [ %9, %cond_949_case_1.dup.p2.0 ], [ %56, %cond_949_case_1.dup.p3.02768 ], [ %72, %cond_949_case_1.dup.p5.02770 ], [ %28, %cond_949_case_1.dup.p8.02773 ], [ %40, %cond_949_case_1.dup.p9.02774 ], [ %9, %cond_949_case_1.dup.p4.0 ], [ %56, %cond_949_case_1.dup.p3.0 ], [ %72, %cond_949_case_1.dup.p5.02794 ], [ %28, %cond_949_case_1.dup.p8.02797 ], [ %40, %cond_949_case_1.dup.p9.02798 ], [ %40, %cond_949_case_1.dup.p6.0 ], [ %28, %cond_949_case_1.dup.p7.02876 ], [ %72, %cond_949_case_1.dup.p10.02879 ], [ %56, %cond_949_case_1.dup.p12.02881 ], [ %9, %cond_949_case_1.dup.p1.02814 ]
  %phi.fix2886 = phi i1 [ %val.available2206, %cond_949_case_1.dup.p0.0 ], [ %46, %cond_949_case_1.dup.p3.02753 ], [ %62, %cond_949_case_1.dup.p5.02755 ], [ %18, %cond_949_case_1.dup.p8.0 ], [ %30, %cond_949_case_1.dup.p9.0 ], [ %val.available2220, %cond_949_case_1.dup.p2.0 ], [ %46, %cond_949_case_1.dup.p3.02768 ], [ %62, %cond_949_case_1.dup.p5.02770 ], [ %18, %cond_949_case_1.dup.p8.02773 ], [ %30, %cond_949_case_1.dup.p9.02774 ], [ %val.available2226, %cond_949_case_1.dup.p4.0 ], [ %46, %cond_949_case_1.dup.p3.0 ], [ %62, %cond_949_case_1.dup.p5.02794 ], [ %18, %cond_949_case_1.dup.p8.02797 ], [ %30, %cond_949_case_1.dup.p9.02798 ], [ %30, %cond_949_case_1.dup.p6.0 ], [ %18, %cond_949_case_1.dup.p7.02876 ], [ %62, %cond_949_case_1.dup.p10.02879 ], [ %46, %cond_949_case_1.dup.p12.02881 ], [ %val.available2207, %cond_949_case_1.dup.p1.02814 ]
  %phi.fix2887 = phi i1 [ %val.available2234, %cond_949_case_1.dup.p0.0 ], [ %47, %cond_949_case_1.dup.p3.02753 ], [ %63, %cond_949_case_1.dup.p5.02755 ], [ %19, %cond_949_case_1.dup.p8.0 ], [ %31, %cond_949_case_1.dup.p9.0 ], [ %val.available2248, %cond_949_case_1.dup.p2.0 ], [ %47, %cond_949_case_1.dup.p3.02768 ], [ %63, %cond_949_case_1.dup.p5.02770 ], [ %19, %cond_949_case_1.dup.p8.02773 ], [ %31, %cond_949_case_1.dup.p9.02774 ], [ %val.available2254, %cond_949_case_1.dup.p4.0 ], [ %47, %cond_949_case_1.dup.p3.0 ], [ %63, %cond_949_case_1.dup.p5.02794 ], [ %19, %cond_949_case_1.dup.p8.02797 ], [ %31, %cond_949_case_1.dup.p9.02798 ], [ %31, %cond_949_case_1.dup.p6.0 ], [ %19, %cond_949_case_1.dup.p7.02876 ], [ %63, %cond_949_case_1.dup.p10.02879 ], [ %47, %cond_949_case_1.dup.p12.02881 ], [ %val.available2235, %cond_949_case_1.dup.p1.02814 ]
  %phi.fix2888 = phi i1 [ %val.available2262, %cond_949_case_1.dup.p0.0 ], [ %48, %cond_949_case_1.dup.p3.02753 ], [ %64, %cond_949_case_1.dup.p5.02755 ], [ %20, %cond_949_case_1.dup.p8.0 ], [ %32, %cond_949_case_1.dup.p9.0 ], [ %val.available2276, %cond_949_case_1.dup.p2.0 ], [ %48, %cond_949_case_1.dup.p3.02768 ], [ %64, %cond_949_case_1.dup.p5.02770 ], [ %20, %cond_949_case_1.dup.p8.02773 ], [ %32, %cond_949_case_1.dup.p9.02774 ], [ %val.available2282, %cond_949_case_1.dup.p4.0 ], [ %48, %cond_949_case_1.dup.p3.0 ], [ %64, %cond_949_case_1.dup.p5.02794 ], [ %20, %cond_949_case_1.dup.p8.02797 ], [ %32, %cond_949_case_1.dup.p9.02798 ], [ %32, %cond_949_case_1.dup.p6.0 ], [ %20, %cond_949_case_1.dup.p7.02876 ], [ %64, %cond_949_case_1.dup.p10.02879 ], [ %48, %cond_949_case_1.dup.p12.02881 ], [ %val.available2263, %cond_949_case_1.dup.p1.02814 ]
  %phi.fix2889 = phi i1 [ %val.available2290, %cond_949_case_1.dup.p0.0 ], [ %49, %cond_949_case_1.dup.p3.02753 ], [ %65, %cond_949_case_1.dup.p5.02755 ], [ %21, %cond_949_case_1.dup.p8.0 ], [ %33, %cond_949_case_1.dup.p9.0 ], [ %val.available2304, %cond_949_case_1.dup.p2.0 ], [ %49, %cond_949_case_1.dup.p3.02768 ], [ %65, %cond_949_case_1.dup.p5.02770 ], [ %21, %cond_949_case_1.dup.p8.02773 ], [ %33, %cond_949_case_1.dup.p9.02774 ], [ %val.available2310, %cond_949_case_1.dup.p4.0 ], [ %49, %cond_949_case_1.dup.p3.0 ], [ %65, %cond_949_case_1.dup.p5.02794 ], [ %21, %cond_949_case_1.dup.p8.02797 ], [ %33, %cond_949_case_1.dup.p9.02798 ], [ %33, %cond_949_case_1.dup.p6.0 ], [ %21, %cond_949_case_1.dup.p7.02876 ], [ %65, %cond_949_case_1.dup.p10.02879 ], [ %49, %cond_949_case_1.dup.p12.02881 ], [ %val.available2291, %cond_949_case_1.dup.p1.02814 ]
  %phi.fix2890 = phi i1 [ %160, %cond_949_case_1.dup.p6.0 ], [ %163, %cond_949_case_1.dup.p7.02876 ], [ %166, %cond_949_case_1.dup.p10.02879 ], [ %169, %cond_949_case_1.dup.p12.02881 ], [ %157, %cond_949_case_1.dup.p1.02814 ], [ %145, %cond_949_case_1.dup.p3.0 ], [ %148, %cond_949_case_1.dup.p5.02794 ], [ %151, %cond_949_case_1.dup.p8.02797 ], [ %154, %cond_949_case_1.dup.p9.02798 ], [ %86, %cond_949_case_1.dup.p4.0 ], [ %133, %cond_949_case_1.dup.p3.02768 ], [ %136, %cond_949_case_1.dup.p5.02770 ], [ %139, %cond_949_case_1.dup.p8.02773 ], [ %142, %cond_949_case_1.dup.p9.02774 ], [ %83, %cond_949_case_1.dup.p2.0 ], [ %121, %cond_949_case_1.dup.p3.02753 ], [ %124, %cond_949_case_1.dup.p5.02755 ], [ %127, %cond_949_case_1.dup.p8.0 ], [ %130, %cond_949_case_1.dup.p9.0 ], [ %80, %cond_949_case_1.dup.p0.0 ]
  %phi.fix2891 = phi i1 [ %161, %cond_949_case_1.dup.p6.0 ], [ %164, %cond_949_case_1.dup.p7.02876 ], [ %167, %cond_949_case_1.dup.p10.02879 ], [ %170, %cond_949_case_1.dup.p12.02881 ], [ %158, %cond_949_case_1.dup.p1.02814 ], [ %146, %cond_949_case_1.dup.p3.0 ], [ %149, %cond_949_case_1.dup.p5.02794 ], [ %152, %cond_949_case_1.dup.p8.02797 ], [ %155, %cond_949_case_1.dup.p9.02798 ], [ %87, %cond_949_case_1.dup.p4.0 ], [ %134, %cond_949_case_1.dup.p3.02768 ], [ %137, %cond_949_case_1.dup.p5.02770 ], [ %140, %cond_949_case_1.dup.p8.02773 ], [ %143, %cond_949_case_1.dup.p9.02774 ], [ %84, %cond_949_case_1.dup.p2.0 ], [ %122, %cond_949_case_1.dup.p3.02753 ], [ %125, %cond_949_case_1.dup.p5.02755 ], [ %128, %cond_949_case_1.dup.p8.0 ], [ %131, %cond_949_case_1.dup.p9.0 ], [ %81, %cond_949_case_1.dup.p0.0 ]
  %phi.fix2892 = phi i1 [ %162, %cond_949_case_1.dup.p6.0 ], [ %165, %cond_949_case_1.dup.p7.02876 ], [ %168, %cond_949_case_1.dup.p10.02879 ], [ %171, %cond_949_case_1.dup.p12.02881 ], [ %159, %cond_949_case_1.dup.p1.02814 ], [ %147, %cond_949_case_1.dup.p3.0 ], [ %150, %cond_949_case_1.dup.p5.02794 ], [ %153, %cond_949_case_1.dup.p8.02797 ], [ %156, %cond_949_case_1.dup.p9.02798 ], [ %88, %cond_949_case_1.dup.p4.0 ], [ %135, %cond_949_case_1.dup.p3.02768 ], [ %138, %cond_949_case_1.dup.p5.02770 ], [ %141, %cond_949_case_1.dup.p8.02773 ], [ %144, %cond_949_case_1.dup.p9.02774 ], [ %85, %cond_949_case_1.dup.p2.0 ], [ %123, %cond_949_case_1.dup.p3.02753 ], [ %126, %cond_949_case_1.dup.p5.02755 ], [ %129, %cond_949_case_1.dup.p8.0 ], [ %132, %cond_949_case_1.dup.p9.0 ], [ %82, %cond_949_case_1.dup.p0.0 ]
  call void @__quantum__rt__bool_record_output(i1 %0, ptr @0)
  call void @__quantum__rt__bool_record_output(i1 %1, ptr @1)
  call void @__quantum__rt__int_record_output(i64 %phi.fix2885, ptr @7)
  call void @__quantum__rt__bool_record_output(i1 %phi.fix2886, ptr @2)
  call void @__quantum__rt__bool_record_output(i1 %phi.fix2887, ptr @3)
  call void @__quantum__rt__bool_record_output(i1 %phi.fix2888, ptr @4)
  call void @__quantum__rt__bool_record_output(i1 %phi.fix2889, ptr @5)
  call void @__quantum__rt__int_record_output(i64 %phi.fix, ptr @6)
  call void @__quantum__rt__bool_record_output(i1 %phi.fix2890, ptr @8)
  call void @__quantum__rt__bool_record_output(i1 %phi.fix2891, ptr @9)
  call void @__quantum__rt__bool_record_output(i1 %phi.fix2892, ptr @10)
  ret void

alloca_block.dup.0:                               ; preds = %alloca_block
  %"74_2.02090" = select i1 %1, i64 %2, i64 %"48_2.0"
  br i1 %0, label %cond_exit_855.dup.p1.0, label %cond_exit_101.route.p0

alloca_block.dup.1:                               ; preds = %alloca_block
  %"74_2.02091" = select i1 %1, i64 %2, i64 %"48_2.0"
  %11 = select i1 %0, i1 %1, i1 false
  br i1 %11, label %cond_exit_855.dup.p7.0, label %cond_exit_755.dup.p0.0

NodeBlock.dup.p1.0:                               ; preds = %cond_374_case_1.dup.p1.0
  %val.available2208 = phi i1 [ %phi.fix2335, %cond_374_case_1.dup.p1.0 ]
  %val.available2236 = phi i1 [ %phi.fix2336, %cond_374_case_1.dup.p1.0 ]
  %val.available2264 = phi i1 [ %phi.fix2337, %cond_374_case_1.dup.p1.0 ]
  %val.available2292 = phi i1 [ %phi.fix2338, %cond_374_case_1.dup.p1.0 ]
  %Pivot2153 = icmp slt i64 %10, 2
  br i1 %Pivot2153, label %.sink.split.dup.p0.0, label %LeafBlock.dup.p0.0

LeafBlock.dup.p0.0:                               ; preds = %NodeBlock.dup.p1.0
  %val.available2207 = phi i1 [ %val.available2208, %NodeBlock.dup.p1.0 ]
  %val.available2235 = phi i1 [ %val.available2236, %NodeBlock.dup.p1.0 ]
  %val.available2263 = phi i1 [ %val.available2264, %NodeBlock.dup.p1.0 ]
  %val.available2291 = phi i1 [ %val.available2292, %NodeBlock.dup.p1.0 ]
  %SwitchLeaf2161 = icmp eq i64 %10, 2
  br i1 %SwitchLeaf2161, label %bb.dup.p0.02351, label %bb.dup.p6.0

.sink.split.dup.p0.0:                             ; preds = %NodeBlock.dup.p1.0
  %val.available2220 = phi i1 [ %val.available2208, %NodeBlock.dup.p1.0 ]
  %val.available2248 = phi i1 [ %val.available2236, %NodeBlock.dup.p1.0 ]
  %val.available2276 = phi i1 [ %val.available2264, %NodeBlock.dup.p1.0 ]
  %val.available2304 = phi i1 [ %val.available2292, %NodeBlock.dup.p1.0 ]
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  %12 = call double @llvm.fabs.f64(double 2.000000e-01)
  %13 = fcmp ueq double %12, 0x7FF0000000000000
  br i1 %13, label %bb, label %cond_949_case_1.dup.p2.0

.sink.split.dup.p2.0:                             ; preds = %cond_374_case_1.dup.p1.0
  %val.available2226 = phi i1 [ %phi.fix2335, %cond_374_case_1.dup.p1.0 ]
  %val.available2254 = phi i1 [ %phi.fix2336, %cond_374_case_1.dup.p1.0 ]
  %val.available2282 = phi i1 [ %phi.fix2337, %cond_374_case_1.dup.p1.0 ]
  %val.available2310 = phi i1 [ %phi.fix2338, %cond_374_case_1.dup.p1.0 ]
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  %14 = call double @llvm.fabs.f64(double 2.000000e-01)
  %15 = fcmp ueq double %14, 0x7FF0000000000000
  br i1 %15, label %bb, label %cond_949_case_1.dup.p4.0

bb.dup.p6.0:                                      ; preds = %LeafBlock.dup.p0.0
  %val.available2206 = phi i1 [ %val.available2207, %LeafBlock.dup.p0.0 ]
  %val.available2234 = phi i1 [ %val.available2235, %LeafBlock.dup.p0.0 ]
  %val.available2262 = phi i1 [ %val.available2263, %LeafBlock.dup.p0.0 ]
  %val.available2290 = phi i1 [ %val.available2291, %LeafBlock.dup.p0.0 ]
  %16 = call double @llvm.fabs.f64(double 2.000000e-01)
  %17 = fcmp ueq double %16, 0x7FF0000000000000
  br i1 %17, label %bb, label %cond_949_case_1.dup.p0.0

cond_exit_755.dup.p0.0:                           ; preds = %alloca_block.dup.1
  br i1 %0, label %cond_exit_855.dup.p0.0, label %cond_exit_101.route.p1

cond_exit_101.route.p0:                           ; preds = %alloca_block.dup.0
  br i1 %1, label %cond_exit_855.dup.p4.0, label %cond_exit_855.dup.p5.0

cond_exit_101.route.p1:                           ; preds = %cond_exit_755.dup.p0.0
  br i1 %1, label %cond_exit_855.dup.p2.0, label %cond_exit_855.dup.p3.0

cond_exit_855.dup.p0.0:                           ; preds = %cond_exit_755.dup.p0.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %18 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %19 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %20 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %21 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %22 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %23 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %24 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %25 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  %"1370_0.021112410" = select i1 %22, i64 8, i64 0
  %"1408_0.021122411" = select i1 %23, i64 4, i64 0
  %"1446_0.021132412" = select i1 %24, i64 2, i64 0
  %"1484_0.021142413" = zext i1 %25 to i64
  %26 = or i64 %"1408_0.021122411", %"1370_0.021112410"
  %27 = or i64 %26, %"1446_0.021132412"
  %28 = or i64 %27, %"1484_0.021142413"
  %"1282_0.021152414" = zext i1 %24 to i64
  %29 = add i64 %"74_2.02091", %"1282_0.021152414"
  %Pivot208921432488 = icmp slt i64 %29, 1
  br i1 %Pivot208921432488, label %.sink.split.dup.p8.02609, label %NodeBlock.dup.p7.0

cond_exit_855.dup.p1.0:                           ; preds = %alloca_block.dup.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 1 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %30 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %31 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %32 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %33 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %34 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %35 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %36 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %37 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  %"1370_0.021112405" = select i1 %34, i64 8, i64 0
  %"1408_0.021122406" = select i1 %35, i64 4, i64 0
  %"1446_0.021132407" = select i1 %36, i64 2, i64 0
  %"1484_0.021142408" = zext i1 %37 to i64
  %38 = or i64 %"1408_0.021122406", %"1370_0.021112405"
  %39 = or i64 %38, %"1446_0.021132407"
  %40 = or i64 %39, %"1484_0.021142408"
  %"1282_0.021152409" = zext i1 %36 to i64
  %41 = add i64 %"74_2.02090", %"1282_0.021152409"
  %Pivot208921432489 = icmp slt i64 %41, 1
  br i1 %Pivot208921432489, label %.sink.split.dup.p9.02610, label %NodeBlock.dup.p6.0

cond_exit_855.dup.p2.0:                           ; preds = %cond_exit_101.route.p1
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %42 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %43 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %44 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %45 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  br label %cond_374_case_1.dup.p1.0

cond_exit_855.dup.p3.0:                           ; preds = %cond_exit_101.route.p1
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %46 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %47 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %48 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %49 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %50 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %51 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %52 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %53 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  %"1370_0.021112435" = select i1 %50, i64 8, i64 0
  %"1408_0.021122436" = select i1 %51, i64 4, i64 0
  %"1446_0.021132437" = select i1 %52, i64 2, i64 0
  %"1484_0.021142438" = zext i1 %53 to i64
  %54 = or i64 %"1408_0.021122436", %"1370_0.021112435"
  %55 = or i64 %54, %"1446_0.021132437"
  %56 = or i64 %55, %"1484_0.021142438"
  %"1282_0.021152439" = zext i1 %52 to i64
  %57 = add i64 %"74_2.02091", %"1282_0.021152439"
  %Pivot208921432483 = icmp slt i64 %57, 1
  br i1 %Pivot208921432483, label %.sink.split.dup.p3.02604, label %NodeBlock.dup.p12.0

cond_exit_855.dup.p4.0:                           ; preds = %cond_exit_101.route.p0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %58 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %59 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %60 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %61 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  br label %cond_374_case_1.dup.p1.0

cond_exit_855.dup.p5.0:                           ; preds = %cond_exit_101.route.p0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %62 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %63 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %64 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %65 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 2 to ptr))
  %66 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 3 to ptr))
  %67 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 3 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 4 to ptr))
  %68 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 4 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 5 to ptr))
  %69 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 5 to ptr))
  %"1370_0.021112425" = select i1 %66, i64 8, i64 0
  %"1408_0.021122426" = select i1 %67, i64 4, i64 0
  %"1446_0.021132427" = select i1 %68, i64 2, i64 0
  %"1484_0.021142428" = zext i1 %69 to i64
  %70 = or i64 %"1408_0.021122426", %"1370_0.021112425"
  %71 = or i64 %70, %"1446_0.021132427"
  %72 = or i64 %71, %"1484_0.021142428"
  %"1282_0.021152429" = zext i1 %68 to i64
  %73 = add i64 %"74_2.02090", %"1282_0.021152429"
  %Pivot208921432485 = icmp slt i64 %73, 1
  br i1 %Pivot208921432485, label %.sink.split.dup.p5.02606, label %NodeBlock.dup.p10.0

cond_exit_855.dup.p7.0:                           ; preds = %alloca_block.dup.1
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  call void @__quantum__qis__mz__body(ptr null, ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__reset__body(ptr null)
  %74 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 6 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 1 to ptr))
  %75 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 2 to ptr), ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 2 to ptr))
  %76 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 3 to ptr), ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__reset__body(ptr inttoptr (i64 3 to ptr))
  %77 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 9 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr null)
  br label %cond_374_case_1.dup.p1.0

bb.dup.p0.02351:                                  ; preds = %LeafBlock.dup.p0.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  %78 = call double @llvm.fabs.f64(double 2.000000e-01)
  %79 = fcmp ueq double %78, 0x7FF0000000000000
  br i1 %79, label %bb, label %cond_949_case_1.dup.p1.02814

cond_949_case_1.dup.p0.0:                         ; preds = %bb.dup.p6.0
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %80 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %81 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FE41B2F769CF0E0, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %82 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p2.0:                         ; preds = %.sink.split.dup.p0.0
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %83 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %84 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FE41B2F769CF0E0, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %85 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p4.0:                         ; preds = %.sink.split.dup.p2.0
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %86 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %87 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FE41B2F769CF0E0, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %88 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

NodeBlock.dup.p6.0:                               ; preds = %cond_exit_855.dup.p1.0
  %Pivot21522519 = icmp slt i64 %41, 2
  br i1 %Pivot21522519, label %.sink.split.dup.p9.0, label %LeafBlock.dup.p9.0

NodeBlock.dup.p7.0:                               ; preds = %cond_exit_855.dup.p0.0
  %Pivot21522520 = icmp slt i64 %29, 2
  br i1 %Pivot21522520, label %.sink.split.dup.p8.0, label %LeafBlock.dup.p8.0

NodeBlock.dup.p10.0:                              ; preds = %cond_exit_855.dup.p5.0
  %Pivot21522523 = icmp slt i64 %73, 2
  br i1 %Pivot21522523, label %.sink.split.dup.p5.0, label %LeafBlock.dup.p5.0

NodeBlock.dup.p12.0:                              ; preds = %cond_exit_855.dup.p3.0
  %Pivot21522525 = icmp slt i64 %57, 2
  br i1 %Pivot21522525, label %.sink.split.dup.p3.02593, label %LeafBlock.dup.p3.0

LeafBlock.dup.p3.0:                               ; preds = %NodeBlock.dup.p12.0
  %SwitchLeaf21622549 = icmp eq i64 %57, 2
  br i1 %SwitchLeaf21622549, label %bb.dup.p3.02718, label %bb.dup.p12.02700

LeafBlock.dup.p5.0:                               ; preds = %NodeBlock.dup.p10.0
  %SwitchLeaf21622551 = icmp eq i64 %73, 2
  br i1 %SwitchLeaf21622551, label %bb.dup.p5.0, label %bb.dup.p10.02698

LeafBlock.dup.p8.0:                               ; preds = %NodeBlock.dup.p7.0
  %SwitchLeaf21622554 = icmp eq i64 %29, 2
  br i1 %SwitchLeaf21622554, label %bb.dup.p8.02722, label %bb.dup.p7.02695

LeafBlock.dup.p9.0:                               ; preds = %NodeBlock.dup.p6.0
  %SwitchLeaf21622555 = icmp eq i64 %41, 2
  br i1 %SwitchLeaf21622555, label %bb.dup.p9.02723, label %bb.dup.p6.02694

.sink.split.dup.p3.02593:                         ; preds = %NodeBlock.dup.p12.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  %89 = call double @llvm.fabs.f64(double 3.000000e-01)
  %90 = fcmp ueq double %89, 0x7FF0000000000000
  br i1 %90, label %bb, label %cond_949_case_1.dup.p3.02768

.sink.split.dup.p5.0:                             ; preds = %NodeBlock.dup.p10.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  %91 = call double @llvm.fabs.f64(double 3.000000e-01)
  %92 = fcmp ueq double %91, 0x7FF0000000000000
  br i1 %92, label %bb, label %cond_949_case_1.dup.p5.02770

.sink.split.dup.p8.0:                             ; preds = %NodeBlock.dup.p7.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  %93 = call double @llvm.fabs.f64(double 6.000000e-01)
  %94 = fcmp ueq double %93, 0x7FF0000000000000
  br i1 %94, label %bb, label %cond_949_case_1.dup.p8.02773

.sink.split.dup.p9.0:                             ; preds = %NodeBlock.dup.p6.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  %95 = call double @llvm.fabs.f64(double 3.000000e-01)
  %96 = fcmp ueq double %95, 0x7FF0000000000000
  br i1 %96, label %bb, label %cond_949_case_1.dup.p9.02774

.sink.split.dup.p3.02604:                         ; preds = %cond_exit_855.dup.p3.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  %97 = call double @llvm.fabs.f64(double 3.000000e-01)
  %98 = fcmp ueq double %97, 0x7FF0000000000000
  br i1 %98, label %bb, label %cond_949_case_1.dup.p3.0

.sink.split.dup.p5.02606:                         ; preds = %cond_exit_855.dup.p5.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  %99 = call double @llvm.fabs.f64(double 3.000000e-01)
  %100 = fcmp ueq double %99, 0x7FF0000000000000
  br i1 %100, label %bb, label %cond_949_case_1.dup.p5.02794

.sink.split.dup.p8.02609:                         ; preds = %cond_exit_855.dup.p0.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  %101 = call double @llvm.fabs.f64(double 6.000000e-01)
  %102 = fcmp ueq double %101, 0x7FF0000000000000
  br i1 %102, label %bb, label %cond_949_case_1.dup.p8.02797

.sink.split.dup.p9.02610:                         ; preds = %cond_exit_855.dup.p1.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  %103 = call double @llvm.fabs.f64(double 3.000000e-01)
  %104 = fcmp ueq double %103, 0x7FF0000000000000
  br i1 %104, label %bb, label %cond_949_case_1.dup.p9.02798

bb.dup.p6.02694:                                  ; preds = %LeafBlock.dup.p9.0
  %105 = call double @llvm.fabs.f64(double 3.000000e-01)
  %106 = fcmp ueq double %105, 0x7FF0000000000000
  br i1 %106, label %bb, label %cond_949_case_1.dup.p9.0

bb.dup.p7.02695:                                  ; preds = %LeafBlock.dup.p8.0
  %107 = call double @llvm.fabs.f64(double 6.000000e-01)
  %108 = fcmp ueq double %107, 0x7FF0000000000000
  br i1 %108, label %bb, label %cond_949_case_1.dup.p8.0

bb.dup.p10.02698:                                 ; preds = %LeafBlock.dup.p5.0
  %109 = call double @llvm.fabs.f64(double 3.000000e-01)
  %110 = fcmp ueq double %109, 0x7FF0000000000000
  br i1 %110, label %bb, label %cond_949_case_1.dup.p5.02755

bb.dup.p12.02700:                                 ; preds = %LeafBlock.dup.p3.0
  %111 = call double @llvm.fabs.f64(double 3.000000e-01)
  %112 = fcmp ueq double %111, 0x7FF0000000000000
  br i1 %112, label %bb, label %cond_949_case_1.dup.p3.02753

bb.dup.p3.02718:                                  ; preds = %LeafBlock.dup.p3.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  %113 = call double @llvm.fabs.f64(double 3.000000e-01)
  %114 = fcmp ueq double %113, 0x7FF0000000000000
  br i1 %114, label %bb, label %cond_949_case_1.dup.p12.02881

bb.dup.p5.0:                                      ; preds = %LeafBlock.dup.p5.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  %115 = call double @llvm.fabs.f64(double 3.000000e-01)
  %116 = fcmp ueq double %115, 0x7FF0000000000000
  br i1 %116, label %bb, label %cond_949_case_1.dup.p10.02879

bb.dup.p8.02722:                                  ; preds = %LeafBlock.dup.p8.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  %117 = call double @llvm.fabs.f64(double 6.000000e-01)
  %118 = fcmp ueq double %117, 0x7FF0000000000000
  br i1 %118, label %bb, label %cond_949_case_1.dup.p7.02876

bb.dup.p9.02723:                                  ; preds = %LeafBlock.dup.p9.0
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 7 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x400921FB54442D18, double 0.000000e+00, ptr inttoptr (i64 6 to ptr))
  %119 = call double @llvm.fabs.f64(double 3.000000e-01)
  %120 = fcmp ueq double %119, 0x7FF0000000000000
  br i1 %120, label %bb, label %cond_949_case_1.dup.p6.0

cond_949_case_1.dup.p3.02753:                     ; preds = %bb.dup.p12.02700
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %121 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %122 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %123 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p5.02755:                     ; preds = %bb.dup.p10.02698
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %124 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %125 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %126 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p8.0:                         ; preds = %bb.dup.p7.02695
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %127 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %128 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FFE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %129 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p9.0:                         ; preds = %bb.dup.p6.02694
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %130 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %131 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %132 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p3.02768:                     ; preds = %.sink.split.dup.p3.02593
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %133 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %134 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %135 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p5.02770:                     ; preds = %.sink.split.dup.p5.0
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %136 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %137 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %138 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p8.02773:                     ; preds = %.sink.split.dup.p8.0
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %139 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %140 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FFE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %141 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p9.02774:                     ; preds = %.sink.split.dup.p9.0
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %142 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %143 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %144 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p3.0:                         ; preds = %.sink.split.dup.p3.02604
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %145 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %146 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %147 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p5.02794:                     ; preds = %.sink.split.dup.p5.02606
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %148 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %149 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %150 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p8.02797:                     ; preds = %.sink.split.dup.p8.02609
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %151 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %152 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FFE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %153 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p9.02798:                     ; preds = %.sink.split.dup.p9.02610
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %154 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %155 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %156 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p1.02814:                     ; preds = %bb.dup.p0.02351
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %157 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %158 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FE41B2F769CF0E0, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %159 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p6.0:                         ; preds = %bb.dup.p9.02723
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %160 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %161 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %162 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p7.02876:                     ; preds = %bb.dup.p8.02722
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %163 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %164 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FFE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %165 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p10.02879:                    ; preds = %bb.dup.p5.0
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %166 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %167 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %168 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final

cond_949_case_1.dup.p12.02881:                    ; preds = %bb.dup.p3.02718
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 6 to ptr), ptr inttoptr (i64 10 to ptr))
  %169 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 10 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 7 to ptr), ptr inttoptr (i64 11 to ptr))
  %170 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 11 to ptr))
  call void @__quantum__qis__phasedx__body(double 0x3FEE28C731EB6950, double 0.000000e+00, ptr inttoptr (i64 8 to ptr))
  call void @__quantum__qis__mz__body(ptr inttoptr (i64 8 to ptr), ptr inttoptr (i64 12 to ptr))
  %171 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 12 to ptr))
  br label %__prepare_module_record_output_final
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
