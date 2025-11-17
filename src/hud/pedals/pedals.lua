require("src.settings.settings")
local config = require("common.config")
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

-- Desenha a marcha
local function drawGear()
  contentMidle = 73 * WindowPedalsScale
  local fontGear = 40 * WindowPedalsScale
  local gearBackgroundWidth = 60 * WindowPedalsScale

  currentWindowWidth = gearBackgroundWidth
  local gear = tostring(CAR.gear)
  if gear == "0" then
    gear = "N"
  elseif gear == "-1" then
    gear = "R"
  end
  
  if SpeedActive then
    ui.setCursor(vec2(20, 11 + contentTop):scale(WindowPedalsScale))
    ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 30):scale(WindowPedalsScale), false, COLOR.YELLOW_DARK)
  else
    fontGear = 45 * WindowPedalsScale
    ui.setCursor(vec2(20, 15 + contentTop):scale(WindowPedalsScale))
    ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 40):scale(WindowPedalsScale), false, COLOR.YELLOW_DARK)
  end
end

-- Desenha a velocidade
local function drawSpeed()
  contentMidle = 73 * WindowPedalsScale
  local fontSpeed = 20 * WindowPedalsScale
  local gearBackgroundWidth = 60 * WindowPedalsScale
  
  currentWindowWidth = gearBackgroundWidth
  local speed
  if(SelectedSpeed == 1) then
    speed = string.format("%.0f", CAR.speedKmh)
  else
    speed = string.format("%.0f", CAR.speedKmh * 0.621371)
  end
  
  if GearActive then
    ui.setCursor(vec2(11, 41 + contentTop):scale(WindowPedalsScale))
    ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(50, 30):scale(WindowPedalsScale), false, COLOR.WHITE)
  else
    fontSpeed = 25 * WindowPedalsScale
    ui.setCursor(vec2(11, 19 + contentTop):scale(WindowPedalsScale))
    ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(50, 35):scale(WindowPedalsScale), false, COLOR.WHITE)
  end
end

-- Desenha texto da barra
local function drawBarText(value, color)
  contentMidle = 73 * WindowPedalsScale
  if value < 98.99 then
    ui.dwriteTextAligned(string.format("%.0f", value), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, COLOR.WHITE)
  else 
    ui.setCursor(vec2(currentWindowWidth, posyInfiniteBars))
    ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, color)
  end
end

-- Desenha barra com linhas de limite
local function drawBarWithLimits(posBar, value, color, inverted)
  contentMidle = 73 * WindowPedalsScale
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
  contentMidle = 73 * WindowPedalsScale
  ui.drawRectFilled(posBar, posBar + barSize, COLOR.GRAY_BG)
  
  if inverted then
    ui.drawRectFilled(posBar + vec2(0, (value * barSize.y)), posBar + barSize, color)
  else
    ui.drawRectFilled(posBar + vec2(0, barSize.y - (value * barSize.y)), posBar + barSize, color)
  end
end

-- Desenha rpm
local function drawRpm()
  if currentWindowWidth < 180 * WindowPedalsScale then
    currentWindowWidth = 180 * WindowPedalsScale
  end
  local rpmStart = CAR.rpmLimiter * 0.80
  local rpmFinal = CAR.rpmLimiter * 0.98
  local rpmRange =  rpmFinal - rpmStart

  if RpmType == "default" then
    local spaceCircles = (currentWindowWidth * 0.95) / (NumCircles * WindowPedalsScale)
    if spaceCircles > 18 then spaceCircles = 18 end
    local initPos = (currentWindowWidth / 2) - (((NumCircles - 1) * spaceCircles) / 2) * WindowPedalsScale
    local level = 0
    if CAR.rpm >= rpmStart then
      level = ((NumCircles * (CAR.rpm - rpmStart)) / rpmRange) + 1
    end
    local color = COLOR.GREEN
    if RpmProcessType == "default" then
      for i = 1, NumCircles, 1 do
        if (CAR.rpm >= rpmFinal * 0.98) then
          level = NumCircles 
          if (8 * Timer) % 2 >= 1 then 
            color = COLOR.GRAY_BG
          else 
            color = COLOR.RED
          end
        elseif i > level then
          color = COLOR.GRAY_BG
        elseif i >= NumCircles * 0.78 then
          color = COLOR.RED_DARK
        elseif i >= NumCircles * 0.45 then
          color = COLOR.YELLOW
        end
        ui.drawCircleFilled(vec2(initPos, 11 * WindowPedalsScale), (spaceCircles * 0.45) * WindowPedalsScale, color, 20 * WindowPedalsScale)
        initPos = initPos + spaceCircles * WindowPedalsScale
      end
    elseif RpmProcessType == "total" then
      if (CAR.rpm >= CAR.rpmLimiter * 0.96) then
        level = NumCircles 
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

      for i = 1, NumCircles, 1 do
        if i > level then
          color = COLOR.GRAY_BG
        end
        ui.drawCircleFilled(vec2(initPos, 11 * WindowPedalsScale), (spaceCircles * 0.45) * WindowPedalsScale, color, 20 * WindowPedalsScale)
        initPos = initPos + spaceCircles * WindowPedalsScale
      end
    end
  elseif RpmType == "bar" then
    local width = currentWindowWidth * BarLength
    local initPos = (currentWindowWidth / 2) - (width / 2)
    local barHeight = 18 * WindowPedalsScale
    ui.drawRectFilled(vec2(initPos, 4 * WindowPedalsScale), vec2(initPos + width, barHeight), COLOR.GRAY_BG, 10 * WindowPedalsScale)

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

      ui.drawRectFilled(vec2(initPos, 4 * WindowPedalsScale), vec2(lenght, barHeight), color, 10 * WindowPedalsScale)
    end 
  end
end 
--

-- Desenha a embreagem
local function drawClutch()
  contentMidle = 73 * WindowPedalsScale
  local posBar = vec2(currentWindowWidth, (6 + contentTop) * WindowPedalsScale)
  
  if TextBarsActive then
    ui.setCursor(vec2(currentWindowWidth, posyTextBars))
    drawBarText(100 - CAR.clutch * 100, COLOR.BLUE)
  end
  
  if PedalLimitsLines then
    drawBarWithLimits(posBar, CAR.clutch, COLOR.BLUE, true)
  else
    drawBarSimple(posBar, CAR.clutch, COLOR.BLUE, true)
  end
  
  currentWindowWidth = currentWindowWidth + barSize.x + barSpace
end

-- Desenha o freio
local function drawBrake()
  contentMidle = 73 * WindowPedalsScale
  local posBar = vec2(currentWindowWidth, (6 + contentTop) * WindowPedalsScale)
  
  if TextBarsActive then
    ui.setCursor(vec2(currentWindowWidth, posyTextBars))
    drawBarText(CAR.brake * 100, COLOR.RED_DARK)
  end
  
  if PedalLimitsLines then
    drawBarWithLimits(posBar, CAR.brake, COLOR.RED_DARK, false)
  else
    drawBarSimple(posBar, CAR.brake, COLOR.RED_DARK, false)
  end
  
  currentWindowWidth = currentWindowWidth + barSize.x + barSpace
end


-- Desenha o acelerador
local function drawAccelerator()
  contentMidle = 73 * WindowPedalsScale
  local posBar = vec2(currentWindowWidth, (6 + contentTop) * WindowPedalsScale)
  
  if TextBarsActive then
    ui.setCursor(vec2(currentWindowWidth, posyTextBars))
    drawBarText(CAR.gas * 100, COLOR.GREEN)
  end
  
  if PedalLimitsLines then
    drawBarWithLimits(posBar, CAR.gas, COLOR.GREEN, false)
  else
    drawBarSimple(posBar, CAR.gas, COLOR.GREEN, false)
  end
  
  currentWindowWidth = currentWindowWidth + barSize.x + barSpace
end

-- Desenha o freio de mão
local function drawHandbrake()
  contentMidle = 73 * WindowPedalsScale
  local posBar = vec2(currentWindowWidth, (6 + contentTop) * WindowPedalsScale)
  
  if TextBarsActive then
    ui.setCursor(vec2(currentWindowWidth, posyTextBars))
    if CAR.handbrake < 1 then
      ui.dwriteTextAligned(string.format("%.0f", CAR.handbrake * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, COLOR.WHITE)
    else 
      ui.setCursor(vec2(currentWindowWidth, posyInfiniteBars))
      ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, COLOR.YELLOW)
    end
  end
  
  if PedalLimitsLines then
    drawBarWithLimits(posBar, CAR.handbrake, COLOR.YELLOW, false)
  else
    drawBarSimple(posBar, CAR.handbrake, COLOR.YELLOW, false)
  end
  
  currentWindowWidth = currentWindowWidth + barSize.x + barSpace
end

-- Desenha o volante
local function drawWheel()
  contentMidle = 73 * WindowPedalsScale
  local wheelBackgroundSize = vec2(55 * WindowPedalsScale, currentWindowHeight)
  
  ui.beginRotation()
  ui.setCursor(vec2(currentWindowWidth - 4 * WindowPedalsScale, (1 + contentTop) * WindowPedalsScale ))
  ui.image("assets/Wheel1.png", vec2(65, 72):scale(WindowPedalsScale), ui.ImageFit.Fit)
  ui.endRotation(90 - CAR.steer)
  
  currentWindowWidth = currentWindowWidth + wheelBackgroundSize.x + 12 * WindowPedalsScale + barSpace
end

-- Desenha o ABS
local function drawABS()
  contentMidle = 73 * WindowPedalsScale
  local absBackgroundSize = vec2(76 * WindowPedalsScale, currentWindowHeight)
  
  ui.setCursor(vec2(currentWindowWidth - 9 * WindowPedalsScale, (-4 + contentTop) * WindowPedalsScale ))
  if CAR.absInAction then
    ui.image("assets/ABS.png", vec2(80,80):scale(WindowPedalsScale), COLOR.RED, ui.ImageFit.Fit)
  else
    ui.image("assets/ABS.png", vec2(80,80):scale(WindowPedalsScale), COLOR.GRAY_BG, ui.ImageFit.Fit)
  end
  
  currentWindowWidth = currentWindowWidth + absBackgroundSize.x
end

-- Desenha o brake bias
local function drawBrakeBias()
  if contentMidle == 0 then contentMidle = 3 * WindowPedalsScale end

  if (currentWindowWidth < 60 * WindowPedalsScale) then
    currentWindowWidth = currentWindowWidth + (60 * WindowPedalsScale - currentWindowWidth)
  end
  
  ui.setCursor(vec2(22 * WindowPedalsScale, currentWindowHeight - 19 * WindowPedalsScale))
  ui.dwriteTextAligned(string.format("%.1f", CAR.brakeBias * 100), fontContentBottom, ui.Alignment.Center, ui.Alignment.Start, vec2(30, 30):scale(WindowPedalsScale), false, COLOR.WHITE)
  
  ui.setCursor(vec2(5 * WindowPedalsScale, currentWindowHeight - 18.5 * WindowPedalsScale))
  ui.image("assets/BrakeBias.png", vec2(16, 16):scale(WindowPedalsScale), ui.ImageFit.Fit)
end


-- Desenha o combustível
local function drawFuel()
  if contentMidle == 0 then contentMidle = 3 * WindowPedalsScale end

  if BrakeBiasActive and currentWindowWidth < 115 * WindowPedalsScale then
    currentWindowWidth = 115 * WindowPedalsScale
  end
  if (currentWindowWidth < 68 * WindowPedalsScale) then
    currentWindowWidth = currentWindowWidth + (68 * WindowPedalsScale - currentWindowWidth)
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
  if (8 * Timer) % 2 >= 1 then 
    color = COLOR.GRAY_BG
  else 
    color = COLOR.RED_DARK
  end

  ui.setCursor(vec2(currentWindowWidth - xOffset * WindowPedalsScale, currentWindowHeight - 19 * WindowPedalsScale))
  ui.dwriteTextAligned(string.format("%.2f", math.max(0, CAR.fuel)), fontContentBottom, ui.Alignment.Center, ui.Alignment.Start, vec2(50, 30):scale(WindowPedalsScale), false, fuelColor)
  
  local iconXOffset = (CAR.fuel >= 99.995) and 65 or ((CAR.fuel >= 9.995) and 59 or 56)
  ui.setCursor(vec2(currentWindowWidth - iconXOffset * WindowPedalsScale, currentWindowHeight - 18.5 * WindowPedalsScale))
  if CAR.fuel < 5.005 then
    if (4 * Timer) % 2 >= 1 then 
      ui.image("assets/Fuel.png", vec2(16, 15):scale(WindowPedalsScale), fuelColor, ui.ImageFit.Fit)
    end
  else 
    ui.image("assets/Fuel.png", vec2(16, 15):scale(WindowPedalsScale), fuelColor, ui.ImageFit.Fit)
  end
  
end

function pedals.windowMain()
  ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
  fontBar = 15 * WindowPedalsScale
  fontBarInfinite = 25 * WindowPedalsScale
  fontContentBottom = 13 * WindowPedalsScale

  posyTextBars = (-12 + contentTop) * WindowPedalsScale
  posyInfiniteBars = (-20 + contentTop) * WindowPedalsScale 

  barSize = vec2(20, 60) * WindowPedalsScale
  barSpace = 4 * WindowPedalsScale
  barLimitSize = vec2(20, 6) * WindowPedalsScale
  barMidleSize = vec2(20, 44) * WindowPedalsScale
  barPaddingMidle = 2 * WindowPedalsScale

  contentTop = 0
  contentBottom = 0

  if TextBarsActive and contentMidle > 0 and (ClutchActive or BrakeActive or AcceleratorActive or HandbrakeActive) then contentTop = 10 end
  if RpmActive then contentTop = contentTop + 22 end
  if BrakeBiasActive or FuelActive then contentBottom = 17 * WindowPedalsScale end

  currentWindowWidth = 0
  currentWindowHeight = contentMidle + contentTop * WindowPedalsScale + contentBottom

  contentMidle = 0
  
  -- Desenha background principal
  ui.drawRectFilled(vec2(0, 0), currentWindowSize, WindowsColor, 10 * WindowPedalsScale)
  
  -- Desenha componentes

  if GearActive then
    drawGear()
  end
  
  if SpeedActive then
    drawSpeed()
  end
  
  currentWindowWidth = currentWindowWidth + 6 * WindowPedalsScale + barSpace
  
  if ClutchActive then
    drawClutch()
  end
  
  if BrakeActive then
    drawBrake()
  end
  
  if AcceleratorActive then
    drawAccelerator()
  end
  
  if HandbrakeActive then
    drawHandbrake()
  end
  
  currentWindowWidth = currentWindowWidth + 6 * WindowPedalsScale
  
  if WheelActive then
    drawWheel()
  end
  
  if ABSActive and CAR.absModes ~= 0 then
    drawABS()
  end
  
  if BrakeBiasActive then
    drawBrakeBias()
  end

  if RpmActive then
    drawRpm()
  end

  if FuelActive then
    drawFuel()
  end
  --

  currentWindowSize = vec2(currentWindowWidth, currentWindowHeight)
  config.resize(currentWindowSize, "Pedals")
end

return pedals