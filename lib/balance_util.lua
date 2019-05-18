local config = require("ab_config")
local redis = require("redis_iresty")
local redis_config = config.redis
local cjson = require("cjson")

local _M = {}

_M.get_server = function() 
  local headers = ngx.req.get_headers()
  local ab_version = package.loaded.ab_version or {}
  local platform = headers["X-Platform"] or "unknow"
  local version = headers["X-Version"] or "unknow"
  local test_key = platform .. "-" .. version
  local server_key = ab_version[test_key]

  local server = config.servers[server_key] or config.servers["default"]
  return server
end

local function redisList2map(result) 
  local map = {}
  for i=1,table.getn(result),2 do 
    local key = result[i]
    local value = result[i+1]
    map[key] = value
  end
  return map
end

local function load_test_version() 
  local red = redis:new(redis_config)
  local result = red:hgetall(config.redis_key)
  local ab_version = {}
  if result and type(result) == "table" then 
    ab_version = redisList2map(result)
  end
  package.loaded.ab_version = ab_version
  ngx.log(ngx.WARN, "load ab config from redis: ", cjson.encode(ab_version))
end

_M.ab_testing_init_worker = function()
  local delay = config.reload_interval
  local handler
  handler = function (premature)
    load_test_version()
    if premature then
        return
    end
    local ok, err = ngx.timer.at(delay, handler)
    if not ok then
        ngx.log(ngx.ERR, "failed to create the timer: ", err)
        return
    end
  end

  local ok, err = ngx.timer.at(0, handler)
  if not ok then
      ngx.log(ngx.ERR, "failed to create the timer: ", err)
      return
  end
end

return _M
