local Types = require("PeriLib.Type")
local Prelude = require("PeriLib.Prelude")
local List    = require("PeriLib.Data.List")
local M = {}

M.applicativeInstances = Types.class("Applicative")
-- No Pure function
M.liftA2 = function(f, a, b)
  if type(a) == "table" then
    if a.type then
      return Prelude.switch(a.type, M.applicativeInstances)(f, a, b)
    else
      local result = {}
      for _, iV in pairs(a) do
        for _, jV in pairs(b) do
          table.insert(result, f(iV,jV))
        end
      end
      return result
    end
  elseif type(a) == "function" then
    return function(x) return f(a(x), b(x)) end
  else
    error("No 'Functor' instance found for type '"..type(a).."'")
  end
end

M.alternativeInstances = Types.class("Alternative")
M.alternative = function(a,b)
  if type(a) == "table" then
    if a.type then
      return Prelude.switch(a.type, M.alternativeInstances)(a,b)
    else
      if List.null(a) and (not List.null(b)) then
        return b
      else
        return a
      end
    end
  end
end

return M
