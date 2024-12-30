local Ents = Ambi.Packages.Out( 'regentity' )

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
local ENT = {}

ENT.Class       = 'drink_vodka'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Водка'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Drinks'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props_junk/garbage_glassbottle003a.mdl',
    date = '19.08.2023 21:19'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local Draw = Ambi.Packages.Out( 'draw' )
    
    local DISTANCE = 600
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, ENT.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end

    AmbDrinks.AddDrunk( ePly, 8.5, 30 )

    self:Remove()
end

Ents.Register( ENT.Class, 'ents', ENT )