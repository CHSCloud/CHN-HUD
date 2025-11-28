local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")
local startingLightsSettings = require("src.settings.tabs.startingLightsSettings")
local startingLights = {}

--- @param value number
--- @param inMin number
--- @param inMax number
--- @param outMin number
--- @param outMax number
--- @return number
local function convertInterval(value, inMin, inMax, outMin, outMax)
    local output = outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin)
    if output > outMax then
        output = outMax
    elseif output < outMin then
        output = outMin
    end
    return output
end

function startingLights.windowMain()
    -- Raio
    local radius = 20 * startingLightsSettings.store.startingLightsScale
    -- Posição do primeiro círculo
    local pos = radius + radius / 2 + 2 * startingLightsSettings.store.startingLightsScale
    -- Distância entre os círculos
    local distance = radius * 2 + radius / 2
    -- Grossura
    local thickness = 1.5 * startingLightsSettings.store.startingLightsScale
    -- Distancia da borda
    local distanceBorder = 4 * startingLightsSettings.store.startingLightsScale
    --Polígonos dos círculos
    local polygons = 50
    local rounding = 50 * startingLightsSettings.store.startingLightsScale
    local rounding2 = 50 * startingLightsSettings.store.startingLightsScale

    -- Proporções da tela
    local currentWindowHeight = 3 * radius + distanceBorder
    local currentWindowWidth = ((startingLightsSettings.store.numStartingLights - 1) * distance) + 3 * radius + distanceBorder
    
    config.resize(vec2(currentWindowWidth, currentWindowHeight), "Starting Lights")

    if SIM.raceSessionType == ac.SessionType.Race then
        local current = 0
        if(SIM.currentSessionTime < 0) then
            -- Background
            ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, currentWindowHeight), WindowsColor, rounding)
            ui.drawRect(vec2(distanceBorder, distanceBorder), vec2(currentWindowWidth - distanceBorder, currentWindowHeight - distanceBorder), COLOR.WHITE, rounding2, ui.CornerFlags.All, thickness)

            -- Círculos do background
            for i = 0, startingLightsSettings.store.numStartingLights - 1, 1 do
                ui.drawCircleFilled(vec2(pos + i * distance , currentWindowHeight / 2), radius, COLOR.GRAY_BG, polygons)
                ui.drawCircle(vec2(pos + i * distance , currentWindowHeight / 2), radius, COLOR.WHITE, polygons, thickness)
            end

            -- Círculos Vermelhos
            local add = 5000 / startingLightsSettings.store.numStartingLights
            for i = -7000, -2000, add do
                
                if SIM.currentSessionTime > i and i < -2000 then
                    ui.drawCircleFilled(vec2(pos + current * distance , currentWindowHeight / 2), convertInterval(SIM.currentSessionTime, i, i + add, 0, radius), COLOR.RED, polygons)
                    ui.drawCircle(vec2(pos + current * distance , currentWindowHeight / 2), radius, COLOR.WHITE, polygons, thickness)
                end 
                current = current + 1
            end
        elseif SIM.currentSessionTime < 6000 then
            -- Background
            ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, currentWindowHeight), WindowsColor, rounding)
            ui.drawRect(vec2(distanceBorder, distanceBorder), vec2(currentWindowWidth - distanceBorder, currentWindowHeight - distanceBorder), COLOR.WHITE, rounding2, ui.CornerFlags.All, thickness)
            
            -- Cículos verdes
            if 2 * Timer % 2 > 1 then
                for i = 0, startingLightsSettings.store.numStartingLights - 1, 1 do
                    if i % 2 == 0 then
                        ui.drawCircleFilled(vec2(pos + i * distance , currentWindowHeight / 2), radius, COLOR.GREEN, polygons)
                    else
                        ui.drawCircleFilled(vec2(pos + i * distance , currentWindowHeight / 2), radius, COLOR.GRAY_BG, polygons)
                    end
                    ui.drawCircle(vec2(pos + i * distance , currentWindowHeight / 2), radius, COLOR.WHITE, polygons, thickness)
                end
            else
                for i = 0, startingLightsSettings.store.numStartingLights - 1, 1 do
                    if i % 2 == 1 then
                        ui.drawCircleFilled(vec2(pos + i * distance , currentWindowHeight / 2), radius, COLOR.GREEN, polygons)
                    else
                        ui.drawCircleFilled(vec2(pos + i * distance , currentWindowHeight / 2), radius, COLOR.GRAY_BG, polygons)
                    end
                    ui.drawCircle(vec2(pos + i * distance , currentWindowHeight / 2), radius, COLOR.WHITE, polygons, thickness)
                end
            end
        elseif SettingsActive then
            -- Background
            ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, currentWindowHeight), WindowsColor, rounding)
            ui.drawRect(vec2(distanceBorder, distanceBorder), vec2(currentWindowWidth - distanceBorder, currentWindowHeight - distanceBorder), COLOR.WHITE, rounding2, ui.CornerFlags.All, thickness)
            
            -- Círculos Azuis
            for i = 0, startingLightsSettings.store.numStartingLights - 1, 1 do
                ui.drawCircleFilled(vec2(pos + i * distance , currentWindowHeight / 2), radius, COLOR.BLUE, polygons)
                ui.drawCircle(vec2(pos + i * distance , currentWindowHeight / 2), radius, COLOR.WHITE, polygons, thickness)
            end
            pinCheckBox.main(startingLightsSettings.store.startingLightsScale, "Starting Lights", config.getWindow("Starting Lights"):pinned(), vec2(currentWindowWidth, currentWindowHeight))
        end
    elseif SettingsActive then
        -- Background
        ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, currentWindowHeight), WindowsColor, rounding)
        ui.drawRect(vec2(distanceBorder, distanceBorder), vec2(currentWindowWidth - distanceBorder, currentWindowHeight - distanceBorder), COLOR.WHITE, rounding2, ui.CornerFlags.All, thickness)
        
        -- Círculos Azuis
        for i = 0, startingLightsSettings.store.numStartingLights - 1, 1 do
            ui.drawCircleFilled(vec2(pos + i * distance , currentWindowHeight / 2), radius, COLOR.BLUE, polygons)
            ui.drawCircle(vec2(pos + i * distance , currentWindowHeight / 2), radius, COLOR.WHITE, polygons, thickness)
        end
        pinCheckBox.main(startingLightsSettings.store.startingLightsScale, "Starting Lights", config.getWindow("Starting Lights"):pinned(), vec2(currentWindowWidth, currentWindowHeight))
    end
end

return startingLights
