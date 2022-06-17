local Maybe = require("PeriLib.Data.Maybe")

local M = {}

M.map = require("PeriLib.Data.Functor").fmap

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
    for i=2,#xs do
      out[i-1] = xs[i]
    end
    return Maybe.Just(out)
  end
end

M.init = function(xs)
  local out = {}
  if #xs <= 0 then
    return Maybe.Nothing
  else
    for i=1,#xs-1 do
      out[i] = xs[i]
    end
    return Maybe.Just(out)
  end
end

M.filter = function(f, xs)
  local out = {}
  for _,v in ipairs(xs) do
    if f(v) then
      table.insert(out, v)
    end
  end
  return out
end

M.null = function(xs)
  return #xs == 0
end

M.take = function(xs,n)
  local out = {}
  for i=1, n do
    out[i] = xs[i]
  end
  return out
end

M.drop = function(xs,n)
  local out = {}
  for i=n+1,#xs do
    out[i-n] = xs[i]
  end
  return out
end

M.takeWhile = function(xs,f)
  local out = {}
  for i=1,#xs do
    if f(xs[i]) then
      out[#out+1] = xs[i]
    else
      break
    end
  end
  return out
end

M.dropWhile = function(xs,f)
  local out = {}
  for i=1,#xs do
    if not f(xs[i]) then
      out[#out+1] = xs[i]
    end
  end
  return out
end

M.span = function(xs,f)
  local out = {}
  for _,v in ipairs(xs) do
    if f(v) then
      table.insert(out, v)
    else
      break
    end
  end
  return {out, M.dropWhile(xs,f)}
end

M.slice = function(xs,i,j)
  local out = {}
  if type(i) == "table" then
    for _,v in ipairs(i) do
      table.insert(out, v)
    end
  else
    for k=i,j do
      table.insert(out, xs[k])
    end
  end
  return out
end

M.iota = function(i,j)
  local out = {}
  if j == nil then
    for n = 1,i do
      out[n] = n
    end
  else
    for n = i,j do
      out[n-i+1] = n
    end
  end
  return out
end

M.elem = function(xs,x)
  for _,v in ipairs(xs) do
    if v == x then
      return true
    end
  end
  return false
end

M.zipWith = function(xs, ys, f)
  local result = {}
  for i,x in ipairs(xs) do
    if ys[i] == nil or x == nil then break end
    result[i] = f(x, ys[i])
  end
  return result
end

M.zip = function(xs, ys)
  return M.zipWith(xs, ys, function(x,y) return {x,y} end)
end

return M
