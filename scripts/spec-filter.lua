-- Render a step's leading role label, "[transactor] Submit ...", as a styled
-- span without brackets. Only the first word of an ordered-list item matches.
function OrderedList(list)
  for _, item in ipairs(list.content) do
    local first = item[1]
    if first and (first.t == "Plain" or first.t == "Para") then
      local word = first.content[1]
      if word and word.t == "Str" then
        local role = word.text:match("^%[([%a][%a%-]*)%]$")
        if role then
          first.content[1] = pandoc.Span({ pandoc.Str(role) }, { class = "role" })
        end
      end
    end
  end
  return list
end
