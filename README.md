

# 测试命令

## 初始化token
```
TOKEN="THE-TOKEN"
HOST="127.0.0.1:12340"
```

## 查看ab配置列表
```
curl -v -H"X-Token: $TOKEN" "http://$HOST/ab/list"
```

## 添加ab配置. 
```
curl -v -H"X-Token: $TOKEN" "http://$HOST/ab/add" -d '{"key": "ios-1.0.1", "server": "test"}'
```

* 本例中, 表示, 平台(x-platform)为ios, 版本(x-version)为1.0.2的请求, 使用server 'test', 
* test实际的地址在ab_config.servers中指定.

## 删除ab配置
```
curl -v -H"X-Token: $TOKEN" "http://$HOST/ab/del" -d '{"key": "ios-1.0.2"}'
```


# 测试应用

```
curl -v -H"X-Platform: ios" -H"X-Version:1.0.1" "http://$HOST/v1/ping"
```
