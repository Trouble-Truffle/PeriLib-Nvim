-- Optional Values
local M = {}

local Types = require("PeriLib.Type")
local Func = require("PeriLib.Data.Function")
local Prelude = require("PeriLib.Prelude")

for k,v in pairs(Types.data("Maybe",
                 {Just = Func.id,
                  Nothing = 0}))
do
  M[k] = v
end

M.isJust = function(x)
  return x.value.type == "Just"
end

M.isNothing = function(x)
  return x.value.type == "Nothing"
end

M.maybe = function(x, f, mX)
  if M.isJust(mX) then
    return f(mX.value.value)
  else
    return x
  end
end

M.fromMaybe = function(x, mX)
  return M.maybe(x, Func.id, mX)
end

M.listToMaybe = function(xs)
  if #xs == 0 then
    return M.Nothing
  else
    return M.Just(xs[1])
  end
end

Prelude.eqInstances["Maybe"] = function(x, y)
  if M.isJust(x) and M.isJust(y) then
    return Prelude.equal(x.value.value, y.value.value)
  elseif M.isNothing(x) and M.isNothing(y) then
    return true
  else
    return false
  end
end

return M
