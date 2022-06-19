-- Checks if the functions are working correctly
--
local Type = require "PeriLib.Type"
local Prelude = require "PeriLib.Prelude"
local Func = require "PeriLib.Data.Function"
local Oper = require "PeriLib.Operator"
local Monoid = require "PeriLib.Data.Monoid"
local Functor = require "PeriLib.Data.Functor"
local List = require "PeriLib.Data.List"
local Tuple = require "PeriLib.Data.Tuple"
local Maybe = require "PeriLib.Data.Maybe"
local Foldable = require "PeriLib.Data.Foldable"
local Applicative = require "PeriLib.Control.Applicative"
local Monad = require "PeriLib.Control.Monad"
local IO    = require "PeriLib.System.IO"

return function()

  print "Testing functions..."

  local function header(text)
    vim.api.nvim_echo({ { "\n" .. text .. "\n", "TSUnderline" } }, false, {})
  end

  local function subHeader(text)
    vim.api.nvim_echo({ { " " .. text .. "\n", "Underlined" } }, false, {})
  end

  local function shouldBe(text, xs)
    subHeader(text)
    local errors = 0
    for _, x in ipairs(xs) do
      if x[3] ~= nil then
        vim.api.nvim_echo({ { "   Test: " .. x[3], "PMenu" } }, false, {})
      end

      if Prelude.equal(x[1], x[2]) then
        vim.api.nvim_echo({ { "   Pass\n", "Character" } }, false, {})
      else
        errors = errors + 1
        vim.api.nvim_echo({
          { "   Failed", "ErrorMsg" },
          { "\n   Expected: ", "ErrorMsg" },
          { vim.inspect(x[2]), "WarningMsg" },
          { "\n   Got: ", "ErrorMsg" },
          { vim.inspect(x[1]), "WarningMsg" },
        }, false, {})
        error "Failed Test"
      end
    end
    if errors ~= 0 then
      vim.api.nvim_echo(
        { { string.format("%i error%s in test '%s'\n", errors, errors == 1 and "" or "s", text), "ErrorMsg" } },
        false,
        {}
      )
    end
  end

  IO.printLn(IO.runIO(IO.readFile("/home/truff/.local/src/sandbox/haskell/app/Main.hs")))

  header "Prelude"
  shouldBe("switch", {
    { Prelude.case("Test", { Test = 3, default = 4 }), 3, "With available switch case" },
    { Prelude.case("_", { Test = 3, default = 4 }), 4, "With default case" },
  })

  --shouldBe("match", {
    --{ Prelude.match}
  --})

  shouldBe("equal", {
    { Prelude.equal(3, 3), true, "With equal values" },
    { Prelude.equal(3, 4), false, "With different values" },
    { Prelude.equal(3, "3"), false, "With different types" },
    { Prelude.equal({ 1, 2 }, { 1, 2 }), true, "With equal tables" },
    { Prelude.equal({ 1, 2 }, { 1, 2, 3 }), false, "With different tables" },
  })
  shouldBe("compare", {
    { Prelude.compare(3, 4), Prelude.LT },
    { Prelude.compare(4, 4), Prelude.EQ },
    { Prelude.compare(4, 3), Prelude.GT },
  })
  shouldBe("max", { { Prelude.max(1, 2), 2 } })
  shouldBe("min", { { Prelude.min(1, 2), 1 } })

  header "Data.Function"
  shouldBe("id", { { Func.id(3), 3 } })
  shouldBe("const", { { Func.const(2)(3), 2 } })
  shouldBe("curry", { { Func.curry(function (x,y) return x + y end)(2)(3), 5 } })
  shouldBe("uncurry", { { Func.uncurry(function (x) return function(y) return x + y end end)(2,3), 5 } })
  shouldBe("on", { { Func.on(Oper.add, Oper.mul(2))(3, 3), 12 } })
  shouldBe("compose", { { Func.compose(Oper.add(2), Oper.mul(2))(3), 8 } })
  shouldBe("application", {{ Func.application({Oper.minuend(3), Oper.add(4), Oper.mul(2)},2), 5}})

  header "Data.Monoid"
  shouldBe("mappend", {
    { Monoid.mappend({ 2, 3 }, { 3, 4 }), { 2, 3, 3, 4 }, "With Lists" },
    { Monoid.mappend({ 2, 3 }, Monoid.mempty), { 2, 3 }, "With List and mempty" },
  })
  shouldBe("mconcat", { { Monoid.mconcat({ { 2, 1 }, { 3, 4 } }), { 2, 1, 3, 4 } } })

  header "Data.Functor"
  shouldBe("fmap", {
    { Functor.fmap(Oper.add(2), { 3, 2, 4 }), { 5, 4, 6 }, "With List" },
    { Functor.fmap(Oper.add(3), Oper.mul(2))(3), 9, "With function" },
    { Functor.fmap(Oper.add(3), { b = 2, c = { 2, 3 } }), { b = 5, c = { 5, 6 } }, "With table" },
  })

  header "Data.List"
  shouldBe("append", { { List.append(2, { 2, 4, 6, 5 }), { 2, 2, 4, 6, 5 } } })
  shouldBe("head", { { List.head({ 1, 2, 3 }), Maybe.Just(1) } })
  shouldBe("tail", { { List.tail({ 1, 2, 3 }), Maybe.Just({ 2, 3 }) } })
  shouldBe("init", { { List.init({ 1, 2, 3 }), Maybe.Just({ 1, 2 }) } })
  shouldBe("last", { { List.last({ 1, 2, 3 }), Maybe.Just(3) } })
  shouldBe("reverse", { { List.reverse({ 1, 2, 3 }), { 3, 2, 1 } } })
  shouldBe("null", { { List.null({}), true } })
  shouldBe("map", { { List.map(Oper.add(2), { 1, 2, 3 }), { 3, 4, 5 } } })
  shouldBe("filter", { { List.filter(Oper.gt(2), { 1, 2, 3 }), { 3 } } })
  shouldBe("take", { { List.take({ 1, 2, 3 }, 2), { 1, 2 } } })
  shouldBe("drop", { { List.drop({ 1, 2, 3 }, 2), { 3 } } })
  shouldBe("takeWhile", { { List.takeWhile({ 1, 2, 3 }, Oper.lt(3)), { 1, 2 } } })
  shouldBe("dropWhile", { { List.dropWhile({ 1, 2, 3 }, Oper.lt(3)), { 3 } } })
  shouldBe("span", { { List.span({ 1, 2, 3 }, Oper.lt(3)), { { 1, 2 }, { 3 } } } })
  shouldBe("slice", {
    { List.slice({ 1, 2, 3 }, 1, 2), { 1, 2 }, "With start and end" },
    { List.slice({ 1, 2, 3 }, { 1, 3 }), { 1, 3 }, "With table of indices" },
  })
  shouldBe("Iota", {
    { List.iota(3), { 1, 2, 3 }, "With 1 argument" },
    { List.iota(2, 7), { 2, 3, 4, 5, 6, 7 }, "With 2 arguments" },
  })
  shouldBe("elem", { { List.elem({ 2, 3, 4, 1 }, 3), true }, { List.elem({ 2, 3, 4, 1 }, 5), false } })
  shouldBe("zipWith", { { List.zipWith({ 1, 2, 3 }, { 4, 5, 6 }, Oper.add), { 5, 7, 9 } } })
  shouldBe("zip", {
    { List.zip({ 1, 2, 3 }, { 4, 5, 6 }), { { 1, 4 }, { 2, 5 }, { 3, 6 } }, "With equal length lists" },
    { List.zip({ 1, 2, 3 }, { 4, 5 }), { { 1, 4 }, { 2, 5 } }, "With different length lists" },
  })
  shouldBe("sum", { { List.sum({ 1, 2, 3, 4 }), 10 } })
  shouldBe("difference", { { List.difference({ 1, 2, 3, 4 }), -10 } })
  shouldBe("product", { { List.product({ 4, 3, 2, 1 }), 24 } })
  shouldBe("quotient", { { List.quotient({ 5, 2 }), 0.1 } })
  shouldBe("maximum", { { List.maximum({ 2, 4, 2, 5, 2 }), 5 } })
  shouldBe("minimum", { { List.minimum({ 5, 3, 5, 3, 1, 3 }), 1 } })
  shouldBe(
    "listAnd",
    { { List.listAnd({ true, true, true, false }), false }, { List.listAnd({ true, true, true, true }), true } }
  )
  shouldBe("listOr", {
    { List.listOr({ false, false, false }), false },
    { List.listOr({ false, false, true }), true },
  })
  shouldBe("any", {
    { List.any(Oper.eq(2), { 3, 4, 1 }), false },
    { List.any(Oper.eq(2), { 3, 4, 2, 1 }), true },
  })
  shouldBe("all", {
    { List.all(Oper.eq(2), { 2, 2, 2, 3 }), false },
    { List.all(Oper.eq(2), { 2, 2, 2, 2 }), true },
  })

  shouldBe("group", {
    { List.groupBy(Oper.gt, { 2, 3, 4, 2, 1, 2, 4, 4, 1 }), { { 2, 3, 4 }, { 2 }, { 1, 2, 4, 4 }, { 1 } } },
    { List.group({ 1, 1, 1, 2, 2, 3, 2, 2 }), { { 1, 1, 1 }, { 2, 2 }, { 3 }, { 2, 2 } } },
  })

  header "Data.Tuple"
  shouldBe("fst", { { Tuple.fst({ 1, 2 }), 1 } })
  shouldBe("snd", { { Tuple.snd({ 1, 2 }), 2 } })
  shouldBe("swap", { { Tuple.swap({ 1, 2 }), { 2, 1 } } })
  shouldBe("structure", { { Tuple.structure(1, 2), { 1, 2 } } })

  header "Data.Foldable"
  shouldBe("foldl", { { Foldable.foldl(Oper.add, 1, { 2, 3 }), 6 } })
  shouldBe("foldl1", { { Foldable.foldl1(Oper.add, { 1, 2, 3 }), 6 } })
  shouldBe("scanl", { { Foldable.scanl(Oper.add, 1, { 1, 2, 3 }), { 1, 2, 4, 7 } } })
  shouldBe("scanl1", { { Foldable.scanl1(Oper.add, { 1, 1, 2, 3 }), { 1, 2, 4, 7 } } })

  header "Control.Applicative"
  shouldBe("liftA2", {
    {
      Applicative.liftA2(Tuple.structure, { 2, 3 }, { 3, 4 }),
      { { 2, 3 }, { 2, 4 }, { 3, 3 }, { 3, 4 } },
      "With List",
    },
    { Applicative.liftA2(Oper.mul, Oper.add(2), Oper.add(3))(1), 12, "With Function" },
  })
  shouldBe("Alternative", {
    { Applicative.alternative({ 1, 2 }, {}), { 1, 2 }, "With Second One empty" },
    { Applicative.alternative({ 1, 2 }, { 3 }), { 1, 2 }, "With None empty" },
    { Applicative.alternative({}, { 3 }), { 3 }, "With First One empty" },
    { Applicative.alternative({}, {}), {}, "With Both empty" },
  })

  header "Control.Monad"
  shouldBe("bind", {
    { Monad.bind({ 2, 3, 4 }, function(x)
      return { x, x }
    end), { 2, 2, 3, 3, 4, 4 }, "With List" },
    { Monad.bind(Oper.add(1), Oper.mul)(4), 20, "With Function" },
  })
  shouldBe("join", {
    {Monad.join({{2,3}, {4,2}}), {2,3,4,2}},
    {Monad.join(Oper.add)(1), 2}
  })

  header "Data.Maybe"
  shouldBe("isJust", { { Maybe.isJust(Maybe.Just(1)), true } })
  shouldBe("isNothing", { { Maybe.isNothing(Maybe.Nothing), true } })

  shouldBe("maybe", {
    { Maybe.maybe(1, Oper.add(2), Maybe.Just(2)), 4, "With Just" },
    { Maybe.maybe(1, Oper.add(2), Maybe.Nothing), 1, "With Nothing" },
  })

  shouldBe("fromMaybe", {
    { Maybe.fromMaybe(1, Maybe.Just(2)), 2, "With Just" },
    { Maybe.fromMaybe(1, Maybe.Nothing), 1, "With Nothing" },
  })

  shouldBe("Show instance", {
    { Prelude.show(Maybe.Just(1)), "Just 1", "With Just" },
    { Prelude.show(Maybe.Nothing), "Nothing", "With Nothing" },
  })

  shouldBe("Eq Instance", {
    { Prelude.equal(Maybe.Just(1), Maybe.Just(1)), true, "With equal Just values" },
    { Prelude.equal(Maybe.Just(1), Maybe.Just(2)), false, "With different Just values" },
    { Prelude.equal(Maybe.Nothing, Maybe.Nothing), true, "With both Nothing" },
    { Prelude.equal(Maybe.Nothing, Maybe.Just(1)), false, "With Just and Nothing" },
  })

  shouldBe("Monoid Instance", {
    { Monoid.mappend(Maybe.Just({2,3}), Maybe.Just({4,1})), Maybe.Just({2,3,4,1})},
    { Monoid.mappend(Maybe.Just({2,3}), Maybe.Nothing) , Maybe.Just({2,3})},
    { Monoid.mappend(Maybe.Nothing, Maybe.Nothing) , Maybe.Nothing},
  })

  shouldBe("Functor Instance", {
    { Functor.fmap(Oper.add(2), Maybe.Just(3)), Maybe.Just(5), "With Just" },
    { Functor.fmap(Oper.add(2), Maybe.Nothing), Maybe.Nothing, "With Nothing" },
  })

  shouldBe("Applicative Instance", {
    { Applicative.liftA2(Oper.add, Maybe.Just(3), Maybe.Just(3)), Maybe.Just(6) },
    { Applicative.liftA2(Oper.add, Maybe.Nothing, Maybe.Just(2)), Maybe.Nothing },
  })

  shouldBe("Alternative Instance", {
    { Applicative.alternative(Maybe.Just(2), Maybe.Nothing), Maybe.Just(2) },
    { Applicative.alternative(Maybe.Nothing, Maybe.Just(4)), Maybe.Just(4) },
    { Applicative.alternative(Maybe.Nothing, Maybe.Nothing), Maybe.Nothing },
  })

  shouldBe("Monad Instance", {
    { Monad.bind(Maybe.Just(2), function(x)
      return Maybe.Just(x + 1)
    end), Maybe.Just(3) },
    { Monad.bind(Maybe.Nothing, function(x)
      return Maybe.Just(x + 1)
    end), Maybe.Nothing },
  })


end
