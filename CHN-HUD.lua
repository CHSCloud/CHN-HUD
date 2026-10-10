TIMER = 0
SIM = ac.getSim()
CAR = ac.getCar(SIM.focusedCar)
USER_UI = ac.getUI()
local isAppsInit = false

local window = require("common.window")
local language = require("language.language")
local settings = require("src.settings.settings")
local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pitLane = require("src.hud.pitLane.pitLane")
local pedals = require("src.hud.pedals.pedals")
local sessionLaps = require("src.hud.sessionLaps.sessionLaps")
local sessionFlags = require("src.hud.sessionFlags.sessionFlags")
local startingLights = require("src.hud.startingLights.startingLights")
local map = require("src.hud.map.map")
local deltaBar = require("src.hud.deltaBar.deltaBar")
local leaderboard = require("src.hud.leaderboard.leaderboard")
local tyres = require("src.hud.tyres.tyres")

---@Credits This function was inspired by the "call_protected_function" function from CMRT Complete HUD.
---@param func function
local function callProtectedFunction(func)
	xpcall(func, function (Error)
		ac.debug("Error in function: " .. Error, debug.traceback())
	end)
end

-- INICIALIZA TODOS OS APPS
local function initApps()
	window.init()
	language.loadTranslations()
	settings.init()
	pedalsSettings.init()
	pitLane.init()
	pedals.init()
	sessionLaps.init()
	sessionFlags.init()
	startingLights.init()
	map.init()
	deltaBar.init()
	leaderboard.init()
	tyres.init()
end

-- FUNÇÃO DE ATUALIZAÇÃO
---@param dt number
function script.update(dt)
	TIMER = TIMER + dt
	SIM = ac.getSim()
	CAR = ac.getCar(SIM.focusedCar)
	USER_UI = ac.getUI()

	if not isAppsInit then
		callProtectedFunction(initApps)
		isAppsInit = true
	end
end

-- FUNÇÃO CHAMADA PARA RESTART DAS SESSÕES
ac.onSessionStart(function (sessionIndex, restarted)
	callProtectedFunction(sessionLaps.onSessionStart)
	callProtectedFunction(deltaBar.onSessionStart)
	callProtectedFunction(pedals.onSessionStart)
end)

-- TELA DE CONFIGURAÇÕES
function WindowSettings()
	callProtectedFunction(settings.windowMain)
end
function WindowOpenSettings()
	callProtectedFunction(settings.windowOpenSettings)
end
function WindowCloseSettings()
	callProtectedFunction(settings.windowCloseSettings)
end
--

-- TELA DOS PEDAIS
function WindowPedals()
	callProtectedFunction(pedals.windowMain)
end

-- TELA DO PIT LANE
function WindowPitLane()
	callProtectedFunction(pitLane.windowMain)
end

-- TELA DE BANDEIRAS
function WindowSessionflags()
	callProtectedFunction(sessionFlags.windowMain)
end

-- TELA DE LUZES DE LARGADA
function WindowStartingLights()
	callProtectedFunction(startingLights.windowMain)
end

-- TELA DE VOLTAS DA SESSÃO
function WindowSessionlaps()
	callProtectedFunction(sessionLaps.windowMain)
end

-- TELA DO MAPA
function WindowMap()
	callProtectedFunction(map.windowMain)
end

-- TELA DO DELTA BAR
function WindowdeltaBar()
	callProtectedFunction(deltaBar.windowMain)
end

-- TELA DO LEADERBOARD
function WindowLeaderboard()
	callProtectedFunction(leaderboard.windowMain)
end

function WindowTyres()
	callProtectedFunction(tyres.windowMain)
end