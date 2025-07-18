local languages = {
  ["en"] = { name = "English", code = "en" },
  ["pt-br"] = { name = "Português - Brasil", code = "pt-br" }
}

local settings = ac.storage{
    hudScale = 1,
    wheelActive = true,
    ABSActive = true,
    acceleratorActive = true,
    brakeActive = true,
    breakeBiasActive = true,
    clutchActive = true,
    fuelActive = true,
    optionLanguage = languages.en.code,
    selectedSpeed = 1
}

HudScale = settings.hudScale
WheelActive = settings.wheelActive
ABSActive = settings.ABSActive
AcceleratorActive = settings.acceleratorActive
BrakeActive = settings.brakeActive
BrakeBiasActive = settings.breakeBiasActive
ClutchActive = settings.clutchActive
FuelActive = settings.fuelActive
OptionLanguage  = Language.getCurrentLanguage()
SelectedSpeed = settings.selectedSpeed

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
        settings.wheelActive = WheelActive
    end

    ui.setCursor(vec2(20, 105))
    if ui.checkbox(Language.get("ABS"), ABSActive) then
        ABSActive = not ABSActive
        settings.ABSActive = ABSActive
    end
    --

    -- Pedais:
    ui.setCursor(vec2(20, 135))
    ui.header(Language.get("PEDALS"))

    ui.setCursor(vec2(20, 155))
    if ui.checkbox(Language.get("THROTTLE"), AcceleratorActive) then
        AcceleratorActive = not AcceleratorActive
        settings.acceleratorActive = AcceleratorActive
    end

    ui.setCursor(vec2(20, 180))
    if ui.checkbox(Language.get("BRAKE"), BrakeActive) then
        BrakeActive = not BrakeActive
        settings.brakeActive = BrakeActive
    end

    ui.setCursor(vec2(20, 205))
    if ui.checkbox(Language.get("CLUTCH"), ClutchActive) then
        ClutchActive = not ClutchActive
        settings.clutchActive = ClutchActive
    end
    --
    
    ui.setCursor(vec2(20, 235))
    ui.header(Language.get("OTHERS"))
  
    ui.setCursor(vec2(20, 260))
    if ui.checkbox(Language.get("FUEL"), FuelActive) then
        FuelActive = not FuelActive
        settings.fuelActive = FuelActive
    end

    ui.setCursor(vec2(20, 285))
    if ui.checkbox(Language.get("BRAKE_BIAS"), BrakeBiasActive) then
        BrakeBiasActive = not BrakeBiasActive
        settings.breakeBiasActive = BrakeBiasActive
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
    HudScale = ui.slider("##Size", HudScale, 0.8  , 3, string.format("%.2f", HudScale));
    settings.hudScale = HudScale
    
    ui.setCursor(vec2(10, 100))
    ui.header(Language.get("SPEED"))
    ui.setCursor(vec2(10, 120))
    SelectedSpeed = ui.combo("##Speed", SelectedSpeed , {"Km/h", "Mph"})
    settings.selectedSpeed = SelectedSpeed
end
  
function script.windowSettings()
    ui.drawRectFilled(vec2(0, 0), vec2(272, 500), rgbm(0, 0, 0, 0.70), 0)
    ui.tabBar('##ID',function ()
        ui.tabItem(Language.get("GENERAL"), geral)
        ui.tabItem(Language.get("ELEMENTS"), content)
        ui.tabItem(Language.get("LANGUAGE"), setLanguage)
    end)
end