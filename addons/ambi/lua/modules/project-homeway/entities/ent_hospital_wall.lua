local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'ent_hospital_wall'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Госпиталь: Стена'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/hunter/blocks/cube2x3x025.mdl',
    date = '16.08.2024 21:08'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, COLLISION_GROUP_WEAPON, false, true, false )
    self:SetTrigger( true )
end

function ENT:StartTouch( ePly )
    if not ePly:IsPlayer() then return end

    hook.Call( '[Ambi.Homeway.StartTouchHospital]', nil, ePly )

    local tab = Ambi.Homeway.Config.hospital
    if not tab.enable then return end
    if ( ePly:Health() >= tab.min_hp ) then return end

    local point = table.Random( tab.points )
    ePly:SetPos( point )
    ePly:Notify( 'Вам нужно '..tab.min_hp..' здоровья, чтобы выйти из Госпиталя', 6, NOTIFY_ERROR )
end

Ents.Register( ENT.Class, 'ents', ENT )