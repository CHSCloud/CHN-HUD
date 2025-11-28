local settings = require("src.settings.settings")
local pitLane = require("src.hud.pitLane.pitLane")
local pedals = require("src.hud.pedals.pedals")
local sessionLaps = require("src.hud.sessionLaps.sessionLaps")
local sessionFlags = require("src.hud.sessionFlags.sessionFlags")
local startingLights = require("src.hud.startingLights.startingLights")

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
  pitLane.windowMain()
end

-- TELA DE BANDEIRAS
function WindowSessionflags()
  sessionFlags.windowMain()
end

-- TELA DE LUZES DE LARGADA
function WindowStartingLights()
  startingLights.windowMain()
end

-- TELA DE VOLTAS DA SESSÃO
function WindowSessionlaps()
  sessionLaps.windowMain()
end

-- FUNÇÃO DE ATUALIZAÇÃO
function script.update(dt)
  Timer = Timer + dt
  settings.updateSettings()
end