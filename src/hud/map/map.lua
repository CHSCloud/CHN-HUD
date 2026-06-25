local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")
local mapSettings = require("src.settings.tabs.mapSettings")
local mapData = require("src.data.map.mapData")

local map = {}
---@type mapData
local data = mapData.new()

-- Inicializa todos os parâmetros do mapa
local function initMap()
    -- Calculando todos os pontos do mapa
    data.totalPoints = config.remapInterval(SIM.trackLengthM, 0, 4000, 0, 500)

    -- Armazenando pontos do mapa
    for i = 0, 1, 1 / data.totalPoints do
        local posWorld = ac.trackCoordinateToWorld(vec3(0, 0, i))
        local posWorld2D = vec2(posWorld.x, posWorld.z)
        table.insert(data.mapPoints, posWorld2D)

        -- Definindo limites do mapa
        if posWorld2D.x < data.minPos.x then data.minPos.x = posWorld2D.x end
        if posWorld2D.y < data.minPos.y then data.minPos.y = posWorld2D.y end
        if posWorld2D.x > data.maxPos.x then data.maxPos.x = posWorld2D.x end
        if posWorld2D.y > data.maxPos.y then data.maxPos.y = posWorld2D.y end
    end

    -- Armazenando sectores
    for i, sector in ipairs(SIM.lapSplits) do
        local left = ac.trackCoordinateToWorld(vec3(-1, 0, sector))
        local center = ac.trackCoordinateToWorld(vec3(0, 0, sector))
        local right = ac.trackCoordinateToWorld(vec3(1, 0, sector))
        table.insert(data.sectors, {
            left = vec2(left.x, left.z),
            center = vec2(center.x, center.z),
            right = vec2(right.x, right.z)
        })
    end

    -- Armazenando DRS
    local drsINI = ac.INIConfig.trackData("drs_zones.ini")
    if drsINI ~= nil then
        for name, sectionData in pairs(drsINI['sections']) do
            local dataStart = sectionData['START']
            local dataFinal = sectionData['END']
            
            local startLeft = ac.trackCoordinateToWorld(vec3(-1, 0, tonumber(dataStart[1])))
            local startCenter = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(dataStart[1])))
            local startRight = ac.trackCoordinateToWorld(vec3(1, 0, tonumber(dataStart[1])))

            local finalLeft = ac.trackCoordinateToWorld(vec3(-1, 0, tonumber(dataFinal[1])))
            local finalCenter = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(dataFinal[1])))
            local finalRight = ac.trackCoordinateToWorld(vec3(1, 0, tonumber(dataFinal[1])))
            if dataStart[1] ~= nil and dataFinal[1] ~= nil then
                table.insert(data.drs, {
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

    -- Verificando sentido da pista
    local sum = 0
    for i = 1, data.totalPoints do
        local currentPoint = ac.trackCoordinateToWorld(vec3(0, 0, i / data.totalPoints))
        local nextPoint = ac.trackCoordinateToWorld(vec3(0, 0, ((i + 1) % data.totalPoints) / data.totalPoints))
        sum = sum + (currentPoint.x * nextPoint.z - nextPoint.x * currentPoint.z)
    end
    if sum > 0 then 
        mapSettings.isClockwise = true
    end

    -- Carregando seções do mapa
    data.trackSections = mapSettings.loadSectionsINI()

    -- Comprimento da pista
    data.trackLength = math.distance(data.minPos, data.maxPos)
    
    -- Verificando se a pista é conectada:
    data.startTrack = ac.trackCoordinateToWorld(vec3(0, 0, 0))
    data.endTrack = ac.trackCoordinateToWorld(vec3(0, 0, 0.01))
    local distance = math.distance(data.startTrack, data.endTrack)
    if distance > 60 then 
        data.isTrackConnected = false
    end
    
    -- Centros da pista
    data.trackCenterX = (data.minPos.x + data.maxPos.x) / 2
    data.trackCenterY = (data.minPos.y + data.maxPos.y) / 2

    -- Direção da pista
    local dirTrack3d = (data.endTrack - data.startTrack):normalize()
    data.dirTrack = vec2(dirTrack3d.x, dirTrack3d.z)

    -- Canvas normal
    data.canvas = ui.ExtraCanvas(data.canvasSize, 1, render.AntialiasingMode.None)
    data.canvas:setName("CANVAS")

    -- Canvas de zoom
    data.canvasZoom = ui.ExtraCanvas(data.canvasSize, 1, render.AntialiasingMode.None)
    data.canvasZoom:setName("CANVAS_ZOOM")
end

-- Desenha o mapa
--- @param thickness number -- Espessura do traço
--- @param color rgbm -- Cor do traço
local function drawMap(thickness, color)
    for i, point in ipairs(data.mapPoints) do
        local offsetX = (point.x - data.trackCenterX) * data.canvasScale
        local offsetY = (point.y - data.trackCenterY) * data.canvasScale

        local rotatePos = config.rotateVec(vec2(offsetX, offsetY), data.angle)

        local finalX = data.canvasCenter.x + rotatePos.x
        local finalY = data.canvasCenter.y + rotatePos.y
        
        ui.pathLineTo(vec2(finalX, finalY))
    end
    ui.pathStroke(color, data.isTrackConnected, thickness)
end

-- Desenha setores
--- @param thickness number -- Espessura do setor
--- @param color rgbm -- Cor do setor
local function drawSectors(thickness, color)
    for i, sector in ipairs(data.sectors) do
        if i > 1 then
            -- Posição do setor
            local left = config.rotateVec(vec2((sector.left.x - data.trackCenterX) * data.canvasScale, (sector.left.y - data.trackCenterY) * data.canvasScale), data.angle)
            local center = config.rotateVec(vec2((sector.center.x - data.trackCenterX) * data.canvasScale, (sector.center.y - data.trackCenterY) * data.canvasScale), data.angle)
            local right = config.rotateVec(vec2((sector.right.x - data.trackCenterX) * data.canvasScale, (sector.right.y - data.trackCenterY) * data.canvasScale), data.angle)
            
            -- Direção do setor
            local dir = (right - left):normalize()
            ui.drawLine(center + dir * thickness + data.canvasCenter, center - dir * thickness + data.canvasCenter, color, 6)
        end
    end
end

-- Desenha a bandeira de largada
--- @param thickness number -- Espessura da bandeira
local function drawStartFlag(thickness) 
    -- Posição do setor
    local left = config.rotateVec(vec2((data.sectors[1].left.x - data.trackCenterX) * data.canvasScale, (data.sectors[1].left.y - data.trackCenterY) * data.canvasScale), data.angle)
    local center = config.rotateVec(vec2((data.sectors[1].center.x - data.trackCenterX) * data.canvasScale, (data.sectors[1].center.y - data.trackCenterY) * data.canvasScale), data.angle)
    local right = config.rotateVec(vec2((data.sectors[1].right.x - data.trackCenterX) * data.canvasScale, (data.sectors[1].right.y - data.trackCenterY) * data.canvasScale), data.angle)
    
    -- Direção do setor
    local dir = (right - left):normalize()
    local init = center + dir * thickness + data.canvasCenter
    local final = center - dir * thickness + data.canvasCenter
    local flagLenght = config.rotateVec(data.dirTrack * thickness / 2, data.angle)
    ui.drawImageQuad("assets/checkered.png", init + flagLenght, final + flagLenght, final - flagLenght, init - flagLenght)

end

-- Desenha um jogador
--- @param car ac.StateCar -- Cara a ser desenhado
--- @param lenght number -- Tamanho do círculo
--- @param colorInternal rgbm -- Cor do círculo interno
--- @param colorExternal rgbm -- Cor do círculo extero
--- @param center vec2 -- Centro do mapa
--- @param scale number -- Escala do mapa
local function drawPLayer(car, lenght, colorInternal, colorExternal, center, scale)
    local posX = (car.position.x - data.trackCenterX) * scale
    local posY = (car.position.z - data.trackCenterY) * scale
    local rotatedPos = config.rotateVec(vec2(posX, posY), data.angle)
    rotatedPos = center + rotatedPos + data.offset
    ui.drawCircleFilled(rotatedPos, lenght, colorInternal, 20)
    ui.drawCircle(rotatedPos, lenght, colorExternal, 20, lenght / 5)
    ui.setCursor(rotatedPos - vec2(lenght,lenght))
    ui.dwriteTextAligned(tostring(car.racePosition), lenght, ui.Alignment.Center, ui.Alignment.Center, vec2(lenght, lenght) * 2, false, colorExternal)
end

-- Desenha todos os jogadores
local function drawPlayers()
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
    for i, car in ac.iterateCars.leaderboard() do
        if car.index ~= SIM.focusedCar then
            if car.isInPitlane then
                drawPLayer(car, enemiesLenght / 1.5, mapSettings.store.colorEnemies - rgbm(0, 0, 0, 0.2),mapSettings.store.colorExternalEnemies - rgbm(0, 0, 0, 0.2), center, scale)
                
            else 
                drawPLayer(car, enemiesLenght, mapSettings.store.colorEnemies, mapSettings.store.colorExternalEnemies, center, scale)
            end
        end
    end
    local car = ac.getCar(SIM.focusedCar)
    if car == nil then return end
    if car.isInPitlane then
        drawPLayer(car, focusedCarLenght / 1.5, mapSettings.store.colorFocusedCar - rgbm(0, 0, 0, 0.2), mapSettings.store.colorExternalFocusedCar, center, scale)
    else 
        drawPLayer(car, focusedCarLenght, mapSettings.store.colorFocusedCar, mapSettings.store.colorExternalFocusedCar, center, scale)
    end
end

-- Desenha DRS
--- @param thickness number -- Espessura do DRS
local function drawDRS(thickness)
    for i, drsData in pairs(data.drs) do
        -- Início
        local left = config.rotateVec(vec2((drsData.startLeft.x - data.trackCenterX) * data.canvasScale, (drsData.startLeft.y - data.trackCenterY) * data.canvasScale), data.angle)
        local center = config.rotateVec(vec2((drsData.startCenter.x - data.trackCenterX) * data.canvasScale, (drsData.startCenter.y - data.trackCenterY) * data.canvasScale), data.angle)
        local right = config.rotateVec(vec2((drsData.startRight.x - data.trackCenterX) * data.canvasScale, (drsData.startRight.y - data.trackCenterY) * data.canvasScale), data.angle)
        
        local dir = (right - left):normalize()
        local init = center + dir * thickness
        init = init + data.canvasCenter
        local final = center - dir * thickness
        final = final + data.canvasCenter
        ui.drawLine(init, final, mapSettings.store.colorDRS, 6)

        -- Final
        left = config.rotateVec(vec2((drsData.finalLeft.x - data.trackCenterX) * data.canvasScale, (drsData.finalLeft.y - data.trackCenterY) * data.canvasScale), data.angle)
        center = config.rotateVec(vec2((drsData.finalCenter.x - data.trackCenterX) * data.canvasScale, (drsData.finalCenter.y - data.trackCenterY) * data.canvasScale), data.angle)
        right = config.rotateVec(vec2((drsData.finalRight.x - data.trackCenterX) * data.canvasScale, (drsData.finalRight.y - data.trackCenterY) * data.canvasScale), data.angle)
        
        dir = (right - left):normalize()
        init = center + dir * thickness
        init = init + data.canvasCenter
        final = center - dir * thickness
        final = final + data.canvasCenter
        ui.drawLine(init, final, mapSettings.store.colorDRS, 6)
    end
end

-- Aumamenta janela com base no retângulo do texto
--- @param initRect vec2 -- Coordenadas iniciais
--- @param finalRect vec2 -- Coordenadas finais
local function resizeWithText(initRect, finalRect)
    if initRect.x < 0 and math.abs(initRect.x) > data.offset.x then
        data.currentWindowSize.x = data.currentWindowSize.x - data.offset.x +  math.abs(initRect.x)
        data.offset.x = math.abs(initRect.x)
    end
    if finalRect.x > data.currentWindowSize.x - data.offset.x then
        data.currentWindowSize.x = finalRect.x + data.offset.x
    end
    if initRect.y < 0 and math.abs(initRect.y) > data.offset.y then
        data.currentWindowSize.y = data.currentWindowSize.y - data.offset.y + math.abs(initRect.y)
        data.offset.y = math.abs(initRect.y)
    end
    if finalRect.y > data.currentWindowSize.y - data.offset.y then
        data.currentWindowSize.y = finalRect.y + data.offset.y
    end
end

-- Altera o tamanho da janela baseado nas seções
local function resizeWindowMap()
    local scale
    local textPosition
    local lenght
    local borderMap = 2
    if mapSettings.store.borderLenght > 0 then
        borderMap = mapSettings.store.borderLenght
    end
    if not mapSettings.store.focus then
        local ratio = (data.baseWindowSize.y * mapSettings.store.mapScale) / data.canvasSize.y
        scale = data.canvasScale * ratio
        lenght = mapSettings.store.sectionsLenght * 2 
        if mapSettings.store.sectionsType == 1 then
            for i = 1, #data.trackSections, 1 do
                local posRotated
                local textLenght = (vec2(lenght, lenght) / 2) * mapSettings.store.mapScale
                if data.trackSections[i].position == 1 then
                    posRotated = config.rotateVec(vec2((data.trackSections[i].center.x - data.trackCenterX) * scale, (data.trackSections[i].center.y - data.trackCenterY) * scale), data.angle)

                elseif data.trackSections[i].position == 2 then
                    posRotated = config.rotateVec(vec2((data.trackSections[i].left.x - data.trackCenterX) * scale, (data.trackSections[i].left.y - data.trackCenterY) * scale), data.angle)
                    local dir = (data.trackSections[i].right - data.trackSections[i].left):normalize()
                    dir = config.rotateVec(dir, data.angle)
                    posRotated = posRotated + dir * (mapSettings.store.trackLenght/2 + borderMap + lenght/4) * mapSettings.store.mapScale

                else
                    posRotated = config.rotateVec(vec2((data.trackSections[i].right.x - data.trackCenterX) * scale, (data.trackSections[i].right.y - data.trackCenterY) * scale), data.angle)
                    local dir = (data.trackSections[i].left - data.trackSections[i].right):normalize()
                    dir = config.rotateVec(dir, data.angle)
                    posRotated = posRotated + dir * (mapSettings.store.trackLenght/2 + borderMap + lenght/4) * mapSettings.store.mapScale
                end
                textPosition = data.windowCenter + posRotated
                resizeWithText(textPosition - textLenght, textPosition + textLenght)

                data.trackSections[i].namePosition = textPosition
            end
        else
            for i = 1, #data.trackSections, 1 do
                local longestText, count = config.findLongestWord(data.trackSections[i].name)
                local textLenght = ui.measureDWriteText(longestText, (lenght / 2)* mapSettings.store.mapScale) + vec2(5) * mapSettings.store.mapScale
                textLenght = textLenght + vec2(0, textLenght.y * count) + vec2(0,5) * mapSettings.store.mapScale
                local posRotated
                local dir = vec2(0,0)
                if data.trackSections[i].position == 1 then
                    posRotated = config.rotateVec(vec2((data.trackSections[i].center.x - data.trackCenterX) * scale, (data.trackSections[i].center.y - data.trackCenterY) * scale), data.angle)

                elseif data.trackSections[i].position == 2 then
                    posRotated = config.rotateVec(vec2((data.trackSections[i].left.x - data.trackCenterX) * scale, (data.trackSections[i].left.y - data.trackCenterY) * scale), data.angle)
                    dir = (data.trackSections[i].right - data.trackSections[i].left):normalize()
                    dir = config.rotateVec(dir, data.angle)

                else
                    posRotated = config.rotateVec(vec2((data.trackSections[i].right.x - data.trackCenterX) * scale, (data.trackSections[i].right.y - data.trackCenterY) * scale), data.angle)
                    dir = (data.trackSections[i].left - data.trackSections[i].right):normalize()
                    dir = config.rotateVec(dir, data.angle)
                end
                local distance
                if dir.x > 0 then
                    distance = config.remapInterval(dir.x, 0, 1, textLenght.x / 20, 1)
                else
                    distance = config.remapInterval(dir.x, -1, 0, 1, textLenght.x / 20)
                end
                local centerText = posRotated + dir * (textLenght.x / (2 * distance) + ((mapSettings.store.trackLenght + borderMap)/2) * mapSettings.store.mapScale)
                textPosition = data.windowCenter + centerText - textLenght / 2
                resizeWithText(textPosition, textPosition + textLenght)
                
                data.trackSections[i].namePosition = textPosition
            end
        end
    else 
        scale = data.canvasScale
        local ratio = data.canvasSize.y / (data.baseWindowSize.y * mapSettings.store.mapScale)
        lenght = (mapSettings.store.sectionsLenght * 2) * ratio * mapSettings.store.mapScale
        if mapSettings.store.sectionsType == 1 then
            local textLenght = (vec2(lenght, lenght) / 2)
            for i = 1, #data.trackSections, 1 do
                local posRotated
                if data.trackSections[i].position == 1 then
                    posRotated = config.rotateVec(vec2((data.trackSections[i].center.x - data.trackCenterX) * scale, (data.trackSections[i].center.y - data.trackCenterY) * scale), data.angle)

                elseif data.trackSections[i].position == 2 then
                    posRotated = config.rotateVec(vec2((data.trackSections[i].left.x - data.trackCenterX) * scale, (data.trackSections[i].left.y - data.trackCenterY) * scale), data.angle)
                    local dir = (data.trackSections[i].right - data.trackSections[i].left):normalize()
                    dir = config.rotateVec(dir, data.angle)
                    posRotated = posRotated + dir * (mapSettings.store.trackLenght/2 + borderMap + textLenght.x)

                else
                    posRotated = config.rotateVec(vec2((data.trackSections[i].right.x - data.trackCenterX) * scale, (data.trackSections[i].right.y - data.trackCenterY) * scale), data.angle)
                    local dir = (data.trackSections[i].left - data.trackSections[i].right):normalize()
                    dir = config.rotateVec(dir, data.angle)
                    posRotated = posRotated + dir * (mapSettings.store.trackLenght/2 + borderMap + textLenght.x)
                end
                posRotated = data.canvasCenter + posRotated
                textPosition = posRotated
                data.trackSections[i].namePosition = textPosition
            end
        else 
            for i = 1, #data.trackSections, 1 do
                local longestText, count = config.findLongestWord(data.trackSections[i].name)
                local textLenght = (ui.measureDWriteText(longestText, lenght / 2) + vec2(5))
                textLenght = textLenght + vec2(0, textLenght.y * count) + vec2(0,5)
                local posRotated
                local dir = vec2(0,0)
                if data.trackSections[i].position == 1 then
                    posRotated = config.rotateVec(vec2((data.trackSections[i].center.x - data.trackCenterX) * scale, (data.trackSections[i].center.y - data.trackCenterY) * scale), data.angle)

                elseif data.trackSections[i].position == 2 then
                    posRotated = config.rotateVec(vec2((data.trackSections[i].left.x - data.trackCenterX) * scale, (data.trackSections[i].left.y - data.trackCenterY) * scale), data.angle)
                    dir = (data.trackSections[i].right - data.trackSections[i].left):normalize()
                    dir = config.rotateVec(dir, data.angle)

                else
                    posRotated = config.rotateVec(vec2((data.trackSections[i].right.x - data.trackCenterX) * scale, (data.trackSections[i].right.y - data.trackCenterY) * scale), data.angle)
                    dir = (data.trackSections[i].left - data.trackSections[i].right):normalize()
                    dir = config.rotateVec(dir, data.angle)
                end
                local distance
                if dir.x > 0 then
                    distance = config.remapInterval(dir.x, 0, 1, textLenght.x / 30, 1)
                else
                    distance = config.remapInterval(dir.x, -1, 0, 1, textLenght.x / 30)
                end
                local centerText = posRotated + dir * (textLenght.x / (2 * distance) + (mapSettings.store.trackLenght + borderMap))
                textPosition = data.canvasCenter + centerText - textLenght / 2
                
                data.trackSections[i].namePosition = textPosition
            end
        end
    end
end

-- Desenha nomes da pista
local function drawTrackSections()
    local scale
    local textLenght
    local lenght
    if mapSettings.store.focus then
        scale = data.canvasSize.y / (data.baseWindowSize.y * mapSettings.store.mapScale)
        lenght = (mapSettings.store.sectionsLenght * 2) * mapSettings.store.mapScale
    else 
        scale =  mapSettings.store.mapScale
        lenght = mapSettings.store.sectionsLenght * 2
    end
    if mapSettings.store.sectionsType == 1 then
        textLenght = ((vec2(lenght, lenght) / 2)) * scale
        for i = 1, #data.trackSections, 1 do
            local position = data.trackSections[i].namePosition + data.offset
            ui.drawCircleFilled(position, textLenght.x, mapSettings.store.sectionsBgColor, 20)
            ui.setCursor(position - textLenght / 2)
            ui.dwriteTextAligned(data.trackSections[i].number, (lenght / 2) * scale, ui.Alignment.Center, ui.Alignment.Center, textLenght, false, mapSettings.store.sectionsTextColor)
        end

    else
        for i = 1, #data.trackSections, 1 do
            if data.trackSections[i].name ~= "" then
                local longestText, count = config.findLongestWord(data.trackSections[i].name)
                local textLenght = ui.measureDWriteText(longestText, (lenght / 2) * scale) + vec2(5) * scale
                textLenght = textLenght + vec2(0, textLenght.y * count) + vec2(0,5) * scale
                local position = data.trackSections[i].namePosition + data.offset
                ui.drawRectFilled(position, position + textLenght, mapSettings.store.sectionsBgColor, 3 * mapSettings.store.mapScale)
                ui.setCursor(position)
                ui.dwriteTextAligned(data.trackSections[i].name:gsub("\n$", ""), (lenght / 2) * scale, ui.Alignment.Center, ui.Alignment.Center, textLenght, false, mapSettings.store.sectionsTextColor)
            end
        end
    end
end

function map.windowMain()
    if mapSettings.store.resetSectionsINI then
        data.trackSections = mapSettings.resetSectionsINI()
    end
    if mapSettings.store.trackSectionsEdited then
        data.trackSections = mapSettings.loadSectionsINI()
    end

    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
    data.offset = vec2(0,0)
    data.currentWindowSize = vec2(300, 300)
    data.currentWindowSize = data.currentWindowSize:scale(mapSettings.store.mapScale)
    data.windowCenter = data.currentWindowSize / 2
    data.canvasScale = (data.canvasSize.y - (data.padding * 2)) / data.trackLength
    if mapSettings.store.focus then
        data.trackCenterX = CAR.position.x
        data.trackCenterY = CAR.position.z
        data.angle = math.deg(math.atan2(CAR.look.z, -CAR.look.x) + math.pi / 2)
    else
        data.trackCenterX = (data.minPos.x + data.maxPos.x) / 2
        data.trackCenterY = (data.minPos.y + data.maxPos.y) / 2
        if mapSettings.isClockwise then
            data.angle = math.deg(-math.atan2(data.dirTrack.y, data.dirTrack.x) + math.pi) + mapSettings.store.angle
        else
            data.angle = math.deg(-math.atan2(data.dirTrack.y, data.dirTrack.x)) + mapSettings.store.angle
        end
    end

    if mapSettings.store.sectionsTrackActive then
        resizeWindowMap()
    end

    -- Desenha borda
    if data.canvas == nil then return end
    data.canvas:clear()
    data.canvas:update(function ()
        drawMap(mapSettings.store.trackLenght + mapSettings.store.borderLenght * 2, mapSettings.store.colorBorder)
        -- Desenha pista
        drawMap(mapSettings.store.trackLenght, mapSettings.store.colorTrack)
        -- Desenha DRS
        if mapSettings.store.drsActive then
            drawDRS(mapSettings.store.trackLenght / 1.8)
        end
        -- Desenha setores
        if mapSettings.store.sectorsActive then
            drawSectors(mapSettings.store.trackLenght / 1.8, mapSettings.store.colorSectors)
        end

        -- Desenha bandeira de largada
        if mapSettings.store.borderLenght < 0 then
            drawStartFlag((mapSettings.store.trackLenght + 6) / 1.3)
        else 
            drawStartFlag((mapSettings.store.trackLenght + mapSettings.store.borderLenght * 2) / 1.3)
        end
    end)


    -- Animação do Background
    if config.isMouseInWindow(ui.mouseLocalPos(), 0, ui.windowSize().x, 0, ui.windowSize().y) then
        if data.transparancy < 0.85 then
            if 20 * Timer % 6 >= 1 then
                data.transparancy = data.transparancy + 0.1
            end
        end
        ui.drawRectFilled(vec2(0, 0), data.currentWindowSize, rgbm(WindowsColor.r,WindowsColor.g,WindowsColor.b, data.transparancy), 20 * mapSettings.store.mapScale)
    else
        if data.transparancy > 0 then
            if 20 * Timer % 6 >= 1 then
                data.transparancy = data.transparancy - 0.1
            end
             ui.drawRectFilled(vec2(0, 0), data.currentWindowSize, rgbm(WindowsColor.r,WindowsColor.g,WindowsColor.b, data.transparancy), 20 * mapSettings.store.mapScale)
        else
            data.transparancy = 0
        end
    end
    
    if mapSettings.store.focus then
        if data.canvasZoom == nil then return end
        local zoomScaled = mapSettings.store.zoom * mapSettings.store.mapScale
        if mapSettings.store.sectionsTrackActive then
            data.canvas:update(function ()
                drawTrackSections()
                drawPlayers()
            end)
        else
            data.canvas:update(function ()
                drawPlayers()
            end)
        end
        data.canvasZoom:updateWithShader({
            textures = {canvas = data.canvas},
            values = {zoom = data.currentWindowSize.x / (2 * (2 * zoomScaled + data.currentWindowSize.x))},
            shader = [[
                SamplerState mapSample {
                    Filter = MIN_MAG_MIP_LINEAR;
                    AddressU = Wrap;
                    AddressV = Wrap;
                };

                float remap(float v, float inMin, float inMax, float outMin, float outMax) {
                    return outMin + (v - inMin) * (outMax - outMin) / (inMax - inMin);
                }

                float4 main(PS_IN pin) {
                    float4 mapCanvas = canvas.Sample(mapSample, pin.Tex);
                    float distanceDromCenter = clamp(distance(float2(0.5f, 0.5f), pin.Tex), zoom - 0.05f, zoom);
                    return lerp(mapCanvas, float4(0,0,0,0), remap(distanceDromCenter, zoom - 0.05f, zoom, 0, 1));
                }
            ]]
        })
    
        ui.drawImage(data.canvasZoom, -zoomScaled, data.currentWindowSize.x + zoomScaled)
    else
        data.offset = config.floorVec(data.offset)
        ui.drawImage(data.canvas, data.offset, data.baseWindowSize * mapSettings.store.mapScale + data.offset)
        if mapSettings.store.sectionsTrackActive then
            drawTrackSections()
        end
        drawPlayers()
    end
    config.resize(data.currentWindowSize, "Map")
    pinCheckBox.main(mapSettings.store.mapScale * 1.5, "Map", config.getWindow("Map"):pinned(), data.currentWindowSize)
end

initMap()

return map