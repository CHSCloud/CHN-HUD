local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local abs = {}

---@param data pedalsData
function abs.drawABS(data)
  data.contentMidle = 73 * pedalsSettings.store.pedalsScale
  local absBackgroundSize = vec2(76 * pedalsSettings.store.pedalsScale, data.currentWindowHeight)

  ui.setCursor(vec2(data.currentWindowWidth - 9 * pedalsSettings.store.pedalsScale, -4 * pedalsSettings.store.pedalsScale + data.contentTop))
  if CAR.absInAction then
    ui.image("assets/pedals/ABS.png", vec2(80, 80):scale(pedalsSettings.store.pedalsScale), COLOR.RED, ui.ImageFit.Fit)
  else
    ui.image("assets/pedals/ABS.png", vec2(80, 80):scale(pedalsSettings.store.pedalsScale), COLOR.GRAY_BG, ui.ImageFit.Fit)
  end

  data.currentWindowWidth = data.currentWindowWidth + absBackgroundSize.x
end

return abs
