---
title: hexo_test1
tags: hexo
categories: hexo
cover: /img/cover/3.png
abbrlink: 844dcfed
date: 2024-01-22 03:14:12
---
```
fun
```
### 字体测试
```python
a = "success"
pirnt(a)
b = 2
c = 1
if b >= c:
    print("success")
```
### 测试网页代码框长度
```css
/* 滚动条 */
::-webkit-scrollbar {
    width: 8px;
    height: 8px;
}

::-webkit-scrollbar-track {
    background-color: rgba(73, 177, 245, 0.2);
    border-radius: 2em;
}

::-webkit-scrollbar-thumb {
    background-color: #49b1f5;
    background-image: -webkit-linear-gradient(45deg,
            rgba(255, 255, 255, 0.4) 25%,
            transparent 25%,
            transparent 50%,
            rgba(255, 255, 255, 0.4) 50%,
            rgba(255, 255, 255, 0.4) 75%,
            transparent 75%,
            transparent);
    border-radius: 2em;
}

::-webkit-scrollbar-corner {
    background-color: transparent;
}

::-moz-selection {
    color: #fff;
    background-color: #49b1f5;
}

/* 页脚footer */
/* 渐变色滚动动画 */
@-webkit-keyframes Gradient {
    0% {
        background-position: 0 50%;
    }

    50% {
        background-position: 100% 50%;
    }

    100% {
        background-position: 0 50%;
    }
}

@-moz-keyframes Gradient {
    0% {
        background-position: 0 50%;
    }

    50% {
        background-position: 100% 50%;
    }

    100% {
        background-position: 0 50%;
    }
}

@keyframes Gradient {
    0% {
        background-position: 0 50%;
    }

    50% {
        background-position: 100% 50%;
    }

    100% {
        background-position: 0 50%;
    }
}

#footer {
    background: linear-gradient(-45deg, #ee7752, #ce3e75, #23a6d5, #23d5ab);
    background-size: 400% 400%;
    -webkit-animation: Gradient 10s ease infinite;
    -moz-animation: Gradient 10s ease infinite;
    animation: Gradient 10s ease infinite;
    -o-user-select: none;
    -ms-user-select: none;
    -webkit-user-select: none;
    -moz-user-select: none;
    user-select: none;
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
}

#footer:before {
    background-color: rgba(248, 244, 244, 0);
}

/* 文章页背景 */
.layout_post>#post {
    /* 以下代表白色透明度为0.3 */
    background: rgba(255, 255, 255, .9);
}

/* 所有背景（包括首页卡片、文章页、页面页等） */
#aside_content .card-widget,
#recent-posts>.recent-post-item,
.layout_page>div:first-child:not(.recent-posts),
.layout_post>#page,
.layout_post>#post,
.read-mode .layout_post>#post {
    /* 以下代表白色透明度为0.3 */
    background: rgba(255, 255, 255, .9);
}

#web_bg {
    /* background: url(https://www.acwing.com/user/profile/index/); */
    background-repeat: no-repeat;
    /* background-image: linear-gradient(to top, #fff1eb 0%, #ace0f9 100%); */
    background: linear-gradient(to right bottom, rgb(0, 255, 240), rgb(92, 159, 247) 40%, rgb(211, 34, 255) 80%);
}
```