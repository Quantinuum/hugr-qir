; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@"sa.static_pyarray.%tmp10.55edf32.0" = local_unnamed_addr constant { i64, [121 x { i64, i64 }] } { i64 121, [121 x { i64, i64 }] [{ i64, i64 } zeroinitializer, { i64, i64 } { i64 0, i64 1 }, { i64, i64 } { i64 0, i64 2 }, { i64, i64 } { i64 0, i64 3 }, { i64, i64 } { i64 0, i64 4 }, { i64, i64 } { i64 0, i64 5 }, { i64, i64 } { i64 0, i64 6 }, { i64, i64 } { i64 0, i64 7 }, { i64, i64 } { i64 0, i64 8 }, { i64, i64 } { i64 0, i64 9 }, { i64, i64 } { i64 0, i64 10 }, { i64, i64 } { i64 1, i64 1 }, { i64, i64 } { i64 1, i64 2 }, { i64, i64 } { i64 1, i64 3 }, { i64, i64 } { i64 1, i64 4 }, { i64, i64 } { i64 1, i64 5 }, { i64, i64 } { i64 1, i64 6 }, { i64, i64 } { i64 1, i64 7 }, { i64, i64 } { i64 1, i64 8 }, { i64, i64 } { i64 1, i64 9 }, { i64, i64 } { i64 1, i64 10 }, { i64, i64 } { i64 2, i64 2 }, { i64, i64 } { i64 2, i64 3 }, { i64, i64 } { i64 2, i64 4 }, { i64, i64 } { i64 2, i64 5 }, { i64, i64 } { i64 2, i64 6 }, { i64, i64 } { i64 2, i64 7 }, { i64, i64 } { i64 2, i64 8 }, { i64, i64 } { i64 2, i64 9 }, { i64, i64 } { i64 2, i64 10 }, { i64, i64 } { i64 3, i64 3 }, { i64, i64 } { i64 3, i64 4 }, { i64, i64 } { i64 3, i64 5 }, { i64, i64 } { i64 3, i64 6 }, { i64, i64 } { i64 3, i64 7 }, { i64, i64 } { i64 3, i64 8 }, { i64, i64 } { i64 3, i64 9 }, { i64, i64 } { i64 3, i64 10 }, { i64, i64 } { i64 4, i64 4 }, { i64, i64 } { i64 4, i64 5 }, { i64, i64 } { i64 4, i64 6 }, { i64, i64 } { i64 4, i64 7 }, { i64, i64 } { i64 4, i64 8 }, { i64, i64 } { i64 4, i64 9 }, { i64, i64 } { i64 4, i64 10 }, { i64, i64 } { i64 5, i64 5 }, { i64, i64 } { i64 5, i64 6 }, { i64, i64 } { i64 5, i64 7 }, { i64, i64 } { i64 5, i64 8 }, { i64, i64 } { i64 5, i64 9 }, { i64, i64 } { i64 5, i64 10 }, { i64, i64 } { i64 6, i64 6 }, { i64, i64 } { i64 6, i64 7 }, { i64, i64 } { i64 6, i64 8 }, { i64, i64 } { i64 6, i64 9 }, { i64, i64 } { i64 6, i64 10 }, { i64, i64 } { i64 7, i64 7 }, { i64, i64 } { i64 7, i64 8 }, { i64, i64 } { i64 7, i64 9 }, { i64, i64 } { i64 7, i64 10 }, { i64, i64 } { i64 8, i64 8 }, { i64, i64 } { i64 8, i64 9 }, { i64, i64 } { i64 8, i64 10 }, { i64, i64 } { i64 9, i64 9 }, { i64, i64 } { i64 9, i64 10 }, { i64, i64 } { i64 10, i64 10 }, { i64, i64 } { i64 -1, i64 1 }, { i64, i64 } { i64 -1, i64 2 }, { i64, i64 } { i64 -1, i64 3 }, { i64, i64 } { i64 -1, i64 4 }, { i64, i64 } { i64 -1, i64 5 }, { i64, i64 } { i64 -1, i64 6 }, { i64, i64 } { i64 -1, i64 7 }, { i64, i64 } { i64 -1, i64 8 }, { i64, i64 } { i64 -1, i64 9 }, { i64, i64 } { i64 -1, i64 10 }, { i64, i64 } { i64 -2, i64 2 }, { i64, i64 } { i64 -2, i64 3 }, { i64, i64 } { i64 -2, i64 4 }, { i64, i64 } { i64 -2, i64 5 }, { i64, i64 } { i64 -2, i64 6 }, { i64, i64 } { i64 -2, i64 7 }, { i64, i64 } { i64 -2, i64 8 }, { i64, i64 } { i64 -2, i64 9 }, { i64, i64 } { i64 -2, i64 10 }, { i64, i64 } { i64 -3, i64 3 }, { i64, i64 } { i64 -3, i64 4 }, { i64, i64 } { i64 -3, i64 5 }, { i64, i64 } { i64 -3, i64 6 }, { i64, i64 } { i64 -3, i64 7 }, { i64, i64 } { i64 -3, i64 8 }, { i64, i64 } { i64 -3, i64 9 }, { i64, i64 } { i64 -3, i64 10 }, { i64, i64 } { i64 -4, i64 4 }, { i64, i64 } { i64 -4, i64 5 }, { i64, i64 } { i64 -4, i64 6 }, { i64, i64 } { i64 -4, i64 7 }, { i64, i64 } { i64 -4, i64 8 }, { i64, i64 } { i64 -4, i64 9 }, { i64, i64 } { i64 -4, i64 10 }, { i64, i64 } { i64 -5, i64 5 }, { i64, i64 } { i64 -5, i64 6 }, { i64, i64 } { i64 -5, i64 7 }, { i64, i64 } { i64 -5, i64 8 }, { i64, i64 } { i64 -5, i64 9 }, { i64, i64 } { i64 -5, i64 10 }, { i64, i64 } { i64 -6, i64 6 }, { i64, i64 } { i64 -6, i64 7 }, { i64, i64 } { i64 -6, i64 8 }, { i64, i64 } { i64 -6, i64 9 }, { i64, i64 } { i64 -6, i64 10 }, { i64, i64 } { i64 -7, i64 7 }, { i64, i64 } { i64 -7, i64 8 }, { i64, i64 } { i64 -7, i64 9 }, { i64, i64 } { i64 -7, i64 10 }, { i64, i64 } { i64 -8, i64 8 }, { i64, i64 } { i64 -8, i64 9 }, { i64, i64 } { i64 -8, i64 10 }, { i64, i64 } { i64 -9, i64 9 }, { i64, i64 } { i64 -9, i64 10 }, { i64, i64 } { i64 -10, i64 10 }] }
@"sa.static_pyarray.%tmp14.5887edc6.0" = local_unnamed_addr constant { i64, [121 x i64] } { i64 121, [121 x i64] [i64 1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 4, i64 8, i64 16, i64 32, i64 64, i64 128, i64 256, i64 512, i64 1024, i64 27, i64 81, i64 243, i64 729, i64 2187, i64 6561, i64 19683, i64 59049, i64 256, i64 1024, i64 4096, i64 16384, i64 65536, i64 262144, i64 1048576, i64 3125, i64 15625, i64 78125, i64 390625, i64 1953125, i64 9765625, i64 46656, i64 279936, i64 1679616, i64 10077696, i64 60466176, i64 823543, i64 5764801, i64 40353607, i64 282475249, i64 16777216, i64 134217728, i64 1073741824, i64 387420489, i64 3486784401, i64 10000000000, i64 -1, i64 1, i64 -1, i64 1, i64 -1, i64 1, i64 -1, i64 1, i64 -1, i64 1, i64 4, i64 -8, i64 16, i64 -32, i64 64, i64 -128, i64 256, i64 -512, i64 1024, i64 -27, i64 81, i64 -243, i64 729, i64 -2187, i64 6561, i64 -19683, i64 59049, i64 256, i64 -1024, i64 4096, i64 -16384, i64 65536, i64 -262144, i64 1048576, i64 -3125, i64 15625, i64 -78125, i64 390625, i64 -1953125, i64 9765625, i64 46656, i64 -279936, i64 1679616, i64 -10077696, i64 60466176, i64 -823543, i64 5764801, i64 -40353607, i64 282475249, i64 16777216, i64 -134217728, i64 1073741824, i64 -387420489, i64 3486784401, i64 10000000000] }
@0 = private unnamed_addr constant [16 x i8] c"ints___ARRINT_0\00", align 1
@1 = private unnamed_addr constant [16 x i8] c"ints___ARRINT_1\00", align 1
@2 = private unnamed_addr constant [16 x i8] c"ints___ARRINT_2\00", align 1
@3 = private unnamed_addr constant [16 x i8] c"ints___ARRINT_3\00", align 1
@4 = private unnamed_addr constant [16 x i8] c"ints___ARRINT_4\00", align 1
@5 = private unnamed_addr constant [16 x i8] c"ints___ARRINT_5\00", align 1
@6 = private unnamed_addr constant [16 x i8] c"ints___ARRINT_6\00", align 1
@7 = private unnamed_addr constant [16 x i8] c"ints___ARRINT_7\00", align 1
@8 = private unnamed_addr constant [16 x i8] c"ints___ARRINT_8\00", align 1
@9 = private unnamed_addr constant [16 x i8] c"ints___ARRINT_9\00", align 1
@10 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_10\00", align 1
@11 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_11\00", align 1
@12 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_12\00", align 1
@13 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_13\00", align 1
@14 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_14\00", align 1
@15 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_15\00", align 1
@16 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_16\00", align 1
@17 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_17\00", align 1
@18 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_18\00", align 1
@19 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_19\00", align 1
@20 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_20\00", align 1
@21 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_21\00", align 1
@22 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_22\00", align 1
@23 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_23\00", align 1
@24 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_24\00", align 1
@25 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_25\00", align 1
@26 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_26\00", align 1
@27 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_27\00", align 1
@28 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_28\00", align 1
@29 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_29\00", align 1
@30 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_30\00", align 1
@31 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_31\00", align 1
@32 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_32\00", align 1
@33 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_33\00", align 1
@34 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_34\00", align 1
@35 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_35\00", align 1
@36 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_36\00", align 1
@37 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_37\00", align 1
@38 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_38\00", align 1
@39 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_39\00", align 1
@40 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_40\00", align 1
@41 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_41\00", align 1
@42 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_42\00", align 1
@43 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_43\00", align 1
@44 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_44\00", align 1
@45 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_45\00", align 1
@46 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_46\00", align 1
@47 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_47\00", align 1
@48 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_48\00", align 1
@49 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_49\00", align 1
@50 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_50\00", align 1
@51 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_51\00", align 1
@52 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_52\00", align 1
@53 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_53\00", align 1
@54 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_54\00", align 1
@55 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_55\00", align 1
@56 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_56\00", align 1
@57 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_57\00", align 1
@58 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_58\00", align 1
@59 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_59\00", align 1
@60 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_60\00", align 1
@61 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_61\00", align 1
@62 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_62\00", align 1
@63 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_63\00", align 1
@64 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_64\00", align 1
@65 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_65\00", align 1
@66 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_66\00", align 1
@67 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_67\00", align 1
@68 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_68\00", align 1
@69 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_69\00", align 1
@70 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_70\00", align 1
@71 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_71\00", align 1
@72 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_72\00", align 1
@73 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_73\00", align 1
@74 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_74\00", align 1
@75 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_75\00", align 1
@76 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_76\00", align 1
@77 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_77\00", align 1
@78 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_78\00", align 1
@79 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_79\00", align 1
@80 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_80\00", align 1
@81 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_81\00", align 1
@82 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_82\00", align 1
@83 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_83\00", align 1
@84 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_84\00", align 1
@85 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_85\00", align 1
@86 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_86\00", align 1
@87 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_87\00", align 1
@88 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_88\00", align 1
@89 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_89\00", align 1
@90 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_90\00", align 1
@91 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_91\00", align 1
@92 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_92\00", align 1
@93 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_93\00", align 1
@94 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_94\00", align 1
@95 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_95\00", align 1
@96 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_96\00", align 1
@97 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_97\00", align 1
@98 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_98\00", align 1
@99 = private unnamed_addr constant [17 x i8] c"ints___ARRINT_99\00", align 1
@100 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_100\00", align 1
@101 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_101\00", align 1
@102 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_102\00", align 1
@103 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_103\00", align 1
@104 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_104\00", align 1
@105 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_105\00", align 1
@106 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_106\00", align 1
@107 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_107\00", align 1
@108 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_108\00", align 1
@109 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_109\00", align 1
@110 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_110\00", align 1
@111 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_111\00", align 1
@112 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_112\00", align 1
@113 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_113\00", align 1
@114 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_114\00", align 1
@115 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_115\00", align 1
@116 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_116\00", align 1
@117 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_117\00", align 1
@118 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_118\00", align 1
@119 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_119\00", align 1
@120 = private unnamed_addr constant [18 x i8] c"ints___ARRINT_120\00", align 1
@121 = private unnamed_addr constant [9 x i8] c"q___BOOL\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.guppy_example_mod.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__rt__initialize(ptr null)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @0)
  tail call void @__quantum__rt__int_record_output(i64 0, ptr nonnull @1)
  tail call void @__quantum__rt__int_record_output(i64 0, ptr nonnull @2)
  tail call void @__quantum__rt__int_record_output(i64 0, ptr nonnull @3)
  tail call void @__quantum__rt__int_record_output(i64 0, ptr nonnull @4)
  tail call void @__quantum__rt__int_record_output(i64 0, ptr nonnull @5)
  tail call void @__quantum__rt__int_record_output(i64 0, ptr nonnull @6)
  tail call void @__quantum__rt__int_record_output(i64 0, ptr nonnull @7)
  tail call void @__quantum__rt__int_record_output(i64 0, ptr nonnull @8)
  tail call void @__quantum__rt__int_record_output(i64 0, ptr nonnull @9)
  tail call void @__quantum__rt__int_record_output(i64 0, ptr nonnull @10)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @11)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @12)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @13)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @14)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @15)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @16)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @17)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @18)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @19)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @20)
  tail call void @__quantum__rt__int_record_output(i64 4, ptr nonnull @21)
  tail call void @__quantum__rt__int_record_output(i64 8, ptr nonnull @22)
  tail call void @__quantum__rt__int_record_output(i64 16, ptr nonnull @23)
  tail call void @__quantum__rt__int_record_output(i64 32, ptr nonnull @24)
  tail call void @__quantum__rt__int_record_output(i64 64, ptr nonnull @25)
  tail call void @__quantum__rt__int_record_output(i64 128, ptr nonnull @26)
  tail call void @__quantum__rt__int_record_output(i64 256, ptr nonnull @27)
  tail call void @__quantum__rt__int_record_output(i64 512, ptr nonnull @28)
  tail call void @__quantum__rt__int_record_output(i64 1024, ptr nonnull @29)
  tail call void @__quantum__rt__int_record_output(i64 27, ptr nonnull @30)
  tail call void @__quantum__rt__int_record_output(i64 81, ptr nonnull @31)
  tail call void @__quantum__rt__int_record_output(i64 243, ptr nonnull @32)
  tail call void @__quantum__rt__int_record_output(i64 729, ptr nonnull @33)
  tail call void @__quantum__rt__int_record_output(i64 2187, ptr nonnull @34)
  tail call void @__quantum__rt__int_record_output(i64 6561, ptr nonnull @35)
  tail call void @__quantum__rt__int_record_output(i64 19683, ptr nonnull @36)
  tail call void @__quantum__rt__int_record_output(i64 59049, ptr nonnull @37)
  tail call void @__quantum__rt__int_record_output(i64 256, ptr nonnull @38)
  tail call void @__quantum__rt__int_record_output(i64 1024, ptr nonnull @39)
  tail call void @__quantum__rt__int_record_output(i64 4096, ptr nonnull @40)
  tail call void @__quantum__rt__int_record_output(i64 16384, ptr nonnull @41)
  tail call void @__quantum__rt__int_record_output(i64 65536, ptr nonnull @42)
  tail call void @__quantum__rt__int_record_output(i64 262144, ptr nonnull @43)
  tail call void @__quantum__rt__int_record_output(i64 1048576, ptr nonnull @44)
  tail call void @__quantum__rt__int_record_output(i64 3125, ptr nonnull @45)
  tail call void @__quantum__rt__int_record_output(i64 15625, ptr nonnull @46)
  tail call void @__quantum__rt__int_record_output(i64 78125, ptr nonnull @47)
  tail call void @__quantum__rt__int_record_output(i64 390625, ptr nonnull @48)
  tail call void @__quantum__rt__int_record_output(i64 1953125, ptr nonnull @49)
  tail call void @__quantum__rt__int_record_output(i64 9765625, ptr nonnull @50)
  tail call void @__quantum__rt__int_record_output(i64 46656, ptr nonnull @51)
  tail call void @__quantum__rt__int_record_output(i64 279936, ptr nonnull @52)
  tail call void @__quantum__rt__int_record_output(i64 1679616, ptr nonnull @53)
  tail call void @__quantum__rt__int_record_output(i64 10077696, ptr nonnull @54)
  tail call void @__quantum__rt__int_record_output(i64 60466176, ptr nonnull @55)
  tail call void @__quantum__rt__int_record_output(i64 823543, ptr nonnull @56)
  tail call void @__quantum__rt__int_record_output(i64 5764801, ptr nonnull @57)
  tail call void @__quantum__rt__int_record_output(i64 40353607, ptr nonnull @58)
  tail call void @__quantum__rt__int_record_output(i64 282475249, ptr nonnull @59)
  tail call void @__quantum__rt__int_record_output(i64 16777216, ptr nonnull @60)
  tail call void @__quantum__rt__int_record_output(i64 134217728, ptr nonnull @61)
  tail call void @__quantum__rt__int_record_output(i64 1073741824, ptr nonnull @62)
  tail call void @__quantum__rt__int_record_output(i64 387420489, ptr nonnull @63)
  tail call void @__quantum__rt__int_record_output(i64 3486784401, ptr nonnull @64)
  tail call void @__quantum__rt__int_record_output(i64 10000000000, ptr nonnull @65)
  tail call void @__quantum__rt__int_record_output(i64 -1, ptr nonnull @66)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @67)
  tail call void @__quantum__rt__int_record_output(i64 -1, ptr nonnull @68)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @69)
  tail call void @__quantum__rt__int_record_output(i64 -1, ptr nonnull @70)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @71)
  tail call void @__quantum__rt__int_record_output(i64 -1, ptr nonnull @72)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @73)
  tail call void @__quantum__rt__int_record_output(i64 -1, ptr nonnull @74)
  tail call void @__quantum__rt__int_record_output(i64 1, ptr nonnull @75)
  tail call void @__quantum__rt__int_record_output(i64 4, ptr nonnull @76)
  tail call void @__quantum__rt__int_record_output(i64 -8, ptr nonnull @77)
  tail call void @__quantum__rt__int_record_output(i64 16, ptr nonnull @78)
  tail call void @__quantum__rt__int_record_output(i64 -32, ptr nonnull @79)
  tail call void @__quantum__rt__int_record_output(i64 64, ptr nonnull @80)
  tail call void @__quantum__rt__int_record_output(i64 -128, ptr nonnull @81)
  tail call void @__quantum__rt__int_record_output(i64 256, ptr nonnull @82)
  tail call void @__quantum__rt__int_record_output(i64 -512, ptr nonnull @83)
  tail call void @__quantum__rt__int_record_output(i64 1024, ptr nonnull @84)
  tail call void @__quantum__rt__int_record_output(i64 -27, ptr nonnull @85)
  tail call void @__quantum__rt__int_record_output(i64 81, ptr nonnull @86)
  tail call void @__quantum__rt__int_record_output(i64 -243, ptr nonnull @87)
  tail call void @__quantum__rt__int_record_output(i64 729, ptr nonnull @88)
  tail call void @__quantum__rt__int_record_output(i64 -2187, ptr nonnull @89)
  tail call void @__quantum__rt__int_record_output(i64 6561, ptr nonnull @90)
  tail call void @__quantum__rt__int_record_output(i64 -19683, ptr nonnull @91)
  tail call void @__quantum__rt__int_record_output(i64 59049, ptr nonnull @92)
  tail call void @__quantum__rt__int_record_output(i64 256, ptr nonnull @93)
  tail call void @__quantum__rt__int_record_output(i64 -1024, ptr nonnull @94)
  tail call void @__quantum__rt__int_record_output(i64 4096, ptr nonnull @95)
  tail call void @__quantum__rt__int_record_output(i64 -16384, ptr nonnull @96)
  tail call void @__quantum__rt__int_record_output(i64 65536, ptr nonnull @97)
  tail call void @__quantum__rt__int_record_output(i64 -262144, ptr nonnull @98)
  tail call void @__quantum__rt__int_record_output(i64 1048576, ptr nonnull @99)
  tail call void @__quantum__rt__int_record_output(i64 -3125, ptr nonnull @100)
  tail call void @__quantum__rt__int_record_output(i64 15625, ptr nonnull @101)
  tail call void @__quantum__rt__int_record_output(i64 -78125, ptr nonnull @102)
  tail call void @__quantum__rt__int_record_output(i64 390625, ptr nonnull @103)
  tail call void @__quantum__rt__int_record_output(i64 -1953125, ptr nonnull @104)
  tail call void @__quantum__rt__int_record_output(i64 9765625, ptr nonnull @105)
  tail call void @__quantum__rt__int_record_output(i64 46656, ptr nonnull @106)
  tail call void @__quantum__rt__int_record_output(i64 -279936, ptr nonnull @107)
  tail call void @__quantum__rt__int_record_output(i64 1679616, ptr nonnull @108)
  tail call void @__quantum__rt__int_record_output(i64 -10077696, ptr nonnull @109)
  tail call void @__quantum__rt__int_record_output(i64 60466176, ptr nonnull @110)
  tail call void @__quantum__rt__int_record_output(i64 -823543, ptr nonnull @111)
  tail call void @__quantum__rt__int_record_output(i64 5764801, ptr nonnull @112)
  tail call void @__quantum__rt__int_record_output(i64 -40353607, ptr nonnull @113)
  tail call void @__quantum__rt__int_record_output(i64 282475249, ptr nonnull @114)
  tail call void @__quantum__rt__int_record_output(i64 16777216, ptr nonnull @115)
  tail call void @__quantum__rt__int_record_output(i64 -134217728, ptr nonnull @116)
  tail call void @__quantum__rt__int_record_output(i64 1073741824, ptr nonnull @117)
  tail call void @__quantum__rt__int_record_output(i64 -387420489, ptr nonnull @118)
  tail call void @__quantum__rt__int_record_output(i64 3486784401, ptr nonnull @119)
  tail call void @__quantum__rt__int_record_output(i64 10000000000, ptr nonnull @120)
  tail call void @__quantum__qis__mz__body(ptr null, ptr null)
  %0 = tail call i1 @__quantum__rt__read_result(ptr null)
  tail call void @__quantum__rt__bool_record_output(i1 %0, ptr nonnull @121)
  ret void
}

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
