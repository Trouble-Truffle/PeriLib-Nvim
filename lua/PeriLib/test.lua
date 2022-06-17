-- Checks if the functions are working correctly
return function()

  local List = require("PeriLib.Data.List")
  local Oper = require("PeriLib.Operator")
  local Func = require("PeriLib.Data.Function")
  local Maybe = require("PeriLib.Data.Maybe")
  local Prelude = require("PeriLib.Prelude")
  local Functor = require("PeriLib.Data.Functor")

  print("Testing functions...")

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
        vim.api.nvim_echo({{"   Test: " .. x[3], "PMenu"}}, false, {})
      end

      if Prelude.equal(x[1], x[2]) then
        vim.api.nvim_echo({ { "   Pass\n", "Character" } }, false, {})
      else
        errors = errors + 1
        vim.api.nvim_echo(
          { { "   Failed", "ErrorMsg" },
            { "\n   Expected: ", "ErrorMsg" }, { vim.inspect(x[2]), "WarningMsg" },
            { "\n   Got: ", "ErrorMsg" }, { vim.inspect(x[1]), "WarningMsg" } }, false, {})
        error("Failed Test")
      end
    end
    if errors ~= 0 then
      vim.api.nvim_echo({ { string.format("%i error%s in test '%s'\n"
        , errors, errors == 1 and "" or "s", text),
      "ErrorMsg" } }, false, {})
    end

  end

  header("Prelude")
  shouldBe("switch",
    {{Prelude.switch("Test", {Test = 3, default = 4}), 3, "With available switch case"}
    ,{Prelude.switch("_", {Test = 3, default = 4}), 4, "With default case"}})

  shouldBe("equal",
    {{Prelude.equal(3, 3), true, "With equal values"},
     {Prelude.equal(3, 4), false, "With different values"},
     {Prelude.equal(3, "3"), false, "With different types"},
     {Prelude.equal({1,2}, {1,2}), true, "With equal tables"},
     {Prelude.equal({1,2}, {1,2,3}), false, "With different tables"},
    })

  header("Data.Function")
  shouldBe("id", {{Func.id(3), 3}})
  shouldBe("const", {{Func.const(2)(3), 2}})
  shouldBe("uncurry", {{Func.uncurry(Oper.add)(2,3), 5}})
  shouldBe("on", {{Func.on(Func.uncurry(Oper.add), Oper.mul(2))(3, 3), 12}})
  shouldBe("compose", {{Func.compose(Oper.add(2), Oper.mul(2))(3), 8}})

  header("Data.Monoid")
  local Monoid = require("PeriLib.Data.Monoid")
  shouldBe("mappend",
    {{Monoid.mappend({2,3},{3,4}), {2,3,3,4}, "With Lists"},
     {Monoid.mappend({2,3}, Monoid.mempty), {2,3}, "With List and mempty"}
    })
  shouldBe("mconcat",
    {{Monoid.mconcat({{2,1},{3,4}}), {2,1,3,4}},
    })

  header("Data.Functor")
  shouldBe("fmap",
    {{Functor.fmap(Oper.add(2), {3,2,4}), {5,4,6}, "With List"},
     {Functor.fmap(Oper.add(3), Oper.mul(2))(3), 9, "With function"},
     {Functor.fmap(Oper.add(3), {b = 2, c = {2,3}}), {b = 5, c = {5,6}}, "With table"},
    })

  header("Data.List")
  shouldBe("head", {{List.head({1,2,3}), Maybe.Just(1)}})
  shouldBe("tail", {{List.tail({1,2,3}), Maybe.Just({2,3})}})
  shouldBe("init", {{List.init({1,2,3}), Maybe.Just({1,2})}})
  shouldBe("last", {{List.last({1,2,3}), Maybe.Just(3)}})
  shouldBe("null", {{List.null({}), true}})
  shouldBe("map", {{List.map(Oper.add(2), {1,2,3}), {3,4,5}}})
  shouldBe("filter", {{List.filter(Oper.gt(2), {1,2,3}), {3}}})
  shouldBe("take", {{List.take({1,2,3}, 2), {1,2}}})
  shouldBe("drop", {{List.drop({1,2,3}, 2), {3}}})
  shouldBe("takeWhile", {{List.takeWhile({1,2,3}, Oper.lt(3)), {1,2}}})
  shouldBe("dropWhile", {{List.dropWhile({1,2,3}, Oper.lt(3)), {3}}})
  shouldBe("span", {{List.span({1,2,3}, Oper.lt(3)), {{1,2}, {3}}}})
  shouldBe("slice", {{List.slice({1,2,3}, 1, 2), {1,2}, "With start and end"},
                     {List.slice({1,2,3}, {1, 3}), {1, 3}, "With table of indices"},
          })
  shouldBe("Iota", {{List.iota(3), {1,2,3}, "With 1 argument"},
                    {List.iota(2,7), {2,3,4,5,6,7}, "With 2 arguments"}
          })
  shouldBe("elem", {{List.elem({2,3,4,1}, 3), true},
                    {List.elem({2,3,4,1}, 5), false}
          })
  shouldBe("zipWith", {{List.zipWith({1,2,3}, {4,5,6}, Oper.uncAdd), {5,7,9}}})
  shouldBe("zip", {{List.zip({1,2,3}, {4,5,6}), {{1,4}, {2,5}, {3,6}}, "With equal length lists"}
                  ,{List.zip({1,2,3}, {4,5}), {{1,4}, {2,5}}, "With different length lists"}
  })

  local Tuple = require("PeriLib.Data.Tuple")
  header("Data.Tuple")
  shouldBe("fst", {{Tuple.fst({1,2}), 1}})
  shouldBe("snd", {{Tuple.snd({1,2}), 2}})
  shouldBe("swap", {{Tuple.swap({1,2}), {2,1}}})

  local Foldable = require("PeriLib.Data.Foldable")
  header("Data.Foldable")
  shouldBe("Foldr", {{Foldable.foldr(Oper.uncAdd, 0, {1,2,3}), 6, "With List"}})

  header("Data.Maybe")
  shouldBe("isJust", {{Maybe.isJust(Maybe.Just(1)), true} })
  shouldBe("isNothing", {{Maybe.isNothing(Maybe.Nothing), true } })

  shouldBe("maybe", { {Maybe.maybe(1, Oper.add(2), Maybe.Just(2)), 4 , "With Just"},
                      {Maybe.maybe(1, Oper.add(2), Maybe.Nothing), 1 , "With Nothing"} })

  shouldBe("fromMaybe", { {Maybe.fromMaybe(1, Maybe.Just(2)), 2 , "With Just"},
                          {Maybe.fromMaybe(1, Maybe.Nothing), 1 , "With Nothing"} })

  shouldBe("Show instance", {
      {Prelude.show(Maybe.Just(1)), "Just 1", "With Just"}
    , {Prelude.show(Maybe.Nothing), "Nothing", "With Nothing"}
  })


  shouldBe("Eq Instance",  {{Prelude.equal(Maybe.Just(1) ,Maybe.Just(1)), true,  "With equal Just values"},
                            {Prelude.equal(Maybe.Just(1) ,Maybe.Just(2)), false, "With different Just values"},
                            {Prelude.equal(Maybe.Nothing ,Maybe.Nothing), true,  "With both Nothing"},
                            {Prelude.equal(Maybe.Nothing ,Maybe.Just(1)), false, "With Just and Nothing"}})

  shouldBe("Functor Instance", {{Functor.fmap(Oper.add(2), Maybe.Just(3)), Maybe.Just(5), "With Just"},
                                {Functor.fmap(Oper.add(2), Maybe.Nothing), Maybe.Nothing, "With Nothing"}})
end
