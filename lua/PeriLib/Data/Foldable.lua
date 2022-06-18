local Type = require "PeriLib.Type"
local Prelude = require "PeriLib.Prelude"
local M = {}

local reverse = function(xs)
  local out = {}
  for i = #xs, 1, -1 do
    out[#out + 1] = xs[i]
  end
  return out
end

local tail = function(xs)
  if #xs == 0 then
    return {}
  end
  local out = {}
  for i = 2, #xs do
    out[i - 1] = xs[i]
  end
  return out
end

M.Foldable = Type.class("Foldable", { "foldl" })
M.foldl = function(f, z, xs)
  return Prelude.match(Type.typeOf(xs), M.Foldable.foldl.instance)(f, z, xs)
end

M.Foldable.foldl.instance["table"] = function(f, z, xs)
  local out = z
  for _, v in ipairs(xs) do
    out = f(out, v)
  end
  return out
end

M.foldl1 = function(f, xs)
  if #xs <= 0 then
    error "Empty Datatype Provided"
  end
  return M.foldl(f, xs[1], tail(xs))
end

M.foldr = function(f, z, xs)
  return M.foldl(f, z, reverse(xs))
end
M.foldr1 = function(f, xs)
  return M.foldl1(f, reverse(xs))
end

M.scanl = function(f, z, xs)
  local out = { z }
  local lastVal = z
  for _, v in ipairs(xs) do
    lastVal = f(lastVal, v)
    table.insert(out, lastVal)
  end
  return out
end

M.scanl1 = function(f, xs)
  if #xs <= 0 then
    error "Empty Datatype Provided"
  end
  return M.scanl(f, xs[1], tail(xs))
end
M.scanr = function(f, z, xs)
  return M.scanl(f, z, reverse(xs))
end
M.scanr1 = function(f, xs)
  return M.scanl1(f, reverse(xs))
end

return M
