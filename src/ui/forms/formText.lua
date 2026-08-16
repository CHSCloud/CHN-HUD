local utils = require("common.utils")
local rect = require("src.ui.background.rect")
local formText = {}

--- @param id string
--- @param pos vec2
--- @param text string
--- @param size vec2
--- @param rounding number
--- @param color rgbm
--- @param textFlags? ui.InputTextFlags
--- @return string, vec2, boolean
function formText.main(id, pos, text, size, rounding, color, textFlags)
	local textFormated = string.replace(text, "\\n", "\n")
	local longestWord, _ = utils.findLongestWord(textFormated)
	local textLenght = ui.measureText(longestWord)
	if textLenght.x > size.x - 15 then
		size.x = textLenght.x + 15
	end
	local _, count = string.gsub(textFormated, "\n", "")
	rect.drawRectRounded(pos, pos + vec2(size.x, size.y + textLenght.y * count), color, rounding, 20)
	ui.pushStyleColor(ui.StyleColor.FrameBg, rgbm.from0255(0, 0, 0, 0))
	ui.pushStyleColor(ui.StyleColor.Text, COLOR.BLACK)
	ui.setCursor(pos)
	text = ui.inputText("##" .. id, textFormated, textFlags, vec2(size.x, size.y * 2 + textLenght.y * count))
	ui.popStyleColor(2)

	return string.replace(text, "\n", "\\n"), vec2(size.x, size.y + textLenght.y * count), ui.itemEdited()
end

return formText
