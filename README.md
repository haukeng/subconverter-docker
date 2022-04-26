# subconverter-docker

## 简介

subconverter-docker 是基于 [tindy2013/subconverter][1] 项目的自定义 Docker 镜像，相关使用方法请参考[原项目文档][2]。相比于原项目，本项目原主要修改了以下的内容：

- 默认启用 API 模式，需要设置环境变量 `SUB_PASSWORD`
- 可通过环境变量 `LISTEN` 和 `PORT` 调整服务监听地址端口
- 系统调整
    - 将镜像的默认时区设置为 `Asia/Shanghai`
- 节点规则调整
    - 默认显示 emoji
    - 默认将 `tfo`, `udp`, `scv`, `tls13` 设置为 `false`
    - 显示正常的台湾 emoji
    - 添加了更多地区的 emoji
- 分组规则调整
    - 调整分组名称
    - 增加`学术`分组
    - 增加 `PayPal` 分组
    - `自动选择`间隔设定为 1800 秒
    - `Microsoft` 默认选项改为`代理`
    - 删除`默认拦截`分组中包含的广告域名规则
    - `中国流媒体`分组现只包含在中国以外有运营的流媒体


## 部署

### docker 部署

```bash
docker run -d \
-e SUB_PASSWORD=your_password \
--name=subconverter \
--restart=always \
-p 25500:25500 \
thehaukeng/subconverter
```

### docker-compose 部署

```bash
mkdir -p subconverter && cd subconverter
wget https://raw.githubusercontent.com/haukeng/subconverter-docker/main/docker-compose.yml -O docker-compose.yml

# 修改环境变量 SUB_PASSWORD
docker-compose up -d
``` 

> This is a shameless copy from [stilleshan/subconverter](https://github.com/stilleshan/subconverter)

[1]: https://github.com/tindy2013/subconverter
[2]: https://github.com/tindy2013/subconverter/blob/master/README-cn.md