local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'cactus_warehouse'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Cactus Warehouse'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Works'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props/de_nuke/crate_extrasmall.mdl',
    date = '09.08.2024 10:18'
}

function ENT:GetCactuses()
    return self.nw_Cactuses or 0
end

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 800
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if ( LocalPlayer():GetPos():Distance( self:GetPos() ) <= DISTANCE ) then
            cam.Start3D2D( self:GetPos() + self:GetAngles():Up() * 1 + self:GetAngles():Right() * 1 + self:GetAngles():Forward() * 25, self:GetAngles() + Angle( 0, 90, 90 ), 0.1)
                Draw.Box( 400, 140, -190, -290, C.HOMEWAY_BLACK, 6 )
                Draw.SimpleText( -180, -280, 'Кактусы: '..self:GetCactuses(), UI.SafeFont( '44 Montserrat' ), C.FLAT_GREEN, 'top-left' )
            cam.End3D2D()
        end
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end

    local count = ePly.cactuses or 0

    if ( count > 0 ) then
        local money = 0

        for i = 1, count do
            money = money + math.random( Ambi.Homeway.Config.cactus.min_reward, Ambi.Homeway.Config.cactus.max_reward )
        end

        ePly.cactuses = 0
        ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Вы положили '..count..' шт. ~G~ кактусов' )
        ePly:Notify( 'Вы заработали '..money..'$', 3, NOTIFY_SUCCESS )
        ePly:AddMoney( money )

        local players = #player.GetHumans()
        if ( players > 1 ) then
            local bonus = players * Ambi.Homeway.Config.cactus.bonus_for_player

            ePly:ChatSend( '~G~ +'..bonus..'$ ~W~ Бонус за игроков! Зовите больше людей 😉'  )
            ePly:AddMoney( bonus )
        end

        self:SetCactuses( self:GetCactuses() + count )

        hook.Call( '[Ambi.Homeway.PutCactusWarehouse]', nil, ePly, count, money )
    end
end

function ENT:SetCactuses( nCount )
    self.nw_Cactuses = nCount or 0
end

Ents.Register( ENT.Class, 'ents', ENT )