require("lang.language")
local settings = {}

local languages = {
  ["en"] = { name = "English", code = "en" },
  ["pt-br"] = { name = "Português - Brasil", code = "pt-br" }
}

local settingsStorage = ac.storage{
    hudScale = 1,
    wheelActive = true,
    ABSActive = true,
    acceleratorActive = true,
    brakeActive = true,
    breakeBiasActive = true,
    handbrakeActive = false,
    textBarsActive = true,
    clutchActive = true,
    fuelActive = true,
    optionLanguage = languages.en.code,
    selectedSpeed = 1
}

HudScale = settingsStorage.hudScale
WheelActive = settingsStorage.wheelActive
ABSActive = settingsStorage.ABSActive
AcceleratorActive = settingsStorage.acceleratorActive
BrakeActive = settingsStorage.brakeActive
BrakeBiasActive = settingsStorage.breakeBiasActive
ClutchActive = settingsStorage.clutchActive
FuelActive = settingsStorage.fuelActive
TextBarsActive = settingsStorage.textBarsActive
OptionLanguage  = Language.getCurrentLanguage()
SelectedSpeed = settingsStorage.selectedSpeed
HandbrakeActive = settingsStorage.handbrakeActive

SIM = ac.getSim()
CAR = ac.getCar(SIM.focusedCar)

-- Escolher Idioma:
local function setLanguage()
    ui.setCursor(vec2(10, 50))
    ui.header(Language.get("LANGUAGE"))
    ui.setCursor(vec2(10, 70))
    
    ui.combo('##resolution', languages[OptionLanguage].name, function ()
      if ui.selectable(languages["en"].name) then
        OptionLanguage = languages["en"].code
      end
  
      if ui.selectable(languages["pt-br"].name) then
        OptionLanguage = languages["pt-br"].code
      end
    end)

    ui.setCursor(vec2(10,100))
    if ui.button(Language.get("APPLY")) then
      Language.setLanguage(OptionLanguage)
      Language.loadTranslations()
    end
end

local function content()
    -- Direção:
    ui.setCursor(vec2(20, 55))
    ui.header(Language.get("STEERING"))

    ui.setCursor(vec2(20, 80))
    if ui.checkbox(Language.get("WHEEL"), WheelActive) then
        WheelActive = not WheelActive
        settingsStorage.wheelActive = WheelActive
    end

    ui.setCursor(vec2(20, 105))
    if ui.checkbox(Language.get("ABS"), ABSActive) then
        ABSActive = not ABSActive
        settingsStorage.ABSActive = ABSActive
    end
    --

    -- Pedais:
    ui.setCursor(vec2(20, 135))
    ui.header(Language.get("PEDALS"))

    ui.setCursor(vec2(20, 155))
    if ui.checkbox(Language.get("THROTTLE"), AcceleratorActive) then
        AcceleratorActive = not AcceleratorActive
        settingsStorage.acceleratorActive = AcceleratorActive
    end

    ui.setCursor(vec2(20, 180))
    if ui.checkbox(Language.get("BRAKE"), BrakeActive) then
        BrakeActive = not BrakeActive
        settingsStorage.brakeActive = BrakeActive
    end

    ui.setCursor(vec2(135, 195))
    if ui.checkbox(Language.get("PERCENTAGE"), TextBarsActive) then
        TextBarsActive = not TextBarsActive
        settingsStorage.textBarsActive = TextBarsActive
    end

    ui.setCursor(vec2(20, 205))
    if ui.checkbox(Language.get("CLUTCH"), ClutchActive) then
        ClutchActive = not ClutchActive
        settingsStorage.clutchActive = ClutchActive
    end

    ui.setCursor(vec2(20, 230))
    if ui.checkbox(Language.get("HANDBRAKE"), HandbrakeActive) then
        HandbrakeActive = not HandbrakeActive
        settingsStorage.handbrakeActive = HandbrakeActive
    end
    --
    
    ui.setCursor(vec2(20, 265))
    ui.header(Language.get("OTHERS"))
  
    ui.setCursor(vec2(20, 290))
    if ui.checkbox(Language.get("FUEL"), FuelActive) then
        FuelActive = not FuelActive
        settingsStorage.fuelActive = FuelActive
    end

    ui.setCursor(vec2(20, 315))
    if ui.checkbox(Language.get("BRAKE_BIAS"), BrakeBiasActive) then
        BrakeBiasActive = not BrakeBiasActive
        settingsStorage.breakeBiasActive = BrakeBiasActive
    end

    -- Alerta do ABS
    if CAR.absModes == 0 then
        ui.setCursor(vec2(70, 100))
        ui.dwriteTextAligned(Language.get("ALERT_ABS"), 10, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 35), false, rgbm(255, 0, 0, 1))  
    end
end
--
  
local function geral()
    ui.setCursor(vec2(10, 50))
    ui.header(Language.get("SIZE"), {fontSize = 100})
    ui.setCursor(vec2(10, 70))
    HudScale = ui.slider("##Size", HudScale, 0.7, 3, string.format("%.2f", HudScale));
    settingsStorage.hudScale = HudScale
    
    ui.setCursor(vec2(10, 100))
    ui.header(Language.get("SPEED"))
    ui.setCursor(vec2(10, 120))
    SelectedSpeed = ui.combo("##Speed", SelectedSpeed , {"Km/h", "Mph"})
    settingsStorage.selectedSpeed = SelectedSpeed
end
  
function settings.windowMain()
    ui.drawRectFilled(vec2(0, 0), vec2(500, 500), rgbm(0, 0, 0, 0.70), 0)
    ui.tabBar('##ID',function ()
        ui.tabItem(Language.get("GENERAL"), geral)
        ui.tabItem(Language.get("ELEMENTS"), content)
        ui.tabItem(Language.get("LANGUAGE"), setLanguage)
    end)
end

return settings