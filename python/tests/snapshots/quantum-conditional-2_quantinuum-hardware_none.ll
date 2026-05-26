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
  %"20_0" = alloca { i1, i1 }, align 8
  %"20_1" = alloca ptr, align 8
  %"36_0" = alloca { i1, i1 }, align 8
  %"36_1" = alloca ptr, align 8
  %"41_0" = alloca { i1, i1 }, align 8
  %"47_0" = alloca { i1, i1 }, align 8
  %"47_1" = alloca { i1, i1 }, align 8
  %"51_0" = alloca { i1, i1 }, align 8
  %"51_1" = alloca { i1, i1 }, align 8
  %"55_0" = alloca { i1, i1 }, align 8
  %"55_1" = alloca { i1, i1 }, align 8
  %"17_0" = alloca i1, align 1
  %"65_0" = alloca { i1, i1 }, align 8
  %"11_1" = alloca ptr, align 8
  %"8_0" = alloca ptr, align 8
  %"139_0" = alloca { i1, ptr }, align 8
  %"138_0" = alloca ptr, align 8
  %"0" = alloca ptr, align 8
  %"45_0" = alloca { i32, ptr }, align 8
  %"39_0" = alloca ptr, align 8
  %"05" = alloca ptr, align 8
  %"23_0" = alloca ptr, align 8
  %"9_0" = alloca ptr, align 8
  %"13_0" = alloca { i1, ptr }, align 8
  %"228_0" = alloca ptr, align 8
  %"010" = alloca ptr, align 8
  %"234_0" = alloca { i32, ptr }, align 8
  %"235_0" = alloca ptr, align 8
  %"014" = alloca ptr, align 8
  %"236_0" = alloca ptr, align 8
  %"10_0" = alloca { ptr, ptr }, align 8
  %"11_0" = alloca ptr, align 8
  %"12_0" = alloca ptr, align 8
  %"238_0" = alloca ptr, align 8
  %"245_0" = alloca double, align 8
  %"243_0" = alloca double, align 8
  %"246_0" = alloca ptr, align 8
  %"241_0" = alloca double, align 8
  %"247_0" = alloca ptr, align 8
  %"14_0" = alloca { i1, i1 }, align 8
  %"119_0" = alloca ptr, align 8
  %"121_0" = alloca i1, align 1
  %"122_0" = alloca { i1, i1 }, align 8
  %"65_1" = alloca { i1, i1 }, align 8
  %"033" = alloca { i1, i1 }, align 8
  %"1" = alloca { i1, i1 }, align 8
  %"036" = alloca i1, align 1
  %"124_0" = alloca i1, align 1
  %"127_0" = alloca { i1, i1 }, align 8
  %"126_0" = alloca { i1, i1 }, align 8
  %"042" = alloca i1, align 1
  %"129_0" = alloca i1, align 1
  %"131_0" = alloca i1, align 1
  %"131_1" = alloca i1, align 1
  %"134_0" = alloca i1, align 1
  %"136_0" = alloca i1, align 1
  %"136_1" = alloca i1, align 1
  %"133_0" = alloca { i1, i1 }, align 8
  %"132_0" = alloca { i1, i1 }, align 8
  %"146_0" = alloca { i1, i1 }, align 8
  %"148_0" = alloca i1, align 1
  %"054" = alloca i1, align 1
  %"056" = alloca i1, align 1
  %"151_0" = alloca i1, align 1
  %"059" = alloca i1, align 1
  %"153_0" = alloca i1, align 1
  %"155_0" = alloca i1, align 1
  %"26_0" = alloca { i1, { i1, i1 }, { i1, i1 } }, align 8
  %"22_0" = alloca ptr, align 8
  %"248_0" = alloca ptr, align 8
  %"255_0" = alloca double, align 8
  %"253_0" = alloca double, align 8
  %"256_0" = alloca ptr, align 8
  %"251_0" = alloca double, align 8
  %"257_0" = alloca ptr, align 8
  %"24_0" = alloca { i1, i1 }, align 8
  %"156_0" = alloca ptr, align 8
  %"158_0" = alloca i1, align 1
  %"159_0" = alloca { i1, i1 }, align 8
  %"64_0" = alloca { i1, i1 }, align 8
  %"64_1" = alloca { i1, i1 }, align 8
  %"084" = alloca { i1, i1 }, align 8
  %"185" = alloca { i1, i1 }, align 8
  %"088" = alloca i1, align 1
  %"161_0" = alloca i1, align 1
  %"164_0" = alloca { i1, i1 }, align 8
  %"163_0" = alloca { i1, i1 }, align 8
  %"094" = alloca i1, align 1
  %"166_0" = alloca i1, align 1
  %"168_0" = alloca i1, align 1
  %"168_1" = alloca i1, align 1
  %"171_0" = alloca i1, align 1
  %"173_0" = alloca i1, align 1
  %"173_1" = alloca i1, align 1
  %"170_0" = alloca { i1, i1 }, align 8
  %"169_0" = alloca { i1, i1 }, align 8
  %"25_0" = alloca i1, align 1
  %"175_0" = alloca { i1, i1 }, align 8
  %"177_0" = alloca i1, align 1
  %"0106" = alloca i1, align 1
  %"0108" = alloca i1, align 1
  %"180_0" = alloca i1, align 1
  %"0111" = alloca i1, align 1
  %"182_0" = alloca i1, align 1
  %"184_0" = alloca i1, align 1
  %"0119" = alloca { i1, { i1, i1 }, { i1, i1 } }, align 8
  %"0121" = alloca { i1, i1 }, align 8
  %"1122" = alloca { i1, i1 }, align 8
  %"28_0" = alloca { i1, i1 }, align 8
  %"28_1" = alloca { i1, i1 }, align 8
  %"30_0" = alloca { i1, { i1, i1 }, { i1, i1 } }, align 8
  %"0128" = alloca { i1, i1 }, align 8
  %"1129" = alloca { i1, i1 }, align 8
  %"32_0" = alloca { i1, i1 }, align 8
  %"32_1" = alloca { i1, i1 }, align 8
  %"0133" = alloca i1, align 1
  %"211_0" = alloca i1, align 1
  %"0135" = alloca i1, align 1
  %"213_0" = alloca i1, align 1
  %"34_0" = alloca { i1, { i1, i1 }, { i1, i1 } }, align 8
  %"217_0" = alloca {}, align 8
  %"38_0" = alloca { i1, i1 }, align 8
  %"185_0" = alloca ptr, align 8
  %"187_0" = alloca i1, align 1
  %"188_0" = alloca { i1, i1 }, align 8
  %"219_0" = alloca {}, align 8
  %"43_0" = alloca { i1, i1 }, align 8
  %"221_0" = alloca {}, align 8
  %"223_0" = alloca {}, align 8
  %"225_0" = alloca {}, align 8
  %"60_0" = alloca i1, align 1
  %"199_0" = alloca { i1, i1 }, align 8
  %"201_0" = alloca i1, align 1
  %"0181" = alloca i1, align 1
  %"0183" = alloca i1, align 1
  %"204_0" = alloca i1, align 1
  %"227_0" = alloca i1, align 1
  %"0186" = alloca i1, align 1
  %"206_0" = alloca i1, align 1
  %"208_0" = alloca i1, align 1
  %"57_0" = alloca i1, align 1
  %"189_0" = alloca { i1, i1 }, align 8
  %"191_0" = alloca i1, align 1
  %"0193" = alloca i1, align 1
  %"0195" = alloca i1, align 1
  %"194_0" = alloca i1, align 1
  %"0198" = alloca i1, align 1
  %"196_0" = alloca i1, align 1
  %"198_0" = alloca i1, align 1
  br label %entry_block

entry_block:                                      ; preds = %alloca_block
  br label %bb

bb:                                               ; preds = %entry_block
  %0 = insertvalue { i1, ptr } { i1 true, ptr poison }, ptr null, 1
  store { i1, ptr } %0, ptr %"139_0", align 8
  %"139_01" = load { i1, ptr }, ptr %"139_0", align 8
  %1 = extractvalue { i1, ptr } %"139_01", 0
  br label %LeafBlock

LeafBlock:                                        ; preds = %bb
  %SwitchLeaf = icmp eq i1 %1, true
  br i1 %SwitchLeaf, label %bb1, label %bb0

bb0:                                              ; preds = %LeafBlock
  br label %cond_138_case_0

bb1:                                              ; preds = %LeafBlock
  %2 = extractvalue { i1, ptr } %"139_01", 1
  store ptr %2, ptr %"05", align 8
  br label %cond_138_case_1

bb2:                                              ; preds = %bb24
  %"20_070" = load { i1, i1 }, ptr %"20_0", align 1
  %"20_171" = load ptr, ptr %"20_1", align 8
  store { i1, i1 } %"20_070", ptr %"20_0", align 1
  store ptr %"20_171", ptr %"20_1", align 8
  %"20_172" = load ptr, ptr %"20_1", align 8
  store ptr %"20_172", ptr %"248_0", align 8
  store double 0xBFF921FB54442D18, ptr %"255_0", align 8
  store double 0x3FF921FB54442D18, ptr %"253_0", align 8
  %"248_073" = load ptr, ptr %"248_0", align 8
  %"253_074" = load double, ptr %"253_0", align 8
  %"255_075" = load double, ptr %"255_0", align 8
  call void @__quantum__qis__phasedx__body(double %"253_074", double %"255_075", ptr %"248_073")
  store ptr %"248_073", ptr %"256_0", align 8
  store double 0x400921FB54442D18, ptr %"251_0", align 8
  %"256_076" = load ptr, ptr %"256_0", align 8
  %"251_077" = load double, ptr %"251_0", align 8
  call void @__quantum__qis__rz__body(double %"251_077", ptr %"256_076")
  store ptr %"256_076", ptr %"257_0", align 8
  %"257_078" = load ptr, ptr %"257_0", align 8
  store ptr %"257_078", ptr %"22_0", align 8
  %"22_079" = load ptr, ptr %"22_0", align 8
  store ptr %"22_079", ptr %"156_0", align 8
  %"156_080" = load ptr, ptr %"156_0", align 8
  call void @__quantum__qis__mz__body(ptr %"156_080", ptr null)
  %3 = call i1 @__quantum__rt__read_result(ptr null)
  %4 = select i1 %3, i1 true, i1 false
  store i1 %4, ptr %"158_0", align 1
  %"158_081" = load i1, ptr %"158_0", align 1
  %5 = insertvalue { i1, i1 } { i1 true, i1 poison }, i1 %"158_081", 1
  store { i1, i1 } %5, ptr %"159_0", align 1
  %"159_082" = load { i1, i1 }, ptr %"159_0", align 1
  store { i1, i1 } %"159_082", ptr %"24_0", align 1
  %"24_083" = load { i1, i1 }, ptr %"24_0", align 1
  %6 = extractvalue { i1, i1 } %"24_083", 0
  br label %LeafBlock207

LeafBlock207:                                     ; preds = %bb2
  %SwitchLeaf208 = icmp eq i1 %6, true
  br i1 %SwitchLeaf208, label %bb4, label %bb3

bb3:                                              ; preds = %LeafBlock207
  %7 = extractvalue { i1, i1 } %"24_083", 1
  store i1 %7, ptr %"088", align 1
  br label %cond_64_case_0

bb4:                                              ; preds = %LeafBlock207
  %8 = extractvalue { i1, i1 } %"24_083", 1
  store i1 %8, ptr %"094", align 1
  br label %cond_64_case_1

bb5:                                              ; preds = %bb23
  %"36_0142" = load { i1, i1 }, ptr %"36_0", align 1
  %"36_1143" = load ptr, ptr %"36_1", align 8
  store { i1, i1 } %"36_0142", ptr %"36_0", align 1
  store ptr %"36_1143", ptr %"36_1", align 8
  store {} undef, ptr %"217_0", align 1
  %"36_1144" = load ptr, ptr %"36_1", align 8
  store ptr %"36_1144", ptr %"185_0", align 8
  %"185_0145" = load ptr, ptr %"185_0", align 8
  call void @__quantum__qis__mz__body(ptr %"185_0145", ptr inttoptr (i64 1 to ptr))
  %9 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 1 to ptr))
  %10 = select i1 %9, i1 true, i1 false
  store i1 %10, ptr %"187_0", align 1
  %"187_0146" = load i1, ptr %"187_0", align 1
  %11 = insertvalue { i1, i1 } { i1 true, i1 poison }, i1 %"187_0146", 1
  store { i1, i1 } %11, ptr %"188_0", align 1
  %"188_0147" = load { i1, i1 }, ptr %"188_0", align 1
  store { i1, i1 } %"188_0147", ptr %"38_0", align 1
  %"217_0148" = load {}, ptr %"217_0", align 1
  %"36_0149" = load { i1, i1 }, ptr %"36_0", align 1
  %"38_0150" = load { i1, i1 }, ptr %"38_0", align 1
  store {} %"217_0148", ptr %"217_0", align 1
  store { i1, i1 } %"36_0149", ptr %"36_0", align 1
  store { i1, i1 } %"38_0150", ptr %"38_0", align 1
  %"217_0151" = load {}, ptr %"217_0", align 1
  %"36_0152" = load { i1, i1 }, ptr %"36_0", align 1
  %"38_0153" = load { i1, i1 }, ptr %"38_0", align 1
  br label %bb6

bb6:                                              ; preds = %bb5
  store { i1, i1 } %"36_0152", ptr %"55_0", align 1
  store { i1, i1 } %"38_0153", ptr %"55_1", align 1
  br label %bb13

bb7:                                              ; preds = %bb32
  %"41_0154" = load { i1, i1 }, ptr %"41_0", align 1
  store { i1, i1 } %"41_0154", ptr %"41_0", align 1
  store {} undef, ptr %"219_0", align 1
  store { i1, i1 } zeroinitializer, ptr %"43_0", align 1
  %"219_0155" = load {}, ptr %"219_0", align 1
  %"41_0156" = load { i1, i1 }, ptr %"41_0", align 1
  %"43_0157" = load { i1, i1 }, ptr %"43_0", align 1
  store {} %"219_0155", ptr %"219_0", align 1
  store { i1, i1 } %"41_0156", ptr %"41_0", align 1
  store { i1, i1 } %"43_0157", ptr %"43_0", align 1
  %"219_0158" = load {}, ptr %"219_0", align 1
  %"41_0159" = load { i1, i1 }, ptr %"41_0", align 1
  %"43_0160" = load { i1, i1 }, ptr %"43_0", align 1
  br label %bb8

bb8:                                              ; preds = %bb7
  store { i1, i1 } %"41_0159", ptr %"51_0", align 1
  store { i1, i1 } %"43_0160", ptr %"51_1", align 1
  br label %bb11

bb9:                                              ; preds = %bb31
  %"47_0161" = load { i1, i1 }, ptr %"47_0", align 1
  %"47_1162" = load { i1, i1 }, ptr %"47_1", align 1
  store { i1, i1 } %"47_0161", ptr %"47_0", align 1
  store { i1, i1 } %"47_1162", ptr %"47_1", align 1
  store {} undef, ptr %"221_0", align 1
  %"221_0163" = load {}, ptr %"221_0", align 1
  %"47_0164" = load { i1, i1 }, ptr %"47_0", align 1
  %"47_1165" = load { i1, i1 }, ptr %"47_1", align 1
  store {} %"221_0163", ptr %"221_0", align 1
  store { i1, i1 } %"47_0164", ptr %"47_0", align 1
  store { i1, i1 } %"47_1165", ptr %"47_1", align 1
  %"221_0166" = load {}, ptr %"221_0", align 1
  %"47_0167" = load { i1, i1 }, ptr %"47_0", align 1
  %"47_1168" = load { i1, i1 }, ptr %"47_1", align 1
  br label %bb10

bb10:                                             ; preds = %bb9
  store { i1, i1 } %"47_0167", ptr %"51_0", align 1
  store { i1, i1 } %"47_1168", ptr %"51_1", align 1
  br label %bb11

bb11:                                             ; preds = %bb10, %bb8
  %"51_0169" = load { i1, i1 }, ptr %"51_0", align 1
  %"51_1170" = load { i1, i1 }, ptr %"51_1", align 1
  store { i1, i1 } %"51_0169", ptr %"51_0", align 1
  store { i1, i1 } %"51_1170", ptr %"51_1", align 1
  store {} undef, ptr %"223_0", align 1
  %"223_0171" = load {}, ptr %"223_0", align 1
  %"51_0172" = load { i1, i1 }, ptr %"51_0", align 1
  %"51_1173" = load { i1, i1 }, ptr %"51_1", align 1
  store {} %"223_0171", ptr %"223_0", align 1
  store { i1, i1 } %"51_0172", ptr %"51_0", align 1
  store { i1, i1 } %"51_1173", ptr %"51_1", align 1
  %"223_0174" = load {}, ptr %"223_0", align 1
  %"51_0175" = load { i1, i1 }, ptr %"51_0", align 1
  %"51_1176" = load { i1, i1 }, ptr %"51_1", align 1
  br label %bb12

bb12:                                             ; preds = %bb11
  store { i1, i1 } %"51_0175", ptr %"55_0", align 1
  store { i1, i1 } %"51_1176", ptr %"55_1", align 1
  br label %bb13

bb13:                                             ; preds = %bb12, %bb6
  %"55_0177" = load { i1, i1 }, ptr %"55_0", align 1
  %"55_1178" = load { i1, i1 }, ptr %"55_1", align 1
  store { i1, i1 } %"55_0177", ptr %"55_0", align 1
  store { i1, i1 } %"55_1178", ptr %"55_1", align 1
  store {} undef, ptr %"225_0", align 1
  %"55_1179" = load { i1, i1 }, ptr %"55_1", align 1
  store { i1, i1 } %"55_1179", ptr %"199_0", align 1
  %"199_0180" = load { i1, i1 }, ptr %"199_0", align 1
  %12 = extractvalue { i1, i1 } %"199_0180", 0
  br label %LeafBlock209

LeafBlock209:                                     ; preds = %bb13
  %SwitchLeaf210 = icmp eq i1 %12, true
  br i1 %SwitchLeaf210, label %bb15, label %bb14

bb14:                                             ; preds = %LeafBlock209
  %13 = extractvalue { i1, i1 } %"199_0180", 1
  store i1 %13, ptr %"0183", align 1
  br label %cond_201_case_0

bb15:                                             ; preds = %LeafBlock209
  %14 = extractvalue { i1, i1 } %"199_0180", 1
  store i1 %14, ptr %"0186", align 1
  br label %cond_201_case_1

bb16:                                             ; preds = %bb35
  ret void

cond_138_case_0:                                  ; preds = %bb0
  store { i32, ptr } { i32 1, ptr @0 }, ptr %"45_0", align 8
  %"45_03" = load { i32, ptr }, ptr %"45_0", align 8
  call void @abort()
  store ptr null, ptr %"39_0", align 8
  %"39_04" = load ptr, ptr %"39_0", align 8
  store ptr %"39_04", ptr %"0", align 8
  br label %cond_exit_138

cond_138_case_1:                                  ; preds = %bb1
  %"06" = load ptr, ptr %"05", align 8
  store ptr %"06", ptr %"23_0", align 8
  %"23_07" = load ptr, ptr %"23_0", align 8
  store ptr %"23_07", ptr %"0", align 8
  br label %cond_exit_138

cond_exit_138:                                    ; preds = %cond_138_case_1, %cond_138_case_0
  %"02" = load ptr, ptr %"0", align 8
  store ptr %"02", ptr %"138_0", align 8
  %"138_08" = load ptr, ptr %"138_0", align 8
  store ptr %"138_08", ptr %"8_0", align 8
  %15 = insertvalue { i1, ptr } { i1 true, ptr poison }, ptr inttoptr (i64 1 to ptr), 1
  store { i1, ptr } %15, ptr %"13_0", align 8
  %"13_09" = load { i1, ptr }, ptr %"13_0", align 8
  %16 = extractvalue { i1, ptr } %"13_09", 0
  br label %LeafBlock211

LeafBlock211:                                     ; preds = %cond_exit_138
  %SwitchLeaf212 = icmp eq i1 %16, true
  br i1 %SwitchLeaf212, label %bb18, label %bb17

bb17:                                             ; preds = %LeafBlock211
  br label %cond_228_case_0

bb18:                                             ; preds = %LeafBlock211
  %17 = extractvalue { i1, ptr } %"13_09", 1
  store ptr %17, ptr %"014", align 8
  br label %cond_228_case_1

cond_228_case_0:                                  ; preds = %bb17
  store { i32, ptr } { i32 1, ptr @1 }, ptr %"234_0", align 8
  %"234_012" = load { i32, ptr }, ptr %"234_0", align 8
  call void @abort()
  store ptr null, ptr %"235_0", align 8
  %"235_013" = load ptr, ptr %"235_0", align 8
  store ptr %"235_013", ptr %"010", align 8
  br label %cond_exit_228

cond_228_case_1:                                  ; preds = %bb18
  %"015" = load ptr, ptr %"014", align 8
  store ptr %"015", ptr %"236_0", align 8
  %"236_016" = load ptr, ptr %"236_0", align 8
  store ptr %"236_016", ptr %"010", align 8
  br label %cond_exit_228

cond_exit_228:                                    ; preds = %cond_228_case_1, %cond_228_case_0
  %"011" = load ptr, ptr %"010", align 8
  store ptr %"011", ptr %"228_0", align 8
  %"228_017" = load ptr, ptr %"228_0", align 8
  store ptr %"228_017", ptr %"9_0", align 8
  %"8_018" = load ptr, ptr %"8_0", align 8
  %"9_019" = load ptr, ptr %"9_0", align 8
  %18 = insertvalue { ptr, ptr } poison, ptr %"8_018", 0
  %19 = insertvalue { ptr, ptr } %18, ptr %"9_019", 1
  store { ptr, ptr } %19, ptr %"10_0", align 8
  %"10_020" = load { ptr, ptr }, ptr %"10_0", align 8
  %20 = extractvalue { ptr, ptr } %"10_020", 0
  %21 = extractvalue { ptr, ptr } %"10_020", 1
  store ptr %20, ptr %"11_0", align 8
  store ptr %21, ptr %"11_1", align 8
  %"11_021" = load ptr, ptr %"11_0", align 8
  store ptr %"11_021", ptr %"238_0", align 8
  store double 0xBFF921FB54442D18, ptr %"245_0", align 8
  store double 0x3FF921FB54442D18, ptr %"243_0", align 8
  %"238_022" = load ptr, ptr %"238_0", align 8
  %"243_023" = load double, ptr %"243_0", align 8
  %"245_024" = load double, ptr %"245_0", align 8
  call void @__quantum__qis__phasedx__body(double %"243_023", double %"245_024", ptr %"238_022")
  store ptr %"238_022", ptr %"246_0", align 8
  store double 0x400921FB54442D18, ptr %"241_0", align 8
  %"246_025" = load ptr, ptr %"246_0", align 8
  %"241_026" = load double, ptr %"241_0", align 8
  call void @__quantum__qis__rz__body(double %"241_026", ptr %"246_025")
  store ptr %"246_025", ptr %"247_0", align 8
  %"247_027" = load ptr, ptr %"247_0", align 8
  store ptr %"247_027", ptr %"12_0", align 8
  %"12_028" = load ptr, ptr %"12_0", align 8
  store ptr %"12_028", ptr %"119_0", align 8
  %"119_029" = load ptr, ptr %"119_0", align 8
  call void @__quantum__qis__mz__body(ptr %"119_029", ptr inttoptr (i64 2 to ptr))
  %22 = call i1 @__quantum__rt__read_result(ptr inttoptr (i64 2 to ptr))
  %23 = select i1 %22, i1 true, i1 false
  store i1 %23, ptr %"121_0", align 1
  %"121_030" = load i1, ptr %"121_0", align 1
  %24 = insertvalue { i1, i1 } { i1 true, i1 poison }, i1 %"121_030", 1
  store { i1, i1 } %24, ptr %"122_0", align 1
  %"122_031" = load { i1, i1 }, ptr %"122_0", align 1
  store { i1, i1 } %"122_031", ptr %"14_0", align 1
  %"14_032" = load { i1, i1 }, ptr %"14_0", align 1
  %25 = extractvalue { i1, i1 } %"14_032", 0
  br label %LeafBlock213

LeafBlock213:                                     ; preds = %cond_exit_228
  %SwitchLeaf214 = icmp eq i1 %25, true
  br i1 %SwitchLeaf214, label %bb20, label %bb19

bb19:                                             ; preds = %LeafBlock213
  %26 = extractvalue { i1, i1 } %"14_032", 1
  store i1 %26, ptr %"036", align 1
  br label %cond_65_case_0

bb20:                                             ; preds = %LeafBlock213
  %27 = extractvalue { i1, i1 } %"14_032", 1
  store i1 %27, ptr %"042", align 1
  br label %cond_65_case_1

cond_65_case_0:                                   ; preds = %bb19
  %"037" = load i1, ptr %"036", align 1
  store i1 %"037", ptr %"124_0", align 1
  %"124_038" = load i1, ptr %"124_0", align 1
  %28 = insertvalue { i1, i1 } { i1 false, i1 poison }, i1 %"124_038", 1
  store { i1, i1 } %28, ptr %"127_0", align 1
  %"124_039" = load i1, ptr %"124_0", align 1
  %29 = insertvalue { i1, i1 } { i1 false, i1 poison }, i1 %"124_039", 1
  store { i1, i1 } %29, ptr %"126_0", align 1
  %"126_040" = load { i1, i1 }, ptr %"126_0", align 1
  %"127_041" = load { i1, i1 }, ptr %"127_0", align 1
  store { i1, i1 } %"126_040", ptr %"033", align 1
  store { i1, i1 } %"127_041", ptr %"1", align 1
  br label %cond_exit_65

cond_65_case_1:                                   ; preds = %bb20
  %"043" = load i1, ptr %"042", align 1
  store i1 %"043", ptr %"129_0", align 1
  %"129_044" = load i1, ptr %"129_0", align 1
  store i1 %"129_044", ptr %"134_0", align 1
  %"134_045" = load i1, ptr %"134_0", align 1
  store i1 %"134_045", ptr %"136_0", align 1
  store i1 %"134_045", ptr %"136_1", align 1
  %"136_046" = load i1, ptr %"136_0", align 1
  %"136_147" = load i1, ptr %"136_1", align 1
  store i1 %"136_046", ptr %"131_0", align 1
  store i1 %"136_147", ptr %"131_1", align 1
  %"131_148" = load i1, ptr %"131_1", align 1
  %30 = insertvalue { i1, i1 } { i1 true, i1 poison }, i1 %"131_148", 1
  store { i1, i1 } %30, ptr %"133_0", align 1
  %"131_049" = load i1, ptr %"131_0", align 1
  %31 = insertvalue { i1, i1 } { i1 true, i1 poison }, i1 %"131_049", 1
  store { i1, i1 } %31, ptr %"132_0", align 1
  %"132_050" = load { i1, i1 }, ptr %"132_0", align 1
  %"133_051" = load { i1, i1 }, ptr %"133_0", align 1
  store { i1, i1 } %"132_050", ptr %"033", align 1
  store { i1, i1 } %"133_051", ptr %"1", align 1
  br label %cond_exit_65

cond_exit_65:                                     ; preds = %cond_65_case_1, %cond_65_case_0
  %"034" = load { i1, i1 }, ptr %"033", align 1
  %"135" = load { i1, i1 }, ptr %"1", align 1
  store { i1, i1 } %"034", ptr %"65_0", align 1
  store { i1, i1 } %"135", ptr %"65_1", align 1
  %"65_152" = load { i1, i1 }, ptr %"65_1", align 1
  store { i1, i1 } %"65_152", ptr %"146_0", align 1
  %"146_053" = load { i1, i1 }, ptr %"146_0", align 1
  %32 = extractvalue { i1, i1 } %"146_053", 0
  br label %LeafBlock215

LeafBlock215:                                     ; preds = %cond_exit_65
  %SwitchLeaf216 = icmp eq i1 %32, true
  br i1 %SwitchLeaf216, label %bb22, label %bb21

bb21:                                             ; preds = %LeafBlock215
  %33 = extractvalue { i1, i1 } %"146_053", 1
  store i1 %33, ptr %"056", align 1
  br label %cond_148_case_0

bb22:                                             ; preds = %LeafBlock215
  %34 = extractvalue { i1, i1 } %"146_053", 1
  store i1 %34, ptr %"059", align 1
  br label %cond_148_case_1

cond_148_case_0:                                  ; preds = %bb21
  %"057" = load i1, ptr %"056", align 1
  store i1 %"057", ptr %"151_0", align 1
  %"151_058" = load i1, ptr %"151_0", align 1
  store i1 %"151_058", ptr %"054", align 1
  br label %cond_exit_148

cond_148_case_1:                                  ; preds = %bb22
  %"060" = load i1, ptr %"059", align 1
  store i1 %"060", ptr %"153_0", align 1
  %"153_061" = load i1, ptr %"153_0", align 1
  %35 = select i1 %"153_061", i1 true, i1 false
  store i1 %35, ptr %"155_0", align 1
  %"155_062" = load i1, ptr %"155_0", align 1
  store i1 %"155_062", ptr %"054", align 1
  br label %cond_exit_148

cond_exit_148:                                    ; preds = %cond_148_case_1, %cond_148_case_0
  %"055" = load i1, ptr %"054", align 1
  store i1 %"055", ptr %"148_0", align 1
  %"148_063" = load i1, ptr %"148_0", align 1
  store i1 %"148_063", ptr %"17_0", align 1
  %"17_064" = load i1, ptr %"17_0", align 1
  %"65_065" = load { i1, i1 }, ptr %"65_0", align 1
  %"11_166" = load ptr, ptr %"11_1", align 8
  store i1 %"17_064", ptr %"17_0", align 1
  store { i1, i1 } %"65_065", ptr %"65_0", align 1
  store ptr %"11_166", ptr %"11_1", align 8
  %"17_067" = load i1, ptr %"17_0", align 1
  %"65_068" = load { i1, i1 }, ptr %"65_0", align 1
  %"11_169" = load ptr, ptr %"11_1", align 8
  br label %LeafBlock217

LeafBlock217:                                     ; preds = %cond_exit_148
  %SwitchLeaf218 = icmp eq i1 %"17_067", true
  br i1 %SwitchLeaf218, label %bb24, label %bb23

bb23:                                             ; preds = %LeafBlock217
  store { i1, i1 } %"65_068", ptr %"36_0", align 1
  store ptr %"11_169", ptr %"36_1", align 8
  br label %bb5

bb24:                                             ; preds = %LeafBlock217
  store { i1, i1 } %"65_068", ptr %"20_0", align 1
  store ptr %"11_169", ptr %"20_1", align 8
  br label %bb2

cond_64_case_0:                                   ; preds = %bb3
  %"089" = load i1, ptr %"088", align 1
  store i1 %"089", ptr %"161_0", align 1
  %"161_090" = load i1, ptr %"161_0", align 1
  %36 = insertvalue { i1, i1 } { i1 false, i1 poison }, i1 %"161_090", 1
  store { i1, i1 } %36, ptr %"164_0", align 1
  %"161_091" = load i1, ptr %"161_0", align 1
  %37 = insertvalue { i1, i1 } { i1 false, i1 poison }, i1 %"161_091", 1
  store { i1, i1 } %37, ptr %"163_0", align 1
  %"163_092" = load { i1, i1 }, ptr %"163_0", align 1
  %"164_093" = load { i1, i1 }, ptr %"164_0", align 1
  store { i1, i1 } %"163_092", ptr %"084", align 1
  store { i1, i1 } %"164_093", ptr %"185", align 1
  br label %cond_exit_64

cond_64_case_1:                                   ; preds = %bb4
  %"095" = load i1, ptr %"094", align 1
  store i1 %"095", ptr %"166_0", align 1
  %"166_096" = load i1, ptr %"166_0", align 1
  store i1 %"166_096", ptr %"171_0", align 1
  %"171_097" = load i1, ptr %"171_0", align 1
  store i1 %"171_097", ptr %"173_0", align 1
  store i1 %"171_097", ptr %"173_1", align 1
  %"173_098" = load i1, ptr %"173_0", align 1
  %"173_199" = load i1, ptr %"173_1", align 1
  store i1 %"173_098", ptr %"168_0", align 1
  store i1 %"173_199", ptr %"168_1", align 1
  %"168_1100" = load i1, ptr %"168_1", align 1
  %38 = insertvalue { i1, i1 } { i1 true, i1 poison }, i1 %"168_1100", 1
  store { i1, i1 } %38, ptr %"170_0", align 1
  %"168_0101" = load i1, ptr %"168_0", align 1
  %39 = insertvalue { i1, i1 } { i1 true, i1 poison }, i1 %"168_0101", 1
  store { i1, i1 } %39, ptr %"169_0", align 1
  %"169_0102" = load { i1, i1 }, ptr %"169_0", align 1
  %"170_0103" = load { i1, i1 }, ptr %"170_0", align 1
  store { i1, i1 } %"169_0102", ptr %"084", align 1
  store { i1, i1 } %"170_0103", ptr %"185", align 1
  br label %cond_exit_64

cond_exit_64:                                     ; preds = %cond_64_case_1, %cond_64_case_0
  %"086" = load { i1, i1 }, ptr %"084", align 1
  %"187" = load { i1, i1 }, ptr %"185", align 1
  store { i1, i1 } %"086", ptr %"64_0", align 1
  store { i1, i1 } %"187", ptr %"64_1", align 1
  %"64_0104" = load { i1, i1 }, ptr %"64_0", align 1
  store { i1, i1 } %"64_0104", ptr %"175_0", align 1
  %"175_0105" = load { i1, i1 }, ptr %"175_0", align 1
  %40 = extractvalue { i1, i1 } %"175_0105", 0
  br label %LeafBlock219

LeafBlock219:                                     ; preds = %cond_exit_64
  %SwitchLeaf220 = icmp eq i1 %40, true
  br i1 %SwitchLeaf220, label %bb26, label %bb25

bb25:                                             ; preds = %LeafBlock219
  %41 = extractvalue { i1, i1 } %"175_0105", 1
  store i1 %41, ptr %"0108", align 1
  br label %cond_177_case_0

bb26:                                             ; preds = %LeafBlock219
  %42 = extractvalue { i1, i1 } %"175_0105", 1
  store i1 %42, ptr %"0111", align 1
  br label %cond_177_case_1

cond_177_case_0:                                  ; preds = %bb25
  %"0109" = load i1, ptr %"0108", align 1
  store i1 %"0109", ptr %"180_0", align 1
  %"180_0110" = load i1, ptr %"180_0", align 1
  store i1 %"180_0110", ptr %"0106", align 1
  br label %cond_exit_177

cond_177_case_1:                                  ; preds = %bb26
  %"0112" = load i1, ptr %"0111", align 1
  store i1 %"0112", ptr %"182_0", align 1
  %"182_0113" = load i1, ptr %"182_0", align 1
  %43 = select i1 %"182_0113", i1 true, i1 false
  store i1 %43, ptr %"184_0", align 1
  %"184_0114" = load i1, ptr %"184_0", align 1
  store i1 %"184_0114", ptr %"0106", align 1
  br label %cond_exit_177

cond_exit_177:                                    ; preds = %cond_177_case_1, %cond_177_case_0
  %"0107" = load i1, ptr %"0106", align 1
  store i1 %"0107", ptr %"177_0", align 1
  %"177_0115" = load i1, ptr %"177_0", align 1
  store i1 %"177_0115", ptr %"25_0", align 1
  %"25_0116" = load i1, ptr %"25_0", align 1
  %"20_0117" = load { i1, i1 }, ptr %"20_0", align 1
  %"64_1118" = load { i1, i1 }, ptr %"64_1", align 1
  br label %LeafBlock221

LeafBlock221:                                     ; preds = %cond_exit_177
  %SwitchLeaf222 = icmp eq i1 %"25_0116", true
  br i1 %SwitchLeaf222, label %bb28, label %bb27

bb27:                                             ; preds = %LeafBlock221
  store { i1, i1 } %"20_0117", ptr %"0121", align 1
  store { i1, i1 } %"64_1118", ptr %"1122", align 1
  br label %cond_26_case_0

bb28:                                             ; preds = %LeafBlock221
  store { i1, i1 } %"20_0117", ptr %"0128", align 1
  store { i1, i1 } %"64_1118", ptr %"1129", align 1
  br label %cond_26_case_1

cond_26_case_0:                                   ; preds = %bb27
  %"0123" = load { i1, i1 }, ptr %"0121", align 1
  %"1124" = load { i1, i1 }, ptr %"1122", align 1
  store { i1, i1 } %"0123", ptr %"28_0", align 1
  store { i1, i1 } %"1124", ptr %"28_1", align 1
  %"28_0125" = load { i1, i1 }, ptr %"28_0", align 1
  %"28_1126" = load { i1, i1 }, ptr %"28_1", align 1
  %44 = insertvalue { i1, { i1, i1 }, { i1, i1 } } { i1 false, { i1, i1 } poison, { i1, i1 } poison }, { i1, i1 } %"28_0125", 1
  %45 = insertvalue { i1, { i1, i1 }, { i1, i1 } } %44, { i1, i1 } %"28_1126", 2
  store { i1, { i1, i1 }, { i1, i1 } } %45, ptr %"30_0", align 1
  %"30_0127" = load { i1, { i1, i1 }, { i1, i1 } }, ptr %"30_0", align 1
  store { i1, { i1, i1 }, { i1, i1 } } %"30_0127", ptr %"0119", align 1
  br label %cond_exit_26

cond_26_case_1:                                   ; preds = %bb28
  %"0130" = load { i1, i1 }, ptr %"0128", align 1
  %"1131" = load { i1, i1 }, ptr %"1129", align 1
  store { i1, i1 } %"0130", ptr %"32_0", align 1
  store { i1, i1 } %"1131", ptr %"32_1", align 1
  %"32_1132" = load { i1, i1 }, ptr %"32_1", align 1
  %46 = extractvalue { i1, i1 } %"32_1132", 0
  br label %LeafBlock223

LeafBlock223:                                     ; preds = %cond_26_case_1
  %SwitchLeaf224 = icmp eq i1 %46, true
  br i1 %SwitchLeaf224, label %bb30, label %bb29

bb29:                                             ; preds = %LeafBlock223
  %47 = extractvalue { i1, i1 } %"32_1132", 1
  store i1 %47, ptr %"0133", align 1
  br label %cond_174_case_0

bb30:                                             ; preds = %LeafBlock223
  %48 = extractvalue { i1, i1 } %"32_1132", 1
  store i1 %48, ptr %"0135", align 1
  br label %cond_174_case_1

cond_exit_26:                                     ; preds = %cond_exit_174, %cond_26_case_0
  %"0120" = load { i1, { i1, i1 }, { i1, i1 } }, ptr %"0119", align 1
  store { i1, { i1, i1 }, { i1, i1 } } %"0120", ptr %"26_0", align 1
  %"26_0140" = load { i1, { i1, i1 }, { i1, i1 } }, ptr %"26_0", align 1
  store { i1, { i1, i1 }, { i1, i1 } } %"26_0140", ptr %"26_0", align 1
  %"26_0141" = load { i1, { i1, i1 }, { i1, i1 } }, ptr %"26_0", align 1
  %49 = extractvalue { i1, { i1, i1 }, { i1, i1 } } %"26_0141", 0
  br label %LeafBlock225

LeafBlock225:                                     ; preds = %cond_exit_26
  %SwitchLeaf226 = icmp eq i1 %49, true
  br i1 %SwitchLeaf226, label %bb32, label %bb31

bb31:                                             ; preds = %LeafBlock225
  %50 = extractvalue { i1, { i1, i1 }, { i1, i1 } } %"26_0141", 1
  %51 = extractvalue { i1, { i1, i1 }, { i1, i1 } } %"26_0141", 2
  store { i1, i1 } %50, ptr %"47_0", align 1
  store { i1, i1 } %51, ptr %"47_1", align 1
  br label %bb9

bb32:                                             ; preds = %LeafBlock225
  %52 = extractvalue { i1, { i1, i1 }, { i1, i1 } } %"26_0141", 1
  store { i1, i1 } %52, ptr %"41_0", align 1
  br label %bb7

cond_174_case_0:                                  ; preds = %bb29
  %"0134" = load i1, ptr %"0133", align 1
  store i1 %"0134", ptr %"211_0", align 1
  br label %cond_exit_174

cond_174_case_1:                                  ; preds = %bb30
  %"0136" = load i1, ptr %"0135", align 1
  store i1 %"0136", ptr %"213_0", align 1
  %"213_0137" = load i1, ptr %"213_0", align 1
  br label %cond_exit_174

cond_exit_174:                                    ; preds = %cond_174_case_1, %cond_174_case_0
  %"32_0138" = load { i1, i1 }, ptr %"32_0", align 1
  %53 = insertvalue { i1, { i1, i1 }, { i1, i1 } } { i1 true, { i1, i1 } poison, { i1, i1 } poison }, { i1, i1 } %"32_0138", 1
  store { i1, { i1, i1 }, { i1, i1 } } %53, ptr %"34_0", align 1
  %"34_0139" = load { i1, { i1, i1 }, { i1, i1 } }, ptr %"34_0", align 1
  store { i1, { i1, i1 }, { i1, i1 } } %"34_0139", ptr %"0119", align 1
  br label %cond_exit_26

cond_201_case_0:                                  ; preds = %bb14
  %"0184" = load i1, ptr %"0183", align 1
  store i1 %"0184", ptr %"204_0", align 1
  store i1 false, ptr %"227_0", align 1
  %"227_0185" = load i1, ptr %"227_0", align 1
  store i1 %"227_0185", ptr %"0181", align 1
  br label %cond_exit_201

cond_201_case_1:                                  ; preds = %bb15
  %"0187" = load i1, ptr %"0186", align 1
  store i1 %"0187", ptr %"206_0", align 1
  %"206_0188" = load i1, ptr %"206_0", align 1
  %54 = select i1 %"206_0188", i1 true, i1 false
  store i1 %54, ptr %"208_0", align 1
  %"208_0189" = load i1, ptr %"208_0", align 1
  store i1 %"208_0189", ptr %"0181", align 1
  br label %cond_exit_201

cond_exit_201:                                    ; preds = %cond_201_case_1, %cond_201_case_0
  %"0182" = load i1, ptr %"0181", align 1
  store i1 %"0182", ptr %"201_0", align 1
  %"201_0190" = load i1, ptr %"201_0", align 1
  store i1 %"201_0190", ptr %"60_0", align 1
  %"55_0191" = load { i1, i1 }, ptr %"55_0", align 1
  store { i1, i1 } %"55_0191", ptr %"189_0", align 1
  %"189_0192" = load { i1, i1 }, ptr %"189_0", align 1
  %55 = extractvalue { i1, i1 } %"189_0192", 0
  br label %LeafBlock227

LeafBlock227:                                     ; preds = %cond_exit_201
  %SwitchLeaf228 = icmp eq i1 %55, true
  br i1 %SwitchLeaf228, label %bb34, label %bb33

bb33:                                             ; preds = %LeafBlock227
  %56 = extractvalue { i1, i1 } %"189_0192", 1
  store i1 %56, ptr %"0195", align 1
  br label %cond_191_case_0

bb34:                                             ; preds = %LeafBlock227
  %57 = extractvalue { i1, i1 } %"189_0192", 1
  store i1 %57, ptr %"0198", align 1
  br label %cond_191_case_1

cond_191_case_0:                                  ; preds = %bb33
  %"0196" = load i1, ptr %"0195", align 1
  store i1 %"0196", ptr %"194_0", align 1
  %"194_0197" = load i1, ptr %"194_0", align 1
  store i1 %"194_0197", ptr %"0193", align 1
  br label %cond_exit_191

cond_191_case_1:                                  ; preds = %bb34
  %"0199" = load i1, ptr %"0198", align 1
  store i1 %"0199", ptr %"196_0", align 1
  %"196_0200" = load i1, ptr %"196_0", align 1
  %58 = select i1 %"196_0200", i1 true, i1 false
  store i1 %58, ptr %"198_0", align 1
  %"198_0201" = load i1, ptr %"198_0", align 1
  store i1 %"198_0201", ptr %"0193", align 1
  br label %cond_exit_191

cond_exit_191:                                    ; preds = %cond_191_case_1, %cond_191_case_0
  %"0194" = load i1, ptr %"0193", align 1
  store i1 %"0194", ptr %"191_0", align 1
  %"191_0202" = load i1, ptr %"191_0", align 1
  store i1 %"191_0202", ptr %"57_0", align 1
  %"57_0203" = load i1, ptr %"57_0", align 1
  call void @__quantum__rt__bool_record_output(i1 %"57_0203", ptr @2)
  %"60_0204" = load i1, ptr %"60_0", align 1
  call void @__quantum__rt__bool_record_output(i1 %"60_0204", ptr @3)
  %"225_0205" = load {}, ptr %"225_0", align 1
  store {} %"225_0205", ptr %"225_0", align 1
  %"225_0206" = load {}, ptr %"225_0", align 1
  br label %bb35

bb35:                                             ; preds = %cond_exit_191
  br label %bb16
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
