local C, Ents = Ambi.General.Global.Colors, Ambi.RegEntity

local ENT = {}

ENT.Class       = 'npc_orgs2'
ENT.Base	    = 'base_ai'
ENT.Type	    = 'ai'

ENT.PrintName	= 'NPC Orgs2'
ENT.Author		= 'Ambi'
ENT.Category	= 'Orgs 2'
ENT.Spawnable   = true

ENT.Stats = {
    type = 'NPC',
    model = 'models/gman.mdl',
    module = 'Orgs2',
    date = '06.09.2023 17:09'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        Ents.Draw( self, false )

        if ( LocalPlayer():GetPos():Distance( self:GetPos() ) > 800 ) then return end

        local rot = ( self:GetPos() - EyePos() ):Angle().yaw - 90
        local head_bone = self:LookupBone( 'ValveBiped.Bip01_Head1' )
        local head = self:GetBonePosition( head_bone )

        cam.Start3D2D( head + Vector( 0, 0, 12 ), Angle( 0, rot, 90 ), 0.1 )
            Draw.SimpleText( 8, 4, 'Меню Организации', UI.SafeFont( '26 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
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
    if ( ePly:GetNWBool( 'amb_players_orgs' ) ) then
		ePly:SendLua( 'AmbOrgs2.openMenuLeaveOrg()' )
	else
		ePly:SendLua( 'AmbOrgs2.openMenuCreateOrg()' )
	end
end