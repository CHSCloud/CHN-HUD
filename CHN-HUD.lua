local settings = require("src.settings.settings")
local pitlane = require("src.hud.pitlane.pitlane")
local pedals = require("src.hud.pedals.pedals")
local sessionlaps = require("src.hud.sessionlaps.sessionlaps")

-- TELA DE CONFIGURAÇÕES
function windowSettings()
  settings.windowMain()
end
function windowOpenSettings()
  settings.windowOpenSettings()
end
function windowCloseSettings()
  settings.windowCloseSettings()
end

-- TELA DOS PEDAIS
function windowPedals()
  pedals.windowMain()
end

-- TELA DO PIT LANE
function windowPitLane()
  pitlane.windowMain()
end

-- TELA DE VOLTAS DA SESSÃO
function windowSessionlaps()
  sessionlaps.windowMain()
end
