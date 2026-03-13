@tool
extends Struct
class_name AudioConstant
## 音频结构体参数

func _init() -> void:
	struct_name = "AudioConstant"
	fields = "sample_rate = 44100.0    // 采样率
time_offset = 0.0    // 时间偏移（秒）
base_frequency= 440.0 // 基础频率
amplitude=0.5     // 振幅
out_img = 512,512 //可视化分辨率"
