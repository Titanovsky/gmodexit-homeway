local RegEntity = Ambi.Packages.Out( 'regentity' )
local ENT = {}

ENT.Class       = 'chest'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Сундук'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/clashroyale/chests/lightingchest.mdl',
    date = '19.07.2024 21:22'
}

RegEntity.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 450
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if not self.nw_Chest or ( LocalPlayer():GetPos():Distance( self:GetPos() ) > DISTANCE ) then return end

        local info = Ambi.Homeway.chest_types[ self.nw_Chest ]

        local _,max = self:GetRotatedAABB(self:OBBMins(), self:OBBMaxs() )
        local rot = (self:GetPos() - EyePos()):Angle().yaw - 90
        local sin = math.sin(CurTime() * 4 + self:EntIndex()) / 3 + .5 -- EntIndex дает разницу в движении
        local center = self:LocalToWorld(self:OBBCenter())

        cam.Start3D2D(center + Vector(0, 0, math.abs(max.z / 2) + 6 + sin), Angle(0, rot, 90), 0.1)
            if not self.nw_RewardItem then
                Draw.SimpleText( 4, 4, self.nw_RewardHeader or info.header, UI.SafeFont( '40 Montserrat SemiBold' ), info.color, 'center', 1, C.BLACK ) 
            else
                local item = Ambi.Inv.GetItem( self.nw_RewardItem )

                Draw.SimpleText( 4, 4, item.name, UI.SafeFont( '45 Montserrat Medium' ), C.HOMEWAY_WHITE, 'center', 1, C.BLACK ) 

                if item.icon and not string.StartsWith( item.icon, 'models' ) then
                    Draw.Material( 128, 128, -64, -180, CL.Material( 'inv_'..self.nw_RewardItem ) )
                end
            end
        cam.End3D2D()
    end

    return RegEntity.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    RegEntity.Initialize( self, self.Stats.model )
    RegEntity.Physics( self, MOVETYPE_NONE, SOLID_NONE, COLLISION_GROUP_WEAPON, false, true, false )

    local phys = self:GetPhysicsObject()
    if IsValid( phys ) then
        phys:EnableMotion( false )
        phys:Sleep()
    end

    self:SetModelScale( 0.5 )
    self:SetTrigger( true )
    self:SetChest( 'money' )
end

function ENT:Use( ePly )
    if self.block_use then return end
    if not ePly:IsPlayer() then return end
    if self.nw_PlayerOwnerSteamID and timer.Exists( 'Ambi.Homeway.ChestRemoveOwner:'..self:EntIndex()..':'..self.nw_PlayerOwnerSteamID ) and ( ePly:SteamID() ~= self.nw_PlayerOwnerSteamID ) then ePly:Notify( 'Сундук личный, но станет общедоступным', 5, NOTIFY_ERROR ) return end

    if self.ready then
        if self.nw_RewardItem then
            ePly:AddInvItemOrDrop( self.nw_RewardItem, 1 )

            local name = Ambi.Inv.GetItem( self.nw_RewardItem ).name

            ePly:Notify( 'Вы получили в инвентарь '..name, 10, 2 )

            hook.Call( '[Ambi.Homeway.UsedChest]', nil, ePly, self, self.nw_RewardItem, Ambi.Inv.GetItem( self.nw_RewardItem or '' ) )
        end

        self:Remove()
    else
        self:EmitSound( 'ambi/ui/bell3.mp3' )
        self:StartAction()
    end
end

function ENT:StartAction()
    if self.ready then return end

    self.block_use = true

    self:SetAngles( self:GetAngles() + Angle( 0, 0, 15 ) )
    self:EmitSound( 'physics/cardboard/cardboard_box_break1.wav' )
    self:SetModelScale( 0.6 )

    timer.Simple( 0.75, function()
        if not IsValid( self ) then return end

        self:SetAngles( self:GetAngles() + Angle( 0, 0, -30 ) )
        self:EmitSound( 'physics/cardboard/cardboard_box_break2.wav' )
        self:SetModelScale( 0.7 )

        timer.Simple( 0.75, function()
            if not IsValid( self ) then return end
    
            self:SetAngles( self:GetAngles() + Angle( 0, 0, 30 ) )
            self:EmitSound( 'physics/cardboard/cardboard_box_break2.wav' )
            self:SetModelScale( 0.8 )

            timer.Simple( 0.75, function()
                if not IsValid( self ) then return end
        
                self:SetAngles( self:GetAngles() + Angle( 0, 0, -35 ) )
                self:EmitSound( 'physics/cardboard/cardboard_box_break3.wav' )
                self:SetModelScale( 1 )

                timer.Simple( 0.1, function()
                    if not IsValid( self ) then return end

                    self:MakeReward()
                end )
            end )
        end )
    end )
end

function ENT:MakeReward()
    local info = Ambi.Homeway.chest_types[ self.nw_Chest ]
    if not info then return end

    local items = info.items
    if not items then return end

    local reward = table.Random( items )

    self:EmitSound( 'garrysmod/save_load'..math.random( 1, 4 )..'.wav' )
    self:SetModel( 'models/hunter/misc/sphere025x025.mdl' )
    self:SetMaterial( 'models/debug/debugwhite' )
    self:SetPos( self:GetPos() + Vector( 0, 0, 20 ) )

    if ( reward == 'none' ) then
        self.nw_RewardHeader = 'Ничего'

        timer.Simple( 10, function()
            if IsValid( self ) then 
                self:Remove() 
            end
        end )
    else
        self.nw_RewardItem = reward

        if string.StartsWith( Ambi.Inv.GetItem( reward ).icon, 'models' ) then 
            self:SetModel( Ambi.Inv.GetItem( reward ).icon ) 
            self:SetAngles( Angle( 0, 0, 0 ) )
            self:SetMaterial( '' )
            self:SetColor( Color( 255, 255, 255 ) )
        end
    end

    local stars = EffectData()
        stars:SetOrigin( self:GetPos() )
        stars:SetNormal( Vector( 0, 0, 0 ) )
    util.Effect( "trampoline_stars", stars )

    local stars = EffectData()
        stars:SetOrigin( self:GetPos() )
        stars:SetNormal( Vector( 1, 1, 1 ) )
    util.Effect( "trampoline_stars", stars )

    self.block_use = false
    self.ready = true

    hook.Call( '[Ambi.Homeway.OpenChest]', nil, self.nw_PlayerOwner, self, self.nw_RewardItem, Ambi.Inv.GetItem( self.nw_RewardItem or '' ) ) --
end

function ENT:SetPlayerOwner( ePly )
    if not ePly:IsPlayer() then return end

    self.nw_PlayerOwner = ePly
    self.nw_PlayerOwnerName = ePly:Name()
    self.nw_PlayerOwnerSteamID = ePly:SteamID()

    if not ePly.notice_about_chest_warn then
        ePly.notice_about_chest_warn = true

        ePly:Notify( 'У вас 5 минут забрать награду, потом она станет для всех', 12 )
    end

    timer.Create( 'Ambi.Homeway.ChestRemoveOwner:'..self:EntIndex()..':'..ePly:SteamID(), 60 * 5, 1, function() 
        if not IsValid( self ) then return end

        self.nw_PlayerOwner = false
        self.nw_PlayerOwnerName = ''
    end )
end

function ENT:OnRemove()
    if self.nw_PlayerOwnerSteamID then timer.Remove( 'Ambi.Homeway.ChestRemoveOwner:'..self:EntIndex()..':'..self.nw_PlayerOwnerSteamID ) end
end

function ENT:SetChest( sChest )
    local info = Ambi.Homeway.chest_types[ sChest or '' ]
    if not info then self:Remove() return end

    self.nw_Chest = sChest

    if info.color then self:SetColor( info.color ) end
    if info.model then self:SetModel( info.model ) end
    if info.material then self:SetMaterial( info.material ) end
end

RegEntity.Register( ENT.Class, 'ents', ENT )