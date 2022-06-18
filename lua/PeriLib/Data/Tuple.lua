local M = {}

M.fst = function(xs)
  return xs[1]
end

M.snd = function(xs)
  return xs[2]
end

M.swap = function(xs)
  return {xs[2], xs[1]}
end

M.structure = function(a,b)
  return {a,b}
end

M.destructure = function(xs)
  return xs[1], xs[2]
end

return M
