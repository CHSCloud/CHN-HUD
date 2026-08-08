local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")
local tyres = {}

-- Desenha tipo de pneu
---@param data leaderboardData
---@param tyreName string
---@param pos vec2
function tyres.drawTyre(data, tyreName, pos, color)
	if leaderboardSettings.store.tyreActive then
		ui.setCursor(pos)
		ui.dwriteTextAligned(
			tyreName,
			18 * leaderboardSettings.store.leaderboardScale,
			ui.Alignment.Center,
			ui.Alignment.Center,
			vec2(data.tyreLenght, 30):scale(leaderboardSettings.store.leaderboardScale),
			false,
			color
		)
		data.posX = data.posX + data.tyreLenght
	end
end

return tyres
