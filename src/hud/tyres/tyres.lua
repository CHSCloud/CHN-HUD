local tyresData = require("src.data.tyres.tyresData")

local wheels = require("src.hud.tyres.components.wheels")

local tyres = {}

local data = tyresData.new()

function tyres.windowMain()
    data.wheels = CAR.wheels

    ui.drawRectFilled(vec2(0,0), vec2(300,300), WindowsColor, 20)
    
    ui.setCursor(vec2(10,10))
    ui.dwriteTextAligned(tostring(ac.getTyresName(CAR.index)), 15, ui.Alignment.Center, ui.Alignment.Center, vec2(20,20))

    wheels.drawWheel(data, vec2(30,50), 0)

    wheels.drawWheel(data, vec2(184,50), 1)

    wheels.drawWheel(data, vec2(30,200), 2)

    wheels.drawWheel(data, vec2(184,200), 3)

end

return tyres