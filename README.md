# 一行命令自建zerotier-planet

私有部署zerotier-planet服务，解决访问官方planet速度和延迟问题
基础镜像源码来源于 [ztncui](https://github.com/key-networks/ztncui-aio),这个主要是用来做私有的zerotier controller的
Docker Compose 文件来源于 [Jonnyan404](https://github.com/Jonnyan404/zerotier-planet).


# 主要的修改如下
- 自动识别机器的公网ip地址
- 端口缺省改成 5599， 没有使用官方9993
- 重新编译了 mkmoonworld-x86_64, 原来的版本配合镜像使用会出现 ==FATAL: kernel too old== 的错误 
- 镜像首次运行自动生成plant 和 moon文件,无需手工干预

# 前提条件

- 具有公网ip的服务器
- 安装 docker 及 docker compose
- 防火墙必须开放 TCP端口 5599、4000 和UDP端口 5599。 

# 用法

```
docker-compose up -d
or
docker compose up -d
```
浏览器访问 `http://ip:4000` 打开controller控制台界面。缺省的登录用户名
- 用户名:admin
- 密码: password

# 各客户端配置planet

服务器镜像运行后会在当前目录子目录zerotier-one生成planet文件。
Linux 客户端拷贝到 /var/lib/zerotier-one/
windows 客户端拷贝到 C:\ProgramData\ZeroTier\One\


#  修改端口
修改docker compose中环境变量。 
ZT_ADDR=localhost:5599 ==》 ZT_ADDR=localhost:xxxx
增加环境变量
ZPORT=xxxx
