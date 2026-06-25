local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local gear = {}

local function animateGear(state, maxFontGear)
  if state.fontGear < maxFontGear - 3 then
    if (40 * Timer) % 2 >= 1 then
      state.fontGear = state.fontGear + 10 * pedalsSettings.store.pedalsScale
    end
  else
    state.fontGear = maxFontGear
  end
end

function gear.draw(state)
  state.contentMidle = 73 * pedalsSettings.store.pedalsScale
  state.gearBackgroundWidth = 60 * pedalsSettings.store.pedalsScale
  state.currentWindowWidth = state.gearBackgroundWidth
  if state.currentGear ~= CAR.gear then
    state.fontGear = 0
    state.currentGear = CAR.gear
  end
  local gear = tostring(CAR.gear)
  if gear == "0" then
    gear = "N"
  elseif gear == "-1" then
    gear = "R"
  end

  if pedalsSettings.store.speedActive then
    animateGear(state, 40 * pedalsSettings.store.pedalsScale)
    ui.setCursor(vec2(20, 11):scale(pedalsSettings.store.pedalsScale) + vec2(0, state.contentTop))
    ui.dwriteTextAligned(gear, state.fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 30):scale(pedalsSettings.store.pedalsScale), false, COLOR.YELLOW_DARK)
  else
    animateGear(state, 45 * pedalsSettings.store.pedalsScale)
    ui.setCursor(vec2(20, 15):scale(pedalsSettings.store.pedalsScale) + vec2(0, state.contentTop))
    ui.dwriteTextAligned(gear, state.fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 40):scale(pedalsSettings.store.pedalsScale), false, COLOR.YELLOW_DARK)
  end
end
return gear