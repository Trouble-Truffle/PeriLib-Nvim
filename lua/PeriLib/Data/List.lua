local M = {}

M.map = function(xs, f)
  local result = {}
  for i,x in ipairs(xs) do
    result[i] = f(x)
  end
  return result
end

M.foldr = function(xs, x, f)
  local result = x
  for _,i in ipairs(xs) do
    result = f(result, i)
  end
  return result
end

M.zipWith = function(xs, ys, f)
  local result = {}
  for i,x in ipairs(xs) do
    result[i] = f(x, ys[i])
  end
  return result
end

M.zip = function(xs, ys)
  return M.zipWith(xs, ys, function(x,y) return {x,y} end)
end


M.equal = function(xs, ys)
  if #xs ~= #ys then return false end
  for i = 1, #xs do
    if xs[i] ~= ys[i] then return false end
  end
  return true
end


M.mempty = {}
M.mappend = function(table1, table2)
  local result = {}
  for _, v in ipairs(table1) do table.insert(result, v) end
  for _, v in ipairs(table2) do table.insert(result, v) end
  return result
end

M.mconcat = function(table)
  local result = {}
  for _, v in ipairs(table) do
    table.insert(result, v)
  end
  return result
end

return M
