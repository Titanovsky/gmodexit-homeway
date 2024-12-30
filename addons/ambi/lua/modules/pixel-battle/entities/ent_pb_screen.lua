local C, RegEntity = Ambi.Packages.Out( 'colors, regentity' )

local ENT = {}

ENT.Class       = 'pb_screen'
ENT.Type	    = 'anim'

ENT.PrintName	= 'PB Screen'
ENT.Author		= 'Ambi'
ENT.Category	= 'PixelBattle'
ENT.Spawnable   = true

ENT.Stats = {
    type = 'Entity',
    model = 'models/hunter/plates/plate3x5.mdl',
    module = 'PixelBattle',
    date = '02.07.2024 20:30'
}

RegEntity.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        RegEntity.Draw( self, false )
    end

    return RegEntity.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    RegEntity.Initialize( self, self.Stats.model )
    RegEntity.Physics( self, MOVETYPE_NONE, SOLID_VPHYSICS, COLLISION_GROUP_WEAPON, false, false, false )

    self:SetTrigger( true )
end

function ENT:Use( ePly )
    if not IsValid( ePly ) or not ePly:IsPlayer() then return end

    ePly:SendLua( 'Ambi.PixelBattle.ShowView()' )
end

RegEntity.Register( ENT.Class, 'ents', ENT )