local settings = require("src.settings.settings")
local pitlane = require("src.hud.pitlane.pitlane")
local pedals = require("src.hud.pedals.pedals")
local sessionlaps = require("src.hud.sessionlaps.sessionlaps")

function windowSettings()
  settings.windowMain()
end

function windowPedals()
  pedals.windowMain()
end

function windowPitLane()
  pitlane.windowMain()
end

function windowSessionlaps()
  sessionlaps.windowMain()
end