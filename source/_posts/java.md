---
title: java_yi
tags: java
categories: java
math: true
archives: true
abbrlink: 2979e7ed
date: 2024-09-03 21:36:25
---
```
<!-- 字符串变量赋值 -->
String name=sc.next();
```
```
Math.pow(a,2);
Math.sqrt(a);
Math.abs(x-y);
```
&nbsp;

**求最大值**

$$
\text{max}(a, b) = \frac{a + b + \text{abs}(a - b)}{2}
$$



$$
\text{max}(a, b, c) = \frac{\left(\frac{a + b + \text{abs}(a - b)}{2} + c + \text{abs}\left(\frac{a + b + \text{abs}(a - b)}{2} - c\right)\right)}{2}
$$
   


&nbsp;

**t+=1e-8;**
java 里面浮点数的不精确性，最后得到的是 0.9999996 ，int 强制转换后变为 0
```
import java.util.Scanner;
public class Main{
    public static void main(String[] args){
        Scanner sc=new Scanner(System.in);
        double t=sc.nextDouble();
        t+=1e-8;
        // java 里面浮点数的不精确性，最后得到的是 0.9999996 ，int 强制转换后变为 0
        // 处理：给t加一个很小的值1e-8
        System.out.println("NOTAS:");
        System.out.printf("%d nota(s) de R$ 100.00\n",(int)t/100);
        System.out.printf("%d nota(s) de R$ 50.00\n",(int)t%100/50);
        System.out.printf("%d nota(s) de R$ 20.00\n",(int)t%100%50/20);
        System.out.printf("%d nota(s) de R$ 10.00\n",(int)t%100%50%20/10);
        System.out.printf("%d nota(s) de R$ 5.00\n",(int)t%100%50%20%10/5);
        System.out.printf("%d nota(s) de R$ 2.00\n",(int)t%100%50%20%10%5/2);
        System.out.println("MOEDAS:");
        System.out.printf("%d moeda(s) de R$ 1.00\n",(int)t%100%50%20%10%5%2/1);
        System.out.printf("%d moeda(s) de R$ 0.50\n",(int)(t%1/0.5));
        System.out.printf("%d moeda(s) de R$ 0.25\n",(int)(t%1%0.5/0.25));
        System.out.printf("%d moeda(s) de R$ 0.10\n",(int)(t%1%0.5%0.25/0.1));
        System.out.printf("%d moeda(s) de R$ 0.05\n",(int)(t%1%0.5%0.25%0.1/0.05));
        System.out.printf("%d moeda(s) de R$ 0.01\n",(int)(t%1%0.5%0.25%0.1%0.05/0.01));
    }
}
```

&nbsp;
java里 **判断字符串相等不能用 a=="wsy"**
只能用 **a.equals(wsy)**，使用前提a不为空，否则报错
处理：**"wsy".equals(a)**
```
if("onivoro".equals(z)){
    System.out.printf("homem");
}
else System.out.printf("vaca");
```
&nbsp;
数据集
![alt text](image.png)
这段代码的作用是将指定目录下的所有以".jpg"结尾的图片文件的标签写入同名的".txt"文件中。假设有一个名叫"antsimage"的目录，里面存放了一些以"ants"开头的蚂蚁图片，我们需要将其标签写入同名的".txt"文件中，以便后续使用。
代码核心部分使用了Python的os模块来定位文件位置和创建文件，主要分为以下步骤：

定义根目录rootdir、目标目录targetdir和标签label。在该段代码中，rootdir指的是存放所有图片的目录；targetdir指的是存放待处理图片的目录名称，本例中为"ants_image"；而label则是标签，这里为"ants"。
获取目标文件夹下所有图片文件的名称，并去掉文件扩展名".jpg"，只保留文件名。
遍历所有文件，使用with open()语句创建同名".txt"文件，并向其中写入标签label。
循环结束后，所有的图片的标签都写入了同名".txt"文件中，存放在指定的目录out_dir下。

总之，这段代码的作用是将一些图片的标签写入同名文件中，方便后续使用。
```
import os

root_dir = '练手数据集/train'
target_dir = 'ants_image'
img_path = os.listdir(os.path.join(root_dir, target_dir))
label = target_dir.split('_')【0】
out_dir = 'ants_label'
for i in img_path:
file_name = i.split('.jpg')【0】
with open(os.path.join(root_dir, out_dir,"{}.txt".format(file_name)),'w') as f:
f.write(label)
```
```
1
```