local Type = require "PeriLib.Type"
local Monoid = require "PeriLib.Data.Monoid"
local Prelude = require "PeriLib.Prelude"
local Function = require "PeriLib.Data.Function"

local M = {}

M.Monad = Type.class("Monad", { "bind" })
M.bind = function(a, f)
  return Prelude.case(Type.typeOf(a), M.Monad.bind.instance)(a, f)
end

M.Monad.bind.instance["table"] = function(ma, f)
  local result = {}
  for _, value in pairs(ma) do
    result = Monoid.mappend(result, f(value))
  end
  return result
end

M.Monad.bind.instance["function"] = function(ma, f)
  return function(x)
    return f(ma(x), x)
  end
end

M.join = function(x)
  -- Since lua lacks currying, join on functions dont work
  if type(x) == "function" then
    return function(y)
      return x(y, y)
    end
  end
  return M.bind(x, Function.id)
end

return M
