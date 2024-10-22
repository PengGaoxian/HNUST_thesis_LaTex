\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{hnuthesis}
    [2017/07/19 v0.1 HNU thesis template]

% 定义布尔变量，用来表示不同的选项
\newif\if@hnu@doctor  % 判断是否为博士学位论文选项
\newif\if@hnu@numerical % 判断是否为数字引用格式
\newif\if@hnu@super % 判断是否为上标引用格式
\newif\if@hnu@pdf % 判断是否生成PDF文件

% 定义选项
\DeclareOption{doctor}{\@hnu@doctortrue}  % 定义选项doctor，激活@hnu@doctor标志
\DeclareOption{print}{\@hnu@pdffalse} % 定义选项print，表示打印模式，不生成PDF文件
\DeclareOption{pdf}{\@hnu@pdftrue}  % 定义选项pdf，表示生成PDF文件
\DeclareOption{super}{\@hnu@numericaltrue\@hnu@supertrue} % 定义选项super，启用数字引用并使用上标显示
\DeclareOption{numbers}{\@hnu@numericaltrue\@hnu@superfalse}  % 定义选项numbers，启用数字引用，但不使用上标显示
\DeclareOption{authoryear}{\@hnu@numericalfalse}  % 定义选项authoryear，使用作者-年份引用格式
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbook}}  % 所有其他未定义的选项都传递给ctexbook类
\ExecuteOptions{doctor,chinese,print,super} % 执行默认选项：博士论文、中文、打印模式、上标引用
\ProcessOptions\relax % 处理所有选项

% 定义一个布尔变量@hnu@addtocspace，是否在目录中添加空格
\newif\if@hnu@addtocspace 
% 如果启用了PDF选项，则传递oneside选项给book类，表示单面打印
\if@hnu@pdf
    \PassOptionsToClass{oneside}{book}
\fi
% 传递no-math选项给fontspec包，禁用数学字体
\PassOptionsToPackage{no-math}{fontspec}
% 加载ctexbook类，设置UTF8编码、A4纸张、任意页开始新章节、小四号字体
\LoadClass[UTF8, a4paper, openany, zihao=-4]{ctexbook}[2015/05/14]
% 加载etoolbox包，用于修改类的内部命令
\RequirePackage{etoolbox}
% 如果当前的ctexbook类版本早于2015/05/14，则报错，提示用户更新ctex包
\@ifclasslater{ctexbook}{2015/05/14}{}{%
    \ClassError{hnuthesis}{%
        Requiring ctex 2.0 or later version!\MessageBreak
        Please update the package using your\MessageBreak
        TeX package manager or from CTAN
    }{%
        See logs for more details.
    }
}

% 设置英文字体
\setmainfont{Times New Roman} % 设置正文字体为Times New Roman
\setsansfont{Arial} % 设置无衬线字体为Arial
\setmonofont{Courier New} % 设置等宽字体为Courier New
% 设置中文字体
\setCJKmainfont{[simsun.ttc]}[AutoFakeBold=true] % 设置中文字体为宋体，加粗效果为伪粗体
\setCJKsansfont{[simhei.ttf]} % 设置中文无衬线字体为黑体

% 加载hyperref包，设置PDF元数据、超链接颜色、超链接样式
\RequirePackage{hyperref}
% 配置hyperref的参数
\hypersetup{
    bookmarksopen=true, % 打开PDF文件时书签栏默认展开
    bookmarksnumbered=true, % 书签条目带有编号
    bookmarksopenlevel=1, % 书签展开到一级标题
    CJKbookmarks=true,  % 支持中文书签
    pdfborder=0 0 0,  % 链接无边框
    unicode=true, % 支持unicode编码
    linktoc=all,  % 目录中的章节和小节名都添加超链接
}

% 如果启用了PDF选项，则配置超链接颜色
\if@hnu@pdf
    \hypersetup{
        colorlinks=true,  % 启用彩色链接
        allcolors=blue, % 所有链接的颜色为蓝色
    }
\fi

% 在文档开始时设置PDF标题和作者
\AtBeginDocument{
    \hypersetup{
        pdftitle={\hnu@title},  % 设置PDF文件的标题，使用变量\hnu@title
        pdfauthor={\hnu@author} % 设置PDF文件的作者，使用变量\hnu@author
    }
}

% 加载xparse宏包，用于定义高级命令
\RequirePackage{xparse}

% 定义新命令\setfontsize，用于设置字体大小和行间距，{mo}表示该命令接收一个必需参数和一个可选参数
\NewDocumentCommand\setfontsize{mo}
    % \IfValueTF用于检测可选参数#2是否存在
    {\IfValueTF{#2}
        {\fontsize{#1}{#2}  % 如果提供了行距#2，则设置字体大小为#1，行距为#2
    }{
        \fontsize{#1}{2\dimexpr#1}  % 如果未提供行距#2，默认行距为2倍字体大小#1
    }
    \linespread{1}  % 设置行距为1.0倍
    \selectfont\relax % 应用所选字体设置
}

% 定义新命令\zhspace，用于生成宽度为#1倍中文字符宽度的水平空白
\newcommand\zhspace[1][1]{\hspace{#1\ccwd}} % \ccwd表示中文字符宽度（chinese character width）

% 定义新命令\hnu@underline，生成带有固定宽度的下划线
\newcommand\hnu@underline[2][6em]{%
    \hskip1pt\underline{\hb@xt@ #1{\hss#2\hss}}\hskip3pt\relax % #1为下划线长度的可选参数，默认为6em，#2为下划线内容
}

% 定义新宏命令hnu@define@term，用于生成带有前缀hun@的全局变量，#1表示要定义的变量名称。通过动态创建带有hnu@前缀的命令和存储值，是这些命令可以在其他地方被调用
\def\hnu@define@term#1{
    \expandafter\gdef\csname #1\endcsname##1{ % 使用\expandafter来展开#1的值并生成对应命令
        \expandafter\gdef\csname hnu@#1\endcsname{##1}  % 创建一个全局变量hnu@#1，并将参数##1赋值给该变量
    }
    \csname #1\endcsname{}  % 立即调用该命令，并初始化为空值
}
\hnu@define@term{hnucode} % 定义全局变量 \hnu@hnucode，用于存储学校代号
\hnu@define@term{hnuname} % 定义全局变量 \hnu@hnuname，用于存储学校名称
\hnu@define@term{degree} % 定义全局变量 \hnu@degree，用于存储学位类型
\hnu@define@term{title}   % 定义全局变量 \hnu@title，用于存储论文标题
\hnu@define@term{clc}     % 定义全局变量 \hnu@clc，用于存储中图分类号
\hnu@define@term{secrettext}  % 定义全局变量 \hnu@secrettext，用于存储密级
\hnu@define@term{author}      % 定义全局变量 \hnu@author，用于存储作者姓名
\hnu@define@term{authorid}    % 定义全局变量 \hnu@authorid，用于存储学号
\hnu@define@term{college}     % 定义全局变量 \hnu@college，用于存储学院
\hnu@define@term{major}       % 定义全局变量 \hnu@major，用于存储专业
\hnu@define@term{workon}      % 定义全局变量 \hnu@workon，用于存储研究方向
\hnu@define@term{supervisor}  % 定义全局变量 \hnu@supervisor，用于存储导师姓名
\hnu@define@term{cosupervisor}  % 定义全局变量 \hnu@cosupervisor，用于存储第二导师姓名
\hnu@define@term{submitdate}    % 定义全局变量 \hnu@submitdate，用于存储论文提交日期
\hnu@define@term{defensedate}   % 定义全局变量 \hnu@defensedate，用于存储论文答辩日期
\hnu@define@term{chair}       % 定义全局变量 \hnu@chair，用于存储答辩委员会主席
\hnu@define@term{entitle}     % 定义全局变量 \hnu@entitle，用于存储英文标题
\hnu@define@term{enauthor}    % 定义全局变量 \hnu@enauthor，用于存储英文作者姓名
\hnu@define@term{enmajor}     % 定义全局变量 \hnu@enmajor，用于存储英文专业
\hnu@define@term{endoctor}    % 定义全局变量 \hnu@endoctor，用于存储英文学位
\hnu@define@term{enmaster}    % 定义全局变量 \hnu@enmaster，用于存储英文学位
\hnu@define@term{enbachelor}  % 定义全局变量 \hnu@enbachelor，用于存储英文学位
\hnu@define@term{enhnuname}   % 定义全局变量 \hnu@enhnuname，用于存储英文学校名称
\hnu@define@term{ensupervisor}  % 定义全局变量 \hnu@ensupervisor，用于存储英文导师姓名
\hnu@define@term{endate}    % 定义全局变量 \hnu@endate，用于存储英文日期

% 条件判断，如果选择了博士选项（\if@hnu@doctor），则设置博士学位论文的相关信息
\if@hnu@doctor
    % 定义命令\hnu@thesisname，用于存储博士学位论文的名称
    \newcommand\hnu@thesisname{博士学位论文}%
    % 定义命令\hnu@yemeiname，用于存储博士学位论文的中文名称，显示在页眉中 
    \newcommand\hnu@yemeiname{\hnu@hnuname 博士学位论文}% TODO
\fi

% 表格：
% 三线表
\RequirePackage{booktabs} % 加载booktabs宏包，用于创建三线表（toprule、midrule、bottomrule）
\RequirePackage{multirow} % 加载multirow宏包，用于在表格中创建跨行单元格
% 跨页表格
% \RequirePackage{longtable} % 加载longtable宏包，用于创建跨页的长表格


% 题注、标题
% 重定义插图和附表的索引标题名称
\renewcommand\listfigurename{插图索引}  % 将"List of Figures" 重命名为"插图索引"
\renewcommand\listtablename{附表索引}   % 将"List of Tables" 重命名为"附表索引"
% 定义其他文档部分的名称
\newcommand\hnu@notesname{\textbf{注}：}  % 定义注释部分的名称，粗体显示为“注：”
\newcommand\hnu@enabstractname{Abstract}  % 定义英文摘要部分的名称为“Abstract”
\newcommand\hnu@abstractname{摘\quad 要}  % 定义中文摘要部分的名称为“摘  要”
\newcommand\hnu@acknowledgementsname{致\quad 谢}  % 定义致谢部分的名称为“致  谢”
\newcommand\hnu@tocname{目\quad 录}   % 定义目录部分的名称为“目  录”
\newcommand\hnu@summaryname{总结与展望}   % 定义总结与展望部分的名称为“总结与展望”
\newcommand\hnu@notationname{符号说明}    % 定义符号说明部分的名称为“符号说明”
% 重定义LaTex中自动引用功能（使用\autoref命令）时的显示内容
% 当自动引用公式时，显示为“公式（编号）”
\def\equationautorefname~#1\null{公式~(#1)\null}%   
% 当自动引用脚注时，显示为“脚注”
\def\footnoteautorefname{脚注}%
% 当自动引用列表项时，显示为”第（编号）项”
\def\itemautorefname~#1\null{第~#1~项\null}%
% 当自动引用图时，显示为“图”
\def\figureautorefname{图}%
% 当自动引用表格时，显示为“表”
\def\tableautorefname{表}%
% 当自动引用部分（part）时，显示为“第（编号）部分”
\def\partautorefname~#1\null{第~#1~部分\null}%
% 当自动引用附录时不显示前缀
\def\appendixautorefname{}%
% 当自动引用章节时，显示为“第（编号）章”
\def\chapterautorefname~#1\null{第~#1~章\null}%
% 当自动引用节（section）时，显示为“第（编号）节”
\def\sectionautorefname~#1\null{第~#1~节\null}%
% 当自动引用小节（subsection）时，显示为“第（编号）小节”
\def\subsectionautorefname~#1\null{第~#1~小节\null}%
% 当自动引用小小节（subsubsection）时，显示为“第（编号）小小节”
\def\subsubsectionautorefname~#1\null{第~#1~小小节\null}%
% 当自动引用段落（paragraph）时，显示为“第（编号）段”
\def\paragraphautorefname~#1\null{第~#1~段\null}%
% 当自动引用小段（subparagraph）时，显示为“第（编号）小段”
\def\subparagraphautorefname~#1\null{第~#1~小段\null}%
% 当自动引用定理（theorem）时，显示为“定理”
\def\theoremautorefname{定理}%
% 当自动引用引理（lemma）时，显示为“引理”
\def\pageautorefname~#1\null{第~#1~页\null}%

% 页面设置
% 加载geometry宏包，用于自定义页面布局
\RequirePackage{geometry}
% 使用geometry宏包设置页面尺寸和边距
\geometry{
    paper=a4paper,  % 纸张尺寸为A4
    top=2.2cm, bottom=2.2cm,  % 上下边距为2.2cm
    left=2.5cm, right=2.5cm,  % 左右边距为2.5cm
    headheight=0.4cm,   % 页眉高度为0.4cm 
    headsep=1.3cm,  % 页眉与正文的距离为1.3cm
    footskip=1.1cm  % 页脚与正文的距离为1.1cm
}

% 加载fancyhdr宏包，用于自定义页眉和页脚
\RequirePackage{fancyhdr}
% 定义页眉的横线粗细，0.4pt表示横线的厚度
\renewcommand{\headrulewidth}{0.4pt}
% 定义自定义的页眉样式 hnu@headings
\fancypagestyle{hnu@headings}{%
  \fancyhf{}%                                       % 清空默认的页眉页脚设置
%   \fancyhead[CE]{\setfontsize{9pt}\hnu@title}%      % 左页的中央页眉内容为论文标题，字号9pt
  \fancyhead[CE]{\setfontsize{9pt}\leftmark}%      % 左页的中央页眉内容为论文章名称，字号9pt
  \fancyhead[CO]{\setfontsize{9pt}\hnu@yemeiname}   % 右页的中央页眉内容为yemeiname，字号9pt
  \fancyfoot[C]{\setfontsize{9pt}\thepage}          % 页脚中央显示页码，字号9pt
  \fancyheadoffset[LO,LE]{3mm}                      % 左侧页眉（LO：左侧页眉奇数页，LE：左侧页眉偶数页）向右偏移量为3mm
  \fancyheadoffset[RO,RE]{-3mm}                     % 右页页眉（RO：右侧页眉奇数页，RE：右侧页眉偶数页）向左偏移量为-3mm

  \makeatletter  % 使@成为普通字母，通常配合\makeatother使用
  \def\headrule{
    % 判断是否为普通页面，如果是，使用普通的页眉线宽；否则使用plainheadrulewidth的页眉线宽
    \if@fancyplain\let\headrulewidth\plainheadrulewidth\fi%
    \hrule\@height 0.5pt \@width\headwidth  % 线粗0.5pt
    % 设置与正文的垂直间距
    \vskip-2\headrulewidth
    \vskip-1pt     
  }
    \vspace{7mm} % 设置页眉与正文的垂直间距为7mm
}%

% 定义一个名为hnu@notation的页脚样式，在该样式下，页脚内容为空
\fancypagestyle{hnu@notation}{\fancyfoot{}}
% 设置文档的默认页眉样式为hnu@headings
\pagestyle{hnu@headings}
% 重定义chaptermark命令，使得章节标题可以正确显示在页眉中
\renewcommand{\chaptermark}[1]{\markboth{#1}{}}
% 重定义\cleardoublepage命令，如果文档是双面打印，并且当前页为偶数页，则插入空白页，使得下一章从奇数页开始
\renewcommand*{\cleardoublepage}{
    \clearpage  % 结束当前页
    \if@twoside % 如果是双面打印
        \ifodd\c@page   % 如果当前页为奇数页
        \else           % 如果当前页为偶数页
            \hbox{}     % 插入一个空盒子占位
            \thispagestyle{empty} % 当前页的样式为空白页样式
            \newpage    % 插入一个新的空白页
            \if@twocolumn % 如果是双栏排版
                \hbox{}   % 插入一个空盒子占位
                \newpage  % 插入一个新的空白页
            \fi
        \fi
    \fi
}

% 为\fontmatter部分（前言部分）增加自定义行为
\g@addto@macro\frontmatter{%
    % 使用大写罗马数字编号
    \pagenumbering{Roman}%  
}

% 重定义\mainmatter命令，用于切换到文档的主体部分，插入新页并开始使用阿拉伯数字进行页码编号
\renewcommand\mainmatter{%
  \cleardoublepage        % 使章节从新的奇数页开始
  \pagenumbering{arabic}% % 使用阿拉伯数字进行页码编号
  \@mainmattertrue        % 设置\@mainmatter为真，表示当前处于文档的主体部分
}

% 列表
% 加载enumitem宏包，用于自定义列表的格式
\RequirePackage{enumitem}
% 自定义无需列表（itemize）的格式
\setitemize{
    leftmargin=3em, % 左边缩进为3em
    itemsep=0em,    % 列表项之间的间距为0em
    partopsep=0em,  % 列表前后额外间距为0em
    parsep=0em,     % 段落间距为0em
    topsep=-0em     % 列表顶部的额外间距为0em
}
% 自定义有序列表（enumerate）的格式
\setenumerate{
    leftmargin=3em, % 左边缩进为3em
    itemsep=0em,    % 列表项之间的间距为0em
    partopsep=0em,  % 列表前后额外间距为0em
    parsep=0em,     % 段落间距为0em
    topsep=0em      % 列表顶部的额外间距为0em
}

% 章节、段落、页眉、页脚
\renewcommand\chapter{%
  % 判断是否为openright模式，如果是，则章节从右页开始
  \if@openright\cleardoublepage\else\clearpage\fi
  % 设置行距为20pt
  \setlength{\baselineskip}{20pt}
  % 设置中文CJK字符的间隔为0.5pt，允许根据行间距动态调整
  \renewcommand{\CJKglue}{\hskip 0.5pt plus \baselineskip}
  \global\@topnum\z@  % 禁止在章节页顶部放置浮动体
  \@afterindenttrue   % 章节后的第一段缩进
  \secdef\@chapter\@schapter  % 使用secdef定义章节命令，分别处理带编号和不带编号的章节
}

% 加载pifont宏包，用于使用符号字体
\RequirePackage{pifont}
% 定义自定义命令hnu@textcircled，显示带圈的数字
\def\hnu@textcircled#1{%
    % 如果当前页脚的编号大于9，则报错
    \ifnum\value{#1} >9
        \ClassError{hnuthesis}%
            {Too many footnotes in this page.}{Keep footnote less than 10.}
    \fi
    % 使用ding命令生成带圈的数字，编号通过计算公式实现
    \ding{\the\numexpr\value{#1}+191\relax}
}

% 加载stringstrings宏包，用于操作字符串，比如计算字符串长度
\RequirePackage{stringstrings}
% 定义计数器titlelength，用于存储字符串长度
\newcounter{titlelength}
% 定义自定义命令spacetitle，根据标题的长度调整字间距
\newcommand\spacetitle[1]{%
    % 计算字符串#1的长度，并将其存储在titlelength计数器中
    \@getstringlength{#1}{titlelength}%
    % 如果字符串长度为2，使用ziju命令将字间距设为2并输出标题
    \ifnum\thetitlelength=2
        {\ziju{2}#1} 
    \else%
        % 如果字符串长度为3，设置字间距为1
        \ifnum\thetitlelength=3
            {\ziju{1}#1}
        \else%
            % 如果字符串长度为4，设置字间距为0.5
            \ifnum\thetitlelength=4
                {\ziju{0.5}#1}
            % 如果字符串长度大于4，包吃默认字间距
            \else
                #1%
            \fi
        \fi
    \fi
}

% 设置章节编号深度，允许最多显示到5级（即章、节、副节、段落等）
\setcounter{secnumdepth}{5}

% 使用ctexset命令自定义章、节、副节等部分的格式
\ctexset{
    chapter = {
        format      = \centering\sffamily\bfseries\setfontsize{18pt}, % 居中，使用无衬线字体、加粗，字号18pt
        nameformat  = {}, % 不设置章名称的格式
        % titleformat = \spacetitle,  % 使用spacetitle命令调整标题字间距
        number      = \thechapter,  % 使用阿拉伯数字显示章节号
        aftername   = \hspace{\ccwd}, % 在章号后加入一个中文字符宽度的空格
        beforeskip  = -1.5em, % 24bp - 31bp % 在章标题前的垂直间距为-1.5em
        afterskip   = 1.5em, % 18bp - 10bp  % 在章标题后的垂直间距为1.5em
        % fixskip   = true, % will be used in future version
    },
    section = {
        format     = \bf\sffamily\setfontsize{15pt},  % 加粗，无衬线字体，字号15pt
        aftername  = \hspace{\ccwd},    % 在节标题后加一个中文字符宽度的空格
        beforeskip = 12pt,    % 标题前的垂直间距为12pt
        afterskip  = 12pt,    % 标题后的垂直间距为12pt
    },
    subsection = {
        format     = \bf\sffamily\setfontsize{14pt},  % 加粗，无衬线字体，字号14pt
        aftername  = \hspace{\ccwd},    % 在副节标题后加一个中文字符宽度的空格
        % indent     = 2\ccwd,
        beforeskip = 6pt,   % 标题前的垂直间距为6pt
        afterskip  = 6pt,   % 标题后的垂直间距为6pt
    },
    subsubsection = {
        format    = \sffamily\setfontsize{12.5pt},  % 无衬线字体，字号12.5pt
        number    = (\arabic{subsubsection}),   % 使用阿拉伯数字显示副副节号
        % aftername = \hspace{\ccwd},
        beforeskip = 6pt,   % 标题前的垂直间距为6pt
        afterskip  = 6pt,   % 标题后的垂直间距为6pt
        % indent    = 3\ccwd,
    },
    paragraph = {
        format    = \sffamily\setfontsize{12.5pt},  % 无衬线字体，字号12.5pt
        number    = (\arabic{paragraph}),  % 使用阿拉伯数字编号，并用{}括起来
        aftername = \hspace{\ccwd},   % 在段标题后加一个中文字符宽度的空格
        % indent    = 3\ccwd,
    },
    subparagraph = {
        format    = \sffamily\setfontsize{12.5pt},  % 无衬线字体，字号12.5pt
        number    = \hnu@textcircled{subparagraph}, % 使用带圈的数字显示小段号
        aftername = \hspace{\ccwd},   % 在小段标题后加一个中文字符宽度的空格
        % indent    = 3\ccwd,
    },
}

% 书签
% 定义计数器hnu@pdfbookmark，用于为章节创建PDF书签
\newcounter{hnu@pdfbookmark}
% 定义新命令hnu@chapter，使用xparse宏包的NewDocumentCommand来处理可选参数和必需参数，o表示可选参数，m表示必需参数
\NewDocumentCommand\hnu@chapter{o m}{%
  % 判断是否启用了openright选项，如果是，则章节从右页开始，否则直接新起一页
  \if@openright\cleardoublepage\else\clearpage\fi%
  % 增加PDF书签计数器的值，每次调用hnu@chapter时递增1
  \addtocounter{hnu@pdfbookmark}\@ne
  % IfValueTF是xparse宏包的命令，判断是否存在可选参数#1，如果存在，则使用#1，否则使用#2
  \IfValueTF{#1}{%
    % 如果提供了可选参数#1，则将其作为PDF书签的标题，并为书签设置层级为0（章级）
    \pdfbookmark[0]{#1}{hnuchapter.\thehnu@pdfbookmark}%
    % 设置章节标记为可选参数#1
    \chaptermark{#1}%
  }{%
    % 如果没有提供可选参数#1，则使用必需参数#2作为PDF书签的标题，并为书签设置层级为0（章级）
    \pdfbookmark[0]{#2}{hnuchapter.\thehnu@pdfbookmark}%
    % 设置章标记为必须参数#2
    \chaptermark{#2}%
  }%
  % 使用chapter*创建不带编号的章节标题，显示必需参数#2
  \chapter*{#2}
}

% 封面
% 重定义 \maketitle命令，负责生成论文的封面部分
\renewcommand\maketitle{%
    % 使用newgeometry调整封面页面的边距设置
    \newgeometry{
        top=3.8cm, bottom=3.8cm,  % 上下边距为3.8cm
        left=3.2cm, right=3.2cm,  % 左右边距为3.2cm
        headheight=0cm,   % 页眉高度为0cm
        headsep=0.8cm,    % 页眉与正文的距离为0.8cm
        footskip=0.8cm    % 页脚与正文的距离为0.8cm
    }
    \pagenumbering{gobble}  % 禁用页码显示

    % \pdfbookmark[0]{封面}{titlepage}  % 为封面页创建PDF书签，层级为0，标题为“封面”
    \make@cntitle@first % 生成封面第一部分
    \clearpage  % 结束当前页 

    \make@entitle   % 生成英文封面
    % \pdfbookmark[0]{Title page}{entitlepage} % 为英文封面创建PDF书签，层级为0，标题为“Title page”，当使用cleardoublepage时，该代码会在上一页生成书签
    \clearpage  % 结束当前页

    \make@cntitle@second  % 生成中文封面第二部分
    \clearpage  % 结束当前页

    \restoregeometry  % 恢复默认页面边距设置
    \make@statement % 生成原创性声明页面
    % \pdfbookmark[0]{原创性声明}{statement}  % 为原创性声明创建PDF书签，标题为“原创性声明”
}

% 定义新命令 \hnu@supervisorline，生成导师信息行
\newcommand\hnu@supervisorline{%
    % 如果联合导师为空，则只显示一位导师信息
    \ifx\hnu@encosupervisor\@empty%
        Supervisor: \hnu@ensupervisor%
    % 如果联合导师不为空，则显示两位导师信息
    \else%
        Supervisors: \hnu@ensupervisor, \hnu@encosupervisor%
    \fi
}

% 加载TikZ宏包，用于绘制图形
\RequirePackage{tikz}
% 定义新命令 \vpostext，垂直定位文本
\newcommand\vpostext[2]{%
    \tikz[remember picture,overlay]%
        % yshift指定垂直偏移量#1，文本#2放置在页面顶部（current page.north）的下方
        \node [yshift=-#1] at (current page.north) [below,align=flush center]%
            %使用parbox创建一个居中的文本框，文本框宽度为\textwidth
            {\parbox{\textwidth}{\centering#2}};
}

% 定义新命令 \linetext，生成带下划线的文本
\newcommand\linetext[3]{%
  \underline{\makebox[#1][#2]{#3}}  % 使用makebox生成固定宽度的文本框，添加下划线
}


% 中文封面
% 加载tabularx宏包，用于在表格中使用可调整列宽的X列类型
\RequirePackage{tabularx}
% 定义自定义命令make@cntitle@first，生成中文封面的第一部分
\newcommand\make@cntitle@first{%
    \begin{titlepage}%  %开始封面页环境
        \phantomsection  % 创建一个标记点
        \pdfbookmark[0]{封面}{titlepage}

        % 使用TikZ在页面的左上角绘制内容，调整位置
        \tikz[remember picture,overlay]%
          \node [xshift=2.5cm,yshift=-2.5cm] at (current page.north west)%
            [below right,align=left] {%
                \newlength{\@tw} % 定义长度变量\@tw
                \setlength{\@tw}{75pt}  % 设置\@tw的值为75pt
                \newlength{\@cw}  % 定义长度变量\@cw
                \setlength{\@cw}{3cm} % 设置\@cw的值为3cm
                \setfontsize{12.5pt}% % 设置字号为12.5pt
                % 创建一个表格，用于显示密级和中图分类号
                \begin{tabularx}{\linewidth}{lrl}%
                    \makebox[8.5cm][c]{\qquad} &  % 使用\makebox创建一个宽度为8.5cm空格
                    \makebox[\@tw][s]{\sffamily\textbf{密级：}} & \linetext{\@cw}{c}{\hnu@secrettext} \\% % 显示“密级：”，并使用linetext命令生成带下划线的内容
                    \makebox[8.5cm][c]{\qquad} &  % 使用\makebox创建一个宽度为8.5cm空格
                    \makebox[\@tw][s]{\sffamily\textbf{中图分类号：}} & \linetext{\@cw}{c}{\hnu@clc} \\%  % 显示“中图分类号：”，并使用linetext命令生成带下划线的内容
                \end{tabularx}
            };%

        % 使用vpostext命令，在页面上方6cm出放置学校的LOGO
        \vpostext{6cm}{\includegraphics[height=2cm]{figures/hnust-logo.png}}%
        % 使用vpostext命令，在页面上方8.3cm处放置论文类型（如博士学位论文）
        \vpostext{8.3cm}{\bf\sffamily\setfontsize{22pt}\hnu@thesisname}%
        % 使用vpostext命令，在页面上方10.5cm处放置论文标题
        \vpostext{12cm}{\bf\sffamily\setfontsize{26pt}\hnu@title}%

        % 使用TikZ在页面的左下角绘制研究生信息
        \tikz[remember picture,overlay]
          \node [xshift=5cm,yshift=-18cm] at (current page.north west)%
            [below right,align=left] {%
                \setlength{\@tw}{94pt}  % 设置标签宽度为94pt
                \setlength{\@cw}{6.4cm} % 设置内容宽度为6.4cm
                \setfontsize{14pt}%   % 设置字体大小为14pt
                % 创建一个表格，显示研究生、导师、学科、研究方向信息
                \begin{tabular}{@{}l@{\hspace{\ccwd}}l@{}}%
                    \makebox[\@tw][s]{\sffamily\textbf{研究生：}} & \linetext{\@cw}{c}{\hnu@author} \\%
                    \makebox[\@tw][s]{\sffamily\textbf{导师：}} & \linetext{\@cw}{c}{\hnu@supervisor} \\%
                    \makebox[\@tw][s]{\sffamily\textbf{学科：}} & \linetext{\@cw}{c}{\hnu@major} \\%
                    \makebox[\@tw][s]{\sffamily\textbf{研究方向：}} & \linetext{\@cw}{c}{\hnu@workon} \\%
                \end{tabular}
            };%
        % 使用vpostext命令，在页面下方25cm处放置论文提交日期
        \vpostext{25cm}{\bf\sffamily\setfontsize{12.5pt}\hnu@submitdate}%
    \end{titlepage} % 结束封面页环境
}

% 中文封面的第二页
\newcommand\make@cntitle@second{%
  \begin{titlepage}% % 开始封面页环境
      % 使用vpostext命令，在页面上方6cm处放置论文标题
      \vpostext{6cm}{\bf\sffamily\setfontsize{22pt}\hnu@title}%
      % 使用TikZ在页面左上角的指定位置绘制表格内容
      \tikz[remember picture,overlay]
        \node [xshift=3.2cm,yshift=-14cm] at (current page.north west)%
          [below right,align=left] {%
              \setlength{\@tw}{128pt} % 标签宽度设置为128pt
              \setlength{\@cw}{8cm}   % 内容宽度设置为8cm
              \setfontsize{14pt}%     % 设置字体大小为14pt
              % 创建表格，显示学位类型、作者姓名、学号、学科、研究方向、导师等信息
              \begin{tabular}{@{}l@{\hspace{\ccwd}}l@{}}%
                  \makebox[\@tw][s]{\sffamily\textbf{学位类型}} & \linetext{\@cw}{c}{\hnu@degree} \\%                     % 学位信息
                  \makebox[\@tw][s]{\sffamily\textbf{作者姓名}} & \linetext{\@cw}{c}{\hnu@author} \\%                     % 作者姓名
                  \makebox[\@tw][s]{\sffamily\textbf{作者学号}} & \linetext{\@cw}{c}{\hnu@authorid} \\%                   % 作者学号
                  \makebox[\@tw][s]{\sffamily\textbf{学科（专业学位类别）}} & \linetext{\@cw}{c}{\hnu@major} \\%           % 专业
                  \makebox[\@tw][s]{\sffamily\textbf{研究方向（专业领域）}} & \linetext{\@cw}{c}{\hnu@workon} \\%          % 研究方向
                  \makebox[\@tw][s]{\sffamily\textbf{导师姓名及职称}} & \linetext{\@cw}{c}{\hnu@supervisor} \\%           % 导师
                  \makebox[\@tw][s]{\sffamily\textbf{实践导师姓名及职称}} & \linetext{\@cw}{c}{\hnu@cosupervisor} \\%     % 实践导师
                  \makebox[\@tw][s]{\sffamily\textbf{所在学院}} & \linetext{\@cw}{c}{\hnu@college} \\%                   % 学院
                  \makebox[\@tw][s]{\sffamily\textbf{论文提交日期}} & \linetext{\@cw}{c}{\hnu@submitdate} \\%             % 提交日期
              \end{tabular}
          };%
  \end{titlepage} % 结束封面页环境
}

% 英文封面
\newcommand\make@entitle{%
    \begin{titlepage}%
        \phantomsection  % 创建一个标记点
        \pdfbookmark[0]{Title Page}{entitlepage}

        \vpostext{3.9cm}{\setfontsize{15pt}{A Dissertation Submitted for the Doctor Degree}}%
        \vpostext{5.9cm}{\setfontsize{22pt}\textbf{\hnu@entitle}}%
        % 使用TikZ在页面的左下角绘制研究生信息
        \tikz[remember picture,overlay]
          \node [xshift=5.5cm,yshift=-18cm] at (current page.north west)%
            [below right,align=left] {%
                \setlength{\@tw}{94pt}  % 设置标签宽度为94pt
                \setlength{\@cw}{6.4cm} % 设置内容宽度为6.4cm
                \setfontsize{14pt}%   % 设置字体大小为14pt
                % 创建一个表格，显示研究生、导师、学科、研究方向信息
                \begin{tabular}{@{}l@{\hspace{\ccwd}}l@{}}%
                    \makebox[\@tw][r]{\sffamily\textbf{Candidate: }} & \linetext{\@cw}{c}{\hnu@enauthor} \\% % 显示“Candidate: ”和研究生英文姓名
                    \makebox[\@tw][r]{\sffamily\textbf{Supervisor and Rank: }} & \linetext{\@cw}{c}{\hnu@ensupervisor} \\%  % 显示“Supervisor and Rank: ”和导师英文姓名
                \end{tabular}
            };%
    \end{titlepage}
}

% 声明
% 定义命令\hnu@declaretext，用于声明论文原创性声明内容
\newcommand{\hnu@declaretext} {
本人郑重声明：所呈交的论文是本人在导师的指导下独立进行研究所取得的研究成果。 除了文中特别加以标注引用的内容外，本论文不包含任何其他个人或集体已经发表或撰写的成果作品。对本文的研究做出重要贡献的个人和集体，均已在文中以明确方式标明。本人完全意识到本声明的法律后果由本人承担。
}

% 定义命令\hnu@authorization，用于声明论文版权使用授权书内容
\newcommand{\hnu@authorization}{
本学位论文作者完全了解学校有关保留、使用学位论文的规定，同意学校保留并向国家有关部门或机构送交论文的复印件和电子版，允许论文被查阅和借阅。本人授权湖南科技大学可以将本学位论文的全部或部分内容编入有关数据库进行检索，可以采用影印、缩印或扫描等复制手段保存和汇编本学位论文。

涉密论文按学校规定处理。
}

% 定义命令\make@statement，用于生成学位论文原创性声明和版权使用授权书页
\newcommand\make@statement{
    \begin{titlepage}% % 开始封面页环境
        \phantomsection  % 创建一个标记点
        \pdfbookmark[0]{原创性声明}{statement}

        \newgeometry{left=3.3cm,right=3.3cm,top=3.5cm, bottom=3cm}  % 设置页面边距
        \thispagestyle{plain} % 设定当前页面样式为plain，即无页眉页脚的样式
        \pagenumbering{gobble}  % 禁止页码显示
        \setcounter{page}{1}    % 设置当前页码为1
        \setfontsize{12.5pt}[20pt]  % 设置正文字体为12pt，行距为20pt
        \vspace*{-0.15cm} % 调整页面上方的垂直间距
        \begin{center}
        \sffamily % 设置无衬线字体
        \setfontsize{18pt}  % 设置标题字体为18pt
        \textbf{学位论文原创性声明} % 居中显示“学位论文原创性声明”
        \end{center}
        \vskip 0.3cm  % 垂直间距为0.3cm

        % 插入声明内容
        \hnu@declaretext\par

        \vskip 1cm  % 垂直间距为1cm
        作者签名：\qquad\qquad\qquad\qquad\qquad\quad 日期：\qquad\quad 年\qquad 月\qquad 日
        \vskip 1cm  % 垂直间距为1cm

        \begin{center}
        \sffamily % 设置无衬线字体
        \setfontsize{18pt}\textbf{学位论文版权使用授权书} % 居中显示“学位论文版权使用授权书”
        \end{center}  
        \vskip 0.3cm  % 垂直间距为0.3cm

        % 插入授权书内容
        \hnu@authorization\par
        \vskip 1cm  % 垂直间距为1cm

        作者签名：\qquad\qquad\qquad\qquad\qquad\quad 日期：\qquad\quad 年\qquad 月\qquad 日
        
        导师签名：\qquad\qquad\qquad\qquad\qquad\quad 日期：\qquad\quad 年\qquad 月\qquad 日
        \restoregeometry
    \end{titlepage} % 结束封面页环境
}

% 摘要、关键字
% 定义中文摘要环境
\newenvironment{abstract}{%
    \cleardoublepage  % 插入双页清除符号，确保摘要从奇数页开始
    \pagenumbering{roman} % 使用罗马数字页码
    \hnu@chapter{\hnu@abstractname}%  % 调用自定义的hnu@chapter命令，插入“摘要”标题
    \addtocontents{toc}{\protect\contentsline{chapter}{\hnu@abstractname}{\thepage}{}}% 只添加到目录
    \setcounter{page}{1}  % 设置当前页码为1
    \thispagestyle{empty}   % 清除当前页面的页眉和页脚
}{}

% 定义英文摘要环境
\newenvironment{enabstract}{%
    \cleardoublepage    % 确保英文摘要也从一个新页开始
    \begingroup % 开始一个组，限制字体设置的作用范围
        \ctexset{chapter/format=\centering\rmfamily\bfseries\setfontsize{18pt}}%  % 设置英文摘要标题的字体为18pt，加粗，居中，使用衬线字体
        \hnu@chapter[Abstract]{\hnu@enabstractname}% % 插入“Abstract”标题
    \endgroup % 结束组
    \addtocontents{toc}{\protect\contentsline{chapter}{\hnu@enabstractname}{\thepage}{}}% 只添加到目录
    \thispagestyle{empty}
}{}

% 定义总结与展望环境
\newenvironment{summary}{%
    \hnu@chapter{\hnu@summaryname}% % 插入“总结与展望”标题
    % \addcontentsline{toc}{chapter}{\hnu@summaryname}  % 将“总结与展望”标题添加到目录中，作为章级别
}{}

% 定义致谢环境
\newenvironment{acknowledgements}{%
  \chapter{\hnu@acknowledgementsname}%  % 插入“致谢”标题
  % \addcontentsline{toc}{chapter}{\hnu@acknowledgementsname}
}{}

% 定义中文关键词命令
\newcommand\keywords[1]{%
  \par\phantom{empty}\par\noindent\hangindent=4\ccwd\relax% % 设置缩进4个中文字符宽度，插入关键词部分
  \sffamily\textbf{关键词}：#1} % 使用无衬线字体，加粗显示“关键词”，并输出关键词内容
% 定义英文关键词命令
\newcommand\enkeywords[1]{%
  \par\phantom{empty}\par\noindent\hangindent=5.3em\relax%  % 设置缩进5.3em，插入关键词部分
  \textbf{Key Words}: #1} % 加粗显示“Key Words”，并输出关键词内容

% 目录
\renewcommand\tableofcontents{%
    \clearpage% % 插入分页符，确保目录从新页开始
    \pagenumbering{Roman} % 使用罗马数字作为目录的页码
    \setcounter{tocdepth}{2}  % 设置目录深度为2，即包括章、节、小节
    % \addcontentsline{toc}{chapter}{\hnu@tocname}
    \hnu@chapter{\hnu@tocname}% % 调用自定义命令\hnu@chapter，插入“目录”标题
    \@starttoc{toc} % 启动目录文件（toc），生成目录内容
}

% 加载titletoc宏包，用于自定义目录格式
\RequirePackage{titletoc}
% 定义目录中的引导符为点线
\newcommand\hnu@leaders{\titlerule*[0.5pc]{$\cdot$}}
  % 定义章级别的目录格式
  \titlecontents{chapter}[0bp]
    {\addvspace{6bp}\bf\sffamily\setfontsize{12.5pt}[15pt]} % 设置字体为无衬线，加粗，字号12.5pt，行距15pt
    {\contentspush{\thecontentslabel\unskip\hskip\ccwd\relax}}  % 在章标题后插入一个中文字符宽度的空格
    {}{\hnu@leaders\setfontsize{12.5pt}[12.5pt]\contentspage} % 设置引导符为点线，页码字体为12.5pt，行距12.5pt
  % 定义节级别的目录格式
  \titlecontents{section}
      [2\ccwd]  % 节目录项的缩进为2个中文字符宽度
      {\setfontsize{12.5pt}[20pt]}  % 字体大小为12.5pt，行距20pt
      {\contentspush{\thecontentslabel\hskip\ccwd\relax}} % 在节标题后插入一个中文字符宽度的空格
      {}{\hnu@leaders\setfontsize{12.5pt}[12.5pt]\contentspage} % 设置引导符为点线，页码字体为12.5pt，行距12.5pt
  % 定义小节级别的目录格式
  \titlecontents{subsection}
      [4\ccwd]  % 小节目录项的缩进为4个中文字符宽度
      {\setfontsize{12.5pt}[20pt]}  % 字体大小为12.5pt，行距20pt
      {\contentspush{\thecontentslabel\hskip\ccwd\relax}} % 在小节标签后加入中文字符宽度的空格
      {}{\hnu@leaders\setfontsize{12.5pt}[12.5pt]\contentspage} % 设置引导符为点线，页码字体为12.5pt，行距12.5pt

  % 图目录的格式
  \titlecontents{figure}[0bp]
      {\setfontsize{12.5pt}}  % 设置字体大小为12.5pt
      {\figureautorefname\hspace*{0.5em}\thecontentslabel\quad} % 在图目录中显示图编号及其标题
      {}{\hnu@leaders\contentspage} % 使用引导符显示到页码
  % 表目录的格式
  \titlecontents{table}[0bp]
      {\setfontsize{12.5pt}}  % 设置字体大小为12.5pt
      {\tableautorefname\hspace*{0.5em}\thecontentslabel\quad}  % 在表目录中显示表编号及其标题
      {}{\hnu@leaders\contentspage} % 使用引导符显示到页码

% 为了让图目录另页起，重新定义 \cs{listoffigures}
\renewcommand\listoffigures{%
    \clearpage  % 插入分页符，确保图目录从新页开始
    \hnu@chapter{\listfigurename}%  % 插入“插入索引”作为章级标题
    % \addcontentsline{toc}{chapter}{\listfigurename} % 将图目录标题添加到目录中，作为章级别
    \@starttoc{lof}}  % 生成图目录内容
% 为了让图目录另页起，重新定义 \cs{listoffigures}
\renewcommand\listoftables{%
    \clearpage % 插入分页符，确保表目录从新页开始
    \hnu@chapter{\listtablename}% % 插入“表目录”作为章级标题
    % \addcontentsline{toc}{chapter}{\listtablename}  % 将表目录标题添加到目录中，作为章级别
    \@starttoc{lot}}  % 生成表目录内容

% 定义notation环境，用于生成符号说明部分
\newenvironment{notation}{%
    \cleardoublepage % 确保符号说明部分从新页开始
    \thispagestyle{hnu@notation}  % 使用自定义页眉页脚样式 hnu@notation
    \ctexset{chapter/format = \centering\rmfamily\setfontsize{12bp}} % 设置章标题格式为居中，衬线字体，字号12bp
    \hnu@chapter{\hnu@notationname} % 插入“符号说明”章标题
    \setfontsize{10.5bp}[16bp]  % 设置字体大小为10.5bp，行距为16bp
    \setlength{\itemsep}{0bp}}{}  % 设置列表项之间的垂直间距为0bp

% 定义尺寸单位bp（big point），用于精确控制字体大小
\newdimen\bp@ \bp@=1bp

% 重定义normalsize命令
\renewcommand\normalsize{%
  \@setfontsize\normalsize{12\bp@}{20\bp@}% % 设置正文字体大小为12bp，行距为20bp
    % 以下设置于数学公式的垂直间距有关
  \abovedisplayskip 12\bp@ \@plus3\bp@ \@minus7\bp@ % 普通公式上方间距：默认值为12bp，可扩展至15bp，可收缩至5bp
  \abovedisplayshortskip \z@ \@plus3\bp@  % 段公式上方间距：默认值为0bp，可扩展至3bp
  \belowdisplayshortskip 6.5\bp@ \@plus3.5\bp@ \@minus3\bp@ % 段公式下方间距：默认值为6.5bp，可扩展至10bp，可收缩至3.5bp
  \belowdisplayskip \abovedisplayskip % 普通公式下方间距设置为与上方相同
  \let\@listi\@listI  % 使用标准的列表缩进格式
} 
\normalsize % 应用normalsize命令

% 重定义small命令
\renewcommand\small{%
    \@setfontsize\small{10.5\bp@}{17.5\bp@}%  % 设置字体大小为10.5bp，行距为17.5bp
    % 以下设置于数学公式的垂直间距有关
    \abovedisplayskip 10.5\bp@ \@plus3\bp@ \@minus6\bp@ % 普通公式上方间距：默认值为10.5bp，可扩展至13.5bp，可收缩至4.5bp
    \abovedisplayshortskip \z@ \@plus3\bp@  % 段公式上方间距：默认值为0bp，可扩展至3bp
    \belowdisplayshortskip 6.5\bp@ \@plus3.5\bp@ \@minus3\bp@ % 段公式下方间距：默认值为6.5bp，可扩展至10bp，可收缩至3.5bp
    % 定义列表格式
    \def\@listi{\leftmargin\leftmargini % 使用默认的左边距
                \topsep 9\bp@ \@plus3\bp@ \@minus5\bp@  % 列表顶部间距：默认值为9bp，可扩展至12bp，可收缩至4bp
                \parsep 4.5\bp@ \@plus2\bp@ \@minus\bp@ % 段落间距：默认值为4.5bp，可扩展至6.5bp，可收缩至3.5bp
                \itemsep \parsep  % 设置项目间距等于段落间距
    }%  
    \belowdisplayskip \abovedisplayskip % 普通公式下方间距设置为与上方相同
}

% 重新定义\footnotesize命令
\renewcommand\footnotesize{%  
    \@setfontsize\footnotesize{9\bp@}{15\bp@} % 设置字体大小为9bp，行距为15bp
    % 以下设置于数学公式的垂直间距有关
    \abovedisplayskip 9\bp@ \@plus2\bp@ \@minus5\bp@  % 普通公式上方间距：默认值为9bp，可扩展至11bp，可收缩至4bp
    \abovedisplayshortskip \z@ \@plus3\bp@  % 短公式上方间距：默认值为0bp，可扩展至3bp
    \belowdisplayshortskip 6\bp@ \@plus3\bp@ \@minus3\bp@ % 短公式下方间距：默认值为6bp，可扩展至9bp，可收缩至3bp
    % 定义列表格式
    \def\@listi{\leftmargin\leftmargini % 使用默认的左边距
                \topsep 6\bp@ \@plus2\bp@ \@minus2\bp@  % 列表顶部间距：默认值为6bp，可扩展至8bp，可收缩至4bp
                \parsep 3\bp@ \@plus2\bp@ \@minus\bp@   % 段落间距：默认值为3bp，可扩展至5bp，可收缩至2bp
                \itemsep \parsep  % 设置项目间距等于段落间距
    }% 
    \belowdisplayskip \abovedisplayskip % 普通公式下方间距设置为与上方相同
}

% 重新定义\scriptsize命令，设置字体大小为7.5bp，行距为12.5bp，通常用于上标、下标或非常小的注释文本
\renewcommand\scriptsize{\@setfontsize\scriptsize{7.5\bp@}{12.5\bp@}}
% 重新定义\tiny命令，设置字体大小为6.5bp，行距为10.83bp，这是最小的预定义字体大小，用于极小的文本
\renewcommand\tiny{\@setfontsize\tiny{6.5\bp@}{10.83\bp@}}
% 重新定义\large命令，设置字体大小为15bp，行距为25bp，用于稍大于正常大小的文本，如小节标题
\renewcommand\large{\@setfontsize\large{15\bp@}{25\bp@}}
% 重新定义\Large命令，设置字体大小为18bp，行距为30bp，用于更大的文本，如节标题
\renewcommand\Large{\@setfontsize\Large{18\bp@}{30\bp@}}
% 重新定义\LARGE命令，设置字体大小为22bp，行距为36.67bp，用于大型标题或强调文本
\renewcommand\LARGE{\@setfontsize\LARGE{22\bp@}{36.67\bp@}}
% 重新定义\huge命令，设置字体大小为24bp，行距为40bp，用于非常大的标题或特别强调的文本
\renewcommand\huge{\@setfontsize\huge{24\bp@}{40\bp@}}
% 重新定义\Huge命令，设置字体大小为26bp，行距为43.33bp，这是最大的预定义字体大小，用于最大的标题或极度强调的文本
\renewcommand\Huge{\@setfontsize\Huge{26\bp@}{43.33\bp@}}

% 排版风格，标题，图表
\setlength{\parindent}{2\ccwd}  % 设置段落首行缩进为两个中文字符宽度
\setlength{\parskip}{\z@}   % 设置段落间距为0
\RequirePackage{upgreek}    % 引入upgreek宏包，用于提供额外的希腊字母
\renewcommand\pi{\uppi}   % 重定义\pi命令，使用直立体的π符号
\RequirePackage{amssymb}  % 引入amssymb宏包，用于提供额外的数学符号
% 重新定义小于等于和大于等于符号
\renewcommand\le{\leqslant}
\renewcommand\leq{\leqslant}
\renewcommand\ge{\geqslant}
\renewcommand\geq{\geqslant}
% 设置不同尺寸的数学字体大小，参数分别是：文本大小，数学显示大小、上下标大小、次级上下标大小
\DeclareMathSizes{10.5bp}{10.5bp}{7.35bp}{5.25bp}
% 调整浮动体的参数
\renewcommand{\topfraction}{.85}  % 页面顶部最大可占用的浮动体比例
\renewcommand{\bottomfraction}{.65} % 页面底部最大可占用的浮动体比例
\renewcommand\textfraction{.15}   % 页面必须由文本占用的最小比例
\renewcommand{\floatpagefraction}{.6} % 浮动页面被占满的最小比例
% 引入caption宏包，用于设置图表标题格式
\RequirePackage{caption}
% yinru calc 宏包，用于计算
\RequirePackage{calc}
% 定义新的标题标签分隔符zhspace，使用一个中文字符的宽度作为间距
\DeclareCaptionLabelSeparator{zhspace}{\hspace{\ccwd}}
\captionsetup{  % 设置所有标题的通用格式
    format = hang,  % 使用悬挂缩进格式
    font = {small,bf},  % 使用小号加粗字体
    labelsep = zhspace, % 使用前面定义的zhspace作为标签分隔符
}
\captionsetup[figure]{  % 专门为图片（figure）设置标题格式
    position = bottom,  % 标题谓语图片下方
    aboveskip = 6bp,  % 图片与标题之间的间距为6bp
    belowskip = {12bp-\intextsep},  % 标题与后续内容之间的距离为12bp减去intextsep（文本间距）
}
\captionsetup[table]{ % 专门为表格（table）设置标题格式
    position = top, % 标题位于表格上方
    aboveskip = 6bp,  % 标题与表格之前内容之间的距离为6bp
    belowskip = 6bp,  % 标题与表格之间的距离为6bp
}
% 定义新命令\note 用于添加注释
\newcommand\note[1]{%
    \captionsetup{  % 设置注释样式
        position = bottom,  % 位置在底部
        font = small  % 使用小号字体
    } 
    \caption*{  % 创建注释
        \hangindent=2\ccwd  % 设置悬挂缩进为2个中文字符宽度
        \relax  % 取消缩进
        \hnu@notesname  % 插入预定义的注释名称（如“注：”）
        \rmfamily % 使用罗马字体
        #1  % 注释内容
    }
}
% 自定义脚注样式，重新定义脚注编号为圆圈包围的数字
\renewcommand{\thefootnote}{\hnu@textcircled{footnote}}
% 重定义脚注分隔线
\renewcommand\footnoterule{%
    \kern-3\p@  % 向上移动3点
    \hrule\@width.25\textwidth  % 绘制宽度为文本宽度25%的水平线
    \kern2.6\p@ % 向下移动2.6点
}
% 重定义脚注文本格式
\renewcommand\@makefntext[1]{%
    \parindent 2\ccwd%  % 设置段落缩进为两个中文字符宽度
    \noindent % 取消缩进
    \hb@xt@2\ccwd{  % 创建脚注标记盒子
        \hss\@makefnmark  % 右对齐脚注标记
    }
    #1  % 脚注内容
}

% 引入natbib包，用于管理参考文献
\RequirePackage[sort&compress]{natbib}
% 定义不同的参考文献样式
\newcommand\bibstyle@super{\bibpunct{[}{]}{,}{s}{,}{\textsuperscript{,}}} % 定义上标引用样式
\newcommand\bibstyle@numbers{\bibpunct{[}{]}{,}{n}{,}{,}} % 定义数字引用样式
\newcommand\bibstyle@authoryear{\bibpunct{(}{)}{;}{a}{,}{,}}  % 定义作者-年份引用样式
% 定义用于比较的临时变量
\def\tmp@numerical{numerical} 
\def\tmp@authoryear{authoryear}
% 定义湖南科技大学自定义的参考文献样式命令
\newcommand\hnubibstyle[1]{%
    % 将输入参数存储在临时变量中
    \def\tmp@gbt{#1}%
    % 如果输入参数是“numerical”，则使用数字引用样式
    \ifx\tmp@gbt\tmp@numerical%
      \bibliographystyle{hnunumerical}%
    \fi%
}
\if@hnu@numerical % 如果使用数字引用样式
  \if@hnu@super % 如果使用上标引用样式
    \citestyle{super} % 设置引用样式为上标
  \else % 如果不使用上标引用样式
    \citestyle{numbers} % 设置引用样式为数字
  \fi
  % 设置参考文献样式为湖南科技大学数字样式
  \bibliographystyle{hnunumerical}%
\else % 如果不使用数字引用样式
  \citestyle{authoryear}  % 设置引用样式为作者-年份
  % 设置参考文献样式为湖南科技大学作者-年份样式
  \bibliographystyle{hnuauthoryear}%
\fi

% 引用
% 修改\NAT@citexnum命令，使其支持上标引用
\patchcmd\NAT@citexnum
% 原代码
{%
  \@ifnum{\NAT@ctype=\z@}{% % 如果引用类型是数字
    \if*#2*\else\NAT@cmt#2\fi % 如果有注释，添加注释
  }{}%
  \NAT@mbox{\NAT@@close}% % 添加结束括号
}
% 新代码
{%
  \NAT@mbox{\NAT@@close}% % 首先添加结束括号
  \@ifnum{\NAT@ctype=\z@}{% % 如果引用类型是数字
    \if*#2*\else\textsuperscript{#2}\fi % 如果有注释，作为上标添加
  }{}%
}{}{} % 成功和失败是的操作（此处为空）

% 重定义上标引用命令
\renewcommand\NAT@citesuper[3]{%  % #1=引用编号，#2=前缀，#3=后缀
    \ifNAT@swa  % 如果启用了作者-年份选项
        \if*#2*\else#2\NAT@spacechar\fi % 如果有前缀，添加前缀和空格
        \unskip\kern\p@\textsuperscript{\NAT@@open#1\NAT@@close\if*#3*\else#3\fi}%  % 添加上标
    \else 
        #1%  % 如果没有启用作者-年份选项，直接输出引用编号
    \fi
    \endgroup
}

% 重新定义数字引用命令
\renewcommand\NAT@citenum[3]{%  % #1=引用编号，#2=前缀，#3=后缀
    \ifNAT@swa  % 如果启用了作者-年份选项
        \NAT@@open  % 添加开始括号
        \if*#2*\else#2\NAT@spacechar\fi % 如果有前缀，添加前缀和空格
        #1\NAT@@close % 添加引用编号和结束括号
        \if*#3*\else\textsuperscript{#3}\fi % 如果有后缀，作为上标添加
    \else
        #1% % 如果没有启用作者-年份选项，只显示引用编号
    \fi
    \endgroup
}

% 修改 \NAT@citex命令，用于一般引用
\patchcmd{\NAT@citex}
% 原代码
{%
  \if*#2*\else\NAT@cmt#2\fi % 如果有注释，添加注释
  \if\relax\NAT@date\relax\else\NAT@@close\fi % 如果有日期，添加结束括号
}
% 新代码
{%
  \if\relax\NAT@date\relax\else\NAT@@close\fi % 如果有日期，添加结束括号
  \if*#2*\else\textsuperscript{#2}\fi % 如果有注释，作为上标添加
}{}{} % 成功和失败时的操作（此处为空）

% 重新定义一般引用命令
\renewcommand\NAT@cite[3]{% % #1=引用内容，#2=前缀，#3=后缀
    \ifNAT@swa  % 如果启用了作者-年份选项
        \NAT@@open  % 添加开始括号
        \if*#2*\else#2\NAT@spacechar\fi % 如果有前缀，添加前缀和空格
        #1\NAT@@close % 添加引用内容和结束括号
        \if*#3*\else\textsuperscript{#3}\fi % 如果有后缀，作为上标添加
    \else
        #1%  % 如果没有启用作者-年份选项，只显示引用内容
    \fi
    \endgroup
}

% 重定义参考文献字体，使用正常字体，大小为12pt，行距为20pt
\renewcommand\bibfont{\normalfont\fontsize{12pt}{20pt}\selectfont}
\setlength{\bibsep}{0bp}  % 设置参考文献条目之间的垂直间距为0bp
\setlength{\bibhang}{2\ccwd}  % 设置参考文献条目的缩进为两个中文字符宽度
% 重定义参考文献标签的格式
\renewcommand\@biblabel[1]{[#1]\hfill}  % 将标签放在方括号中，并右对齐
\urlstyle{same} % 设置所有URL的字体样式与正文相同
% 为URL添加更多的断行点，允许在所有字母和数字后断行
\g@addto@macro\UrlBreaks{%
  \do\a\do\b\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j%
  \do\k\do\l\do\m\do\n\do\o\do\p\do\q\do\r\do\s\do\t%
  \do\u\do\v\do\w\do\x\do\y\do\z%
  \do\A\do\B\do\C\do\D\do\E\do\F\do\G\do\H\do\I\do\J%
  \do\K\do\L\do\M\do\N\do\O\do\P\do\Q\do\R\do\S\do\T%
  \do\U\do\V\do\W\do\X\do\Y\do\Z%
  \do\1\do\2\do\3\do\4\do\5\do\6\do\7\do\8\do\9\do\0%
}
% 重定义参考文献章级格式
\renewcommand\bibsection{%
    \@mainmatterfalse % 临时关闭主题内容标志
    \chapter{\bibname}% % 创建一个新的章，标题为“参考文献”
    \@mainmattertrue  % 恢复主体内容标志
}

% 数学符号：
% 引入amsmath（提供增强的数学排版功能）和amsthm（提供定理环境的支持）宏包
\RequirePackage{amsmath,amsthm}
\makeatletter % 开始一个LaTex内部命令定义区块
% 向\normalsize命令添加额外的设置，用于调整数学公式的垂直间距
\g@addto@macro\normalsize{%
  \setlength\abovedisplayskip{16pt} % 设置普通数学显示（display math）上方的垂直空间为16pt
  \setlength\belowdisplayskip{16pt} % 设置普通数学显示下方的垂直空间为16pt
  \setlength\abovedisplayshortskip{16pt}  % 设置短数学显示（可能只有一行）上方的垂直空间为16pt
  \setlength\belowdisplayshortskip{16pt}  % 设置短数学显示下方的垂直空间为16pt
}
% \newcommand\eu{\mathrm{e}}
% \newcommand\iu{\mathrm{i}}
%\newcommand*{\diff}{\mathop{}\!\mathrm{d}}
%\DeclareMathOperator*{\argmax}{arg\,max}
%\DeclareMathOperator*{\argmin}{arg\,min}
% 数学定理：
% 以下定义数学定理环境默认风格为 hnuplain。
\newtheoremstyle{hnuplain}%
    {}{}% % 定理前后的垂直空白：都设为默认
    {}{2\ccwd}% % 定理主体的缩进两：无缩进
    {\bfseries}{}%  % 定理主体的段间距：两个中文字符宽度
    {\ccwd}{} % 定理头后的空白：一个中文字符宽度；定理附注的字体：默认
\theoremstyle{hnuplain} % 将当前的定理样式设置为刚刚定义的hnuplain

% 定义各种数学结构的中文名称
\newcommand\hnu@assertionname{断言}
\newcommand\hnu@axiomname{公理}
\newcommand\hnu@corollaryname{推论}
\newcommand\hnu@definitionname{定义}
\newcommand\hnu@examplename{例}
\newcommand\hnu@lemmaname{引理}
\newcommand\hnu@proofname{证明}
\newcommand\hnu@propositionname{命题}
\newcommand\hnu@remarkname{注}
\newcommand\hnu@theoremname{定理}
% 定义新的定理环境，[chapter]表示每章重新编号
\newtheorem{theorem}                {\hnu@theoremname}     [chapter]
% 定义其他定理环境，[theorem]表示与定理共用编号
\newtheorem{assertion}  [theorem]   {\hnu@assertionname}
\newtheorem{axiom}      [theorem]   {\hnu@axiomname}
\newtheorem{corollary}  [theorem]   {\hnu@corollaryname}
\newtheorem{lemma}      [theorem]   {\hnu@lemmaname}
\newtheorem{proposition}[theorem]   {\hnu@propositionname}
% 定义单独编号的环境
\newtheorem{definition}             {\hnu@definitionname}  [chapter]
\newtheorem{example}                {\hnu@examplename}     [chapter]
% 定义不编号的环境
\newtheorem*{remark}                {\hnu@remarkname}
% \pkg{amsthm} 单独定义了 proof 环境，这里重新定义以满足格式要求。
% 原本模仿 \pkg{amsthm} 写成 |\item[\hskip\labelsep\hskip2\ccwd #1\hskip\ccwd]|，
% 但是却会多出一些间隙。

% 重新定义证明环境
\renewenvironment{proof}[1][\proofname]{
    \par  % 开始新段落
    \pushQED{\qed}% % 将QED符号推入堆栈，以便在证明结束时使用
    \normalfont % 设置为正常字体 
    \topsep6\p@\@plus6\p@\relax % 设置顶部间距，允许额外的6pt弹性空间
    \trivlist % 开始一个简单列表环境
        \item\relax % 添加一个列表项
        \hskip2\ccwd  % 水平空格，宽度为两个中文字符
        \textbf{#1} % 以粗体显示参数（默认为“证明”）
        \hskip\ccwd\ignorespaces  % 添加一个中文字符宽度的空格，忽略后续空白
    }{% % 环境结束的定义
    \popQED % 弹出QED符号并显示
    \endtrivlist  % 结束简单列表环境
    \@endpefalse  % 禁止在段落末尾添加额外的垂直空间
}
% 将\proofname重定义为之前设置的中文“证明”
\renewcommand\proofname\hnu@proofname

% 算法和代码：
% 引入algorithm2e宏包，用于排版算法
\RequirePackage[
    algoruled,  % 使用带框的算法样式
    algochapter,  % 算法编号包含章节号
    lined,  % 为算法添加行号
    linesnumbered % 显示行号
]{algorithm2e}
% 重新定义算法名称为中文“算法”
\renewcommand{\algorithmcfname}{算法}
% 引入listings宏包，用于代码列表显示
\RequirePackage{listings}
% 设置代码列表的全局样式
\lstset{
    basicstyle=\small\ttfamily, % 使用小号等宽字体
    xleftmargin=2pc,  % 左边距为2个字符宽度
    xrightmargin=2pc, % 右边距为2个字符宽度
    frame=single, % 添加单线框
    columns=flexible, % 灵活调整列宽，适应不同字符宽度
    numbers=left, % 在左侧显示行号
}
% 定义命令用于记住当前算法的行号
\newcommand{\rememberlines}{
    \xdef\rememberedlines{\number\value{AlgoLine}}
}
% 定义命令用于恢复之前记住的行号
\newcommand{\resumenumbering}{
    \setcounter{AlgoLine}{\rememberedlines}
}
% 引入tcolorbox宏包的skins库，用于创建高度可定制的彩色盒子
\RequirePackage[skins]{tcolorbox}
% 定义新的tcolorbox环境talgorithm，用于排版算法
\newtcolorbox{talgorithm}[2][]{%
  blanker,  % 使用空白样式
  float=tbp,  % 允许浮动（顶部、底部或页面）
  grow to left by=#2, % 向左扩展的宽度
  grow to right by=#2,  % 向右扩展的宽度
  before upper={\begin{algorithm}[H]},  % 在内容前开始algorithm环境
  after upper={\end{algorithm}},  % 在内容后结束algorithm环境
  #1  % 允许额外的自定以选项
}
