local Ents, C = Ambi.Packages.Out( 'regentity, colors' )
local ENT = {}

ENT.Class       = 'inv_item'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Item'
ENT.Author		= 'Ambi'
ENT.Category	= 'Inv'
ENT.Spawnable   = false

ENT.Stats = {
    type = 'Entity',
    model = 'models/props_lab/box01a.mdl',
    module = 'Inv',
    date = '22.06.2022 02:47'
}

function ENT:GetHeader()
    return self.nw_Header
end

function ENT:GetCount()
    return self.nw_Count
end

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_BOTH

    local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

    function ENT:DrawTranslucent()
        if not self:CheckDistance( LocalPlayer(), 400 ) then return end

        Ents.Draw( self, false )

        if not self:GetCount() then return end
        if not self:GetHeader() then return end

        local pos = self:GetPos()
        local ang = self:GetAngles()

        ang:RotateAroundAxis(ang:Up(), 90)
        ang:RotateAroundAxis(ang:Forward(), 90)

        cam.Start3D2D( pos + ang:Up() * 2, Angle( 0, LocalPlayer():EyeAngles().y - 90, 90 ), 0.1 )
            draw.SimpleTextOutlined( self:GetHeader()..' x'..self:GetCount(), UI.SafeFont( '30 Ambi' ), 32, -96, C.AMBI_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
        cam.End3D2D()
    end
    
    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, nil, nil, COLLISION_GROUP_WEAPON, true, true )

    self:SetTrigger()
end

function ENT:SetHeader( sHeader )
    self.nw_Header = sHeader
end

function ENT:SetCount( nCount )
    self.nw_Count = nCount or 1
end

function ENT:SetClass( sClass )
    if not sClass then return end

    self.class = sClass
end

function ENT:SetItem( sClass, nCount )
    local class = Ambi.Inv.GetItem( sClass )
    if not class then return end

    self:SetHeader( class.name )
    self:SetCount( nCount )
    self:SetClass( sClass )
end

function ENT:Use( eCaller )
    local class = self.class
    if not class then return end

    if not Ambi.Inv.GetItem( class ) then return end

    local player_count_item = eCaller:GetInvItemCount( class )
    local stack = Ambi.Inv.GetItem( class ).stack
    local count = self:GetCount()

    local new_count = player_count_item + count 

    local max_value = 0

    for slot, item in ipairs( eCaller:GetInventory().items ) do
        local item = item.item -- if have item
        if not item then max_value = max_value + stack continue end

        if ( item.class ~= class ) then continue end

        local cnt = item.count
        if ( cnt == stack ) then continue end

        max_value = max_value + (stack - cnt)
    end

    if ( count > max_value ) then
        self:SetCount( count - max_value )

        count = max_value
    else
        self:Remove()
    end

    if ( max_value <= 0 ) then return end

    eCaller:ChatSend( '~G~ [Inv] ~W~ Вы подобрали: ~G~ '..self:GetHeader()..' ('..count..')' )
    eCaller:AddInvItem( class, count )

    hook.Call( '[Ambi.Inv.UseItemEntity]', nil, eCaller, self, class, count, max_value )
end

function ENT:OnRemove()
    timer.Remove( 'AmbiSimpleInventoryDropItem:'..tostring( self ) )
end

function ENT:StartTouch( eObj )
    if ( eObj:GetClass() ~= ENT.Class )  then return end
    if ( eObj.class ~= self.class ) then return end

    if ( self:EntIndex() > eObj:EntIndex() ) then
        if not IsValid( self ) then return end

        eObj:SetCount( self:GetCount() + eObj:GetCount() )
        self:Remove()
    end
end

Ents.Register( ENT.Class, 'ents', ENT )