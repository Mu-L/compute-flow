@icon("uid://0v0dr6x2knfj")
@tool
extends StorageBuffer
class_name AudioBuffer

@export_custom(PROPERTY_HINT_NODE_TYPE, "AudioStream,AudioStreamPlayer2D,AudioStreamPlayer3D")
var audio_stream_player:Node
var audio_stream:AudioStreamGenerator
var playback:AudioStreamGeneratorPlayback

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	audio_stream = AudioStreamGenerator.new()
	audio_stream.mix_rate = 44100
	if audio_stream_player:
		audio_stream_player.stream = audio_stream
	await rd_change
	black_board.compute_run.connect(get_audio_stream)

func get_audio_stream():
	# 1. 从GPU获取字节数据
	var byte_data = get_byte_array()
	# 2. 转换为浮点数数组
	var audio_frames = byte_data.to_vector2_array()
	# 创建AudioStreamGenerator
	audio_stream.buffer_length = float(audio_frames.size()) / 44100.0
	audio_stream_player.play()
	# 获取播放器引用并填充
	playback = audio_stream_player.get_stream_playback()
	if playback:
		playback.push_buffer(audio_frames)
	
