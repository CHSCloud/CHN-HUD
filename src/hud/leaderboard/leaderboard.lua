local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")
local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")

local leaderboard = {}

local players = {}
local currentWindowSize = vec2(500, 500):scale(leaderboardSettings.store.leaderboardScale)

-- Desenha posições
---@param index number
---@param carPosition number
---@param playerName string
---@param pos vec2
local function drawPosition(index, carPosition, playerName, pos)
    local color = COLOR.WHITE
    if index == SIM.focusedCar then
        color = COLOR.YELLOW
    end

    local backgroundColor
    if carPosition % 2 == 1 then
        backgroundColor = WindowsColor
    else
        backgroundColor = COLOR.GRAY_BG
    end
    ui.drawRectFilled(pos - vec2(0,2.5):scale(leaderboardSettings.store.leaderboardScale), pos + vec2(currentWindowSize.x, 32.5 * leaderboardSettings.store.leaderboardScale), backgroundColor)

    -- Desenha posição do jogador
    ui.drawRectFilled(pos + vec2(5):scale(leaderboardSettings.store.leaderboardScale), pos + vec2(35, 30):scale(leaderboardSettings.store.leaderboardScale), color, 5 * leaderboardSettings.store.leaderboardScale)
    ui.setCursor(pos + vec2(5):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned(tostring(carPosition), 20 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(30,30):scale(leaderboardSettings.store.leaderboardScale), false, COLOR.BLACK)

    -- Desenha nome do jogador
    ui.setCursor(pos + vec2(40):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned(playerName, 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Start, ui.Alignment.Center, vec2(200,30):scale(leaderboardSettings.store.leaderboardScale), false, color)
    
    --ui.drawLine(vec2(10 * leaderboardSettings.store.leaderboardScale, pos.y + 32.5 * leaderboardSettings.store.leaderboardScale), vec2(currentWindowSize.x - 10 * leaderboardSettings.store.leaderboardScale, pos.y + 35 * leaderboardSettings.store.leaderboardScale), COLOR.WHITE, 1 * leaderboardSettings.store.leaderboardScale)
end

-- Desenha tipo de pneu
---@param tyreName string
---@param pos vec2
local function drawTyre(tyreName, pos)
    ui.setCursor(pos)
    ui.dwriteTextAligned(tyreName, 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(30,30):scale(leaderboardSettings.store.leaderboardScale), false, COLOR.WHITE)
end

-- Desenha contagem de voltas
---@param lap number
---@param pos vec2
local function drawLapCount(lap, pos)
    ui.setCursor(pos)
    ui.dwriteTextAligned(tostring(lap + 1), 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment.Center, vec2(30,30):scale(leaderboardSettings.store.leaderboardScale), false, COLOR.WHITE)
end

-- Desenha tempo da última volta
---@param time number
---@param pos vec2
local function drawLastLap(time, pos)
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
    ui.dwriteTextAligned(lastLapText, 20 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Start, ui.Alignment.Center, vec2(100, 30):scale(leaderboardSettings.store.leaderboardScale), false, COLOR.WHITE)
end

-- Atualiza a lista de jogadores
local function updatePlayers()
    table.clear(players)
    for _, car in ac.iterateCars() do
        table.insert(players, {
            index = car.index,
            name = string.sub(car:driverName(),1, 15),
            position = car.racePosition,
            tyre = car:tyresName(),
            lapCount = car.lapCount,
            lastLapTime = car.previousLapTimeMs,
            bestLapTime = car.bestLapTimeMs
        })
    end
    table.sort(players, function(a, b) return a.position < b.position end)
end

function leaderboard.windowMain()
    updatePlayers()
    currentWindowSize = vec2(500, 500):scale(leaderboardSettings.store.leaderboardScale)
    
    --ui.drawRectFilled(vec2(0,0), currentWindowSize, WindowsColor, 15 * leaderboardSettings.store.leaderboardScale)

    local posY = 40
    local posX = 0
    for _, player in ipairs(players) do
        posX = 0
        drawPosition(player.index, player.position, player.name, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale))
        posX = posX + 230
        
        if true then
            drawTyre(player.tyre, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale))
            posX = posX + 50
        end

        if true then
            drawLapCount(player.lapCount, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale))
            posX = posX + 50
        end

        if true then
            drawLastLap(player.lastLapTime, vec2(posX, posY):scale(leaderboardSettings.store.leaderboardScale))
            posX = posX + 50
        end

        posY = posY + 35
    end

    config.resize(currentWindowSize, "Leaderboard")
    pinCheckBox.main(leaderboardSettings.store.leaderboardScale, "Leaderboard", config.getWindow("Leaderboard"):pinned(), currentWindowSize)
end

return leaderboard