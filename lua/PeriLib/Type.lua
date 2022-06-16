-- The gods of procedural begged for their survival yet the functional deities
-- refused to accept their beseeching. Here lies the ruin of their former civilization
-- now replaced by a typed functional distopia.

-- Types are tables that store a value and a type field

-- data is used to create new types
-- class is used to create new typeclasses

local M = {}
local func = require("PeriLib.Data.Function")

M.type = function(name, value)
  return {
    type = name,
    value = value
  }
end

-- Creates a new periType datatype
-- 'dataname' is the name of the type
-- 'constructors' is a table of constructors
M.data = function(dataname, constructors)
  local datatype = {}

  for name, constructor in pairs(constructors) do
    if type(constructor) == "function"
    then
      datatype[name] = function(x)
        return M.type(dataname, M.type(name, constructor(x)))
      end
    else datatype[name] =
      M.type(dataname, M.type(name, nil))
    end

  end
  datatype.type = dataname

  return datatype
end

M.class = function(name)
  return { default = function(x,_)
    error("No '" .. name .. "' instance for type: " .. x.type)
  end
  }
end

return M
