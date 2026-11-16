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
  %ipow.bit = and i64 %shot, 1
  %ipow.set.not = icmp eq i64 %ipow.bit, 0
  %ipow.accumulator = select i1 %ipow.set.not, i64 1, i64 3
  %ipow.bit59 = and i64 %shot, 2
  %ipow.set60.not = icmp eq i64 %ipow.bit59, 0
  %ipow.product = mul nuw nsw i64 %ipow.accumulator, 9
  %ipow.accumulator61 = select i1 %ipow.set60.not, i64 %ipow.accumulator, i64 %ipow.product
  %ipow.bit62 = and i64 %shot, 4
  %ipow.set63.not = icmp eq i64 %ipow.bit62, 0
  %ipow.product64 = mul nuw nsw i64 %ipow.accumulator61, 81
  %ipow.accumulator65 = select i1 %ipow.set63.not, i64 %ipow.accumulator61, i64 %ipow.product64
  %ipow.bit66 = and i64 %shot, 8
  %ipow.set67.not = icmp eq i64 %ipow.bit66, 0
  %ipow.product68 = mul nuw nsw i64 %ipow.accumulator65, 6561
  %ipow.accumulator69 = select i1 %ipow.set67.not, i64 %ipow.accumulator65, i64 %ipow.product68
  %ipow.bit70 = and i64 %shot, 16
  %ipow.set71.not = icmp eq i64 %ipow.bit70, 0
  %ipow.product72 = mul nuw nsw i64 %ipow.accumulator69, 43046721
  %ipow.accumulator73 = select i1 %ipow.set71.not, i64 %ipow.accumulator69, i64 %ipow.product72
  %ipow.bit74 = and i64 %shot, 32
  %ipow.set75.not = icmp eq i64 %ipow.bit74, 0
  %ipow.product76 = mul i64 %ipow.accumulator73, 1853020188851841
  %ipow.accumulator77 = select i1 %ipow.set75.not, i64 %ipow.accumulator73, i64 %ipow.product76
  %ipow.bit78 = and i64 %shot, 64
  %ipow.set79.not = icmp eq i64 %ipow.bit78, 0
  %ipow.product80 = mul i64 %ipow.accumulator77, 8733086111712066817
  %ipow.accumulator81 = select i1 %ipow.set79.not, i64 %ipow.accumulator77, i64 %ipow.product80
  %ipow.bit82 = and i64 %shot, 128
  %ipow.set83.not = icmp eq i64 %ipow.bit82, 0
  %ipow.product84 = mul i64 %ipow.accumulator81, -9204772141784466943
  %ipow.accumulator85 = select i1 %ipow.set83.not, i64 %ipow.accumulator81, i64 %ipow.product84
  %ipow.bit86 = and i64 %shot, 256
  %ipow.set87.not = icmp eq i64 %ipow.bit86, 0
  %ipow.product88 = mul i64 %ipow.accumulator85, -3310041070528564223
  %ipow.accumulator89 = select i1 %ipow.set87.not, i64 %ipow.accumulator85, i64 %ipow.product88
  %ipow.bit90 = and i64 %shot, 512
  %ipow.set91.not = icmp eq i64 %ipow.bit90, 0
  %ipow.product92 = mul i64 %ipow.accumulator89, 2118395047680534529
  %ipow.accumulator93 = select i1 %ipow.set91.not, i64 %ipow.accumulator89, i64 %ipow.product92
  %ipow.bit94 = and i64 %shot, 1024
  %ipow.set95.not = icmp eq i64 %ipow.bit94, 0
  %ipow.product96 = mul i64 %ipow.accumulator93, -7087363323575676927
  %ipow.accumulator97 = select i1 %ipow.set95.not, i64 %ipow.accumulator93, i64 %ipow.product96
  %ipow.bit98 = and i64 %shot, 2048
  %ipow.set99.not = icmp eq i64 %ipow.bit98, 0
  %ipow.product100 = mul i64 %ipow.accumulator97, 6615629770586038273
  %ipow.accumulator101 = select i1 %ipow.set99.not, i64 %ipow.accumulator97, i64 %ipow.product100
  %ipow.bit102 = and i64 %shot, 4096
  %ipow.set103.not = icmp eq i64 %ipow.bit102, 0
  %ipow.product104 = mul i64 %ipow.accumulator101, -760046494566891519
  %ipow.accumulator105 = select i1 %ipow.set103.not, i64 %ipow.accumulator101, i64 %ipow.product104
  %ipow.bit106 = and i64 %shot, 8192
  %ipow.set107.not = icmp eq i64 %ipow.bit106, 0
  %ipow.product108 = mul i64 %ipow.accumulator105, 3014151301029068801
  %ipow.accumulator109 = select i1 %ipow.set107.not, i64 %ipow.accumulator105, i64 %ipow.product108
  %ipow.bit110 = and i64 %shot, 16384
  %ipow.set111.not = icmp eq i64 %ipow.bit110, 0
  %ipow.product112 = mul i64 %ipow.accumulator109, 2857149036689686529
  %ipow.accumulator113 = select i1 %ipow.set111.not, i64 %ipow.accumulator109, i64 %ipow.product112
  %ipow.bit114 = and i64 %shot, 32768
  %ipow.set115.not = icmp eq i64 %ipow.bit114, 0
  %ipow.product116 = mul i64 %ipow.accumulator113, 1843931970111406081
  %ipow.accumulator117 = select i1 %ipow.set115.not, i64 %ipow.accumulator113, i64 %ipow.product116
  %ipow.bit118 = and i64 %shot, 65536
  %ipow.set119.not = icmp eq i64 %ipow.bit118, 0
  %ipow.product120 = mul i64 %ipow.accumulator117, -5843219465185787903
  %ipow.accumulator121 = select i1 %ipow.set119.not, i64 %ipow.accumulator117, i64 %ipow.product120
  %ipow.bit122 = and i64 %shot, 131072
  %ipow.set123.not = icmp eq i64 %ipow.bit122, 0
  %ipow.product124 = mul i64 %ipow.accumulator121, -2207724490699833343
  %ipow.accumulator125 = select i1 %ipow.set123.not, i64 %ipow.accumulator121, i64 %ipow.product124
  %ipow.bit126 = and i64 %shot, 262144
  %ipow.set127.not = icmp eq i64 %ipow.bit126, 0
  %ipow.product128 = mul i64 %ipow.accumulator125, 8495423646126309377
  %ipow.accumulator129 = select i1 %ipow.set127.not, i64 %ipow.accumulator125, i64 %ipow.product128
  %ipow.bit130 = and i64 %shot, 524288
  %ipow.set131.not = icmp eq i64 %ipow.bit130, 0
  %ipow.product132 = mul i64 %ipow.accumulator129, -2270334730964566015
  %ipow.accumulator133 = select i1 %ipow.set131.not, i64 %ipow.accumulator129, i64 %ipow.product132
  %ipow.bit134 = and i64 %shot, 1048576
  %ipow.set135.not = icmp eq i64 %ipow.bit134, 0
  %ipow.product136 = mul i64 %ipow.accumulator133, -3186735241532276735
  %ipow.accumulator137 = select i1 %ipow.set135.not, i64 %ipow.accumulator133, i64 %ipow.product136
  %ipow.bit138 = and i64 %shot, 2097152
  %ipow.set139.not = icmp eq i64 %ipow.bit138, 0
  %ipow.product140 = mul i64 %ipow.accumulator137, -957733601477132287
  %ipow.accumulator141 = select i1 %ipow.set139.not, i64 %ipow.accumulator137, i64 %ipow.product140
  %ipow.bit142 = and i64 %shot, 4194304
  %ipow.set143.not = icmp eq i64 %ipow.bit142, 0
  %ipow.product144 = mul i64 %ipow.accumulator141, 1300736249685868545
  %ipow.accumulator145 = select i1 %ipow.set143.not, i64 %ipow.accumulator141, i64 %ipow.product144
  %ipow.bit146 = and i64 %shot, 8388608
  %ipow.set147.not = icmp eq i64 %ipow.bit146, 0
  %ipow.product148 = mul i64 %ipow.accumulator145, -2980457763777282047
  %ipow.accumulator149 = select i1 %ipow.set147.not, i64 %ipow.accumulator145, i64 %ipow.product148
  %ipow.bit150 = and i64 %shot, 16777216
  %ipow.set151.not = icmp eq i64 %ipow.bit150, 0
  %ipow.product152 = mul i64 %ipow.accumulator149, 8604851567268462593
  %ipow.accumulator153 = select i1 %ipow.set151.not, i64 %ipow.accumulator149, i64 %ipow.product152
  %ipow.bit154 = and i64 %shot, 33554432
  %ipow.set155.not = icmp eq i64 %ipow.bit154, 0
  %ipow.product156 = mul i64 %ipow.accumulator153, 1685795218990825473
  %ipow.accumulator157 = select i1 %ipow.set155.not, i64 %ipow.accumulator153, i64 %ipow.product156
  %ipow.bit158 = and i64 %shot, 67108864
  %ipow.set159.not = icmp eq i64 %ipow.bit158, 0
  %ipow.product160 = mul i64 %ipow.accumulator157, -3383809003074093055
  %ipow.accumulator161 = select i1 %ipow.set159.not, i64 %ipow.accumulator157, i64 %ipow.product160
  %ipow.bit162 = and i64 %shot, 134217728
  %ipow.set163.not = icmp eq i64 %ipow.bit162, 0
  %ipow.product164 = mul i64 %ipow.accumulator161, 3104272377047941121
  %ipow.accumulator165 = select i1 %ipow.set163.not, i64 %ipow.accumulator161, i64 %ipow.product164
  %ipow.bit166 = and i64 %shot, 268435456
  %ipow.set167.not = icmp eq i64 %ipow.bit166, 0
  %ipow.product168 = mul i64 %ipow.accumulator165, 8802618139461287937
  %ipow.accumulator169 = select i1 %ipow.set167.not, i64 %ipow.accumulator165, i64 %ipow.product168
  %ipow.bit170 = and i64 %shot, 536870912
  %ipow.set171.not = icmp eq i64 %ipow.bit170, 0
  %ipow.product172 = mul i64 %ipow.accumulator169, -8911958327034904575
  %ipow.accumulator173 = select i1 %ipow.set171.not, i64 %ipow.accumulator169, i64 %ipow.product172
  %ipow.bit174 = and i64 %shot, 1073741824
  %ipow.set175.not = icmp eq i64 %ipow.bit174, 0
  %ipow.product176 = mul i64 %ipow.accumulator173, 5234513438067130369
  %ipow.accumulator177 = select i1 %ipow.set175.not, i64 %ipow.accumulator173, i64 %ipow.product176
  %ipow.set179.not = icmp samesign ult i64 %shot, 2147483648
  %ipow.product180 = mul i64 %ipow.accumulator177, -7977717197575290879
  %ipow.accumulator181 = select i1 %ipow.set179.not, i64 %ipow.accumulator177, i64 %ipow.product180
  tail call void @__quantum__rt__int_record_output(i64 %ipow.accumulator181, ptr nonnull @0)
  tail call void @__quantum__qis__mz__body(ptr null, ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__rt__bool_record_output(i1 %0, ptr nonnull @1)
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
