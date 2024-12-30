local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'metz_metz'
ENT.Type	    = 'anim'

ENT.PrintName	= 'MetZ'
ENT.Author		= 'Ambi'
ENT.Category	= 'Metz'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Metz',
    date = '04.07.2022 15:19'
}

function ENT:GetAmount()
    return self.nw_amount
end

Ents.Register( ENT.Class, 'ents', ENT )

if SERVER then
    function ENT:Initialize()
        Ents.Initialize( self, Ambi.Metz.Config.ingredient_metz_model )
        Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

        self:SetMaterial( Ambi.Metz.Config.ingredient_metz_material )
        self:SetAmount( 1 )
        self:SetHealth( 50 )
    end

    function ENT:OnTakeDamage( dmgInfo )
        Ambi.Metz.IngredientTakeRemove( self, dmgInfo )
    end

    function ENT:Use( ePly )
        Ambi.Metz.MetzUse( self, ePly )
    end

    function ENT:SetAmount( nAmount )
        self.nw_amount = nAmount
    end

    function ENT:StartTouch( eObj )
        if self.cant_touch then return end
        if ( eObj:GetClass() ~= self.Class ) then return end
    
        self.cant_touch = true
        eObj.cant_touch = true
    
        local i = eObj:EntIndex()
        local j = self:EntIndex()
    
        local money = eObj.nw_amount + self.nw_amount
        
        if ( i > j ) then 
            self:Remove()
            eObj:SetAmount( money )
        else
            eObj:Remove()
            self:SetAmount( money )
        end
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end

ENT.RenderGroup = RENDERGROUP_BOTH

local COLOR_BLACK = Color(100, 100, 100, 255)
local UI = Ambi.Packages.Out( 'ui' )

function ENT:Draw()
    self:DrawModel()
    self:DrawShadow( false )

    local color = HSVToColor( ( CurTime() * 128 ) % 360, 1, 1 )
    self:SetColor( color  )

    if not self:CheckDistance( LocalPlayer(), Ambi.Metz.Config.draw_distance ) then return end
    if not self:GetAmount() then return end

    local pos = self:GetPos()
	local ang = self:GetAngles()

    ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	cam.Start3D2D( pos + ang:Up(), Angle( 0, LocalPlayer():EyeAngles().y - 90, 90 ), 0.1 )
        draw.SimpleTextOutlined( 'x'..self:GetAmount(), UI.SafeFont( '30 Arial' ), 32, -96, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
    cam.End3D2D()
end

Ents.Register( ENT.Class, 'ents', ENT )