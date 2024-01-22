---
title: hexo
tags: hexo
cover: /img/cover/1.png
abbrlink: ab21860c
date: 2024-01-22 03:01:24
---
# 发表文章
```
hexo new "name"
```
这篇文章会出现在/source/_post/
# 发表page
```
hexo page "name"
```
# 修改完毕之后在本地查看效果
```
hexo clean
hexo generate
hexo cl && hexo g
hexo serve
```
# 上传
```
hexo d 
```
需要输入ssh密码


## 美化

### 彩色标签云
在`config.yal`中将`aside`中的`card_tags`的`enable`设置为`true`即可

### 用`giscus`实现评论

```
待整理
```
### 实现鼠标彩色
```
待整理
```
### 社交信息

```yaml
social:
  fab fa-github:  "填入github主页"|| Github || '#24292e'
  fas fa-envelope:  mailto:"邮箱" || Email || '#4a7dbe'
  fab fa-qq: fab fa-qq: tencent://AddContact/?fromId=45&fromSubId=1&subcmd=all&uin="QQ号👌"&website=www.oicqzone.com || QQ || '#qq-color-code'
```
### 背景图片and渐变
⚠️：先在`config.yaml`中将`backgroud`设一个图片 `url()`
网上都没有这一步 
但我试了好多次，只加个`css`不出现图片，不知道为什么
```
写css
然后inject
```
### 代码高亮
```
写css
然后inject
```

## 目前还不会的
### 2024.1.11
- [ ] `giscus`不会将评论顺序默认改成最新的
- [ ] 最新留言or评论不会弄到右边
- [x] 将评论在某些page不显示
- [x] 文章背景虚化   2024.1.22完成
### 待做
- [ ] `about`完善
  

### 图床
token
```
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
```