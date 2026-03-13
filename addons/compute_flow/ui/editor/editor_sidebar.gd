@tool
extends Control


#region 节点引用
## 按钮容器
@onready var flow_container: FlowContainer = %FlowContainer
## set类
@onready var compute_set: Button = %ComputeSet
@onready var double_buffering_set: Button = %DoubleBufferingSet
## buffer类 
@onready var image_buffer: Button = %ImageBuffer
@onready var sampler_2d: Button = %Sampler2D
@onready var uniform_buffer: Button = %UniformBuffer
@onready var storage_buffer: Button = %StorageBuffer
@onready var audio_buffer: Button = %AudioBuffer
@onready var bridge_uniform: Button = %BridgeUniform

## 黑板容器
@onready var black_board_foldable: FoldableContainer = %BlackBoard
@onready var shader_name: Button = %shader_name

## 数据编辑器
@onready var global_x: SpinBox = %global_x
@onready var global_y: SpinBox = %global_y
@onready var global_z: SpinBox = %global_z

@onready var local_x: SpinBox = %local_x
@onready var local_y: SpinBox = %local_y
@onready var local_z: SpinBox = %local_z

@onready var macro_edit: CodeEdit = %MacroEdit
@onready var push_constant_edit: CodeEdit = %PushConstantEdit
@onready var structs_foldable: FoldableContainer = %StructsFoldable

## 警告标签
@onready var worring_label: Label = %WorringLabel
#endregion

## 当前选中的节点
var current_node:Node = null
var compute_shader:ComputeFlow = null
## 黑板数据
var black_board:ComputeFlowBlackBoard = null
## glsl 文件路径
var file_path:String
# 编辑器
var scene_root
var _undo_redo:EditorUndoRedoManager

signal switch_position()

func _ready() -> void:
	# 获取编辑器接口
	scene_root = EditorInterface.get_edited_scene_root()
	_undo_redo = EditorInterface.get_editor_undo_redo()
	_undo_redo.clear_history(_undo_redo.get_object_history_id(scene_root))

#region 插件初始,切换当前节点
func update_for_node(node:Node) -> void:
	get_child(0).show()
	worring_label.hide()
	current_node = node
	if current_node is ComputeFlow:
		compute_shader = node
		_show_button(0)
	elif current_node is ComputeSet:
		if current_node.get_parent() is ComputeFlow:
			compute_shader = node.get_parent()
			if current_node is DoubleBufferingSet:
				_show_button(1)
			else :
				_show_button(2)
		else:
			_show_worring("The node must be a child node of ComputeFlow")
			return
	elif current_node is ComputeUniform:
		if current_node.get_parent() is ComputeSet:
			compute_shader = node.get_parent().get_parent()
			_show_button(3)
		else:
			_show_worring("The node must be a child node of ComputeSet")
			return


	update_ui_from_blackboard()

## 显示按钮
func _show_button(type: int) -> void:
	for child in flow_container.get_children():
		child.hide()
	match type:
		0: 
			flow_container.show()
			compute_set.show()
			double_buffering_set.show()
		1:
			flow_container.show()
			image_buffer.show()
			storage_buffer.show()
			
		2:  # ComputeSet
			flow_container.show()
			image_buffer.show()
			sampler_2d.show()
			uniform_buffer.show()
			storage_buffer.show()
			audio_buffer.show()
			bridge_uniform.show()
		_:
			flow_container.hide()

func _show_worring(worring:String):
	get_child(0).hide()
	worring_label.show()
	worring_label.text = worring
#endregion

#region 添加子节点
func _on_compute_set_pressed() -> void:
	if not _undo_redo or not current_node:
		return
	
	_undo_redo.create_action("Add ComputeSet")
	
	# 保存节点引用
	var target_parent = current_node
	var new_node = ComputeSet.new()
	
	# Do操作
	_undo_redo.add_do_method(target_parent, "add_child", new_node)
	_undo_redo.add_do_property(new_node, "name", "ComputeSet")
	_undo_redo.add_do_property(new_node, "owner", get_tree().edited_scene_root)
	
	# Undo操作
	_undo_redo.add_undo_method(target_parent, "remove_child", new_node)
	
	_undo_redo.commit_action()

func _on_double_buffering_set_pressed() -> void:
	if not _undo_redo or not current_node:
		return
	
	_undo_redo.create_action("Add DoubleBufferingSet")
	
	var target_parent = current_node
	var new_node = DoubleBufferingSet.new()
	
	_undo_redo.add_do_method(target_parent, "add_child", new_node)
	_undo_redo.add_do_property(new_node, "name", "DoubleBufferingSet")
	_undo_redo.add_do_property(new_node, "owner", get_tree().edited_scene_root)
	
	_undo_redo.add_undo_method(target_parent, "remove_child", new_node)
	
	_undo_redo.commit_action()

func _on_image_buffer_pressed() -> void:
	if not _undo_redo or not current_node:
		return
	
	_undo_redo.create_action("Add ImageBuffer")
	
	var target_parent = current_node
	var new_node = ImageUniform.new()
	
	_undo_redo.add_do_method(target_parent, "add_child", new_node)
	_undo_redo.add_do_property(new_node, "name", "ImageBuffer")
	_undo_redo.add_do_property(new_node, "owner", get_tree().edited_scene_root)
	
	_undo_redo.add_undo_method(target_parent, "remove_child", new_node)
	
	_undo_redo.commit_action()

func _on_sampler_2d_pressed() -> void:
	if not _undo_redo or not current_node:
		return
	
	_undo_redo.create_action("Add Sampler2D")
	
	var target_parent = current_node
	var new_node = Sampler2DUniform.new()
	
	_undo_redo.add_do_method(target_parent, "add_child", new_node)
	_undo_redo.add_do_property(new_node, "name", "Sampler2D")
	_undo_redo.add_do_property(new_node, "owner", get_tree().edited_scene_root)
	
	_undo_redo.add_undo_method(target_parent, "remove_child", new_node)
	
	_undo_redo.commit_action()

func _on_uniform_buffer_pressed() -> void:
	if not _undo_redo or not current_node:
		return
	
	_undo_redo.create_action("Add UniformBuffer")
	
	var target_parent = current_node
	var new_node = UniformBuffer.new()
	
	_undo_redo.add_do_method(target_parent, "add_child", new_node)
	_undo_redo.add_do_property(new_node, "name", "UniformBuffer")
	_undo_redo.add_do_property(new_node, "owner", get_tree().edited_scene_root)
	
	_undo_redo.add_undo_method(target_parent, "remove_child", new_node)
	
	_undo_redo.commit_action()

func _on_storage_buffer_pressed() -> void:
	if not _undo_redo or not current_node:
		return
	
	_undo_redo.create_action("Add StorageBuffer")
	
	var target_parent = current_node
	var new_node = StorageBuffer.new()
	
	_undo_redo.add_do_method(target_parent, "add_child", new_node)
	_undo_redo.add_do_property(new_node, "name", "StorageBuffer")
	_undo_redo.add_do_property(new_node, "owner", get_tree().edited_scene_root)
	
	_undo_redo.add_undo_method(target_parent, "remove_child", new_node)
	
	_undo_redo.commit_action()

func _on_audio_buffer_pressed() -> void:
	if not _undo_redo or not current_node:
		return
	
	_undo_redo.create_action("Add StorageBuffer")
	
	var target_parent = current_node
	var new_node = AudioBuffer.new()
	
	_undo_redo.add_do_method(target_parent, "add_child", new_node)
	_undo_redo.add_do_property(new_node, "name", "StorageBuffer")
	_undo_redo.add_do_property(new_node, "owner", get_tree().edited_scene_root)
	
	_undo_redo.add_undo_method(target_parent, "remove_child", new_node)
	
	_undo_redo.commit_action()

func _on_bridge_uniform_pressed() -> void:
	if not _undo_redo or not current_node:
		return
	
	_undo_redo.create_action("Add BridgeUniform")
	
	var target_parent = current_node
	var new_node = BridgeUniform.new()
	
	_undo_redo.add_do_method(target_parent, "add_child", new_node)
	_undo_redo.add_do_property(new_node, "name", "BridgeUniform")
	_undo_redo.add_do_property(new_node, "owner", get_tree().edited_scene_root)
	
	_undo_redo.add_undo_method(target_parent, "remove_child", new_node)
	
	_undo_redo.commit_action()


#endregion

#region 选择 生成 glsl文件预设
func _on_shader_name_pressed() -> void:
	if file_path == "":
		_show_glsl_selection_dialog()
	else:
		_open_glsl_file_location()

# 显示GLSL文件选择弹窗
func _show_glsl_selection_dialog() -> void:
	var file_dialog = EditorFileDialog.new()
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_ANY
	file_dialog.filters = PackedStringArray(["*.glsl"])
	file_dialog.access = EditorFileDialog.ACCESS_FILESYSTEM
	file_dialog.title = "选择GLSL文件或文件夹"
	
	file_dialog.file_selected.connect(func(selected_path: String):
		# 如果选择的是GLSL文件
		if selected_path.get_extension() == "glsl":
			file_path = selected_path
			shader_name.text = file_path.get_file().get_basename()
			
			# 加载已有的GLSL文件
			if ResourceLoader.exists(file_path):
				var glsl_resource = ResourceLoader.load(file_path)
				if glsl_resource:
					black_board.glsl_file = file_path
		else:
			# 如果不是glsl文件，视为文件夹
			_create_glsl_in_directory(selected_path)
		
		file_dialog.queue_free()
	)
	
	file_dialog.dir_selected.connect(func(selected_dir: String):
		_create_glsl_in_directory(selected_dir)
		file_dialog.queue_free()
	)
	
	file_dialog.canceled.connect(func():
		file_dialog.queue_free()
	)
	
	get_parent().add_child(file_dialog)
	file_dialog.popup_centered_ratio(0.8)

## 在指定目录创建GLSL文件
func _create_glsl_in_directory(directory_path: String) -> void:
	var uid = ResourceUID.create_id()
	var default_filename = "compute_shader_" + str(uid) + ".glsl"
	var new_file_path = directory_path.path_join(default_filename)
	
	var file = FileAccess.open(new_file_path, FileAccess.WRITE)
	if file:
		file.close()
		print("GLSL文件创建成功: ", new_file_path)
		
		# 设置文件路径
		file_path = new_file_path
		shader_name.text = new_file_path.get_file().get_basename()
		
		# 刷新资源系统
		await get_tree().create_timer(0.1).timeout
		EditorInterface.get_resource_filesystem().scan()
		await get_tree().create_timer(0.1).timeout
		
		black_board.glsl_file = new_file_path
	else:
		print("创建文件失败")

# 打开文件所在文件夹
func _open_glsl_file_location() -> void:
	var dir_dialog = EditorFileDialog.new()
	dir_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	dir_dialog.filters = PackedStringArray(["*.glsl"])
	dir_dialog.current_path = file_path
	dir_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	dir_dialog.title = "Open_GLSL_file"
	
	dir_dialog.file_selected.connect(func(selected_path: String):
		# 可以更新文件路径
		if selected_path != file_path:
			file_path = selected_path
			shader_name.text = file_path.get_file().get_basename()
			
			# 重新加载GLSL文件
			if ResourceLoader.exists(file_path):
				var glsl_resource = ResourceLoader.load(file_path)
				if glsl_resource:
					black_board.glsl_file = file_path
		
		dir_dialog.queue_free()
	)
	
	dir_dialog.canceled.connect(func():
		dir_dialog.queue_free()
	)
	
	get_parent().add_child(dir_dialog)
	dir_dialog.popup_centered_ratio(0.8)
#endregion

#region 黑板数据编辑
## 加载黑板数据到UI
func update_ui_from_blackboard() -> void:
	if black_board == current_node.black_board:
		return
	black_board = compute_shader.black_board
	current_node.black_board = compute_shader.black_board

	if black_board.glsl_file != "":
		file_path = ResourceLoader.load(black_board.glsl_file).resource_path
		shader_name.text = file_path.get_file().get_basename()
	else:
		file_path = ""
		shader_name.text = "No GLSL file"
	# 更新全局线程数控件
	global_x.value = black_board.global_size.x
	global_y.value = black_board.global_size.y
	global_z.value = black_board.global_size.z
	# 更新工作组线程数控件
	local_x.value = black_board.local_size.x
	local_y.value = black_board.local_size.y
	local_z.value = black_board.local_size.z
	
	# 更新宏控件
	macro_edit.text = black_board.macro
	
	# 更新push_constant
	if black_board.push_constant :
		push_constant_edit.text = black_board.push_constant.fields
	else:
		push_constant_edit.text = ""
		
	# 更新structs
	structs_foldable.black_board = black_board
	for i:Node in structs_foldable.box_container.get_children():
		i.queue_free()
	
	for i in black_board.structs:
		var stuck_editor:StructEditor = preload("uid://caoxj2as6gtxb").instantiate()
		structs_foldable.box_container.add_child(stuck_editor)
		stuck_editor.owner = get_tree().current_scene
		stuck_editor.updata_struct(i)

func _on_global_x_value_changed(value: float) -> void:
	black_board.global_size.x = int(value)

func _on_global_y_value_changed(value: float) -> void:
	black_board.global_size.y = value

func _on_global_z_value_changed(value: float) -> void:
	black_board.global_size.z = value

func _on_local_x_value_changed(value: float) -> void:
	black_board.local_size.x = value

func _on_local_y_value_changed(value: float) -> void:
	black_board.local_size.y = value

func _on_local_z_value_changed(value: float) -> void:
	black_board.local_size.z = value

func _on_macro_edit_text_changed() -> void:
	black_board.macro = macro_edit.text

func _on_push_constant_edit_text_changed() -> void:
	if !black_board.push_constant:
		black_board.push_constant= PushConstant.new()
	black_board.push_constant.fields = push_constant_edit.text
	black_board.push_constant.add_field_to_data()

#endregion

## 弹窗编辑
func _on_edit_gui_input(event: InputEvent,text_edit) -> void:
	if event is InputEventMouseButton :
		if event.button_index ==1 and event.double_click:
			const GLSL_EDITOR = preload("uid://c5wupgq8n1kt")
			var editor = GLSL_EDITOR.instantiate()
			add_child(editor)
			editor.owner = get_tree().current_scene
			editor.updata_editor(text_edit)

func _on_shader_initialization_pressed() -> void:
	compute_shader.build_glsl_source()

func _on_shader_edit_pressed() -> void:
	compute_shader.edit_shader()
