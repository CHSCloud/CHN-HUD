local settings = require("settings.settings")
local pitlane = require("pitlane.pitlane")
local pedals = require("pedals.pedals")

function windowSettings()
  settings.windowMain()
end

function windowPedals()
  pedals.windowMain()
end

function windowPitLane()
  pitlane.windowMain()
end

