local language = require("lang.language")
local simpleCheckbox = require("src.ui.simpleCheckBox")
local SimpleButton = require("src.ui.simpleButton")
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
    wheelType = "default",
    rpmType = "default",
    rpmProcessType = "default",
    numLights = 9,
    barLength = 0.55
}

local gearButton = SimpleButton.new()
local speedButton = SimpleButton.new()
local wheelButton = SimpleButton.new()
local absButton = SimpleButton.new()
local acceleratorButton = SimpleButton.new()
local brakeButton = SimpleButton.new()
local brakeBiasButton = SimpleButton.new()
local clutchButton = SimpleButton.new()
local handbrakeButton = SimpleButton.new()
local textBarsButton = SimpleButton.new()
local fuelButton = SimpleButton.new()
local pedalLimitsLinesButton = SimpleButton.new()
local rpmButton = SimpleButton.new()

pedalsSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        pedalsSettings.store[key] = value
    end
end

function pedalsSettings.pedalsSettings()
    local wheelLabels = {
        ["default"] = "Iracing",
        ["simple"] = language.get("SIMPLE")
    }
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
    local posXOthers = 250
    local posXStyle = 150
    local posXRPMpedalsSettings = 460
    
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
    pedalsSettings.store.gearActive = gearButton:main(vec2(20,initPos), pedalsSettings.store.gearActive, language.get("GEAR"))
    
    initPos = initPos + 25; 
    pedalsSettings.store.speedActive = speedButton:main(vec2(20,initPos), pedalsSettings.store.speedActive, language.get("SPEED"))
    
    initPos = initPos + 25;
    pedalsSettings.store.wheelActive = wheelButton:main(vec2(20,initPos), pedalsSettings.store.wheelActive, language.get("WHEEL"))
    if pedalsSettings.store.wheelActive then
        -- Combo Wheel Type
        ui.setCursor(vec2(120, initPos + 5))
        ui.header("|  ".. language.get("TYPE"))
        ui.setCursor(vec2(160, initPos))
        ui.setNextItemWidth(100)
        ui.combo('##wheelType', wheelLabels[pedalsSettings.store.wheelType], function ()
            if ui.selectable(wheelLabels["default"]) then pedalsSettings.store.wheelType = "default" end
            if ui.selectable(wheelLabels["simple"]) then pedalsSettings.store.wheelType = "simple" end
        end)
    end
    
    initPos = initPos + 25; 
    pedalsSettings.store.absActive = absButton:main(vec2(20,initPos), pedalsSettings.store.absActive, language.get("ABS"))

    -- Alerta do ABS
    if CAR.absModes == 0 then
        ui.setCursor(vec2(70, initPos))
        ui.dwriteTextAligned(language.get("ALERT_ABS"), 10, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 25), false, COLOR.RED)  
    end

    initPos = initPos + 50
    ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), COLOR.GRAY, 1)

    -- OUTROS
    local posRPMpedalsSettings = initPos2
    ui.setCursor(vec2(posXOthers - 5, initPos2))
    ui.header(language.get("OTHERS"))
  
    initPos2 = initPos2 + 25; 
    pedalsSettings.store.fuelActive = fuelButton:main(vec2(posXOthers,initPos2), pedalsSettings.store.fuelActive, language.get("FUEL"))
    
    initPos2 = initPos2 + 25; 
    pedalsSettings.store.brakeBiasActive = brakeBiasButton:main(vec2(posXOthers,initPos2), pedalsSettings.store.brakeBiasActive, language.get("BRAKE_BIAS"))
    -- 

    -- RPM
    ui.setCursor(vec2(posXRPMpedalsSettings - 5, posRPMpedalsSettings))
    ui.header("RPM")
    
    posRPMpedalsSettings = posRPMpedalsSettings + 25
    pedalsSettings.store.rpmActive = rpmButton:main(vec2(posXRPMpedalsSettings,posRPMpedalsSettings), pedalsSettings.store.rpmActive, language.get("RPM"))

    if pedalsSettings.store.rpmActive then
        local exampleRPpedalsSettingsX = 515        
        local exampleRPpedalsSettingsY = 158
        
        posRPMpedalsSettings = posRPMpedalsSettings + 30
        ui.setCursor(vec2(posXRPMpedalsSettings, posRPMpedalsSettings + 5))
        ui.header(language.get("TYPE"))
        
        ui.setCursor(vec2(posXRPMpedalsSettings + 30, posRPMpedalsSettings))
        ui.setNextItemWidth(140)
        
        -- Combo RPM Type
        ui.combo('##rpmType', rpmLabels[pedalsSettings.store.rpmType], function ()
            if ui.selectable(rpmLabels["default"]) then pedalsSettings.store.rpmType = "default" end
            if ui.selectable(rpmLabels["bar"]) then pedalsSettings.store.rpmType = "bar" end
        end)

        if pedalsSettings.store.rpmType == "default" then
            posRPMpedalsSettings = posRPMpedalsSettings + 35
            ui.setCursor(vec2(posXRPMpedalsSettings, posRPMpedalsSettings))
            ui.header(language.get("PROGRESS"))
            
            ui.setCursor(vec2(posXRPMpedalsSettings + 50, posRPMpedalsSettings - 5))
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

            posRPMpedalsSettings = posRPMpedalsSettings + 30
            ui.setCursor(vec2(posXRPMpedalsSettings, posRPMpedalsSettings))
            ui.header(language.get("NUM_LIGHTS"))
            ui.setCursor(vec2(posXRPMpedalsSettings + 90, posRPMpedalsSettings - 5))
            ui.setNextItemWidth(160)
            
            pedalsSettings.store.numLights = math.floor(ui.slider("##numLights", pedalsSettings.store.numLights, 6, 25, string.format("%i", pedalsSettings.store.numLights)))

        elseif pedalsSettings.store.rpmType == "bar" then
            posRPMpedalsSettings = posRPMpedalsSettings + 35
            ui.setCursor(vec2(posXRPMpedalsSettings, posRPMpedalsSettings))
            ui.header("Percentage")
        
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 35), vec2(exampleRPpedalsSettingsX + 93, exampleRPpedalsSettingsY - 25), COLOR.GRAY_BG, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 35), vec2(exampleRPpedalsSettingsX - 5 + (98 * 0.45), exampleRPpedalsSettingsY - 25), COLOR.GREEN, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 20), vec2(exampleRPpedalsSettingsX + 93, exampleRPpedalsSettingsY - 10), COLOR.GRAY_BG, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 20), vec2(exampleRPpedalsSettingsX - 5 + (98 * 0.75), exampleRPpedalsSettingsY - 10), COLOR.YELLOW, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 5), vec2(exampleRPpedalsSettingsX + 93, exampleRPpedalsSettingsY + 5), COLOR.GRAY_BG, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 5), vec2(exampleRPpedalsSettingsX - 5 + (98), exampleRPpedalsSettingsY + 5), COLOR.RED, 10)
            
            ui.setCursor(vec2(posXRPMpedalsSettings + 70, posRPMpedalsSettings - 5))
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
    pedalsSettings.store.acceleratorActive = acceleratorButton:main(vec2(20,initPos), pedalsSettings.store.acceleratorActive, language.get("ACCELERATOR"))

    ui.setCursor(vec2(posXStyle - 5, initPos - 25))
    ui.header(language.get("PEDAL_STYLE"))
    
    pedalsSettings.store.textBarsActive = textBarsButton:main(vec2(posXStyle,initPos), pedalsSettings.store.textBarsActive, language.get("PERCENTAGE"))

    initPos = initPos + 25
    pedalsSettings.store.pedalLimitsLines = pedalLimitsLinesButton:main(vec2(posXStyle,initPos), pedalsSettings.store.pedalLimitsLines, language.get("LIMIT_LINES"))

    ui.setCursor(vec2(20, initPos))
    pedalsSettings.store.brakeActive = brakeButton:main(vec2(20,initPos), pedalsSettings.store.brakeActive, language.get("BRAKE"))
    
    initPos = initPos + 25; 
    pedalsSettings.store.clutchActive = clutchButton:main(vec2(20,initPos), pedalsSettings.store.clutchActive, language.get("CLUTCH"))
    
    initPos = initPos + 25; 
    pedalsSettings.store.handbrakeActive = handbrakeButton:main(vec2(20,initPos), pedalsSettings.store.handbrakeActive, language.get("HANDBRAKE"))
    --
    -- Botão Reset
    initPos = initPos + 40
    ui.setCursor(vec2(20, initPos))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return pedalsSettings