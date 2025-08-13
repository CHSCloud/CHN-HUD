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

WindowPedalsScale = settingsStorage.windowPedalsScale
WheelActive = settingsStorage.wheelActive
ABSActive = settingsStorage.ABSActive
AcceleratorActive = settingsStorage.acceleratorActive
BrakeActive = settingsStorage.brakeActive
BrakeBiasActive = settingsStorage.breakeBiasActive
ClutchActive = settingsStorage.clutchActive
FuelActive = settingsStorage.fuelActive
TextBarsActive = settingsStorage.textBarsActive
HandbrakeActive = settingsStorage.handbrakeActive

local function geral()
    ui.setCursor(vec2(10, 50))
    ui.header(Language.get("SIZE"), {fontSize = 100})
    ui.setCursor(vec2(10, 70))
    WindowPedalsScale = ui.slider("##Size", WindowPedalsScale, 0.7, 3, string.format("%.2f", WindowPedalsScale));
    pedalsSettingsStore.hudScale = WindowPedalsScale
end

local function content()
    -- Direção:
    ui.setCursor(vec2(20, 55))
    ui.header(Language.get("STEERING"))

    ui.setCursor(vec2(20, 80))
    if ui.checkbox(Language.get("WHEEL"), WheelActive) then
        WheelActive = not WheelActive
        pedalsSettingsStore.wheelActive = WheelActive
    end

    ui.setCursor(vec2(20, 105))
    if ui.checkbox(Language.get("ABS"), ABSActive) then
        ABSActive = not ABSActive
        pedalsSettingsStore.ABSActive = ABSActive
    end
    --

    -- Pedais:
    ui.setCursor(vec2(20, 135))
    ui.header(Language.get("PEDALS"))

    ui.setCursor(vec2(20, 155))
    if ui.checkbox(Language.get("THROTTLE"), AcceleratorActive) then
        AcceleratorActive = not AcceleratorActive
        pedalsSettingsStore.acceleratorActive = AcceleratorActive
    end

    ui.setCursor(vec2(20, 180))
    if ui.checkbox(Language.get("BRAKE"), BrakeActive) then
        BrakeActive = not BrakeActive
        pedalsSettingsStore.brakeActive = BrakeActive
    end

    ui.setCursor(vec2(135, 195))
    if ui.checkbox(Language.get("PERCENTAGE"), TextBarsActive) then
        TextBarsActive = not TextBarsActive
        pedalsSettingsStore.textBarsActive = TextBarsActive
    end

    ui.setCursor(vec2(20, 205))
    if ui.checkbox(Language.get("CLUTCH"), ClutchActive) then
        ClutchActive = not ClutchActive
        pedalsSettingsStore.clutchActive = ClutchActive
    end

    ui.setCursor(vec2(20, 230))
    if ui.checkbox(Language.get("HANDBRAKE"), HandbrakeActive) then
        HandbrakeActive = not HandbrakeActive
        pedalsSettingsStore.handbrakeActive = HandbrakeActive
    end
    --
    
    ui.setCursor(vec2(20, 265))
    ui.header(Language.get("OTHERS"))
  
    ui.setCursor(vec2(20, 290))
    if ui.checkbox(Language.get("FUEL"), FuelActive) then
        FuelActive = not FuelActive
        pedalsSettingsStore.fuelActive = FuelActive
    end

    ui.setCursor(vec2(20, 315))
    if ui.checkbox(Language.get("BRAKE_BIAS"), BrakeBiasActive) then
        BrakeBiasActive = not BrakeBiasActive
        pedalsSettingsStore.breakeBiasActive = BrakeBiasActive
    end

    -- Alerta do ABS
    if CAR.absModes == 0 then
        ui.setCursor(vec2(70, 100))
        ui.dwriteTextAligned(Language.get("ALERT_ABS"), 10, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 35), false, rgbm(255, 0, 0, 1))  
    end
end
--

function pedalsSettings.pedalsSettings()
    setCursor(vec2(0, 20))
    ui.tabBar('##ID',function ()
        ui.tabItem(Language.get("GENERAL"), geral)
        ui.tabItem(Language.get("ELEMENTS"), content)
    end)
end

return pedalsSettings