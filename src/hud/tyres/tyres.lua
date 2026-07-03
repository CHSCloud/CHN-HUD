local tyresData = require("src.data.tyres.tyresData")

local wheels = require("src.hud.tyres.components.wheels")

local tyres = {}

local data = tyresData.new()
tyresData.loadTyresData(data)

function tyres.windowMain()
    data.wheels = CAR.wheels
    ui.drawRectFilled(vec2(0,0), vec2(300,300), WindowsColor, 20)
    
    ui.setCursor(vec2(10,10))
    ui.dwriteTextAligned(tostring(ac.getTyresName(CAR.index)), 15, ui.Alignment.Center, ui.Alignment.Center, vec2(20,20))

    wheels.drawWheelInfo(data, vec2(30, 90), 0)

    wheels.drawWheelInfo(data, vec2(175, 90), 1)

    wheels.drawWheelInfo(data, vec2(30, 200), 2)

    wheels.drawWheelInfo(data, vec2(175, 200), 3)

end

return tyres