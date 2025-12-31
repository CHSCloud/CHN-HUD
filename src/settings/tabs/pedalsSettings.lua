local language = require("lang.language")
local slider = require("src.ui.slider")
local button = require("src.ui.button")
local droplist = require("src.ui.droplist")
local toggleButton = require("src.ui.toggleButton")
local pedalsSettings = {} 

local defaultValues = {
    pedalsScale = 1,
    gearActive = true,
    speedActive = true,
    wheelActive = true,
    absActive = true,
    tractionControlActive = true,
    throttleActive = true,
    brakeActive = true,
    brakeBiasActive = true,
    clutchActive = true,
    handbrakeActive = false,
    textBarsActive = false,
    fuelActive = true,
    pedalLimitsLines = true,
    rpmActive = true,
    wheelType = 1,
    rpmType = 1,
    rpmProcessType = 1,
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
    local wheelLabels = {
        "Iracing",
        language.get("SIMPLE")
    }
    local rpmLabels = {
        language.get("SHIFT_LIGHTS"),
        language.get("BAR")
    }
    local processCircleType = {
        language.get("DEFAULT"),
        "Total"
    }
    -- Layout
    local initPos = 55
    local posXOthers = 270
    local posXStyle = 150
    local posXRPMpedalsSettings = 490

    
    initPos = initPos + 20
    pedalsSettings.store.pedalsScale = slider.main(language.get("SIZE"), string.format("%.2f", pedalsSettings.store.pedalsScale), vec2(20, initPos), 250, pedalsSettings.store.pedalsScale, 0.7, 3)


    initPos = initPos + 35
    ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), COLOR.GRAY, 1)

    -- DIREÇÃO
    initPos = initPos + 10
    local initPos2 = initPos -- Salva posição para coluna da direita
    
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("STEERING"))
    
    initPos = initPos + 25; 
    if toggleButton.main("gear", vec2(20,initPos), pedalsSettings.store.gearActive, language.get("GEAR")) then
        pedalsSettings.store.gearActive = not pedalsSettings.store.gearActive
    end
    
    initPos = initPos + 25; 
    if toggleButton.main("speed",vec2(20,initPos), pedalsSettings.store.speedActive, language.get("SPEED")) then
        pedalsSettings.store.speedActive = not pedalsSettings.store.speedActive
    end
    
    initPos = initPos + 25;
    if toggleButton.main("wheel", vec2(20,initPos), pedalsSettings.store.wheelActive, language.get("WHEEL")) then
        pedalsSettings.store.wheelActive = not pedalsSettings.store.wheelActive
    end
    if pedalsSettings.store.wheelActive then
        pedalsSettings.store.wheelType = droplist.main("##wheelType", "", vec2(110, initPos - 2), 100, pedalsSettings.store.wheelType, wheelLabels, droplist.PosText.Start)
    end
    
    initPos = initPos + 25; 
    if toggleButton.main("abs", vec2(20,initPos), pedalsSettings.store.absActive, language.get("ABS")) then
        pedalsSettings.store.absActive = not pedalsSettings.store.absActive
    end
    -- Alerta do ABS
    if CAR.absModes == 0 then
        ui.setCursor(vec2(100, initPos))
        ui.dwriteTextAligned(language.get("ALERT_ABS"), 12, ui.Alignment.Center, ui.Alignment.Center, vec2(180, 20), false, COLOR.RED)  
    end

    initPos = initPos + 25; 
    if toggleButton.main("tc", vec2(20, initPos), pedalsSettings.store.tractionControlActive, language.get("TC")) then
        pedalsSettings.store.tractionControlActive = not pedalsSettings.store.tractionControlActive
    end

    if CAR.tractionControlModes == 0 then
        ui.setCursor(vec2(200, initPos))
        ui.dwriteTextAligned(language.get("ALERT_TC"), 12, ui.Alignment.Center, ui.Alignment.Center, vec2(250, 20), false, COLOR.RED)  
    end

    initPos = initPos + 50
    ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), COLOR.GRAY, 1)

    -- OUTROS
    local posRPMpedalsSettings = initPos2
    ui.setCursor(vec2(posXOthers - 5, initPos2))
    ui.header(language.get("OTHERS"))
  
    initPos2 = initPos2 + 25; 
    if toggleButton.main("fuel", vec2(posXOthers,initPos2), pedalsSettings.store.fuelActive, language.get("FUEL")) then
        pedalsSettings.store.fuelActive = not pedalsSettings.store.fuelActive
    end
    
    initPos2 = initPos2 + 25; 
    if toggleButton.main("brakeBias", vec2(posXOthers,initPos2), pedalsSettings.store.brakeBiasActive, language.get("BRAKE_BIAS")) then
        pedalsSettings.store.brakeBiasActive = not pedalsSettings.store.brakeBiasActive
    end
    -- 

    -- RPM
    ui.setCursor(vec2(posXRPMpedalsSettings - 5, posRPMpedalsSettings))
    ui.header("RPM")
    
    posRPMpedalsSettings = posRPMpedalsSettings + 25
    if toggleButton.main("rpm",vec2(posXRPMpedalsSettings,posRPMpedalsSettings), pedalsSettings.store.rpmActive, "") then
        pedalsSettings.store.rpmActive = not pedalsSettings.store.rpmActive
    end

    if pedalsSettings.store.rpmActive then

        local exampleRPpedalsSettingsX = posXRPMpedalsSettings + 70   
        local exampleRPpedalsSettingsY = 158
        
        posRPMpedalsSettings = posRPMpedalsSettings + 30

        pedalsSettings.store.rpmType = droplist.main("##rpmType", language.get("TYPE"), vec2(posXRPMpedalsSettings, posRPMpedalsSettings + 5), 160, pedalsSettings.store.rpmType, rpmLabels, droplist.PosText.Start)

        if pedalsSettings.store.rpmType == 1 then

            posRPMpedalsSettings = posRPMpedalsSettings + 40
            pedalsSettings.store.rpmProcessType = droplist.main("##progress", language.get("PROGRESS"), vec2(posXRPMpedalsSettings, posRPMpedalsSettings), 100, pedalsSettings.store.rpmProcessType, processCircleType, droplist.PosText.Start)

            for i = 1, 9 do
                local c1, c2, c3 = COLOR.GREEN, COLOR.GREEN, COLOR.GREEN
                
                if pedalsSettings.store.rpmProcessType == 1 then
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
            pedalsSettings.store.numLights = math.floor(slider.main(language.get("NUM_LIGHTS"), string.format("%i", pedalsSettings.store.numLights), vec2(posXRPMpedalsSettings, posRPMpedalsSettings + 10), 135, pedalsSettings.store.numLights, 6, 25, slider.PosText.Start))

        elseif pedalsSettings.store.rpmType == 2 then
            posRPMpedalsSettings = posRPMpedalsSettings + 35
        
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 35), vec2(exampleRPpedalsSettingsX + 93, exampleRPpedalsSettingsY - 25), COLOR.GRAY_BG, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 35), vec2(exampleRPpedalsSettingsX - 5 + (98 * 0.45), exampleRPpedalsSettingsY - 25), COLOR.GREEN, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 20), vec2(exampleRPpedalsSettingsX + 93, exampleRPpedalsSettingsY - 10), COLOR.GRAY_BG, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 20), vec2(exampleRPpedalsSettingsX - 5 + (98 * 0.75), exampleRPpedalsSettingsY - 10), COLOR.YELLOW, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 5), vec2(exampleRPpedalsSettingsX + 93, exampleRPpedalsSettingsY + 5), COLOR.GRAY_BG, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 5), vec2(exampleRPpedalsSettingsX - 5 + (98), exampleRPpedalsSettingsY + 5), COLOR.RED, 10)
            
            pedalsSettings.store.barLength = slider.main(language.get("PERCENTAGE"), string.format("%.0f", (pedalsSettings.store.barLength+ 0.05) * 100) .. "%", vec2(posXRPMpedalsSettings, posRPMpedalsSettings + 10), 130, pedalsSettings.store.barLength, 0.25, 0.95, slider.PosText.Start)
        end
        --
    end
    --  

    -- PEDAIS
    initPos = initPos + 10
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("PEDALS"))

    initPos = initPos + 25; 
    if toggleButton.main("throttle", vec2(20,initPos), pedalsSettings.store.throttleActive, language.get("THROTTLE")) then
        pedalsSettings.store.throttleActive = not pedalsSettings.store.throttleActive
    end

    ui.setCursor(vec2(posXStyle - 5, initPos - 25))
    ui.header(language.get("PEDAL_STYLE"))
    if toggleButton.main("percentagePedals", vec2(posXStyle,initPos), pedalsSettings.store.textBarsActive, language.get("PERCENTAGE_PEDALS")) then
        pedalsSettings.store.textBarsActive = not pedalsSettings.store.textBarsActive
    end

    initPos = initPos + 25
    if toggleButton.main("limitLines", vec2(posXStyle,initPos), pedalsSettings.store.pedalLimitsLines, language.get("LIMIT_LINES")) then
        pedalsSettings.store.pedalLimitsLines = not pedalsSettings.store.pedalLimitsLines
    end

    ui.setCursor(vec2(20, initPos))
    if toggleButton.main("brake", vec2(20,initPos), pedalsSettings.store.brakeActive, language.get("BRAKE")) then
        pedalsSettings.store.brakeActive = not pedalsSettings.store.brakeActive
    end
    
    initPos = initPos + 25; 
    if toggleButton.main("clutch", vec2(20,initPos), pedalsSettings.store.clutchActive, language.get("CLUTCH")) then
        pedalsSettings.store.clutchActive = not pedalsSettings.store.clutchActive
    end
    
    initPos = initPos + 25; 
    if toggleButton.main("handbrake", vec2(20,initPos), pedalsSettings.store.handbrakeActive, language.get("HANDBRAKE")) then
        pedalsSettings.store.handbrakeActive = not pedalsSettings.store.handbrakeActive
    end
    --
    -- Botão Reset
    initPos = initPos + 40
    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return pedalsSettings