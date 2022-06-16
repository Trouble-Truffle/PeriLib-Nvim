-- Checks if the functions are working correctly
return function()

  local List = require("PeriLib.Data.List")
  local Oper = require("PeriLib.Operator")
  local Func = require("PeriLib.Data.Function")
  local Maybe = require("PeriLib.Data.Maybe")
  local Prelude = require("PeriLib.Prelude")
  local Functor = require("PeriLib.Data.Functor")

  print("Testing functions...")
  local printLn = Func.compose(print, vim.inspect)

  local function header(text)
    vim.api.nvim_echo({ { text .. "\n", "TSUnderline" } }, false, {})
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

  header("Data.Functor")
  shouldBe("fmap",
    {{Functor.fmap(Oper.add(2), {3,2,4}), {5,4,6}, "With List"},
     {Functor.fmap(Oper.add(3), Oper.mul(2))(3), 9, "With function"},
     {Functor.fmap(Oper.add(3), {b = 2, c = {2,3}}), {b = 5, c = {5,6}}, "With table"},
    })

  header("Data.Maybe")
  shouldBe("isJust", {{Maybe.isJust(Maybe.Just(1)), true} })
  shouldBe("isNothing", {{Maybe.isNothing(Maybe.Nothing), true } })

  shouldBe("maybe", { {Maybe.maybe(1, Oper.add(2), Maybe.Just(2)), 4 , "With Just"},
                      {Maybe.maybe(1, Oper.add(2), Maybe.Nothing), 1 , "With Nothing"} })

  shouldBe("fromMaybe", { {Maybe.fromMaybe(1, Maybe.Just(2)), 2 , "With Just"},
                          {Maybe.fromMaybe(1, Maybe.Nothing), 1 , "With Nothing"} })

  shouldBe("Eq Instance",  {{Prelude.equal(Maybe.Just(1) ,Maybe.Just(1)), true,  "With equal Just values"},
                            {Prelude.equal(Maybe.Just(1) ,Maybe.Just(2)), false, "With different Just values"},
                            {Prelude.equal(Maybe.Nothing ,Maybe.Nothing), true,  "With both Nothing"},
                            {Prelude.equal(Maybe.Nothing ,Maybe.Just(1)), false, "With Just and Nothing"}})

  --shouldBe("List.mempty",List.mempty, {})
  --shouldBe("List.mappend",List.mappend({1,2,3}, {4,5,6}), {1,2,3,4,5,6})
  --shouldBe("List.mconcat",List.mconcat({{1,2,3}, {4,5,6}}), {1,2,3,4,5,6})

end
