# subconverter-docker
## 简介
subconverter-docker 是基于 [tindy2013/subconverter][1] 项目的自定义 Docker 镜像，相关使用方法请参考[原项目文档][2]。相比于原项目，本项目原主要修改了以下的内容：

- **分组规则调整**
    - 将`自动选择`间隔设定为 1800 秒
    - 调整了原项目大部分的分组名字
    - 增加了`HBO` 和 `Disney+` 分组
    - 增加了 `PayPal` 分组
    - 增加了`学术`分组
    - 修改了 `Microsoft` 分组的默认选项为代理
    - 删除了`默认拦截`分组中 `NobyDa/Surge/AdRule.list` 包含的规则
    - `中国流媒体`分组只包含在中国以外有运营的中国流媒体，其余转移到`默认直连`分组中
- **系统调整**
    - 将镜像的默认时区设置为 `Asia/Shanghai`
- **节点规则调整**
    - 默认显示 emoji
    - 默认将 `tfo`, `udp`, `scv`, `tls13` 设置为 `false`
    - 显示正常的台湾 emoji
    - 添加了更多地区的 emoji

## 部署
### docker 部署
```shell
docker run -d --name=subconverter --restart=always -p 25500:25500 ghcr.io/haukeng/subconverter
```

### docker-compose 部署
```shell
mkdir -p subconverter && cd subconverter
wget https://git.io/JXES5 -O docker-compose.yml
docker-compose up -d
``` 

### Nginx反向代理（推荐）
配置 Nginx 反向代理方便访问，配置参考如下，请自行替换`域名`和`证书`信息.

```nginx
server {
    listen              443 ssl http2;
    listen              [::]:443 ssl http2;
    server_name         example.com; #改成你自己的域名

    # SSL
    ssl_certificate     /path/to/example.com.cert.pem; # 改成你的 SSL 证书 
    ssl_certificate_key /path/to/example.com.key.pem; # 改成你的 SSL 证书密钥

    # security headers
    add_header X-XSS-Protection          "1; mode=block" always;
    add_header X-Content-Type-Options    "nosniff" always;
    add_header Referrer-Policy           "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy   "default-src 'self' http: https: data: blob: 'unsafe-inline'; frame-ancestors 'self';" always;
    add_header Permissions-Policy        "interest-cohort=()" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

    # restrict methods
    if ($request_method !~ ^(GET|DELETE|HEAD|CONNECT|OPTIONS|TRACE)$) {
        return '405';
    }

    # reverse proxy
    location / {
        proxy_pass http://127.0.0.1:25500; #改成你绑定的端口

        iproxy_http_version                 1.1;
        proxy_cache_bypass                 $http_upgrade;

        # Proxy headers
        proxy_set_header Upgrade           $http_upgrade;
        proxy_set_header Connection        $connection_upgrade;
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header Forwarded         $proxy_add_forwarded;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host  $host;
        proxy_set_header X-Forwarded-Port  $server_port;

        # Proxy timeouts
        proxy_connect_timeout              60s;
        proxy_send_timeout                 60s;
        proxy_read_timeout                 60s;
    }
}

# HTTP redirect
server {
    listen      80;
    listen      [::]:80;
    server_name example.com; #改成你自己的域名
    return      301 https://example.com$request_uri; #改成你自己的域名
}
```

> This is a shameless copy from [stilleshan/subconverter](https://github.com/stilleshan/subconverter)

[1]: https://github.com/tindy2013/subconverter
[2]: https://github.com/tindy2013/subconverter/blob/master/README-cn.md