local Type = require("PeriLib.Type")
local Prelude = require("PeriLib.Prelude")
local Foldable = require("PeriLib.Data.Foldable")
local M = {}


M.Monoid = Type.class("Monoid", {"mappend"})
M.mempty = {type = "mempty"}

M.mappend = function(a, b)
  if a.type == "mempty" then return b
  elseif b.type == "mempty" then return a
  else return Prelude.match(Type.typeOf(a), M.Monoid.mappend.instance)(a,b)
  end
end

M.Monoid.mappend.instance["table"] = function(a,b)
  local res = {}
  for _,v in ipairs(a) do table.insert(res, v) end
  for _,v in ipairs(b) do table.insert(res, v) end
  return res
end

M.mconcat = function(xs)
  return Foldable.foldl(M.mappend, M.mempty, xs)
end


return M
