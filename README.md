Name
====

a simple ab testing gateway. 
default deliver by request header `X-Platform` + `X-Version`

# Usage

* the code deploy to directory: `/opt`

* change lua config: `simple-ab-testing-gateway/lib/ab_config.lua`

```lua

local _M = {}

-- the token for manager operate.
_M.man_token = "THE-TOKEN"

-- interval(second) for reload config from redis
_M.reload_interval = 60

-- config key in redis
_M.redis_key = "ab-config:default"

-- the redis config
_M.redis = {
  host="127.0.0.1",
  port=6379,
  password=123456,
  timeout=5*1000,
  db_index=0,
}

-- the server config map
_M.servers = {
  default="127.0.0.1:1000", --default server
  test="127.0.0.1:2000",  -- server 'test'
}

return _M
```

* nginx config

```nginx
http {
   lua_package_path "/opt/simple-ab-testing-gateway/lib/?.lua;;";
}
```


# Testing

## init the token and host
```
TOKEN="THE-TOKEN"     # set to ab_config.man_token
HOST="127.0.0.1:12340"
```

## add ab testing config
```
curl -H"X-Token: $TOKEN" "http://$HOST/ab/add" -d '{"key": "ios-1.0.1", "server": "test"}'
curl -H"X-Token: $TOKEN" "http://$HOST/ab/add" -d '{"key": "ios-1.0.2", "server": "test"}'
```

* in this example `key` is `ios-1.0.2` means the request that platform(header `x-platform`) is `ios`, version(header `x-version`) is `1.0.2`, use the server `test`
* the server `test` is config in ab_config.servers.

## list the ab testing config
```
curl -H"X-Token: $TOKEN" "http://$HOST/ab/list"
```

## delete the ab testing config
```
curl -H"X-Token: $TOKEN" "http://$HOST/ab/del" -d '{"key": "ios-1.0.100"}'
```


## testing request

```bash
curl -H"X-Platform: ios" -H"X-Version:1.0.0" "http://$HOST/v1/ping"
> default server

curl -H"X-Platform: ios" -H"X-Version:1.0.1" "http://$HOST/v1/ping"
> test server

curl -H"X-Platform: ios" -H"X-Version:1.0.2" "http://$HOST/v1/ping"
> test server
```



# Licence

This module is licensed under the 2-clause BSD license.

Copyright (c) 2019, jie123108 <jie123108@163.com>

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR AN
Y DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUD
ING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

