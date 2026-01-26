---
title: belief
index_img: /img/cover/1.png
banner_img: /img/cover/1.png
tags: 毕设
abbrlink: 2f811454
date: 2026-01-26 17:10:52
categories:
math: true
---


## 3.4 常识驱动的概率信念推演与动态追踪模块

在部分可观测环境下，智能体无法直接获取所有物体的精确位置信息。本文提出的**信念推演模块**利用大语言模型的常识推理能力，构建概率化的物体位置信念分布，并在与环境交互过程中动态更新。该模块分为**离线常识知识库构建**和**在线信念推理与更新**两个阶段。

### 3.4.1 离线：LLM驱动的常识知识库构建

**阶段 0：常识知识预生成**（一次性离线处理）

为避免在线推理延迟，本文采用离线方式预先构建常识知识库。对于每个可移动物品 $o_i \in O$，通过提示词工程向大语言模型 $L$ 查询其最可能的位置：

$
\text{Prompt}(o_i) = \text{"Question: What is the most possible position of } o_i \text{?"}\\
\text{Answer:"}
$

对每个物品重复采样 $M=50$ 次，得到响应集合 $\mathcal{E}_i = \{e_{i1}, e_{i2}, \ldots, e_{iM}\}$。例如，对于物品 "cutleryfork"，LLM 可能输出：
- 第1次：$\text{"INSIDE kitchencabinet"}$
- 第2次：$\text{"INSIDE dishwasher"}$
- 第3次：$\text{"INSIDE kitchencabinet"}$
- ...（共50次）

为将自然语言响应映射到一致的状态表示，采用基于 **Sentence-BERT** 的语义嵌入方法，计算响应与房间/容器候选的余弦相似度：

$$
\mathrm{CosineSim}(e_{ij}, r_k) = \frac{f_{\text{SBERT}}(e_{ij}) \cdot f_{\text{SBERT}}(r_k)}{\|f_{\text{SBERT}}(e_{ij})\| \cdot \|f_{\text{SBERT}}(r_k)\|}
$$

其中 $f_{\text{SBERT}}(\cdot)$ 为 Sentence-BERT 嵌入函数，$r_k \in \{\text{"kitchen"}, \text{"bedroom"}, \text{"bathroom"}, \text{"livingroom"}\}$ 为房间候选。选取相似度最高的房间作为该次采样的映射位置 $\tilde{r}_{ij}$。

统计每个物品在各位置的出现频次，计算归一化频率作为先验概率：

$$
p^{\text{prior}}_{ij} = \frac{\mathrm{count}(\tilde{r}_{ij} = r_k)}{M}, \quad k = 1, 2, 3, 4
$$

例如，若 "cutleryfork" 的 50 次采样中有 48 次映射到 "kitchen"，1 次到 "bedroom"，1 次到 "bathroom"，则：
$$p^{\text{prior}}_{\text{cutleryfork}, \text{kitchen}} = 0.96, \quad p^{\text{prior}}_{\text{cutleryfork}, \text{bedroom}} = 0.02, \quad p^{\text{prior}}_{\text{cutleryfork}, \text{bathroom}} = 0.02$$

最终得到**常识知识库** $\mathcal{K}_{\text{commonsense}}$，以 JSON 格式存储：
```json
{
  "cutleryfork": [["INSIDE", "kitchen", 48], ["ON", "kitchen", 2]],
  "book": [["INSIDE", "bedroom", 31], ["ON", "bedroom", 19]],
  ...
}
```

### 3.4.2 在线：概率信念初始化

**阶段 1：任务初始化**

在任务开始时，给定环境的初始图结构表示 $G_{\text{init}} = (V, E)$，其中：
- 节点集 $V$ 包含物体、房间、家具等实体
- 边集 $E$ 表示实体间的关系（如 $\text{INSIDE}$、$\text{ON}$）

智能体构建**初始信念分布** $b_0: O \times \mathcal{L} \rightarrow [0, 1]$，其中 $\mathcal{L}$ 为位置候选集合。对于每个可移动物品 $o_i$：

1. **加载常识知识库**：查询 $\mathcal{K}_{\text{commonsense}}$ 获取先验位置分布 $\{p^{\text{prior}}_{i1}, \ldots, p^{\text{prior}}_{i|\mathcal{L}|}\}$

2. **映射到环境实例**：将通用位置（如 "kitchen"）映射到当前环境的具体对象（如 `kitchencabinet_id`, `dishwasher_id`）：
   $$p^{\text{init}}_{i,\text{container}} = \frac{p^{\text{prior}}_{i,\text{kitchen}}}{\sum_{c \in \text{containers in kitchen}} p^{\text{prior}}_{i,\text{kitchen}}}$$

3. **构建完整信念分布**：
   - **容器内位置**：$b_0(o_i, \text{INSIDE}) = \{(c_1, p_{i1}), (c_2, p_{i2}), \ldots, (\text{None}, p_{i0})\}$
   - **表面位置**：$b_0(o_i, \text{ON}) = \{(s_1, p_{i1}), (s_2, p_{i2}), \ldots\}$
   - **房间位置**：$b_0(o_i, \text{ROOM}) = \{(r_1, p_{i1}), (r_2, p_{i2}), \ldots\}$

满足归一化条件：
$$\sum_{c} p_{ic} + \sum_{s} p_{is} = 1$$

**初始采样**：从信念分布中采样一个确定的世界状态 $G_0$：
$$
G_0 \sim b_0
$$

对每个物品 $o_i$：
$$
\text{location}(o_i) = \text{SampleFromCategorical}(b_0(o_i, \text{INSIDE}) \cup b_0(o_i, \text{ON}))
$$

若采样结果为 $\text{location}(o_i) = c_j$，则在图 $G_0$ 中添加边：
$$
E_0 \leftarrow E_0 \cup \{(o_i, c_j, \text{INSIDE})\}
$$

### 3.4.3 在线：信念更新与世界状态重采样

**阶段 2：交互式信念更新**

在时间步 $t$，智能体执行动作 $a_t$ 后获得新的部分观测 $\text{obs}_{t+1}$。信念更新分为两步：

**步骤 1：硬约束更新**

若观测明确显示物品 $o_i$ 位于位置 $l^*$：
$$
b_{t+1}^{\text{hard}}(o_i, l) = \begin{cases}
1, & \text{if } l = l^* \\
0, & \text{otherwise}
\end{cases}
$$

若观测排除某些位置（例如：打开柜子后未发现物品），定义未排除位置集合 $U = \{l : l \text{ consistent with } \text{obs}_{t+1}\}$，则：
$$
b_{t+1}^{\text{hard}}(o_i, l) = \begin{cases}
0, & \text{if } l \notin U \\
\dfrac{b_t(o_i, l)}{\sum_{l' \in U} b_t(o_i, l')}, & \text{if } l \in U
\end{cases}
$$

**步骤 2：软约束回归**

为避免过度拟合单次观测，引入**遗忘机制**使信念逐渐回归先验：
$$
b_{t+1}^{\text{soft}}(o_i, l) = b_t(o_i, l) - \lambda \cdot (b_t(o_i, l) - b_0(o_i, l))
$$

其中 $\lambda \in [0, 1]$ 为遗忘率（实验中设为 0.05），控制回归速度。

**最终信念**（结合硬约束与软约束）：
$$
b_{t+1}(o_i, l) = \alpha \cdot b_{t+1}^{\text{hard}}(o_i, l) + (1-\alpha) \cdot b_{t+1}^{\text{soft}}(o_i, l)
$$

**世界状态重采样**：

从更新后的信念中采样新的世界状态 $G_{t+1}$，用于后续的 MCTS 搜索：
$$
G_{t+1} \sim b_{t+1}
$$

采样过程如下：
```python
for each object o_i in grabbable_objects:
    # 从容器位置采样
    container = sample_categorical([None, cab_id, dw_id, ...], b_{t+1}(o_i, INSIDE))

    if container is not None:
        add_edge(o_i, container, INSIDE)
    else:
        # 从表面位置采样
        surface = sample_categorical([table_id, counter_id, ...], b_{t+1}(o_i, ON))
        add_edge(o_i, surface, ON)
```

### 3.4.4 完整 Pipeline 总结

信念系统的完整工作流程如下：

```
┌─────────────────────────────────────────────────────────────┐
│ 离线阶段（一次性）                                            │
│ LLM 采样 → 统计频率 → 常识知识库 K_commonsense               │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│ 在线阶段（每个 Task）                                         │
│                                                             │
│ 1. 初始化：加载 K → b_0 → 采样 G_0                          │
│ 2. 执行动作 a_t → 获得观测 obs_{t+1}                          │
│ 3. 更新：b_t → b_{t+1}（硬约束 + 软回归）                     │
│ 4. 采样：G_{t+1} ~ b_{t+1}                                  │
│ 5. MCTS：在 G_{t+1} 上搜索最佳动作                             │
│ 6. 重复步骤 2-5                                              │
└─────────────────────────────────────────────────────────────┘
```

**关键优势**：
1. **离线预生成**：避免在线推理延迟，LLM 用于常识知识构建而非实时查询
2. **概率建模**：显式建模位置不确定性，支持多样化采样
3. **动态更新**：结合硬约束（观测）与软回归（先验），平衡准确性与鲁棒性
4. **环境适应**：通过映射机制将通用常识适配到具体环境实例

图 3 展示了信念系统的完整架构，包括常识知识库构建、信念初始化、交互式更新和世界状态采样四个关键模块。
