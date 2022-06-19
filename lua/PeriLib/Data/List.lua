local Types = require "PeriLib.Type"
local Func = require "PeriLib.Data.Function"
local Foldable = require "PeriLib.Data.Foldable"
local Operator = require "PeriLib.Operator"
local Prelude = require "PeriLib.Prelude"
local Tuple = require "PeriLib.Data.Tuple"

local Maybe = {}
for k, v in pairs(Types.data("Maybe", { Just = Func.id, Nothing = 0 })) do
  Maybe[k] = v
end

local fromMaybe = function(mX)
  return mX.value.value
end

local M = {}

M.map = require("PeriLib.Data.Functor").fmap

M.append = function(x, xs)
  local out = { x }
  for i = 2, #xs + 1 do
    out[i] = xs[i - 1]
  end
  return out
end

M.reverse = function(xs)
  local out = {}
  for i = #xs, 1, -1 do
    out[#out + 1] = xs[i]
  end
  return out
end

M.head = function(xs)
  if #xs <= 0 then
    return Maybe.Nothing
  else
    return Maybe.Just(xs[1])
  end
end

M.last = function(xs)
  if #xs <= 0 then
    return Maybe.Nothing
  else
    return Maybe.Just(xs[#xs])
  end
end

M.tail = function(xs)
  local out = {}
  if #xs <= 0 then
    return Maybe.Nothing
  else
    for i = 2, #xs do
      out[i - 1] = xs[i]
    end
    return Maybe.Just(out)
  end
end

M.init = function(xs)
  local out = {}
  if #xs <= 0 then
    return Maybe.Nothing
  else
    for i = 1, #xs - 1 do
      out[i] = xs[i]
    end
    return Maybe.Just(out)
  end
end

M.filter = function(f, xs)
  local out = {}
  for _, v in ipairs(xs) do
    if f(v) then
      table.insert(out, v)
    end
  end
  return out
end

M.null = function(xs)
  return #xs == 0
end

M.take = function(xs, n)
  local out = {}
  for i = 1, n do
    out[i] = xs[i]
  end
  return out
end

M.drop = function(xs, n)
  local out = {}
  for i = n + 1, #xs do
    out[i - n] = xs[i]
  end
  return out
end

M.takeWhile = function(xs, f)
  local out = {}
  for i = 1, #xs do
    if f(xs[i]) then
      out[#out + 1] = xs[i]
    else
      break
    end
  end
  return out
end

M.dropWhile = function(xs, f)
  local out = {}
  for i = 1, #xs do
    if not f(xs[i]) then
      out[#out + 1] = xs[i]
    end
  end
  return out
end

M.span = function(xs, f)
  local l = {}
  for _, v in ipairs(xs) do
    if f(v) then
      table.insert(l, v)
    else
      break
    end
  end
  return { l, M.drop(xs, #l) }
end

M.slice = function(xs, i, j)
  local out = {}
  if type(i) == "table" then
    for _, v in ipairs(i) do
      table.insert(out, v)
    end
  else
    for k = i, j do
      table.insert(out, xs[k])
    end
  end
  return out
end

M.iota = function(i, j)
  local out = {}
  if j == nil then
    for n = 1, i do
      out[n] = n
    end
  else
    for n = i, j do
      out[n - i + 1] = n
    end
  end
  return out
end

M.elem = function(xs, x)
  for _, v in ipairs(xs) do
    if v == x then
      return true
    end
  end
  return false
end

M.zipWith = function(xs, ys, f)
  local result = {}
  for i, x in ipairs(xs) do
    if ys[i] == nil or x == nil then
      break
    end
    result[i] = f(x, ys[i])
  end
  return result
end

M.zip = function(xs, ys)
  return M.zipWith(xs, ys, function(x, y)
    return { x, y }
  end)
end

M.sum = function(xs)
  return Foldable.foldl(Operator.add, 0, xs)
end
M.difference = function(xs)
  return Foldable.foldr(Operator.sub, 0, xs)
end
M.product = function(xs)
  return Foldable.foldl(Operator.mul, 1, xs)
end
M.quotient = function(xs)
  return Foldable.foldr(Operator.div, 1, xs)
end
M.maximum = function(xs)
  return Foldable.foldl1(Prelude.max, xs)
end
M.minimum = function(xs)
  return Foldable.foldl1(Prelude.min, xs)
end
M.listOr = function(xs)
  for _, v in ipairs(xs) do
    if v then
      return true
    end
  end
  return false
end

M.listAnd = function(xs)
  for _, v in ipairs(xs) do
    if not v then
      return false
    end
  end
  return true
end

M.any = function(f, xs)
  for _, v in pairs(xs) do
    if f(v) then
      return true
    end
  end
  return false
end

M.all = function(f, xs)
  for _, v in pairs(xs) do
    if not f(v) then
      return false
    end
  end
  return true
end

M.groupBy = function(f, xss)
  if M.null(xss) then return {} end
  local x, xs = xss[1], fromMaybe(M.tail(xss))
  local ys,zs = Tuple.destructure(M.span(xs, f(x)))

  return M.append(M.append(x,ys), M.groupBy(f, zs))


end

M.group = function(xs)
  return M.groupBy(Prelude.equal, xs)
end

return M
