local window = require("common.window")
local pinCheckBox = require("src.ui.buttons.pinCheckBox")
local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")
local leaderboardData = require("src.data.leaderboard.leaderboardData")

local position = require("src.hud.leaderboard.components.position")
local laps = require("src.hud.leaderboard.components.laps")
local tyres = require("src.hud.leaderboard.components.tyres")
local gap = require("src.hud.leaderboard.components.gap")
local overtaking = require("src.hud.leaderboard.components.overtaking")
local status = require("src.hud.leaderboard.components.status")
local titles = require("src.hud.leaderboard.components.titles")

local leaderboard = {}

---@type leaderboardData
local data = leaderboardData.new()

ac.onSessionStart(function()
    table.clear(data.storedPositions)
end)


-- Atualiza a lista de jogadores
local function updateDrivers()
    table.clear(data.drivers)
    for _, car in ac.iterateCars() do
        table.insert(data.drivers, {
            index = car.index,
            name = string.sub(car:driverName(), 1, 15),
            position = car.racePosition,
            tyre = car:tyresName(),
            lapCount = car.lapCount,
            lastLapTime = car.previousLapTimeMs,
            bestLapTime = car.bestLapTimeMs,
            isConnected = car.isConnected,
            isRetired = car.isRetired,
            isRaceFinished = car.isRaceFinished,
            isInPitlane = car.isInPitlane,
            logoPath = ac.getFolder(ac.FolderID.ContentCars) .. "\\" .. ac.getCarID(car.index) .. "\\ui\\badge.png"
        })
    end
    table.sort(data.drivers, function(a, b) return a.position < b.position end)
end

function leaderboard.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
    leaderboardData.setTitlesLeght(data)
    updateDrivers()

    data.posY = 0
    data.posX = 0
    local numPlayers = 0

    for i, driver in ipairs(data.drivers) do
        if SIM.isSessionStarted then
            if data.storedPositions[driver.index] == nil then
                data.storedPositions[driver.index] = {
                    lastPos = driver.position,
                    currentPos = driver.position,
                    isPositionChanges = false,
                    timeToDraw = -math.huge
                }
            end

            if driver.position ~= data.storedPositions[driver.index].currentPos then
                data.storedPositions[driver.index].currentPos = driver.position
                data.storedPositions[driver.index].isPositionChanges = true
            end
        end

        if i == 1 and leaderboardSettings.store.titlesActive then
            titles.drawTitles(data)
        end

        if i <= leaderboardSettings.store.numDrivers or (leaderboardSettings.store.focusedCarActive and driver.index == SIM.focusedCar) then
            numPlayers = numPlayers + 1

            local color = COLOR.WHITE
            if driver.index == SIM.focusedCar then
                color = COLOR.YELLOW_DARK
            end
            
            local statusColor, statusText
            if not driver.isConnected then
                statusColor = COLOR.WHITE
                statusText = data.statusTexts[1]
            elseif driver.isRetired then
                statusColor = COLOR.RED
                statusText = data.statusTexts[2]
            elseif driver.isRaceFinished then
                statusColor = COLOR.GREEN
                statusText = data.statusTexts[3]
            elseif driver.isInPitlane then
                statusColor = COLOR.RED
                statusText = data.statusTexts[4]
            else
                statusColor = COLOR.WHITE
                statusText = "-"
            end

            data.posX = 0

            position.drawPosition(data, driver.logoPath, numPlayers, driver.position, driver.name,
                vec2(data.posX, data.posY):scale(leaderboardSettings.store.leaderboardScale), color)
            
            for index = 1, 6, 1 do
                if index == leaderboardSettings.store.tyrePos then
                    tyres.drawTyre(data, driver.tyre,
                        vec2(data.posX, data.posY + 2.5):scale(leaderboardSettings.store.leaderboardScale), color)
                elseif index == leaderboardSettings.store.lapCountPos then
                    laps.drawLapCount(data, driver.lapCount,
                        vec2(data.posX, data.posY + 2.5):scale(leaderboardSettings.store.leaderboardScale), color)
                elseif index == leaderboardSettings.store.lastLapPos then
                    laps.drawLastLap(data, driver.lastLapTime,
                        vec2(data.posX, data.posY + 2.5):scale(leaderboardSettings.store.leaderboardScale), color)
                elseif index == leaderboardSettings.store.gapPos then
                    gap.drawGap(data, driver,
                        vec2(data.posX, data.posY + 2.5):scale(leaderboardSettings.store.leaderboardScale), color)
                elseif index == leaderboardSettings.store.overtakeArrowsPos then
                    overtaking.drawOvertaking(data, driver.index,
                        vec2(data.posX, data.posY + 2.5):scale(leaderboardSettings.store.leaderboardScale))
                elseif index == leaderboardSettings.store.statusPos then
                    status.drawDriverStatus(data, statusText, statusColor,
                        vec2(data.posX, data.posY + 2.5):scale(leaderboardSettings.store.leaderboardScale))
                end
            end

            data.posY = data.posY + 35
            data.currentWindowSize = vec2(data.posX, data.posY) * leaderboardSettings.store.leaderboardScale
        end
    end

    window.resize(data.currentWindowSize, "Leaderboard")
    pinCheckBox.main(leaderboardSettings.store.leaderboardScale, "Leaderboard", window.getWindow("Leaderboard"):pinned(),
        data.currentWindowSize)
end

updateDrivers()
table.clear(data.storedPositions)

return leaderboard
