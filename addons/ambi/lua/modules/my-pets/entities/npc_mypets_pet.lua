local C, Ents = Ambi.General.Global.Colors, Ambi.RegEntity

local ENT = {}

ENT.Class       = 'mypets_pet'
ENT.Base	    = 'base_ai'
ENT.Type	    = 'ai'

ENT.PrintName	= 'NPC Pet'
ENT.Author		= 'Ambi'
ENT.Category	= 'MyPets'
ENT.Spawnable   = false

ENT.Stats = {
    type = 'NPC',
    model = 'models/Barney.mdl',
    module = 'MyPet',
    date = '26.01.2022 15:07'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        Ents.Draw( self, false )

        --if ( LocalPlayer():GetPos():Distance( self:GetPos() ) > 1800 ) then return end
        --draw.SimpleTextOutlined( self.nw_NamePet, '24 Ambi', 4, 0, C.ABS_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Hull( self )
    Ents.Physics( self, MOVETYPE_NONE, SOLID_BBOX, COLLISION_GROUP_PLAYER, false, false, true )
    Ents.Capability( self, CAP_ANIMATEDFACE )
    Ents.Capability( self, CAP_TURN_HEAD )
end