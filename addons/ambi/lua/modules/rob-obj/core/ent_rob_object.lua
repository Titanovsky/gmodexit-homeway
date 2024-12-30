local Ents, C = Ambi.RegEntity, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'rob_object'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Rob Object'
ENT.Author		= 'Ambi'
ENT.Category	= 'Rob Object'
ENT.Spawnable   = true

ENT.Stats = {
    type = 'Entity',
    model = 'models/props_junk/wood_crate001a_damaged.mdl',
    module = 'Rob Object',
    date = '19.09.2023 23:14'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

    local function PrintChat( sText )
        chat.AddText( C.AMBI, '[•] ', C.ABS_WHITE, sText )
    end
    
    local max_dist = 2400
    local font = 'ambFont22'
    local COLOR_GREEN = Color( 0, 255, 0 )
    
    local w_ent = 270
    local h_ent = 120
    local x_ent = -130
    local y_ent = -182

    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if ( LocalPlayer():GetPos():Distance( self:GetPos() ) > 400 ) then return end

        local rot = ( self:GetPos() - EyePos() ):Angle().yaw - 90
        local pos = self:GetPos() + Vector( 0, 0, self:GetModelRadius() )

        cam.Start3D2D( pos + Vector( 0, 0, 12 ), Angle( 0, rot, 90 ), 0.1 )
            draw.SimpleTextOutlined( Ambi.RobObj.Config.object.name, UI.SafeFont( '46 Ambi' ), 4, 0, C.AMBI, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
        cam.End3D2D()

        Ents.Draw( self, false )
    end
    
    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetTrigger()
    self:SetHealth( Ambi.RobObj.Config.object.hp )

    local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end
end

function ENT:Steal( ePly )
    Ambi.DarkRP.Wanted( ePly, nil, 'Ограбление груза', 60 * 10 )

    local money = math.random( Ambi.RobObj.Config.rewards.min_money_rob, Ambi.RobObj.Config.rewards.max_money_rob )

    ePly:ChatSend( '~W~ Вы закончили ограбление: ~G~'..money..'$')
    ePly:AddMoney( money )

    Ambi.Homeway.NotifyAll( ePly:Name()..' ограбил груз в метро на '..money..'$', 20 )

    self:Remove()

    hook.Call( '[Ambi.RobObj.Stealed]', nil, ePly, money )
end

function ENT:OnTakeDamage( dmg )
	self:SetHealth( self:Health() - dmg:GetDamage() )

	if ( self:Health() <= 0 ) then 
        local attacker = dmg:GetAttacker()
        if ( IsValid( attacker ) and attacker:IsPlayer() and Ambi.RobObj.Config.can_rob_jobs[ attacker:GetJob() ] ) then
            self:Steal( attacker )
        end

        self:Remove() 
    end
end

Ents.Register( ENT.Class, 'ents', ENT )