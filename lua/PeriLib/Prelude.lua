local M = {}

local types = require("PeriLib.Type")

M.switch = function(param, cases)
  local case = cases[param]
  if case == nil then
    return cases.default
  else
    return case
  end
end

M.const = function(x, _)
  return x
end

M.eqInstances = types.class("Eq")
M.equal = function(a, b)
  if type(a) ~= type(b) then
    return false
  end
  if type(a) == "table" then
    if #a ~= #b then return false end
    if a.type and a.type == b.type then
      return M.switch(a.type, M.eqInstances)(a,b)
    else
      for k, v in pairs(a) do
        if not M.equal(v, b[k]) then return false end
      end
      return true
    end
  end
  return a == b
end

M.showInstances = types.class("Show")
M.show = function(x)
  if type(x) == "table" and x.type then
    return M.switch(x.type, M.showInstances)(x)
  end
  return vim.inspect(x)
end
return M


