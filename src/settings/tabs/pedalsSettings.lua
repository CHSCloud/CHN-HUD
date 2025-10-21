local language = require("lang.language")

local pedalsSettings = {}

local pedalsSettingsStore = ac.storage{
    windowPedalsScale = 1,
    wheelActive = true,
    ABSActive = true,
    acceleratorActive = true,
    brakeActive = true,
    breakeBiasActive = true,
    handbrakeActive = false,
    textBarsActive = true,
    clutchActive = true,
    fuelActive = true
}

WindowPedalsScale = pedalsSettingsStore.windowPedalsScale
WheelActive = pedalsSettingsStore.wheelActive
ABSActive = pedalsSettingsStore.ABSActive
AcceleratorActive = pedalsSettingsStore.acceleratorActive
BrakeActive = pedalsSettingsStore.brakeActive
BrakeBiasActive = pedalsSettingsStore.breakeBiasActive
ClutchActive = pedalsSettingsStore.clutchActive
FuelActive = pedalsSettingsStore.fuelActive
TextBarsActive = pedalsSettingsStore.textBarsActive
HandbrakeActive = pedalsSettingsStore.handbrakeActive


function pedalsSettings.pedalsSettings()
    local initPos = 55
    local initPos2
    ui.setCursor(vec2(10, initPos))
    ui.header(language.get("SIZE"))
    initPos = initPos + 20
    ui.setCursor(vec2(10, initPos))
    WindowPedalsScale = math.floor(ui.slider("##Size", WindowPedalsScale, 0.7, 3, string.format("%.2f", WindowPedalsScale)) * 100 + 0.5) / 100;
    pedalsSettingsStore.windowPedalsScale = WindowPedalsScale
    
    

    initPos = initPos + 35
    ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), rgbm.from0255(119, 118, 124, 0.3), 1)
    -- Direção:
    initPos = initPos + 10
    initPos2 = initPos
    ui.setCursor(vec2(20, initPos))
    ui.header(language.get("STEERING"))

    -- OUTROS:
    local posXOthers = 220
    ui.setCursor(vec2(posXOthers, initPos2))
    ui.header(language.get("OTHERS"))
  
    initPos2 = initPos2 + 25
    ui.setCursor(vec2(posXOthers, initPos2))
    if ui.checkbox(language.get("FUEL"), FuelActive) then
        FuelActive = not FuelActive
        pedalsSettingsStore.fuelActive = FuelActive
    end

    initPos2 = initPos2 + 25
    ui.setCursor(vec2(posXOthers, initPos2))
    if ui.checkbox(language.get("BRAKE_BIAS"), BrakeBiasActive) then
        BrakeBiasActive = not BrakeBiasActive
        pedalsSettingsStore.breakeBiasActive = BrakeBiasActive
    end
    --

    initPos = initPos + 25
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("WHEEL"), WheelActive) then
        WheelActive = not WheelActive
        pedalsSettingsStore.wheelActive = WheelActive
    end

    initPos = initPos + 25
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("ABS"), ABSActive) then
        ABSActive = not ABSActive
        pedalsSettingsStore.ABSActive = ABSActive
    end
    -- Alerta do ABS
    if CAR.absModes == 0 then
        ui.setCursor(vec2(70, initPos))
        ui.dwriteTextAligned(language.get("ALERT_ABS"), 10, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 25), false, rgbm(255, 0, 0, 1))  
    end

    initPos = initPos + 35
    ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), rgbm.from0255(119, 118, 124, 0.3), 1)

    -- Pedais:
    initPos = initPos + 10
    ui.setCursor(vec2(20, initPos))
    ui.header(language.get("PEDALS"))

    initPos = initPos + 30
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("PERCENTAGE"), TextBarsActive) then
        TextBarsActive = not TextBarsActive
        pedalsSettingsStore.textBarsActive = TextBarsActive
    end

    initPos = initPos + 25
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("THROTTLE"), AcceleratorActive) then
        AcceleratorActive = not AcceleratorActive
        pedalsSettingsStore.acceleratorActive = AcceleratorActive
    end

    initPos = initPos + 25
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("BRAKE"), BrakeActive) then
        BrakeActive = not BrakeActive
        pedalsSettingsStore.brakeActive = BrakeActive
    end

    initPos = initPos + 25
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("CLUTCH"), ClutchActive) then
        ClutchActive = not ClutchActive
        pedalsSettingsStore.clutchActive = ClutchActive
    end

    initPos = initPos + 25
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("HANDBRAKE"), HandbrakeActive) then
        HandbrakeActive = not HandbrakeActive
        pedalsSettingsStore.handbrakeActive = HandbrakeActive
    end
    --
    
end

return pedalsSettings