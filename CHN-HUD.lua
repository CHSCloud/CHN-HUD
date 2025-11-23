local settings = require("src.settings.settings")
local pitlane = require("src.hud.pitlane.pitlane")
local pedals = require("src.hud.pedals.pedals")
local sessionlaps = require("src.hud.sessionlaps.sessionlaps")

Timer = 0

-- TELA DE CONFIGURAÇÕES
function WindowSettings()
  settings.windowMain()
end
function WindowOpenSettings()
  settings.windowOpenSettings()
end
function WindowCloseSettings()
  settings.windowCloseSettings()
end

-- TELA DOS PEDAIS
function WindowPedals()
  pedals.windowMain()
end

-- TELA DO PIT LANE
function WindowPitLane()
  pitlane.windowMain()
end

-- TELA DE VOLTAS DA SESSÃO
function WindowSessionlaps()
  sessionlaps.windowMain()
end

-- FUNÇÃO DE ATUALIZAÇÃO
function script.update(dt)
  Timer = Timer + dt
  settings.updateSettings()
end