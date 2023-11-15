game_api = require("lib")
spells = require ("spells")
talents = require ("talents")
auras = require ("auras")
settings = require ("settings")
utils = require ("utils")

state = {}

--[[
    Create your variable and toggle here
]]
function OnInit()
    settings.createSettings()
    print("0x33 Preservation Evoker Rotation Loaded !")
end


function StateUpdate()

    state.currentMana = game_api.getPower(0)
    state.currentEssence = game_api.getPower(2)
    state.maxEssence = game_api.getMaxPower(2)

    state.currentTarget = game_api.getCurrentUnitTarget()
    state.currentPlayer = game_api.getCurrentPlayer()
    state.FontOfMagic = game_api.hasTalent(talents.FontOfMagic)

    state.currentHpPercent = game_api.unitHealthPercent(state.currentPlayer)


    state.afflictedUnits = game_api.getUnitsByNpcId(204773)
    state.incorporealUnits = game_api.getUnitsByNpcId(204560)

    state.party = game_api.getPartyUnits()


    if not state.FontOfMagic then
        state.chargedSpellsMaxRank = 3
    else 
        state.chargedSpellsMaxRank = 4
    end

    if game_api.hasTalent(talents.Punctuality) then
        state.reversionMaxCharge = 2
    else 
        state.reversionMaxCharge = 1
    end
    
end


function Affix()
    if game_api.getToggle(settings.Dispel) then
        state.afflictedUnits = game_api.getUnitsByNpcId(204773)

        if (#state.afflictedUnits > 0) and (game_api.canCast(spells.Naturalize) or game_api.canCast(spells.CauterizingFlame)) then
            for _, unit in ipairs(state.afflictedUnits) do
                if (game_api.distanceToUnit(unit) < 30.0) and (game_api.unitIsCasting(unit) or game_api.unitIsChanneling(unit)) then

                    if game_api.canCast(spells.Naturalize) then
                        game_api.castSpellOnTarget(spells.Naturalize,unit)
                        return true
                    end

                    if game_api.canCast(spells.CauterizingFlame) then
                        game_api.castSpellOnTarget(spells.CauterizingFlame,unit)
                        return true

                    end
                end
            end
        end
    
    end
    return false
end

function Dps()


    if state.currentTarget == "00" or not game_api.isTargetHostile(true) or not game_api.unitInCombat(state.currentTarget) then
        return false
    end

    if ( game_api.canCast(spells.FireBreath) and not game_api.isOnCooldown(spells.FireBreathFOM) ) and state.currentMana >= 6500 and game_api.currentPlayerDistanceFromTarget() <= 25.0  then
        game_api.castSpell(spells.FireBreath)
        return true
    end
    if game_api.currentPlayerHasAura(auras.EssenceBurst,true) and game_api.canCast(spells.Disintegrate) and game_api.currentPlayerDistanceFromTarget() <= 25.0 then
        game_api.castSpellOnTarget(spells.Disintegrate,state.currentTarget)
        return true
    end

    if game_api.canCast(spells.LivingFlame) and game_api.currentPlayerDistanceFromTarget() <= 25.0 then
        game_api.castSpellOnTarget(spells.LivingFlame,state.currentTarget)
        return true
    end

    return false
end

function Defensive()

    if game_api.hasTalent(talents.RenewingBlaze) and game_api.canCast(spells.RenewingBlaze) and state.currentHpPercent < game_api.getSetting(settings.RenewingBlazePercent) then
        game_api.castSpell(spells.RenewingBlaze)
        return true
    end

    if game_api.hasTalent(talents.ObsidianScales) and game_api.canCast(spells.ObsidianScales) and state.currentHpPercent < game_api.getSetting(settings.ObsidianScalePercent) then
        game_api.castSpell(spells.ObsidianScales)
        return true
    end


    return false
end

function Healing()

    if game_api.getToggle(settings.Dispel) then

        local unitToDispelNaturalize = utils.UnitToDispel("MAGIC","POISON","ALL")
        local unitToDispelCauterizingFlame = utils.UnitToDispel("CURSE","POISON","DISEASE","ALL")

        if (unitToDispelNaturalize) and (game_api.canCast(spells.Naturalize)) then
            game_api.castSpellOnTarget(spells.Naturalize,unitToDispelNaturalize)
            return true
        end
    
        if (unitToDispelCauterizingFlame) and (game_api.canCast(spells.CauterizingFlame)) then
            game_api.castSpellOnTarget(spells.CauterizingFlame,unitToDispelCauterizingFlame)
            return true
        end
    end



    if (game_api.currentPlayerHasAura(auras.CallOfYsera,true)) and ( game_api.canCast(spells.DreamBreath) and not game_api.isOnCooldown(spells.DreamBreathFOM) ) then
        game_api.castSpell(spells.DreamBreath)
        return true
    end

    if ( game_api.canCast(spells.DreamBreath) and not game_api.isOnCooldown(spells.DreamBreathFOM) ) or ( game_api.canCast(spells.SpriritBloom) and not game_api.isOnCooldown(spells.SpriritBloomFOM) ) or game_api.canCastCharge(spells.Reversion,state.reversionMaxCharge) then
        local party = game_api.getPartyUnits()
        local count = 0
        local lowestRemainingTime = 999999
        local lowestHp = 100
        for i = 1, #party do
            if game_api.unitHasAura(party[i],auras.Echo,true) then
                count = count + 1
                local remain = game_api.unitAuraRemainingTime(party[i],auras.Echo,true)
                if remain < lowestRemainingTime then
                    lowestRemainingTime = remain
                end
                local hp = game_api.unitHealthPercent(party[i])
                if hp < lowestHp then
                    lowestHp = hp
                end
            end
        end

        if ( game_api.canCast(spells.DreamBreath) and not game_api.isOnCooldown(spells.DreamBreathFOM) ) and count >= game_api.getSetting(settings.DreamBreathParty) and lowestHp <= game_api.getSetting(settings.DreamBreathPercent) then
            game_api.castSpell(spells.DreamBreath)
            return true
        end

        if ( game_api.canCast(spells.SpriritBloom) and not game_api.isOnCooldown(spells.SpriritBloomFOM) ) and count >= game_api.getSetting(settings.BloomParty) and lowestHp <= game_api.getSetting(settings.BloomPercent) then
            game_api.castSpell(spells.SpriritBloom)
            return true
        end

        if game_api.canCastCharge(spells.Reversion,state.reversionMaxCharge) and ( lowestRemainingTime <= 1000 ) then
            game_api.castSpellOnTarget(spells.Reversion,state.currentPlayer)
            return true
        end
    end


    --Echo Logic
    if game_api.canCast(spells.Echo) then
        local unitToEcho = utils.UnitToEcho();
        if #unitToEcho > 0 then
            game_api.castSpellOnTarget(spells.Echo,unitToEcho[1])
        end
    end


    -- si Tank < TimeDilationPercent => TimeDilationPercent => TimeDilation
    if game_api.canCast(spells.TimeDilation) then
        local tanksUnderTimeDilationPercent = game_api.getPartyUnitWithRoleBelowHealthPercent(game_api.getSetting(settings.TimeDilationPercent),30.0,"TANK")
        if #tanksUnderTimeDilationPercent > 0 then
            game_api.castSpellOnTarget(spells.TimeDilation,tanksUnderTimeDilationPercent[1])
            return true
        end   
    end


    -- consume leaping flames
    if game_api.currentPlayerHasAura(auras.LeapingFlames,true) and game_api.canCast(spells.LivingFlame) then
        local partyUnderLivingPercent = game_api.getPartyUnitBelowHealthPercent(game_api.getSetting(settings.LivingFlamePercent) + 10.0 ,30.0)
        if #partyUnderLivingPercent > 0  then
            game_api.castSpellOnTarget(spells.LivingFlame,partyUnderLivingPercent[1])
            return true
        end
    end



    -- si BloomParty < BloomPercent => SpriritBloom
    if ( game_api.canCast(spells.SpriritBloom) and not game_api.isOnCooldown(spells.SpriritBloomFOM) ) then
        local partyUnderBloomPercent = game_api.getPartyUnitBelowHealthPercent(game_api.getSetting(settings.BloomPercent),30.0)
        if #partyUnderBloomPercent >= game_api.getSetting(settings.BloomParty) then
            game_api.castSpellOnTarget(spells.SpriritBloom,partyUnderBloomPercent[1])
            return true
        end 
    end


    -- si TemportalAnomalyParty < TemportalAnomalyPercent => TemporalAnomaly 
    if game_api.canCast(spells.TemporalAnomaly) then
        local partyUnderTemporalPercent = game_api.getPartyUnitBelowHealthPercent(game_api.getSetting(settings.TemportalAnomalyPercent),30.0)
        if #partyUnderTemporalPercent > game_api.getSetting(settings.TemportalAnomalyParty) then
            game_api.castSpell(spells.TemporalAnomaly)
            return true
        end   
    end


    if game_api.canCastCharge(spells.Reversion,state.reversionMaxCharge) then
        local partyUnderReversionPercent = game_api.getPartyUnitBelowHealthPercent(game_api.getSetting(settings.ReversionPercent),30.0)
        if #partyUnderReversionPercent > 0 then
            for i = 1, #partyUnderReversionPercent do
                if not game_api.unitHasAura(partyUnderReversionPercent[i],auras.Reversion,true) then
                    game_api.castSpellOnTarget(spells.Reversion,partyUnderReversionPercent[i])
                    return true
                end
            end
        end
    end


    -- Si Tank < ReversionPercent => Reversion on tank


    -- FB + LivingFlame

    -- (VerdantEmbrace if CallOfYsera)

    if ( game_api.canCast(spells.DreamBreath) and not game_api.isOnCooldown(spells.DreamBreathFOM) ) then
        local partyUnderDreamBreathPercent = game_api.getPartyUnitBelowHealthPercent(game_api.getSetting(settings.DreamBreathPercent),30.0)
        if #partyUnderDreamBreathPercent >= game_api.getSetting(settings.DreamBreathParty) then
            if((game_api.hasTalent(talents.CallOfYsera) and game_api.canCast(spells.VerdantEmbrace))) then
                game_api.castSpellOnTarget(spells.VerdantEmbrace,game_api.getCurrentPlayer())
                return true
            else
                game_api.castSpell(spells.DreamBreath)
                return true
            end    
        end
    end


    if game_api.canCast(spells.TipTheScales) and not game_api.currentPlayerHasAura(auras.TipTheScales,true) then
        local partyUnderTipTheScalePercent = game_api.getPartyUnitBelowHealthPercent(game_api.getSetting(settings.TipTheScalePercent),99.0)
        if #partyUnderTipTheScalePercent >= game_api.getSetting(settings.TipTheScaleParty) then
            game_api.castSpell(spells.TipTheScales)
            return true
        end
    end

    -- SpriritBloom rank 3
    -- Echo is EchoSpread
    
    -- VerdantEmbrace to single
    -- Reversion on tank


    -- Reversion on tank


    -- EmeraldBlossom


    -- Rewind
    if game_api.canCast(spells.Rewind) then
        local partyUnderRewindPercent = game_api.getPartyUnitBelowHealthPercent(game_api.getSetting(settings.RewindPercent),40.0)
        if #partyUnderRewindPercent > game_api.getSetting(settings.RewindParty) then
            game_api.castSpell(spells.Rewind)
            return true
        end
    end

    -- VerdantEmbrace single 
    if game_api.getToggle(settings.VerdantEmbrace) then
        if game_api.canCast(spells.VerdantEmbrace) then
            local partyUnderVEPercent = game_api.getPartyUnitBelowHealthPercent(game_api.getSetting(settings.VerdantEmbracePercent),game_api.getSetting(settings.VerdantEmbraceRange))
            if #partyUnderVEPercent > 0  then
                game_api.castSpellOnTarget(spells.VerdantEmbrace,partyUnderVEPercent[1])
                return true
            end
        end
    end



    -- LivingFlame Emergency
    if game_api.canCast(spells.LivingFlame) then
        local partyUnderLivingPercent = game_api.getPartyUnitBelowHealthPercent(game_api.getSetting(settings.LivingFlamePercent),30.0)
        if #partyUnderLivingPercent > 0  then
            game_api.castSpellOnTarget(spells.LivingFlame,partyUnderLivingPercent[1])
            return true
        end
    end

    -- No healing needed
    return false
end

--[[
    Run on eatch engine tick if game has focus and is not loading
]]
function OnUpdate()
    
    
    --Preservation Evoker
    if not game_api.isSpec(356810) then
        return true
    end
    if game_api.getToggle(settings.Pause) then
        return true
    end
    

    StateUpdate()
    
    --charged spell
    if game_api.currentPlayerIsChanneling() then
        if ( game_api.getCurrentPlayerChannelID() == spells.FireBreath or game_api.getCurrentPlayerChannelID() == spells.FireBreathFOM ) and utils.EmpowerRank(game_api.getCurrentPlayerChannelPercentage(),state.chargedSpellsMaxRank) > 0 then
            game_api.castSpell(spells.FireBreath);
            return true
        end

        if (game_api.getCurrentPlayerChannelID() == spells.SpriritBloom or game_api.getCurrentPlayerChannelID() == spells.SpriritBloomFOM) and ( utils.EmpowerRank(game_api.getCurrentPlayerChannelPercentage(),state.chargedSpellsMaxRank) > (state.chargedSpellsMaxRank - 1) ) then
            game_api.castSpell(spells.SpriritBloom);
            return true
        end

        if (game_api.getCurrentPlayerChannelID() == spells.DreamBreath or game_api.getCurrentPlayerChannelID() == spells.DreamBreathFOM) and utils.EmpowerRank(game_api.getCurrentPlayerChannelPercentage(),state.chargedSpellsMaxRank) > 1 then
            game_api.castSpell(spells.DreamBreath);
            return true
        end
    end
    
    if game_api.currentPlayerIsCasting() or game_api.currentPlayerIsMounted() or game_api.currentPlayerIsChanneling() or game_api.isAOECursor() then
        return
    end

    -- BlessingOfTheBronze auto buff
    if game_api.canCast(spells.BlessingOfTheBronze) and not game_api.currentPlayerHasAura(auras.BlessingOfTheBronze,false) then
        game_api.castSpell(spells.BlessingOfTheBronze)
        return true
    end

    if Affix() then
        return true
    end

    if Defensive() then
        return true
    end

    if Healing() then
        return true
    end

    if Dps() then
        return true
    end
   

end