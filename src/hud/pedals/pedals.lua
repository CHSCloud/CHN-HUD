local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")
local pedals = {}

local currentWindowSize = vec2(0, 0)
local currentWindowWidth = 0 -- Largura da janela atual
local currentWindowHeight = 0 -- Altura da janela atual

-- Fontes das barras
local fontBar -- Fonte dos textos das barras
local fontBarInfinite -- Fonte do símbolo infinito das barras
local fontContentBottom -- Fonte dos conteúdos de baixo

-- Posições dos textos das barras
local posyTextBars -- Posição Y dos textos das barras
local posyInfiniteBars -- Posição Y do símbolo infinito das barras

-- Barras
local barSize -- Largutra das barras
local barSpace -- Espaço entre as barras
local barLimitSize -- Tamanho das linhas de limite das barras
local barMidleSize -- Tamanho das barras intermediárias
local barPaddingMidle -- Espaço entre as barras intermediárias

-- Tamanho do espaço do conteúdo do topo
local contentTop = 0
local contentMidle = 0
local contentBottom = 0

-- Marcha
local currentGear = 0
local fontGear = 40 * pedalsSettings.scale
local gearBackgroundWidth

-- Velocidade
local fontSpeed

--Animação da Marcha
local function animateGear(maxFontGear) 
  if fontGear < maxFontGear - 3 then
    if (40 * Timer) % 2 >= 1 then 
      fontGear = fontGear + 10 * pedalsSettings.scale
    end
  else
    fontGear = maxFontGear
  end
end

-- Desenha a marcha
local function drawGear()
  contentMidle = 73 * pedalsSettings.scale
  gearBackgroundWidth = 60 * pedalsSettings.scale
  currentWindowWidth = gearBackgroundWidth
  if currentGear ~= CAR.gear then
    fontGear = 0
    currentGear = CAR.gear
  end
  local gear = tostring(CAR.gear)
  if gear == "0" then
    gear = "N"
  elseif gear == "-1" then
    gear = "R"
  end
  
  if pedalsSettings.speedActive then
    animateGear(40 * pedalsSettings.scale)
    ui.setCursor(vec2(20, 11 + contentTop):scale(pedalsSettings.scale))
    ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 30):scale(pedalsSettings.scale), false, COLOR.YELLOW_DARK)
  else
    animateGear(45 * pedalsSettings.scale)
    ui.setCursor(vec2(20, 15 + contentTop):scale(pedalsSettings.scale))
    ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 40):scale(pedalsSettings.scale), false, COLOR.YELLOW_DARK)
  end
end

-- Desenha a velocidade
local function drawSpeed()
  contentMidle = 73 * pedalsSettings.scale
  gearBackgroundWidth = 60 * pedalsSettings.scale
  currentWindowWidth = gearBackgroundWidth
  fontSpeed = 20 * pedalsSettings.scale
  local speed
  if(SelectedSpeed == "Km/h") then
    speed = string.format("%.0f", CAR.speedKmh)
  else
    speed = string.format("%.0f", CAR.speedKmh * 0.621371)
  end
  
  if pedalsSettings.gearActive then
    ui.setCursor(vec2(11, 41 + contentTop):scale(pedalsSettings.scale))
    ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(50, 30):scale(pedalsSettings.scale), false, COLOR.WHITE)
  else
    fontSpeed = 25 * pedalsSettings.scale
    ui.setCursor(vec2(11, 19 + contentTop):scale(pedalsSettings.scale))
    ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(50, 35):scale(pedalsSettings.scale), false, COLOR.WHITE)
  end
end

-- Desenha texto da barra
local function drawBarText(value, color)
  contentMidle = 73 * pedalsSettings.scale
  if value < 98.99 then
    ui.dwriteTextAligned(string.format("%.0f", value), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(pedalsSettings.scale), false, COLOR.WHITE)
  else 
    ui.setCursor(vec2(currentWindowWidth, posyInfiniteBars))
    ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(pedalsSettings.scale), false, color)
  end
end

-- Desenha barra com linhas de limite
local function drawBarWithLimits(posBar, value, color, inverted)
  contentMidle = 73 * pedalsSettings.scale
  ui.drawRectFilled(posBar, posBar + barLimitSize, COLOR.GRAY_BG)
  
  ui.drawRectFilled(
    posBar + vec2(0, barLimitSize.y + barPaddingMidle), 
    posBar + vec2(0, barLimitSize.y + barPaddingMidle) + barMidleSize, 
    COLOR.GRAY_BG
  )
  
  ui.drawRectFilled(
    posBar + vec2(0, barLimitSize.y + barMidleSize.y + 2 * barPaddingMidle), 
    posBar + vec2(0, barLimitSize.y + barMidleSize.y + 2 * barPaddingMidle) + barLimitSize, 
    COLOR.GRAY_BG
  )
  
  if inverted then
    -- Para barras invertidas (clutch)
    if value == 0 then
      ui.drawRectFilled(posBar, posBar + barLimitSize, color)
    end
    if value < 1 then
      ui.drawRectFilled(
        posBar + vec2(0, barLimitSize.y + 2 * barPaddingMidle + barMidleSize.y),
        posBar + vec2(0, barLimitSize.y + 2 * barPaddingMidle + barMidleSize.y) + barLimitSize, 
        color
      )
    end
    ui.drawRectFilled(
      posBar + vec2(0, barLimitSize.y + barPaddingMidle + (value * barMidleSize.y)), 
      posBar + vec2(0, barLimitSize.y + barPaddingMidle) + barMidleSize, 
      color
    )
  else
    -- Para barras normais (brake, gas, handbrake)
    if value > 0 then
      ui.drawRectFilled(
        posBar + vec2(0, barLimitSize.y + 2 * barPaddingMidle + barMidleSize.y),
        posBar + vec2(0, barLimitSize.y + 2 * barPaddingMidle + barMidleSize.y) + barLimitSize, 
        color
      )
    end
    if value == 1 then
      ui.drawRectFilled(posBar, posBar + barLimitSize, color)
    end
    ui.drawRectFilled(
      posBar + vec2(0, barLimitSize.y + barPaddingMidle + barMidleSize.y - (value * barMidleSize.y)), 
      posBar + vec2(0, barLimitSize.y + barPaddingMidle) + barMidleSize, 
      color
    )
  end
end

-- Desenha barra simples
local function drawBarSimple(posBar, value, color, inverted)
  contentMidle = 73 * pedalsSettings.scale
  ui.drawRectFilled(posBar, posBar + barSize, COLOR.GRAY_BG)
  
  if inverted then
    ui.drawRectFilled(posBar + vec2(0, (value * barSize.y)), posBar + barSize, color)
  else
    ui.drawRectFilled(posBar + vec2(0, barSize.y - (value * barSize.y)), posBar + barSize, color)
  end
end

-- Desenha rpm
local function drawRpm()
  if currentWindowWidth < 180 * pedalsSettings.scale then
    currentWindowWidth = 180 * pedalsSettings.scale
  end
  local rpmStart = CAR.rpmLimiter * 0.80
  local rpmFinal = CAR.rpmLimiter * 0.98
  local rpmRange =  rpmFinal - rpmStart

  if pedalsSettings.rpmType == "default" then
    local spaceCircles = (currentWindowWidth * 0.95) / (pedalsSettings.numLights * pedalsSettings.scale)
    if spaceCircles > 18 then spaceCircles = 18 end
    local initPos = (currentWindowWidth / 2) - (((pedalsSettings.numLights - 1) * spaceCircles) / 2) * pedalsSettings.scale
    local level = 0
    if CAR.rpm >= rpmStart then
      level = ((pedalsSettings.numLights * (CAR.rpm - rpmStart)) / rpmRange) + 1
    end
    local color = COLOR.GREEN
    if pedalsSettings.rpmProcessType == "default" then
      for i = 1, pedalsSettings.numLights, 1 do
        if (CAR.rpm >= rpmFinal * 0.98) then
          level = pedalsSettings.numLights 
          if (8 * Timer) % 2 >= 1 then 
            color = COLOR.GRAY_BG
          else 
            color = COLOR.RED
          end
        elseif i > level then
          color = COLOR.GRAY_BG
        elseif i >= pedalsSettings.numLights * 0.78 then
          color = COLOR.RED_DARK
        elseif i >= pedalsSettings.numLights * 0.45 then
          color = COLOR.YELLOW
        end
        ui.drawCircleFilled(vec2(initPos, 11 * pedalsSettings.scale), (spaceCircles * 0.45) * pedalsSettings.scale, color, 20 * pedalsSettings.scale)
        initPos = initPos + spaceCircles * pedalsSettings.scale
      end
    elseif pedalsSettings.rpmProcessType == "total" then
      if (CAR.rpm >= CAR.rpmLimiter * 0.96) then
        level = pedalsSettings.numLights 
        if (8 * Timer) % 2 >= 1 then 
            color = COLOR.GRAY_BG
        else 
          color = COLOR.RED_DARK
        end

      elseif(CAR.rpm >= CAR.rpmLimiter * 0.95) then
        color = COLOR.RED_DARK

      elseif (CAR.rpm >= CAR.rpmLimiter * 0.90) then
        color = COLOR.YELLOW
      end

      for i = 1, pedalsSettings.numLights, 1 do
        if i > level then
          color = COLOR.GRAY_BG
        end
        ui.drawCircleFilled(vec2(initPos, 11 * pedalsSettings.scale), (spaceCircles * 0.45) * pedalsSettings.scale, color, 20 * pedalsSettings.scale)
        initPos = initPos + spaceCircles * pedalsSettings.scale
      end
    end
  elseif pedalsSettings.rpmType == "bar" then
    local width = currentWindowWidth * pedalsSettings.barLength
    local initPos = (currentWindowWidth / 2) - (width / 2)
    local barHeight = 18 * pedalsSettings.scale
    ui.drawRectFilled(vec2(initPos, 4 * pedalsSettings.scale), vec2(initPos + width, barHeight), COLOR.GRAY_BG, 10 * pedalsSettings.scale)

    if CAR.rpm >= rpmStart then
      local lenght = initPos + ((width * (CAR.rpm - rpmStart)) / rpmRange)
      local color = COLOR.GREEN

      if (CAR.rpm >= rpmFinal) then
        lenght = initPos + width
        if (8 * Timer) % 2 >= 1 then 
            color = COLOR.GRAY_BG
        else 
          color = COLOR.RED_DARK
        end

      elseif(CAR.rpm >= rpmFinal * 0.95) then
        color = COLOR.RED_DARK

      elseif (CAR.rpm >= rpmFinal * 0.90) then
        color = COLOR.YELLOW
      end

      ui.drawRectFilled(vec2(initPos, 4 * pedalsSettings.scale), vec2(lenght, barHeight), color, 10 * pedalsSettings.scale)
    end 
  end
end 
--

-- Desenha a embreagem
local function drawClutch()
  contentMidle = 73 * pedalsSettings.scale
  local posBar = vec2(currentWindowWidth, (6 + contentTop) * pedalsSettings.scale)
  
  if pedalsSettings.textBarsActive then
    ui.setCursor(vec2(currentWindowWidth, posyTextBars))
    drawBarText(100 - CAR.clutch * 100, COLOR.BLUE)
  end
  
  if pedalsSettings.pedalLimitsLines then
    drawBarWithLimits(posBar, CAR.clutch, COLOR.BLUE, true)
  else
    drawBarSimple(posBar, CAR.clutch, COLOR.BLUE, true)
  end
  
  currentWindowWidth = currentWindowWidth + barSize.x + barSpace
end

-- Desenha o freio
local function drawBrake()
  contentMidle = 73 * pedalsSettings.scale
  local posBar = vec2(currentWindowWidth, (6 + contentTop) * pedalsSettings.scale)
  
  if pedalsSettings.textBarsActive then
    ui.setCursor(vec2(currentWindowWidth, posyTextBars))
    drawBarText(CAR.brake * 100, COLOR.RED_DARK)
  end
  
  if pedalsSettings.pedalLimitsLines then
    drawBarWithLimits(posBar, CAR.brake, COLOR.RED_DARK, false)
  else
    drawBarSimple(posBar, CAR.brake, COLOR.RED_DARK, false)
  end
  
  currentWindowWidth = currentWindowWidth + barSize.x + barSpace
end


-- Desenha o acelerador
local function drawAccelerator()
  contentMidle = 73 * pedalsSettings.scale
  local posBar = vec2(currentWindowWidth, (6 + contentTop) * pedalsSettings.scale)
  
  if pedalsSettings.textBarsActive then
    ui.setCursor(vec2(currentWindowWidth, posyTextBars))
    drawBarText(CAR.gas * 100, COLOR.GREEN)
  end
  
  if pedalsSettings.pedalLimitsLines then
    drawBarWithLimits(posBar, CAR.gas, COLOR.GREEN, false)
  else
    drawBarSimple(posBar, CAR.gas, COLOR.GREEN, false)
  end
  
  currentWindowWidth = currentWindowWidth + barSize.x + barSpace
end

-- Desenha o freio de mão
local function drawHandbrake()
  contentMidle = 73 * pedalsSettings.scale
  local posBar = vec2(currentWindowWidth, (6 + contentTop) * pedalsSettings.scale)
  
  if pedalsSettings.textBarsActive then
    ui.setCursor(vec2(currentWindowWidth, posyTextBars))
    if CAR.handbrake < 1 then
      ui.dwriteTextAligned(string.format("%.0f", CAR.handbrake * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(pedalsSettings.scale), false, COLOR.WHITE)
    else 
      ui.setCursor(vec2(currentWindowWidth, posyInfiniteBars))
      ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(pedalsSettings.scale), false, COLOR.YELLOW)
    end
  end
  
  if pedalsSettings.pedalLimitsLines then
    drawBarWithLimits(posBar, CAR.handbrake, COLOR.YELLOW, false)
  else
    drawBarSimple(posBar, CAR.handbrake, COLOR.YELLOW, false)
  end
  
  currentWindowWidth = currentWindowWidth + barSize.x + barSpace
end

-- Desenha o volante
local function drawWheel()
  contentMidle = 73 * pedalsSettings.scale
  local wheelBackgroundSize = vec2(55 * pedalsSettings.scale, currentWindowHeight)
  
  ui.beginRotation()
  ui.setCursor(vec2(currentWindowWidth - 4 * pedalsSettings.scale, (1 + contentTop) * pedalsSettings.scale ))
  ui.image("assets/Wheel1.png", vec2(65, 72):scale(pedalsSettings.scale), ui.ImageFit.Fit)
  ui.endRotation(90 - CAR.steer)
  
  currentWindowWidth = currentWindowWidth + wheelBackgroundSize.x + 12 * pedalsSettings.scale + barSpace
end

-- Desenha o ABS
local function drawABS()
  contentMidle = 73 * pedalsSettings.scale
  local absBackgroundSize = vec2(76 * pedalsSettings.scale, currentWindowHeight)
  
  ui.setCursor(vec2(currentWindowWidth - 9 * pedalsSettings.scale, (-4 + contentTop) * pedalsSettings.scale ))
  if CAR.absInAction then
    ui.image("assets/ABS.png", vec2(80,80):scale(pedalsSettings.scale), COLOR.RED, ui.ImageFit.Fit)
  else
    ui.image("assets/ABS.png", vec2(80,80):scale(pedalsSettings.scale), COLOR.GRAY_BG, ui.ImageFit.Fit)
  end
  
  currentWindowWidth = currentWindowWidth + absBackgroundSize.x
end

-- Desenha o brake bias
local function drawBrakeBias()
  if contentMidle == 0 then contentMidle = 3 * pedalsSettings.scale end

  if (currentWindowWidth < 60 * pedalsSettings.scale) then
    currentWindowWidth = currentWindowWidth + (60 * pedalsSettings.scale - currentWindowWidth)
  end
  
  ui.setCursor(vec2(22 * pedalsSettings.scale, currentWindowHeight - 19 * pedalsSettings.scale))
  ui.dwriteTextAligned(string.format("%.1f", CAR.brakeBias * 100), fontContentBottom, ui.Alignment.Center, ui.Alignment.Start, vec2(30, 30):scale(pedalsSettings.scale), false, COLOR.WHITE)
  
  ui.setCursor(vec2(5 * pedalsSettings.scale, currentWindowHeight - 18.5 * pedalsSettings.scale))
  ui.image("assets/BrakeBias.png", vec2(16, 16):scale(pedalsSettings.scale), ui.ImageFit.Fit)
end


-- Desenha o combustível
local function drawFuel()
  if contentMidle == 0 then contentMidle = 3 * pedalsSettings.scale end

  if pedalsSettings.brakeBiasActive and currentWindowWidth < 115 * pedalsSettings.scale then
    currentWindowWidth = 115 * pedalsSettings.scale
  end
  if (currentWindowWidth < 68 * pedalsSettings.scale) then
    currentWindowWidth = currentWindowWidth + (68 * pedalsSettings.scale - currentWindowWidth)
  end
  
  local fuelColor = COLOR.WHITE
  local xOffset = 48
  
  if CAR.fuel < 5.005 then
    fuelColor = COLOR.RED_DARK
    xOffset = 48
  elseif CAR.fuel < 9.995 then
    fuelColor = COLOR.YELLOW_DARK
    xOffset = 48
  elseif CAR.fuel >= 99.995 then
    xOffset = 51
  end

  ui.setCursor(vec2(currentWindowWidth - xOffset * pedalsSettings.scale, currentWindowHeight - 19 * pedalsSettings.scale))
  ui.dwriteTextAligned(string.format("%.2f", math.max(0, CAR.fuel)), fontContentBottom, ui.Alignment.Center, ui.Alignment.Start, vec2(50, 30):scale(pedalsSettings.scale), false, fuelColor)
  
  local iconXOffset = (CAR.fuel >= 99.995) and 65 or ((CAR.fuel >= 9.995) and 59 or 56)
  ui.setCursor(vec2(currentWindowWidth - iconXOffset * pedalsSettings.scale, currentWindowHeight - 18.5 * pedalsSettings.scale))
  if CAR.fuel < 5.005 then
    if (4 * Timer) % 2 >= 1 then 
      ui.image("assets/Fuel.png", vec2(16, 15):scale(pedalsSettings.scale), fuelColor, ui.ImageFit.Fit)
    end
  else 
    ui.image("assets/Fuel.png", vec2(16, 15):scale(pedalsSettings.scale), fuelColor, ui.ImageFit.Fit)
  end
  
end

function pedals.windowMain()
  ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
  fontBar = 15 * pedalsSettings.scale
  fontBarInfinite = 25 * pedalsSettings.scale
  fontContentBottom = 13 * pedalsSettings.scale

  posyTextBars = (-12 + contentTop) * pedalsSettings.scale
  posyInfiniteBars = (-20 + contentTop) * pedalsSettings.scale 

  barSize = vec2(20, 60) * pedalsSettings.scale
  barSpace = 4 * pedalsSettings.scale
  barLimitSize = vec2(20, 6) * pedalsSettings.scale
  barMidleSize = vec2(20, 44) * pedalsSettings.scale
  barPaddingMidle = 2 * pedalsSettings.scale

  contentTop = 0
  contentBottom = 0

  if pedalsSettings.textBarsActive and contentMidle > 0 and (pedalsSettings.clutchActive or pedalsSettings.brakeActive or pedalsSettings.acceleratorActive or pedalsSettings.handbrakeActive) then contentTop = 10 end
  if pedalsSettings.rpmActive then contentTop = contentTop + 22 end
  if pedalsSettings.brakeBiasActive or pedalsSettings.fuelActive then contentBottom = 17 * pedalsSettings.scale end

  currentWindowWidth = 0
  currentWindowHeight = contentMidle + contentTop * pedalsSettings.scale + contentBottom

  contentMidle = 0
  
  -- Desenha background principal
  ui.drawRectFilled(vec2(0, 0), currentWindowSize, WindowsColor, 10 * pedalsSettings.scale)
  -- Desenha componentes

  if pedalsSettings.gearActive then
    drawGear()
  end
  
  if pedalsSettings.speedActive then
    drawSpeed()
  end
  
  currentWindowWidth = currentWindowWidth + 6 * pedalsSettings.scale + barSpace
  
  if pedalsSettings.clutchActive then
    drawClutch()
  end
  
  if pedalsSettings.brakeActive then
    drawBrake()
  end
  
  if pedalsSettings.acceleratorActive then
    drawAccelerator()
  end
  
  if pedalsSettings.handbrakeActive then
    drawHandbrake()
  end
  
  currentWindowWidth = currentWindowWidth + 6 * pedalsSettings.scale
  
  if pedalsSettings.wheelActive then
    drawWheel()
  end
  
  if pedalsSettings.absActive and CAR.absModes ~= 0 then
    drawABS()
  end
  
  if pedalsSettings.brakeBiasActive then
    drawBrakeBias()
  end

  if pedalsSettings.rpmActive then
    drawRpm()
  end

  if pedalsSettings.fuelActive then
    drawFuel()
  end
  --

  currentWindowSize = vec2(currentWindowWidth, currentWindowHeight)
  config.resize(currentWindowSize, "Pedals")


  if config.isMouseInWindow(ui.mouseLocalPos(), 0, currentWindowWidth + (PinCheckLenght + 2) * pedalsSettings.scale, 0, currentWindowHeight)then
    config.resize(currentWindowSize + vec2((PinCheckLenght + 2) * pedalsSettings.scale), "Pedals")
    if ui.mouseClicked(ui.MouseButton.Right) then
      config.pinWindow("Pedals")
      PinAllApps = false
    end
    local isMouseInCheckBox = pinCheckBox.main(vec2(currentWindowWidth + 2 * pedalsSettings.scale, 10 * pedalsSettings.scale), pedalsSettings.scale, "Pedals", config.getWindow("Pedals"):pinned())
    if isMouseInCheckBox then
      config.resize(currentWindowSize + vec2((PinCheckLenght + 100) * pedalsSettings.scale), "Pedals")
    end
  end
end

return pedals