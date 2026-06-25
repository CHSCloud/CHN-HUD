local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")
local pedalsState = require("src.hud.pedals.pedalsState")
local pedalsRenderer = require("src.hud.pedals.pedalsRenderer")
local pedals = {}
local state = pedalsState:new()

function pedals.windowMain()

  ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
  state.fontBar = 15 * pedalsSettings.store.pedalsScale
  state.fontBarInfinite = 25 * pedalsSettings.store.pedalsScale
  state.fontContentBottom = 13 * pedalsSettings.store.pedalsScale

  state.barSize = vec2(20, 60) * pedalsSettings.store.pedalsScale
  state.barSpace = 4 * pedalsSettings.store.pedalsScale
  state.barLimitSize = vec2(20, 6) * pedalsSettings.store.pedalsScale
  state.barMidleSize = vec2(20, 44) * pedalsSettings.store.pedalsScale
  state.barPaddingMidle = 2 * pedalsSettings.store.pedalsScale
  state:resetContentPositions(state.currentWindowSize)

  if pedalsSettings.store.textBarsActive and
    state.contentMidle > 0 and
    (pedalsSettings.store.clutchActive or pedalsSettings.store.brakeActive or pedalsSettings.store.throttleActive or pedalsSettings.store.handbrakeActive) then
    state.contentTop = state.contentTop + 8 * pedalsSettings.store.pedalsScale
  end

  state.currentWindowWidth = 0
  state.currentWindowHeight = state.contentMidle + state.contentTop + state.contentBottom
  state.contentMidle = 0

  ui.drawRectFilled(vec2(0, 0), state.currentWindowSize, WindowsColor, 10 * pedalsSettings.store.pedalsScale)

  if pedalsSettings.store.gearActive then
    pedalsRenderer.drawGear(state)
  else
    state.fontGear = 0
  end

  if pedalsSettings.store.speedActive then
    pedalsRenderer.drawSpeed(state)
  end

  state.currentWindowWidth = state.currentWindowWidth + 7 * pedalsSettings.store.pedalsScale + state.barSpace

  if pedalsSettings.store.clutchActive then
    pedalsRenderer.drawClutch(state)
  end

  if pedalsSettings.store.brakeActive then
    pedalsRenderer.drawBrake(state)
  end

  if pedalsSettings.store.throttleActive then
    pedalsRenderer.drawAccelerator(state)
  end

  if pedalsSettings.store.handbrakeActive then
    pedalsRenderer.drawHandbrake(state)
  end

  state.currentWindowWidth = state.currentWindowWidth + 7 * pedalsSettings.store.pedalsScale

  if pedalsSettings.store.wheelActive then
    pedalsRenderer.drawWheel(state)
  end

  if pedalsSettings.store.absActive and CAR.absModes ~= 0 then
    pedalsRenderer.drawABS(state)
  end

  if pedalsSettings.store.brakeBiasActive then
    pedalsRenderer.drawBrakeBias(state)
  end

  if pedalsSettings.store.fuelActive then
    pedalsRenderer.drawFuel(state)
  end

  if pedalsSettings.store.tractionControlActive and CAR.tractionControlModes ~= 0 then
    pedalsRenderer.drawTC(state)
  end

  if pedalsSettings.store.drsActvationActive and CAR.drsPresent then
    pedalsRenderer.drawDRSActivation(state)
  end

  if state.currentWindowWidth < (state.contentPositions[1][2].x + state.contentPositions[2][2].x + state.contentPositions[5][2].x) or state.currentWindowWidth < (state.contentPositions[3][2].x + state.contentPositions[4][2].x + state.contentPositions[6][2].x) then
    state.currentWindowWidth = math.max(state.contentPositions[1][2].x + state.contentPositions[2][2].x + state.contentPositions[5][2].x, state.contentPositions[3][2].x + state.contentPositions[4][2].x + state.contentPositions[6][2].x)
  end

  if pedalsSettings.store.p2pActive and CAR.kersPresent then
    pedalsRenderer.drawP2p(state)
  end

  if pedalsSettings.store.rpmActive then
    pedalsRenderer.drawRpm(state)
  end

  if state.contentPositions[1][2] ~= vec2(0, 0) or state.contentPositions[2][2] ~= vec2(0, 0) or state.contentPositions[5][2] ~= vec2(0, 0) then
    state.contentTop = math.max(state.contentPositions[1][2].y, state.contentPositions[2][2].y, state.contentPositions[5][2].y)
  else
    state.contentTop = 0
  end

  if state.contentPositions[3][2] ~= vec2(0, 0) or state.contentPositions[4][2] ~= vec2(0, 0) or state.contentPositions[6][2] ~= vec2(0, 0) then
    state.contentBottom = math.max(state.contentPositions[3][2].y, state.contentPositions[4][2].y, state.contentPositions[6][2].y)
  else
    state.contentBottom = 0
  end

  state.currentWindowSize = vec2(state.currentWindowWidth, state.currentWindowHeight)

  config.resize(state.currentWindowSize, "Pedals")

  pinCheckBox.main(pedalsSettings.store.pedalsScale, "Pedals", config.getWindow("Pedals"):pinned(), state.currentWindowSize)
end

return pedals