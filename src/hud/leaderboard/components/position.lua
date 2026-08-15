local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")
local position = {}

-- Desenha posições
---@param data leaderboardData
---@param logoPath string
---@param nationPath string
---@param driverDrawNumber number
---@param carPosition number
---@param driverName string
---@param pos vec2
---@param color rgbm
function position.drawPosition(data, logoPath, nationPath, driverDrawNumber, carPosition, driverName, pos, color)
	local backgroundColor
	if driverDrawNumber % 2 == 1 then
		backgroundColor = WindowsColor
	else
		backgroundColor = COLOR.GRAY_BG
	end
	ui.drawRectFilled(pos, pos + vec2(data.currentWindowSize.x, 35 * leaderboardSettings.store.leaderboardScale), backgroundColor)

	-- Desenha posição do jogador
	ui.drawRectFilled(
		pos + vec2(10, 2.5):scale(leaderboardSettings.store.leaderboardScale),
		pos + vec2(40, 32.5):scale(leaderboardSettings.store.leaderboardScale),
		color,
		5 * leaderboardSettings.store.leaderboardScale
	)
	ui.setCursor(pos + vec2(10, 2.5):scale(leaderboardSettings.store.leaderboardScale))
	ui.dwriteTextAligned(
		tostring(carPosition),
		20 * leaderboardSettings.store.leaderboardScale,
		ui.Alignment.Center,
		ui.Alignment.Center,
		vec2(30, 30):scale(leaderboardSettings.store.leaderboardScale),
		false,
		COLOR.BLACK
	)

	pos.x = pos.x + 10 * leaderboardSettings.store.leaderboardScale
	-- Desenha logo do carro
	if leaderboardSettings.store.logoActive then
		pos.x = pos.x + 40 * leaderboardSettings.store.leaderboardScale
		ui.setCursor(pos + vec2(0, 2.5):scale(leaderboardSettings.store.leaderboardScale))
		ui.image(logoPath, vec2(28, 28):scale(leaderboardSettings.store.leaderboardScale), ui.ImageFit.Fill)
	end
	-- Desenha logo do país
	if leaderboardSettings.store.nationActive then
		pos.x = pos.x + 40 * leaderboardSettings.store.leaderboardScale
		ui.setCursor(pos + vec2(0, 2.5):scale(leaderboardSettings.store.leaderboardScale))
		ui.image(nationPath, vec2(28, 28):scale(leaderboardSettings.store.leaderboardScale), ui.ImageFit.Fill)
	end

	-- Desenha nome do jogador
	pos.x = pos.x + 40 * leaderboardSettings.store.leaderboardScale
	ui.setCursor(pos + vec2(0, 2.5):scale(leaderboardSettings.store.leaderboardScale))
	ui.dwriteTextAligned(
		driverName,
		18 * leaderboardSettings.store.leaderboardScale,
		ui.Alignment.Start,
		ui.Alignment.Center,
		vec2(200, 30):scale(leaderboardSettings.store.leaderboardScale),
		false,
		color
	)

	pos.x = pos.x + 190 * leaderboardSettings.store.leaderboardScale
	data.positionLenght = pos.x / leaderboardSettings.store.leaderboardScale
	data.posX = data.posX + data.positionLenght
end

return position
