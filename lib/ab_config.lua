
local _M = {}

_M.man_token = "THE-TOKEN"

_M.redis = {
  host="127.0.0.1",
  port=6379,
  password=123456,
  timeout=5*1000,
  db_index=0,
}

_M.reload_interval = 60 -- second

_M.servers = {
  default="127.0.0.1:2020", --默认地址, 所有未命中其它server的请求, 都将代理到该地址上.
  test="127.0.0.1:2022",  -- server 'test' 将代理到该地址上.
}

return _M
