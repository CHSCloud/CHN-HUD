local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")
local pedalsData = require("src.data.pedals.pedalsData")
local pedalsRenderer = require("src.hud.pedals.pedalsRenderer")

local gear = require("src.hud.pedals.render.gear")

local pedals = {}

local data = pedalsData.new()

function pedals.windowMain()

  ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
  data.fontBar = 15 * pedalsSettings.store.pedalsScale
  data.fontBarInfinite = 25 * pedalsSettings.store.pedalsScale
  data.fontContentBottom = 13 * pedalsSettings.store.pedalsScale

  data.barSize = vec2(20, 60) * pedalsSettings.store.pedalsScale
  data.barSpace = 4 * pedalsSettings.store.pedalsScale
  data.barLimitSize = vec2(20, 6) * pedalsSettings.store.pedalsScale
  data.barMidleSize = vec2(20, 44) * pedalsSettings.store.pedalsScale
  data.barPaddingMidle = 2 * pedalsSettings.store.pedalsScale
  pedalsData.resetContentPositions(data, data.currentWindowSize)

  if pedalsSettings.store.textBarsActive and
    data.contentMidle > 0 and
    (pedalsSettings.store.clutchActive or pedalsSettings.store.brakeActive or pedalsSettings.store.throttleActive or pedalsSettings.store.handbrakeActive) then
    data.contentTop = data.contentTop + 8 * pedalsSettings.store.pedalsScale
  end

  data.currentWindowWidth = 0
  data.currentWindowHeight = data.contentMidle + data.contentTop + data.contentBottom
  data.contentMidle = 0

  ui.drawRectFilled(vec2(0, 0), data.currentWindowSize, WindowsColor, 10 * pedalsSettings.store.pedalsScale)

  if pedalsSettings.store.gearActive then
    gear.draw(data)
  else
    data.fontGear = 0
  end

  if pedalsSettings.store.speedActive then
    pedalsRenderer.drawSpeed(data)
  end

  data.currentWindowWidth = data.currentWindowWidth + 7 * pedalsSettings.store.pedalsScale + data.barSpace

  if pedalsSettings.store.clutchActive then
    pedalsRenderer.drawClutch(data)
  end

  if pedalsSettings.store.brakeActive then
    pedalsRenderer.drawBrake(data)
  end

  if pedalsSettings.store.throttleActive then
    pedalsRenderer.drawAccelerator(data)
  end

  if pedalsSettings.store.handbrakeActive then
    pedalsRenderer.drawHandbrake(data)
  end

  data.currentWindowWidth = data.currentWindowWidth + 7 * pedalsSettings.store.pedalsScale

  if pedalsSettings.store.wheelActive then
    pedalsRenderer.drawWheel(data)
  end

  if pedalsSettings.store.absActive and CAR.absModes ~= 0 then
    pedalsRenderer.drawABS(data)
  end

  if pedalsSettings.store.brakeBiasActive then
    pedalsRenderer.drawBrakeBias(data)
  end

  if pedalsSettings.store.fuelActive then
    pedalsRenderer.drawFuel(data)
  end

  if pedalsSettings.store.tractionControlActive and CAR.tractionControlModes ~= 0 then
    pedalsRenderer.drawTC(data)
  end

  if pedalsSettings.store.drsActvationActive and CAR.drsPresent then
    pedalsRenderer.drawDRSActivation(data)
  end

  if data.currentWindowWidth < (data.contentPositions[1][2].x + data.contentPositions[2][2].x + data.contentPositions[5][2].x) or data.currentWindowWidth < (data.contentPositions[3][2].x + data.contentPositions[4][2].x + data.contentPositions[6][2].x) then
    data.currentWindowWidth = math.max(data.contentPositions[1][2].x + data.contentPositions[2][2].x + data.contentPositions[5][2].x, data.contentPositions[3][2].x + data.contentPositions[4][2].x + data.contentPositions[6][2].x)
  end

  if pedalsSettings.store.p2pActive and CAR.kersPresent then
    pedalsRenderer.drawP2p(data)
  end

  if pedalsSettings.store.rpmActive then
    pedalsRenderer.drawRpm(data)
  end

  if data.contentPositions[1][2] ~= vec2(0, 0) or data.contentPositions[2][2] ~= vec2(0, 0) or data.contentPositions[5][2] ~= vec2(0, 0) then
    data.contentTop = math.max(data.contentPositions[1][2].y, data.contentPositions[2][2].y, data.contentPositions[5][2].y)
  else
    data.contentTop = 0
  end

  if data.contentPositions[3][2] ~= vec2(0, 0) or data.contentPositions[4][2] ~= vec2(0, 0) or data.contentPositions[6][2] ~= vec2(0, 0) then
    data.contentBottom = math.max(data.contentPositions[3][2].y, data.contentPositions[4][2].y, data.contentPositions[6][2].y)
  else
    data.contentBottom = 0
  end

  data.currentWindowSize = vec2(data.currentWindowWidth, data.currentWindowHeight)

  config.resize(data.currentWindowSize, "Pedals")

  pinCheckBox.main(pedalsSettings.store.pedalsScale, "Pedals", config.getWindow("Pedals"):pinned(), data.currentWindowSize)
end

return pedals