local RegEntity = Ambi.Packages.Out( 'regentity' )
local ENT = {}

ENT.Class       = 'warehouse'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Warehouse'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props_c17/lockers001a.mdl',
    date = '19.07.2024 20:01'
}

function ENT:GetWarehouse()
    return self.nw_Warehouse
end

function ENT:GetItems()
    local wh = Ambi.Homeway.GetWarehouse( self:GetWarehouse() )
    local result = {}

    for i, wep in ipairs( wh.items ) do
        result[ i ] = { count = self[ 'nw_ItemCount'..i ], header = wep.header, class = wep.class }
    end

    return result
end

function ENT:GetWeaponCount( nID )
    return self[ 'nw_ItemCount'..nID ]
end

function ENT:GetMedKits()
    return self[ 'nw_MedKits' ]
end

function ENT:GetArmor()
    return self[ 'nw_Armor' ]
end

function ENT:GetAmmo()
    return self[ 'nw_Ammo' ]
end

function ENT:GetMoney()
    return self[ 'nw_Money' ] or 0
end

function ENT:IsClosed()
    return self.nw_Closed
end

RegEntity.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 600 * 600

    local COLOR_PANEL = Color( 0, 0, 0, 220 ) 
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end
        if not self:GetWarehouse() then return end

        local wh = Ambi.Homeway.GetWarehouse( self:GetWarehouse() )

        cam.Start3D2D( self:GetPos() + self:GetAngles():Up() * 28 + self:GetAngles():Right() * 24.2 + self:GetAngles():Forward() * 10, self:GetAngles() + Angle( 0, 90, 90 ), 0.1)
            Draw.Box( 180, 50, 140, 0, C.HOMEWAY_BLACK, 4 )
            Draw.Box( 180 - 8, 50 - 8, 140 + 4, 4, C.HOMEWAY_BLUE_DARK, 6 )
            Draw.SimpleText( 230, 23, wh.header, UI.SafeFont( '50 Montserrat SemiBold' ), wh.color, 'center', 1, C.ABS_BLACK )

            Draw.Box( 484 - 24, 400, 12, 60, C.HOMEWAY_BLACK, 6 )
            Draw.Box( 484 - 24 - 24, 400 - 24, 12 + 12, 60 + 12, C.HOMEWAY_BLUE_DARK, 8 )

            Draw.SimpleText( 450, 70, self:IsClosed() and 'Закрыт' or 'Открыт', UI.SafeFont( '32 Montserrat SemiBold' ), self:IsClosed() and C.FLAT_RED or C.FLAT_GREEN, 'top-right', 1, C.ABS_BLACK )
            Draw.SimpleText( 440, 440, string.Comma( self:GetMoney() )..'$', UI.SafeFont( '45 Montserrat SemiBold' ), C.GREEN, 'bottom-right', 1, C.ABS_BLACK )
            
            for i, wep in ipairs( wh.items ) do
                local count = self:GetWeaponCount( i ) or 0
                local text_count = ( count > 0 ) and ( wep.max and '  '..count..'/'..wep.max or '  x'..count ) or ''

                Draw.SimpleText( 34, 70 + 30 * ( i - 1 ), i..'. '..wep.header..text_count, UI.SafeFont( '28 Montserrat Medium' ), ( count > 0 ) and C.WHITE or C.AMBI_GRAY, 'top-left', 1, C.ABS_BLACK )
            end

            local ammo = self:GetAmmo()
            if ammo then
                Draw.Material( 32, 32, 420, 130, CL.Material( 'hw_hud1_ammo' ) )
                Draw.SimpleText( 410, 124, ammo, UI.SafeFont( '40 Montserrat' ), C.ABS_WHITE, 'top-right' )
            end

            local medkits = self:GetMedKits()
            if medkits then
                Draw.Material( 32, 32, 420, 180, CL.Material( 'hw_hud1_hp1' ) )
                Draw.SimpleText( 410, 174, medkits, UI.SafeFont( '40 Montserrat' ), C.ABS_WHITE, 'top-right' )
            end

            local armor = self:GetArmor()
            if armor then
                Draw.Material( 32, 32, 420, 230, CL.Material( 'hw_hud1_armor1' ) )
                Draw.SimpleText( 410, 224, armor, UI.SafeFont( '40 Montserrat' ), C.ABS_WHITE, 'top-right' )
            end
        cam.End3D2D()
    end

    return RegEntity.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    RegEntity.Initialize( self, self.Stats.model )
    RegEntity.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    local phys = self:GetPhysicsObject()
    if IsValid( phys ) then
        phys:EnableMotion( false )
        phys:Sleep()
    end

    self:SetWarehouse( 'fbi' )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end

    local wh = Ambi.Homeway.GetWarehouse( self:GetWarehouse() )
    if not wh then return end

    local job = ePly:GetJob()
    if wh.raiders and wh.raiders[ job ] then 
        Ambi.Homeway.RaidWarehouse( ePly, self ) 
        return
    end

    if self:IsClosed() then ePly:Notify( 'Склад закрыт', 2, NOTIFY_ERROR ) return end
    
    if wh.jobs and not wh.jobs[ ePly:GetJob() ] then return end

    ePly:SendLua( 'Ambi.Homeway.OpenWarehouse('..self:EntIndex()..')' )
end

function ENT:StartTouch( eObj )
    if ( eObj:GetClass() ~= 'factory_box' ) then return end

    local wh = Ambi.Homeway.GetWarehouse( self:GetWarehouse() )
    if not wh then return end

    local can = false
    for class, _ in pairs( Ambi.Homeway.Config.factory_items ) do
        if ( eObj:GetWeapon( class ) > 0 ) then can = true break end
    end
    if not can then eObj:Remove() return end

    local plys = {}
    for _, ply in ipairs( player.GetAll() ) do
        if wh.jobs[ ply:GetJob() ] then plys[ #plys + 1 ] = ply end
    end

    local can_remove = true
    for i, wep in ipairs( wh.items ) do
        local count_wep_box = eObj:GetWeapon( wep.class )
        if ( count_wep_box <= 0 ) then continue end

        local count_wep_warehouse = self:GetWeaponCount( i )
        local add = count_wep_warehouse + count_wep_box

        local revenue = 0

        if wep.max and ( add > wep.max ) then
            revenue = add - wep.max

            add = wep.max
            count_wep_box = wep.max - self:GetWeaponCount( i )
            if ( count_wep_box <= 0 ) then return end

            can_remove = false
        end

        eObj:SetWeapon( wep.class, revenue )
        self:SetWeaponCount( i, add )

        for _, ply in ipairs( plys ) do
            ply:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Склад пополнился оружием ~HOMEWAY_BLUE~ '..wep.header..' ~W~ на ~HOMEWAY_BLUE~ '..count_wep_box..' ~W~ единиц' )
        end
    end

    if eObj:HasWeapons() then can_remove = false end

    if can_remove then eObj:Remove() end
end

function ENT:SetWarehouse( sType )
    local wh = Ambi.Homeway.GetWarehouse( sType )
    if not wh then return end

    self.nw_Warehouse = sType

    for i, wep in ipairs( wh.items ) do
        self[ 'nw_ItemCount'..i ] = wep.count
    end

    if wh.ammo then self.nw_Ammo = wh.ammo end
    if wh.medkits then self.nw_MedKits = wh.medkits end
    if wh.armor then self.nw_Armor = wh.armor end
end

function ENT:Close()
    self.nw_Closed = true

    local wh = Ambi.Homeway.GetWarehouse( self:GetWarehouse() )
    if not wh then return end

    for _, ply in ipairs( player.GetAll() ) do
        if wh.jobs[ ply:GetJob() ] then 
            ply:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Лидер ~FLAT_RED~ закрыл ~W~ склад' )
        end
    end

    self:EmitSound( 'doors/default_locked.wav' )
end

function ENT:Open()
    self.nw_Closed = false

    local wh = Ambi.Homeway.GetWarehouse( self:GetWarehouse() )
    if not wh then return end

    for _, ply in ipairs( player.GetAll() ) do
        if wh.jobs[ ply:GetJob() ] then 
            ply:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Лидер ~FLAT_GREEN~ открыл ~W~ склад' )
        end
    end

    self:EmitSound( 'doors/default_locked.wav' )
end

function ENT:SetWeaponCount( nID, nCount )
    self[ 'nw_ItemCount'..nID ] = nCount or 0
end

function ENT:SetMedKits( nCount )
    self[ 'nw_MedKits' ] = nCount or 0
end

function ENT:SetArmor( nCount )
    self[ 'nw_Armor' ] = nCount or 0
end

function ENT:SetAmmo( nCount )
    self[ 'nw_Ammo' ] = nCount or 0
end

function ENT:SetMoney( nCount )
    self[ 'nw_Money' ] = nCount or 0
end

function ENT:AddMoney( nCount )
    self:SetMoney( self:GetMoney() + nCount )
end

hook.Add( 'KeyPress', 'Ambi.Homeway.CloseWarehouse', function(ePly, nKey )
    if ( nKey ~= IN_RELOAD ) then return end

    local ent = ePly:GetEyeTrace().Entity
    if not IsValid(ent) or ( ent:GetClass() ~= ENT.Class ) then return end
    if ( ePly:GetPos():DistToSqr( ent:GetPos() ) >= 100 * 100 ) then return end

    local wh = Ambi.Homeway.GetWarehouse( ent:GetWarehouse() )
    if not wh.leaders[ ePly:GetJob() ] then ePly:Notify( 'Ты не лидер', 4, NOTIFY_ERROR ) return end

    if ent:IsClosed() then ent:Open() else ent:Close() end
end )

RegEntity.Register( ENT.Class, 'ents', ENT )