local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'applejack_warehouse'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Apple Warehouse'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Works'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props/de_nuke/crate_extrasmall.mdl',
    date = '31.07.2024 2:30'
}

function ENT:GetApplesRed()
    return self.nw_ApplesRed or 0
end

function ENT:GetApplesGreen()
    return self.nw_ApplesGreen or 0
end

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 1200
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if ( LocalPlayer():GetPos():Distance( self:GetPos() ) <= DISTANCE ) then
            cam.Start3D2D( self:GetPos() + self:GetAngles():Up() * 1 + self:GetAngles():Right() * 1 + self:GetAngles():Forward() * 25, self:GetAngles() + Angle( 0, 90, 90 ), 0.1)
                Draw.Box( 400, 140, -190, -290, C.HOMEWAY_BLACK, 6 )
                Draw.SimpleText( -180, -280, 'Красные яблоки: '..self:GetApplesRed(), UI.SafeFont( '44 Montserrat' ), C.FLAT_RED, 'top-left' )
                Draw.SimpleText( -180, -220, 'Зелёные яблоки: '..self:GetApplesGreen(), UI.SafeFont( '44 Montserrat' ), C.FLAT_GREEN, 'top-left' )
            cam.End3D2D()
        end
    end

    function ENT:Initialize()
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end

    local red_count = ePly.apple_red or 0
    local green_count = ePly.apple_green or 0
    local count = red_count + green_count

    if ( red_count > 0 ) then
        self:SetApplesRed( self:GetApplesRed() + red_count )
        ePly.apple_red = 0
        ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Вы положили '..red_count..' шт. ~R~ красных ~W~ яблок' )
    end

    if ( green_count > 0 ) then
        self:SetApplesGreen( self:GetApplesGreen() + green_count )
        ePly.apple_green = 0
        ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Вы положили '..green_count..' шт. ~G~ зелёных ~W~ яблок' )
    end

    if ( count > 0 ) then
        local money = 0

        for i = 1, count do
            money = money + math.random( Ambi.Homeway.Config.applejack.min_reward, Ambi.Homeway.Config.applejack.max_reward )
        end

        ePly:Notify( 'Вы заработали '..money..'$', 3, NOTIFY_SUCCESS )
        ePly:AddMoney( money )

        local players = #player.GetHumans()
        if ( players > 1 ) then
            local bonus = players * Ambi.Homeway.Config.applejack.bonus_for_player

            ePly:ChatSend( '~G~ +'..bonus..'$ ~W~ Бонус за игроков! Зовите больше людей 😉'  )
            ePly:AddMoney( bonus )
        end

        hook.Call( '[Ambi.Homeway.PutApplesWarehouse]', nil, ePly, red_count, green_count )
    end
end

function ENT:SetApplesRed( nCount )
    self.nw_ApplesRed = nCount or 0
end

function ENT:SetApplesGreen( nCount )
    self.nw_ApplesGreen = nCount or 0
end

Ents.Register( ENT.Class, 'ents', ENT )