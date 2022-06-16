local M = {}

local Types = require("PeriLib.Type")
local Prelude = require("PeriLib.Prelude")
local Func = require("PeriLib.Data.Function")

M.functorInstances = Types.class("Functor")

M.fmap = function(f, x)
  if type(x) == "table" then
    if x.type then
      return Prelude.switch(x.type, M.functorInstances)
    else
      local r = {}
      for k,v in pairs(x) do
        if type(v) == "table" or type(v) == "function" then
          r[k] = M.fmap(f, v)
        else
          r[k] = f(v)
        end
      end
      return r
    end
  elseif type(x) == "function" then
    return Func.compose(f,x)
  else
    error("No 'Functor' instance found for type '"..type(x).."'")
  end
end

return M
