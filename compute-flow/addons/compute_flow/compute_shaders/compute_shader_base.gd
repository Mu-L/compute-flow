@abstract
@tool
extends Node
class_name ComputeFlowBase
## 计算着色器基类

## 全局的 RenderingDevice
static var rd := RenderingServer.get_rendering_device() 

## 全局的纹理设置
static var view := RDTextureView.new()

var rid:RID
var shader_rid:RID

@export var black_board :ComputeFlowBlackBoard
