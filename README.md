# Compute Flow

一款深度集成于 Godot Engine 编辑器内的计算着色器（Compute Shader）可视化管理插件。它通过一组专用的场景节点和编辑器工具，将 GPU 通用计算任务的资源创建、绑定、配置与调试流程变得直观和可视化，无需编写底层 RenderingDevice 代码。

<img width="436" height="382" alt="image" src="https://github.com/user-attachments/assets/ca2350ae-a66d-4e1f-87fd-8208bc684ed2" />
<img width="1336" height="576" alt="image" src="https://github.com/user-attachments/assets/491b1360-545d-4045-85d5-f2edc0fd8e00" />

![闪烁](https://github.com/user-attachments/assets/8c59b5a5-27ac-4575-84c8-7b08bdd638ee)

## 特性

• 结构化节点树：提供 ComputeFlow、ComputeSet 及多种 ComputeUniform 资源节点（如 StorageBuffer、UniformBuffer、ImageUniform 等），直接在场景树中构建清晰的计算任务层级结构。

• 可视化资源绑定：通过将 Godot 资源（如 Texture2D、AudioStream）拖拽到节点属性中，自动完成计算资源的绑定与后台 RID 管理。

• 集成编辑器工具栏：选中节点后，在编辑器中显示专用侧边栏，用于快速生成子节点、编辑 GLSL 配置、调试着色器执行。

• 声明式 GLSL 配置：通过“黑板数据”编辑器，集中管理计算着色器的全局工作组大小、本地工作组大小、宏定义、结构体与 Push Constant。

• 专用派生资源节点：提供如 AudioBuffer 等专用节点，可与引擎其他系统（如音频播放器）便捷对接。

• 运行时调试支持：支持在编辑器中快速重启/暂停计算着色器，并查看 Push Constant 等调试信息。

• 简化的工作流：大部分计算着色器的设置与管理操作在编辑器中即可完成。

## 系统要求

• Godot 版本: 4.4+

• 图形后端: 需要支持计算着色器的后端（推荐 Vulkan）。

• 硬件: 支持计算着色器的 GPU。

## 安装

1.  从 Asset Library 下载 compute_flow 插件包，或克隆此仓库到您项目的 addons/ 目录下。
2.  在 Godot 编辑器中，进入 项目 -> 项目设置 -> 插件。
3.  在插件列表中找到“Compute Flow”，并将其状态切换为“启用”。

## 核心概念

• ComputeFlow 节点：场景中计算任务的根节点和管理器。负责着色器的提交、执行与同步，并提供编辑器集成接口。

• ComputeSet 节点：资源节点的逻辑容器，用于组织和管理一组相关的计算资源。

• ComputeUniform 及其派生类：各类计算资源的抽象表示。

    ◦ UniformBuffer：只读的统一缓冲。

    ◦ StorageBuffer：可读写的存储缓冲。

    ◦ AudioBuffer：继承自 StorageBuffer，可便捷绑定到音频播放器。

    ◦ ImageUniform / Sampler2DUniform：用于图像采样的纹理资源。

    ◦ BridgeUniform：用于不同shader间的数据桥接，通过RD rid 直接读取buffer。

• 黑板数据 (Blackboard Data)：附着在 ComputeFlow 节点上的配置数据块，用于集中管理计算着色器的配置参数。

• 可视化绑定：通过拖放资源到节点检查器属性完成数据关联的交互方式。

## 快速开始

### 1. 创建 ComputeFlow 根节点
1.  在场景树中创建 ComputeFlow 节点。
2.  选中 ComputeFlow 节点，编辑器右侧将出现一个 ComputeFlow 工具栏。
   
<img width="1399" height="1423" alt="image" src="https://github.com/user-attachments/assets/cfb4dc93-2668-4fbd-bba8-073871c879a0" />

3.  黑板数据编辑器中，你可以定义：
    ◦ global_size：全局工作组数量。

    ◦ local_size：本地工作组大小（如 [8, 8, 1]）。

    ◦ macros：预处理器宏定义。
    
    ◦ push_constant：推送常量数据。
    
    ◦ structs：自定义结构体。
    
    注：push_constant 及 structs 不支持数组类型及结构体嵌套

### 2. 使用工具栏构建节点树

1.  在场景树中选中 ComputeFlow 节点。
2.  点击工具栏最上方的 “Add Set” 按钮，一个 ComputeSet 节点将作为子节点被创建。ComputeSet 用于对相关资源进行逻辑分组。
3.  选中新创建的 ComputeSet 节点，工具栏中的按钮会更新。
4.  点击 “Add Storage Buffer” 或 “Add Uniform Buffer” 等按钮，创建你计算着色器所需的具体资源节点。

### 3. 绑定资源与配置着色器

    如，创建了一个 ImageBuffer 节点。
    在检查器中，你会看到 texture_node 和 output_image 等属性。

    1.  从文件系统面板中，将一个图片纹理拖拽到 texture 属性上，完成输入数据的绑定。
    2.  勾选 output_image 属性，插件会自动处理后台 RDTexture 的创建，用于接收着色器的输出。
   
    如，创建了一个 Sampler2DUniform 节点。
    在检查器中，可以拖拽SubViewport节点，会自动绑定子视口的rid 作为画面后处理。

### 4. 编写与指定着色器

1.  在工具栏中点击 “Create/Edit GLSL” 按钮，或在 Godot 编辑器中创建一个新的 .glsl 着色器文件。
2.  点击生成可自动生成配置好的Glsl源码。编辑可打开外部编辑器中编写glsl文件。

### 5. 运行与调试

1.  运行场景。
2.  在编辑器运行模式下，你可以通过 ComputeFlow 工具栏中的按钮重启或暂停计算着色器的执行。
3.  启用 Debug 模式，可以实时查看诸如 Push Constant 等传递给着色器的数据，辅助调试。

## 示例

插件包中包含 examples 文件夹，提供以下场景：

• 图像闪烁：演示使用Sampler2DUniform和 ImageBuffer 进行简单的画面图像处理。

• 基础粒子系统：演示使用 ComputeFlow 生成粒子数据，并通过RDTexture传递给godot粒子系统进行渲染。

• 音频数据：演示 AudioBuffer 进行GPU 程序化音频生成。

## 故障排除

• 工具栏不显示：确保选中的是 ComputeFlow 或相关节点（如 ComputeSet, StorageBuffer 等），编辑器工具栏 顶部的开关可以控制工具栏的显示。

<img width="1650" height="133" alt="image" src="https://github.com/user-attachments/assets/897f6020-14b3-40ef-9a17-fd9eee9d4eec" />

• 无计算结果：确保 ComputeFlow 节点的 shader 属性已正确指定，并检查资源节点的绑定属性是否已正确赋值。

## 许可证

本插件采用 MIT 许可证发布。详情请见随附的 LICENSE 文件。
