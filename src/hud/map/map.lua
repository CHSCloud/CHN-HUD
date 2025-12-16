local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")
local mapSettings = require("src.settings.tabs.mapSettings")

local map = {}

local minPos = vec2(math.huge, math.huge) -- Posição mínima da pista
local maxPos = vec2(-math.huge, -math.huge) -- Posição máxima da pista
local totalPoints -- Total de pontos do mapa
local mapPoints = {} -- Pontos do mapa
local sectors = {} -- Setores da pista
local drs = {} -- DRS da pista

local canvas = nil
local canvasSize = vec2(600, 600)-- Tamanho do Canvas
local canvasCenter = vec2(canvasSize.x / 2, canvasSize.y / 2)
local canvasScale -- Escala final do mapa
local angle

local padding = 10 -- Limite do mapa
local thickness -- Espessura do traço

-- Tamnho da janela
local currentWindowSize

-- Tamanho da pista
local trackLength
-- Centros da pista
local trackCenterX
local trackCenterY
local isTrackConnected = true

local startTrack -- Inicio da pista
local endTrack -- Fim da pista
local dirTrack -- Direção da pista

local transparancy = 0

local function initMap()
    totalPoints = config.remapInterval(SIM.trackLengthM, 0, 4000, 0, 450)
    -- Armazenando pontos do mapa
    for i = 0, 1, 1 / totalPoints do
        local posWorld = ac.trackCoordinateToWorld(vec3(0, 0, i))
        local posWorld2D = vec2(posWorld.x, posWorld.z)
        table.insert(mapPoints, posWorld2D)

        -- Definindo limites do mapa
        if posWorld2D.x < minPos.x then minPos.x = posWorld2D.x end
        if posWorld2D.y < minPos.y then minPos.y = posWorld2D.y end
        if posWorld2D.x > maxPos.x then maxPos.x = posWorld2D.x end
        if posWorld2D.y > maxPos.y then maxPos.y = posWorld2D.y end
    end

    -- Armazenando sectores
    for i, sector in ipairs(SIM.lapSplits) do
        local left = ac.trackCoordinateToWorld(vec3(-1, 0, sector))
        local center = ac.trackCoordinateToWorld(vec3(0, 0, sector))
        local right = ac.trackCoordinateToWorld(vec3(1, 0, sector))
        table.insert(sectors, {
            left = vec2(left.x, left.z),
            center = vec2(center.x, center.z),
            right = vec2(right.x, right.z)
        })
    end

    -- Armazenando DRS
    local ini = ac.INIConfig.trackData("drs_zones.ini")
    if ini ~= nil then
        local sections = ini['sections']
        for name, data in pairs(sections) do
            local dataStart = data['START']
            local dataFinal = data['END']
            
            local startLeft = ac.trackCoordinateToWorld(vec3(-1, 0, tonumber(dataStart[1])))
            local startCenter = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(dataStart[1])))
            local startRight = ac.trackCoordinateToWorld(vec3(1, 0, tonumber(dataStart[1])))

            local finalLeft = ac.trackCoordinateToWorld(vec3(-1, 0, tonumber(dataFinal[1])))
            local finalCenter = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(dataFinal[1])))
            local finalRight = ac.trackCoordinateToWorld(vec3(1, 0, tonumber(dataFinal[1])))
            if dataStart[1] ~= nil and dataFinal[1] ~= nil then
                table.insert(drs, {
                    startLeft = vec2(startLeft.x, startLeft.z),
                    startCenter = vec2(startCenter.x, startCenter.z),
                    startRight = vec2(startRight.x, startRight.z),

                    finalLeft = vec2(finalLeft.x, finalLeft.z),
                    finalCenter = vec2(finalCenter.x, finalCenter.z),
                    finalRight = vec2(finalRight.x, finalRight.z)
                })
            end
        end
    end

    -- Comprimento da pista
    trackLength = math.distance(minPos, maxPos)
    
    -- Verificando se a pista é conectada:
    startTrack = ac.trackCoordinateToWorld(vec3(0, 0, 0))
    endTrack = ac.trackCoordinateToWorld(vec3(0, 0, 0.99))
    local distance = math.distance(startTrack, endTrack)
    if distance > 60 then 
        isTrackConnected = false
    end
    -- Centros da pista
    trackCenterX = (minPos.x + maxPos.x) / 2
    trackCenterY = (minPos.y + maxPos.y) / 2

    -- Direção da pista
    local dirTrack3d = (endTrack - startTrack):normalize()
    dirTrack = vec2(dirTrack3d.x, dirTrack3d.z)

    
    canvas = ui.ExtraCanvas(canvasSize, 1, render.AntialiasingMode.None)
    canvas:setName("CANVAS")
end

--- @param thickness number -- Espessura do traço
--- @param color rgbm -- Cor do traço
local function drawMap(thickness, color)
    for i, point in ipairs(mapPoints) do
        local offsetX = (point.x - trackCenterX) * canvasScale
        local offsetY = (point.y - trackCenterY) * canvasScale

        local rotatePos = config.rotateVec(vec2(offsetX, offsetY), angle)

        local finalX = canvasCenter.x + rotatePos.x
        local finalY = canvasCenter.y + rotatePos.y
        
        ui.pathLineTo(vec2(finalX, finalY))
    end
    ui.pathStroke(color, isTrackConnected, thickness)
end

--- @param thickness number -- Espessura do setor
--- @param color rgbm -- Cor do setor
local function drawSectors(thickness, color)
    for i, sector in ipairs(sectors) do
        local left = config.rotateVec(vec2((sector.left.x - trackCenterX) * canvasScale, (sector.left.y - trackCenterY) * canvasScale), angle)
        local center = config.rotateVec(vec2((sector.center.x - trackCenterX) * canvasScale, (sector.center.y - trackCenterY) * canvasScale), angle)
        local right = config.rotateVec(vec2((sector.right.x - trackCenterX) * canvasScale, (sector.right.y - trackCenterY) * canvasScale), angle)
        
        local dir = (right - left):normalize()
        local init = center + dir * thickness
        init = init + canvasCenter

        local final = center - dir * thickness
        final = final + canvasCenter
        if i == 1 then
            ui.drawLine(init, final, COLOR.RED, 6)
        else 
            ui.drawLine(init, final, color, 6)
        end
    end
end

--- @param car ac.StateCar -- Cara a ser desenhado
--- @param lenght number -- Tamanho do círculo
--- @param color rgbm -- Cor do círculo
local function drawPLayer(car, lenght, color)
    local posX = (car.position.x - trackCenterX) * canvasScale
    local posY = (car.position.z - trackCenterY) * canvasScale
    local rotatedPos = config.rotateVec(vec2(posX, posY), angle)
    rotatedPos = canvasCenter + rotatedPos
    ui.drawCircleFilled(rotatedPos, lenght / 2, color, 20)
    ui.drawCircle(rotatedPos, lenght / 2, COLOR.BLACK, 20, 5)
    ui.setCursor(rotatedPos - vec2(lenght,lenght)/2)
    ui.dwriteTextAligned(tostring(car.racePosition), 0.6 * lenght, ui.Alignment.Center, ui.Alignment.Center, vec2(lenght, lenght), false, COLOR.BLACK)
end

--- @param lenght number -- Tamanho dos círculos
local function drawPLayers(lenght)
    for i, car in ac.iterateCars.leaderboard() do
        if car.index ~= SIM.focusedCar then
            drawPLayer(car, lenght, mapSettings.store.colorEnemies)
        end
    end
    local car = ac.getCar(SIM.focusedCar)
    if car == nil then return end
    drawPLayer(car, lenght, mapSettings.store.colorPlayer)
end


--- @param thickness number -- Espessura do DRS
local function drawDRS(thickness)
    for i, data in pairs(drs) do
        -- Início
        local left = config.rotateVec(vec2((data.startLeft.x - trackCenterX) * canvasScale, (data.startLeft.y - trackCenterY) * canvasScale), angle)
        local center = config.rotateVec(vec2((data.startCenter.x - trackCenterX) * canvasScale, (data.startCenter.y - trackCenterY) * canvasScale), angle)
        local right = config.rotateVec(vec2((data.startRight.x - trackCenterX) * canvasScale, (data.startRight.y - trackCenterY) * canvasScale), angle)
        
        local dir = (right - left):normalize()
        local init = center + dir * thickness
        init = init + canvasCenter
        local final = center - dir * thickness
        final = final + canvasCenter
        ui.drawLine(init, final, mapSettings.store.colorDRS, 6)

        -- Final
        left = config.rotateVec(vec2((data.finalLeft.x - trackCenterX) * canvasScale, (data.finalLeft.y - trackCenterY) * canvasScale), angle)
        center = config.rotateVec(vec2((data.finalCenter.x - trackCenterX) * canvasScale, (data.finalCenter.y - trackCenterY) * canvasScale), angle)
        right = config.rotateVec(vec2((data.finalRight.x - trackCenterX) * canvasScale, (data.finalRight.y - trackCenterY) * canvasScale), angle)
        
        dir = (right - left):normalize()
        init = center + dir * thickness
        init = init + canvasCenter
        final = center - dir * thickness
        final = final + canvasCenter
        ui.drawLine(init, final, mapSettings.store.colorDRS, 6)
    end
end

function map.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
    currentWindowSize = vec2(300, 300):scale(mapSettings.store.mapScale)
    thickness = 50
    -- Animação do Background
    if config.isMouseInWindow(ui.mouseLocalPos(), 0, ui.windowSize().x, 0, ui.windowSize().y) then
        if transparancy < 0.85 then
            if 20 * Timer % 6 >= 1 then
                transparancy = transparancy + 0.1
            end
        end
        ui.drawRectFilled(vec2(0, 0), currentWindowSize, rgbm(WindowsColor.r,WindowsColor.g,WindowsColor.b, transparancy), 20 * mapSettings.store.mapScale)
    else
        if transparancy > 0 then
            if 20 * Timer % 6 >= 1 then
                transparancy = transparancy - 0.1
            end
             ui.drawRectFilled(vec2(0, 0), currentWindowSize, rgbm(WindowsColor.r,WindowsColor.g,WindowsColor.b, transparancy), 20 * mapSettings.store.mapScale)
        else
            transparancy = 0
        end
    end
    local zoom
    if mapSettings.store.focus then
        trackCenterX = CAR.position.x
        trackCenterY = CAR.position.z
        angle = math.deg(math.atan2(CAR.look.z, -CAR.look.x) + math.pi / 2)
        canvasScale = (canvasSize.y - (padding * 2)) / trackLength
        zoom = 100 * mapSettings.store.mapScale
    else
        trackCenterX = (minPos.x + maxPos.x) / 2
        trackCenterY = (minPos.y + maxPos.y) / 2
        local dirTrackRotated = config.rotateVec(vec2(dirTrack.x, dirTrack.y), mapSettings.store.angle)
        angle = math.deg(math.atan2(dirTrackRotated.x, dirTrackRotated.y) + math.pi / 2)

        canvasScale = (canvasSize.y - (padding * 2)) / trackLength
        zoom = 0
    end

    -- Desenha borda
    if canvas == nil then return end
    canvas:clear()
    canvas:update(function ()
        drawMap((mapSettings.store.trackLenght + mapSettings.store.borderLenght * 2), mapSettings.store.colorBorder)
        -- Desenha pista
        drawMap(mapSettings.store.trackLenght, mapSettings.store.colorTrack)
        -- Desenha DRS
        drawDRS(mapSettings.store.trackLenght / 1.8)
        -- Desenha setores
        drawSectors(mapSettings.store.trackLenght / 1.8, mapSettings.store.colorSectors)
        -- Desenha jogadores
        drawPLayers(thickness)
    end)
    
    ui.drawImage(canvas, -zoom, currentWindowSize.x + zoom)
    config.resize(currentWindowSize, "Map")
    pinCheckBox.main(mapSettings.store.mapScale * 1.5, "Map", config.getWindow("Map"):pinned(), currentWindowSize)
end

initMap()

return map