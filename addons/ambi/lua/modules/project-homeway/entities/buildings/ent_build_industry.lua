local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'build_industry'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Пром. Зона'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Buildings'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/ambi/homeway/buildings/hw_industrial.mdl',
    date = '28.08.2024 8:14'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 1200
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )
    end


    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_NONE, SOLID_VPHYSICS, nil, true, true )

    local phys = self:GetPhysicsObject()
    if IsValid( phys ) then
        phys:EnableMotion( false )
        phys:Sleep()
    end
end


Ents.Register( ENT.Class, 'ents', ENT )