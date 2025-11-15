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
    textBarsActive = true,
    fuelActive = true,
    pedalLimitsLines = false,
    rpmActive = true,
    rpmType = "default",
    numCircles = 9,
    barLength = 0.55
}

WindowPedalsScale = pedalsSettingsStore.windowPedalsScale
GearActive = pedalsSettingsStore.gearActive
SpeedActive = pedalsSettingsStore.speedActive
WheelActive = pedalsSettingsStore.wheelActive
ABSActive = pedalsSettingsStore.ABSActive
AcceleratorActive = pedalsSettingsStore.acceleratorActive
BrakeActive = pedalsSettingsStore.brakeActive
BrakeBiasActive = pedalsSettingsStore.breakeBiasActive
ClutchActive = pedalsSettingsStore.clutchActive
HandbrakeActive = pedalsSettingsStore.handbrakeActive
TextBarsActive = pedalsSettingsStore.textBarsActive
FuelActive = pedalsSettingsStore.fuelActive
PedalLimitsLines = pedalsSettingsStore.pedalLimitsLines
RpmActive = pedalsSettingsStore.rpmActive
RpmType = pedalsSettingsStore.rpmType
NumCircles = pedalsSettingsStore.numCircles
BarLength = pedalsSettingsStore.barLength


local function resetToDefault()
    WindowPedalsScale = 1
    GearActive = true
    SpeedActive = true
    WheelActive = true
    ABSActive = true
    AcceleratorActive = true
    BrakeActive = true
    BrakeBiasActive = true
    ClutchActive = true
    HandbrakeActive = false
    TextBarsActive = true
    FuelActive = true
    PedalLimitsLines = false
    RpmActive = true
    RpmType = "default"
    NumCircles = 9
    BarLength = 0.5

    pedalsSettingsStore.windowPedalsScale = WindowPedalsScale
    pedalsSettingsStore.gearActive = GearActive
    pedalsSettingsStore.speedActive = SpeedActive
    pedalsSettingsStore.wheelActive = WheelActive
    pedalsSettingsStore.ABSActive = ABSActive
    pedalsSettingsStore.acceleratorActive = AcceleratorActive
    pedalsSettingsStore.brakeActive = BrakeActive
    pedalsSettingsStore.breakeBiasActive = BrakeBiasActive
    pedalsSettingsStore.clutchActive = ClutchActive
    pedalsSettingsStore.handbrakeActive = HandbrakeActive
    pedalsSettingsStore.textBarsActive = TextBarsActive
    pedalsSettingsStore.fuelActive = FuelActive
    pedalsSettingsStore.pedalLimitsLines = PedalLimitsLines
    pedalsSettingsStore.rpmActive = RpmActive
    pedalsSettingsStore.rpmType = RpmType
    pedalsSettingsStore.numCircles = NumCircles
    BarLength = pedalsSettingsStore.barLength
end

function pedalsSettings.pedalsSettings()
    local rpm = {
        ["default"] = language.get("DEFAULT"),
        ["dots-2"] = "Dots 2",
        ["bar"] = language.get("BAR")
    }
    local initPos = 55
    local posXOthers = 200
    local posXStyle = 150
    local initPos2
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    WindowPedalsScale = math.floor(ui.slider("##Size", WindowPedalsScale, 0.7, 3, string.format("%.2f", WindowPedalsScale)) * 100 + 0.5) / 100;
    pedalsSettingsStore.windowPedalsScale = WindowPedalsScale

    initPos = initPos + 35
    ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), COLOR.GRAY, 1)
    -- Direção:
    initPos = initPos + 10
    initPos2 = initPos
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("STEERING"))

    
    initPos = initPos + 25
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("GEAR"), GearActive) then
        GearActive = not GearActive
        pedalsSettingsStore.gearActive= GearActive
    end

    initPos = initPos + 25
    ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("SPEED"), SpeedActive) then
        SpeedActive = not SpeedActive
        pedalsSettingsStore.speedActive = SpeedActive
    end

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
        ui.dwriteTextAligned(language.get("ALERT_ABS"), 10, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 25), false, COLOR.RED)  
    end

    initPos = initPos + 35
    ui.drawRectFilled(vec2(5, initPos), vec2(WindowSettingsSize.x - 5, initPos), COLOR.GRAY, 1)
    --
    
    -- OUTROS:
    ui.setCursor(vec2(posXOthers - 5, initPos2))
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

    initPos2 = initPos2 + 25
    ui.setCursor(vec2(posXOthers, initPos2))
    if ui.checkbox("RPM", RpmActive) then
        RpmActive = not RpmActive
        pedalsSettingsStore.rpmActive = RpmActive
    end

    if RpmActive then
        ui.setCursor(vec2(posXOthers + 60, initPos2 + 2))
        ui.setNextItemWidth(100)
        ui.combo('##rpmType', rpm[RpmType], function ()
            if ui.selectable(rpm["default"]) then
                RpmType = "default"
                pedalsSettingsStore.rpmType = RpmType
            end
            if ui.selectable(rpm["dots-2"]) then
                RpmType = "dots-2"
                pedalsSettingsStore.rpmType = RpmType
            end
            if ui.selectable(rpm["bar"]) then
                RpmType = "bar"
                pedalsSettingsStore.rpmType = RpmType
            end
        end)
        if RpmType == "default" or RpmType == "dots-2" then
            ui.setCursor(vec2(posXOthers, initPos2 + 30))
            ui.setNextItemWidth(160)
            NumCircles = math.floor(ui.slider("##NumCircles", NumCircles, 5, 15, string.format("%i", NumCircles)))
        elseif RpmType == "bar" then
            ui.setCursor(vec2(posXOthers, initPos2 + 30))
            ui.setNextItemWidth(160)
            BarLength = ui.slider("##BarLength", BarLength, 0.2, 0.95, (string.format("%.2f", BarLength) + 0.05) * 100 )
        end
    end

    --

    -- Pedais:
    initPos = initPos + 10
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("PEDALS"))

    initPos = initPos + 25
     ui.setCursor(vec2(20, initPos))
    if ui.checkbox(language.get("THROTTLE"), AcceleratorActive) then
        AcceleratorActive = not AcceleratorActive
        pedalsSettingsStore.acceleratorActive = AcceleratorActive
    end

    --- Estilo dos pedais
    ui.setCursor(vec2(posXStyle - 5, initPos -25))
    ui.header(language.get("PEDAL_STYLE"))
    ui.setCursor(vec2(posXStyle, initPos))
    if ui.checkbox(language.get("PERCENTAGE"), TextBarsActive) then
        TextBarsActive = not TextBarsActive
        pedalsSettingsStore.textBarsActive = TextBarsActive
    end

    initPos = initPos + 25
    ui.setCursor(vec2(posXStyle, initPos))
    if ui.checkbox(language.get("LIMIT_LINES"), PedalLimitsLines) then
        PedalLimitsLines = not PedalLimitsLines
        pedalsSettingsStore.pedalLimitsLines = PedalLimitsLines
    end
    ---

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

    initPos = initPos + 40
    ui.setCursor(vec2(20, initPos))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return pedalsSettings