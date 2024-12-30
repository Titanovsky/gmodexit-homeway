--[[
              _____           _  _       _______                      
             / ____|         | |( )     |__   __|                     
            | |      ___   __| ||/ ___     | |  __ _  ___   ___  _ __ 
            | |     / _ \ / _` |  / __|    | | / _` |/ __| / _ \| '__|
            | |____|  __/| (_| |  \__ \    | || (_| |\__ \|  __/| |   
             \_____|\___| \__,_|  |___/    |_| \__,_||___/ \___||_| 
]]

if ( CLIENT ) then
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/entities/weapon_taser" )
    SWEP.BounceWeaponIcon = false

    killicon.Add( "weapon_taser", "vgui/entities/killicon_taser", Color( 255, 255, 255, 255 ) )
end

SWEP.PrintName = "Taser"
SWEP.Author = "Ced" 
SWEP.Purpose = "Tases players from a distance, turning them into helpless ragdolls which you can electrocute for a certain amount of time!"
SWEP.Instructions = "Mouse1 to shoot, Mouse2 to electrocute."
SWEP.Category = "Ced's Weapons"
SWEP.Slot = 1

SWEP.HoldType  = "revolver"

SWEP.Primary.ClipSize = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Sound = "ced/taser/taser_shot.wav"

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.Spawnable = true

SWEP.UseHands = true

-- c_model by Buu342.
-- You can find this model at Buu342's addon: http://steamcommunity.com/sharedfiles/filedetails/?id=239687689 
SWEP.ViewModel = "models/csgo/weapons/c_csgo_taser.mdl"
SWEP.WorldModel = "models/csgo/weapons/w_eq_taser.mdl"

SWEP.Prongs = {}
SWEP.Deploying = false

function SWEP:Deploy()
    self:SetHoldType( self.HoldType )
    self:SendWeaponAnim( ACT_VM_DRAW )

    self.Owner:EmitSound( "ced/taser/taser_draw.wav" )

    self.Deploying = true
    timer.Simple( self.Owner:GetViewModel():SequenceDuration(), function()
        if ( IsValid( self ) ) then
            self.Deploying = false
        end
    end )

    if ( SERVER ) then
        self.ShootPos = ents.Create( "prop_physics" )
        self.ShootPos:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
        self.ShootPos:SetNoDraw( true )
        self.ShootPos:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
		
        if ( not self.Owner:Crouching() ) then
			self.ShootPos:SetPos( self:GetBonePosition( self:LookupBone( "frame" ) ) + Vector( 0, 0, 68 ) )
		else
			self.ShootPos:SetPos( self:GetBonePosition( self:LookupBone( "frame" ) ) + Vector( 0, 0, 32 ) )
		end
		
        self.ShootPos:Spawn()
		
		local range = GetConVar( "taser_range" ):GetFloat() or 450
		for _, p in pairs( self.Prongs ) do
			self.Cable = constraint.Rope( self.ShootPos, p, 0, 0, Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), range, 0, 0, 0.25, "cable/blue_elec", false )
			self.Cable2 = constraint.Rope( self.ShootPos, p, 0, 0, Vector( 0, 0, -1 ), Vector( 0, 0, 0 ), range, 0, 0, 0.25, "cable/blue_elec", false )
		end
    end

    return true
end

function SWEP:Holster()
    if ( SERVER ) then
		for _, p in pairs( self.Prongs ) do
			if ( not IsValid( p.Target ) and IsValid( p ) ) then
				p:Remove()
				table.RemoveByValue( self.Prongs, p )
			end
		end
	
        if ( IsValid( self.ShootPos ) ) then
            self.ShootPos:Remove()
        end

        if ( IsValid( self.Cable ) and IsValid( self.Cable2 ) ) then
            self.Cable:Remove()
            self.Cable2:Remove()
        end
    end

    return true
end

function SWEP:Think()
    if ( SERVER and IsValid( self.ShootPos ) ) then
        if ( not self.Owner:Crouching() ) then
			self.ShootPos:SetPos( self:GetBonePosition( self:LookupBone( "frame" ) ) + Vector( 0, 0, 68 ) )
		else
			self.ShootPos:SetPos( self:GetBonePosition( self:LookupBone( "frame" ) ) + Vector( 0, 0, 32 ) )
		end
		
        self.ShootPos:SetAngles( Angle( 0, 0, 0 ) )
    elseif ( SERVER ) then
        self.ShootPos = ents.Create( "prop_physics" )
        self.ShootPos:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
        self.ShootPos:SetNoDraw( true )
        self.ShootPos:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
		
        if ( not self.Owner:Crouching() ) then
			self.ShootPos:SetPos( self:GetBonePosition( self:LookupBone( "frame" ) ) + Vector( 0, 0, 68 ) )
		else
			self.ShootPos:SetPos( self:GetBonePosition( self:LookupBone( "frame" ) ) + Vector( 0, 0, 32 ) )
		end
		
        self.ShootPos:Spawn()
		
		local range = GetConVar( "taser_range" ):GetFloat() or 450
		for _, p in pairs( self.Prongs ) do
			self.Cable = constraint.Rope( self.ShootPos, p, 0, 0, Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), range, 0, 0, 0.25, "cable/blue_elec", false )
			self.Cable2 = constraint.Rope( self.ShootPos, p, 0, 0, Vector( 0, 0, -1 ), Vector( 0, 0, 0 ), range, 0, 0, 0.25, "cable/blue_elec", false )
		end
    end
end

function SWEP:PrimaryAttack()
    if ( self.Deploying ) then return false end

    local tr = self.Owner:GetEyeTrace()
    local ply = tr.Entity
    if not IsValid( ply ) then return end
    if not ply:IsPlayer() then return end
    if ply:IsPolice() then return end
    if ply:IsAdminMode() then return end

    if ( ply:GetPos():DistToSqr( self.Owner:GetPos() ) > 370 ^ 2 ) then return end
	
	self:ShootEffects()

    if ( SERVER ) then
        if ply.has_tasered then return end
        if ( hook.Call( '[Ambi.Homeway.CanTaser]', nil, self.Owner, ply, self ) == false ) then return end

        self.Owner:EmitSound( self.Primary.Sound, 35 )

        self.Prong = ents.Create( "taser_prong" )
        self.Prong:SetAngles( self.Owner:EyeAngles() )
        self.Prong:SetPos( self.Owner:GetShootPos() )
        self.Prong:SetAngles( self.Owner:EyeAngles() )
        self.Prong.Owner = self.Owner
        self.Prong:Spawn()

        table.insert( self.Prongs, #self.Prongs + 1, self.Prong )

        local phys = self.Prong:GetPhysicsObject()
        local range = GetConVar( "taser_range" ):GetFloat() or 450
        phys:ApplyForceCenter( self.Owner:GetAimVector():GetNormalized() * math.pow( tr.HitPos:Length(), 8 ) )

        local cable1 = constraint.Rope( self.Prong, ply, 0, 0, Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), range, 0, 0, 1, "cable/blue_elec", false, Color(255,0,0) )
        local cable2 = constraint.Rope( self.Prong, ply, 0, 0, Vector( 0, 0, -1 ), Vector( 0, 0, 0 ), range, 0, 0, 1, "cable/blue_elec", false, Color(255,0,0) )

        if ( ply:Health() > 1 ) then
            ply:TakeDamage( 1, self.Owner, self )
        end

        ply.has_tasered = true
        ply:GodEnable()
        ply:Freeze( true )
        ply:EmitSound( 'vo/npc/Barney/ba_pain0'..math.random( 1, 9 )..'.wav' )
        ply:ScreenFade(SCREENFADE.IN, Color(255,255,255,255), 3, 0)

        if ply:HasWeapon( 'keys' ) then ply:SelectWeapon( 'keys' ) end

        local ed = EffectData()
		ed:SetEntity( ply )
		util.Effect( "entity_remove", ed, true, true )

        timer.Simple( 3.5, function()
            if IsValid( cable1 ) then cable1:Remove() end
            if IsValid( cable2 ) then cable2:Remove() end

            if not IsValid( ply ) then return end
            
            ply.has_tasered = false
            ply:Freeze( false ) 
            ply:GodDisable()
        end )
    
		self:SetNextPrimaryFire( CurTime() + 8 )
        self.Owner:Notify( 'Перезарядка 8 секунд', 3 )

        hook.Call( '[Ambi.Homeway.Taser]', nil, self.Owner, ply, self )
	end
end

function SWEP:SecondaryAttack()
    -- if ( self.Prongs == nil ) then return end

    -- for _, p in pairs( self.Prongs ) do
    --     if ( IsValid( p.Target ) ) then
    --         p.Target:TakeDamage( GetConVar( "taser_damage" ):GetFloat() or 0.5, self.Owner, self )
    --     end
    -- end

    -- self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:ShootEffects()
    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetTexture( self.WepSelectIcon )

	y = y + 10
	x = x + 30
	wide = wide - 20

	surface.DrawTexturedRect( x , y , ( wide / 1.35 ), ( wide / 1.35 ) )

	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
end