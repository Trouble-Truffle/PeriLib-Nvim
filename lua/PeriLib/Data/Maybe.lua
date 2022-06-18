-- Optional Values
local M = {}

local Types = require("PeriLib.Type")
local Func = require("PeriLib.Data.Function")
local Prelude = require("PeriLib.Prelude")
local Functor = require("PeriLib.Data.Functor")
local Applicative = require("PeriLib.Control.Applicative")
local Monad       = require("PeriLib.Control.Monad")

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

Prelude.Show.show.instance["Maybe"] = function(x)
  if M.isJust(x) then
    return "Just " .. Prelude.show(x.value.value)
  else
    return "Nothing"
  end
end

Prelude.Eq.equal.instance["Maybe"] = function(x, y)
  if M.isJust(x) and M.isJust(y) then
    return Prelude.equal(x.value.value)(y.value.value)
  elseif M.isNothing(x) and M.isNothing(y) then
    return true
  else
    return false
  end
end

Functor.Functor.fmap.instance["Maybe"] = function(f, x)
  if M.isJust(x) then
    return M.Just(f(x.value.value))
  else
    return M.Nothing
  end
end

Applicative.Applicative.liftA2.instance["Maybe"] = function(f,a,b)
  if M.isJust(a) and M.isJust(b) then
    return M.Just(f(a.value.value,b.value.value))
  else
    return M.Nothing
  end
end

Applicative.Alternative.alternative.instance["Maybe"] = function(a,b)
  if M.isNothing(a) and M.isJust(b) then
    return b
  elseif M.isNothing(a) and M.isNothing(b) then
    return M.Nothing
  else
    return a
  end
end

Monad.Monad.bind.instance["Maybe"] = function(a, f)
  if M.isNothing(a) then
    return M.Nothing
  else
    return f(a.value.value)
  end
end

return M
