local Type = require("PeriLib.Type")
local Monoid = require("PeriLib.Data.Monoid")
local Prelude= require("PeriLib.Prelude")

local M = {}

M.monadInstances = Type.class("Monad")
M.bind = function(ma, f)
  if type(ma) == "table" then
    if ma.type then
      return Prelude.switch(ma.type, M.monadInstances)(ma, f)
    else
      local result = {}
      for _, value in pairs(ma) do
        result = Monoid.mappend(result, f(value))
      end
      return result
    end
  elseif type(ma) == "function" then
    return function (x)
      return f(ma(x), x)
    end
  else
    error("No 'Functor' instance found for type '"..type(ma).."'")
  end
end

return M
