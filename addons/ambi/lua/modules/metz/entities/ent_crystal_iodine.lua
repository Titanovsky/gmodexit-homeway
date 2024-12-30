local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'metz_crystal_iodine'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Прочный Пластилин'
ENT.Author		= 'Ambi'
ENT.Category	= 'Metz'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Metz',
    date = '04.07.2022 14:31'
}

function ENT:GetAmount()
    return self.nw_amount
end

Ents.Register( ENT.Class, 'ents', ENT )

if SERVER then
    function ENT:Initialize()
        Ents.Initialize( self, Ambi.Metz.Config.ingredient_crystal_iodine_model )
        Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

        self:SetMaterial( Ambi.Metz.Config.ingredient_crystal_iodine_material )
        self:SetColor( Ambi.Metz.Config.ingredient_crystal_iodine_color )

        self:SetAmount( 1 )
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

local UI = Ambi.Packages.Out( 'ui' )
local COLOR_BLACK = Color(100, 100, 100, 255)

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
    self:DrawModel()
    self:DrawShadow( false )

    if not self:CheckDistance( LocalPlayer(), Ambi.Metz.Config.draw_distance ) then return end
    if not self:GetAmount() then return end

    local pos = self:GetPos()
	local ang = self:GetAngles()

    ang:RotateAroundAxis(ang:Up(), 90);
	ang:RotateAroundAxis(ang:Forward(), 90);

	cam.Start3D2D( pos + ang:Up(), Angle( 0, LocalPlayer():EyeAngles().y - 90, 90 ), 0.1 )
        draw.SimpleTextOutlined( 'x'..self:GetAmount(), UI.SafeFont( '30 Arial' ), 32, -96, C.ABS_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
    cam.End3D2D()
end

Ents.Register( ENT.Class, 'ents', ENT )