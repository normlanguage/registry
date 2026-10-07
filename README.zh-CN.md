# Norm GitHub Registry

[English](README.md)

`registry.json` 将 Norm Module 名称映射到拥有其不可变 Release 的公开 GitHub 仓库。

每个已注册仓库以 `v<version>` 发布 `<artifact>-<version>.nar` 及其 SHA-256 校验文件。Module 身份与依赖仅在 `module.norm` 中声明。

新包通过拉取请求注册名称和仓库。现有所有者独立发布新版本。

包仓库调用[共享工作流](.github/workflows/package.yml)，并指定明确的 Norm 工具链版本。该工作流解析声明、拒绝未提交的解析变更、打包一个根 Module、运行模块测试和 `samples/` 之外现有的 `Main.norm` 回归、为带标签的产物生成证明，并发布不可变 Release。各所有者仓库单独验证自己的 `samples/`。

具有 Windows Java 依赖图的模块在调用共享工作流时设置 `runner: windows-2025`。默认运行器为 Linux。

工具链安装入口见 [setup-norm](.github/actions/setup-norm/action.yml)。公共打包工作流要求在 `norm-version` 与完整提交 SHA `norm-source-ref` 中选一个；源码模式调用编译器已有的发行目录构建任务。
