local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pedalsData = require("src.data.pedals.pedalsData")
local tc = {}

---@param data pedalsData
function tc.drawTC(data)
  local size = vec2(30, 20):scale(pedalsSettings.store.pedalsScale)
  pedalsData.setPositionContentBorder(data, pedalsSettings.store.tractionControlPos, size)
  ui.setCursor(data.contentPositions[pedalsSettings.store.tractionControlPos][1])
  if CAR.tractionControlInAction then
    ui.image("assets/pedals/TC.png", size, COLOR.RED, ui.ImageFit.Fit)
  else
    ui.image("assets/pedals/TC.png", size, COLOR.WHITE, ui.ImageFit.Fit)
  end
end

return tc
