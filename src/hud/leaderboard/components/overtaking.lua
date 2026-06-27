local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")
local overtaking = {}

-- Desenha setas de ultrapassagem
---@param data leaderboardData
---@param driverIndex number
---@param pos vec2
function overtaking.drawOvertaking(data, driverIndex, pos)
    if leaderboardSettings.store.overtakeArrowsActive then
        local overtakingText
        local space = vec2(0, 0)
        local color = COLOR.WHITE
        if data.storedPositions[driverIndex] ~= nil then
            if data.storedPositions[driverIndex].isPositionChanges then
                data.storedPositions[driverIndex].timeToDraw = SIM.currentSessionTime + 30000
            end

            if SIM.currentSessionTime <= data.storedPositions[driverIndex].timeToDraw then
                local diff = data.storedPositions[driverIndex].lastPos - data.storedPositions[driverIndex].currentPos
                if diff ~= 0 then
                    overtakingText = tostring(math.abs(diff))
                    space = vec2(15):scale(leaderboardSettings.store.leaderboardScale)
                    local rotation
                    if diff > 0 then
                        color = COLOR.GREEN
                        rotation = -180
                    else
                        color = COLOR.RED
                        rotation = 0
                    end
                    ui.beginRotation()
                    ui.drawImage("assets/leaderboard/arrow.png",
                        pos + vec2(14, 6):scale(leaderboardSettings.store.leaderboardScale),
                        pos + vec2(28, 27):scale(leaderboardSettings.store.leaderboardScale), color)
                    ui.endRotation(rotation)
                else
                    overtakingText = "-"
                end
            else
                if SIM.currentSessionTime > data.storedPositions[driverIndex].timeToDraw + 30000 then
                    data.storedPositions[driverIndex].lastPos = data.storedPositions[driverIndex].currentPos
                end
                overtakingText = "-"
            end
            data.storedPositions[driverIndex].isPositionChanges = false
        else
            overtakingText = "-"
        end
        ui.setCursor(pos + space)
        ui.dwriteTextAligned(overtakingText, 20 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center,
            ui.Alignment.Center, vec2(data.overtakingLenght, 30):scale(leaderboardSettings.store.leaderboardScale), false,
            color)

        data.posX = data.posX + data.overtakingLenght
    end
end

return overtaking
