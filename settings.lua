local settings = {}
game_api = require("lib")

--Toogles
settings.DreamFlight = "DreamFlight"
settings.VerdantEmbrace = "VerdantEmbrace"
settings.Cooldown = "Cooldown"
settings.Dispel = "Dispel"
settings.Pause = "Pause"


--Settings
settings.DispelDelay = "DispelDelay"

settings.EchoParty = "EchoParty"
settings.BlossomParty = "BlossomParty"
settings.BloomParty = "BloomParty"
settings.DreamBreathParty = "DreamBreathParty"
settings.RewindParty = "RewindParty"
settings.DreamFlightParty = "DreamFlightParty"
settings.TipTheScaleParty = "TipTheScaleParty"
settings.TemportalAnomalyParty = "TemporalAnomalyParty"

settings.EchoPercent = "EchoPercent"
settings.BlossomPercent = "BlossomPercent"
settings.BloomPercent = "BloomPercent"
settings.DreamBreathPercent = "DreamBreathPercent"
settings.RewindPercent = "RewindPercent"
settings.DreamFlightPercent = "DreamFlightPercent"
settings.TipTheScalePercent = "TipTheScalePercent"
settings.TemportalAnomalyPercent = "TemportalAnomalyPercent"

settings.VerdantEmbracePercent = "VerdantEmbracePercent"
settings.VerdantEmbraceRange = "VerdantEmbraceRange"

settings.LivingFlamePercent = "LivingFlamePercent"
settings.TimeDilationPercent = "TimeDilationPercent"
settings.ReversionPercent = "ReversionPercent"
settings.ObsidianScalePercent = "ObsidianScalePercent"
settings.RenewingBlazePercent = "RenewingBlazePercent"

function settings.createSettings()

    game_api.createSetting(settings.DispelDelay,settings.DispelDelay,1500,{0,3000})


    game_api.createSetting(settings.EchoParty,settings.EchoParty,2,{0,50})
    game_api.createSetting(settings.EchoPercent,settings.EchoPercent,85,{0,100})

    game_api.createSetting(settings.BlossomParty,settings.BlossomParty,3,{0,50})
    game_api.createSetting(settings.BlossomPercent,settings.BlossomPercent,80,{0,100})

    game_api.createSetting(settings.BloomParty,settings.BloomParty,4,{0,50})
    game_api.createSetting(settings.BloomPercent,settings.BloomPercent,85,{0,100})

    game_api.createSetting(settings.DreamBreathParty,settings.DreamBreathParty,4,{0,50})
    game_api.createSetting(settings.DreamBreathPercent,settings.DreamBreathPercent,90,{0,100})

    game_api.createSetting(settings.RewindParty,settings.RewindParty,9,{0,50})
    game_api.createSetting(settings.RewindPercent,settings.RewindPercent,30,{0,100})

    game_api.createSetting(settings.DreamFlightParty,settings.DreamFlightParty,6,{0,50})
    game_api.createSetting(settings.DreamFlightPercent,settings.DreamFlightPercent,45,{0,100})

    game_api.createSetting(settings.TipTheScaleParty,settings.TipTheScaleParty,4,{0,50})
    game_api.createSetting(settings.TipTheScalePercent,settings.TipTheScalePercent,70,{0,100})

    game_api.createSetting(settings.TemportalAnomalyParty,settings.TemportalAnomalyParty,4,{0,50})
    game_api.createSetting(settings.TemportalAnomalyPercent,settings.TemportalAnomalyPercent,80,{0,100})

    game_api.createSetting(settings.VerdantEmbracePercent,settings.VerdantEmbracePercent,85,{0,100})
    game_api.createSetting(settings.VerdantEmbraceRange,settings.VerdantEmbraceRange,5,{0,25})



    game_api.createSetting(settings.LivingFlamePercent,settings.LivingFlamePercent,90,{0,100})
    game_api.createSetting(settings.TimeDilationPercent,settings.TimeDilationPercent,75,{0,100})
    game_api.createSetting(settings.ReversionPercent,settings.ReversionPercent,30,{0,100})
    game_api.createSetting(settings.ObsidianScalePercent,settings.ObsidianScalePercent,70,{0,100})
    game_api.createSetting(settings.RenewingBlazePercent,settings.RenewingBlazePercent,40,{0,100})

    

    game_api.createToggle(settings.DreamFlight, settings.DreamFlight,false,0);
    game_api.createToggle(settings.VerdantEmbrace, settings.VerdantEmbrace,true,0);
    game_api.createToggle(settings.Cooldown, settings.Cooldown,true,0);
    game_api.createToggle(settings.Dispel, settings.Dispel,true,0);
    game_api.createToggle(settings.Pause, settings.Pause,false,0);

    
end

return settings