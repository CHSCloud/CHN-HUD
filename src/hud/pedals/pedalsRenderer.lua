local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pedalsData = require("src.data.pedals.pedalsData")

local pedalsRenderer = {}

local function drawBarText(data, value, color, posBar)
  data.contentMidle = 73 * pedalsSettings.store.pedalsScale
  if value < 98.99 then
    ui.setCursor(vec2(data.currentWindowWidth, posBar.y - 17 * pedalsSettings.store.pedalsScale))
    ui.dwriteTextAligned(string.format("%.0f", value), data.fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(pedalsSettings.store.pedalsScale), false, COLOR.WHITE)
  else
    ui.setCursor(vec2(data.currentWindowWidth, posBar.y - 25 * pedalsSettings.store.pedalsScale))
    ui.dwriteTextAligned("∞", data.fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(pedalsSettings.store.pedalsScale), false, color)
  end
end

local function drawBarWithLimits(data, posBar, value, color, inverted)
  data.contentMidle = 73 * pedalsSettings.store.pedalsScale
  ui.drawRectFilled(posBar, posBar + data.barLimitSize, COLOR.GRAY_BG)

  ui.drawRectFilled(
    posBar + vec2(0, data.barLimitSize.y + data.barPaddingMidle),
    posBar + vec2(0, data.barLimitSize.y + data.barPaddingMidle) + data.barMidleSize,
    COLOR.GRAY_BG
  )

  ui.drawRectFilled(
    posBar + vec2(0, data.barLimitSize.y + data.barMidleSize.y + 2 * data.barPaddingMidle),
    posBar + vec2(0, data.barLimitSize.y + data.barMidleSize.y + 2 * data.barPaddingMidle) + data.barLimitSize,
    COLOR.GRAY_BG
  )

  if inverted then
    if value == 0 then
      ui.drawRectFilled(posBar, posBar + data.barLimitSize, color)
    end
    if value < 1 then
      ui.drawRectFilled(
        posBar + vec2(0, data.barLimitSize.y + 2 * data.barPaddingMidle + data.barMidleSize.y),
        posBar + vec2(0, data.barLimitSize.y + 2 * data.barPaddingMidle + data.barMidleSize.y) + data.barLimitSize,
        color
      )
    end
    ui.drawRectFilled(
      posBar + vec2(0, data.barLimitSize.y + data.barPaddingMidle + (value * data.barMidleSize.y)),
      posBar + vec2(0, data.barLimitSize.y + data.barPaddingMidle) + data.barMidleSize,
      color
    )
  else
    if value > 0 then
      ui.drawRectFilled(
        posBar + vec2(0, data.barLimitSize.y + 2 * data.barPaddingMidle + data.barMidleSize.y),
        posBar + vec2(0, data.barLimitSize.y + 2 * data.barPaddingMidle + data.barMidleSize.y) + data.barLimitSize,
        color
      )
    end
    if value == 1 then
      ui.drawRectFilled(posBar, posBar + data.barLimitSize, color)
    end
    ui.drawRectFilled(
      posBar + vec2(0, data.barLimitSize.y + data.barPaddingMidle + data.barMidleSize.y - (value * data.barMidleSize.y)),
      posBar + vec2(0, data.barLimitSize.y + data.barPaddingMidle) + data.barMidleSize,
      color
    )
  end
end

local function drawBarSimple(data, posBar, value, color, inverted)
  data.contentMidle = 73 * pedalsSettings.store.pedalsScale
  ui.drawRectFilled(posBar, posBar + data.barSize, COLOR.GRAY_BG)

  if inverted then
    ui.drawRectFilled(posBar + vec2(0, (value * data.barSize.y)), posBar + data.barSize, color)
  else
    ui.drawRectFilled(posBar + vec2(0, data.barSize.y - (value * data.barSize.y)), posBar + data.barSize, color)
  end
end



function pedalsRenderer.drawSpeed(data)
  data.contentMidle = 73 * pedalsSettings.store.pedalsScale
  data.gearBackgroundWidth = 60 * pedalsSettings.store.pedalsScale
  data.currentWindowWidth = data.gearBackgroundWidth
  data.fontSpeed = 20 * pedalsSettings.store.pedalsScale
  local speed
  if SelectedSpeed == 1 then
    speed = string.format("%.0f", CAR.speedKmh)
  else
    speed = string.format("%.0f", CAR.speedKmh * 0.621371)
  end

  if pedalsSettings.store.gearActive then
    ui.setCursor(vec2(11, 41):scale(pedalsSettings.store.pedalsScale) + vec2(0, data.contentTop))
    ui.dwriteTextAligned(speed, data.fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(50, 30):scale(pedalsSettings.store.pedalsScale), false, COLOR.WHITE)
  else
    data.fontSpeed = 25 * pedalsSettings.store.pedalsScale
    ui.setCursor(vec2(11, 19):scale(pedalsSettings.store.pedalsScale) + vec2(0, data.contentTop))
    ui.dwriteTextAligned(speed, data.fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(50, 35):scale(pedalsSettings.store.pedalsScale), false, COLOR.WHITE)
  end
end

function pedalsRenderer.drawRpm(data)
  local rpmStart = CAR.rpmLimiter * 0.80
  local rpmFinal = CAR.rpmLimiter * 0.98
  local rpmRange = rpmFinal - rpmStart

  if pedalsSettings.store.rpmType == 1 then
    local area = 0
    local spaceCircles
    local space
    local center
    local posY
    if pedalsSettings.store.rpmPos == 5 then
      space = data.currentWindowWidth * 0.95 - data.contentPositions[1][2].x - data.contentPositions[2][2].x
      if space < 75 * pedalsSettings.store.pedalsScale then
        data.currentWindowWidth = data.currentWindowWidth + (75 * pedalsSettings.store.pedalsScale - space)
        space = data.currentWindowWidth * 0.95 - data.contentPositions[1][2].x - data.contentPositions[2][2].x
      end

      if space == data.currentWindowWidth * 0.95 then
        center = data.currentWindowWidth / 2
      else
        center = data.contentPositions[1][2].x + (data.currentWindowWidth - data.contentPositions[1][2].x - data.contentPositions[2][2].x) / 2
      end
      posY = data.contentPositions[pedalsSettings.store.rpmPos][1].y + 10 * pedalsSettings.store.pedalsScale
    else
      space = data.currentWindowWidth * 0.95 - data.contentPositions[3][2].x - data.contentPositions[4][2].x
      if space < 75 * pedalsSettings.store.pedalsScale then
        data.currentWindowWidth = data.currentWindowWidth + (75 * pedalsSettings.store.pedalsScale - space)
        space = data.currentWindowWidth * 0.95 - data.contentPositions[3][2].x - data.contentPositions[4][2].x
      end
      if space == data.currentWindowWidth * 0.95 then
        center = data.currentWindowWidth / 2
      else
        center = data.contentPositions[3][2].x + (data.currentWindowWidth - data.contentPositions[3][2].x - data.contentPositions[4][2].x) / 2
      end
      posY = data.contentPositions[pedalsSettings.store.rpmPos][1].y - 10 * pedalsSettings.store.pedalsScale
    end

    area = space / data.currentWindowWidth
    spaceCircles = math.min((data.currentWindowWidth * area) / (pedalsSettings.store.numLights * pedalsSettings.store.pedalsScale), 18)
    pedalsData.setPositionContentCenter(data, pedalsSettings.store.rpmPos, vec2(space, 20 * pedalsSettings.store.pedalsScale))

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
      elseif (CAR.rpm >= CAR.rpmLimiter * 0.95) then
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
    local space
    local initPosX
    local center
    local initPosY
    if pedalsSettings.store.rpmPos == 5 then
      space = data.currentWindowWidth - data.contentPositions[1][2].x - data.contentPositions[2][2].x
      width = space * pedalsSettings.store.barLength
      if space < 75 * pedalsSettings.store.pedalsScale then
        data.currentWindowWidth = data.currentWindowWidth + (75 * pedalsSettings.store.pedalsScale - space)
        space = data.currentWindowWidth - data.contentPositions[1][2].x - data.contentPositions[2][2].x
        width = space * pedalsSettings.store.barLength
      end

      center = data.contentPositions[1][2].x + (data.currentWindowWidth - data.contentPositions[1][2].x - data.contentPositions[2][2].x) / 2
      pedalsData.setPositionContentCenter(data, pedalsSettings.store.rpmPos, vec2(width, 20 * pedalsSettings.store.pedalsScale))
      initPosY = data.contentPositions[1][1].y + 4 * pedalsSettings.store.pedalsScale
    else
      space = data.currentWindowWidth - data.contentPositions[3][2].x - data.contentPositions[4][2].x
      width = space * pedalsSettings.store.barLength
      if space < 75 * pedalsSettings.store.pedalsScale then
        data.currentWindowWidth = data.currentWindowWidth + (75 * pedalsSettings.store.pedalsScale - space)
        space = data.currentWindowWidth - data.contentPositions[3][2].x - data.contentPositions[4][2].x
        width = space * pedalsSettings.store.barLength
      end

      center = data.contentPositions[3][2].x + (data.currentWindowWidth - data.contentPositions[3][2].x - data.contentPositions[4][2].x) / 2
      pedalsData.setPositionContentCenter(data, pedalsSettings.store.rpmPos, vec2(width, 20 * pedalsSettings.store.pedalsScale))
      initPosY = data.contentPositions[pedalsSettings.store.rpmPos][1].y + 2 * pedalsSettings.store.pedalsScale
    end
    local barHeight = 14 * pedalsSettings.store.pedalsScale
    initPosX = center - (width / 2)
    ui.drawRectFilled(vec2(initPosX, initPosY), vec2(initPosX + width, initPosY + barHeight), COLOR.GRAY_BG, 10 * pedalsSettings.store.pedalsScale)
    if CAR.rpm >= rpmStart then
      local length = initPosX + ((width * (CAR.rpm - rpmStart)) / rpmRange)
      local color = COLOR.GREEN

      if (CAR.rpm >= rpmFinal) then
        length = initPosX + width
        if (8 * Timer) % 2 >= 1 then
          color = COLOR.GRAY_BG
        else
          color = COLOR.RED_DARK
        end
      elseif (CAR.rpm >= rpmFinal * 0.95) then
        color = COLOR.RED_DARK
      elseif (CAR.rpm >= rpmFinal * 0.90) then
        color = COLOR.YELLOW
      end

      ui.drawRectFilled(vec2(initPosX, initPosY), vec2(length, initPosY + barHeight), color, 10 * pedalsSettings.store.pedalsScale)
    end
  end
end

function pedalsRenderer.drawClutch(data)
  data.contentMidle = 73 * pedalsSettings.store.pedalsScale
  local posBar = vec2(data.currentWindowWidth, 6 * pedalsSettings.store.pedalsScale + data.contentTop)

  if pedalsSettings.store.textBarsActive then
    drawBarText(data, 100 - CAR.clutch * 100, COLOR.BLUE, posBar)
  end

  if pedalsSettings.store.pedalLimitsLines then
    drawBarWithLimits(data, posBar, CAR.clutch, COLOR.BLUE, true)
  else
    drawBarSimple(data, posBar, CAR.clutch, COLOR.BLUE, true)
  end

  data.currentWindowWidth = data.currentWindowWidth + data.barSize.x + data.barSpace
end

function pedalsRenderer.drawBrake(data)
  data.contentMidle = 73 * pedalsSettings.store.pedalsScale
  local posBar = vec2(data.currentWindowWidth, 6 * pedalsSettings.store.pedalsScale + data.contentTop)

  if pedalsSettings.store.textBarsActive then
    drawBarText(data, CAR.brake * 100, COLOR.RED_DARK, posBar)
  end

  if pedalsSettings.store.pedalLimitsLines then
    drawBarWithLimits(data, posBar, CAR.brake, COLOR.RED_DARK, false)
  else
    drawBarSimple(data, posBar, CAR.brake, COLOR.RED_DARK, false)
  end

  data.currentWindowWidth = data.currentWindowWidth + data.barSize.x + data.barSpace
end

function pedalsRenderer.drawAccelerator(data)
  data.contentMidle = 73 * pedalsSettings.store.pedalsScale
  local posBar = vec2(data.currentWindowWidth, 6 * pedalsSettings.store.pedalsScale + data.contentTop)

  if pedalsSettings.store.textBarsActive then
    drawBarText(data, CAR.gas * 100, COLOR.GREEN, posBar)
  end

  if pedalsSettings.store.pedalLimitsLines then
    drawBarWithLimits(data, posBar, CAR.gas, COLOR.GREEN, false)
  else
    drawBarSimple(data, posBar, CAR.gas, COLOR.GREEN, false)
  end

  data.currentWindowWidth = data.currentWindowWidth + data.barSize.x + data.barSpace
end

function pedalsRenderer.drawHandbrake(data)
  data.contentMidle = 73 * pedalsSettings.store.pedalsScale
  local posBar = vec2(data.currentWindowWidth, 6 * pedalsSettings.store.pedalsScale + data.contentTop)

  if pedalsSettings.store.textBarsActive then
    drawBarText(data, CAR.handbrake * 100, COLOR.YELLOW, posBar)
  end

  if pedalsSettings.store.pedalLimitsLines then
    drawBarWithLimits(data, posBar, CAR.handbrake, COLOR.YELLOW, false)
  else
    drawBarSimple(data, posBar, CAR.handbrake, COLOR.YELLOW, false)
  end

  data.currentWindowWidth = data.currentWindowWidth + data.barSize.x + data.barSpace
end

function pedalsRenderer.drawWheel(data)
  data.contentMidle = 73 * pedalsSettings.store.pedalsScale
  local wheelBackgroundSize = vec2(55 * pedalsSettings.store.pedalsScale, data.currentWindowHeight)

  local p1 = data.currentWindowWidth - 4 * pedalsSettings.store.pedalsScale
  local p2 = 1 * pedalsSettings.store.pedalsScale + data.contentTop
  local width = 65 * pedalsSettings.store.pedalsScale
  local height = 72 * pedalsSettings.store.pedalsScale
  if pedalsSettings.store.wheelType == 1 then
    ui.setCursor(vec2(p1, p2))
    ui.beginRotation()
    ui.image("assets/Wheel.png", vec2(width, height), ui.ImageFit.Fit)
    ui.endRotation(90 - CAR.steer)
  elseif pedalsSettings.store.wheelType == 2 then
    local thickness = 7 * pedalsSettings.store.pedalsScale
    local length = 5 * pedalsSettings.store.pedalsScale
    ui.beginRotation()
    ui.drawCircle(vec2(p1 + (width / 2), p2 + (height / 2)), width / 2 - thickness, COLOR.GRAY_BG, 50, thickness)
    ui.drawRectFilled(
      vec2(p1 + (width / 2) - length, p2 + thickness),
      vec2(p1 + (width / 2) + length, p2 + 15 * pedalsSettings.store.pedalsScale),
      COLOR.YELLOW_DARK,
      2 * pedalsSettings.store.pedalsScale
    )
    ui.endRotation(90 - CAR.steer)
  end

  data.currentWindowWidth = data.currentWindowWidth + wheelBackgroundSize.x + 12 * pedalsSettings.store.pedalsScale + data.barSpace
end

function pedalsRenderer.drawABS(data)
  data.contentMidle = 73 * pedalsSettings.store.pedalsScale
  local absBackgroundSize = vec2(76 * pedalsSettings.store.pedalsScale, data.currentWindowHeight)

  ui.setCursor(vec2(data.currentWindowWidth - 9 * pedalsSettings.store.pedalsScale, -4 * pedalsSettings.store.pedalsScale + data.contentTop))
  if CAR.absInAction then
    ui.image("assets/ABS.png", vec2(80, 80):scale(pedalsSettings.store.pedalsScale), COLOR.RED, ui.ImageFit.Fit)
  else
    ui.image("assets/ABS.png", vec2(80, 80):scale(pedalsSettings.store.pedalsScale), COLOR.GRAY_BG, ui.ImageFit.Fit)
  end

  data.currentWindowWidth = data.currentWindowWidth + absBackgroundSize.x
end

function pedalsRenderer.drawTC(data)
  local size = vec2(30, 20):scale(pedalsSettings.store.pedalsScale)
  pedalsData.setPositionContentBorder(data, pedalsSettings.store.tractionControlPos, size)
  ui.setCursor(data.contentPositions[pedalsSettings.store.tractionControlPos][1])
  if CAR.tractionControlInAction then
    ui.image("assets/TC.png", size, COLOR.RED, ui.ImageFit.Fit)
  else
    ui.image("assets/TC.png", size, COLOR.WHITE, ui.ImageFit.Fit)
  end
end

function pedalsRenderer.drawDRSActivation(data)
  local size = vec2(55, 22):scale(pedalsSettings.store.pedalsScale)
  pedalsData.setPositionContentBorder(data, pedalsSettings.store.drsPos, size)
  ui.setCursor(data.contentPositions[pedalsSettings.store.drsPos][1])

  ui.setCursor(data.contentPositions[pedalsSettings.store.drsPos][1] + vec2(24, 4):scale(pedalsSettings.store.pedalsScale))
  ui.dwriteTextAligned("DRS", 11 * pedalsSettings.store.pedalsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(30, 14):scale(pedalsSettings.store.pedalsScale), false, COLOR.WHITE)
  local color
  if CAR.drsAvailable then
    if data.initDRSActivation == 0 then
      data.initDRSActivation = Timer
    end
    if Timer - data.initDRSActivation < 4 then
      if (4 * Timer) % 2 >= 1 then
        color = COLOR.GREEN
      else
        color = COLOR.GRAY_BG
      end
    else
      color = COLOR.GREEN
    end
  else
    data.initDRSActivation = 0
    color = COLOR.GRAY_BG
  end
  ui.drawCircleFilled(data.contentPositions[pedalsSettings.store.drsPos][1] + vec2(15, 11):scale(pedalsSettings.store.pedalsScale), 7 * pedalsSettings.store.pedalsScale, color, 20 * pedalsSettings.store.pedalsScale)
end

function pedalsRenderer.drawBrakeBias(data)
  pedalsData.setPositionContentBorder(data, pedalsSettings.store.brakebiasPos, vec2(60, 20):scale(pedalsSettings.store.pedalsScale))
  ui.setCursor(data.contentPositions[pedalsSettings.store.brakebiasPos][1] + vec2(25) * pedalsSettings.store.pedalsScale)
  ui.dwriteTextAligned(string.format("%.1f", CAR.brakeBias * 100), data.fontContentBottom, ui.Alignment.Start, ui.Alignment.Center, vec2(30, 20):scale(pedalsSettings.store.pedalsScale), false, COLOR.WHITE)

  ui.setCursor(data.contentPositions[pedalsSettings.store.brakebiasPos][1] + vec2(4, 2) * pedalsSettings.store.pedalsScale)
  ui.image("assets/BrakeBias.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), ui.ImageFit.Fit)
end

function pedalsRenderer.drawP2p(data)
  local oldKersCharge = 0
  local size = vec2(0, 10 * pedalsSettings.store.pedalsScale)
  local pos = vec2()
  pos.y = data.contentPositions[pedalsSettings.store.p2pPos][1].y
  local space
  local center
  if pedalsSettings.store.p2pPos == 5 then
    space = data.currentWindowWidth - data.contentPositions[1][2].x - data.contentPositions[2][2].x
    if space < 75 * pedalsSettings.store.pedalsScale then
      data.currentWindowWidth = data.currentWindowWidth + (80 * pedalsSettings.store.pedalsScale - space)
      space = data.currentWindowWidth - data.contentPositions[1][2].x - data.contentPositions[2][2].x
    end
    size.x = space * pedalsSettings.store.p2pLenght
    center = data.contentPositions[1][2].x + (space) / 2
    pos.x = center - (size.x / 2)
    pos.y = pos.y + 5 * pedalsSettings.store.pedalsScale
  else
    space = data.currentWindowWidth - data.contentPositions[3][2].x - data.contentPositions[4][2].x
    if space < 75 * pedalsSettings.store.pedalsScale then
      data.currentWindowWidth = data.currentWindowWidth + (80 * pedalsSettings.store.pedalsScale - space)
      space = data.currentWindowWidth - data.contentPositions[3][2].x - data.contentPositions[4][2].x
    end
    size.x = math.max(space * pedalsSettings.store.p2pLenght, 50 * pedalsSettings.store.pedalsScale)
    center = data.contentPositions[3][2].x + (space) / 2
    pos.x = center - (size.x / 2)
    pos.y = pos.y - 15 * pedalsSettings.store.pedalsScale
  end
  data:setPositionContentCenter(pedalsSettings.store.p2pPos, size + vec2(0, 5):scale(pedalsSettings.store.pedalsScale))

  ui.drawRectFilled(pos, pos + size, COLOR.GRAY_BG, 10 * pedalsSettings.store.pedalsScale)

  local color
  if oldKersCharge < CAR.kersCharge then
    color = COLOR.GREEN
  elseif oldKersCharge > CAR.kersCharge then
    color = COLOR.RED
  else
    color = COLOR.BLUE_SKY
  end

  if CAR.kersCharge > 0.01 then
    ui.drawRectFilled(pos, pos + vec2(size.x * CAR.kersCharge, size.y), color, 10 * pedalsSettings.store.pedalsScale)
  end
  ui.setCursor(pos)
  ui.dwriteTextAligned(string.format("%.0f%%", CAR.kersCharge * 100), 10 * pedalsSettings.store.pedalsScale, ui.Alignment.Center, ui.Alignment.Center, vec2(size.x, size.y), false, COLOR.WHITE)
end

function pedalsRenderer.drawFuel(data)
  local fuelColor = COLOR.WHITE
  if CAR.fuel < 5.005 then
    fuelColor = COLOR.RED_DARK
  elseif CAR.fuel < 9.995 then
    fuelColor = COLOR.YELLOW_DARK
  end

  pedalsData.setPositionContentBorder(data, pedalsSettings.store.fuelPos, vec2(65, 20):scale(pedalsSettings.store.pedalsScale))
  ui.setCursor(data.contentPositions[pedalsSettings.store.fuelPos][1] + vec2(22) * pedalsSettings.store.pedalsScale)
  ui.dwriteTextAligned(string.format("%.2f", math.max(0, CAR.fuel)), data.fontContentBottom, ui.Alignment.Start, ui.Alignment.Center, vec2(50, 20):scale(pedalsSettings.store.pedalsScale), false, fuelColor)
  ui.setCursor(data.contentPositions[pedalsSettings.store.fuelPos][1] + vec2(4, 2.5):scale(pedalsSettings.store.pedalsScale))
  if CAR.fuel < 5.005 then
    if (4 * Timer) % 2 >= 1 then
      ui.image("assets/Fuel.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), fuelColor, ui.ImageFit.Fit)
    end
  else
    ui.image("assets/Fuel.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), fuelColor, ui.ImageFit.Fit)
  end
end

return pedalsRenderer
