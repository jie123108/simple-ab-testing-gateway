local config = require("ab_config")
local redis = require("redis_iresty")
local redis_config = config.redis
local cjson = require("cjson")

local function check_token() 
  local headers = ngx.req.get_headers()
  local token = headers["X-Token"]
  if token ~= config.man_token then 
    ngx.status = 401
    ngx.say("没有权限!")
  end
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

local function get_post_object() 
  ngx.req.read_body()
  local jso = cjson.decode(ngx.req.get_body_data())
  return jso
end

local function new_redis() 
  local red = redis:new(redis_config)
  if redis_config.password then 
    local res, err = red:auth(redis_config.password)
    if not res then
      ngx.log(ngx.ERR, "redis.auth(%s) failed! ", redis_config.password)
        return
    end
  end
  return red
end

-- 列出所有测试版本信息.
local function ab_list() 
  if package.loaded.ab_version then
    for key, value in pairs(package.loaded.ab_version) do 
      ngx.say(key, ":", value)
    end
  else
    ngx.say("empty")
  end
end

-- 添加测试版本
local function ab_add()
  local body = get_post_object()
  local red = new_redis()
  if body.key and body.server then 
    red:hset("ab-config", body.key, body.server)
    ngx.say("set ", body.key, " = ", body.server)
    ngx.say("生效时间: ", config.reload_interval, " 秒")
  else
    ngx.say("missing field: key or server")
  end
end
-- 删除测试版本
local function ab_del() 
  local body = get_post_object()
  local red = new_redis()
  if body.key then 
    red:hdel("ab-config", body.key)
    ngx.say("del ", body.key, " success")
    ngx.say("生效时间: ", config.reload_interval, " 秒")
  else
    ngx.say("missing field: key")
  end
end

-- check token.

check_token()

if ngx.var.uri == "/ab/list" then 
  ab_list()
elseif ngx.var.uri == "/ab/add" then 
  ab_add()
elseif ngx.var.uri == "/ab/del" then 
  ab_del()
else
  ngx.exit(404)
end