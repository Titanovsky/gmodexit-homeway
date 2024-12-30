local C, Ents = Ambi.General.Global.Colors, Ambi.RegEntity

local ENT = {}

ENT.Class       = 'npc_duelist'
ENT.Base	    = 'base_ai'
ENT.Type	    = 'ai'

ENT.PrintName	= 'NPC Duelist'
ENT.Author		= 'Ambi'
ENT.Category	= 'Duel'
ENT.Spawnable   = true

ENT.Stats = {
    type = 'NPC',
    model = 'models/combine_soldier.mdl',
    module = 'Duel',
    date = '27.09.2023 05:00'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        Ents.Draw( self, false )

        if ( LocalPlayer():GetPos():Distance( self:GetPos() ) > 800 ) then return end

        local rot = ( self:GetPos() - EyePos() ):Angle().yaw - 90
        local head_bone = self:LookupBone( 'ValveBiped.Bip01_Head1' )
        local head = self:GetBonePosition( head_bone )

        cam.Start3D2D( head + Vector( 0, 0, 12 ), Angle( 0, rot, 90 ), 0.1 )
            Draw.SimpleText( 8, 4, 'Дуэль', UI.SafeFont( '26 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
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
    if timer.Exists( 'Ambi.DuelAccept' ) then  
		if ( ePly == Ambi.Duel.duelist2 ) then Ambi.Duel.AcceptDuel( ePly ) end
	elseif timer.Exists( 'Ambi.DuelTime' ) then
		ePly:SendLua( 'Ambi.Duel.OpenBet()' )
	else
		ePly:SendLua( 'Ambi.Duel.OpenRegister()' )
	end
end