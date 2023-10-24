local utils = {}
game_api = require("lib")




--[[
    Dispel Function
]]
function utils.UnitToDispel(DispelType, DispelType2, DispelType3, DispelType4, DispelType5, DispelType6)
    local lowestHealthUnit = nil
    local lowestHealth = 101

    local dispelTypes = {DispelType, DispelType2, DispelType3, DispelType4, DispelType5, DispelType6}

    local partyUnits = game_api.getPartyUnits()
    for _, playerPartyUnit in ipairs(partyUnits) do
        for _, dispelType in ipairs(dispelTypes) do
            if dispelType then
                local debuffList = game_api.unitDebuffListWithDispelType(playerPartyUnit,dispelType)
                if #debuffList > 0 then
                    local unitHealth = game_api.unitHealthPercent(playerPartyUnit)
                    if unitHealth > 0 and unitHealth < lowestHealth then
                        lowestHealth = unitHealth
                        lowestHealthUnit = playerPartyUnit
                    end
                end
            end
        end
    end
    return lowestHealthUnit
end


--[[
    Units that needs to get echoed
]]
function utils.UnitToEcho()
    local unitToEcho = {}
    local partyUnits = game_api.getPartyUnits()
    for _, playerPartyUnit in ipairs(partyUnits) do
        if game_api.unitHealthPercent(playerPartyUnit) > 0 and game_api.unitHealthPercent(playerPartyUnit) <= game_api.getSetting(settings.EchoPercent) and not game_api.unitHasAura(playerPartyUnit,auras.Echo,true) then
            table.insert(unitToEcho, playerPartyUnit)
            if #unitToEcho >= game_api.getSetting(settings.EchoParty) then
                break
            end
        end
    end
    return unitToEcho
end


--[[
    Calculate Current Empower Rank
]]
function utils.EmpowerRank(percent,nbRank)
    local currentRank = 0
    local rankPart = 100.0 // nbRank
    currentRank = ( ( percent  ) // rankPart )
    if currentRank > nbRank then
        currentRank = nbRank
    end
    return currentRank
end

return utils