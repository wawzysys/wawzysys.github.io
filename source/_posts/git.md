---
title: git
tags: git
abbrlink: 518e617c
date: 2024-01-29 00:58:33
---
## 建立第二个github page
```
https://wawzysys.github.io/blog2/
```
## ssh`bug`
不知道为什么只有pigcha才能连接成功，clash代理不显示ssh。https都没有问题。

##
10.4

# 上传git超过100mb限制

## 修改为500MB

```
git config http.postBuffer 524288000
```

## 删除git历史中超过100MB的文件

### **步骤 1：下载预构建的 BFG Jar 文件**

1. [下载 bfg-1.14.0.jar](https://github.com/rtyley/bfg-repo-cleaner/releases/download/v1.14.0/bfg-1.14.0.jar)

3. **将 `bfg.jar` 移动到一个不包含中文字符的路径**

   将 `bfg.jar` 移动到一个路径简单且不包含中文字符的目录，例如 `E:\bfg\`。


### **步骤 2：克隆仓库的镜像版本**

1. **打开 Git Bash 或命令提示符**

2. **导航到您希望存放镜像仓库的位置**

   例如，将镜像仓库存放在 `E:\0Code` 目录下：

   ```bash
   cd /e/0Code
   ```

3. **克隆仓库的镜像**

   ```bash
   git clone --mirror https://github.com/wawzysys/Algorithm_.git
   ```

   这将创建一个名为 `Algorithm_.git` 的目录，包含仓库的所有数据。

4. **进入镜像仓库目录**

   ```bash
   cd Algorithm_.git
   ```

### **步骤 3：运行 BFG Repo-Cleaner**

现在，您可以使用 BFG 来移除大文件。

1. **确保您在镜像仓库目录中**

   您应该已经在 `Algorithm_.git` 目录中：

   ```bash
   pwd
   ```

   输出应类似于：

   ```
   /e/0Code/Algorithm_.git
   ```

2. **运行 BFG 命令**

   使用以下命令来移除特定的大文件：

   ```bash
   java -jar "/e/bfg/bfg.jar" --delete-files "Clash for Windows.zip" --delete-files "Z-lib.zip" --delete-files "mingw64.zip"
   ```

   **或**，如果您想移除所有超过 100MB 的文件，可以使用：

   ```bash
   java -jar "/e/bfg/bfg.jar" --strip-blobs-bigger-than 100M
   ```

   **注意：**
   - 在 Git Bash 中，路径分隔符应使用 `/`。
   - 确保路径中使用引号括起，以处理可能的空格或特殊字符。

3. **等待 BFG 处理完成**

   BFG 会扫描并移除指定的大文件。处理完成后，您会看到类似以下的输出：

   ```
   Found 3 commits to process
   Cleaning repository, please wait...
   Cleaned repository
   ```

### **步骤 4：清理和压缩仓库**

在运行 BFG 之后，执行以下 Git 命令以清理不需要的对象：

```bash
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

这将彻底清理大文件并优化仓库。

### **步骤 5：强制推送清理后的仓库到 GitHub**

由于仓库历史已被重写，您需要使用 `--force` 选项来强制推送更改到 GitHub：

```bash
git push --force
```

**⚠️ 警告：** 强制推送会覆盖远程仓库的历史记录。**所有协作者需要重新克隆仓库**，否则他们的本地仓库将与远程仓库不一致，可能会导致问题。

### **步骤 6：验证清理结果**

1. **检查 GitHub 仓库**

   登录您的 GitHub 仓库页面，确保大文件已被移除。

2. **尝试再次推送**

   在本地仓库中进行一次小的提交并尝试推送，以确保问题已解决。

   ```bash
   echo "测试" > test.txt
   git add test.txt
   git commit -m "测试推送"
   git push
   ```

   如果推送成功，说明清理已成功。

### **步骤 7：配置 Git LFS（可选）**

为了避免未来再次遇到大文件问题，建议使用 [Git Large File Storage (Git LFS)](https://git-lfs.github.com/) 来管理大文件。

### **操作步骤：**

1. **安装 Git LFS**

   如果尚未安装 Git LFS，请访问 [Git LFS 官方网站](https://git-lfs.github.com/) 下载并安装。

2. **初始化 Git LFS**

   ```bash
   git lfs install
   ```

3. **配置要跟踪的文件类型**

   例如，跟踪所有 `.zip` 文件：

   ```bash
   git lfs track "*.zip"
   ```

   这将创建或更新 `.gitattributes` 文件。

4. **提交 `.gitattributes` 文件**

   ```bash
   git add .gitattributes
   git commit -m "配置 Git LFS 跟踪 zip 文件"
   ```

5. **添加和提交大文件**

   ```bash
   git add path/to/largefile.zip
   git commit -m "使用 Git LFS 添加大文件"
   git push
   ```

**注意：** Git LFS 有其自身的存储限制和费用，请根据您的项目需求选择合适的方案。

### **总结**

1. **下载正确的 `bfg.jar` 文件**，确保不是源代码。
2. **将 `bfg.jar` 移动到不包含中文字符的路径**，如 `E:\bfg\`。
3. **克隆仓库的镜像版本**，以确保 BFG 可以清理所有分支和标签中的大文件。
4. **运行 BFG 命令**，指定正确的 `bfg.jar` 路径和要删除的文件。
5. **执行 Git 垃圾回收**，彻底清理大文件。
6. **强制推送**清理后的仓库到 GitHub。
7. **验证清理结果**，确保大文件已被移除。
8. **使用 Git LFS 管理未来的大文件**，避免类似问题再次发生。
