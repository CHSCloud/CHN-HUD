local mapSettings = require("src.settings.tabs.mapSettings")
local utils = require("common.utils")

---@class mapData
---@field minPos vec2
---@field maxPos vec2
---@field totalPoints number
---@field mapPoints vec2[]
---@field sectors table
---@field drs table
---@field trackSections table
---@field canvas any
---@field canvasZoom any
---@field canvasSize vec2
---@field canvasCenter vec2
---@field canvasScale number
---@field angle number
---@field offset vec2
---@field padding number
---@field baseWindowSize vec2
---@field currentWindowSize vec2
---@field windowCenter vec2
---@field trackLength number
---@field trackCenterX number
---@field trackCenterY number
---@field isTrackConnected boolean
---@field startTrack vec3
---@field endTrack vec3
---@field dirTrack vec2
---@field transparancy number
local mapData = {}

---@return mapData
function mapData.new()
    local baseWindowSize = vec2(300, 300)
    local currentWindowSize = baseWindowSize
    return {
        minPos = vec2(math.huge, math.huge),
        maxPos = vec2(-math.huge, -math.huge),
        totalPoints = 0,
        mapPoints = {},
        sectors = {},
        drs = {},
        trackSections = {},
        canvas = nil,
        canvasZoom = nil,
        canvasSize = vec2(600, 600),
        canvasCenter = vec2(600 / 2, 600 / 2),
        canvasScale = nil,
        angle = nil,
        offset = vec2(0, 0),
        padding = 40,
        baseWindowSize = baseWindowSize,
        currentWindowSize = currentWindowSize,
        windowCenter = currentWindowSize / 2,
        trackLength = 0,
        trackCenterX = 0,
        trackCenterY = 0,
        isTrackConnected = true,
        startTrack = nil,
        endTrack = nil,
        dirTrack = vec2(0, 0),
        transparancy = 0,
    }
end

---@param data mapData
function mapData.initMap(data)
    -- Calculando todos os pontos do mapa
    data.totalPoints = utils.remapInterval(SIM.trackLengthM, 0, 4000, 0, 500)

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
    for _, sector in ipairs(SIM.lapSplits) do
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
        for _, sectionData in pairs(drsINI['sections']) do
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

return mapData
