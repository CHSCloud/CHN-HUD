local mapSettings = require("src.settings.tabs.mapSettings")
local utils = require("common.utils")
local players = {}

-- Desenha um jogador
--- @param data mapData
--- @param car ac.StateCar -- Cara a ser desenhado
--- @param lenght number -- Tamanho do círculo
--- @param colorInternal rgbm -- Cor do círculo interno
--- @param colorExternal rgbm -- Cor do círculo extero
--- @param center vec2 -- Centro do mapa
--- @param scale number -- Escala do mapa
local function drawPlayer(data, car, lenght, colorInternal, colorExternal, center, scale)
    local posX = (car.position.x - data.trackCenterX) * scale
    local posY = (car.position.z - data.trackCenterY) * scale
    local rotatedPos = utils.rotateVec(vec2(posX, posY), data.angle)
    rotatedPos = center + rotatedPos + data.offset
    ui.drawCircleFilled(rotatedPos, lenght, colorInternal, 20)
    ui.drawCircle(rotatedPos, lenght, colorExternal, 20, lenght / 5)
    ui.setCursor(rotatedPos - vec2(lenght, lenght))
    ui.dwriteTextAligned(tostring(car.racePosition), lenght, ui.Alignment.Center, ui.Alignment.Center,
        vec2(lenght, lenght) * 2, false, colorExternal)
end

-- Desenha todos os jogadores
--- @param data mapData
function players.drawPlayers(data)
    local scale
    local center
    local enemiesLenght
    local focusedCarLenght
    if not mapSettings.store.focus then
        local ratio = (data.baseWindowSize.y * mapSettings.store.mapScale) / data.canvasSize.y
        scale = data.canvasScale * ratio
        center = data.windowCenter
        enemiesLenght = mapSettings.store.enemiesLenght * mapSettings.store.mapScale
        focusedCarLenght = mapSettings.store.focusedCarLenght * mapSettings.store.mapScale
    else
        scale = data.canvasScale
        center = data.canvasCenter
        local ratio = data.canvasSize.y / (data.baseWindowSize.y * mapSettings.store.mapScale)
        enemiesLenght = mapSettings.store.enemiesLenght * ratio * mapSettings.store.mapScale
        focusedCarLenght = mapSettings.store.focusedCarLenght * ratio * mapSettings.store.mapScale
    end
    for _, car in ac.iterateCars.leaderboard() do
        if car.index ~= SIM.focusedCar then
            if car.isInPitlane then
                drawPlayer(data, car, enemiesLenght / 1.5, mapSettings.store.colorEnemies - rgbm(0, 0, 0, 0.2),
                    mapSettings.store.colorExternalEnemies - rgbm(0, 0, 0, 0.2), center, scale)
            else
                drawPlayer(data, car, enemiesLenght, mapSettings.store.colorEnemies,
                    mapSettings.store.colorExternalEnemies, center, scale)
            end
        end
    end
    local car = ac.getCar(SIM.focusedCar)
    if car == nil then return end
    if car.isInPitlane then
        drawPlayer(data, car, focusedCarLenght / 1.5, mapSettings.store.colorFocusedCar - rgbm(0, 0, 0, 0.2),
            mapSettings.store.colorExternalFocusedCar, center, scale)
    else
        drawPlayer(data, car, focusedCarLenght, mapSettings.store.colorFocusedCar,
            mapSettings.store.colorExternalFocusedCar, center, scale)
    end
end

return players
