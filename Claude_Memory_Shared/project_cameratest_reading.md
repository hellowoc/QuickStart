---
name: cameratest-reading-complete
description: CameraTest 色选机 Qt 工程阅读已全部完成，13 个模块均已覆盖
metadata: 
  node_type: memory
  type: project
  originSessionId: b3868053-b668-42ce-93f4-891d6fdb272b
---

# CameraTest 工程阅读完成

**完成时间**: 2026-05-27

**阅读路径**: main.cpp → ZKSort → MiddleWidgetManager → GlobalFlow/Runtime → bus/ → data/ → mysortwidget/ → mainpage/ → factoryset/ → engineerset/ → systeminfo/ → autocontrol/ → arithprofilewidget/

**导出文档位置**: `Desktop/mdData/` 共 20+ 篇 md 文档

**工程定位**: 工业色选机上位机控制系统（Qt4 + Linux ARM），自研品牌（中科 zksort）

**核心结论**:
- 不是一个状态机，而是过程式硬件通信系统
- GlobalFlow 是翻译官，不是状态机
- FPGA 和 IPC AI 是并行互补的分选引擎，不是二选一

## 第二阶段：网络通信与界面控件（2025-06-10 完成）

**覆盖内容**：三通道UDP通信（IPC命令/FPGA相机/高速抓图）→ 4个界面控件溯源（系统状态/IPC信息/远程控制/WiFi配置）→ MQTT远程控制 → HTTP协议 → BSD Socket vs Qt QUdpSocket → WiFi整合方案设计 → MQTT全链路深度学习（协议规范→嵌入式部署）→ MQTT加密体系框架 → TCP协议对照 → 网络分层详解

**导出文档**：35+ 个MD文档，包含 13 个references/参考文件、主文档+基础知识双文档对照、设计文档、学习总结

**关键认知**：
- 三通道 UDP 中各通道的 socket 类型选择（BSD vs Qt）取决于数据频率和线程模型
- MQTT 三件套（mqttsrv/mqttThread/mqttMsgParaseThread）的职责分离：连接层 vs 业务层
- MQTT QoS 2 的四步握手（PUBLISH→PUBREC→PUBREL→PUBCOMP）与 TCP 三次握手的层次区别
- 20+ 远程命令的全链路：手机→Broker→on_message→recvMsgList→doParseMessage→onCmdXxx→硬件
- 标志位驱动的异步上传机制：20+ 个 int 标志位，主循环每秒轮询，解耦生产者消费者
- 网络分层五层模型中，应用层/传输层只在两端处理，网络层在两端+路由器处理

**待补**：缺少动手实践验证（未实际改代码或做测试）

# CameraTest 色选机工程

## 项目概述
- 工业色选机上位机程序，基于 Qt 4.8.4，约 15 万行代码，500+ 文件
- 原始目标平台：嵌入式 Linux ARM
- 构建系统：qmake（solution.pro → zksort/zksort.pro）
- 通信协议：自定义二进制帧 + 串口（与 FPGA/PLC 通信）+ UDP（与 IPC 工控机通信）

## 工程结构
```
CameraTest/
├── solution.pro          # 顶层 subdirs，串联 3rdparty、uikits、zksort
├── zksort/
│   ├── zksort.pro        # 主工程文件
│   ├── main.cpp          # 入口：启动日志、加载配置、显示主窗口
│   ├── global/           # 全局数据层
│   │   ├── constant.h    # 892 行宏定义：CMD_ 协议命令字、MAX_ 容量上限、界面 ID
│   │   ├── globalparams.h # 1858 行结构体定义：所有数据结构（IPC、相机、算法、配置）
│   │   ├── globalflow.h/cpp # 全局流程控制：initAll()、参数发送、IPC/UDP 通信
│   │   ├── material.h/cpp # 物料参数
│   │   ├── mylanguage.h/cpp # 多语言切换
│   │   ├── myautofeed.cpp  # 自动供料
│   │   ├── myfscheck.cpp   # 文件系统检查
│   │   └── mythread.h      # 线程基类
│   ├── bus/              # 通信层
│   │   ├── myqextserialport.h/cpp # 串口通信核心：MyQextSerialPort（Windows QextSerialPort）和 ZkSerialPort（Linux 原生串口）
│   │   ├── mynetwork.h/cpp  # UDP 网络通信（与 IPC 工控机）
│   │   ├── myfastnetwork.h/cpp # 快速 UDP 通道（192.168.1.x 网段）
│   │   ├── myudpthread.h    # UDP 线程
│   │   ├── myqueue.h/cpp    # 线程安全环形缓冲队列
│   │   ├── myhttpfileclient.h # HTTP 文件传输
│   │   └── mosquitto.h      # MQTT 协议头
│   ├── mainwindow/       # 主窗口框架
│   │   ├── zksort.h/cpp  # ZKSort 主窗口类
│   │   ├── middlewidgetmanager.h/cpp # 中间区域页面管理器
│   │   ├── topwidget.h   # 顶部状态栏
│   │   └── bottomwidget.h # 底部按钮栏
│   ├── mainpage/         # 主功能页面
│   │   ├── userwidget.cpp       # 用户操作界面
│   │   ├── engineerwidget.cpp   # 工程设置入口
│   │   ├── sensesetwidget.cpp   # 灵敏度设置
│   │   ├── feedsetwidget.cpp    # 供料设置
│   │   ├── modemanagewidget.cpp # 方案管理
│   │   ├── newmainpage.h        # 新版主页面
│   │   └── simulatewidget.cpp   # 仿真调试
│   ├── mysortwidget/     # 自定义控件库（40+ 文件）
│   │   ├── basewidget.h/cpp     # 基类控件
│   │   ├── hsvcolorcircle.h/cpp # HSV 色环选择器
│   │   ├── myinputdialog.cpp    # 自定义输入弹窗
│   │   ├── myinputmethod.cpp    # 软键盘输入法
│   │   ├── mymessagebox.cpp     # 自定义消息框
│   │   ├── mytoolbutton.cpp     # 自定义按钮
│   │   ├── mywavewidget.cpp     # 波形显示控件
│   │   ├── mylistwidget.cpp     # 自定义列表
│   │   └── switchbtn.cpp        # 滑动开关
│   ├── engineerset/      # 工程设置
│   │   ├── imagecapturewidget.cpp  # 图像采集
│   │   ├── svmimagewidget.cpp      # SVM 采样和训练
│   │   ├── identifywidget.cpp      # 物料识别界面
│   │   ├── backgroundsetwidget.cpp # 背景设置
│   │   ├── lightsetwidget.cpp      # 灯光设置
│   │   └── ejectwidget.h           # 喷阀控制
│   ├── factoryset/       # 工厂/调试设置
│   │   ├── fpga.h/cpp       # FPGA 传统算法参数配置
│   │   ├── fpga2.h/cpp      # FPGA 算法扩展
│   │   ├── camerasetwidget.cpp   # 相机配置
│   │   ├── ipcsetwidget.cpp      # IPC 工控机设置
│   │   ├── ipccamerasetwidget.cpp # IPC 相机配置
│   │   ├── ipcaisetwidget.cpp    # AI 参数设置
│   │   ├── pixeladjust.cpp       # 分像素调整
│   │   ├── machinesetwidget.cpp  # 机型设置
│   │   └── languagesetwidget.cpp # 语言切换
│   ├── systeminfo/       # 系统信息和调试
│   │   ├── sysinfowidget.cpp     # 系统信息主页
│   │   ├── ipcinfowidget.cpp     # IPC 信息和控制
│   │   ├── ipcstatewidget.h      # IPC 状态监控
│   │   ├── ipctestnetwidget.cpp  # IPC 网络测试
│   │   ├── machineinfowidget.cpp # 机器信息
│   │   ├── wificonfigwidget.cpp  # WiFi 配置
│   │   └── barchart.cpp          # 数据柱状图
│   ├── arithprofilewidget/ # 算法方案参数控件（20+ 算法类型）
│   │   ├── svmsensesetwidget.cpp  # SVM 算法灵敏度
│   │   ├── hsvsensesetwidget.cpp  # HSV 色选灵敏度
│   │   ├── graysensesetwidget.cpp # 灰度灵敏度
│   │   ├── bigsmallsensesetwidget.cpp  # 大小识别
│   │   └── wheatsproutsensesetwidget.cpp # 麦芽识别
│   ├── autocontrol/      # 自动控制
│   │   └── plcautoctrlmanager.cpp # PLC 自动控制管理
│   ├── scheme/           # 方案管理
│   │   └── algorithmselectwidget.cpp # 算法选择
│   ├── plastic/          # 塑料分选
│   │   └── iroffsetwidget.cpp   # 红外偏移
│   └── data/             # 数据持久化
│       ├── jsondataconvert.h/cpp # JSON ↔ C 结构体双向映射
│       ├── myjson.h/cpp   # jsoncpp 封装（读写配置/方案文件）
│       └── mysqlite.h/cpp # SQLite 统计数据（产量、合格率、运行时长）
├── 3rdparty/
│   ├── log4qt/           # 日志框架（Log4j 风格）
│   ├── qextserialport/   # Qt 串口库封装
│   ├── qwt/              # 2D 图表库
│   ├── jsoncpp/          # C++ JSON 解析库
│   ├── svm/              # SVM 分类算法库（svmtool.h: train/isBad/shape_sampling/shape_classify）
│   ├── qrencode/         # 二维码生成
│   ├── mqtt/             # MQTT 协议库（mosquitto）
│   ├── encrypt/          # 时间加密
│   └── fToFp/            # 浮点转换
└── uikits/               # 通用 UI 组件库（进度条、Toast、动画标签）
```

## 核心数据流
```
相机/FPGA 硬件 → 串口(COM1/COM2) → mySerial(MyQextSerialPort/ZkSerialPort)
                                     → mySerialSend/RecvThread（收发线程）
                                     → globalflow.cpp（协议解析）
                                     → 界面更新（信号/槽）

IPC 工控机(AI)  → UDP(192.168.1.x:20001) → myNetWork
                                          → AI 检测结果
                                          → 与 FPGA 结果并行判断

配置持久化 → data/myjson.cpp（JSON 读/写 .cnf 文件）
统计记录   → data/mysqlite.cpp（SQLite INSERT/QUERY）
```

## 串口协议
- 自定义二进制帧，CMD 命令字定义在 `global/constant.h`（70+ 个 CMD_ 宏）
- 命令组装：`mySerial.pushCom2CmdData(nCmd, intAddr, boardType, boardAddr, data, nCount)` → 经消息队列 → 串口线程发送
- 回包解析：`mySerialRecvThread::recvDataAnalysis()` → 分 64 字节常规包和 1024 字节统计包

## 两种算法引擎（并行互补）
1. **FPGA 传统算法**：硬件直通，极低延迟，处理灰度/HSV/形状/大小
2. **IPC AI 深度学习**：工控机 GPU 推理，SVM 分类 + 神经网络，处理复杂特征（麦芽、霉变等）

## 多线程架构（7-9 个常驻线程）
- 4 串口线程（COM1 收发 + COM2 收发）
- 1 状态轮询线程（时钟/清灰/报警）
- 1-2 网络线程（UDP 波形、快速抓图）
- 1-2 MQTT 线程（仅 Linux，与云端通信）