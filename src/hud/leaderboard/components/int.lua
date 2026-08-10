local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")

local int = {}

-- Desenha o int
---@param data leaderboardData
---@param driver table
---@param pos vec2
---@param color rgbm
function int.drawInt(data, driver, pos, color)
	if leaderboardSettings.store.intActive then
		ui.setCursor(pos)
		local intText
		local fontSize = 18 * leaderboardSettings.store.leaderboardScale
		local intervalLaps = data.drivers[1].lapCount - driver.lapCount

		if driver.position ~= 1 then
			local int = ac.getGapBetweenCars(driver.index, data.drivers[driver.position - 1].index)
			if (intervalLaps > 0 and int > 100) or intervalLaps > 1 then
				intText = string.format("%d Lap", intervalLaps)
			else
				if int < 98 then
					intText = string.format("+%.1f", math.max(int, 0))
					if int < 2 then
						color = COLOR.GREEN
					elseif int > 20 then
						color = COLOR.RED
					end
				else
					intText = " ∞"
					fontSize = 25 * leaderboardSettings.store.leaderboardScale
				end
			end
		else
			intText = ""
			color = COLOR.BLUE
		end

		ui.dwriteTextAligned(
			intText,
			fontSize,
			ui.Alignment.Center,
			ui.Alignment.Center,
			vec2(data.intLenght, 30):scale(leaderboardSettings.store.leaderboardScale),
			false,
			color
		)
		data.posX = data.posX + data.intLenght
	end
end

return int
