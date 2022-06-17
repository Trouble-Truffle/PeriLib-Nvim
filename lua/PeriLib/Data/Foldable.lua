local Type = require("PeriLib.Type")
local M = {}

M.foldableInsances = Type.class("Foldable")
M.foldr = function(f, z, xs)
  if type(xs) == "table" then
    if xs.type then
      Type.switch(xs.type, M.foldableInsances)
    else
      local out = z
      for _,v in ipairs(xs) do
        out = f(out, v)
      end
      return out
    end
  end
end

return M
