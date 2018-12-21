


### Own:
------------------------------------

* 证书发包流程 -- https://www.cnblogs.com/sunfuyou/p/5900592.html
* 发布流程 --  https://www.jianshu.com/p/817686897ec1?open_source=weibo_search

蒲公英打包发布 ---蒲公英认证 : https://www.jianshu.com/p/b8f8509f64fa

*. Releal使用： https://www.cnblogs.com/lucky-star-star/p/6699267.html

* SVN使用： https://www.cnblogs.com/fyongbetter/p/5404697.html

iOS 配置多个环境变量： https://www.jianshu.com/p/83b6e781eb51

*** develop local Video paly and you can edit camera.  --- 仿抖音效果
*** develop Map
*** pay
*** chat
*** draw image
*** Charles 可以抓取网页端数据，进行相关测试
*** Charles use :  https://www.jianshu.com/p/e6360f1d1c6f  || https://blog.csdn.net/u013538542/article/details/79107106 || tangqiao: https://juejin.im/entry/56488b7660b20fc9b9c2f0be

https://blog.csdn.net/muyimo/article/details/83344431

HACK net website: http://www.weixianmanbu.com/page_2.html

1. 提供给学生的兼职平台
2. 提供给用户的旅游平台
3. 相互学生的交流平台


为基础和面试准备：
//2. 基础知识解决后，在进行后续的 `视频播放器` 和 `地图` 、`蓝牙` `AR`  `摄像头` ，`支付`,`分享`甚至是聊天环信项目的Demo工程。
//4. 二维码扫描和制作

*. 看面试题目进行相关基础知识学习
*. 第三方整合使用，友盟或者Google统计，还有分享的使用。
*. Apple 内置功能调用使用，SIM卡调用，通讯录调用，NFC调用。

Interview question:
http://blog.cocoachina.com/article/73184

leave:

1. save `AHZX file`。
2. delete `other...`。
3. 记住把git信息变更。 -- 删除~/.gitconfig + ~/.ssh 需要可以给用户自动生成。


### 今日做

12.21 周五


* AFNetworkin原理/底层
* SDWebImage原理
* Masonry原理底层

* CoreData/归档使用
* 处理网络视频播放/变下边播放/后台播放 ==> https://www.jianshu.com/p/93ce1748ea57
* 音频
* 相机调用并处理/相册
* 流媒体学习

* 主要对前面知识整理/iOS基础教程


* iCoud
* 内购整理
* GameCenter使用
* 广告整合



* 友盟统计加入 -- 埋点+推送
* QQ/微信/支付宝 + 登录+支付
* Shell 脚本学习
* python学习




整理知识点：

before:
//*  继续进行视频播放器的处理。 --> 做出基本视频功能，具备全屏播放/自动旋转屏幕处理。

*  进行Github项目的OpenGL ES项目的处理，视频处理相关 / 查看相关其它视频播放器的实现 / 抖音上下滑动效果的实现。
*  进行iOS `支付` 的相关问题，开始。 ==> 完成部分功能。
* 进行iOS `地图` 功能加入
* 继续整理`AHZX`,以及加密方法查看使用和其它工具类的使用处理。


### git知识学习:

// 注意: 所有的配置如果需要生效只有在配置更改信息后的下次变更时才会生效。
查看全局的 git配置，git cofnig 命令（在~/.gitconfig目录文件中存储的git global信息）
$ git config --global --edit (直接修改文件即可修改git全局配置的相关信息)
若需要直接从终端查看 user.name/user.email
$ git config --global user.name     // 查看global user name
$ git config --global user.email    // 查看global user eamil

查看或配置当前项目git 的相关信息（包括user.name+user.email+Author）
$ git show  //查看当前项目的相关信息
$ git config user.name //查看当前项目的user name
$ git config user.email //查看当前项目的user email
$ git config user.name "GDayao" // 更改当前项目的 user name
$ git config user.email "xxxx@xx.com" // 更改当前项目的 user email ==> 注意这里的邮箱若和github/gitlab的注册邮箱相同则在提交历史中会显示头像否则为github默认头像
// 当前项目的config配置Author信息可以和全局配的config信息不相同。所以在全局的config没有配置的情况下，也可以配置当前项目的某些信息内容。




-   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -  -   

### Com:


代码整理： 
1. imageNamed，图片名字命名全部把中文替换成英文。

更新 customUI method


11-27


开发者证书分为 开发 和 发布 两种，类型为ios Development,iOS Distribution

//1. 查看发布者证书和开发者证书流程

//2. 进行上线发布App准备，包括描述语句和提供测试账号

// 3. iCon 文件制作多个图标

//4. 提交一个版本进行测试  (注意网络的VPN地址)

11-30

*后面增加隐私政策和使用条款。


12-3

// * 更改iMac中的界面UI及适配，未拷贝。 --- 已从新更改完成
// * 增加更新弹框提醒

18-12-5/12-6
//* 去除报告生成中的正在加载的短暂加载框的显示
//* 点击发送邮件至邮箱做点击发送后关闭弹框的处理。


18-12-7

//* 增加网络连接失败或者关闭的 alert弹框
//* 抓包检测
//* 新老用户区分



* base64 加密规则  -- 对加密方式进行处理


***** 可能考虑未加入功能 ****
* 好评评分的加入
* 增加找回密码功能。
* 数据请求操作做缓存处理功能。
* 检查报告下载是否是网络请求被阻塞了
* 进行存放用户名和密码的组件框架



deal code --p
1. 整理界面代码，对界面代码进行重构或者优化。
2. 对性能进行检测和调优。
3. 对网络请求数据进行处理或者更好的处理。
4. 处理数据缓存和数据解析。





