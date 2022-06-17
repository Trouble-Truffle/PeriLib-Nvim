local Prelude = require("PeriLib.Prelude")
local M = {}

M.printLn = function(x)
  print(Prelude.show(x))
end

return M
