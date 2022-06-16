local M = {}

M.id = function(x) return x end

M.on = function(f2, f)
  return function(x,y) f2(f(x), f(y)) end
end

M.compose = function(f, g)
  return function(x)
    return f(g(x))
  end
end

return M
