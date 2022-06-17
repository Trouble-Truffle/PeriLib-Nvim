local Types = require("PeriLib.Type")
local Prelude = require("PeriLib.Prelude")
local Foldable = require("PeriLib.Data.Foldable")
local M = {}


M.monoidInstances = Types.class("Monoid")
M.mempty = {type = "mempty"}
M.mappend = function(mA, mB)
  if mA.type == "mempty" then return mB end
  if mB.type == "mempty" then return mA end

  if type(mA) == "table" then
    if mA.type then
      return Prelude.switch(mA.type, M.monoidInstances)
    else
      local res = {}
      for _,v in ipairs(mA) do table.insert(res, v) end
      for _,v in ipairs(mB) do table.insert(res, v) end
      return res
    end
  end
end
M.mconcat = function(xs)
  return Foldable.foldr(M.mappend, M.mempty, xs)
end


return M
