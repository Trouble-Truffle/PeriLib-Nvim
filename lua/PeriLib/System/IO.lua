local Prelude = require("PeriLib.Prelude")
local Type    = require("PeriLib.Type")
local Monoid  = require("PeriLib.Data.Monoid")
local Function = require("PeriLib.Data.Function")
local Functor  = require("PeriLib.Data.Functor")
local Applicative = require("PeriLib.Control.Applicative")
local Monad       = require("PeriLib.Control.Monad")
local M = {}

M.printLn = function(x)
  print(Prelude.show(x))
end

for k,v in pairs(Type.data("IO",
                 {FileIORead = Function.id, funcs = {} }))
do
  M[k] = v
end

M.runIO = function(action)
  return Prelude.case(Type.typeOf(action.value), {
      ["FileIORead"] = function ()
        local file = action.value.value
        local str = file:read("all")
        file:close()
        return str
      end
    })()
end

Monoid.Monoid.mappend.instance["IO"] = function(x,y)
  Prelude.match({Type.typeOf(x.value), Type.typeOf(y.value)}, nil)
end

--Functor.Functor.fmap.instance["IO"] = function(f,x)
  --return M.IO(f(M.unsafePerformIO(x)))
--end

--Applicative.Applicative.liftA2.instance["IO"] = function(f,x,y)
  --return M.IO(Function.on(f , M.unsafePerformIO)(x,y))
--end

--Monad.Monad.bind.instance["IO"] = function(x, f)
  --return f(x)
--end

M.readFile = function(filepath)
  return M.FileIORead(assert(io.open(filepath, "r")))
end


return M
