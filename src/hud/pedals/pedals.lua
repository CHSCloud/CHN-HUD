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
local barBackgroundColor = rgbm.from0255(55, 55, 63, 0.85) -- Cor de fundo das barras
local fontGear = 40 * WindowPedalsScale

-- Tamanho do espaço do conteúdo do topo
local contentTop = 0
local contentMidle = 0
local contentBottom = 0

-- Desenha a marcha
local function drawGear()
  contentMidle = 73 * WindowPedalsScale
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
    ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 30):scale(WindowPedalsScale), false, rgbm.from0255(255, 203, 0, 1))
  else
    fontGear = 45 * WindowPedalsScale
    ui.setCursor(vec2(20, 15 + contentTop):scale(WindowPedalsScale))
    ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 40):scale(WindowPedalsScale), false, rgbm.from0255(255, 203, 0, 1))
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
    ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(50, 30):scale(WindowPedalsScale), false, rgbm(255, 255, 255, 1))
  else
    fontSpeed = 25 * WindowPedalsScale
    ui.setCursor(vec2(11, 19 + contentTop):scale(WindowPedalsScale))
    ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(50, 35):scale(WindowPedalsScale), false, rgbm(255, 255, 255, 1))
  end
end

-- Desenha texto da barra
local function drawBarText(value, color)
  contentMidle = 73 * WindowPedalsScale
  if value < 98.99 then
    ui.dwriteTextAligned(string.format("%.0f", value), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm.from0255(255, 255, 255, 1))
  else 
    ui.setCursor(vec2(currentWindowWidth, posyInfiniteBars))
    ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, color)
  end
end

-- Desenha barra com linhas de limite
local function drawBarWithLimits(posBar, value, color, inverted)
  contentMidle = 73 * WindowPedalsScale
  ui.drawRectFilled(posBar, posBar + barLimitSize, barBackgroundColor)
  
  ui.drawRectFilled(
    posBar + vec2(0, barLimitSize.y + barPaddingMidle), 
    posBar + vec2(0, barLimitSize.y + barPaddingMidle) + barMidleSize, 
    barBackgroundColor
  )
  
  ui.drawRectFilled(
    posBar + vec2(0, barLimitSize.y + barMidleSize.y + 2 * barPaddingMidle), 
    posBar + vec2(0, barLimitSize.y + barMidleSize.y + 2 * barPaddingMidle) + barLimitSize, 
    barBackgroundColor
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
  ui.drawRectFilled(posBar, posBar + barSize, barBackgroundColor)
  
  if inverted then
    ui.drawRectFilled(posBar + vec2(0, (value * barSize.y)), posBar + barSize, color)
  else
    ui.drawRectFilled(posBar + vec2(0, barSize.y - (value * barSize.y)), posBar + barSize, color)
  end
end

-- Desenha rpm
local function drawRpm()
  local rpmHeight = 6 * WindowPedalsScale
  local lenght = 10
  local initPos = vec2(lenght, 5) * WindowPedalsScale
  ui.drawRectFilled(initPos, vec2(currentWindowWidth - lenght * WindowPedalsScale, initPos.y + rpmHeight), barBackgroundColor, rpmHeight)
  local lenghtRPM = ((currentWindowWidth - lenght * WindowPedalsScale) * CAR.rpm) / CAR.rpmLimiter
  if lenghtRPM <= initPos.x then
    lenghtRPM = initPos.x
  end
  local color = rgbm.from0255(90, 212, 51, 1)
  if(CAR.rpm >= CAR.rpmLimiter - 600) then
    color = rgbm.from0255(200, 0, 0, 1)
  elseif (CAR.rpm >= CAR.rpmLimiter - 1500) then
    color = rgbm.from0255(255, 255, 0, 1)
  end
  ui.drawRectFilled(initPos, vec2(lenghtRPM, initPos.y + rpmHeight), color, rpmHeight)
end 

-- Desenha rpm
local function drawRpm2()
  local rpmHeight = 6 * WindowPedalsScale
  if currentWindowWidth < 150 * WindowPedalsScale then
    currentWindowWidth = 150 * WindowPedalsScale
  end
  local initPos = (currentWindowWidth / 2) - 72.5 * WindowPedalsScale

  local num = 9
  local rpmThreshold = CAR.rpmLimiter * 0.80
  local rpmRange = CAR.rpmLimiter - rpmThreshold
  local level = 0
  
  if CAR.rpm >= rpmThreshold then
    level = ((num * (CAR.rpm - rpmThreshold)) / rpmRange) + 1
  end

  local color = rgbm.from0255(90, 212, 51, 1)
  if(CAR.rpm >= CAR.rpmLimiter * 0.96) then
    color = rgbm.from0255(200, 0, 0, 1)

  elseif (CAR.rpm >= CAR.rpmLimiter * 0.90) then
    color = rgbm.from0255(255, 203, 0, 1)
  end

  for i = 1, num, 1 do
    ui.setCursor(vec2(initPos, 1 * WindowPedalsScale))
    if i > level then
      color = barBackgroundColor
    end
    ui.image("assets/ledRpm.png", vec2(17, 17):scale(WindowPedalsScale), color, ui.ImageFit.Fit)
    initPos = initPos + 16 * WindowPedalsScale
  end

end 

-- Desenha a embreagem
local function drawClutch()
  contentMidle = 73 * WindowPedalsScale
  local posBar = vec2(currentWindowWidth, (6 + contentTop) * WindowPedalsScale)
  
  if TextBarsActive then
    ui.setCursor(vec2(currentWindowWidth, posyTextBars))
    drawBarText(100 - CAR.clutch * 100, rgbm.from0255(0, 89, 208, 1))
  end
  
  if PedalLimitsLines then
    drawBarWithLimits(posBar, CAR.clutch, rgbm.from0255(0, 89, 208, 1), true)
  else
    drawBarSimple(posBar, CAR.clutch, rgbm.from0255(0, 89, 208, 1), true)
  end
  
  currentWindowWidth = currentWindowWidth + barSize.x + barSpace
end

-- Desenha o freio
local function drawBrake()
  contentMidle = 73 * WindowPedalsScale
  local posBar = vec2(currentWindowWidth, (6 + contentTop) * WindowPedalsScale)
  
  if TextBarsActive then
    ui.setCursor(vec2(currentWindowWidth, posyTextBars))
    drawBarText(CAR.brake * 100, rgbm.from0255(200, 0, 0, 1))
  end
  
  if PedalLimitsLines then
    drawBarWithLimits(posBar, CAR.brake, rgbm.from0255(200, 0, 0, 1), false)
  else
    drawBarSimple(posBar, CAR.brake, rgbm.from0255(200, 0, 0, 1), false)
  end
  
  currentWindowWidth = currentWindowWidth + barSize.x + barSpace
end


-- Desenha o acelerador
local function drawAccelerator()
  contentMidle = 73 * WindowPedalsScale
  local posBar = vec2(currentWindowWidth, (6 + contentTop) * WindowPedalsScale)
  
  if TextBarsActive then
    ui.setCursor(vec2(currentWindowWidth, posyTextBars))
    drawBarText(CAR.gas * 100, rgbm.from0255(90, 212, 51, 1))
  end
  
  if PedalLimitsLines then
    drawBarWithLimits(posBar, CAR.gas, rgbm.from0255(90, 212, 51, 1), false)
  else
    drawBarSimple(posBar, CAR.gas, rgbm.from0255(90, 212, 51, 1), false)
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
      ui.dwriteTextAligned(string.format("%.0f", CAR.handbrake * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm(255, 255, 255, 1))
    else 
      ui.setCursor(vec2(currentWindowWidth, posyInfiniteBars))
      ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm(255, 255, 0, 1))
    end
  end
  
  if PedalLimitsLines then
    drawBarWithLimits(posBar, CAR.handbrake, rgbm.from0255(255, 255, 0, 1), false)
  else
    drawBarSimple(posBar, CAR.handbrake, rgbm.from0255(255, 255, 0, 1), false)
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
    ui.image("assets/ABS.png", vec2(80,80):scale(WindowPedalsScale), rgbm(255, 0, 0, 1), ui.ImageFit.Fit)
  else
    ui.image("assets/ABS.png", vec2(80,80):scale(WindowPedalsScale), barBackgroundColor, ui.ImageFit.Fit)
  end
  
  currentWindowWidth = currentWindowWidth + absBackgroundSize.x
end

-- Desenha o brake bias
local function drawBrakeBias()
  if contentMidle == 0 then contentMidle = 3 * WindowPedalsScale end

  if (currentWindowWidth < 60 * WindowPedalsScale) then
    currentWindowWidth = currentWindowWidth + (60 * WindowPedalsScale - currentWindowWidth)
  end
  
  ui.setCursor(vec2(20 * WindowPedalsScale, currentWindowHeight - 19 * WindowPedalsScale))
  ui.dwriteTextAligned(string.format("%.1f", CAR.brakeBias * 100), fontContentBottom, ui.Alignment.Center, ui.Alignment.Start, vec2(30, 30):scale(WindowPedalsScale), false, rgbm(255, 255, 255, 1))
  
  ui.setCursor(vec2(2 * WindowPedalsScale, currentWindowHeight - 21 * WindowPedalsScale))
  ui.image("assets/BrakeBias.png", vec2(19, 19):scale(WindowPedalsScale), ui.ImageFit.Fit)
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
  
  local fuelColor = rgbm.from0255(255, 255, 255, 1)
  local xOffset = 48
  
  if CAR.fuel < 5.005 then
    fuelColor = rgbm.from0255(200, 0, 0, 1)
    xOffset = 48
  elseif CAR.fuel < 9.995 then
    fuelColor = rgbm.from0255(255, 203, 0, 1)
    xOffset = 48
  elseif CAR.fuel >= 99.995 then
    xOffset = 51
  end
  
  ui.setCursor(vec2(currentWindowWidth - xOffset * WindowPedalsScale, currentWindowHeight - 19 * WindowPedalsScale))
  ui.dwriteTextAligned(string.format("%.2f", CAR.fuel), fontContentBottom, ui.Alignment.Center, ui.Alignment.Start, vec2(50, 30):scale(WindowPedalsScale), false, fuelColor)
  
  local iconXOffset = (CAR.fuel >= 99.995) and 65 or ((CAR.fuel >= 9.995) and 59 or 56)
  ui.setCursor(vec2(currentWindowWidth - iconXOffset * WindowPedalsScale, currentWindowHeight - 18.5 * WindowPedalsScale))
  ui.image("assets/Fuel.png", vec2(16, 15):scale(WindowPedalsScale), fuelColor, ui.ImageFit.Fit)
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
  if RpmActive then contentTop = contentTop + 20 end
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
    drawRpm2()
  end
  if FuelActive then
    drawFuel()
  end

  --

  currentWindowSize = vec2(currentWindowWidth, currentWindowHeight)
  config.resize(currentWindowSize, "Pedals")
end

return pedals