local language = require("lang.language")

local pedalsSettings = {}

local pedalsSettingsStore = ac.storage{
    windowPedalsScale = 1,
    gearActive = true,
    speedActive = true,
    wheelActive = true,
    ABSActive = true,
    acceleratorActive = true,
    brakeActive = true,
    breakeBiasActive = true,
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

pedalsSettings.scale = pedalsSettingsStore.windowPedalsScale
pedalsSettings.gearActive = pedalsSettingsStore.gearActive
pedalsSettings.speedActive = pedalsSettingsStore.speedActive
pedalsSettings.wheelActive = pedalsSettingsStore.wheelActive
pedalsSettings.absActive = pedalsSettingsStore.ABSActive
pedalsSettings.acceleratorActive = pedalsSettingsStore.acceleratorActive
pedalsSettings.brakeActive = pedalsSettingsStore.brakeActive
pedalsSettings.brakeBiasActive = pedalsSettingsStore.breakeBiasActive
pedalsSettings.clutchActive = pedalsSettingsStore.clutchActive
pedalsSettings.handbrakeActive = pedalsSettingsStore.handbrakeActive
pedalsSettings.textBarsActive = pedalsSettingsStore.textBarsActive
pedalsSettings.fuelActive = pedalsSettingsStore.fuelActive
pedalsSettings.pedalLimitsLines = pedalsSettingsStore.pedalLimitsLines
pedalsSettings.rpmActive = pedalsSettingsStore.rpmActive
pedalsSettings.rpmType = pedalsSettingsStore.rpmType
pedalsSettings.rpmProcessType = pedalsSettingsStore.rpmProcessType
pedalsSettings.numLights = pedalsSettingsStore.numLights
pedalsSettings.barLength = pedalsSettingsStore.barLength


local function resetToDefault()
    pedalsSettings.scale = 1
    pedalsSettings.gearActive = true
    pedalsSettings.speedActive = true
    pedalsSettings.wheelActive = true
    pedalsSettings.absActive = true
    pedalsSettings.acceleratorActive = true
    pedalsSettings.brakeActive = true
    pedalsSettings.brakeBiasActive = true
    pedalsSettings.clutchActive = true
    pedalsSettings.handbrakeActive = false
    pedalsSettings.textBarsActive = false
    pedalsSettings.fuelActive = true
    pedalsSettings.pedalLimitsLines = true
    pedalsSettings.rpmActive = true
    pedalsSettings.rpmType = "default"
    pedalsSettings.rpmProcessType = "default"
    pedalsSettings.numLights = 9
    pedalsSettings.barLength = 0.5

    pedalsSettingsStore.windowPedalsScale = pedalsSettings.scale
    pedalsSettingsStore.gearActive = pedalsSettings.gearActive
    pedalsSettingsStore.speedActive = pedalsSettings.speedActive
    pedalsSettingsStore.wheelActive = pedalsSettings.wheelActive
    pedalsSettingsStore.pedalsSettings.absActive = pedalsSettings.absActive
    pedalsSettingsStore.acceleratorActive = pedalsSettings.acceleratorActive
    pedalsSettingsStore.brakeActive = pedalsSettings.brakeActive
    pedalsSettingsStore.breakeBiasActive = pedalsSettings.brakeBiasActive
    pedalsSettingsStore.clutchActive = pedalsSettings.clutchActive
    pedalsSettingsStore.handbrakeActive = pedalsSettings.handbrakeActive
    pedalsSettingsStore.textBarsActive = pedalsSettings.textBarsActive
    pedalsSettingsStore.fuelActive = pedalsSettings.fuelActive
    pedalsSettingsStore.pedalLimitsLines = pedalsSettings.pedalLimitsLines
    pedalsSettingsStore.rpmActive = pedalsSettings.rpmActive
    pedalsSettingsStore.rpmType = pedalsSettings.rpmType
    pedalsSettingsStore.numLights = pedalsSettings.numLights
    pedalsSettingsStore.barLength = pedalsSettings.barLength
    pedalsSettingsStore.rpmProcessType = pedalsSettings.rpmProcessType
end

function pedalsSettings.pedalsSettings()
    local rpm = {
        ["default"] = language.get("SHIFT_LIGHTS"),
        ["bar"] = language.get("BAR")
    }
    local processCircleType = {
        ["default"] = language.get("DEFAULT"),
        ["total"] = "Total"
    }
    local initPos = 55
    local initPos2
    local posXOthers = 150
    local posXStyle = 150

    local posRPM = initPos
    local posXRPM = 330
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    pedalsSettings.scale = math.floor(ui.slider("##Size", pedalsSettings.scale, 0.7, 3, string.format("%.2f", pedalsSettings.scale)) * 100 + 0.5) / 100;
    pedalsSettingsStore.windowPedalsScale = pedalsSettings.scale

    initPos = initPos + 35
    ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), COLOR.GRAY, 1)
    -- Direção:
    initPos = initPos + 10
    initPos2 = initPos
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("STEERING"))

    
    initPos = initPos + 25
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("GEAR"), pedalsSettings.gearActive) then
        pedalsSettings.gearActive = not pedalsSettings.gearActive
        pedalsSettingsStore.gearActive= pedalsSettings.gearActive
    end

    initPos = initPos + 25
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("SPEED"), pedalsSettings.speedActive) then
        pedalsSettings.speedActive = not pedalsSettings.speedActive
        pedalsSettingsStore.speedActive = pedalsSettings.speedActive
    end

    initPos = initPos + 25
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("WHEEL"), pedalsSettings.wheelActive) then
        pedalsSettings.wheelActive = not pedalsSettings.wheelActive
        pedalsSettingsStore.wheelActive = pedalsSettings.wheelActive
    end

    initPos = initPos + 25
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("ABS"), pedalsSettings.absActive) then
        pedalsSettings.absActive = not pedalsSettings.absActive
        pedalsSettingsStore.pedalsSettings.absActive = pedalsSettings.absActive
    end
    -- Alerta do ABS
    if CAR.absModes == 0 then
        ui.setCursor(vec2(70, initPos))
        ui.dwriteTextAligned(language.get("ALERT_ABS"), 10, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 25), false, COLOR.RED)  
    end

    initPos = initPos + 50
    ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), COLOR.GRAY, 1)
    --
    
    -- OUTROS:
    posRPM = initPos2
    ui.setCursor(vec2(posXOthers - 5, initPos2))
    ui.header(language.get("OTHERS"))
  
    initPos2 = initPos2 + 25
    ui.setCursor(vec2(posXOthers, initPos2))
    if ui.checkbox(language.get("FUEL"), pedalsSettings.fuelActive) then
        pedalsSettings.fuelActive = not pedalsSettings.fuelActive
        pedalsSettingsStore.fuelActive = pedalsSettings.fuelActive
    end

    initPos2 = initPos2 + 25
    ui.setCursor(vec2(posXOthers, initPos2))
    if ui.checkbox(language.get("BRAKE_BIAS"), pedalsSettings.brakeBiasActive) then
        pedalsSettings.brakeBiasActive = not pedalsSettings.brakeBiasActive
        pedalsSettingsStore.breakeBiasActive = pedalsSettings.brakeBiasActive
    end

    ui.setCursor(vec2(posXRPM - 5, posRPM))
    ui.header("RPM")
    posRPM = posRPM + 25
    ui.setCursor(vec2(posXRPM, posRPM))
    if ui.checkbox("RPM", pedalsSettings.rpmActive) then
        pedalsSettings.rpmActive = not pedalsSettings.rpmActive
        pedalsSettingsStore.rpmActive = pedalsSettings.rpmActive
    end

    if pedalsSettings.rpmActive then
        local exampleRPMX = 420
        local exampleRPMY = 158
        local color1
        local color2
        local color3
        posRPM = posRPM + 30
        ui.setCursor(vec2(posXRPM, posRPM + 5))
        ui.header("Type")
        ui.setCursor(vec2(posXRPM + 30, posRPM))
        ui.setNextItemWidth(140)
        ui.combo('##rpmType', rpm[pedalsSettings.rpmType], function ()
            if ui.selectable(rpm["default"]) then
                pedalsSettings.rpmType = "default"
                pedalsSettingsStore.rpmType = pedalsSettings.rpmType
            end
            if ui.selectable(rpm["bar"]) then
                pedalsSettings.rpmType = "bar"
                pedalsSettingsStore.rpmType = pedalsSettings.rpmType
            end
        end)
        if pedalsSettings.rpmType == "default" then
            posRPM = posRPM + 35
            ui.setCursor(vec2(posXRPM, posRPM))
            ui.header("Progress")
            ui.setCursor(vec2(posXRPM + 50, posRPM - 5))
            ui.setNextItemWidth(100)
            ui.combo('##progress', processCircleType[pedalsSettings.rpmProcessType], function ()
                if ui.selectable(processCircleType["default"]) then
                    pedalsSettings.rpmProcessType = "default"
                    pedalsSettingsStore.rpmProcessType = pedalsSettings.rpmProcessType
                end
                if ui.selectable(processCircleType["total"]) then
                    pedalsSettings.rpmProcessType = "total"
                    pedalsSettingsStore.rpmProcessType = pedalsSettings.rpmProcessType
                end
            end)

            if pedalsSettings.rpmProcessType == "default" then
                for i = 1, 9, 1 do
                    color1 = COLOR.GREEN
                    color2 = COLOR.GREEN
                    color3 = COLOR.GREEN
                    if i > 7 then
                        color1 = COLOR.GRAY_BG
                        color2 = COLOR.GRAY_BG
                        color3 = COLOR.RED_DARK
                    elseif i > 4 then
                        color1 = COLOR.GRAY_BG
                        color2 = COLOR.YELLOW
                        color3 = COLOR.YELLOW
                    end
                    ui.drawCircleFilled(vec2(exampleRPMX, exampleRPMY - 30), 5, color1, 20)
                    ui.drawCircleFilled(vec2(exampleRPMX, exampleRPMY - 15), 5, color2, 20)
                    ui.drawCircleFilled(vec2(exampleRPMX, exampleRPMY), 5, color3, 20)
                    exampleRPMX = exampleRPMX + 11
                end
            elseif pedalsSettings.rpmProcessType == "total" then
                for i = 1, 9, 1 do
                    color1 = COLOR.GREEN
                    color2 = COLOR.YELLOW
                    color3 = COLOR.RED_DARK
                    if i > 7 then
                        color1 = COLOR.GRAY_BG
                        color2 = COLOR.GRAY_BG
                    elseif i > 4 then
                        color1 = COLOR.GRAY_BG
                    end
                    ui.drawCircleFilled(vec2(exampleRPMX, exampleRPMY - 30), 5, color1, 20)
                    ui.drawCircleFilled(vec2(exampleRPMX, exampleRPMY - 15), 5, color2, 20)
                    ui.drawCircleFilled(vec2(exampleRPMX, exampleRPMY), 5, color3, 20)
                    exampleRPMX = exampleRPMX + 11
                end
            end
            

            posRPM = posRPM + 30
            ui.setCursor(vec2(posXRPM, posRPM))
            ui.header(language.get("NUM_LIGHTS"))
            ui.setCursor(vec2(posXRPM + 90, posRPM - 5))
            ui.setNextItemWidth(160)
            pedalsSettings.numLights = math.floor(ui.slider("##pedalsSettings.numLights", pedalsSettings.numLights, 6, 25, string.format("%i", pedalsSettings.numLights)))
        elseif pedalsSettings.rpmType == "bar" then
            posRPM = posRPM + 35
            ui.setCursor(vec2(posXRPM, posRPM))
            ui.header("Percentage")
            
            ui.drawRectFilled(vec2(exampleRPMX - 5, exampleRPMY - 35), vec2(exampleRPMX - 5 + 98, exampleRPMY - 25), COLOR.GRAY_BG, 10)
            ui.drawRectFilled(vec2(exampleRPMX - 5, exampleRPMY - 35), vec2(exampleRPMX - 5 + (98 * 0.45), exampleRPMY - 25), COLOR.GREEN, 10)

            ui.drawRectFilled(vec2(exampleRPMX - 5, exampleRPMY - 20), vec2(exampleRPMX - 5 + 98, exampleRPMY - 10), COLOR.GRAY_BG, 10)
            ui.drawRectFilled(vec2(exampleRPMX - 5, exampleRPMY - 20), vec2(exampleRPMX - 5 + (98 * 0.70), exampleRPMY - 10), COLOR.YELLOW, 10)
            ui.drawRectFilled(vec2(exampleRPMX - 5, exampleRPMY - 5), vec2(exampleRPMX - 5 + 98, exampleRPMY + 5), COLOR.RED_DARK, 10)
            ui.setCursor(vec2(posXRPM + 70, posRPM - 5))
            ui.setNextItemWidth(160)
            pedalsSettings.barLength = ui.slider("##pedalsSettings.barLength", pedalsSettings.barLength, 0.25, 0.95, string.format("%.0f%%", (pedalsSettings.barLength+ 0.05) * 100) .. "%")
        end
        
        
    end
    --

    -- Pedais:
    initPos = initPos + 10
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("PEDALS"))

    initPos = initPos + 25
     ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("THROTTLE"), pedalsSettings.acceleratorActive) then
        pedalsSettings.acceleratorActive = not pedalsSettings.acceleratorActive
        pedalsSettingsStore.acceleratorActive = pedalsSettings.acceleratorActive
    end

    --- Estilo dos pedais
    ui.setCursor(vec2(posXStyle - 5, initPos -25))
    ui.header(language.get("PEDAL_STYLE"))
    ui.setCursor(vec2(posXStyle, initPos))
    if ui.checkbox(language.get("PERCENTAGE"), pedalsSettings.textBarsActive) then
        pedalsSettings.textBarsActive = not pedalsSettings.textBarsActive
        pedalsSettingsStore.textBarsActive = pedalsSettings.textBarsActive
    end

    initPos = initPos + 25
    ui.setCursor(vec2(posXStyle, initPos))
    if ui.checkbox(language.get("LIMIT_LINES"), pedalsSettings.pedalLimitsLines) then
        pedalsSettings.pedalLimitsLines = not pedalsSettings.pedalLimitsLines
        pedalsSettingsStore.pedalLimitsLines = pedalsSettings.pedalLimitsLines
    end
    ---

    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("BRAKE"), pedalsSettings.brakeActive) then
        pedalsSettings.brakeActive = not pedalsSettings.brakeActive
        pedalsSettingsStore.brakeActive = pedalsSettings.brakeActive
    end
    initPos = initPos + 25
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("CLUTCH"), pedalsSettings.clutchActive) then
        pedalsSettings.clutchActive = not pedalsSettings.clutchActive
        pedalsSettingsStore.clutchActive = pedalsSettings.clutchActive
    end

    initPos = initPos + 25
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("HANDBRAKE"), pedalsSettings.handbrakeActive) then
        pedalsSettings.handbrakeActive = not pedalsSettings.handbrakeActive
        pedalsSettingsStore.handbrakeActive = pedalsSettings.handbrakeActive
    end
    --

    initPos = initPos + 40
    ui.setCursor(vec2(20, initPos))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return pedalsSettings