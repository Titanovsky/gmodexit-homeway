local C, Ents = Ambi.General.Global.Colors, Ambi.RegEntity

local ENT = {}

ENT.Class       = 'quest_giver'
ENT.Base	    = 'base_ai'
ENT.Type	    = 'ai'

ENT.PrintName	= 'NPC Quest Giver'
ENT.Author		= 'Ambi'
ENT.Category	= 'Quest'
ENT.Spawnable   = true

ENT.Stats = {
    type = 'NPC',
    model = 'models/Barney.mdl',
    module = 'Quest',
    date = '16.03.2021 21:53:26'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        Ents.Draw( self, false )

        if ( LocalPlayer():GetPos():Distance( self:GetPos() ) > 800 ) then return end

        local rot = ( self:GetPos() - EyePos() ):Angle().yaw - 90
        local head_bone = self:LookupBone( 'ValveBiped.Bip01_Head1' )
        local head = self:GetBonePosition( head_bone )

        cam.Start3D2D( head + Vector( 0, 0, 12 ), Angle( 0, rot, 90 ), 0.1 )
            draw.SimpleTextOutlined( 'Квестодатель', '26 Ambi', 4, 0, C.ABS_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
        cam.End3D2D()
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

function ENT:Use( ePly )
    ePly:SendLua( 'Ambi.Quest.OpenMenu()' )
end