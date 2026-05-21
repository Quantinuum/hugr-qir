; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

@0 = private unnamed_addr constant [38 x i8] c"No more qubits available to allocate.\00", align 1
@1 = private unnamed_addr constant [38 x i8] c"No more qubits available to allocate.\00", align 1
@2 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@3 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@gen_name = private unnamed_addr constant [8 x i8] c"hugr-qir", section ",qir_generator"
@gen_version = private unnamed_addr constant [5 x i8] c"X.Y.Z", section ",qir_generator"

define dso_local void @__hugr__.guppy_example_mod.main.1() #0 {
alloca_block:
  call void @__quantum__rt__initialize(i8* null)
  %"20_0" = alloca { i1, i1 }, align 8
  %"20_1" = alloca %Qubit*, align 8
  %"36_0" = alloca { i1, i1 }, align 8
  %"36_1" = alloca %Qubit*, align 8
  %"41_0" = alloca { i1, i1 }, align 8
  %"47_0" = alloca { i1, i1 }, align 8
  %"47_1" = alloca { i1, i1 }, align 8
  %"51_0" = alloca { i1, i1 }, align 8
  %"51_1" = alloca { i1, i1 }, align 8
  %"55_0" = alloca { i1, i1 }, align 8
  %"55_1" = alloca { i1, i1 }, align 8
  %"17_0" = alloca i1, align 1
  %"65_0" = alloca { i1, i1 }, align 8
  %"11_1" = alloca %Qubit*, align 8
  %"15_0" = alloca { i1, i1 }, align 8
  %"0" = alloca i1, align 1
  %"117_0" = alloca i1, align 1
  %"03" = alloca i1, align 1
  %"119_0" = alloca i1, align 1
  %"13_0" = alloca {}, align 8
  %"8_0" = alloca %Qubit*, align 8
  %"201_0" = alloca { i1, %Qubit* }, align 8
  %"202_0" = alloca %Qubit*, align 8
  %"07" = alloca %Qubit*, align 8
  %"208_0" = alloca { i32, i8* }, align 8
  %"209_0" = alloca %Qubit*, align 8
  %"011" = alloca %Qubit*, align 8
  %"210_0" = alloca %Qubit*, align 8
  %"9_0" = alloca %Qubit*, align 8
  %"214_0" = alloca { i1, %Qubit* }, align 8
  %"215_0" = alloca %Qubit*, align 8
  %"016" = alloca %Qubit*, align 8
  %"221_0" = alloca { i32, i8* }, align 8
  %"222_0" = alloca %Qubit*, align 8
  %"020" = alloca %Qubit*, align 8
  %"223_0" = alloca %Qubit*, align 8
  %"10_0" = alloca { %Qubit*, %Qubit* }, align 8
  %"11_0" = alloca %Qubit*, align 8
  %"12_0" = alloca %Qubit*, align 8
  %"225_0" = alloca %Qubit*, align 8
  %"232_0" = alloca double, align 8
  %"230_0" = alloca double, align 8
  %"233_0" = alloca %Qubit*, align 8
  %"228_0" = alloca double, align 8
  %"234_0" = alloca %Qubit*, align 8
  %"14_0" = alloca { i1, i1 }, align 8
  %"96_0" = alloca %Qubit*, align 8
  %"98_0" = alloca i1, align 1
  %"99_0" = alloca { i1, i1 }, align 8
  %"65_1" = alloca { i1, i1 }, align 8
  %"039" = alloca { i1, i1 }, align 8
  %"1" = alloca { i1, i1 }, align 8
  %"042" = alloca i1, align 1
  %"101_0" = alloca i1, align 1
  %"104_0" = alloca { i1, i1 }, align 8
  %"103_0" = alloca { i1, i1 }, align 8
  %"048" = alloca i1, align 1
  %"106_0" = alloca i1, align 1
  %"108_0" = alloca i1, align 1
  %"108_1" = alloca i1, align 1
  %"111_0" = alloca i1, align 1
  %"113_0" = alloca i1, align 1
  %"113_1" = alloca i1, align 1
  %"110_0" = alloca { i1, i1 }, align 8
  %"109_0" = alloca { i1, i1 }, align 8
  %"123_0" = alloca { i1, i1 }, align 8
  %"125_0" = alloca i1, align 1
  %"060" = alloca i1, align 1
  %"062" = alloca i1, align 1
  %"128_0" = alloca i1, align 1
  %"065" = alloca i1, align 1
  %"130_0" = alloca i1, align 1
  %"132_0" = alloca i1, align 1
  %"26_0" = alloca { i1, { i1, i1 }, { i1, i1 } }, align 8
  %"23_0" = alloca {}, align 8
  %"22_0" = alloca %Qubit*, align 8
  %"235_0" = alloca %Qubit*, align 8
  %"242_0" = alloca double, align 8
  %"240_0" = alloca double, align 8
  %"243_0" = alloca %Qubit*, align 8
  %"238_0" = alloca double, align 8
  %"244_0" = alloca %Qubit*, align 8
  %"24_0" = alloca { i1, i1 }, align 8
  %"133_0" = alloca %Qubit*, align 8
  %"135_0" = alloca i1, align 1
  %"136_0" = alloca { i1, i1 }, align 8
  %"64_0" = alloca { i1, i1 }, align 8
  %"64_1" = alloca { i1, i1 }, align 8
  %"090" = alloca { i1, i1 }, align 8
  %"191" = alloca { i1, i1 }, align 8
  %"094" = alloca i1, align 1
  %"138_0" = alloca i1, align 1
  %"141_0" = alloca { i1, i1 }, align 8
  %"140_0" = alloca { i1, i1 }, align 8
  %"0100" = alloca i1, align 1
  %"143_0" = alloca i1, align 1
  %"145_0" = alloca i1, align 1
  %"145_1" = alloca i1, align 1
  %"148_0" = alloca i1, align 1
  %"150_0" = alloca i1, align 1
  %"150_1" = alloca i1, align 1
  %"147_0" = alloca { i1, i1 }, align 8
  %"146_0" = alloca { i1, i1 }, align 8
  %"25_0" = alloca i1, align 1
  %"152_0" = alloca { i1, i1 }, align 8
  %"154_0" = alloca i1, align 1
  %"0112" = alloca i1, align 1
  %"0114" = alloca i1, align 1
  %"157_0" = alloca i1, align 1
  %"0117" = alloca i1, align 1
  %"159_0" = alloca i1, align 1
  %"161_0" = alloca i1, align 1
  %"0125" = alloca { i1, { i1, i1 }, { i1, i1 } }, align 8
  %"0127" = alloca { i1, i1 }, align 8
  %"1128" = alloca { i1, i1 }, align 8
  %"28_0" = alloca { i1, i1 }, align 8
  %"28_1" = alloca { i1, i1 }, align 8
  %"30_0" = alloca { i1, { i1, i1 }, { i1, i1 } }, align 8
  %"0134" = alloca { i1, i1 }, align 8
  %"1135" = alloca { i1, i1 }, align 8
  %"32_0" = alloca { i1, i1 }, align 8
  %"32_1" = alloca { i1, i1 }, align 8
  %"0139" = alloca i1, align 1
  %"188_0" = alloca i1, align 1
  %"0141" = alloca i1, align 1
  %"190_0" = alloca i1, align 1
  %"34_0" = alloca { i1, { i1, i1 }, { i1, i1 } }, align 8
  %"39_0" = alloca {}, align 8
  %"38_0" = alloca { i1, i1 }, align 8
  %"162_0" = alloca %Qubit*, align 8
  %"164_0" = alloca i1, align 1
  %"165_0" = alloca { i1, i1 }, align 8
  %"45_0" = alloca {}, align 8
  %"43_0" = alloca { i1, i1 }, align 8
  %"49_0" = alloca {}, align 8
  %"53_0" = alloca {}, align 8
  %"63_0" = alloca {}, align 8
  %"62_0" = alloca {}, align 8
  %"60_0" = alloca i1, align 1
  %"176_0" = alloca { i1, i1 }, align 8
  %"178_0" = alloca i1, align 1
  %"0187" = alloca i1, align 1
  %"0189" = alloca i1, align 1
  %"181_0" = alloca i1, align 1
  %"0192" = alloca i1, align 1
  %"183_0" = alloca i1, align 1
  %"185_0" = alloca i1, align 1
  %"59_0" = alloca {}, align 8
  %"57_0" = alloca i1, align 1
  %"166_0" = alloca { i1, i1 }, align 8
  %"168_0" = alloca i1, align 1
  %"0199" = alloca i1, align 1
  %"0201" = alloca i1, align 1
  %"171_0" = alloca i1, align 1
  %"0204" = alloca i1, align 1
  %"173_0" = alloca i1, align 1
  %"175_0" = alloca i1, align 1
  br label %entry_block

entry_block:                                      ; preds = %alloca_block
  br label %bb

bb:                                               ; preds = %entry_block
  store { i1, i1 } zeroinitializer, { i1, i1 }* %"15_0", align 1
  %"15_01" = load { i1, i1 }, { i1, i1 }* %"15_0", align 1
  %0 = extractvalue { i1, i1 } %"15_01", 0
  br label %LeafBlock

LeafBlock:                                        ; preds = %bb
  %SwitchLeaf = icmp eq i1 %0, true
  br i1 %SwitchLeaf, label %bb1, label %NewDefault

NewDefault:                                       ; preds = %LeafBlock
  br label %bb0

bb0:                                              ; preds = %NewDefault
  %1 = extractvalue { i1, i1 } %"15_01", 1
  store i1 %1, i1* %"0", align 1
  br label %cond_114_case_0

bb1:                                              ; preds = %LeafBlock
  %2 = extractvalue { i1, i1 } %"15_01", 1
  store i1 %2, i1* %"03", align 1
  br label %cond_114_case_1

bb2:                                              ; preds = %bb26
  %"20_076" = load { i1, i1 }, { i1, i1 }* %"20_0", align 1
  %"20_177" = load %Qubit*, %Qubit** %"20_1", align 8
  store { i1, i1 } %"20_076", { i1, i1 }* %"20_0", align 1
  store %Qubit* %"20_177", %Qubit** %"20_1", align 8
  store {} undef, {}* %"23_0", align 1
  %"20_178" = load %Qubit*, %Qubit** %"20_1", align 8
  store %Qubit* %"20_178", %Qubit** %"235_0", align 8
  store double 0xBFF921FB54442D18, double* %"242_0", align 8
  store double 0x3FF921FB54442D18, double* %"240_0", align 8
  %"235_079" = load %Qubit*, %Qubit** %"235_0", align 8
  %"240_080" = load double, double* %"240_0", align 8
  %"242_081" = load double, double* %"242_0", align 8
  call void @__quantum__qis__phasedx__body(double %"240_080", double %"242_081", %Qubit* %"235_079")
  store %Qubit* %"235_079", %Qubit** %"243_0", align 8
  store double 0x400921FB54442D18, double* %"238_0", align 8
  %"243_082" = load %Qubit*, %Qubit** %"243_0", align 8
  %"238_083" = load double, double* %"238_0", align 8
  call void @__quantum__qis__rz__body(double %"238_083", %Qubit* %"243_082")
  store %Qubit* %"243_082", %Qubit** %"244_0", align 8
  %"244_084" = load %Qubit*, %Qubit** %"244_0", align 8
  store %Qubit* %"244_084", %Qubit** %"22_0", align 8
  %"22_085" = load %Qubit*, %Qubit** %"22_0", align 8
  store %Qubit* %"22_085", %Qubit** %"133_0", align 8
  %"133_086" = load %Qubit*, %Qubit** %"133_0", align 8
  call void @__quantum__qis__mz__body(%Qubit* %"133_086", %Result* null)
  %3 = call i1 @__quantum__rt__read_result(%Result* null)
  %4 = select i1 %3, i1 true, i1 false
  store i1 %4, i1* %"135_0", align 1
  %"135_087" = load i1, i1* %"135_0", align 1
  %5 = insertvalue { i1, i1 } { i1 true, i1 poison }, i1 %"135_087", 1
  store { i1, i1 } %5, { i1, i1 }* %"136_0", align 1
  %"136_088" = load { i1, i1 }, { i1, i1 }* %"136_0", align 1
  store { i1, i1 } %"136_088", { i1, i1 }* %"24_0", align 1
  %"24_089" = load { i1, i1 }, { i1, i1 }* %"24_0", align 1
  %6 = extractvalue { i1, i1 } %"24_089", 0
  br label %LeafBlock214

LeafBlock214:                                     ; preds = %bb2
  %SwitchLeaf215 = icmp eq i1 %6, true
  br i1 %SwitchLeaf215, label %bb4, label %NewDefault213

NewDefault213:                                    ; preds = %LeafBlock214
  br label %bb3

bb3:                                              ; preds = %NewDefault213
  %7 = extractvalue { i1, i1 } %"24_089", 1
  store i1 %7, i1* %"094", align 1
  br label %cond_64_case_0

bb4:                                              ; preds = %LeafBlock214
  %8 = extractvalue { i1, i1 } %"24_089", 1
  store i1 %8, i1* %"0100", align 1
  br label %cond_64_case_1

bb5:                                              ; preds = %bb25
  %"36_0148" = load { i1, i1 }, { i1, i1 }* %"36_0", align 1
  %"36_1149" = load %Qubit*, %Qubit** %"36_1", align 8
  store { i1, i1 } %"36_0148", { i1, i1 }* %"36_0", align 1
  store %Qubit* %"36_1149", %Qubit** %"36_1", align 8
  store {} undef, {}* %"39_0", align 1
  %"36_1150" = load %Qubit*, %Qubit** %"36_1", align 8
  store %Qubit* %"36_1150", %Qubit** %"162_0", align 8
  %"162_0151" = load %Qubit*, %Qubit** %"162_0", align 8
  call void @__quantum__qis__mz__body(%Qubit* %"162_0151", %Result* inttoptr (i64 1 to %Result*))
  %9 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 1 to %Result*))
  %10 = select i1 %9, i1 true, i1 false
  store i1 %10, i1* %"164_0", align 1
  %"164_0152" = load i1, i1* %"164_0", align 1
  %11 = insertvalue { i1, i1 } { i1 true, i1 poison }, i1 %"164_0152", 1
  store { i1, i1 } %11, { i1, i1 }* %"165_0", align 1
  %"165_0153" = load { i1, i1 }, { i1, i1 }* %"165_0", align 1
  store { i1, i1 } %"165_0153", { i1, i1 }* %"38_0", align 1
  %"39_0154" = load {}, {}* %"39_0", align 1
  %"36_0155" = load { i1, i1 }, { i1, i1 }* %"36_0", align 1
  %"38_0156" = load { i1, i1 }, { i1, i1 }* %"38_0", align 1
  store {} %"39_0154", {}* %"39_0", align 1
  store { i1, i1 } %"36_0155", { i1, i1 }* %"36_0", align 1
  store { i1, i1 } %"38_0156", { i1, i1 }* %"38_0", align 1
  %"39_0157" = load {}, {}* %"39_0", align 1
  %"36_0158" = load { i1, i1 }, { i1, i1 }* %"36_0", align 1
  %"38_0159" = load { i1, i1 }, { i1, i1 }* %"38_0", align 1
  br label %bb6

bb6:                                              ; preds = %bb5
  store { i1, i1 } %"36_0158", { i1, i1 }* %"55_0", align 1
  store { i1, i1 } %"38_0159", { i1, i1 }* %"55_1", align 1
  br label %bb13

bb7:                                              ; preds = %bb34
  %"41_0160" = load { i1, i1 }, { i1, i1 }* %"41_0", align 1
  store { i1, i1 } %"41_0160", { i1, i1 }* %"41_0", align 1
  store {} undef, {}* %"45_0", align 1
  store { i1, i1 } zeroinitializer, { i1, i1 }* %"43_0", align 1
  %"45_0161" = load {}, {}* %"45_0", align 1
  %"41_0162" = load { i1, i1 }, { i1, i1 }* %"41_0", align 1
  %"43_0163" = load { i1, i1 }, { i1, i1 }* %"43_0", align 1
  store {} %"45_0161", {}* %"45_0", align 1
  store { i1, i1 } %"41_0162", { i1, i1 }* %"41_0", align 1
  store { i1, i1 } %"43_0163", { i1, i1 }* %"43_0", align 1
  %"45_0164" = load {}, {}* %"45_0", align 1
  %"41_0165" = load { i1, i1 }, { i1, i1 }* %"41_0", align 1
  %"43_0166" = load { i1, i1 }, { i1, i1 }* %"43_0", align 1
  br label %bb8

bb8:                                              ; preds = %bb7
  store { i1, i1 } %"41_0165", { i1, i1 }* %"51_0", align 1
  store { i1, i1 } %"43_0166", { i1, i1 }* %"51_1", align 1
  br label %bb11

bb9:                                              ; preds = %bb33
  %"47_0167" = load { i1, i1 }, { i1, i1 }* %"47_0", align 1
  %"47_1168" = load { i1, i1 }, { i1, i1 }* %"47_1", align 1
  store { i1, i1 } %"47_0167", { i1, i1 }* %"47_0", align 1
  store { i1, i1 } %"47_1168", { i1, i1 }* %"47_1", align 1
  store {} undef, {}* %"49_0", align 1
  %"49_0169" = load {}, {}* %"49_0", align 1
  %"47_0170" = load { i1, i1 }, { i1, i1 }* %"47_0", align 1
  %"47_1171" = load { i1, i1 }, { i1, i1 }* %"47_1", align 1
  store {} %"49_0169", {}* %"49_0", align 1
  store { i1, i1 } %"47_0170", { i1, i1 }* %"47_0", align 1
  store { i1, i1 } %"47_1171", { i1, i1 }* %"47_1", align 1
  %"49_0172" = load {}, {}* %"49_0", align 1
  %"47_0173" = load { i1, i1 }, { i1, i1 }* %"47_0", align 1
  %"47_1174" = load { i1, i1 }, { i1, i1 }* %"47_1", align 1
  br label %bb10

bb10:                                             ; preds = %bb9
  store { i1, i1 } %"47_0173", { i1, i1 }* %"51_0", align 1
  store { i1, i1 } %"47_1174", { i1, i1 }* %"51_1", align 1
  br label %bb11

bb11:                                             ; preds = %bb10, %bb8
  %"51_0175" = load { i1, i1 }, { i1, i1 }* %"51_0", align 1
  %"51_1176" = load { i1, i1 }, { i1, i1 }* %"51_1", align 1
  store { i1, i1 } %"51_0175", { i1, i1 }* %"51_0", align 1
  store { i1, i1 } %"51_1176", { i1, i1 }* %"51_1", align 1
  store {} undef, {}* %"53_0", align 1
  %"53_0177" = load {}, {}* %"53_0", align 1
  %"51_0178" = load { i1, i1 }, { i1, i1 }* %"51_0", align 1
  %"51_1179" = load { i1, i1 }, { i1, i1 }* %"51_1", align 1
  store {} %"53_0177", {}* %"53_0", align 1
  store { i1, i1 } %"51_0178", { i1, i1 }* %"51_0", align 1
  store { i1, i1 } %"51_1179", { i1, i1 }* %"51_1", align 1
  %"53_0180" = load {}, {}* %"53_0", align 1
  %"51_0181" = load { i1, i1 }, { i1, i1 }* %"51_0", align 1
  %"51_1182" = load { i1, i1 }, { i1, i1 }* %"51_1", align 1
  br label %bb12

bb12:                                             ; preds = %bb11
  store { i1, i1 } %"51_0181", { i1, i1 }* %"55_0", align 1
  store { i1, i1 } %"51_1182", { i1, i1 }* %"55_1", align 1
  br label %bb13

bb13:                                             ; preds = %bb12, %bb6
  %"55_0183" = load { i1, i1 }, { i1, i1 }* %"55_0", align 1
  %"55_1184" = load { i1, i1 }, { i1, i1 }* %"55_1", align 1
  store { i1, i1 } %"55_0183", { i1, i1 }* %"55_0", align 1
  store { i1, i1 } %"55_1184", { i1, i1 }* %"55_1", align 1
  store {} undef, {}* %"63_0", align 1
  store {} undef, {}* %"62_0", align 1
  %"55_1185" = load { i1, i1 }, { i1, i1 }* %"55_1", align 1
  store { i1, i1 } %"55_1185", { i1, i1 }* %"176_0", align 1
  %"176_0186" = load { i1, i1 }, { i1, i1 }* %"176_0", align 1
  %12 = extractvalue { i1, i1 } %"176_0186", 0
  br label %LeafBlock217

LeafBlock217:                                     ; preds = %bb13
  %SwitchLeaf218 = icmp eq i1 %12, true
  br i1 %SwitchLeaf218, label %bb15, label %NewDefault216

NewDefault216:                                    ; preds = %LeafBlock217
  br label %bb14

bb14:                                             ; preds = %NewDefault216
  %13 = extractvalue { i1, i1 } %"176_0186", 1
  store i1 %13, i1* %"0189", align 1
  br label %cond_178_case_0

bb15:                                             ; preds = %LeafBlock217
  %14 = extractvalue { i1, i1 } %"176_0186", 1
  store i1 %14, i1* %"0192", align 1
  br label %cond_178_case_1

bb16:                                             ; preds = %bb37
  ret void

cond_114_case_0:                                  ; preds = %bb0
  %"02" = load i1, i1* %"0", align 1
  store i1 %"02", i1* %"117_0", align 1
  br label %cond_exit_114

cond_114_case_1:                                  ; preds = %bb1
  %"04" = load i1, i1* %"03", align 1
  store i1 %"04", i1* %"119_0", align 1
  %"119_05" = load i1, i1* %"119_0", align 1
  br label %cond_exit_114

cond_exit_114:                                    ; preds = %cond_114_case_1, %cond_114_case_0
  store {} undef, {}* %"13_0", align 1
  %15 = insertvalue { i1, %Qubit* } { i1 true, %Qubit* poison }, %Qubit* null, 1
  store { i1, %Qubit* } %15, { i1, %Qubit* }* %"201_0", align 8
  %"201_06" = load { i1, %Qubit* }, { i1, %Qubit* }* %"201_0", align 8
  %16 = extractvalue { i1, %Qubit* } %"201_06", 0
  br label %LeafBlock220

LeafBlock220:                                     ; preds = %cond_exit_114
  %SwitchLeaf221 = icmp eq i1 %16, true
  br i1 %SwitchLeaf221, label %bb18, label %NewDefault219

NewDefault219:                                    ; preds = %LeafBlock220
  br label %bb17

bb17:                                             ; preds = %NewDefault219
  br label %cond_202_case_0

bb18:                                             ; preds = %LeafBlock220
  %17 = extractvalue { i1, %Qubit* } %"201_06", 1
  store %Qubit* %17, %Qubit** %"011", align 8
  br label %cond_202_case_1

cond_202_case_0:                                  ; preds = %bb17
  store { i32, i8* } { i32 1, i8* getelementptr inbounds ([38 x i8], [38 x i8]* @0, i32 0, i32 0) }, { i32, i8* }* %"208_0", align 8
  %"208_09" = load { i32, i8* }, { i32, i8* }* %"208_0", align 8
  call void @abort()
  store %Qubit* null, %Qubit** %"209_0", align 8
  %"209_010" = load %Qubit*, %Qubit** %"209_0", align 8
  store %Qubit* %"209_010", %Qubit** %"07", align 8
  br label %cond_exit_202

cond_202_case_1:                                  ; preds = %bb18
  %"012" = load %Qubit*, %Qubit** %"011", align 8
  store %Qubit* %"012", %Qubit** %"210_0", align 8
  %"210_013" = load %Qubit*, %Qubit** %"210_0", align 8
  store %Qubit* %"210_013", %Qubit** %"07", align 8
  br label %cond_exit_202

cond_exit_202:                                    ; preds = %cond_202_case_1, %cond_202_case_0
  %"08" = load %Qubit*, %Qubit** %"07", align 8
  store %Qubit* %"08", %Qubit** %"202_0", align 8
  %"202_014" = load %Qubit*, %Qubit** %"202_0", align 8
  store %Qubit* %"202_014", %Qubit** %"8_0", align 8
  %18 = insertvalue { i1, %Qubit* } { i1 true, %Qubit* poison }, %Qubit* inttoptr (i64 1 to %Qubit*), 1
  store { i1, %Qubit* } %18, { i1, %Qubit* }* %"214_0", align 8
  %"214_015" = load { i1, %Qubit* }, { i1, %Qubit* }* %"214_0", align 8
  %19 = extractvalue { i1, %Qubit* } %"214_015", 0
  br label %LeafBlock223

LeafBlock223:                                     ; preds = %cond_exit_202
  %SwitchLeaf224 = icmp eq i1 %19, true
  br i1 %SwitchLeaf224, label %bb20, label %NewDefault222

NewDefault222:                                    ; preds = %LeafBlock223
  br label %bb19

bb19:                                             ; preds = %NewDefault222
  br label %cond_215_case_0

bb20:                                             ; preds = %LeafBlock223
  %20 = extractvalue { i1, %Qubit* } %"214_015", 1
  store %Qubit* %20, %Qubit** %"020", align 8
  br label %cond_215_case_1

cond_215_case_0:                                  ; preds = %bb19
  store { i32, i8* } { i32 1, i8* getelementptr inbounds ([38 x i8], [38 x i8]* @1, i32 0, i32 0) }, { i32, i8* }* %"221_0", align 8
  %"221_018" = load { i32, i8* }, { i32, i8* }* %"221_0", align 8
  call void @abort()
  store %Qubit* null, %Qubit** %"222_0", align 8
  %"222_019" = load %Qubit*, %Qubit** %"222_0", align 8
  store %Qubit* %"222_019", %Qubit** %"016", align 8
  br label %cond_exit_215

cond_215_case_1:                                  ; preds = %bb20
  %"021" = load %Qubit*, %Qubit** %"020", align 8
  store %Qubit* %"021", %Qubit** %"223_0", align 8
  %"223_022" = load %Qubit*, %Qubit** %"223_0", align 8
  store %Qubit* %"223_022", %Qubit** %"016", align 8
  br label %cond_exit_215

cond_exit_215:                                    ; preds = %cond_215_case_1, %cond_215_case_0
  %"017" = load %Qubit*, %Qubit** %"016", align 8
  store %Qubit* %"017", %Qubit** %"215_0", align 8
  %"215_023" = load %Qubit*, %Qubit** %"215_0", align 8
  store %Qubit* %"215_023", %Qubit** %"9_0", align 8
  %"8_024" = load %Qubit*, %Qubit** %"8_0", align 8
  %"9_025" = load %Qubit*, %Qubit** %"9_0", align 8
  %21 = insertvalue { %Qubit*, %Qubit* } poison, %Qubit* %"8_024", 0
  %22 = insertvalue { %Qubit*, %Qubit* } %21, %Qubit* %"9_025", 1
  store { %Qubit*, %Qubit* } %22, { %Qubit*, %Qubit* }* %"10_0", align 8
  %"10_026" = load { %Qubit*, %Qubit* }, { %Qubit*, %Qubit* }* %"10_0", align 8
  %23 = extractvalue { %Qubit*, %Qubit* } %"10_026", 0
  %24 = extractvalue { %Qubit*, %Qubit* } %"10_026", 1
  store %Qubit* %23, %Qubit** %"11_0", align 8
  store %Qubit* %24, %Qubit** %"11_1", align 8
  %"11_027" = load %Qubit*, %Qubit** %"11_0", align 8
  store %Qubit* %"11_027", %Qubit** %"225_0", align 8
  store double 0xBFF921FB54442D18, double* %"232_0", align 8
  store double 0x3FF921FB54442D18, double* %"230_0", align 8
  %"225_028" = load %Qubit*, %Qubit** %"225_0", align 8
  %"230_029" = load double, double* %"230_0", align 8
  %"232_030" = load double, double* %"232_0", align 8
  call void @__quantum__qis__phasedx__body(double %"230_029", double %"232_030", %Qubit* %"225_028")
  store %Qubit* %"225_028", %Qubit** %"233_0", align 8
  store double 0x400921FB54442D18, double* %"228_0", align 8
  %"233_031" = load %Qubit*, %Qubit** %"233_0", align 8
  %"228_032" = load double, double* %"228_0", align 8
  call void @__quantum__qis__rz__body(double %"228_032", %Qubit* %"233_031")
  store %Qubit* %"233_031", %Qubit** %"234_0", align 8
  %"234_033" = load %Qubit*, %Qubit** %"234_0", align 8
  store %Qubit* %"234_033", %Qubit** %"12_0", align 8
  %"12_034" = load %Qubit*, %Qubit** %"12_0", align 8
  store %Qubit* %"12_034", %Qubit** %"96_0", align 8
  %"96_035" = load %Qubit*, %Qubit** %"96_0", align 8
  call void @__quantum__qis__mz__body(%Qubit* %"96_035", %Result* inttoptr (i64 2 to %Result*))
  %25 = call i1 @__quantum__rt__read_result(%Result* inttoptr (i64 2 to %Result*))
  %26 = select i1 %25, i1 true, i1 false
  store i1 %26, i1* %"98_0", align 1
  %"98_036" = load i1, i1* %"98_0", align 1
  %27 = insertvalue { i1, i1 } { i1 true, i1 poison }, i1 %"98_036", 1
  store { i1, i1 } %27, { i1, i1 }* %"99_0", align 1
  %"99_037" = load { i1, i1 }, { i1, i1 }* %"99_0", align 1
  store { i1, i1 } %"99_037", { i1, i1 }* %"14_0", align 1
  %"14_038" = load { i1, i1 }, { i1, i1 }* %"14_0", align 1
  %28 = extractvalue { i1, i1 } %"14_038", 0
  br label %LeafBlock226

LeafBlock226:                                     ; preds = %cond_exit_215
  %SwitchLeaf227 = icmp eq i1 %28, true
  br i1 %SwitchLeaf227, label %bb22, label %NewDefault225

NewDefault225:                                    ; preds = %LeafBlock226
  br label %bb21

bb21:                                             ; preds = %NewDefault225
  %29 = extractvalue { i1, i1 } %"14_038", 1
  store i1 %29, i1* %"042", align 1
  br label %cond_65_case_0

bb22:                                             ; preds = %LeafBlock226
  %30 = extractvalue { i1, i1 } %"14_038", 1
  store i1 %30, i1* %"048", align 1
  br label %cond_65_case_1

cond_65_case_0:                                   ; preds = %bb21
  %"043" = load i1, i1* %"042", align 1
  store i1 %"043", i1* %"101_0", align 1
  %"101_044" = load i1, i1* %"101_0", align 1
  %31 = insertvalue { i1, i1 } { i1 false, i1 poison }, i1 %"101_044", 1
  store { i1, i1 } %31, { i1, i1 }* %"104_0", align 1
  %"101_045" = load i1, i1* %"101_0", align 1
  %32 = insertvalue { i1, i1 } { i1 false, i1 poison }, i1 %"101_045", 1
  store { i1, i1 } %32, { i1, i1 }* %"103_0", align 1
  %"103_046" = load { i1, i1 }, { i1, i1 }* %"103_0", align 1
  %"104_047" = load { i1, i1 }, { i1, i1 }* %"104_0", align 1
  store { i1, i1 } %"103_046", { i1, i1 }* %"039", align 1
  store { i1, i1 } %"104_047", { i1, i1 }* %"1", align 1
  br label %cond_exit_65

cond_65_case_1:                                   ; preds = %bb22
  %"049" = load i1, i1* %"048", align 1
  store i1 %"049", i1* %"106_0", align 1
  %"106_050" = load i1, i1* %"106_0", align 1
  store i1 %"106_050", i1* %"111_0", align 1
  %"111_051" = load i1, i1* %"111_0", align 1
  store i1 %"111_051", i1* %"113_0", align 1
  store i1 %"111_051", i1* %"113_1", align 1
  %"113_052" = load i1, i1* %"113_0", align 1
  %"113_153" = load i1, i1* %"113_1", align 1
  store i1 %"113_052", i1* %"108_0", align 1
  store i1 %"113_153", i1* %"108_1", align 1
  %"108_154" = load i1, i1* %"108_1", align 1
  %33 = insertvalue { i1, i1 } { i1 true, i1 poison }, i1 %"108_154", 1
  store { i1, i1 } %33, { i1, i1 }* %"110_0", align 1
  %"108_055" = load i1, i1* %"108_0", align 1
  %34 = insertvalue { i1, i1 } { i1 true, i1 poison }, i1 %"108_055", 1
  store { i1, i1 } %34, { i1, i1 }* %"109_0", align 1
  %"109_056" = load { i1, i1 }, { i1, i1 }* %"109_0", align 1
  %"110_057" = load { i1, i1 }, { i1, i1 }* %"110_0", align 1
  store { i1, i1 } %"109_056", { i1, i1 }* %"039", align 1
  store { i1, i1 } %"110_057", { i1, i1 }* %"1", align 1
  br label %cond_exit_65

cond_exit_65:                                     ; preds = %cond_65_case_1, %cond_65_case_0
  %"040" = load { i1, i1 }, { i1, i1 }* %"039", align 1
  %"141" = load { i1, i1 }, { i1, i1 }* %"1", align 1
  store { i1, i1 } %"040", { i1, i1 }* %"65_0", align 1
  store { i1, i1 } %"141", { i1, i1 }* %"65_1", align 1
  %"65_158" = load { i1, i1 }, { i1, i1 }* %"65_1", align 1
  store { i1, i1 } %"65_158", { i1, i1 }* %"123_0", align 1
  %"123_059" = load { i1, i1 }, { i1, i1 }* %"123_0", align 1
  %35 = extractvalue { i1, i1 } %"123_059", 0
  br label %LeafBlock229

LeafBlock229:                                     ; preds = %cond_exit_65
  %SwitchLeaf230 = icmp eq i1 %35, true
  br i1 %SwitchLeaf230, label %bb24, label %NewDefault228

NewDefault228:                                    ; preds = %LeafBlock229
  br label %bb23

bb23:                                             ; preds = %NewDefault228
  %36 = extractvalue { i1, i1 } %"123_059", 1
  store i1 %36, i1* %"062", align 1
  br label %cond_125_case_0

bb24:                                             ; preds = %LeafBlock229
  %37 = extractvalue { i1, i1 } %"123_059", 1
  store i1 %37, i1* %"065", align 1
  br label %cond_125_case_1

cond_125_case_0:                                  ; preds = %bb23
  %"063" = load i1, i1* %"062", align 1
  store i1 %"063", i1* %"128_0", align 1
  %"128_064" = load i1, i1* %"128_0", align 1
  store i1 %"128_064", i1* %"060", align 1
  br label %cond_exit_125

cond_125_case_1:                                  ; preds = %bb24
  %"066" = load i1, i1* %"065", align 1
  store i1 %"066", i1* %"130_0", align 1
  %"130_067" = load i1, i1* %"130_0", align 1
  %38 = select i1 %"130_067", i1 true, i1 false
  store i1 %38, i1* %"132_0", align 1
  %"132_068" = load i1, i1* %"132_0", align 1
  store i1 %"132_068", i1* %"060", align 1
  br label %cond_exit_125

cond_exit_125:                                    ; preds = %cond_125_case_1, %cond_125_case_0
  %"061" = load i1, i1* %"060", align 1
  store i1 %"061", i1* %"125_0", align 1
  %"125_069" = load i1, i1* %"125_0", align 1
  store i1 %"125_069", i1* %"17_0", align 1
  %"17_070" = load i1, i1* %"17_0", align 1
  %"65_071" = load { i1, i1 }, { i1, i1 }* %"65_0", align 1
  %"11_172" = load %Qubit*, %Qubit** %"11_1", align 8
  store i1 %"17_070", i1* %"17_0", align 1
  store { i1, i1 } %"65_071", { i1, i1 }* %"65_0", align 1
  store %Qubit* %"11_172", %Qubit** %"11_1", align 8
  %"17_073" = load i1, i1* %"17_0", align 1
  %"65_074" = load { i1, i1 }, { i1, i1 }* %"65_0", align 1
  %"11_175" = load %Qubit*, %Qubit** %"11_1", align 8
  br label %LeafBlock232

LeafBlock232:                                     ; preds = %cond_exit_125
  %SwitchLeaf233 = icmp eq i1 %"17_073", true
  br i1 %SwitchLeaf233, label %bb26, label %NewDefault231

NewDefault231:                                    ; preds = %LeafBlock232
  br label %bb25

bb25:                                             ; preds = %NewDefault231
  store { i1, i1 } %"65_074", { i1, i1 }* %"36_0", align 1
  store %Qubit* %"11_175", %Qubit** %"36_1", align 8
  br label %bb5

bb26:                                             ; preds = %LeafBlock232
  store { i1, i1 } %"65_074", { i1, i1 }* %"20_0", align 1
  store %Qubit* %"11_175", %Qubit** %"20_1", align 8
  br label %bb2

cond_64_case_0:                                   ; preds = %bb3
  %"095" = load i1, i1* %"094", align 1
  store i1 %"095", i1* %"138_0", align 1
  %"138_096" = load i1, i1* %"138_0", align 1
  %39 = insertvalue { i1, i1 } { i1 false, i1 poison }, i1 %"138_096", 1
  store { i1, i1 } %39, { i1, i1 }* %"141_0", align 1
  %"138_097" = load i1, i1* %"138_0", align 1
  %40 = insertvalue { i1, i1 } { i1 false, i1 poison }, i1 %"138_097", 1
  store { i1, i1 } %40, { i1, i1 }* %"140_0", align 1
  %"140_098" = load { i1, i1 }, { i1, i1 }* %"140_0", align 1
  %"141_099" = load { i1, i1 }, { i1, i1 }* %"141_0", align 1
  store { i1, i1 } %"140_098", { i1, i1 }* %"090", align 1
  store { i1, i1 } %"141_099", { i1, i1 }* %"191", align 1
  br label %cond_exit_64

cond_64_case_1:                                   ; preds = %bb4
  %"0101" = load i1, i1* %"0100", align 1
  store i1 %"0101", i1* %"143_0", align 1
  %"143_0102" = load i1, i1* %"143_0", align 1
  store i1 %"143_0102", i1* %"148_0", align 1
  %"148_0103" = load i1, i1* %"148_0", align 1
  store i1 %"148_0103", i1* %"150_0", align 1
  store i1 %"148_0103", i1* %"150_1", align 1
  %"150_0104" = load i1, i1* %"150_0", align 1
  %"150_1105" = load i1, i1* %"150_1", align 1
  store i1 %"150_0104", i1* %"145_0", align 1
  store i1 %"150_1105", i1* %"145_1", align 1
  %"145_1106" = load i1, i1* %"145_1", align 1
  %41 = insertvalue { i1, i1 } { i1 true, i1 poison }, i1 %"145_1106", 1
  store { i1, i1 } %41, { i1, i1 }* %"147_0", align 1
  %"145_0107" = load i1, i1* %"145_0", align 1
  %42 = insertvalue { i1, i1 } { i1 true, i1 poison }, i1 %"145_0107", 1
  store { i1, i1 } %42, { i1, i1 }* %"146_0", align 1
  %"146_0108" = load { i1, i1 }, { i1, i1 }* %"146_0", align 1
  %"147_0109" = load { i1, i1 }, { i1, i1 }* %"147_0", align 1
  store { i1, i1 } %"146_0108", { i1, i1 }* %"090", align 1
  store { i1, i1 } %"147_0109", { i1, i1 }* %"191", align 1
  br label %cond_exit_64

cond_exit_64:                                     ; preds = %cond_64_case_1, %cond_64_case_0
  %"092" = load { i1, i1 }, { i1, i1 }* %"090", align 1
  %"193" = load { i1, i1 }, { i1, i1 }* %"191", align 1
  store { i1, i1 } %"092", { i1, i1 }* %"64_0", align 1
  store { i1, i1 } %"193", { i1, i1 }* %"64_1", align 1
  %"64_0110" = load { i1, i1 }, { i1, i1 }* %"64_0", align 1
  store { i1, i1 } %"64_0110", { i1, i1 }* %"152_0", align 1
  %"152_0111" = load { i1, i1 }, { i1, i1 }* %"152_0", align 1
  %43 = extractvalue { i1, i1 } %"152_0111", 0
  br label %LeafBlock235

LeafBlock235:                                     ; preds = %cond_exit_64
  %SwitchLeaf236 = icmp eq i1 %43, true
  br i1 %SwitchLeaf236, label %bb28, label %NewDefault234

NewDefault234:                                    ; preds = %LeafBlock235
  br label %bb27

bb27:                                             ; preds = %NewDefault234
  %44 = extractvalue { i1, i1 } %"152_0111", 1
  store i1 %44, i1* %"0114", align 1
  br label %cond_154_case_0

bb28:                                             ; preds = %LeafBlock235
  %45 = extractvalue { i1, i1 } %"152_0111", 1
  store i1 %45, i1* %"0117", align 1
  br label %cond_154_case_1

cond_154_case_0:                                  ; preds = %bb27
  %"0115" = load i1, i1* %"0114", align 1
  store i1 %"0115", i1* %"157_0", align 1
  %"157_0116" = load i1, i1* %"157_0", align 1
  store i1 %"157_0116", i1* %"0112", align 1
  br label %cond_exit_154

cond_154_case_1:                                  ; preds = %bb28
  %"0118" = load i1, i1* %"0117", align 1
  store i1 %"0118", i1* %"159_0", align 1
  %"159_0119" = load i1, i1* %"159_0", align 1
  %46 = select i1 %"159_0119", i1 true, i1 false
  store i1 %46, i1* %"161_0", align 1
  %"161_0120" = load i1, i1* %"161_0", align 1
  store i1 %"161_0120", i1* %"0112", align 1
  br label %cond_exit_154

cond_exit_154:                                    ; preds = %cond_154_case_1, %cond_154_case_0
  %"0113" = load i1, i1* %"0112", align 1
  store i1 %"0113", i1* %"154_0", align 1
  %"154_0121" = load i1, i1* %"154_0", align 1
  store i1 %"154_0121", i1* %"25_0", align 1
  %"25_0122" = load i1, i1* %"25_0", align 1
  %"20_0123" = load { i1, i1 }, { i1, i1 }* %"20_0", align 1
  %"64_1124" = load { i1, i1 }, { i1, i1 }* %"64_1", align 1
  br label %LeafBlock238

LeafBlock238:                                     ; preds = %cond_exit_154
  %SwitchLeaf239 = icmp eq i1 %"25_0122", true
  br i1 %SwitchLeaf239, label %bb30, label %NewDefault237

NewDefault237:                                    ; preds = %LeafBlock238
  br label %bb29

bb29:                                             ; preds = %NewDefault237
  store { i1, i1 } %"20_0123", { i1, i1 }* %"0127", align 1
  store { i1, i1 } %"64_1124", { i1, i1 }* %"1128", align 1
  br label %cond_26_case_0

bb30:                                             ; preds = %LeafBlock238
  store { i1, i1 } %"20_0123", { i1, i1 }* %"0134", align 1
  store { i1, i1 } %"64_1124", { i1, i1 }* %"1135", align 1
  br label %cond_26_case_1

cond_26_case_0:                                   ; preds = %bb29
  %"0129" = load { i1, i1 }, { i1, i1 }* %"0127", align 1
  %"1130" = load { i1, i1 }, { i1, i1 }* %"1128", align 1
  store { i1, i1 } %"0129", { i1, i1 }* %"28_0", align 1
  store { i1, i1 } %"1130", { i1, i1 }* %"28_1", align 1
  %"28_0131" = load { i1, i1 }, { i1, i1 }* %"28_0", align 1
  %"28_1132" = load { i1, i1 }, { i1, i1 }* %"28_1", align 1
  %47 = insertvalue { i1, { i1, i1 }, { i1, i1 } } { i1 false, { i1, i1 } poison, { i1, i1 } poison }, { i1, i1 } %"28_0131", 1
  %48 = insertvalue { i1, { i1, i1 }, { i1, i1 } } %47, { i1, i1 } %"28_1132", 2
  store { i1, { i1, i1 }, { i1, i1 } } %48, { i1, { i1, i1 }, { i1, i1 } }* %"30_0", align 1
  %"30_0133" = load { i1, { i1, i1 }, { i1, i1 } }, { i1, { i1, i1 }, { i1, i1 } }* %"30_0", align 1
  store { i1, { i1, i1 }, { i1, i1 } } %"30_0133", { i1, { i1, i1 }, { i1, i1 } }* %"0125", align 1
  br label %cond_exit_26

cond_26_case_1:                                   ; preds = %bb30
  %"0136" = load { i1, i1 }, { i1, i1 }* %"0134", align 1
  %"1137" = load { i1, i1 }, { i1, i1 }* %"1135", align 1
  store { i1, i1 } %"0136", { i1, i1 }* %"32_0", align 1
  store { i1, i1 } %"1137", { i1, i1 }* %"32_1", align 1
  %"32_1138" = load { i1, i1 }, { i1, i1 }* %"32_1", align 1
  %49 = extractvalue { i1, i1 } %"32_1138", 0
  br label %LeafBlock241

LeafBlock241:                                     ; preds = %cond_26_case_1
  %SwitchLeaf242 = icmp eq i1 %49, true
  br i1 %SwitchLeaf242, label %bb32, label %NewDefault240

NewDefault240:                                    ; preds = %LeafBlock241
  br label %bb31

bb31:                                             ; preds = %NewDefault240
  %50 = extractvalue { i1, i1 } %"32_1138", 1
  store i1 %50, i1* %"0139", align 1
  br label %cond_151_case_0

bb32:                                             ; preds = %LeafBlock241
  %51 = extractvalue { i1, i1 } %"32_1138", 1
  store i1 %51, i1* %"0141", align 1
  br label %cond_151_case_1

cond_exit_26:                                     ; preds = %cond_exit_151, %cond_26_case_0
  %"0126" = load { i1, { i1, i1 }, { i1, i1 } }, { i1, { i1, i1 }, { i1, i1 } }* %"0125", align 1
  store { i1, { i1, i1 }, { i1, i1 } } %"0126", { i1, { i1, i1 }, { i1, i1 } }* %"26_0", align 1
  %"26_0146" = load { i1, { i1, i1 }, { i1, i1 } }, { i1, { i1, i1 }, { i1, i1 } }* %"26_0", align 1
  store { i1, { i1, i1 }, { i1, i1 } } %"26_0146", { i1, { i1, i1 }, { i1, i1 } }* %"26_0", align 1
  %"26_0147" = load { i1, { i1, i1 }, { i1, i1 } }, { i1, { i1, i1 }, { i1, i1 } }* %"26_0", align 1
  %52 = extractvalue { i1, { i1, i1 }, { i1, i1 } } %"26_0147", 0
  br label %LeafBlock244

LeafBlock244:                                     ; preds = %cond_exit_26
  %SwitchLeaf245 = icmp eq i1 %52, true
  br i1 %SwitchLeaf245, label %bb34, label %NewDefault243

NewDefault243:                                    ; preds = %LeafBlock244
  br label %bb33

bb33:                                             ; preds = %NewDefault243
  %53 = extractvalue { i1, { i1, i1 }, { i1, i1 } } %"26_0147", 1
  %54 = extractvalue { i1, { i1, i1 }, { i1, i1 } } %"26_0147", 2
  store { i1, i1 } %53, { i1, i1 }* %"47_0", align 1
  store { i1, i1 } %54, { i1, i1 }* %"47_1", align 1
  br label %bb9

bb34:                                             ; preds = %LeafBlock244
  %55 = extractvalue { i1, { i1, i1 }, { i1, i1 } } %"26_0147", 1
  store { i1, i1 } %55, { i1, i1 }* %"41_0", align 1
  br label %bb7

cond_151_case_0:                                  ; preds = %bb31
  %"0140" = load i1, i1* %"0139", align 1
  store i1 %"0140", i1* %"188_0", align 1
  br label %cond_exit_151

cond_151_case_1:                                  ; preds = %bb32
  %"0142" = load i1, i1* %"0141", align 1
  store i1 %"0142", i1* %"190_0", align 1
  %"190_0143" = load i1, i1* %"190_0", align 1
  br label %cond_exit_151

cond_exit_151:                                    ; preds = %cond_151_case_1, %cond_151_case_0
  %"32_0144" = load { i1, i1 }, { i1, i1 }* %"32_0", align 1
  %56 = insertvalue { i1, { i1, i1 }, { i1, i1 } } { i1 true, { i1, i1 } poison, { i1, i1 } poison }, { i1, i1 } %"32_0144", 1
  store { i1, { i1, i1 }, { i1, i1 } } %56, { i1, { i1, i1 }, { i1, i1 } }* %"34_0", align 1
  %"34_0145" = load { i1, { i1, i1 }, { i1, i1 } }, { i1, { i1, i1 }, { i1, i1 } }* %"34_0", align 1
  store { i1, { i1, i1 }, { i1, i1 } } %"34_0145", { i1, { i1, i1 }, { i1, i1 } }* %"0125", align 1
  br label %cond_exit_26

cond_178_case_0:                                  ; preds = %bb14
  %"0190" = load i1, i1* %"0189", align 1
  store i1 %"0190", i1* %"181_0", align 1
  %"181_0191" = load i1, i1* %"181_0", align 1
  store i1 %"181_0191", i1* %"0187", align 1
  br label %cond_exit_178

cond_178_case_1:                                  ; preds = %bb15
  %"0193" = load i1, i1* %"0192", align 1
  store i1 %"0193", i1* %"183_0", align 1
  %"183_0194" = load i1, i1* %"183_0", align 1
  %57 = select i1 %"183_0194", i1 true, i1 false
  store i1 %57, i1* %"185_0", align 1
  %"185_0195" = load i1, i1* %"185_0", align 1
  store i1 %"185_0195", i1* %"0187", align 1
  br label %cond_exit_178

cond_exit_178:                                    ; preds = %cond_178_case_1, %cond_178_case_0
  %"0188" = load i1, i1* %"0187", align 1
  store i1 %"0188", i1* %"178_0", align 1
  %"178_0196" = load i1, i1* %"178_0", align 1
  store i1 %"178_0196", i1* %"60_0", align 1
  store {} undef, {}* %"59_0", align 1
  %"55_0197" = load { i1, i1 }, { i1, i1 }* %"55_0", align 1
  store { i1, i1 } %"55_0197", { i1, i1 }* %"166_0", align 1
  %"166_0198" = load { i1, i1 }, { i1, i1 }* %"166_0", align 1
  %58 = extractvalue { i1, i1 } %"166_0198", 0
  br label %LeafBlock247

LeafBlock247:                                     ; preds = %cond_exit_178
  %SwitchLeaf248 = icmp eq i1 %58, true
  br i1 %SwitchLeaf248, label %bb36, label %NewDefault246

NewDefault246:                                    ; preds = %LeafBlock247
  br label %bb35

bb35:                                             ; preds = %NewDefault246
  %59 = extractvalue { i1, i1 } %"166_0198", 1
  store i1 %59, i1* %"0201", align 1
  br label %cond_168_case_0

bb36:                                             ; preds = %LeafBlock247
  %60 = extractvalue { i1, i1 } %"166_0198", 1
  store i1 %60, i1* %"0204", align 1
  br label %cond_168_case_1

cond_168_case_0:                                  ; preds = %bb35
  %"0202" = load i1, i1* %"0201", align 1
  store i1 %"0202", i1* %"171_0", align 1
  %"171_0203" = load i1, i1* %"171_0", align 1
  store i1 %"171_0203", i1* %"0199", align 1
  br label %cond_exit_168

cond_168_case_1:                                  ; preds = %bb36
  %"0205" = load i1, i1* %"0204", align 1
  store i1 %"0205", i1* %"173_0", align 1
  %"173_0206" = load i1, i1* %"173_0", align 1
  %61 = select i1 %"173_0206", i1 true, i1 false
  store i1 %61, i1* %"175_0", align 1
  %"175_0207" = load i1, i1* %"175_0", align 1
  store i1 %"175_0207", i1* %"0199", align 1
  br label %cond_exit_168

cond_exit_168:                                    ; preds = %cond_168_case_1, %cond_168_case_0
  %"0200" = load i1, i1* %"0199", align 1
  store i1 %"0200", i1* %"168_0", align 1
  %"168_0208" = load i1, i1* %"168_0", align 1
  store i1 %"168_0208", i1* %"57_0", align 1
  %"57_0209" = load i1, i1* %"57_0", align 1
  call void @__quantum__rt__bool_record_output(i1 %"57_0209", i8* getelementptr inbounds ([2 x i8], [2 x i8]* @2, i32 0, i32 0))
  %"60_0210" = load i1, i1* %"60_0", align 1
  call void @__quantum__rt__bool_record_output(i1 %"60_0210", i8* getelementptr inbounds ([2 x i8], [2 x i8]* @3, i32 0, i32 0))
  %"63_0211" = load {}, {}* %"63_0", align 1
  store {} %"63_0211", {}* %"63_0", align 1
  %"63_0212" = load {}, {}* %"63_0", align 1
  br label %bb37

bb37:                                             ; preds = %cond_exit_168
  br label %bb16
}

declare %Qubit* @__quantum__rt__qubit_allocate()

declare void @abort()

declare void @__quantum__qis__phasedx__body(double, double, %Qubit*)

declare void @__quantum__qis__rz__body(double, %Qubit*)

declare %Result* @__QIR__CONV_Qubit_TO_Result(%Qubit*)

declare void @__quantum__qis__mz__body(%Qubit*, %Result* writeonly) #1

declare i1 @__quantum__rt__read_result(%Result* readonly)

declare void @__quantum__rt__bool_record_output(i1, i8*)

declare void @__quantum__rt__initialize(i8*)

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="2" "required_num_results"="3" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
