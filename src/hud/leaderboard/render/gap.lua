
local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")

local gap = {}

-- Desenha o gap para o primeiro colocado
---@param data leaderboardData
---@param driver table
---@param pos vec2
---@param color rgbm
function gap.drawGap(data, driver, pos, color)
    
    if leaderboardSettings.store.gapActive then
        ui.setCursor(pos)
        local gap = ac.getGapBetweenCars(driver.index, data.drivers[1].index)
        local gapText
        local fontSize = 18 * leaderboardSettings.store.leaderboardScale
        local intervalLaps = data.drivers[1].lapCount - driver.lapCount

        if driver.position ~= 1 then
            if (intervalLaps > 0 and gap > 100) or intervalLaps > 1 then
                gapText = string.format("%d Lap", intervalLaps)
            else
                if gap < 98 then
                    gapText = string.format("+%.1f", math.max(gap, 0))
                    if gap < 2 then
                        color = COLOR.GREEN
                    elseif gap > 20 then
                        color = COLOR.RED
                    end
                else
                    gapText = " ∞"
                    fontSize = 25 * leaderboardSettings.store.leaderboardScale
                end
            end
        else
            gapText = ""
            color = COLOR.BLUE
        end

        ui.dwriteTextAligned(gapText, fontSize, ui.Alignment.Center, ui.Alignment.Center, vec2(data.gapLenght, 30):scale(leaderboardSettings.store.leaderboardScale), false, color)
        data.posX = data.posX + data.gapLenght
    end
end

return gap