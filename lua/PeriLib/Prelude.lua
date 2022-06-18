local M = {}
local Type = require "PeriLib.Type"
local Function = require "PeriLib.Data.Function"

M.match = function(param, cases)
  local case = cases[param]
  if case == nil then
    return cases.default
  else
    return case
  end
end

M.Eq = Type.class("EQ", { "equal" })
M.equal = function(a)
  return function(b)
    if Type.typeOf(a) ~= Type.typeOf(b) then
      return false
    end
    return M.match(Type.typeOf(a), M.Eq.equal.instance)(a,b)
  end
end
M.uncEqual = function(a, b)
  return M.equal(a)(b)
end

M.Eq.equal.instance["table"] = function(a, b)
  if #a ~= #b then return false end
  for k, v in pairs(a) do
    if not M.equal(v)(b[k]) then
      return false
    end
  end
  return true
end
M.Eq.equal.instance["default"] = function(x,y) return x == y end

M.Show = Type.class("Show", { "show" })
M.show = function(x)
  return M.match(Type.typeOf(x), M.Show.show.instance)(x)
end

M.Show.show.instance["default"] = vim.inspect

M.index = function(keys)
  return function(x)
    local out = x
    for _, v in pairs(keys) do
      out = out[v]
    end
    return out
  end
end

for k, v in pairs(Type.data("Ord", { EQ = 0, LT = 0, GT = 0 })) do
  M[k] = v
end
M.Show.show.instance["Ord"] = function(x)
  return x.value.type
end

M.Ord = Type.class("Ordered", { "compare" })
M.Eq.equal.instance["Ord"] = function(x,y)
  return Function.on(M.equal, M.index({ "type", "type" }))(x, y)
end
M.compare = function(x, y)
  return M.match(Type.typeOf(x), M.Ord.compare.instance)(x,y)
end

M.Ord.compare.instance["number"] = function(x, y)
  if x == y then
    return M.EQ
  end
  if x > y then
    return M.GT
  end
  if x < y then
    return M.LT
  end
end
M.Ord.compare.instance["boolean"] = function(x, y)
  if x and y then
    return M.EQ
  elseif x and not y then
    return M.GT
  else
    return M.LT
  end
end
M.Ord.compare.instance["table"] = function(x, y)
  if (#x == 0) and (#y == 0) then
    return M.EQ
  elseif (#x > 0) and (#y == 0) then
    return M.GT
  elseif (#x == 0) and (#y > 0) then
    return M.LT
  else
    return M.compare(x[1], y[1])
  end
end

M.max = function(a, b)
  return M.match(M.compare(a, b).value.type, { EQ = a, GT = a, LT = b })
end

M.min = function(a, b)
  return M.match(M.compare(a, b).value.type, { EQ = b, GT = b, LT = a })
end

return M
