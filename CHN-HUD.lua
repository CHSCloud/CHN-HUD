local settings = require("settings.settings")
local pitlane = require("pitlane.pitlane")
local pedals = require("pedals.pedals")
local sessionlaps = require("sessionlaps.sessionlaps")

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
