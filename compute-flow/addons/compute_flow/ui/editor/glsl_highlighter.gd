@tool
extends SyntaxHighlighter
class_name GlslHighlighter

# 定义语法颜色
const COLOR_KEYWORD = Color(1.0, 0.44, 0.52) # 红色系
const COLOR_TYPE = Color(0.4, 0.9, 0.7)    # 青色系
const COLOR_BUILTIN = Color(0.9, 0.8, 0.4) # 黄色系
const COLOR_COMMENT = Color(0.5, 0.5, 0.5) # 灰色
const COLOR_NUMBER = Color(1.0, 1.0, 1.0, 1.0)  # 紫色

var keywords = [
	"#define","if", "else", "for", "while", "do", "return", "break", "continue", "discard",
	"switch", "case", "default", "attribute", "varying", "uniform", "in", "out", 
	"inout", "layout", "const", "precision", "lowp", "mediump", "highp"
]

var types = [
	"void", "bool", "int", "uint", "float", "double", "vec2", "vec3", "vec4", 
	"bvec2", "bvec3", "bvec4", "ivec2", "ivec3", "ivec4", "uvec2", "uvec3", "uvec4", 
	"mat2", "mat3", "mat4", "sampler2D", "samplerCube", "sampler3D", "image2D"
]

var builtins = [
	"TIME", "PI", "UV", "COLOR", "VERTEX", "FRAGCOORD", "NORMAL", "TEXTURE",
	"radians", "degrees", "sin", "cos", "tan", "asin", "acos", "atan", "pow", 
	"exp", "log", "sqrt", "abs", "sign", "floor", "ceil", "fract", "mod", 
	"min", "max", "clamp", "mix", "step", "smoothstep", "length", "distance", 
	"dot", "cross", "normalize", "texture", "textureLod", "imageStore", "imageLoad"
]

func _get_line_syntax_highlighting(line: int) -> Dictionary:
	var res = {}
	var text = get_text_edit().get_line(line)
	
	# 处理注释 (简单实现)
	var comment_index = text.find("//")
	if comment_index != -1:
		res[comment_index] = {"color": COLOR_COMMENT}
		# 注释后的内容不再处理
		return res

	# 简单的分词正则表达式（匹配单词、数字）
	var regex = RegEx.new()
	regex.compile("\\b[A-Za-z_]\\w*\\b|\\b\\d+\\.?\\d*\\b")
	
	for match in regex.search_all(text):
		var word = match.get_string()
		var start = match.get_start()
		
		if word in keywords:
			res[start] = {"color": COLOR_KEYWORD}
		elif word in types:
			res[start] = {"color": COLOR_TYPE}
		elif word in builtins:
			res[start] = {"color": COLOR_BUILTIN}
		elif word.is_valid_float() or word.is_valid_int():
			res[start] = {"color": COLOR_NUMBER}
		else:
			res[start] = {"color": Color.WHITE} # 默认颜色

	return res
