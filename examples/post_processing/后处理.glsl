#[compute]
#version 450


//
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;
layout(push_constant) uniform PushConstants {
	float time;
};


//set 0
layout(set = 0, binding = 0) uniform sampler2D input_image;  // 画面输入
layout(set = 0, binding = 1, rgba8) writeonly uniform image2D output_image;  // 画面输出

//** COMPUTE SHADER SEPARATOR - 分隔符 **//



void main() {
ivec2 texel = ivec2(gl_GlobalInvocationID.xy);
vec4 color = texture(input_image, texel / textureSize(input_image, 0));
imageStore(output_image, texel, color);
}
