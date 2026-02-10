local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local language = require("lang.language")
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
local fontGear = 40 * pedalsSettings.store.pedalsScale
local gearBackgroundWidth

-- Velocidade
local fontSpeed

-- Conteúdo das posições das bordas
local position = {
  vec2(), -- Posição
  vec2() -- Tamanho
}

local contentPositions = {
  position, -- SUPERIOR ESQUEDO
  position, -- SUPERIOR DIREITO
  position, -- INFERIOR ESQUERDO
  position, -- INFERIOR DIREITO
  
  position, -- SUPERIOR MEIO
  position -- INFERIOR MEIO
}

--- @param pos number
--- @param size vec2
local function setPositionContentBorder(pos, size)
  if contentPositions[pos][1].x > 0 then
    contentPositions[pos][1].x = contentPositions[pos][1].x - size.x
  end

  if contentPositions[pos][1].y > 0 then
    contentPositions[pos][1].y = contentPositions[pos][1].y - size.y
  end

  contentPositions[pos][2] = size
end

--- @param pos number
--- @param size vec2
local function setPositionContentCenter(pos, size)
  if contentPositions[pos][1].y > 0 then
    contentPositions[pos][1].y = contentPositions[pos][1].y - size.y
  end
  contentPositions[pos][2] = size
end

--Animação da Marcha
local function animateGear(maxFontGear) 
  if fontGear < maxFontGear - 3 then
    if (40 * Timer) % 2 >= 1 then 
      fontGear = fontGear + 10 * pedalsSettings.store.pedalsScale
    end
  else
    fontGear = maxFontGear
  end
end

-- Desenha a marcha
local function drawGear()
  contentMidle = 73 * pedalsSettings.store.pedalsScale
  gearBackgroundWidth = 60 * pedalsSettings.store.pedalsScale
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
  
  if pedalsSettings.store.speedActive then
    animateGear(40 * pedalsSettings.store.pedalsScale)
    ui.setCursor(vec2(20, 11):scale(pedalsSettings.store.pedalsScale) + vec2(0, contentTop))
    ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 30):scale(pedalsSettings.store.pedalsScale), false, COLOR.YELLOW_DARK)
  else
    animateGear(45 * pedalsSettings.store.pedalsScale)
    ui.setCursor(vec2(20, 15):scale(pedalsSettings.store.pedalsScale) + vec2(0, contentTop))
    ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 40):scale(pedalsSettings.store.pedalsScale), false, COLOR.YELLOW_DARK)
  end
end

-- Desenha a velocidade
local function drawSpeed()
  contentMidle = 73 * pedalsSettings.store.pedalsScale
  gearBackgroundWidth = 60 * pedalsSettings.store.pedalsScale
  currentWindowWidth = gearBackgroundWidth
  fontSpeed = 20 * pedalsSettings.store.pedalsScale
  local speed
  if(SelectedSpeed == 1) then
    speed = string.format("%.0f", CAR.speedKmh)
  else
    speed = string.format("%.0f", CAR.speedKmh * 0.621371)
  end
  
  if pedalsSettings.store.gearActive then
    ui.setCursor(vec2(11, 41):scale(pedalsSettings.store.pedalsScale) + vec2(0, contentTop))
    ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(50, 30):scale(pedalsSettings.store.pedalsScale), false, COLOR.WHITE)
  else
    fontSpeed = 25 * pedalsSettings.store.pedalsScale
    ui.setCursor(vec2(11, 19):scale(pedalsSettings.store.pedalsScale) + vec2(0, contentTop))
    ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(50, 35):scale(pedalsSettings.store.pedalsScale), false, COLOR.WHITE)
  end
end

-- Desenha texto da barra
--- @param value number
--- @param color rgbm
--- @param posBar vec2
local function drawBarText(value, color, posBar)
  contentMidle = 73 * pedalsSettings.store.pedalsScale
  if value < 98.99 then
    ui.setCursor(vec2(currentWindowWidth, posBar.y - 17 * pedalsSettings.store.pedalsScale))
    ui.dwriteTextAligned(string.format("%.0f", value), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(pedalsSettings.store.pedalsScale), false, COLOR.WHITE)
  else 
    ui.setCursor(vec2(currentWindowWidth, posBar.y - 25 * pedalsSettings.store.pedalsScale))
    ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(pedalsSettings.store.pedalsScale), false, color)
  end
end

-- Desenha barra com linhas de limite
local function drawBarWithLimits(posBar, value, color, inverted)
  contentMidle = 73 * pedalsSettings.store.pedalsScale
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
  contentMidle = 73 * pedalsSettings.store.pedalsScale
  ui.drawRectFilled(posBar, posBar + barSize, COLOR.GRAY_BG)
  
  if inverted then
    ui.drawRectFilled(posBar + vec2(0, (value * barSize.y)), posBar + barSize, color)
  else
    ui.drawRectFilled(posBar + vec2(0, barSize.y - (value * barSize.y)), posBar + barSize, color)
  end
end

-- Desenha rpm
local function drawRpm()
  local rpmStart = CAR.rpmLimiter * 0.80
  local rpmFinal = CAR.rpmLimiter * 0.98
  local rpmRange =  rpmFinal - rpmStart

  if pedalsSettings.store.rpmType == 1 then
    local area = 0
    local spaceCircles
    local space
    local center
    local posY
    if pedalsSettings.store.rpmPos == 5 then
      space = currentWindowWidth * 0.95 - contentPositions[1][2].x - contentPositions[2][2].x
      if space < 75 * pedalsSettings.store.pedalsScale then
        currentWindowWidth = currentWindowWidth + (75 * pedalsSettings.store.pedalsScale - space)
        space = currentWindowWidth * 0.95 - contentPositions[1][2].x - contentPositions[2][2].x
      end

      if space == currentWindowWidth * 0.95 then
        center = currentWindowWidth / 2
      else 
        center = contentPositions[1][2].x + (currentWindowWidth - contentPositions[1][2].x - contentPositions[2][2].x) / 2
      end
      posY = contentPositions[pedalsSettings.store.rpmPos][1].y + 10 * pedalsSettings.store.pedalsScale
    else
      space = currentWindowWidth * 0.95 - contentPositions[3][2].x - contentPositions[4][2].x
      if space < 75 * pedalsSettings.store.pedalsScale then
        currentWindowWidth = currentWindowWidth + (75 * pedalsSettings.store.pedalsScale - space)
        space = currentWindowWidth * 0.95 - contentPositions[3][2].x - contentPositions[4][2].x
      end
      if space == currentWindowWidth * 0.95 then
        center = currentWindowWidth / 2
      else 
        center = contentPositions[3][2].x + (currentWindowWidth - contentPositions[3][2].x - contentPositions[4][2].x) / 2
      end
      posY = contentPositions[pedalsSettings.store.rpmPos][1].y - 10 * pedalsSettings.store.pedalsScale
    end
    
    area = space / currentWindowWidth
    spaceCircles = math.min((currentWindowWidth * area) / (pedalsSettings.store.numLights * pedalsSettings.store.pedalsScale), 18)
    setPositionContentCenter(pedalsSettings.store.rpmPos, vec2(space, 20 * pedalsSettings.store.pedalsScale))
    
    local initPos = center - (((pedalsSettings.store.numLights - 1) * spaceCircles) / 2) * pedalsSettings.store.pedalsScale
    local level = 0
    if CAR.rpm >= rpmStart then
      level = ((pedalsSettings.store.numLights * (CAR.rpm - rpmStart)) / rpmRange) + 1
    end
    local color = COLOR.GREEN
    if pedalsSettings.store.rpmProcessType == 1 then
      for i = 1, pedalsSettings.store.numLights, 1 do
        if (CAR.rpm >= rpmFinal * 0.98) then
          level = pedalsSettings.store.numLights 
          if (8 * Timer) % 2 >= 1 then 
            color = COLOR.GRAY_BG
          else 
            color = COLOR.RED
          end
        elseif i > level then
          color = COLOR.GRAY_BG
        elseif i >= pedalsSettings.store.numLights * 0.78 then
          color = COLOR.RED_DARK
        elseif i >= pedalsSettings.store.numLights * 0.45 then
          color = COLOR.YELLOW
        end
        ui.drawCircleFilled(vec2(initPos, posY), (spaceCircles * 0.45) * pedalsSettings.store.pedalsScale, color, 20 * pedalsSettings.store.pedalsScale)
        initPos = initPos + spaceCircles * pedalsSettings.store.pedalsScale
      end
    elseif pedalsSettings.store.rpmProcessType == 2 then
      if (CAR.rpm >= CAR.rpmLimiter * 0.96) then
        level = pedalsSettings.store.numLights 
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

      for i = 1, pedalsSettings.store.numLights, 1 do
        if i > level then
          color = COLOR.GRAY_BG
        end
        ui.drawCircleFilled(vec2(initPos, posY), (spaceCircles * 0.45) * pedalsSettings.store.pedalsScale, color, 20 * pedalsSettings.store.pedalsScale)
        initPos = initPos + spaceCircles * pedalsSettings.store.pedalsScale
      end
    end
  elseif pedalsSettings.store.rpmType == 2 then
    local width
    local initPosX
    local center
    local initPosY
    
    if pedalsSettings.store.rpmPos == 5 then
      width = currentWindowWidth * 0.95 - contentPositions[1][2].x - contentPositions[2][2].x
      if width < 75 * pedalsSettings.store.pedalsScale then
        currentWindowWidth = currentWindowWidth + (75 * pedalsSettings.store.pedalsScale - width)
        width = 75 * pedalsSettings.store.pedalsScale
      end
      center = contentPositions[1][2].x + (currentWindowWidth - contentPositions[1][2].x - contentPositions[2][2].x) / 2
      setPositionContentCenter(pedalsSettings.store.rpmPos, vec2(width, 20 * pedalsSettings.store.pedalsScale))
      initPosY = contentPositions[1][1].y + 4 * pedalsSettings.store.pedalsScale
    else
      width = currentWindowWidth * 0.95 - contentPositions[3][2].x - contentPositions[4][2].x
      if width < 75 * pedalsSettings.store.pedalsScale then
        currentWindowWidth = currentWindowWidth + (75 * pedalsSettings.store.pedalsScale - width)
        width = 75 * pedalsSettings.store.pedalsScale
      end
      center = contentPositions[3][2].x + (currentWindowWidth - contentPositions[3][2].x - contentPositions[4][2].x) / 2
      setPositionContentCenter(pedalsSettings.store.rpmPos, vec2(width, 20 * pedalsSettings.store.pedalsScale))
      initPosY = contentPositions[pedalsSettings.store.rpmPos][1].y + 2 * pedalsSettings.store.pedalsScale
    end
    local barHeight = 14 * pedalsSettings.store.pedalsScale
    initPosX = center - (width / 2)
    ui.drawRectFilled(vec2(initPosX, initPosY), vec2(initPosX + width, initPosY +barHeight), COLOR.GRAY_BG, 10 * pedalsSettings.store.pedalsScale)
    if CAR.rpm >= rpmStart then
      local lenght = initPosX + ((width * (CAR.rpm - rpmStart)) / rpmRange)
      local color = COLOR.GREEN

      if (CAR.rpm >= rpmFinal) then
        lenght = initPosX + width
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

      ui.drawRectFilled(vec2(initPosX, initPosY), vec2(lenght, initPosY + barHeight), color, 10 * pedalsSettings.store.pedalsScale)
    end 
  end
end 
--

-- Desenha a embreagem
local function drawClutch()
  contentMidle = 73 * pedalsSettings.store.pedalsScale
  local posBar = vec2(currentWindowWidth, 6 * pedalsSettings.store.pedalsScale + contentTop)
  
  if pedalsSettings.store.textBarsActive then
    drawBarText(100 - CAR.clutch * 100, COLOR.BLUE, posBar)
  end
  
  if pedalsSettings.store.pedalLimitsLines then
    drawBarWithLimits(posBar, CAR.clutch, COLOR.BLUE, true)
  else
    drawBarSimple(posBar, CAR.clutch, COLOR.BLUE, true)
  end
  
  currentWindowWidth = currentWindowWidth + barSize.x + barSpace
end

-- Desenha o freio
local function drawBrake()
  contentMidle = 73 * pedalsSettings.store.pedalsScale
  local posBar = vec2(currentWindowWidth, 6 * pedalsSettings.store.pedalsScale + contentTop)
  
  if pedalsSettings.store.textBarsActive then
    drawBarText(CAR.brake * 100, COLOR.RED_DARK, posBar)
  end
  
  if pedalsSettings.store.pedalLimitsLines then
    drawBarWithLimits(posBar, CAR.brake, COLOR.RED_DARK, false)
  else
    drawBarSimple(posBar, CAR.brake, COLOR.RED_DARK, false)
  end
  
  currentWindowWidth = currentWindowWidth + barSize.x + barSpace
end


-- Desenha o acelerador
local function drawAccelerator()
  contentMidle = 73 * pedalsSettings.store.pedalsScale
  local posBar = vec2(currentWindowWidth, 6 * pedalsSettings.store.pedalsScale + contentTop)
  
  if pedalsSettings.store.textBarsActive then
    drawBarText(CAR.gas * 100, COLOR.GREEN, posBar)
  end
  
  if pedalsSettings.store.pedalLimitsLines then
    drawBarWithLimits(posBar, CAR.gas, COLOR.GREEN, false)
  else
    drawBarSimple(posBar, CAR.gas, COLOR.GREEN, false)
  end
  
  currentWindowWidth = currentWindowWidth + barSize.x + barSpace
end

-- Desenha o freio de mão
local function drawHandbrake()
  contentMidle = 73 * pedalsSettings.store.pedalsScale
  local posBar = vec2(currentWindowWidth, 6 * pedalsSettings.store.pedalsScale + contentTop)
  
  if pedalsSettings.store.textBarsActive then
    drawBarText(CAR.handbrake * 100, COLOR.YELLOW, posBar)
  end
  
  if pedalsSettings.store.pedalLimitsLines then
    drawBarWithLimits(posBar, CAR.handbrake, COLOR.YELLOW, false)
  else
    drawBarSimple(posBar, CAR.handbrake, COLOR.YELLOW, false)
  end
  
  currentWindowWidth = currentWindowWidth + barSize.x + barSpace
end

-- Desenha o volante
local function drawWheel()
  contentMidle = 73 * pedalsSettings.store.pedalsScale
  local wheelBackgroundSize = vec2(55 * pedalsSettings.store.pedalsScale, currentWindowHeight)
  
  local p1 = currentWindowWidth - 4 * pedalsSettings.store.pedalsScale
  local p2 = 1 * pedalsSettings.store.pedalsScale + contentTop
  local width = 65 * pedalsSettings.store.pedalsScale
  local height = 72 * pedalsSettings.store.pedalsScale
  if pedalsSettings.store.wheelType == 1 then
    ui.setCursor(vec2(p1, p2))
    ui.beginRotation()
    ui.image("assets/Wheel.png", vec2(width, height), ui.ImageFit.Fit)
    ui.endRotation(90 - CAR.steer)
  elseif pedalsSettings.store.wheelType == 2 then
    local thickness = 7 * pedalsSettings.store.pedalsScale
    local lenght = 5 * pedalsSettings.store.pedalsScale
    ui.beginRotation()
    ui.drawCircle(vec2(p1 + (width / 2),  p2 + (height / 2)), width / 2 - thickness, COLOR.GRAY_BG, 50 , thickness)
    ui.drawRectFilled(
      vec2(p1 + (width / 2) - lenght, p2 + thickness),
      vec2(p1 + (width / 2) + lenght, p2 +  15 * pedalsSettings.store.pedalsScale),
      COLOR.YELLOW_DARK,
      2 * pedalsSettings.store.pedalsScale
    )
    ui.endRotation(90 - CAR.steer)
  end
  
  currentWindowWidth = currentWindowWidth + wheelBackgroundSize.x + 12 * pedalsSettings.store.pedalsScale + barSpace
end

-- Desenha o ABS
local function drawABS()
  contentMidle = 73 * pedalsSettings.store.pedalsScale
  local absBackgroundSize = vec2(76 * pedalsSettings.store.pedalsScale, currentWindowHeight)
  
  ui.setCursor(vec2(currentWindowWidth - 9 * pedalsSettings.store.pedalsScale, -4 * pedalsSettings.store.pedalsScale + contentTop))
  if CAR.absInAction then
    ui.image("assets/ABS.png", vec2(80,80):scale(pedalsSettings.store.pedalsScale), COLOR.RED, ui.ImageFit.Fit)
  else
    ui.image("assets/ABS.png", vec2(80,80):scale(pedalsSettings.store.pedalsScale), COLOR.GRAY_BG, ui.ImageFit.Fit)
  end
  
  currentWindowWidth = currentWindowWidth + absBackgroundSize.x
end

-- Desenha o controle de tração
local function drawTC()
  ui.setCursor(vec2(currentWindowWidth - 22 * pedalsSettings.store.pedalsScale, 1 * pedalsSettings.store.pedalsScale ))
  if CAR.tractionControlInAction then
    ui.image("assets/TC.png", vec2(20, 20):scale(pedalsSettings.store.pedalsScale), COLOR.YELLOW, ui.ImageFit.Fit)
  else
    ui.image("assets/TC.png", vec2(20, 20):scale(pedalsSettings.store.pedalsScale), COLOR.GRAY_BG, ui.ImageFit.Fit)
  end
end

-- Desenha o brake bias
local function drawBrakeBias()
  if (currentWindowWidth < 60 * pedalsSettings.store.pedalsScale) then
    currentWindowWidth = currentWindowWidth + (60 * pedalsSettings.store.pedalsScale - currentWindowWidth)
  end
  
  setPositionContentBorder(pedalsSettings.store.brakebiasPos, vec2(56, 20):scale(pedalsSettings.store.pedalsScale))

  --ui.drawRectFilled(contentPositions[pedalsSettings.store.brakebiasPos][1], contentPositions[pedalsSettings.store.brakebiasPos][1] + vec2(56, 20):scale(pedalsSettings.store.pedalsScale), COLOR.BLUE)

  ui.setCursor(contentPositions[pedalsSettings.store.brakebiasPos][1] + vec2(25) * pedalsSettings.store.pedalsScale)
  ui.dwriteTextAligned(string.format("%.1f", CAR.brakeBias * 100), fontContentBottom, ui.Alignment.Start, ui.Alignment.Center, vec2(30, 20):scale(pedalsSettings.store.pedalsScale), false, COLOR.WHITE)
  
  ui.setCursor(contentPositions[pedalsSettings.store.brakebiasPos][1] + vec2(4,2) * pedalsSettings.store.pedalsScale)
  ui.image("assets/BrakeBias.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), ui.ImageFit.Fit)
end

-- Desenha a bateria
local oldKersCharge = 0
local function drawP2p()
  local size = vec2(80 * pedalsSettings.store.pedalsScale, 10 * pedalsSettings.store.pedalsScale)
  setPositionContentCenter(pedalsSettings.store.p2pPos, size)
  local pos = vec2()
  pos.y = contentPositions[pedalsSettings.store.p2pPos][1].y
  local space
  local center
  if pedalsSettings.store.p2pPos == 5 then
    space = currentWindowWidth - contentPositions[1][2].x - contentPositions[2][2].x
    if space < 90 * pedalsSettings.store.pedalsScale then
      currentWindowWidth = currentWindowWidth + (90 * pedalsSettings.store.pedalsScale - space)
      space = currentWindowWidth - contentPositions[1][2].x - contentPositions[2][2].x
    end
    center = contentPositions[1][2].x + (space) / 2
    pos.x = center - (size.x / 2)
    pos.y = pos.y + 5 * pedalsSettings.store.pedalsScale
  else
    space = currentWindowWidth - contentPositions[3][2].x - contentPositions[4][2].x
        if space < 90 * pedalsSettings.store.pedalsScale then
      currentWindowWidth = currentWindowWidth + (90 * pedalsSettings.store.pedalsScale - space)
      space = currentWindowWidth - contentPositions[3][2].x - contentPositions[4][2].x
    end
    center = contentPositions[3][2].x + (space) / 2
    pos.x = center - (size.x / 2)
    pos.y = pos.y - 5 * pedalsSettings.store.pedalsScale
  end

  ui.drawRectFilled(pos, pos + size, COLOR.GRAY_BG, 10 * pedalsSettings.store.pedalsScale)

  local color 
  if oldKersCharge < CAR.kersCharge then
    color = COLOR.GREEN
  else if oldKersCharge > CAR.kersCharge then
        color = COLOR.RED
    else
      color = COLOR.BLUE_SKY
    end
  end

  ui.drawRectFilled(pos, pos + vec2(size.x * CAR.kersCharge, size.y), color, 10 * pedalsSettings.store.pedalsScale)
  ui.setCursor(pos)
  ui.dwriteTextAligned(string.format("%.0f%%", CAR.kersCharge * 100), 10 * pedalsSettings.store.pedalsScale, ui.Alignment.Center, ui.Alignment.Center, vec2(size.x, size.y), false, COLOR.WHITE)
  oldKersCharge = CAR.kersCharge
end


-- Desenha o combustível
local function drawFuel()
  if pedalsSettings.store.brakeBiasActive and currentWindowWidth < 120 * pedalsSettings.store.pedalsScale then
    currentWindowWidth = 120 * pedalsSettings.store.pedalsScale
  end
  if (currentWindowWidth < 68 * pedalsSettings.store.pedalsScale) then
    currentWindowWidth = 68 * pedalsSettings.store.pedalsScale
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

  setPositionContentBorder(pedalsSettings.store.fuelPos, vec2(65, 20):scale(pedalsSettings.store.pedalsScale))
  --ui.drawRectFilled(contentPositions[pedalsSettings.store.fuelPos][1], contentPositions[pedalsSettings.store.fuelPos][1] + vec2(65, 20):scale(pedalsSettings.store.pedalsScale), COLOR.BLUE)
  ui.setCursor(contentPositions[pedalsSettings.store.fuelPos][1] + vec2(22) * pedalsSettings.store.pedalsScale)
  ui.dwriteTextAligned(string.format("%.2f", math.max(0, CAR.fuel)), fontContentBottom, ui.Alignment.Start, ui.Alignment.Center, vec2(50, 20):scale(pedalsSettings.store.pedalsScale), false, fuelColor)
  
  --local iconXOffset = (CAR.fuel >= 99.995) and 65 or ((CAR.fuel >= 9.995) and 59 or 56)
  ui.setCursor(contentPositions[pedalsSettings.store.fuelPos][1] + vec2(4, 2.5):scale(pedalsSettings.store.pedalsScale))
  if CAR.fuel < 5.005 then
    if (4 * Timer) % 2 >= 1 then 
      ui.image("assets/Fuel.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), fuelColor, ui.ImageFit.Fit)
    end
  else 
    ui.image("assets/Fuel.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), fuelColor, ui.ImageFit.Fit)
  end
  
end

function pedals.windowMain()
  ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
  fontBar = 15 * pedalsSettings.store.pedalsScale
  fontBarInfinite = 25 * pedalsSettings.store.pedalsScale
  fontContentBottom = 13 * pedalsSettings.store.pedalsScale

  barSize = vec2(20, 60) * pedalsSettings.store.pedalsScale
  barSpace = 4 * pedalsSettings.store.pedalsScale
  barLimitSize = vec2(20, 6) * pedalsSettings.store.pedalsScale
  barMidleSize = vec2(20, 44) * pedalsSettings.store.pedalsScale
  barPaddingMidle = 2 * pedalsSettings.store.pedalsScale
  --ui.drawRectFilled(vec2(0,0), vec2(65,20):scale(pedalsSettings.store.pedalsScale), COLOR.GRAY_BG)
  contentPositions = {
    { vec2(0, 0), vec2(0, 0) }, -- SUPERIOR ESQUEDO
    { vec2(currentWindowSize.x, 0), vec2(0, 0) }, -- SUPERIOR DIREITO
    { vec2(0, currentWindowSize.y), vec2(0, 0)}, -- INFERIOR ESQUERDO
    { vec2(currentWindowSize.x, currentWindowSize.y ), vec2(0, 0) }, -- INFERIOR DIREITO
    { vec2(currentWindowSize.x / 2, 0), vec2(0, 0) }, -- SUPERIOR MEIO
    { vec2(currentWindowSize.x / 2, currentWindowSize.y), vec2(0, 0) }, -- INFERIOR MEIO
  }

  if pedalsSettings.store.textBarsActive and 
    contentMidle > 0 and 
    (pedalsSettings.store.clutchActive or pedalsSettings.store.brakeActive or pedalsSettings.store.throttleActive or pedalsSettings.store.handbrakeActive) then
      contentTop = contentTop + 8 * pedalsSettings.store.pedalsScale
  end
  --if pedalsSettings.store.rpmActive or pedalsSettings.store.tractionControlActive then contentTop = contentTop + 22 end

  currentWindowWidth = 0
  currentWindowHeight = contentMidle + contentTop + contentBottom
  contentMidle = 0
  
  -- Desenha background principal
  ui.drawRectFilled(vec2(0, 0), currentWindowSize, WindowsColor, 10 * pedalsSettings.store.pedalsScale)

  -- Desenha componentes

  if pedalsSettings.store.gearActive then
    drawGear()
  else 
    fontGear = 0
  end
  
  if pedalsSettings.store.speedActive then
    drawSpeed()
  end
  
  currentWindowWidth = currentWindowWidth + 7 * pedalsSettings.store.pedalsScale + barSpace
  
  if pedalsSettings.store.clutchActive then
    drawClutch()
  end
  
  if pedalsSettings.store.brakeActive then
    drawBrake()
  end
  
  if pedalsSettings.store.throttleActive then
    drawAccelerator()
  end
  
  if pedalsSettings.store.handbrakeActive then
    drawHandbrake()
  end
  
  currentWindowWidth = currentWindowWidth + 7 * pedalsSettings.store.pedalsScale
  
  if pedalsSettings.store.wheelActive then
    drawWheel()
  end
  
  if pedalsSettings.store.absActive and CAR.absModes ~= 0 then
    drawABS()
  end

  if pedalsSettings.store.brakeBiasActive then
    --contentBottom = 20 * pedalsSettings.store.pedalsScale
    drawBrakeBias()
  end
  
  if pedalsSettings.store.fuelActive then
    drawFuel()
  end

  if pedalsSettings.store.rpmActive then 
    drawRpm()
  end
  if pedalsSettings.store.p2pActive then
    drawP2p()
  end

  if pedalsSettings.store.tractionControlActive and CAR.tractionControlModes ~= 0 then
    drawTC()
  end

  if contentPositions[1][2] ~= vec2(0, 0) or contentPositions[2][2] ~= vec2(0, 0) or contentPositions[5][2] ~= vec2(0, 0) then
    contentTop = math.max(contentPositions[1][2].y, contentPositions[2][2].y, contentPositions[5][2].y)
  else
    contentTop = 0 
  end

  if contentPositions[3][2] ~= vec2(0, 0) or contentPositions[4][2] ~= vec2(0, 0) or contentPositions[6][2] ~= vec2(0, 0) then
    contentBottom = math.max(contentPositions[3][2].y, contentPositions[4][2].y, contentPositions[6][2].y)
  else
    contentBottom = 0 
  end
  --
  currentWindowSize = vec2(currentWindowWidth, currentWindowHeight)

  config.resize(currentWindowSize, "Pedals")

  pinCheckBox.main(pedalsSettings.store.pedalsScale, "Pedals", config.getWindow("Pedals"):pinned(), currentWindowSize)
end

return pedals