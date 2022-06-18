-- The gods of procedural begged for their survival yet the functional deities
-- refused to accept their beseeching. Here lies the ruin of their former civilization
-- now replaced by a typed functional distopia.

-- Types are tables that store a value and a type field

-- data is used to create new types
-- class is used to create new typeclasses

local M = {}

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

M.typeOf = function(x)
  if type(x) == "table" and x.type then
    return x.type
  end
  return type(x)
end

M.class = function(classname, functions)
  local class = {}

  for _, func in pairs(functions) do
    class[func] = {
      instance = { default = function(x)
        error(string.format("No '%s' instance for type '%s'", classname, M.typeOf(x)))
      end
      }
    }
  end

  return class
end

return M
