
AddCSLuaFile()

SWEP.PrintName				= "Наркотестер"
SWEP.Author					= "AmbitionProject"
SWEP.Purpose				= "пкм - Испольовать"
SWEP.Category 				= "Drugs"

SWEP.Slot					= 2
SWEP.SlotPos				= 1

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel				= Model( "models/weapons/c_bong.mdl" )
SWEP.WorldModel				= Model( "models/weapons/w_bong.mdl" )
SWEP.ViewModelFOV			= 54
SWEP.UseHands				= true

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.MaxAmmo				= 100	-- Maxumum ammo

local HealSound = Sound( "HealthKit.Touch" )
local DenySound = Sound( "WallHealth.Deny" )

function SWEP:Initialize()

	self:SetHoldType( "normal" )

end

function SWEP:PreDrawViewModel( vm,ply,wep )
	vm:SetNoDraw(true)
end

function SWEP:DrawWorldModel( )

end

function SWEP:Audio(ad)
	self.Owner:EmitSound("npc/metropolice/vo/on"..math.random(1,2)..".wav")
	timer.Simple(0.25,function()
		self.Owner:EmitSound(ad)
		timer.Simple(SoundDuration(ad)+0.25,function()
			self.Owner:EmitSound("npc/metropolice/vo/off"..math.random(1,4)..".wav")
		end)
	end)
end

SWEP.NThink = 0
local best = Vector(846196,123512,632452)
function SWEP:Think()
	if ( CLIENT ) then return end
	if(self.NThink < CurTime()) then
		self.NThink = CurTime() + 1
		best = Vector(846196,123512,632452)
		for k,v in pairs(SMOKEPUFFS_TABLE) do
			if(v[1]:Distance(self.Owner:GetPos()) < 1024 && v[1]:Distance(self.Owner:GetPos()) < best:Distance(self.Owner:GetPos())) then
				best = v[1]
			end
		end
		//76561198011794778
		for k,v in pairs(ents.FindByClass("sent_drug_pot")) do
			if(v:GetPos():Distance(self.Owner:GetPos()) < 1024 && v:GetPos():Distance(self.Owner:GetPos()) < best:Distance(self.Owner:GetPos())) then
				if(v:GetNWInt("Level",0) > 0) then
					best = v:GetPos()
				end
			end
		end

		self:SetNWInt("SmokeLevel",math.Clamp(1-(best:Distance(self.Owner:GetPos())/1024),0,1)*100)
		if(IsValid(self:GetNWEntity("DangPlayer"))) then
			if(self:GetNWEntity("DangPlayer"):GetWeed() <= 10) then
				self:SetNWEntity("DangPlayer",game.GetWorld())
			end
		end
	end
end

local aff = {"npc/metropolice/vo/gotsuspect1here.wav","npc/metropolice/vo/lookingfortrouble.wav","npc/metropolice/vo/loyaltycheckfailure.wav"}
local str = {"npc/metropolice/vo/getoutofhere.wav","npc/metropolice/vo/criminaltrespass63.wav","npc/metropolice/vo/ispassive.wav"}
local sto = {"npc/metropolice/vo/holdit.wav","npc/metropolice/vo/dontmove.wav","npc/metropolice/vo/lockyourposition.wav"}

function SWEP:PrimaryAttack()

	if ( CLIENT ) then return end

	local tr = self.Owner:GetEyeTrace()

	if(IsValid(tr.Entity) && tr.Entity:IsPlayer()) then
		if(tr.Entity:GetWeed() > 25) then
			self:SetNWEntity("DangPlayer",tr.Entity)
			self:Audio(table.Random(aff))
		else
			self:Audio(table.Random(str))
		end
	end

	self:SetNextPrimaryFire(CurTime() + 1)

end

function SWEP:SecondaryAttack()

	if ( CLIENT ) then return end

	local ad = table.Random(sto)
	self:Audio(ad)

	self:SetNextSecondaryFire( CurTime() + SoundDuration(ad)+0.5 )
end

function SWEP:Holster()
	if(IsValid(self.Owner:GetViewModel()) && self.Owner:GetViewModel(0) != nil) then
		self.Owner:GetViewModel():SetNoDraw(false)
	end
	return true
end

function SWEP:Reload()
	self:SetNWEntity("DangPlayer",game.GetWorld())
end

if CLIENT then
end

local lvl = 0

function SWEP:DrawHUD()

	local col = HSVToColor( CurTime() % 6 * 60, 1, 1 )

	surface.SetDrawColor(75,75,75)

	surface.DrawRect(ScrW()/2-128,ScrH()-104,256,28)
	surface.DrawRect(ScrW()/2-128,ScrH()-72,256,48)

	draw.SimpleText("Weed Sniffer","Trebuchet26",ScrW()/2,ScrH()-104,Color(25,25,25),TEXT_ALIGN_CENTER)
	draw.SimpleText("Weed Sniffer","Trebuchet26",ScrW()/2,ScrH()-103,Color(235,235,235),TEXT_ALIGN_CENTER)

	surface.SetDrawColor(25,155,25)
	surface.DrawRect(ScrW()/2-128+6,ScrH()-72+6,256-12,48-12)

	lvl = Lerp(FrameTime(),lvl,self:GetNWFloat("SmokeLevel",0))

	if(!IsValid(self:GetNWEntity("DangPlayer",nil)) || !self:GetNWEntity("DangPlayer",nil):IsPlayer()) then
		if(lvl < 25) then
			surface.SetDrawColor(Color(46, 204, 113))
		elseif(lvl < 50) then
			surface.SetDrawColor(Color(241, 196, 15))
		elseif(lvl < 75) then
			surface.SetDrawColor(Color(230, 126, 34))
		else
			surface.SetDrawColor(Color(231, 76, 60))
		end

	else
		surface.SetDrawColor(255,75+math.cos(RealTime()*5)*25,75+math.cos(RealTime()*5)*25)
		surface.DrawRect(ScrW()/2-128+8,ScrH()-72+8,256-16,48-16)

		draw.SimpleText("DRUGGED "..self:GetNWEntity("DangPlayer",nil):Nick(),"Trebuchet26",ScrW()/2,ScrH()-59,Color(25,25,25),TEXT_ALIGN_CENTER)
		draw.SimpleText("DRUGGED "..self:GetNWEntity("DangPlayer",nil):Nick(),"Trebuchet26",ScrW()/2,ScrH()-60,Color(235,235,235),TEXT_ALIGN_CENTER)
	end

	if(!IsValid(self:GetNWEntity("DangPlayer",nil)) || !self:GetNWEntity("DangPlayer",nil):IsPlayer()) then
		surface.DrawRect(ScrW()/2-128+8,ScrH()-72+8,(256-16)*(lvl/100),48-16)
		draw.SimpleText("%"..math.Round(lvl),"Trebuchet26",ScrW()/2,ScrH()-59,Color(235,235,235),TEXT_ALIGN_CENTER)
	end

end
