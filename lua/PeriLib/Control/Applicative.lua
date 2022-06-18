local Prelude = require "PeriLib.Prelude"
local List = require "PeriLib.Data.List"
local Type = require "PeriLib.Type"
local M = {}

M.Applicative = Type.class("Applicative", { "liftA2" })
M.liftA2 = function(f, a, b)
  return Prelude.match(Type.typeOf(a), M.Applicative.liftA2.instance)(f, a, b)
end

M.Applicative.liftA2.instance["table"] = function(f, a, b)
  local result = {}
  for _, iV in pairs(a) do
    for _, jV in pairs(b) do
      table.insert(result, f(iV, jV))
    end
  end
  return result
end
M.Applicative.liftA2.instance["function"] = function(f, a, b)
  return function(x)
    return f(a(x), b(x))
  end
end



M.Alternative = Type.class("Alternative", { "alternative" })
M.alternative = function(a, b)
  return Prelude.match(Type.typeOf(a), M.Alternative.alternative.instance)(a, b)
end

M.Alternative.alternative.instance["table"] = function(a, b)
  if List.null(a) and (not List.null(b)) then
    return b
  else
    return a
  end
end

return M
