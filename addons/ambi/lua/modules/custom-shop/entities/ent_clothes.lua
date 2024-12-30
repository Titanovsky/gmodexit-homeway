local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'customshop_clothes'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Clothes'
ENT.Author		= 'Ambi'
ENT.Spawnable   =  false

ENT.Stats = {
    type = 'Entity',
    module = 'CustomShop',
    model = 'models/hunter/blocks/cube05x075x025.mdl',
    date = '12.05.2022 11:48'
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
    Ents.Initialize( self )
    Ents.Physics( self, MOVETYPE_NONE, SOLID_NONE, COLLISION_GROUP_WORLD, false, false )
end

Ents.Register( ENT.Class, 'ents', ENT )