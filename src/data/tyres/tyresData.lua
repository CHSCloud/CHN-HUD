---@class tyresData
---@field wheels ac.StateWheel[]
local tyresData = {}

---@return tyresData
function tyresData.new()
    return {
        wheels = CAR.wheels
    } 
end

return tyresData