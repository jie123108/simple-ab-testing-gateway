
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
