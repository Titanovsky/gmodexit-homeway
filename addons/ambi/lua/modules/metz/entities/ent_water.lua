local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'metz_water'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Вода'
ENT.Author		= 'Ambi'
ENT.Category	= 'Metz'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Metz',
    date = '04.07.2022 17:14'
}

function ENT:GetAmount()
    return self.nw_amount
end

Ents.Register( ENT.Class, 'ents', ENT )

if SERVER then
    function ENT:Initialize()
        Ents.Initialize( self, Ambi.Metz.Config.ingredient_water_model )
        Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

        self:SetAmount( Ambi.Metz.Config.ingredient_water_amount )
        self:SetColor( Ambi.Metz.Config.ingredient_water_color )
        self:SetHealth( 50 )
    end

    function ENT:OnTakeDamage( dmgInfo )
        Ambi.Metz.IngredientTakeRemove( self, dmgInfo )
    end

    function ENT:StartTouch( eObj )
        Ambi.Metz.IngredientStartTouch( self, eObj )
    end

    function ENT:SetAmount( nAmount )
        self.nw_amount = nAmount
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
    self:DrawModel()
    self:DrawShadow( false )
end

Ents.Register( ENT.Class, 'ents', ENT )