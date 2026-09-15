; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [24 x i8] c"quotient_positive___INT\00", align 1
@1 = private unnamed_addr constant [25 x i8] c"remainder_positive___INT\00", align 1
@2 = private unnamed_addr constant [9 x i8] c"q___BOOL\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
  %shot = tail call i64 @___get_current_shot()
  %0 = add nsw i64 %shot, -5
  %is_dividend_negative = icmp samesign ult i64 %shot, 5
  %sdiv.is_min = icmp eq i64 %0, -9223372036854775808
  %sdiv.is_negative = icmp slt i64 %0, 0
  %sdiv.negated = sub i64 0, %0
  %sdiv.magnitude = select i1 %sdiv.is_negative, i64 %sdiv.negated, i64 %0
  %sdiv.safe_magnitude = select i1 %sdiv.is_min, i64 0, i64 %sdiv.magnitude
  %sdiv.quotient = udiv i64 %sdiv.safe_magnitude, 3
  %sdiv.negated_quotient = sub i64 0, %sdiv.quotient
  %sdiv.signed = select i1 %sdiv.is_negative, i64 %sdiv.negated_quotient, i64 %sdiv.quotient
  %sdiv.lowered = select i1 %sdiv.is_min, i64 -3074457345618258602, i64 %sdiv.signed
  %.neg = mul nsw i64 %sdiv.lowered, -3
  %remainder.decomposed = add nsw i64 %.neg, %0
  br i1 %is_dividend_negative, label %negative_smoldiv20, label %finish18

negative_smoldiv20:                               ; preds = %alloca_block
  %1 = add nsw i64 %remainder.decomposed, 3
  %is_rem_0.not = icmp eq i64 %remainder.decomposed, 0
  %.elt44 = select i1 %is_rem_0.not, i64 0, i64 %1
  %is_rem_023 = icmp ne i64 %remainder.decomposed, 0
  %2 = sext i1 %is_rem_023 to i64
  %.elt51 = add nsw i64 %sdiv.lowered, %2
  br label %finish18

finish18:                                         ; preds = %alloca_block, %negative_smoldiv20
  %result24.unpack = phi i64 [ %.elt51, %negative_smoldiv20 ], [ %sdiv.lowered, %alloca_block ]
  %result.sroa.2.061 = phi i64 [ %.elt44, %negative_smoldiv20 ], [ %remainder.decomposed, %alloca_block ]
  tail call void @__quantum__rt__int_record_output(i64 %result24.unpack, ptr nonnull @0)
  tail call void @__quantum__rt__int_record_output(i64 %result.sroa.2.061, ptr nonnull @1)
  tail call void @__quantum__qis__mz__body(ptr null, ptr null)
  %3 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__rt__bool_record_output(i1 %3, ptr nonnull @2)
  ret void
}

declare noundef range(i64 0, 4294967296) i64 @___get_current_shot() local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, ptr) local_unnamed_addr

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="1" "required_num_results"="1" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
