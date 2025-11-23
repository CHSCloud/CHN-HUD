local language = require("lang.language")
local simpleCheckbox = require("src.ui.simpleCheckBox")
local pedalsSettings = {} 

local defaultValues = {
    pedalsScale = 1,
    gearActive = true,
    speedActive = true,
    wheelActive = true,
    absActive = true,
    acceleratorActive = true,
    brakeActive = true,
    brakeBiasActive = true,
    clutchActive = true,
    handbrakeActive = false,
    textBarsActive = false,
    fuelActive = true,
    pedalLimitsLines = true,
    rpmActive = true,
    rpmType = "default",
    rpmProcessType = "default",
    numLights = 9,
    barLength = 0.55
}

pedalsSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        pedalsSettings.store[key] = value
    end
end

function pedalsSettings.pedalsSettings()
    local rpmLabels = {
        ["default"] = language.get("SHIFT_LIGHTS"),
        ["bar"] = language.get("BAR")
    }
    local processCircleType = {
        ["default"] = language.get("DEFAULT"),
        ["total"] = "Total"
    }
    
    -- Layout
    local initPos = 55
    local posXOthers = 150
    local posXStyle = 150
    local posXRPpedalsSettings = 330
    
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))
    
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    
    pedalsSettings.store.pedalsScale = math.floor(ui.slider("##Size", pedalsSettings.store.pedalsScale, 0.7, 3, string.format("%.2f", pedalsSettings.store.pedalsScale)) * 100 + 0.5) / 100


    initPos = initPos + 35
    ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), COLOR.GRAY, 1)

    -- DIREÇÃO
    initPos = initPos + 10
    local initPos2 = initPos -- Salva posição para coluna da direita
    
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("STEERING"))
    
    initPos = initPos + 25; 
    pedalsSettings.store.gearActive = simpleCheckbox.main(language.get("GEAR"), pedalsSettings.store.gearActive, 20, initPos)
    
    initPos = initPos + 25; 
    pedalsSettings.store.speedActive = simpleCheckbox.main(language.get("SPEED"), pedalsSettings.store.speedActive, 20, initPos)
    
    initPos = initPos + 25; 
    pedalsSettings.store.wheelActive = simpleCheckbox.main(language.get("WHEEL"), pedalsSettings.store.wheelActive, 20, initPos)
    
    initPos = initPos + 25; 
    pedalsSettings.store.absActive = simpleCheckbox.main(language.get("ABS"), pedalsSettings.store.absActive, 20, initPos)

    -- Alerta do ABS
    if CAR.absModes == 0 then
        ui.setCursor(vec2(70, initPos))
        ui.dwriteTextAligned(language.get("ALERT_ABS"), 10, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 25), false, COLOR.RED)  
    end

    initPos = initPos + 50
    ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), COLOR.GRAY, 1)

    -- OUTROS
    local posRPpedalsSettings = initPos2
    ui.setCursor(vec2(posXOthers - 5, initPos2))
    ui.header(language.get("OTHERS"))
  
    initPos2 = initPos2 + 25; 
    pedalsSettings.store.fuelActive = simpleCheckbox.main(language.get("FUEL"), pedalsSettings.store.fuelActive, posXOthers, initPos2)
    
    initPos2 = initPos2 + 25; 
    pedalsSettings.store.brakeBiasActive = simpleCheckbox.main(language.get("BRAKE_BIAS"), pedalsSettings.store.brakeBiasActive, posXOthers, initPos2)
    -- 

    -- RPM
    ui.setCursor(vec2(posXRPpedalsSettings - 5, posRPpedalsSettings))
    ui.header("RPM")
    
    posRPpedalsSettings = posRPpedalsSettings + 25
    pedalsSettings.store.rpmActive = simpleCheckbox.main("RPM", pedalsSettings.store.rpmActive, posXRPpedalsSettings, posRPpedalsSettings)

    if pedalsSettings.store.rpmActive then
        local exampleRPpedalsSettingsX = 420
        local exampleRPpedalsSettingsY = 158
        
        posRPpedalsSettings = posRPpedalsSettings + 30
        ui.setCursor(vec2(posXRPpedalsSettings, posRPpedalsSettings + 5))
        ui.header(language.get("TYPE"))
        
        ui.setCursor(vec2(posXRPpedalsSettings + 30, posRPpedalsSettings))
        ui.setNextItemWidth(140)
        
        -- Combo RPM Type
        ui.combo('##rpmType', rpmLabels[pedalsSettings.store.rpmType], function ()
            if ui.selectable(rpmLabels["default"]) then pedalsSettings.store.rpmType = "default" end
            if ui.selectable(rpmLabels["bar"]) then pedalsSettings.store.rpmType = "bar" end
        end)

        if pedalsSettings.store.rpmType == "default" then
            posRPpedalsSettings = posRPpedalsSettings + 35
            ui.setCursor(vec2(posXRPpedalsSettings, posRPpedalsSettings))
            ui.header(language.get("PROGRESS"))
            
            ui.setCursor(vec2(posXRPpedalsSettings + 50, posRPpedalsSettings - 5))
            ui.setNextItemWidth(100)
            
            ui.combo('##progress', processCircleType[pedalsSettings.store.rpmProcessType], function ()
                if ui.selectable(processCircleType["default"]) then pedalsSettings.store.rpmProcessType = "default" end
                if ui.selectable(processCircleType["total"]) then pedalsSettings.store.rpmProcessType = "total" end
            end)

            for i = 1, 9 do
                local c1, c2, c3 = COLOR.GREEN, COLOR.GREEN, COLOR.GREEN
                
                if pedalsSettings.store.rpmProcessType == "default" then
                    if i > 7 then c1, c2, c3 = COLOR.GRAY_BG, COLOR.GRAY_BG, COLOR.RED_DARK
                    elseif i > 4 then c1, c2, c3 = COLOR.GRAY_BG, COLOR.YELLOW, COLOR.YELLOW end
                else 
                    c2, c3 = COLOR.YELLOW, COLOR.RED_DARK
                    if i > 7 then c1, c2 = COLOR.GRAY_BG, COLOR.GRAY_BG
                    elseif i > 4 then c1 = COLOR.GRAY_BG end
                end

                ui.drawCircleFilled(vec2(exampleRPpedalsSettingsX, exampleRPpedalsSettingsY - 30), 5, c1, 20)
                ui.drawCircleFilled(vec2(exampleRPpedalsSettingsX, exampleRPpedalsSettingsY - 15), 5, c2, 20)
                ui.drawCircleFilled(vec2(exampleRPpedalsSettingsX, exampleRPpedalsSettingsY), 5, c3, 20)
                exampleRPpedalsSettingsX = exampleRPpedalsSettingsX + 11
            end

            posRPpedalsSettings = posRPpedalsSettings + 30
            ui.setCursor(vec2(posXRPpedalsSettings, posRPpedalsSettings))
            ui.header(language.get("NUM_LIGHTS"))
            ui.setCursor(vec2(posXRPpedalsSettings + 90, posRPpedalsSettings - 5))
            ui.setNextItemWidth(160)
            
            pedalsSettings.store.numLights = math.floor(ui.slider("##numLights", pedalsSettings.store.numLights, 6, 25, string.format("%i", pedalsSettings.store.numLights)))

        elseif pedalsSettings.store.rpmType == "bar" then
            posRPpedalsSettings = posRPpedalsSettings + 35
            ui.setCursor(vec2(posXRPpedalsSettings, posRPpedalsSettings))
            ui.header("Percentage")
        
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 35), vec2(exampleRPpedalsSettingsX + 93, exampleRPpedalsSettingsY - 25), COLOR.GRAY_BG, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 35), vec2(exampleRPpedalsSettingsX - 5 + (98 * 0.45), exampleRPpedalsSettingsY - 25), COLOR.GREEN, 10)
            
            ui.setCursor(vec2(posXRPpedalsSettings + 70, posRPpedalsSettings - 5))
            ui.setNextItemWidth(160)
            pedalsSettings.store.barLength = ui.slider("##barLength", pedalsSettings.store.barLength, 0.25, 0.95, string.format("%.0f%%", (pedalsSettings.store.barLength+ 0.05) * 100) .. "%")
        end
        --
    end
    --

    -- PEDAIS
    initPos = initPos + 10
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("PEDALS"))

    initPos = initPos + 25; 
    pedalsSettings.store.acceleratorActive = simpleCheckbox.main(language.get("THROTTLE"), pedalsSettings.store.acceleratorActive, 20, initPos)

    ui.setCursor(vec2(posXStyle - 5, initPos - 25))
    ui.header(language.get("PEDAL_STYLE"))
    
    pedalsSettings.store.textBarsActive = simpleCheckbox.main(language.get("PERCENTAGE"), pedalsSettings.store.textBarsActive, posXStyle, initPos)

    initPos = initPos + 25
    pedalsSettings.store.pedalLimitsLines = simpleCheckbox.main(language.get("LIMIT_LINES"), pedalsSettings.store.pedalLimitsLines, posXStyle, initPos)

    ui.setCursor(vec2(20, initPos))
    pedalsSettings.store.brakeActive = simpleCheckbox.main(language.get("BRAKE"), pedalsSettings.store.brakeActive, 20, initPos)
    
    initPos = initPos + 25; 
    pedalsSettings.store.clutchActive = simpleCheckbox.main(language.get("CLUTCH"), pedalsSettings.store.clutchActive, 20, initPos)
    
    initPos = initPos + 25; 
    pedalsSettings.store.handbrakeActive = simpleCheckbox.main(language.get("HANDBRAKE"), pedalsSettings.store.handbrakeActive, 20, initPos)
    --
    
    -- Botão Reset
    initPos = initPos + 40
    ui.setCursor(vec2(20, initPos))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return pedalsSettings