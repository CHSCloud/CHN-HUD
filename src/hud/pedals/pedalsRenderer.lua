local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pedalsData = require("src.data.pedals.pedalsData")

local pedalsRenderer = {}

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
