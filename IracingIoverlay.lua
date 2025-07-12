require("lang.language")

ui.setAsynchronousImagesLoading(true)
local settings = ac.storage{
  Size = 1,
  Wheel = true,
  ABS = true,
  BaseWindowWidth = 272,
  BaseWindowHeight = 110,
  optionLanguage = "English",
  selectedSpeed = 1
}

-- Largura das barras de freio e acelerador
local barWidth = 17

-- Posições das das barras:
local posXAceleratorBar = 100 -- Posição X da barra de acelerador 
local posxBrakeBar = posXAceleratorBar - 20 -- Posição X da barra de freio
local posyBars = 106 -- Posição Y de ambas as barras

ui.pushDWriteFont("Font/Montserrat-Bold.ttf") -- Fonte do texto

-- Posições dos textos das barras:
local posxTextBars = (posXAceleratorBar - 43) * settings.Size -- Posição X dos textos do acelerador e freio
local posyTextBars = 26 * settings.Size
local posyInfiniteBars = 20 * settings.Size
local posxTextRight = -10 * settings.Size -- Posição X dos textos de marcha e velocidade

-- Fonte dos textos:
local fontBar = 14 * settings.Size -- Tamanho da fonte dos textos do acelerador e freio
local fontBarInfinite = 22 * settings.Size -- Tamanho da fonte dos símbolos de infinito
local fontGear = 40 * settings.Size -- Tamanho da fonte do texto de marcha
local fontSpeed = 17 * settings.Size -- Tamanho da fonte do texto de velocidade

-- Setando largura e altura da janela para posterior redimencionamento:
local OldWindowWidth = settings.BaseWindowWidth
local OldWindowHeight = settings.BaseWindowHeight
local NewWindowWidth = settings.BaseWindowWidth
local NewWindowHeight = settings.BaseWindowHeight

local SIM = ac.getSim()
local CAR = ac.getCar(SIM.focusedCar)

function script.windowMain()
    if CAR == nil then
        ac.debug("Focused driver error");
        return
    end
    ui.beginScale()

    -- BackGround
    ui.drawRectFilled(vec2(0, 0), vec2(settings.BaseWindowWidth, settings.BaseWindowHeight), rgbm(0, 0, 0, 0.30), 0)

    -- Wheel:
    if settings.Wheel then
      settings.BaseWindowWidth = 202
      ui.beginRotation()
      ui.setCursor(vec2(125, 30))
      ui.image("Icons/Wheel.png", vec2(60, 72), ui.ImageFit.Fit)
      ui.endRotation(90 -CAR.steer)
    end

    -- ABS:
    if settings.ABS then
      if settings.Wheel then
        settings.BaseWindowWidth = 272
        ui.setCursor(vec2(190, 25))
      else
        settings.BaseWindowWidth = 202
        ui.setCursor(vec2(115, 25))
      end
      if CAR.absInAction then
        ui.image("Icons/ABSactive.png", vec2(80, 82), ui.ImageFit.Fit)
      else
        ui.image("Icons/ABS.png", vec2(80, 82), ui.ImageFit.Fit)
      end
    end

    if not settings.ABS and not settings.Wheel then
      settings.BaseWindowWidth = 120
    end

    -- Barras do acelerador:
    ui.drawSimpleLine(vec2(posXAceleratorBar, posyBars), vec2(posXAceleratorBar, posyBars - 60), rgbm(0.2, 0.2, 0.2, 0.6), barWidth)
    ui.drawSimpleLine(vec2(posXAceleratorBar, posyBars), vec2(posXAceleratorBar, posyBars - CAR.gas * 60), rgbm(107 / 255, 228 / 255, 96 / 255, 1), barWidth)

    -- Barras do freio:
    ui.drawSimpleLine(vec2(posxBrakeBar, posyBars), vec2(posxBrakeBar, posyBars - 60), rgbm(0.2, 0.2, 0.2, 0.6), barWidth)
    ui.drawSimpleLine(vec2(posxBrakeBar, posyBars), vec2(posxBrakeBar, posyBars - CAR.brake * 60), rgbm(226 / 255, 12 / 255, 50 / 255, 1), barWidth)

    ui.endPivotScale(settings.Size, vec2(0, 0)) -- Escala da janela


    -- Texto do acelerador:
    if (CAR.gas * 100) < 98.99 then
      ui.setCursor(vec2(posxTextBars, posyTextBars))
      ui.dwriteTextAligned(string.format("%.0f", CAR.gas * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30):scale(settings.Size), false, rgbm(255, 255, 255, 1))
    else 
      ui.setCursor(vec2(posxTextBars, posyInfiniteBars))
      ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(85, 30):scale(settings.Size), false, rgbm(107 / 255, 228 / 255, 96 / 255, 1))
    end
    -- 

    -- Texto do freio:
    if (CAR.brake * 100) < 98.99 then
      ui.setCursor(vec2(posxTextBars, posyTextBars))
      ui.dwriteTextAligned(string.format("%.0f", CAR.brake * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(45, 30):scale(settings.Size), false, rgbm(255, 255, 255, 1))
    else 
      ui.setCursor(vec2(posxTextBars, posyInfiniteBars))
      ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(45, 30):scale(settings.Size), false, rgbm(226 / 255, 12 / 255, 50 / 255, 1))
    end
    --

    -- Texto das marchas:
    local gear = tostring(CAR.gear);
    if gear == "0" then
      gear = "N";
    elseif gear == "-1" then
      gear = "R";
    end
    ui.setCursor(vec2(posxTextRight, 30 * settings.Size))
    ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(86, 50):scale(settings.Size), false, rgbm(255, 255, 255, 1))
    --
    
    -- Velocidade Km/h:
    local speed
    if(settings.selectedSpeed == 1) then
      speed = string.format("%d", math.floor(CAR.speedKmh))
    else
      speed = string.format("%d", math.floor(CAR.speedKmh * 0.621371))
    end
    
    ui.setCursor(vec2(posxTextRight, 60 * settings.Size))
    ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(88, 55):scale(settings.Size), false, rgbm(255, 255, 255, 1))   
    --
end

local function updateSettings()
  setTimeout(function()
    Language.loadTranslations()
  end, 0.5) 
end

-- Escolher Idioma:
local function setLanguage()
  ui.header(Language.get("LANGUAGE"))
  ui.combo('##resolution', '%s' % settings.optionLanguage, function ()
    if ui.selectable("English") then
      settings.optionLanguage = "English"
      Language.setLanguage("en")
    end

    if ui.selectable("Português - Brasil") then
      settings.optionLanguage = "Português - Brasil"
      Language.setLanguage("pt-br")
    end
  end)
  ui.setCursor(vec2(20,100))
  if ui.button(Language.get("APPLY")) then
    updateSettings()
  end
end

-- Checkbox
local function elements()
  ui.setCursor(vec2(20, 55))
  if ui.checkbox(Language.get("WHEEL"), settings.Wheel) then
    settings.Wheel = not settings.Wheel
  end

  ui.setCursor(vec2(20, 80))
  if ui.checkbox(Language.get("ABS"), settings.ABS) then
    settings.ABS = not settings.ABS
  end
  -- Alert ABS
  if CAR.absModes == 0 then
    ui.setCursor(vec2(70, 75))
    ui.dwriteTextAligned(Language.get("ALERT_ABS"), 10, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 35), false, rgbm(255, 0, 0, 1))  
  end
end
--

local function geral()
  settings.Size = ui.slider(Language.get("SIZE"), settings.Size, 1, 3, string.format("%.2f", settings.Size));
  ui.header(Language.get("SPEED"))
  settings.selectedSpeed = ui.combo("##Speed", settings.selectedSpeed , {"Km/h", "Mph"})
end

-- TabBar
function script.Ioverlay_Settings()
    ui.tabBar('##ID', function ()
      ui.tabItem(Language.get("GENERAL"), geral)
      ui.tabItem(Language.get("ELEMENTS"), elements)
      ui.tabItem(Language.get("LANGUAGE"), setLanguage)
    end)
    
    NewWindowHeight = settings.BaseWindowHeight * settings.Size
    NewWindowWidth = settings.BaseWindowWidth * settings.Size
    if NewWindowHeight ~= OldWindowHeight or NewWindowWidth ~= OldWindowWidth then
      -- Redimencionando janela:
      local iniFile = ac.INIConfig.load(ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\IracingIoverlay\\manifest.ini")
      iniFile:setAndSave("WINDOW_...", "SIZE", " " .. tostring(NewWindowWidth) .. ", " .. tostring(NewWindowHeight))
      OldWindowHeight = NewWindowHeight
      OldWindowWidth = NewWindowWidth
    end
  end