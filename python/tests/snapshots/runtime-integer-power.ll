; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [12 x i8] c"power___INT\00", align 1
@1 = private unnamed_addr constant [9 x i8] c"q___BOOL\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
  %shot = tail call i64 @___get_current_shot()
  %ipow.set187.not = icmp samesign ult i64 %shot, 2147483648
  %ipow.bit181 = and i64 %shot, 1073741824
  %ipow.set182.not = icmp eq i64 %ipow.bit181, 0
  %ipow.bit176 = and i64 %shot, 536870912
  %ipow.set177.not = icmp eq i64 %ipow.bit176, 0
  %ipow.bit171 = and i64 %shot, 268435456
  %ipow.set172.not = icmp eq i64 %ipow.bit171, 0
  %ipow.bit166 = and i64 %shot, 134217728
  %ipow.set167.not = icmp eq i64 %ipow.bit166, 0
  %ipow.bit161 = and i64 %shot, 67108864
  %ipow.set162.not = icmp eq i64 %ipow.bit161, 0
  %ipow.bit156 = and i64 %shot, 33554432
  %ipow.set157.not = icmp eq i64 %ipow.bit156, 0
  %ipow.bit151 = and i64 %shot, 16777216
  %ipow.set152.not = icmp eq i64 %ipow.bit151, 0
  %ipow.bit146 = and i64 %shot, 8388608
  %ipow.set147.not = icmp eq i64 %ipow.bit146, 0
  %ipow.bit141 = and i64 %shot, 4194304
  %ipow.set142.not = icmp eq i64 %ipow.bit141, 0
  %ipow.bit136 = and i64 %shot, 2097152
  %ipow.set137.not = icmp eq i64 %ipow.bit136, 0
  %ipow.bit131 = and i64 %shot, 1048576
  %ipow.set132.not = icmp eq i64 %ipow.bit131, 0
  %ipow.bit126 = and i64 %shot, 524288
  %ipow.set127.not = icmp eq i64 %ipow.bit126, 0
  %ipow.bit121 = and i64 %shot, 262144
  %ipow.set122.not = icmp eq i64 %ipow.bit121, 0
  %ipow.bit116 = and i64 %shot, 131072
  %ipow.set117.not = icmp eq i64 %ipow.bit116, 0
  %ipow.bit111 = and i64 %shot, 65536
  %ipow.set112.not = icmp eq i64 %ipow.bit111, 0
  %ipow.bit106 = and i64 %shot, 32768
  %ipow.set107.not = icmp eq i64 %ipow.bit106, 0
  %ipow.bit101 = and i64 %shot, 16384
  %ipow.set102.not = icmp eq i64 %ipow.bit101, 0
  %ipow.bit96 = and i64 %shot, 8192
  %ipow.set97.not = icmp eq i64 %ipow.bit96, 0
  %ipow.bit91 = and i64 %shot, 4096
  %ipow.set92.not = icmp eq i64 %ipow.bit91, 0
  %ipow.bit86 = and i64 %shot, 2048
  %ipow.set87.not = icmp eq i64 %ipow.bit86, 0
  %ipow.bit81 = and i64 %shot, 1024
  %ipow.set82.not = icmp eq i64 %ipow.bit81, 0
  %ipow.bit76 = and i64 %shot, 512
  %ipow.set77.not = icmp eq i64 %ipow.bit76, 0
  %ipow.bit71 = and i64 %shot, 256
  %ipow.set72.not = icmp eq i64 %ipow.bit71, 0
  %ipow.bit66 = and i64 %shot, 128
  %ipow.set67.not = icmp eq i64 %ipow.bit66, 0
  %ipow.bit61 = and i64 %shot, 64
  %ipow.set62.not = icmp eq i64 %ipow.bit61, 0
  %ipow.bit56 = and i64 %shot, 32
  %ipow.set57.not = icmp eq i64 %ipow.bit56, 0
  %ipow.bit51 = and i64 %shot, 16
  %ipow.set52.not = icmp eq i64 %ipow.bit51, 0
  %ipow.bit46 = and i64 %shot, 8
  %ipow.set47.not = icmp eq i64 %ipow.bit46, 0
  %ipow.bit41 = and i64 %shot, 4
  %ipow.set42.not = icmp eq i64 %ipow.bit41, 0
  %ipow.bit36 = and i64 %shot, 2
  %ipow.set37.not = icmp eq i64 %ipow.bit36, 0
  %ipow.bit = and i64 %shot, 1
  %ipow.set.not = icmp eq i64 %ipow.bit, 0
  %ipow.accumulator = select i1 %ipow.set.not, i64 1, i64 3
  %ipow.product38 = mul nuw nsw i64 %ipow.accumulator, 9
  %ipow.accumulator39 = select i1 %ipow.set37.not, i64 %ipow.accumulator, i64 %ipow.product38
  %ipow.product43 = mul nuw nsw i64 %ipow.accumulator39, 81
  %ipow.accumulator44 = select i1 %ipow.set42.not, i64 %ipow.accumulator39, i64 %ipow.product43
  %ipow.product48 = mul nuw nsw i64 %ipow.accumulator44, 6561
  %ipow.accumulator49 = select i1 %ipow.set47.not, i64 %ipow.accumulator44, i64 %ipow.product48
  %ipow.product53 = mul nuw nsw i64 %ipow.accumulator49, 43046721
  %ipow.accumulator54 = select i1 %ipow.set52.not, i64 %ipow.accumulator49, i64 %ipow.product53
  %ipow.product58 = mul i64 %ipow.accumulator54, 1853020188851841
  %ipow.accumulator59 = select i1 %ipow.set57.not, i64 %ipow.accumulator54, i64 %ipow.product58
  %ipow.product63 = mul i64 %ipow.accumulator59, 8733086111712066817
  %ipow.accumulator64 = select i1 %ipow.set62.not, i64 %ipow.accumulator59, i64 %ipow.product63
  %ipow.product68 = mul i64 %ipow.accumulator64, -9204772141784466943
  %ipow.accumulator69 = select i1 %ipow.set67.not, i64 %ipow.accumulator64, i64 %ipow.product68
  %ipow.product73 = mul i64 %ipow.accumulator69, -3310041070528564223
  %ipow.accumulator74 = select i1 %ipow.set72.not, i64 %ipow.accumulator69, i64 %ipow.product73
  %ipow.product78 = mul i64 %ipow.accumulator74, 2118395047680534529
  %ipow.accumulator79 = select i1 %ipow.set77.not, i64 %ipow.accumulator74, i64 %ipow.product78
  %ipow.product83 = mul i64 %ipow.accumulator79, -7087363323575676927
  %ipow.accumulator84 = select i1 %ipow.set82.not, i64 %ipow.accumulator79, i64 %ipow.product83
  %ipow.product88 = mul i64 %ipow.accumulator84, 6615629770586038273
  %ipow.accumulator89 = select i1 %ipow.set87.not, i64 %ipow.accumulator84, i64 %ipow.product88
  %ipow.product93 = mul i64 %ipow.accumulator89, -760046494566891519
  %ipow.accumulator94 = select i1 %ipow.set92.not, i64 %ipow.accumulator89, i64 %ipow.product93
  %ipow.product98 = mul i64 %ipow.accumulator94, 3014151301029068801
  %ipow.accumulator99 = select i1 %ipow.set97.not, i64 %ipow.accumulator94, i64 %ipow.product98
  %ipow.product103 = mul i64 %ipow.accumulator99, 2857149036689686529
  %ipow.accumulator104 = select i1 %ipow.set102.not, i64 %ipow.accumulator99, i64 %ipow.product103
  %ipow.product108 = mul i64 %ipow.accumulator104, 1843931970111406081
  %ipow.accumulator109 = select i1 %ipow.set107.not, i64 %ipow.accumulator104, i64 %ipow.product108
  %ipow.product113 = mul i64 %ipow.accumulator109, -5843219465185787903
  %ipow.accumulator114 = select i1 %ipow.set112.not, i64 %ipow.accumulator109, i64 %ipow.product113
  %ipow.product118 = mul i64 %ipow.accumulator114, -2207724490699833343
  %ipow.accumulator119 = select i1 %ipow.set117.not, i64 %ipow.accumulator114, i64 %ipow.product118
  %ipow.product123 = mul i64 %ipow.accumulator119, 8495423646126309377
  %ipow.accumulator124 = select i1 %ipow.set122.not, i64 %ipow.accumulator119, i64 %ipow.product123
  %ipow.product128 = mul i64 %ipow.accumulator124, -2270334730964566015
  %ipow.accumulator129 = select i1 %ipow.set127.not, i64 %ipow.accumulator124, i64 %ipow.product128
  %ipow.product133 = mul i64 %ipow.accumulator129, -3186735241532276735
  %ipow.accumulator134 = select i1 %ipow.set132.not, i64 %ipow.accumulator129, i64 %ipow.product133
  %ipow.product138 = mul i64 %ipow.accumulator134, -957733601477132287
  %ipow.accumulator139 = select i1 %ipow.set137.not, i64 %ipow.accumulator134, i64 %ipow.product138
  %ipow.product143 = mul i64 %ipow.accumulator139, 1300736249685868545
  %ipow.accumulator144 = select i1 %ipow.set142.not, i64 %ipow.accumulator139, i64 %ipow.product143
  %ipow.product148 = mul i64 %ipow.accumulator144, -2980457763777282047
  %ipow.accumulator149 = select i1 %ipow.set147.not, i64 %ipow.accumulator144, i64 %ipow.product148
  %ipow.product153 = mul i64 %ipow.accumulator149, 8604851567268462593
  %ipow.accumulator154 = select i1 %ipow.set152.not, i64 %ipow.accumulator149, i64 %ipow.product153
  %ipow.product158 = mul i64 %ipow.accumulator154, 1685795218990825473
  %ipow.accumulator159 = select i1 %ipow.set157.not, i64 %ipow.accumulator154, i64 %ipow.product158
  %ipow.product163 = mul i64 %ipow.accumulator159, -3383809003074093055
  %ipow.accumulator164 = select i1 %ipow.set162.not, i64 %ipow.accumulator159, i64 %ipow.product163
  %ipow.product168 = mul i64 %ipow.accumulator164, 3104272377047941121
  %ipow.accumulator169 = select i1 %ipow.set167.not, i64 %ipow.accumulator164, i64 %ipow.product168
  %ipow.product173 = mul i64 %ipow.accumulator169, 8802618139461287937
  %ipow.accumulator174 = select i1 %ipow.set172.not, i64 %ipow.accumulator169, i64 %ipow.product173
  %ipow.product178 = mul i64 %ipow.accumulator174, -8911958327034904575
  %ipow.accumulator179 = select i1 %ipow.set177.not, i64 %ipow.accumulator174, i64 %ipow.product178
  %ipow.product183 = mul i64 %ipow.accumulator179, 5234513438067130369
  %ipow.accumulator184 = select i1 %ipow.set182.not, i64 %ipow.accumulator179, i64 %ipow.product183
  %ipow.product188 = mul i64 %ipow.accumulator184, -7977717197575290879
  %ipow.accumulator189 = select i1 %ipow.set187.not, i64 %ipow.accumulator184, i64 %ipow.product188
  tail call void @__quantum__qis__mz__body(ptr null, ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__rt__int_record_output(i64 %ipow.accumulator189, ptr nonnull @0)
  tail call void @__quantum__rt__bool_record_output(i1 %0, ptr nonnull @1)
  ret void
}

declare noundef range(i64 0, 4294967296) i64 @___get_current_shot() local_unnamed_addr

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) local_unnamed_addr #1

declare i1 @__quantum__rt__read_result(ptr readonly) local_unnamed_addr

declare void @__quantum__rt__int_record_output(i64, ptr) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, ptr) local_unnamed_addr

declare void @__quantum__rt__initialize(ptr) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="1" "required_num_results"="1" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
