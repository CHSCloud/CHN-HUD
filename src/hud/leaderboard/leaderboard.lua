local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")
local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")

local leaderboard = {}

local drivers = {}
local storedPositions = {}
local currentWindowSize = vec2()
local statusTexts = {
    "OFF",
    "RETIRED",
    "FINISHED",
    "IN PIT"
}
local posY = 2.5
local posX = 0

local positionLenght = 260
local tyreLenght = 50
local lapCountLenght = 50
local lastLapLenght = 100
local gapLenght = 80
local statusLenght = 0
local overtakingLenght = 70


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
    ui.drawRectFilled(pos + vec2(10):scale(leaderboardSettings.store.leaderboardScale), pos + vec2(40, 30):scale(leaderboardSettings.store.leaderboardScale), color, 5 * leaderboardSettings.store.leaderboardScale)
    ui.setCursor(pos + vec2(10):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned(tostring(carPosition), 20 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(30,30):scale(leaderboardSettings.store.leaderboardScale), false, COLOR.BLACK)

    ui.setCursor(pos + vec2(50,2):scale(leaderboardSettings.store.leaderboardScale))
    ui.image(logoPath, vec2(28,28):scale(leaderboardSettings.store.leaderboardScale) , ui.ImageFit.Fill)

    -- Desenha nome do jogador
    ui.setCursor(pos + vec2(90):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned(driverName, 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Start, ui.Alignment.Center, vec2(200,30):scale(leaderboardSettings.store.leaderboardScale), false, color)
    posX = posX + positionLenght
end

-- Desenha tipo de pneu
---@param tyreName string
---@param pos vec2
local function drawTyre(tyreName, pos, color)
    if leaderboardSettings.store.tyreActive then
        ui.setCursor(pos)
        ui.dwriteTextAligned(tyreName, 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(tyreLenght, 30):scale(leaderboardSettings.store.leaderboardScale), false, color)
        posX = posX + tyreLenght
    end
end

-- Desenha contagem de voltas
---@param lap number
---@param pos vec2
local function drawLapCount(lap, pos, color)
    if leaderboardSettings.store.lapCountActive then
        ui.setCursor(pos)
        ui.dwriteTextAligned(tostring(lap + 1), 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(lapCountLenght, 30):scale(leaderboardSettings.store.leaderboardScale), false, color)
        posX = posX + lapCountLenght
    end
end

-- Desenha tempo da última volta
---@param time number
---@param pos vec2
local function drawLastLap(time, pos, color)
    if leaderboardSettings.store.lastLapActive then
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
        ui.dwriteTextAligned(lastLapText, 20 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(lastLapLenght, 30):scale(leaderboardSettings.store.leaderboardScale), false, color)
        posX = posX + lastLapLenght
    end
end

-- Desenha o gap para o primeiro colocado
---@param driver table
---@param pos vec2
---@param color rgbm
local function drawGap(driver, pos, color)
    
    if leaderboardSettings.store.gapActive then
        ui.setCursor(pos)
        local gap = ac.getGapBetweenCars(driver.index, drivers[1].index)
        local gapText
        local horizontalAligment = ui.Alignment.Start
        local fontSize = 18 * leaderboardSettings.store.leaderboardScale
        local intervalLaps = drivers[1].lapCount - driver.lapCount

        if driver.position ~= 1 then
            if intervalLaps > 0 then
                gapText = string.format("%d Lap", intervalLaps)
            else
                if gap < 98 then
                    gapText = string.format("+%.2f", math.max(gap, 0))
                    horizontalAligment = ui.Alignment.Start
                    if gap < 2 then
                        color = COLOR.GREEN
                    elseif gap > 20 then
                        color = COLOR.RED
                    end
                else
                    gapText = "  ∞"
                    horizontalAligment = ui.Alignment.Start
                    fontSize = 25 * leaderboardSettings.store.leaderboardScale
                end
            end
        else
            gapText = ""
            color = COLOR.BLUE
            horizontalAligment = ui.Alignment.Start
        end

        ui.dwriteTextAligned(gapText, fontSize, ui.Alignment.Center, ui.Alignment.Center, vec2(gapLenght, 30):scale(leaderboardSettings.store.leaderboardScale), false, color)
        posX = posX + gapLenght
    end
end

---@param statusText string
---@param statusColor rgbm
---@param pos vec2
local function drawDriverStatus(statusText, statusColor, pos)
    if leaderboardSettings.store.statusActive then
        statusLenght = config.findLenghtLongestString(statusTexts, 18).x + 60
        ui.setCursor(pos)
        ui.dwriteTextAligned(statusText, 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(statusLenght,30):scale(leaderboardSettings.store.leaderboardScale), false, statusColor)
        posX = posX + statusLenght
    end
end

-- Desenha setas de ultrapassagem
---@param driverIndex number
---@param pos vec2
local function drawOvertaking(driverIndex, pos)
    if leaderboardSettings.store.overtakeArrowsActive then
        local overtakingText
        local space = vec2(0,0)
        local color = COLOR.WHITE
        if storedPositions[driverIndex] ~= nil then
            if storedPositions[driverIndex].isPositionChanges then
                storedPositions[driverIndex].timeToDraw = SIM.currentSessionTime + 30000
            end

            if SIM.currentSessionTime <= storedPositions[driverIndex].timeToDraw then
                local diff = storedPositions[driverIndex].lastPos - storedPositions[driverIndex].currentPos
                if diff ~= 0 then
                    overtakingText = tostring(math.abs(diff))
                    space = vec2(15):scale(leaderboardSettings.store.leaderboardScale)
                    local rotation
                    if diff > 0 then
                        color = COLOR.GREEN
                        rotation = 180
                    else
                        color = COLOR.RED
                        rotation = 0
                    end
                    ui.beginRotation()
                    ui.drawImage("assets/arrow.png", pos + vec2(15,5):scale(leaderboardSettings.store.leaderboardScale), pos + vec2(40, 25):scale(leaderboardSettings.store.leaderboardScale), color)
                    ui.endRotation(rotation)
                else   
                    overtakingText = "-"
                end

            else
                if SIM.currentSessionTime > storedPositions[driverIndex].timeToDraw + 30000 then
                    storedPositions[driverIndex].lastPos = storedPositions[driverIndex].currentPos
                end
                overtakingText = "-"
            end
            storedPositions[driverIndex].isPositionChanges = false
        else
            overtakingText = "-"
        end
        ui.setCursor(pos + space)
        ui.dwriteTextAligned(overtakingText, 20 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(overtakingLenght,30):scale(leaderboardSettings.store.leaderboardScale), false, color)
        
        posX = posX + overtakingLenght
    end
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
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
    updateDrivers()

    posY = 0
    posX = 0
    local numPlayers = 0
    ui.drawRectFilled(vec2(0, 0), vec2(currentWindowSize.x, 35 * leaderboardSettings.store.leaderboardScale), COLOR.WHITE, 5 * leaderboardSettings.store.leaderboardScale, ui.CornerFlags.Top)

    for i, driver in ipairs(drivers) do
        if SIM.isSessionStarted then
            if storedPositions[driver.index] == nil then
                storedPositions[driver.index] = {
                    lastPos = driver.position,
                    currentPos = driver.position,
                    isPositionChanges = false,
                    timeToDraw = -math.huge
                }
            end

            if driver.position ~= storedPositions[driver.index].currentPos then
                storedPositions[driver.index].currentPos = driver.position
                storedPositions[driver.index].isPositionChanges = true
            end
        end
        if i == 1 then
            local color = COLOR.BLACK
            posX = positionLenght
            posY = 35
            ui.setCursor(vec2(7, 0):scale(leaderboardSettings.store.leaderboardScale))
            ui.dwriteTextAligned("Pos", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(35, posY):scale(leaderboardSettings.store.leaderboardScale), false, color)
            
            ui.setCursor(vec2(90, 0):scale(leaderboardSettings.store.leaderboardScale))
            ui.dwriteTextAligned("Driver name", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Start, ui.Alignment.Center, vec2(200, posY):scale(leaderboardSettings.store.leaderboardScale), false, color)

            for index = 1, 6, 1 do
                if index == leaderboardSettings.store.tyrePos and leaderboardSettings.store.tyreActive then
                    ui.setCursor(vec2(posX, 0):scale(leaderboardSettings.store.leaderboardScale))
                    ui.dwriteTextAligned("Tyre", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(tyreLenght, posY):scale(leaderboardSettings.store.leaderboardScale), false, color)
                    posX = posX + tyreLenght

                elseif index == leaderboardSettings.store.lapCountPos and leaderboardSettings.store.lapCountActive then
                    ui.setCursor(vec2(posX, 0):scale(leaderboardSettings.store.leaderboardScale))
                    ui.dwriteTextAligned("Lap", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(lapCountLenght, posY):scale(leaderboardSettings.store.leaderboardScale), false, color)
                    posX = posX + lapCountLenght

                elseif index == leaderboardSettings.store.lastLapPos and leaderboardSettings.store.lastLapActive then
                    ui.setCursor(vec2(posX, 0):scale(leaderboardSettings.store.leaderboardScale))
                    ui.dwriteTextAligned("Last", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(lastLapLenght, posY):scale(leaderboardSettings.store.leaderboardScale), false, color)
                    posX = posX + lastLapLenght

                elseif index == leaderboardSettings.store.gapPos and leaderboardSettings.store.gapPos then
                    ui.setCursor(vec2(posX, 0):scale(leaderboardSettings.store.leaderboardScale))
                    ui.dwriteTextAligned("Gap", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(gapLenght, posY):scale(leaderboardSettings.store.leaderboardScale), false, color)
                    posX = posX + gapLenght

                elseif index == leaderboardSettings.store.overtakeArrowsPos and leaderboardSettings.store.overtakeArrowsActive then
                    posX = posX + overtakingLenght
                    
                elseif index == leaderboardSettings.store.statusPos and leaderboardSettings.store.statusActive then
                    ui.setCursor(vec2(posX, 0):scale(leaderboardSettings.store.leaderboardScale))
                    ui.dwriteTextAligned("Status", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(statusLenght, posY):scale(leaderboardSettings.store.leaderboardScale), false, color)
                    posX = posX + statusLenght
                end
            end
        end

        if i <= leaderboardSettings.store.numDrivers or (leaderboardSettings.store.focusedCarActive and driver.index == SIM.focusedCar) then
            numPlayers = numPlayers + 1
            local color = COLOR.WHITE
            local statusColor, statusText
            if driver.index == SIM.focusedCar then
                color = COLOR.YELLOW_DARK
            end

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

            for index = 1, 6, 1 do
                if index == leaderboardSettings.store.tyrePos then
                    drawTyre(driver.tyre, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale), color)
                elseif index == leaderboardSettings.store.lapCountPos then
                    drawLapCount(driver.lapCount, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale), color)
                elseif index == leaderboardSettings.store.lastLapPos then
                    drawLastLap(driver.lastLapTime, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale),color)
                elseif index == leaderboardSettings.store.gapPos then
                    drawGap(driver, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale), color)
                elseif index == leaderboardSettings.store.overtakeArrowsPos then
                    drawOvertaking(driver.index, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale))
                elseif index == leaderboardSettings.store.statusPos then
                    drawDriverStatus(statusText, statusColor, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale))
                end
            end

            posY = posY + 35
            currentWindowSize = vec2(posX, posY) * leaderboardSettings.store.leaderboardScale
        end
    end

    config.resize(currentWindowSize, "Leaderboard")
    pinCheckBox.main(leaderboardSettings.store.leaderboardScale, "Leaderboard", config.getWindow("Leaderboard"):pinned(), currentWindowSize)
end

updateDrivers()
table.clear(storedPositions)

return leaderboard