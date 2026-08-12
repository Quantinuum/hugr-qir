; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@0 = private unnamed_addr constant [38 x i8] c"No more qubits available to allocate.\00", align 1
@1 = private unnamed_addr constant [38 x i8] c"No more qubits available to allocate.\00", align 1
@2 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@3 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define void @__hugr__.guppy_example_mod.main.1() #0 {
alloca_block:
  call void @__quantum__rt__initialize(ptr null)
  %"4_0" = alloca i1, align 1
  %"4_1" = alloca i1, align 1
  %"0" = alloca i1, align 1
  %"1" = alloca i1, align 1
  %"15_0" = alloca i1, align 1
  %"15_1" = alloca ptr, align 8
  %"30_0" = alloca i1, align 1
  %"30_1" = alloca ptr, align 8
  %"37_0" = alloca i1, align 1
  %"44_0" = alloca i1, align 1
  %"44_1" = alloca i1, align 1
  %"49_0" = alloca i1, align 1
  %"49_1" = alloca i1, align 1
  %"12_0" = alloca i1, align 1
  %"9_0" = alloca ptr, align 8
  %"8_0" = alloca ptr, align 8
  %"90_0" = alloca { i1, ptr }, align 8
  %"91_0" = alloca ptr, align 8
  %"02" = alloca ptr, align 8
  %"97_0" = alloca { i32, ptr }, align 8
  %"98_0" = alloca ptr, align 8
  %"06" = alloca ptr, align 8
  %"99_0" = alloca ptr, align 8
  %"10_0" = alloca ptr, align 8
  %"114_0" = alloca ptr, align 8
  %"121_0" = alloca double, align 8
  %"119_0" = alloca double, align 8
  %"122_0" = alloca ptr, align 8
  %"117_0" = alloca double, align 8
  %"123_0" = alloca ptr, align 8
  %"103_0" = alloca { i1, ptr }, align 8
  %"104_0" = alloca ptr, align 8
  %"018" = alloca ptr, align 8
  %"110_0" = alloca { i32, ptr }, align 8
  %"111_0" = alloca ptr, align 8
  %"022" = alloca ptr, align 8
  %"112_0" = alloca ptr, align 8
  %"11_0" = alloca i1, align 1
  %"20_0" = alloca { i1, i1, i1 }, align 8
  %"17_0" = alloca ptr, align 8
  %"124_0" = alloca ptr, align 8
  %"131_0" = alloca double, align 8
  %"129_0" = alloca double, align 8
  %"132_0" = alloca ptr, align 8
  %"127_0" = alloca double, align 8
  %"133_0" = alloca ptr, align 8
  %"18_0" = alloca i1, align 1
  %"19_0" = alloca i1, align 1
  %"050" = alloca { i1, i1, i1 }, align 8
  %"052" = alloca i1, align 1
  %"153" = alloca i1, align 1
  %"22_0" = alloca i1, align 1
  %"22_1" = alloca i1, align 1
  %"24_0" = alloca { i1, i1, i1 }, align 8
  %"059" = alloca i1, align 1
  %"160" = alloca i1, align 1
  %"26_0" = alloca i1, align 1
  %"26_1" = alloca i1, align 1
  %"28_0" = alloca { i1, i1, i1 }, align 8
  %"34_0" = alloca {}, align 8
  %"33_0" = alloca i1, align 1
  %"32_0" = alloca i1, align 1
  %"41_0" = alloca {}, align 8
  %"39_0" = alloca i1, align 1
  %"46_0" = alloca {}, align 8
  %"51_0" = alloca {}, align 8
  br label %entry_block

entry_block:                                      ; preds = %alloca_block
  br label %bb

bb:                                               ; preds = %entry_block
  %0 = insertvalue { i1, ptr } { i1 true, ptr poison }, ptr null, 1
  store { i1, ptr } %0, ptr %"90_0", align 8
  %"90_01" = load { i1, ptr }, ptr %"90_0", align 8
  %1 = extractvalue { i1, ptr } %"90_01", 0
  br label %LeafBlock

LeafBlock:                                        ; preds = %bb
  %SwitchLeaf = icmp eq i1 %1, true
  br i1 %SwitchLeaf, label %bb1, label %bb0

bb0:                                              ; preds = %LeafBlock
  br label %cond_91_case_0

bb1:                                              ; preds = %LeafBlock
  %2 = extractvalue { i1, ptr } %"90_01", 1
  store ptr %2, ptr %"06", align 8
  br label %cond_91_case_1

bb2:                                              ; preds = %bb17
  %"15_036" = load i1, ptr %"15_0", align 1
  %"15_137" = load ptr, ptr %"15_1", align 8
  store i1 %"15_036", ptr %"15_0", align 1
  store ptr %"15_137", ptr %"15_1", align 8
  %"15_138" = load ptr, ptr %"15_1", align 8
  store ptr %"15_138", ptr %"124_0", align 8
  store double 0xBFF921FB54442D18, ptr %"131_0", align 8
  store double 0x3FF921FB54442D18, ptr %"129_0", align 8
  %"124_039" = load ptr, ptr %"124_0", align 8
  %"129_040" = load double, ptr %"129_0", align 8
  %"131_041" = load double, ptr %"131_0", align 8
  call void @__quantum__qis__phasedx__body(double %"129_040", double %"131_041", ptr %"124_039")
  store ptr %"124_039", ptr %"132_0", align 8
  store double 0x400921FB54442D18, ptr %"127_0", align 8
  %"132_042" = load ptr, ptr %"132_0", align 8
  %"127_043" = load double, ptr %"127_0", align 8
  call void @__quantum__qis__rz__body(double %"127_043", ptr %"132_042")
  store ptr %"132_042", ptr %"133_0", align 8
  %"133_044" = load ptr, ptr %"133_0", align 8
  store ptr %"133_044", ptr %"17_0", align 8
  %"17_045" = load ptr, ptr %"17_0", align 8
  call void @__quantum__qis__mz__body(ptr %"17_045", ptr null)
  %3 = call i1 @__quantum__rt__read_result(ptr null)
  %4 = select i1 %3, i1 true, i1 false
  store i1 %4, ptr %"18_0", align 1
  %"18_046" = load i1, ptr %"18_0", align 1
  %5 = select i1 %"18_046", i1 true, i1 false
  store i1 %5, ptr %"19_0", align 1
  %"19_047" = load i1, ptr %"19_0", align 1
  %"15_048" = load i1, ptr %"15_0", align 1
  %"19_049" = load i1, ptr %"19_0", align 1
  br label %LeafBlock102

LeafBlock102:                                     ; preds = %bb2
  %SwitchLeaf103 = icmp eq i1 %"19_047", true
  br i1 %SwitchLeaf103, label %bb4, label %bb3

bb3:                                              ; preds = %LeafBlock102
  store i1 %"15_048", ptr %"052", align 1
  store i1 %"19_049", ptr %"153", align 1
  br label %cond_20_case_0

bb4:                                              ; preds = %LeafBlock102
  store i1 %"15_048", ptr %"059", align 1
  store i1 %"19_049", ptr %"160", align 1
  br label %cond_20_case_1

bb5:                                              ; preds = %bb16
  %"30_067" = load i1, ptr %"30_0", align 1
  %"30_168" = load ptr, ptr %"30_1", align 8
  store i1 %"30_067", ptr %"30_0", align 1
  store ptr %"30_168", ptr %"30_1", align 8
  %"30_169" = load ptr, ptr %"30_1", align 8
  call void @__quantum__qis__mz__body(ptr %"30_169", ptr inttoptr (i64 1 to ptr))
  %6 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 1 to ptr))
  %7 = select i1 %6, i1 true, i1 false
  store i1 %7, ptr %"32_0", align 1
  store {} undef, ptr %"34_0", align 1
  %"32_070" = load i1, ptr %"32_0", align 1
  %8 = select i1 %"32_070", i1 true, i1 false
  store i1 %8, ptr %"33_0", align 1
  %"34_071" = load {}, ptr %"34_0", align 1
  %"30_072" = load i1, ptr %"30_0", align 1
  %"33_073" = load i1, ptr %"33_0", align 1
  store {} %"34_071", ptr %"34_0", align 1
  store i1 %"30_072", ptr %"30_0", align 1
  store i1 %"33_073", ptr %"33_0", align 1
  %"34_074" = load {}, ptr %"34_0", align 1
  %"30_075" = load i1, ptr %"30_0", align 1
  %"33_076" = load i1, ptr %"33_0", align 1
  br label %bb6

bb6:                                              ; preds = %bb5
  store i1 %"30_075", ptr %"0", align 1
  store i1 %"33_076", ptr %"1", align 1
  br label %bb13

bb7:                                              ; preds = %bb19
  %"37_077" = load i1, ptr %"37_0", align 1
  store i1 %"37_077", ptr %"37_0", align 1
  store {} undef, ptr %"41_0", align 1
  store i1 false, ptr %"39_0", align 1
  %"41_078" = load {}, ptr %"41_0", align 1
  %"37_079" = load i1, ptr %"37_0", align 1
  %"39_080" = load i1, ptr %"39_0", align 1
  store {} %"41_078", ptr %"41_0", align 1
  store i1 %"37_079", ptr %"37_0", align 1
  store i1 %"39_080", ptr %"39_0", align 1
  %"41_081" = load {}, ptr %"41_0", align 1
  %"37_082" = load i1, ptr %"37_0", align 1
  %"39_083" = load i1, ptr %"39_0", align 1
  br label %bb8

bb8:                                              ; preds = %bb7
  store i1 %"37_082", ptr %"49_0", align 1
  store i1 %"39_083", ptr %"49_1", align 1
  br label %bb11

bb9:                                              ; preds = %bb18
  %"44_084" = load i1, ptr %"44_0", align 1
  %"44_185" = load i1, ptr %"44_1", align 1
  store i1 %"44_084", ptr %"44_0", align 1
  store i1 %"44_185", ptr %"44_1", align 1
  store {} undef, ptr %"46_0", align 1
  %"46_086" = load {}, ptr %"46_0", align 1
  %"44_087" = load i1, ptr %"44_0", align 1
  %"44_188" = load i1, ptr %"44_1", align 1
  store {} %"46_086", ptr %"46_0", align 1
  store i1 %"44_087", ptr %"44_0", align 1
  store i1 %"44_188", ptr %"44_1", align 1
  %"46_089" = load {}, ptr %"46_0", align 1
  %"44_090" = load i1, ptr %"44_0", align 1
  %"44_191" = load i1, ptr %"44_1", align 1
  br label %bb10

bb10:                                             ; preds = %bb9
  store i1 %"44_090", ptr %"49_0", align 1
  store i1 %"44_191", ptr %"49_1", align 1
  br label %bb11

bb11:                                             ; preds = %bb10, %bb8
  %"49_092" = load i1, ptr %"49_0", align 1
  %"49_193" = load i1, ptr %"49_1", align 1
  store i1 %"49_092", ptr %"49_0", align 1
  store i1 %"49_193", ptr %"49_1", align 1
  store {} undef, ptr %"51_0", align 1
  %"51_094" = load {}, ptr %"51_0", align 1
  %"49_095" = load i1, ptr %"49_0", align 1
  %"49_196" = load i1, ptr %"49_1", align 1
  store {} %"51_094", ptr %"51_0", align 1
  store i1 %"49_095", ptr %"49_0", align 1
  store i1 %"49_196", ptr %"49_1", align 1
  %"51_097" = load {}, ptr %"51_0", align 1
  %"49_098" = load i1, ptr %"49_0", align 1
  %"49_199" = load i1, ptr %"49_1", align 1
  br label %bb12

bb12:                                             ; preds = %bb11
  store i1 %"49_098", ptr %"0", align 1
  store i1 %"49_199", ptr %"1", align 1
  br label %bb13

bb13:                                             ; preds = %bb12, %bb6
  %"034" = load i1, ptr %"0", align 1
  %"135" = load i1, ptr %"1", align 1
  store i1 %"034", ptr %"4_0", align 1
  store i1 %"135", ptr %"4_1", align 1
  %"4_0100" = load i1, ptr %"4_0", align 1
  call void @__quantum__rt__bool_record_output(i1 %"4_0100", ptr @2)
  %"4_1101" = load i1, ptr %"4_1", align 1
  call void @__quantum__rt__bool_record_output(i1 %"4_1101", ptr @3)
  ret void

cond_91_case_0:                                   ; preds = %bb0
  store { i32, ptr } { i32 1, ptr @0 }, ptr %"97_0", align 8
  %"97_04" = load { i32, ptr }, ptr %"97_0", align 8
  call void @abort()
  store ptr null, ptr %"98_0", align 8
  %"98_05" = load ptr, ptr %"98_0", align 8
  store ptr %"98_05", ptr %"02", align 8
  br label %cond_exit_91

cond_91_case_1:                                   ; preds = %bb1
  %"07" = load ptr, ptr %"06", align 8
  store ptr %"07", ptr %"99_0", align 8
  %"99_08" = load ptr, ptr %"99_0", align 8
  store ptr %"99_08", ptr %"02", align 8
  br label %cond_exit_91

cond_exit_91:                                     ; preds = %cond_91_case_1, %cond_91_case_0
  %"03" = load ptr, ptr %"02", align 8
  store ptr %"03", ptr %"91_0", align 8
  %"91_09" = load ptr, ptr %"91_0", align 8
  store ptr %"91_09", ptr %"8_0", align 8
  %"8_010" = load ptr, ptr %"8_0", align 8
  store ptr %"8_010", ptr %"114_0", align 8
  store double 0xBFF921FB54442D18, ptr %"121_0", align 8
  store double 0x3FF921FB54442D18, ptr %"119_0", align 8
  %"114_011" = load ptr, ptr %"114_0", align 8
  %"119_012" = load double, ptr %"119_0", align 8
  %"121_013" = load double, ptr %"121_0", align 8
  call void @__quantum__qis__phasedx__body(double %"119_012", double %"121_013", ptr %"114_011")
  store ptr %"114_011", ptr %"122_0", align 8
  store double 0x400921FB54442D18, ptr %"117_0", align 8
  %"122_014" = load ptr, ptr %"122_0", align 8
  %"117_015" = load double, ptr %"117_0", align 8
  call void @__quantum__qis__rz__body(double %"117_015", ptr %"122_014")
  store ptr %"122_014", ptr %"123_0", align 8
  %"123_016" = load ptr, ptr %"123_0", align 8
  store ptr %"123_016", ptr %"10_0", align 8
  %9 = insertvalue { i1, ptr } { i1 true, ptr poison }, ptr inttoptr (i64 1 to ptr), 1
  store { i1, ptr } %9, ptr %"103_0", align 8
  %"103_017" = load { i1, ptr }, ptr %"103_0", align 8
  %10 = extractvalue { i1, ptr } %"103_017", 0
  br label %LeafBlock104

LeafBlock104:                                     ; preds = %cond_exit_91
  %SwitchLeaf105 = icmp eq i1 %10, true
  br i1 %SwitchLeaf105, label %bb15, label %bb14

bb14:                                             ; preds = %LeafBlock104
  br label %cond_104_case_0

bb15:                                             ; preds = %LeafBlock104
  %11 = extractvalue { i1, ptr } %"103_017", 1
  store ptr %11, ptr %"022", align 8
  br label %cond_104_case_1

cond_104_case_0:                                  ; preds = %bb14
  store { i32, ptr } { i32 1, ptr @1 }, ptr %"110_0", align 8
  %"110_020" = load { i32, ptr }, ptr %"110_0", align 8
  call void @abort()
  store ptr null, ptr %"111_0", align 8
  %"111_021" = load ptr, ptr %"111_0", align 8
  store ptr %"111_021", ptr %"018", align 8
  br label %cond_exit_104

cond_104_case_1:                                  ; preds = %bb15
  %"023" = load ptr, ptr %"022", align 8
  store ptr %"023", ptr %"112_0", align 8
  %"112_024" = load ptr, ptr %"112_0", align 8
  store ptr %"112_024", ptr %"018", align 8
  br label %cond_exit_104

cond_exit_104:                                    ; preds = %cond_104_case_1, %cond_104_case_0
  %"019" = load ptr, ptr %"018", align 8
  store ptr %"019", ptr %"104_0", align 8
  %"104_025" = load ptr, ptr %"104_0", align 8
  store ptr %"104_025", ptr %"9_0", align 8
  %"10_026" = load ptr, ptr %"10_0", align 8
  call void @__quantum__qis__mz__body(ptr %"10_026", ptr inttoptr (i64 2 to ptr))
  %12 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  %13 = select i1 %12, i1 true, i1 false
  store i1 %13, ptr %"11_0", align 1
  %"11_027" = load i1, ptr %"11_0", align 1
  %14 = select i1 %"11_027", i1 true, i1 false
  store i1 %14, ptr %"12_0", align 1
  %"12_028" = load i1, ptr %"12_0", align 1
  %"12_029" = load i1, ptr %"12_0", align 1
  %"9_030" = load ptr, ptr %"9_0", align 8
  store i1 %"12_028", ptr %"12_0", align 1
  store i1 %"12_029", ptr %"12_0", align 1
  store ptr %"9_030", ptr %"9_0", align 8
  %"12_031" = load i1, ptr %"12_0", align 1
  %"12_032" = load i1, ptr %"12_0", align 1
  %"9_033" = load ptr, ptr %"9_0", align 8
  br label %LeafBlock106

LeafBlock106:                                     ; preds = %cond_exit_104
  %SwitchLeaf107 = icmp eq i1 %"12_031", true
  br i1 %SwitchLeaf107, label %bb17, label %bb16

bb16:                                             ; preds = %LeafBlock106
  store i1 %"12_032", ptr %"30_0", align 1
  store ptr %"9_033", ptr %"30_1", align 8
  br label %bb5

bb17:                                             ; preds = %LeafBlock106
  store i1 %"12_032", ptr %"15_0", align 1
  store ptr %"9_033", ptr %"15_1", align 8
  br label %bb2

cond_20_case_0:                                   ; preds = %bb3
  %"054" = load i1, ptr %"052", align 1
  %"155" = load i1, ptr %"153", align 1
  store i1 %"054", ptr %"22_0", align 1
  store i1 %"155", ptr %"22_1", align 1
  %"22_056" = load i1, ptr %"22_0", align 1
  %"22_157" = load i1, ptr %"22_1", align 1
  %15 = insertvalue { i1, i1, i1 } { i1 false, i1 poison, i1 poison }, i1 %"22_056", 1
  %16 = insertvalue { i1, i1, i1 } %15, i1 %"22_157", 2
  store { i1, i1, i1 } %16, ptr %"24_0", align 1
  %"24_058" = load { i1, i1, i1 }, ptr %"24_0", align 1
  store { i1, i1, i1 } %"24_058", ptr %"050", align 1
  br label %cond_exit_20

cond_20_case_1:                                   ; preds = %bb4
  %"061" = load i1, ptr %"059", align 1
  %"162" = load i1, ptr %"160", align 1
  store i1 %"061", ptr %"26_0", align 1
  store i1 %"162", ptr %"26_1", align 1
  %"26_063" = load i1, ptr %"26_0", align 1
  %17 = insertvalue { i1, i1, i1 } { i1 true, i1 poison, i1 poison }, i1 %"26_063", 1
  store { i1, i1, i1 } %17, ptr %"28_0", align 1
  %"28_064" = load { i1, i1, i1 }, ptr %"28_0", align 1
  store { i1, i1, i1 } %"28_064", ptr %"050", align 1
  br label %cond_exit_20

cond_exit_20:                                     ; preds = %cond_20_case_1, %cond_20_case_0
  %"051" = load { i1, i1, i1 }, ptr %"050", align 1
  store { i1, i1, i1 } %"051", ptr %"20_0", align 1
  %"20_065" = load { i1, i1, i1 }, ptr %"20_0", align 1
  store { i1, i1, i1 } %"20_065", ptr %"20_0", align 1
  %"20_066" = load { i1, i1, i1 }, ptr %"20_0", align 1
  %18 = extractvalue { i1, i1, i1 } %"20_066", 0
  br label %LeafBlock108

LeafBlock108:                                     ; preds = %cond_exit_20
  %SwitchLeaf109 = icmp eq i1 %18, true
  br i1 %SwitchLeaf109, label %bb19, label %bb18

bb18:                                             ; preds = %LeafBlock108
  %19 = extractvalue { i1, i1, i1 } %"20_066", 1
  %20 = extractvalue { i1, i1, i1 } %"20_066", 2
  store i1 %19, ptr %"44_0", align 1
  store i1 %20, ptr %"44_1", align 1
  br label %bb9

bb19:                                             ; preds = %LeafBlock108
  %21 = extractvalue { i1, i1, i1 } %"20_066", 1
  store i1 %21, ptr %"37_0", align 1
  br label %bb7
}

declare ptr @__quantum__rt__qubit_allocate()

declare void @abort()

declare void @__quantum__qis__phasedx__body(double, double, ptr)

declare void @__quantum__qis__rz__body(double, ptr)

declare ptr @__QIR__CONV_Qubit_TO_Result(ptr)

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) #1

declare i1 @__quantum__rt__read_result(ptr readonly)

declare void @__quantum__rt__bool_record_output(i1, ptr)

declare void @__quantum__rt__initialize(ptr)

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="2" "required_num_results"="3" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
