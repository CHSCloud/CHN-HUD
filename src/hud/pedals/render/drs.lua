local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pedalsData = require("src.data.pedals.pedalsData")
local drs = {}

---@param data pedalsData
function drs.drawDRSActivation(data)
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

return drs
