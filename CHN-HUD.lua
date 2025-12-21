Timer = 0
SIM = ac.getSim()
CAR = ac.getCar(SIM.focusedCar)
UserUI = ac.getUI()
  
local settings = require("src.settings.settings")
local pitLane = require("src.hud.pitLane.pitLane")
local pedals = require("src.hud.pedals.pedals")
local sessionLaps = require("src.hud.sessionLaps.sessionLaps")
local sessionFlags = require("src.hud.sessionFlags.sessionFlags")
local startingLights = require("src.hud.startingLights.startingLights")
local map = require("src.hud.map.map")
local deltaBar = require("src.hud.deltaBar.deltaBar")

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

-- TELA DO MAPA
function WindowMap()
  map.windowMain()
end

-- DELTA BAR
function WindowdeltaBar()
  deltaBar.windowMain()
end

-- FUNÇÃO DE ATUALIZAÇÃO
function script.update(dt)
  Timer = Timer + dt
  SIM = ac.getSim()
  CAR = ac.getCar(SIM.focusedCar)
  UserUI = ac.getUI()
end