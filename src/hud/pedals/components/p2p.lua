local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pedalsData = require("src.data.pedals.pedalsData")
local p2p = {}

local oldKersCharge = CAR.kersCharge
---@param data pedalsData
function p2p.drawP2p(data)
	local size = vec2(0, 10 * pedalsSettings.store.pedalsScale)
	local pos = vec2()
	pos.y = data.contentPositions[pedalsSettings.store.p2pPos][1].y
	local space
	local center
	if pedalsSettings.store.p2pPos == 5 then
		space = data.currentWindowWidth - data.contentPositions[1][2].x - data.contentPositions[1][1].x - data.contentPositions[2][2].x
		if space < 75 * pedalsSettings.store.pedalsScale then
			data.currentWindowWidth = data.currentWindowWidth + (80 * pedalsSettings.store.pedalsScale - space)
			space = data.currentWindowWidth - data.contentPositions[1][2].x - data.contentPositions[1][1].x - data.contentPositions[2][2].x
		end
		size.x = space * pedalsSettings.store.p2pLenght
		center = data.contentPositions[1][2].x + data.contentPositions[1][1].x + space / 2
		pos.x = center - (size.x / 2)
		pos.y = pos.y + 5 * pedalsSettings.store.pedalsScale
	else
		space = data.currentWindowWidth - data.contentPositions[3][2].x - data.contentPositions[3][1].x - data.contentPositions[4][2].x
		if space < 75 * pedalsSettings.store.pedalsScale then
			data.currentWindowWidth = data.currentWindowWidth + (80 * pedalsSettings.store.pedalsScale - space)
			space = data.currentWindowWidth - data.contentPositions[3][2].x - data.contentPositions[3][1].x - data.contentPositions[4][2].x
		end
		size.x = math.max(space * pedalsSettings.store.p2pLenght, 50 * pedalsSettings.store.pedalsScale)
		center = data.contentPositions[3][2].x + data.contentPositions[3][1].x + space / 2
		pos.x = center - (size.x / 2)
		pos.y = pos.y - 15 * pedalsSettings.store.pedalsScale
	end
	pedalsData.setPositionContentCenter(data, pedalsSettings.store.p2pPos, size + vec2(0, 5):scale(pedalsSettings.store.pedalsScale))

	ui.drawRectFilled(pos, pos + size, COLOR.GRAY_BG, 10 * pedalsSettings.store.pedalsScale)

	local color
	if oldKersCharge < CAR.kersCharge then
		color = COLOR.GREEN
	elseif oldKersCharge > CAR.kersCharge then
		color = COLOR.RED
	else
		color = COLOR.BLUE_SKY
	end
	oldKersCharge = CAR.kersCharge
	if CAR.kersCharge > 0.01 then
		ui.drawRectFilled(pos, pos + vec2(size.x * CAR.kersCharge, size.y), color, 10 * pedalsSettings.store.pedalsScale)
	end
	ui.setCursor(pos)
	ui.dwriteTextAligned(
		string.format("%.0f%%", CAR.kersCharge * 100),
		10 * pedalsSettings.store.pedalsScale,
		ui.Alignment.Center,
		ui.Alignment.Center,
		vec2(size.x, size.y),
		false,
		COLOR.WHITE
	)
end

return p2p
