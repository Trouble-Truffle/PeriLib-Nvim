local M = {}

local Type = require "PeriLib.Type"
local Prelude = require "PeriLib.Prelude"
local Func = require "PeriLib.Data.Function"

M.Functor = Type.class("Functor", { "fmap" })
M.fmap = function(f, x)
  return Prelude.match(Type.typeOf(x), M.Functor.fmap.instance)(f, x)
end
M.Functor.fmap.instance["table"] = function(f, x)
  local r = {}
  for k, v in pairs(x) do
    if type(v) == "table" or type(v) == "function" then
      r[k] = M.fmap(f, v)
    else
      r[k] = f(v)
    end
  end
  return r
end
M.Functor.fmap.instance["function"] = Func.compose

return M
