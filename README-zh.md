# runX

runX 是我自己用的一个小工具，日常工作涉及跨语言项目的开发，可能随时需要在各种语言间切换，
之前的做法是直接在一个虚拟机里面配置开发环境，久而久之奇慢无比都不说，时间长了里面真是一团乱麻。
后来我尝试过 Vargrant, Docker 等方案，还是觉得不尽如人意，Vargrant 对我钟爱的 Parallels
支持不是很好，而 Mac 上的 Docker 也是一个虚拟机方案，做起性能调优来总觉得隔靴搔痒的不爽。
所以，最终还是转向了 VM 上来。尤其是我发现 Parallels 同时还提供了强大的命令行管理工具 `prlctl`
后，更坚定了我的这个想法。

## intro

*几个前提条件：*

* 首先保证 pvm 能与宿主机共享目录（比如代码目录，比如 runX 项目目录）
* 用来部署开发环境的源 pvm 需要将共享的 runX 项目添加到 PATH 环境变量下，保证我的 set_up 脚本
  能在新建的 pvm 上面执行类似 `prlctl exec golang 'sudo -Hiu z set_up'` 这样的命令
* 部署所依赖的源文件放置示例可查看 .gitingore 文件
* 部署后会生成 `/etc/profile.d/idevz_prlctl_${HOSTNAME}.sh` 文件来设置相应的环境变量

### why U need this runX

* 绕过 docker 内核绑定的问题
* 一切基于统一的 base 镜像开始
* 自动化部署开发系统
* 归一化虚拟机中生成的文件（history，conf，logs 等）
* 自动化日常操作（服务停、启，自动化工具）

## how to Use
### using commands


# 读取历史记录
fc -IR
# 保存历史记录
fc -IA