local PSBT              = PSBT
local ModuleProto       = PSBT.ModuleProto
local PSBT_Ultimate     = ModuleProto:Subclass()
local CBM               = CALLBACK_MANAGER
local kVerison          = 1.0

local PSBT_MODULES      = PSBT_MODULES
local PSBT_AREAS        = PSBT_AREAS
local PSBT_EVENTS       = PSBT_EVENTS
local PSBT_STRINGS      = PSBT_STRINGS
local zo_strformat      = zo_strformat

local kVersion          = 1.0

local POWERTYPE_ULTIMATE                = POWERTYPE_ULTIMATE
local ACTION_BAR_ULTIMATE_SLOT_INDEX    = ACTION_BAR_ULTIMATE_SLOT_INDEX

function PSBT_Ultimate:Initialize( ... )
    ModuleProto.Initialize( self, ... )

    self._ready   = false
    self._current = 0
    self._needed  = 0
    self._texture = nil

    self:RegisterForEvent( EVENT_POWER_UPDATE,                  function( ... ) self:OnPowerUpdate( ... ) end )
    self:RegisterForEvent( EVENT_ACTION_SLOTS_FULL_UPDATE,      function( ... ) self:UpdateUltimateMin() end )
    self:RegisterForEvent( EVENT_ACTION_SLOT_ABILITY_SLOTTED,   function( ... ) self:UpdateUltimateMin() end )

    self._ultimateReady = GetString( _G[ PSBT_STRINGS.ULTIMATE_READY ] )
    self._ultimateGain  = GetString( _G[ PSBT_STRINGS.ULTIMATE_GAIN ] )

    self:UpdateUltimateMin()
end

function PSBT_Ultimate:OnPowerUpdate( unit, powerPoolIndex, powerType, powerPool, powerPoolMax )
    if ( unit ~= 'player' ) then
        return
    end

    if ( not self._texture ) then
        return
    end

    if ( powerType ~= POWERTYPE_ULTIMATE ) then
        return 
    end

    if ( powerPool > self._current ) then
        if ( powerPool >= self._needed and not self._ready ) then
            self._ready = true
            PlaySound( 'Quest_Complete' )
            self:NewEvent( PSBT_AREAS.NOTIFICATION, true, self._texture, self._ultimateReady )
        elseif ( powerPool - self._current >= 5 ) then
            self:NewEvent( PSBT_AREAS.INCOMING, false, self._texture, zo_strformat( self._ultimateGain, powerPool ) )
        end
    else
        self._ready = powerPool >= self._needed
    end

    self._current = powerPool 
end

function PSBT_Ultimate:UpdateUltimateMin()
    self._needed = GetSlotAbilityCost( ACTION_BAR_ULTIMATE_SLOT_INDEX + 1 )
    self._texture = GetSlotTexture( ACTION_BAR_ULTIMATE_SLOT_INDEX + 1 )
end

CBM:RegisterCallback( PSBT_EVENTS.LOADED, 
    function( psbt )
        psbt:RegisterModule( PSBT_MODULES.ULTIMATE, PSBT_Ultimate:New( psbt ), kVerison )
    end )