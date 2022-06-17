local M = {}
M.id = function(x) return x end

M.const = function(x) return function(_) return x end end

M.uncurry = function(f)
  return function(x, y)
    return f(x)(y)
  end
end

M.on = function(f2, f)
  return function(a, b)
    return f2(f(a), f(b))
  end
end
M.onUncurried = function(f2, f)
  return function(x,y)
    return M.on(M.uncurry(f2), f)(x,y)
  end
end

M.compose = function(f, g)
  return function(x)
    return f(g(x))
  end
end

return M
