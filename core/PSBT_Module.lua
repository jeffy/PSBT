local PSBT          = PSBT
local ZO_Object     = ZO_Object
local ModuleProto   = ZO_Object:Subclass()
local CBM           = CALLBACK_MANAGER

function ModuleProto:New( ... )
    local result = ZO_Object.New( self )
    result:Initialize( ... )
    return result
end

function ModuleProto:Initialize( root )
    self._root = root
end

function ModuleProto:RegisterForEvent( event, callback )
    self._root:RegisterForEvent( event, callback )
end

function ModuleProto:UnregisterForEvent( event, callback )
    self._root:UnregisterForEvent( event, callback )
end

function ModuleProto:OnUpdate( frametime )
    -- stub, implement if needed
end

function ModuleProto:NewEvent( scrollArea, sticky, icon, text, color )
    self._root:NewEvent( scrollArea, sticky, icon, text, color )
end

PSBT.ModuleProto = ModuleProto