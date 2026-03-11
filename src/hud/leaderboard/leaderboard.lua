local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")
local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")

local leaderboard = {}

local drivers = {}
local currentWindowSize = vec2()

-- Desenha posições
---@param driverDrawNumber number
---@param carPosition number
---@param driverName string
---@param pos vec2
---@param color rgbm
local function drawPosition(logoPath, driverDrawNumber, carPosition, driverName, pos, color)
    local backgroundColor
    if driverDrawNumber % 2 == 1 then
        backgroundColor = WindowsColor
    else
        backgroundColor = COLOR.GRAY_BG
    end
    ui.drawRectFilled(pos - vec2(0,2.5):scale(leaderboardSettings.store.leaderboardScale), pos + vec2(currentWindowSize.x, 32.5 * leaderboardSettings.store.leaderboardScale), backgroundColor)

    -- Desenha posição do jogador
    ui.drawRectFilled(pos + vec2(5):scale(leaderboardSettings.store.leaderboardScale), pos + vec2(35, 30):scale(leaderboardSettings.store.leaderboardScale), color, 5 * leaderboardSettings.store.leaderboardScale)
    ui.setCursor(pos + vec2(5):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned(tostring(carPosition), 20 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(30,30):scale(leaderboardSettings.store.leaderboardScale), false, COLOR.BLACK)

    ui.setCursor(pos + vec2(40,2):scale(leaderboardSettings.store.leaderboardScale))
    ui.image(logoPath, vec2(28,28):scale(leaderboardSettings.store.leaderboardScale) , ui.ImageFit.Fill)

    -- Desenha nome do jogador
    ui.setCursor(pos + vec2(80):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned(driverName, 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Start, ui.Alignment.Center, vec2(200,30):scale(leaderboardSettings.store.leaderboardScale), false, color)
    
    --ui.drawLine(vec2(10 * leaderboardSettings.store.leaderboardScale, pos.y + 32.5 * leaderboardSettings.store.leaderboardScale), vec2(currentWindowSize.x - 10 * leaderboardSettings.store.leaderboardScale, pos.y + 35 * leaderboardSettings.store.leaderboardScale), COLOR.WHITE, 1 * leaderboardSettings.store.leaderboardScale)
end

-- Desenha tipo de pneu
---@param tyreName string
---@param pos vec2
local function drawTyre(tyreName, pos, color)
    ui.setCursor(pos)
    ui.dwriteTextAligned(tyreName, 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(30,30):scale(leaderboardSettings.store.leaderboardScale), false, color)
end

-- Desenha contagem de voltas
---@param lap number
---@param pos vec2
local function drawLapCount(lap, pos, color)
    ui.setCursor(pos)
    ui.dwriteTextAligned(tostring(lap + 1), 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(30,30):scale(leaderboardSettings.store.leaderboardScale), false, color)
end

-- Desenha tempo da última volta
---@param time number
---@param pos vec2
local function drawLastLap(time, pos, color)
    local lastLapText
    if time == 0 then
        lastLapText = "-:--.---"
    else
        local minutes = time / 60E3
        local seconds = (minutes %1) * 60
        local milliseconds = math.round((seconds % 1) * 1000)
        lastLapText = string.format("%d:%02d.%03d", minutes, seconds, milliseconds)
    end
    ui.setCursor(pos)
    ui.dwriteTextAligned(lastLapText, 20 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Start, ui.Alignment.Center, vec2(100, 30):scale(leaderboardSettings.store.leaderboardScale), false, color)
end

local function drawGap(driver, pos, color)
    ui.setCursor(pos)
    local gap = ac.getGapBetweenCars(driver.index, drivers[1].index)
    local gapText
    local horizontalAligment = ui.Alignment.Start

    local intervalLaps = drivers[1].lapCount - driver.lapCount

    if intervalLaps > 0 then
        gapText = string.format("%dL", intervalLaps)
    else 
        if gap < 200 then
            gapText = string.format("%.2f", math.max(gap, 0))
            horizontalAligment = ui.Alignment.Start
        else
            gapText = "---.--"
            horizontalAligment = ui.Alignment.Start
        end
    end
    ui.dwriteTextAligned(gapText, 18 * leaderboardSettings.store.leaderboardScale, horizontalAligment, ui.Alignment.Center, vec2(80, 30):scale(leaderboardSettings.store.leaderboardScale), false, color)  
    
end

---@param statusText string
---@param statusColor rgbm
---@param pos vec2
local function drawDriverStatus(statusText, statusColor, statusLenght, pos)
    ui.setCursor(pos)
    ui.dwriteTextAligned(statusText, 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(statusLenght,30):scale(leaderboardSettings.store.leaderboardScale), false, statusColor)
end

-- Atualiza a lista de jogadores
local function updateDrivers()
    table.clear(drivers)
    for _, car in ac.iterateCars() do
        table.insert(drivers, {
            index = car.index,
            name = string.sub(car:driverName(),1, 15),
            position = car.racePosition,
            tyre = car:tyresName(),
            lapCount = car.lapCount,
            lastLapTime = car.previousLapTimeMs,
            bestLapTime = car.bestLapTimeMs,
            isConnected = car.isConnected,
            isRetired = car.isRetired,
            isRaceFinished = car.isRaceFinished,
            isInPitlane = car.isInPitlane,
            logoPath = ac.getFolder(ac.FolderID.ContentCars) .. "\\".. ac.getCarID(car.index) .. "\\ui\\badge.png"
        })
    end
    table.sort(drivers, function(a, b) return a.position < b.position end)
end

function leaderboard.windowMain()
    updateDrivers()

    local posY = 2.5
    local posX = 0
    local numPlayers = 0
    for i, driver in ipairs(drivers) do
        if i <= leaderboardSettings.store.numDrivers or (leaderboardSettings.store.focusedCarActive and driver.index == SIM.focusedCar) then
            numPlayers = numPlayers + 1
            local color = COLOR.WHITE
            local statusColor, statusText
            if driver.index == SIM.focusedCar then
                color = COLOR.YELLOW_DARK
            end

            local statusTexts = {
                "OFF",
                "RETIRED",
                "FINISHED",
                "IN PIT"
            }

            if not driver.isConnected then
                statusColor = COLOR.WHITE
                statusText = statusTexts[1]
            elseif driver.isRetired then
                statusColor = COLOR.RED
                statusText = statusTexts[2]
            elseif driver.isRaceFinished then
                statusColor = COLOR.GREEN
                statusText = statusTexts[3]
            elseif driver.isInPitlane then
                statusColor = COLOR.RED
                statusText = statusTexts[4]
            else
                statusColor = COLOR.WHITE
                statusText = "-"
            end

            posX = 0
            drawPosition(driver.logoPath, numPlayers, driver.position, driver.name, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale), color)
            posX = posX + 260
            
            if leaderboardSettings.store.tyreActive then
                drawTyre(driver.tyre, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale), color)
                posX = posX + 50
            end

            if leaderboardSettings.store.lapCountActive then
                drawLapCount(driver.lapCount, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale), color)
                posX = posX + 50
            end

            if leaderboardSettings.store.lastLapActive then
                drawLastLap(driver.lastLapTime, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale),color)
                posX = posX + 110
            end

            if true then
                drawGap(driver, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale), color)
                posX = posX + 50
            end

            if leaderboardSettings.store.statusActive then
                local statusLenght = config.findLenghtLongestString(statusTexts, 18).x + 20
                drawDriverStatus(statusText, statusColor, statusLenght, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale))
                posX = posX + statusLenght
            end

            posY = posY + 35

            currentWindowSize = vec2(posX, posY) * leaderboardSettings.store.leaderboardScale
        end
    end

    config.resize(currentWindowSize, "Leaderboard")
    pinCheckBox.main(leaderboardSettings.store.leaderboardScale, "Leaderboard", config.getWindow("Leaderboard"):pinned(), currentWindowSize)
end

return leaderboard