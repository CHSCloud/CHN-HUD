require("language")

ui.setAsynchronousImagesLoading(true)
local settings = ac.storage{
  Size = 1,
  Wheel = true,
  ABS = true,
  BaseWindowWidth = 272,
  BaseWindowHeight = 125,
  optionLanguage = "English"
}

-- Largura das barras de freio e acelerador
local barWidth = 17

-- Posições das das barras:
local posXAceleratorBar = 100 -- Posição X da barra de acelerador 
local posxBrakeBar = posXAceleratorBar - 20 -- Posição X da barra de freio
local posyBars = 102 -- Posição Y de ambas as barras

ui.pushDWriteFont("Font/Montserrat-Bold.ttf") -- Fonte do texto

-- Posições dos textos das barras:
local posxTextBars = (posXAceleratorBar - 43) * settings.Size -- Posição X dos textos do acelerador e freio
local posyTextBars = 26 * settings.Size
local posyInfiniteBars = 20 * settings.Size
local posxTextRight = -10 * settings.Size -- Posição X dos textos de marcha e velocidade

-- Fonte dos textos:
local fontFuel = 13 * settings.Size -- Tamanho da fonte dos textos do acelerador e freio
local fontBar = 14 * settings.Size -- Tamanho da fonte dos textos do acelerador e freio
local fontBarInfinite = 22 * settings.Size -- Tamanho da fonte dos símbolos de infinito
local fontGear = 40 * settings.Size -- Tamanho da fonte do texto de marcha
local fontSpeed = 17 * settings.Size -- Tamanho da fonte do texto de velocidade

-- Setando largura e altura da janela para posterior redimencionamento:
local OldWindowWidth = settings.BaseWindowWidth
local OldWindowHeight = settings.BaseWindowHeight
local NewWindowWidth = settings.BaseWindowWidth
local NewWindowHeight = settings.BaseWindowHeight

local isApplyClicked = false

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
        ui.image("Icons/ABS.png", vec2(80, 82), rgbm(255, 0, 0, 1),ui.ImageFit.Fit)
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
    ui.drawSimpleLine(vec2(posxBrakeBar, posyBars), vec2(posxBrakeBar, posyBars - CAR.brake * 60), rgbm(255, 0, 0, 1), barWidth)

    
    -- Fuel Imagem
    if CAR.fuel <= 5 then
      ui.setCursor(vec2(settings.BaseWindowWidth-55, settings.BaseWindowHeight-19))
      ui.image("Icons/Fuel.png", vec2(16, 15), rgbm(255, 0, 0, 1), ui.ImageFit.Fit)
    elseif CAR.fuel < 10 then
      ui.setCursor(vec2(settings.BaseWindowWidth-55, settings.BaseWindowHeight-19))
      ui.image("Icons/Fuel.png", vec2(16, 15), rgbm(255, 255, 0, 1), ui.ImageFit.Fit)
    elseif CAR.fuel < 100 then
      ui.setCursor(vec2(settings.BaseWindowWidth-59, settings.BaseWindowHeight-19))
      ui.image("Icons/Fuel.png", vec2(16, 15), rgbm(255, 255, 255, 1), ui.ImageFit.Fit)
    else
      ui.setCursor(vec2(settings.BaseWindowWidth-62, settings.BaseWindowHeight-19))
      ui.image("Icons/Fuel.png", vec2(16, 15), rgbm(255, 255, 255, 1), ui.ImageFit.Fit)
    end
    --
    -- BrakeBias Image
    ui.setCursor(vec2(2, 104))
    ui.image("Icons/BrakeBias.png", vec2(19, 19), ui.ImageFit.Fit)
    --
    ui.endPivotScale(settings.Size, vec2(0, 0)) -- Escala da janela

    -- Text Fuel
    ui.setCursor(vec2((settings.BaseWindowWidth-67)*settings.Size, (settings.BaseWindowHeight-20)*settings.Size))
    if CAR.fuel <= 5 then
      ui.dwriteTextAligned(string.format("%.2f", CAR.fuel), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30):scale(settings.Size), false, rgbm(255, 0, 0, 1))
    elseif CAR.fuel < 10 then
      ui.dwriteTextAligned(string.format("%.2f", CAR.fuel), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30):scale(settings.Size), false, rgbm(255, 255, 0, 1))
    else
      ui.dwriteTextAligned(string.format("%.2f", CAR.fuel), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30):scale(settings.Size), false, rgbm(255, 255, 255, 1))
    end
    --
    -- Text Brake Bias
    ui.setCursor(vec2(-8, (settings.BaseWindowHeight-20)*settings.Size))
    ui.dwriteTextAligned(string.format("%.1f", CAR.brakeBias*100), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30):scale(settings.Size), false, rgbm(255, 255, 255, 1))

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
      ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(45, 30):scale(settings.Size), false, rgbm(255, 0, 0, 1))
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
    local speed = string.format("%d", math.floor(CAR.speedKmh))
    ui.setCursor(vec2(posxTextRight, 60 * settings.Size))
    ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(88, 55):scale(settings.Size), false, rgbm(255, 255, 255, 1))   
    --
end

local function updateSettings()
  setTimeout(function()
      Language.loadTranslations()
  end, 0.5) 
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
  ui.header(Language.get("LANGUAGE"))
  ui.combo('##resolution', '%s' % settings.optionLanguage, function ()
    if ui.selectable("English") then
      settings.optionLanguage = "English"
      Language.setLanguage("en")
      isApplyClicked = true
    end

    if ui.selectable("Português") then
      settings.optionLanguage = "Português"
      Language.setLanguage("pt-br")
      isApplyClicked = true
    end
  end)

  if isApplyClicked then
    ui.setCursor(vec2(250,98))
    if ui.button(Language.get("APPLY")) then
      isApplyClicked = false
      updateSettings()
    end
  end
end

-- TabBar
function script.Ioverlay_Settings()
    ui.tabBar('##ID', function ()
      ui.tabItem(Language.get("GENERAL"), geral)
      ui.tabItem(Language.get("ELEMENTS"), elements)
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