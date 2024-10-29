# 湖南科技大学博士学位论文 LaTeX 模板

[![Compile and publish the release](https://github.com/yusanshi/hnuthesis/actions/workflows/main.yml/badge.svg)](https://github.com/yusanshi/hnuthesis/actions/workflows/main.yml) [![GitHub Releases](https://img.shields.io/github/v/release/yusanshi/hnuthesis)](https://github.com/yusanshi/hnuthesis/releases/latest)

本项目是湖南科技大学博士学位论文 LaTeX 模板 hnuthesis，按照《[湖南科技大学研究生学位论文撰写规范](https://yyxy.hnust.edu.cn/rcpy/yjspy/yjspygl/f2d23a836a874cdba2b09b4ec5e662ad.htm)》的要求编写（**个人能力、精力有限，不保证完全符合规范，_Use at your own risk!_**）。

下载地址：[GitHub Releases](https://github.com/PengGaoxian/HNUST_thesis_LaTex)、[Overleaf](https://cn.overleaf.com/read/mcfvqsyrtrxj#373a4c)。

本项目基于 [hnuthesis](https://github.com/hnuthesis/hnuthesis)。

关于 LaTeX 的安装、配置、编写的相关问题，请参阅其他类似项目（如 [thuthesis](https://github.com/tuna/thuthesis) 和 [ustcthesis](https://github.com/ustctug/ustcthesis) 等）。

## 关键文件说明

- `main.tex`: 主文件，编译入口；
- `hnuthesis.cls`: 撰写规范，需要调整格式在该文件中对应修改；
- `references.bib`: 参考文献列表；
- `chapters/`: 论文章节文件夹，分章有利于保持 TeX 文件的整洁；
- `figures/`: 插图文件夹，LaTeX 支持多种格式，如 EPS、PDF、PNG 等；
- `main.pdf`: 编译生成的论文 PDF 文件；
