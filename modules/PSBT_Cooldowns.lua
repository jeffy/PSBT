local PSBT_Module           = PSBT_Module
local PSBT_Cooldowns        = PSBT_Module:Subclass()
local CBM                   = CALLBACK_MANAGER

local PSBT_EVENTS           = PSBT_EVENTS
local PSBT_MODULES          = PSBT_MODULES

local kVerison              = 1.0

function PSBT_Cooldowns:Initialize( ... )
    PSBT_Module.Initialize( self, ... )

    self:RegisterForEvent( EVENT_ABILITY_COOLDOWN_UPDATED, function( abilityId ) self:OnAbilityCooldownUpdated( abilityId ) end )
    self:RegisterForEvent( EVENT_ACTION_UPDATE_COOLDOWNS, function() self:OnActionCooldownUpdate() end )
end

function PSBT_Cooldowns:OnAbilityCooldownUpdated( abilityId )
end

function PSBT_Cooldowns:OnActionCooldownUpdate()
end

CBM:RegisterCallback( PSBT_EVENTS.LOADED, 
    function( psbt )
        psbt:RegisterModule( PSBT_MODULES.COOLDOWNS, PSBT_Cooldowns:New( psbt ), kVerison )
    end )