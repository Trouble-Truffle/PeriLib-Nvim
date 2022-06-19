-- Convecience module for defining operators as functions.

local M =
{
  add = function(x,y_)
    if y_
      then return x + y_
      else return function(y) return x + y end
    end
  end,

  sub = function(x,y_)
    if y_
      then return x - y_
      else return function(y) return x - y end
    end
  end,

  minuend = function(x,y_)
    if y_
      then return y_ - x
      else return function(y) return y - x end
    end
  end,

  mul = function(x,y_)
    if y_
      then return x * y_
      else return function(y) return x * y end
    end
  end,

  div = function(x,y_)
    if y_
      then return x / y_
      else return function(y) return x / y end
    end
  end,

  divisor = function(x,y_)
    if y_
      then return y_ / x
      else return function(y) return y / x end
    end
  end,

  mod = function(x,y_)
    if y_
      then return x % y_
      else return function(y) return x % y end
    end
  end,

  pow = function(x,y_)
    if y_
      then return x ^ y_
      else return function(y) return x ^ y end
    end
  end,

  exp = function(x,y_)
    if y_
      then return y_ ^ x
      else return function(y) return y ^ x end
    end
  end,

  eq = function(x,y_)
    if y_
      then return x == y_
      else return function(y) return x == y end
    end
  end,

  neq = function(x,y_)
    if y_
      then return x ~= y_
      else return function(y) return x ~= y end
    end
  end,

  lt = function(x,y_)
    if y_
      then return x < y_
      else return function(y) return x > y end
    end
  end,

  gt = function(x,y_)
    if y_
      then return x > y_
      else return function(y) return x < y end
    end
  end,

  ltOrEq = function(x,y_)
    if y_
      then return x <= y_
      else return function(y) return x >= y end
    end
  end,

  gtOrEq = function(x,y_)
    if y_
      then return x >= y_
      else return function(y) return x <= y end
    end
  end,

  opOr = function(x,y_)
    if y_
      then return x or y_
      else return function(y) return x or y end
    end
  end,

  opAnd = function(x,y_)
    if y_
      then return x and y_
      else return function(y) return x and y end
    end
  end,

  opNot = function(x)
    return not x
  end,

}

return M
