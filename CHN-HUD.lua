TIMER = 0
SIM = ac.getSim()
CAR = ac.getCar(SIM.focusedCar)
USER_UI = ac.getUI()

local settings = require("src.settings.settings")
local pitLane = require("src.hud.pitLane.pitLane")
local pedals = require("src.hud.pedals.pedals")
local sessionLaps = require("src.hud.sessionLaps.sessionLaps")
local sessionFlags = require("src.hud.sessionFlags.sessionFlags")
local startingLights = require("src.hud.startingLights.startingLights")
local map = require("src.hud.map.map")
local deltaBar = require("src.hud.deltaBar.deltaBar")
local leaderboard = require("src.hud.leaderboard.leaderboard")
local tyres = require("src.hud.tyres.tyres")

-- TELA DE CONFIGURAÇÕES
function WindowSettings()
	pcall(settings.windowMain)
end

function WindowOpenSettings()
	pcall(settings.windowOpenSettings)
end

function WindowCloseSettings()
	pcall(settings.windowCloseSettings)
end

-- TELA DOS PEDAIS
function WindowPedals()
	pcall(pedals.windowMain)
end

-- TELA DO PIT LANE
function WindowPitLane()
	pcall(pitLane.windowMain)
end

-- TELA DE BANDEIRAS
function WindowSessionflags()
	pcall(sessionFlags.windowMain)
end

-- TELA DE LUZES DE LARGADA
function WindowStartingLights()
	pcall(startingLights.windowMain)
end

-- TELA DE VOLTAS DA SESSÃO
function WindowSessionlaps()
	pcall(sessionLaps.windowMain)
end

-- TELA DO MAPA
function WindowMap()
	pcall(map.windowMain)
end

-- TELA DO DELTA BAR
function WindowdeltaBar()
	pcall(deltaBar.windowMain)
end

-- TELA DO LEADERBOARD
function WindowLeaderboard()
	pcall(leaderboard.windowMain)
end

function WindowTyres()
	pcall(tyres.windowMain)
end

-- FUNÇÃO DE ATUALIZAÇÃO
function script.update(dt)
	TIMER = TIMER + dt
	SIM = ac.getSim()
	CAR = ac.getCar(SIM.focusedCar)
	USER_UI = ac.getUI()
end
