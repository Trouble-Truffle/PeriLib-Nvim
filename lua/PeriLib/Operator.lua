-- Convecience module for defining operators as functions.

local M =
{
  add = function(x) return function(y) return x + y end end,
  sub = function(x) return function(y) return x - y end end,
  mul = function(x) return function(y) return x * y end end,
  div = function(x) return function(y) return x / y end end,
  mod = function(x) return function(y) return x % y end end,
  pow = function(x) return function(y) return x ^ y end end,
  eq = function(x) return function(y) return x == y end end,
  neq = function(x) return function(y) return x ~= y end end,
  lt = function(x) return function(y) return x > y end end,
  gt = function(x) return function(y) return x < y end end,
  ltOrE = function(x) return function(y) return x >= y end end,
  gtOrE = function(x) return function(y) return x <= y end end,

  -- Uncurried operators
  uncAdd = function(x,y) return x + y end,
  uncSub = function(x,y) return x - y end,
  uncMul = function(x,y) return x * y end,
  uncDiv = function(x,y) return x / y end,
  uncMod = function(x,y) return x % y end,
  uncPow = function(x,y) return x ^ y end,
  uncEq = function(x,y) return x == y end,
  uncNeq = function(x,y) return x ~= y end,
  uncLt = function(x,y) return x < y end,
  uncGt = function(x,y) return x > y end,
  uncLtOrE = function(x,y) return x <= y end,
  uncGtOrE = function(x,y) return x >= y end,

}

return M
