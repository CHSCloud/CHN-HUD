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
    brakebiasPos = 3,

    p2pActive = false,
    p2pPos = 6,

    clutchActive = true,
    handbrakeActive = false,
    textBarsActive = false,

    fuelActive = true,
    fuelPos = 4,

    pedalLimitsLines = true,
    rpmActive = true,
    wheelType = 1,

    rpmPos = 5,
    rpmType = 1,
    rpmProcessType = 1,
    numLights = 9,
    barLength = 0.55
}

pedalsSettings.store = ac.storage(defaultValues)

local positionsKeysBorders = {}
local positionsKeysCenter = {}

local positionsBorders = {
    "TOP LEFT",
    "TOP RIGHT",
    "BOTTOM LEFT",
    "BOTTOM RIGHT"
}
local positionsCenters = {
    [5] = "TOP CENTER",
    [6] = "BOTTOM CENTER"
}

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        pedalsSettings.store[key] = value
    end
end

local function invertPositionBorder(oldPos, newPos, keyPos)
    for key, value in pairs(positionsKeysBorders) do
        if key ~= keyPos then
            if value == newPos then
                pedalsSettings.store[key] = oldPos
                positionsKeysBorders[key] = oldPos
            end
        end
    end
end

local function invertPositionCenter(oldPos, newPos, keyPos)
    for key, value in pairs(positionsKeysCenter) do
        if key ~= keyPos then
            if value == newPos then
                pedalsSettings.store[key] = oldPos
                positionsKeysCenter[key] = oldPos
            end
        end
    end
end

-- Desenha a seção de outros
--- @param pos vec2
local function drawOthers(pos)
    ui.setCursor(vec2(pos.x - 5, pos.y))
    ui.header(language.get("OTHERS"))
  
    pos.y = pos.y + 25; 
    if toggleButton.main("fuel", vec2(pos.x, pos.y), pedalsSettings.store.fuelActive, language.get("FUEL")) then
        pedalsSettings.store.fuelActive = not pedalsSettings.store.fuelActive
    end
    if pedalsSettings.store.fuelActive then
        local old = pedalsSettings.store.fuelPos
        pedalsSettings.store.fuelPos = droplist.main("##fuelPos", "", vec2(pos.x + 130, pos.y - 2), 150, pedalsSettings.store.fuelPos, positionsBorders, droplist.PosText.Start)
        if pedalsSettings.store.fuelPos ~= old then
            invertPositionBorder(old, pedalsSettings.store.fuelPos, "fuelPos")
        end
    end
    
    pos.y = pos.y + 30; 
    if toggleButton.main("brakeBias", vec2(pos.x, pos.y), pedalsSettings.store.brakeBiasActive, language.get("BRAKE_BIAS")) then
        pedalsSettings.store.brakeBiasActive = not pedalsSettings.store.brakeBiasActive
    end
    if pedalsSettings.store.brakeBiasActive then
        local old = pedalsSettings.store.brakebiasPos
        pedalsSettings.store.brakebiasPos = droplist.main("##brakebiasPos", "", vec2(pos.x + 200, pos.y - 2), 150, pedalsSettings.store.brakebiasPos, positionsBorders, droplist.PosText.Start)
        if pedalsSettings.store.brakebiasPos ~= old then
            invertPositionBorder(old, pedalsSettings.store.brakebiasPos, "brakebiasPos")
        end
    end
    pos.y = pos.y + 30; 
    if toggleButton.main("battery", vec2(pos.x, pos.y), pedalsSettings.store.p2pActive, "P2P") then
        pedalsSettings.store.p2pActive = not pedalsSettings.store.p2pActive
    end
    if pedalsSettings.store.p2pActive then
        local old = pedalsSettings.store.p2pPos
        pedalsSettings.store.p2pPos = droplist.main("##p2pPos", "", vec2(pos.x + 70, pos.y - 2), 150, pedalsSettings.store.p2pPos, positionsCenters, droplist.PosText.Start)
        --ac.log(tostring(pedalsSettings.store.p2pPos))
        if pedalsSettings.store.p2pPos ~= old then
            invertPositionCenter(old, pedalsSettings.store.p2pPos, "p2pPos")
        end
    end
end

-- Desenha a seção de RPM
local function drawRPM(pos)
    --pedalsSettings.store.rpmPos = 5
    local rpmLabels = {
        language.get("SHIFT_LIGHTS"),
        language.get("BAR")
    }
    local processCircleType = {
        language.get("DEFAULT"),
        "Total"
    }

    ui.setCursor(vec2(pos.x - 5, pos.y))
    ui.header("RPM")
    
    pos.y = pos.y + 25
    if toggleButton.main("rpm",vec2(pos.x,pos.y), pedalsSettings.store.rpmActive, "") then
        pedalsSettings.store.rpmActive = not pedalsSettings.store.rpmActive
    end

    if pedalsSettings.store.rpmActive then

        local exampleRPpedalsSettingsX = pos.x + 70   
        local exampleRPpedalsSettingsY = pos.y + 20

        local old = pedalsSettings.store.rpmPos
        pedalsSettings.store.rpmPos = droplist.main("##rpmPos", "", vec2(pos.x + 200, pos.y), 150, pedalsSettings.store.rpmPos, positionsCenters, droplist.PosText.Start)
        --ac.log(tostring(pedalsSettings.store.rpmPos))
        if pedalsSettings.store.rpmPos ~= old then
            invertPositionCenter(old, pedalsSettings.store.rpmPos, "rpmPos")
        end
        
        pos.y = pos.y + 30

        pedalsSettings.store.rpmType = droplist.main("##rpmType", language.get("TYPE"), vec2(pos.x, pos.y + 5), 160, pedalsSettings.store.rpmType, rpmLabels, droplist.PosText.Start)

        if pedalsSettings.store.rpmType == 1 then

            pos.y = pos.y + 40
            pedalsSettings.store.rpmProcessType = droplist.main("##progress", language.get("PROGRESS"), vec2(pos.x, pos.y), 100, pedalsSettings.store.rpmProcessType, processCircleType, droplist.PosText.Start)
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

            pos.y = pos.y + 30
            pedalsSettings.store.numLights = math.floor(slider.main(language.get("NUM_LIGHTS"), string.format("%i", pedalsSettings.store.numLights), vec2(pos.x, pos.y + 10), 135, pedalsSettings.store.numLights, 6, 25, slider.PosText.Start))

        elseif pedalsSettings.store.rpmType == 2 then
            pos.y = pos.y + 35
        
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 35), vec2(exampleRPpedalsSettingsX + 93, exampleRPpedalsSettingsY - 25), COLOR.GRAY_BG, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 35), vec2(exampleRPpedalsSettingsX - 5 + (98 * 0.45), exampleRPpedalsSettingsY - 25), COLOR.GREEN, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 20), vec2(exampleRPpedalsSettingsX + 93, exampleRPpedalsSettingsY - 10), COLOR.GRAY_BG, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 20), vec2(exampleRPpedalsSettingsX - 5 + (98 * 0.75), exampleRPpedalsSettingsY - 10), COLOR.YELLOW, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 5), vec2(exampleRPpedalsSettingsX + 93, exampleRPpedalsSettingsY + 5), COLOR.GRAY_BG, 10)
            ui.drawRectFilled(vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 5), vec2(exampleRPpedalsSettingsX - 5 + (98), exampleRPpedalsSettingsY + 5), COLOR.RED, 10)
            
            pedalsSettings.store.barLength = slider.main(language.get("PERCENTAGE"), string.format("%.0f", (pedalsSettings.store.barLength+ 0.05) * 100) .. "%", vec2(pos.x, pos.y + 10), 130, pedalsSettings.store.barLength, 0.25, 0.95, slider.PosText.Start)
        end
        --
    end
end

function pedalsSettings.pedalsSettings()
    positionsKeysBorders = {
        brakebiasPos = pedalsSettings.store.brakebiasPos,
        fuelPos = pedalsSettings.store.fuelPos
    }
    positionsKeysCenter = {
        rpmPos = pedalsSettings.store.rpmPos
    }
    local wheelLabels = {
        "Iracing",
        language.get("SIMPLE")
    }

    -- Layout
    local initPos = 55
    local posXStyle = 150
    
    initPos = initPos + 20
    pedalsSettings.store.pedalsScale = slider.main(language.get("SIZE"), string.format("%.2f", pedalsSettings.store.pedalsScale), vec2(20, initPos), 250, pedalsSettings.store.pedalsScale, 0.7, 3)


    initPos = initPos + 35
    ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), COLOR.GRAY, 1)

    -- DIREÇÃO
    initPos = initPos + 10
    
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
    drawOthers(vec2(270, 120))

    -- RPM
    drawRPM(vec2(20, 300))

    -- PEDAIS
    initPos = 500
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