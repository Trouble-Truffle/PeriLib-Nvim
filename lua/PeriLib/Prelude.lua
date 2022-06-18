local M = {}
local types = require("PeriLib.Type")
local Type  = require("PeriLib.Type")
local Function = require("PeriLib.Data.Function")

M.switch = function(param, cases)
  local case = cases[param]
  if case == nil then
    return cases.default
  else
    return case
  end
end

M.eqInstances = types.class("Eq")
M.equal = function(a)
  return function(b)
    if type(a) ~= type(b) then
      return false
    end
    if type(a) == "table" then
      if #a ~= #b then return false end
      if a.type and a.type == b.type then
        return M.switch(a.type, M.eqInstances)(a, b)
      else
        for k, v in pairs(a) do
          if not M.equal(v)(b[k]) then return false end
        end
        return true
      end
    end
    return a == b
  end
end
M.uncEqual = function(a,b) return M.equal(a)(b) end

M.showInstances = types.class("Show")
M.show = function(x)
  if type(x) == "table" and x.type then
    return M.switch(x.type, M.showInstances)(x)
  end
  return vim.inspect(x)
end

for k,v in pairs(Type.data("Ord", {EQ = 0, LT = 0, GT = 0}))
  do M[k] = v
end

M.index = function(keys)
  return function(x)
    local out = x
    for _,v in pairs(keys) do
      out = out[v]
    end
    return out
  end
end

M.ordInstances = types.class("Ordered")
M.compare = function(x,y)
  if type(x) == "number" then
    if x == y then return M.EQ
    elseif x > y then return M.GT
    else return M.LT
    end
  elseif type(x) == "boolean" then
      if x and y then return M.EQ
      elseif x and (not y) then return M.GT
      else return M.LT
      end
  elseif type(x) == "table" then
    if x.type then
      return M.switch(x.type, M.ordInstances)(x,y)
    else
      if (#x == 0) and  (#y == 0) then
        return M.EQ
      elseif (#x > 0) and (#y == 0) then
        return M.GT
      elseif (#x == 0) and (#y > 0) then
        return M.LT
      else
        return M.compare(x[1], y[1])
      end
    end
  else
    error("No 'Ordered' instance found for type: '" .. type(x) .. "'")
  end
end

M.eqInstances["Ord"] = function(a,b)
  return Function.on(M.equal, M.index({"type", "type"}))(a,b)
end

M.max = function(a, b)
  return M.switch(M.compare(a,b).value.type,
    {EQ = a, GT = a, LT = b})
end

M.min = function(a, b)
  return M.switch(M.compare(a,b).value.type,
    {EQ = b, GT = b, LT = a})
end

return M
