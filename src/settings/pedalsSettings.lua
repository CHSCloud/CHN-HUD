require("lang.language")

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

local function geral()
    ui.setCursor(vec2(10, 75))
    ui.header(Language.get("SIZE"), {fontSize = 100})
    ui.setCursor(vec2(10, 95))
    WindowPedalsScale = ui.slider("##Size", WindowPedalsScale, 0.7, 3, string.format("%.2f", WindowPedalsScale));
    pedalsSettingsStore.windowPedalsScale = WindowPedalsScale
end

local function content()
    -- Direção:
    ui.setCursor(vec2(20, 75))
    ui.header(Language.get("STEERING"))

    ui.setCursor(vec2(20, 100))
    if ui.checkbox(Language.get("WHEEL"), WheelActive) then
        WheelActive = not WheelActive
        pedalsSettingsStore.wheelActive = WheelActive
    end

    ui.setCursor(vec2(20, 125))
    if ui.checkbox(Language.get("ABS"), ABSActive) then
        ABSActive = not ABSActive
        pedalsSettingsStore.ABSActive = ABSActive
    end
    --

    -- Pedais:
    ui.setCursor(vec2(20, 155))
    ui.header(Language.get("PEDALS"))

    ui.setCursor(vec2(20, 175))
    if ui.checkbox(Language.get("THROTTLE"), AcceleratorActive) then
        AcceleratorActive = not AcceleratorActive
        pedalsSettingsStore.acceleratorActive = AcceleratorActive
    end

    ui.setCursor(vec2(20, 200))
    if ui.checkbox(Language.get("BRAKE"), BrakeActive) then
        BrakeActive = not BrakeActive
        pedalsSettingsStore.brakeActive = BrakeActive
    end

    ui.setCursor(vec2(135, 215))
    if ui.checkbox(Language.get("PERCENTAGE"), TextBarsActive) then
        TextBarsActive = not TextBarsActive
        pedalsSettingsStore.textBarsActive = TextBarsActive
    end

    ui.setCursor(vec2(20, 225))
    if ui.checkbox(Language.get("CLUTCH"), ClutchActive) then
        ClutchActive = not ClutchActive
        pedalsSettingsStore.clutchActive = ClutchActive
    end

    ui.setCursor(vec2(20, 250))
    if ui.checkbox(Language.get("HANDBRAKE"), HandbrakeActive) then
        HandbrakeActive = not HandbrakeActive
        pedalsSettingsStore.handbrakeActive = HandbrakeActive
    end
    --
    
    ui.setCursor(vec2(20, 285))
    ui.header(Language.get("OTHERS"))
  
    ui.setCursor(vec2(20, 310))
    if ui.checkbox(Language.get("FUEL"), FuelActive) then
        FuelActive = not FuelActive
        pedalsSettingsStore.fuelActive = FuelActive
    end

    ui.setCursor(vec2(20, 335))
    if ui.checkbox(Language.get("BRAKE_BIAS"), BrakeBiasActive) then
        BrakeBiasActive = not BrakeBiasActive
        pedalsSettingsStore.breakeBiasActive = BrakeBiasActive
    end

    -- Alerta do ABS
    if CAR.absModes == 0 then
        ui.setCursor(vec2(70, 120))
        ui.dwriteTextAligned(Language.get("ALERT_ABS"), 10, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 35), false, rgbm(255, 0, 0, 1))  
    end
end
--

function pedalsSettings.pedalsSettings()
    ui.setCursor(vec2(0, 45))
    ui.tabBar('##ID',function ()
        ui.tabItem(Language.get("GENERAL"), geral)
        ui.tabItem(Language.get("ELEMENTS"), content)
    end)
end

return pedalsSettings