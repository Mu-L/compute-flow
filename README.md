# Compute Flow

一款为 Godot Engine 设计的计算着色器（Compute Shader）管理与流程编排插件，旨在简化 GPU 通用计算在游戏与图形应用中的集成与使用。

## 特性

- **直观的计算着色器管理**：在编辑器中轻松创建、编辑和组织计算着色器节点。
- **可视化工作流编排**：通过节点编辑器定义多步计算任务的数据流与依赖关系。
- **统一资源接口**：为存储缓冲（Storage Buffers）、统一缓冲（Uniform Buffers）、图像（Images）等计算资源提供一致的创建与绑定方式。
- **异步计算支持**：简化异步计算命令的提交、同步与回调管理。
- **性能分析与调试**：内置计算分派（Dispatch）性能监控与资源使用情况查看工具。
- **跨后端兼容**：抽象层设计，为目标支持 Vulkan 与未来可能的其他图形API后端提供便利。

## 系统要求

- **Godot 版本**: 4.3 或更高版本（稳定分支）
- **图形后端**: 主要支持 Vulkan。部分功能在兼容模式下可运行于其他后端。
- **硬件**: 支持计算着色器的 GPU。

## 安装

1. 从 Asset Library 下载 `compute_flow` 插件包，或克隆此仓库到您的项目目录下。
2. 在 Godot 编辑器中，进入 `项目设置 -> 插件`。
3. 在插件列表中找到“Compute Flow”，并将其状态切换为“启用”。



### 4. 运行
将包含 `ComputeFlow` 节点的场景加入主场景或运行该场景，即可执行计算流程。

## 核心概念

- **ComputeFlow 节点**： 计算任务的主要容器和调度单元。
- **计算资源**： 包括缓冲区和图像，是着色器读取和写入的数据载体。
- **绑定槽**： 着色器中 `binding = X` 对应的资源绑定位置。
- **分派**： 指定在 GPU 上执行的工作组数量。
- **流程脚本**： 驱动 `ComputeFlow` 节点执行控制逻辑的脚本。

## API 概览

主要 API 分类如下（具体请参考内嵌文档或 API 文档）:

- **资源管理**: `create_storage_buffer()`, `create_uniform_buffer()`, `create_image()`
- **着色器与绑定**: `set_compute_shader()`, `bind_storage_buffer()`, `bind_uniform_buffer()`, `bind_image()`
- **执行控制**: `dispatch()`, `dispatch_async()`, `barrier()` (用于同步)
- **数据读取**: `read_storage_buffer()`, `read_storage_buffer_async()`

## 示例项目

插件包中包含 `examples` 文件夹，内有以下场景：
- `Particle System`： 使用计算着色器更新的粒子系统。
- `Image Processing`： 简单的图像模糊与锐化处理。
- `Flocking Boids`： 经典的 Boids 群体模拟。

## 文档与支持

- 详细的类与方法参考，请在 Godot 编辑器中启用插件后，在脚本编辑器中查看相关类的内联文档。
- 遇到问题或有功能建议？请访问 https://github.com/yourusername/compute_flow/issues 页面。

## 许可证

本插件采用 MIT 许可证发布。详情请见随附的 LICENSE 文件。

---

**Compute Flow** - 让 Godot 中的 GPU 计算如行云流水。
