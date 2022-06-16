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
  lt = function(x) return function(y) return x < y end end,
  gt = function(x) return function(y) return x > y end end,
  ltOrE = function(x) return function(y) return x <= y end end,
  gtOrE = function(x) return function(y) return x >= y end end,

}

return M
