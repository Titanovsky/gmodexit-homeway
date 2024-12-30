include("shared.lua")
include("blues_slots_config.lua")

surface.CreateFont( "WOL_Dispaly_Large", {
	font = "DSEG14 Modern", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 125,
	weight = 500,
	blursize = 0,
	scanlines = 0, 
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "WOL_Dispaly_Smallest", {
	font = "DSEG14 Modern", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 35,
	weight = 500,
	blursize = 0,
	scanlines = 0, 
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "WOL_Dispaly_Smallest_2", {
	font = "Roboto", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 90,
	weight = 1300,
	blursize = 0,
	scanlines = 0, 
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "WOL_Dispaly_Smallest_3", {
	font = "Roboto", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 25,
	weight = 1300,
	blursize = 0,
	scanlines = 0, 
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local leverPulled = 35 //The degress the lever should move by when pulled.
local leverBoneID = 3 //The bone ID of the lever
local bonusWheelBoneID = 7 //The bone ID of the bonus wheel
local buttonBoneID = 8 //The ID of the bonus button

local bonusWheelSpinTime = 10 //The time in seconds it takes to spin the wheel.

local jackpot = math.random(100,100000000000)

local function comma_value(amount)
 	local formatted = amount
 	while true do  
    	formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    	if (k==0) then
    		break
    	end
  	end
	return formatted
end


//Credit to EmmanuelOga
local function hsvToRgb(h, s, v, a)
	local r, g, b

	local i = math.floor(h * 6);
	local f = h * 6 - i;
	local p = v * (1 - s);
	local q = v * (1 - f * s);
	local t = v * (1 - (1 - f) * s);

	i = i % 6

	if i == 0 then r, g, b = v, t, p
	elseif i == 1 then r, g, b = q, v, p
	elseif i == 2 then r, g, b = p, v, t
	elseif i == 3 then r, g, b = p, q, v
	elseif i == 4 then r, g, b = t, p, v
	elseif i == 5 then r, g, b = v, p, q
	end

	return Color(r * 255, g * 255, b * 255, 255)
end

function ENT:Initialize()
	self.leverAnimating = false

	self.reels = {}
	self.reels[1] = self:GetReelOne()
	self.reels[2] = self:GetReelTwo()
	self.reels[3] = self:GetReelThree()

	self.bonusSound = nil
	self.bonusHue = 0
	self.bonusSoundPlaying = false

	self.jackpotIsPlaying = false
	self.decendingJackpotAmount = 0
	self.previousJackpot = 0

	self.isPlayingButtonAnimation = false

	for i = 1 , 3 do
		self.reels[i]:SetSkin(1)
	end

	self:SetAutomaticFrameAdvance(true)

	self.bonusWheelSpinning = false
	self.bonusWheelPreviousAngle = 0 //The angle before the previous spin
	self.bonusWheelAngle = 0 //In degress the current angle of the wheel.
	self.bonusWheelTarget = 0 //In degress where the wheel should land
	self.faceSinceLastSound = 1 //The face in which it was on when the last sound played, we used this to calculate when the next sound shoudl trigger
	self.timeSinceClickSound = CurTime()
	self.playBounsLights = false
end

function ENT:PlayBonusSound()
	sound.PlayFile( "sound/blues-slots/bonus sound.mp3", "3d", function( station )
		if ( IsValid( station ) ) then 
			self.bonusSound = station
			self.bonusSound:SetPos(self:GetPos())
			self.bonusSound:Set3DFadeDistance( 100, 800 )
			self.bonusSound:SetVolume(0.7)
			station:Play() 
			self.bonusSoundPlaying = true
		end
	end )
end

function ENT:PlayJackpotSound()
	sound.PlayFile( "sound/blues-slots/jackpot_sound.mp3", "3d", function( station )
		if ( IsValid( station ) ) then 
			self.bonusSound = station
			self.bonusSound:SetPos(self:GetPos())
			self.bonusSound:Set3DFadeDistance( 100, 1700 )
			self.bonusSound:SetVolume(1)
			station:Play() 
			self.bonusSoundPlaying = true
		end
	end )
end

//Draws the model and all the infomation displayed on the screens (Cam2D3D)
function ENT:Draw()
	self:DrawModel()

	local ang = self:GetAngles()
	local position = self:GetPos()

	position = position + (ang:Forward() * 27.2)
	position = position + (ang:Up() * 62.7)
	position = position + (ang:Right() * -14)

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 85)

	//Draw the info for the screens
	cam.Start3D2D(position, ang, 0.02)
		//Bonus screen
		draw.SimpleText("~~", "WOL_Dispaly_Smallest", 0, 0, Color(30,30,30,150), 2, 1)
		local spins = self:GetBonusSpins()
		if spins < 10 then
			draw.SimpleText("0"..spins, "WOL_Dispaly_Smallest", 0, 0, Color(220,220,220,255), 2, 1)
		else
			draw.SimpleText(spins, "WOL_Dispaly_Smallest", 0, 0, Color(220,220,220,255), 2, 1)
		end

		//Last Win
		draw.SimpleText("~~~~~~~~", "WOL_Dispaly_Smallest", 19, -230, Color(30,30,30,150), 2, 1)
		local lastWin = self:GetLastWin()
		draw.SimpleText(lastWin, "WOL_Dispaly_Smallest", 19, -230, Color(220,220,220,255), 2, 1)

	cam.End3D2D()	

	ang = self:GetAngles()
	position = self:GetPos()

	position = position + (ang:Forward() * 25.4)
	position = position + (ang:Up() * 90.35)
	position = position + (ang:Right() * -14.3)

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	//Draw the jackpot amount
	cam.Start3D2D(position, ang, 0.02)
		draw.SimpleText("~~~~~~~~~~~~~~", "WOL_Dispaly_Large", 0, 0, Color(30,30,30,150), 2, 1)
		if self.jackpotIsPlaying then
			self.decendingJackpotAmount = Lerp(1 - (timer.TimeLeft(self:EntIndex().."_jackpot") / 42), self.previousJackpot, 0)
			draw.SimpleText(comma_value(math.floor(self.decendingJackpotAmount)), "WOL_Dispaly_Large", 0, 0, Color(255,215,0,255), 2, 1)
		else
			draw.SimpleText(comma_value(self:GetJackpot()), "WOL_Dispaly_Large", 0, 0, Color(255,215,0,255), 2, 1)
		end
	cam.End3D2D()	

	for i = 1 , 20 do
		if i ~= 1 then
			ang = self:GetAngles()
			position = self:GetPos()

			position = position + (ang:Forward() * 21.1)
			position = position + (ang:Up() * 114.35)

			ang:RotateAroundAxis(ang:Up(), 90)
			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(self:GetAngles():Forward(), ((360 / 20) * (i-1)) + 90 + self.bonusWheelAngle)
			//Draw the bonus wheel stuff
			cam.Start3D2D(position, ang, 0.02)
				draw.SimpleText(WOL_CONFIG.currencyIcon..comma_value(WOL_BONUS_ITEMS[i].cash), "WOL_Dispaly_Smallest_2", 590,  -4 , Color(0,0,0,255), 2, 1)
			cam.End3D2D()
		end
	end
end

//Circular lerp instead of just normal lerp
local function LerpAngleCustom(value, start, _end)
    local min = 0.0
    local max = 360.0
    local half = math.abs((max - min) / 2.0)
    local retval = 0.0
    local diff = 0.0

    if ((_end - start) < -half) then
        diff = ((max - start) + _end) * value
        retval = start + diff;
    elseif ((_end - start) > half) then
        diff = -((max - _end) + start) * value
        retval = start + diff;
    else 
    	retval = start + (_end - start) * value
    end

    return retval;
end

//An ease in ease out lerp
local function Hermite(value, start, _end)
    return Lerp(value * value * (3.0 - 2.0 * value), start, _end)
end

function ENT:Think()
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 1000 then
		if self.bonusSound ~= nil then
			self.bonusSound:SetVolume(0.7)
		end
		//Animate the lever
		if self.leverAnimating then
			local totalTime = 1
			local timeLeft = timer.TimeLeft(self:EntIndex().."_leverl_animation") * 2
			local angle = Angle(0,0,0)
			//Opening the lever
			if timeLeft/2 < totalTime / 2 then
				angle.r = Hermite(timeLeft, 0, leverPulled)
			else //now the lever is closing
				angle.r = Hermite(timeLeft-(totalTime), leverPulled, 0)
			end
			self:ManipulateBoneAngles(leverBoneID, angle)
		end

		if self.bonusWheelSpinning then
			self.bonusWheelAngle = Hermite(1 - (timer.TimeLeft(self:EntIndex().."_bonuswheel") / 10), self.bonusWheelPreviousAngle, self.bonusWheelTarget)
			self:ManipulateBoneAngles(bonusWheelBoneID, Angle(0,self.bonusWheelAngle,0))

			//Below is used to calculate the sound of the wheel and if it should click (worked out by seeing witch wedge it is on and if its the next wedge play the sound)
			local normAngle = (self.bonusWheelAngle - 9) % 360
			if normAngle < 0 then normAngle = normAngle + 360 end

			local currentFace = math.floor(normAngle / 18)

			if currentFace ~= self.faceSinceLastSound then
				self.faceSinceLastSound = currentFace
				if CurTime() - self.timeSinceClickSound >= 0.02 then
					EmitSound("blues-slots/bonus_click.ogg", self:GetPos() + Vector(0,0,75), self:EntIndex(), CHAN_AUTO, 0.9, 60, 0, math.random(100,108))
					self.timeSinceClickSound = CurTime()
				end
			end
		end

		if self.playBounsLights then
			local color = hsvToRgb(self.bonusHue % 360, 0.5, 1)
			local dlight = DynamicLight(self:EntIndex())
			if ( dlight ) then
				dlight.pos = self:GetPos() + Vector(0,0,100) + (self:GetAngles():Forward() * 40)
				dlight.r = color.r
				dlight.g = color.g
				dlight.b = color.b
				dlight.brightness = 3
				dlight.Decay = 1000
				dlight.Size = 256
				dlight.DieTime = CurTime() + 1
			end
			self.bonusHue = self.bonusHue + (1 * FrameTime())
			debugoverlay.Sphere(self:GetPos() + Vector(0,0,75) + (self:GetAngles():Forward() * 35), 25, 1)
		else
			if self.bonusSound ~= nil and not self.bonusSoundPlaying then
				self.bonusSound:Stop()
				self.bonusSound = nil
			end
		end
	else
		if self.bonusSound ~= nil then
			self.bonusSound:SetVolume(0)
		end
	end
end

//Spins all the wheels
function ENT:SpinReels()
	for k ,v in pairs(self.reels) do
		v:Spin()
	end
end

//Spins the bonus wheel up top
function ENT:SpinBonusWheel(targetItem)
	targetItem = 360 - (18 * (targetItem - 1))
	self.bonusWheelSpinning = true
	self.bonusWheelTarget = targetItem + (360 * 5) //Spin around 4 time before stopping.
	timer.Create(self:EntIndex().."_bonuswheel", bonusWheelSpinTime, 1, function()
		self.bonusWheelSpinning = false
		self.bonusWheelPreviousAngle = self.bonusWheelAngle % 360
	end)
end

//Stops the the reel using that index at the item that you set it to
function ENT:StopReel(reelIndex, itemIndex)
	self.reels[reelIndex]:StopReel(itemIndex)
end

//Triggers the lever animation to start.
function ENT:TriggerLeverAnimation()
	self.leverAnimating = true
	timer.Create(self:EntIndex().."_leverl_animation", 1, 1, function()
		self.leverAnimating = false
	end)
end

//Makes the machine flash pretty lights
function ENT:Flash()
	for k, v in pairs(self.reels) do
		v:Flash()
	end
end

local payTableMaterial = Material("materials/wol_ui/paytable.png")
local function CreatePayTableUI()
	local f = vgui.Create("DFrame")
	f:SetSize(700, 500)
	f:Center()
	f:SetDraggable(false)
	f:SetTitle("")
	f.Paint = function(s, w, h)
		surface.SetMaterial(payTableMaterial)
		surface.SetDrawColor(Color(255,255,255))
		surface.DrawTexturedRect(0,0,w,h)

		//draw all the payouts for the items
		draw.SimpleText(WOL_CONFIG.currencyIcon..comma_value(WOL_CONFIG.winning.threeBonus), "WOL_Dispaly_Smallest_3", 220,200,Color(40,40,40,255), 0, 1)

		draw.SimpleText(WOL_CONFIG.currencyIcon..comma_value(WOL_CONFIG.winning.twoBonus), "WOL_Dispaly_Smallest_3", 220,238,Color(40,40,40,255), 0, 1)

		draw.SimpleText(WOL_CONFIG.currencyIcon..comma_value(WOL_CONFIG.winning.oneBonus), "WOL_Dispaly_Smallest_3", 220,238 + 46,Color(40,40,40,255), 0, 1)

		draw.SimpleText(WOL_CONFIG.currencyIcon..comma_value(WOL_CONFIG.winning.threeRaspberry), "WOL_Dispaly_Smallest_3", 220,238 + 46 + 50,Color(40,40,40,255), 0, 1)

		draw.SimpleText(WOL_CONFIG.currencyIcon..comma_value(WOL_CONFIG.winning.threeCoins), "WOL_Dispaly_Smallest_3", 220,238 + 46 + 50 + 50,Color(40,40,40,255), 0, 1)

		draw.SimpleText(WOL_CONFIG.currencyIcon..comma_value(WOL_CONFIG.winning.twoCoins), "WOL_Dispaly_Smallest_3", 220,238 + 46 + 50 + 50 + 50,Color(40,40,40,255), 0, 1)


		draw.SimpleText(WOL_CONFIG.currencyIcon..comma_value(WOL_CONFIG.winning.threeBar2), "WOL_Dispaly_Smallest_3", 220 + 365,200,Color(40,40,40,255), 0, 1)

		draw.SimpleText(WOL_CONFIG.currencyIcon..comma_value(WOL_CONFIG.winning.threeBar), "WOL_Dispaly_Smallest_3", 220+ 365,238,Color(40,40,40,255), 0, 1)

		draw.SimpleText(WOL_CONFIG.currencyIcon..comma_value(WOL_CONFIG.winning.threeSeven), "WOL_Dispaly_Smallest_3", 220+ 365,238 + 40,Color(40,40,40,255), 0, 1)

		draw.SimpleText(WOL_CONFIG.currencyIcon..comma_value(WOL_CONFIG.winning.threeDiamonds), "WOL_Dispaly_Smallest_3", 220+ 365,238 + 46 + 56,Color(40,40,40,255), 0, 1)

		draw.SimpleText(WOL_CONFIG.currencyIcon..comma_value(WOL_CONFIG.winning.twoDiamonds), "WOL_Dispaly_Smallest_3", 220+ 365,238 + 46 + 50 + 52,Color(40,40,40,255), 0, 1)

		draw.SimpleText(WOL_CONFIG.currencyIcon..comma_value(WOL_CONFIG.winning.oneDiamonds), "WOL_Dispaly_Smallest_3", 220+ 365,238 + 46 + 50 + 50 + 46,Color(40,40,40,255), 0, 1)

		//Price per spin

		draw.SimpleText(WOL_CONFIG.currencyIcon..comma_value(WOL_CONFIG.pricePerSpin), "WOL_Dispaly_Smallest_3", 212,238 + 46 + 50 + 50 + 50 + 48,Color(40,40,40,255), 0, 1)
	end
	f:MakePopup()
end


//Networking below here

net.Receive("WOL_OpenPayTable", function()
	CreatePayTableUI()
end)


//Triggers a spin to start
net.Receive("WOL_BeginSpin", function()
	local e = net.ReadEntity()
	if e.SpinReels ~= nil then
		e:SpinReels()
	end
end)


net.Receive("WOL_BeginBonusSpin", function()
	local e = net.ReadEntity()
	if e.SpinBonusWheel ~= nil then
		e:SpinBonusWheel(net.ReadInt(16))
		e:ResetSequence(1)
		e:SetCycle(0)
		e:SetPlaybackRate(1)
		timer.Simple(3, function()
			e:ResetSequence(0)
			e:SetCycle(0)
		end)
	end
end)

//Triggers the lever to animate
net.Receive("WOL_TriggerLever" , function()
	local e = net.ReadEntity()
	if e.TriggerLeverAnimation ~= nil then
		e:TriggerLeverAnimation()
	end
end)

//Just stops the reel the server requested.
net.Receive("WOL_StopReel", function()
	local index = net.ReadInt(6)
	local itemIndex = net.ReadInt(7)
	local entity = net.ReadEntity()

	if entity.StopReel ~= nil then
		entity:StopReel(index, itemIndex)
	end
end)

//Casuses lights around the machine to flash (Generally used when you win something.)
net.Receive("WOL_FlashLights", function()
	local e = net.ReadEntity()
	if e.reels ~= nil then
		local winningReels = net.ReadTable()
		for k, v in pairs(winningReels) do
			if v then
				e.reels[k]:Flash()
			end
		end
	end
end)

//I guess start flashing at the bonus sound que
net.Receive("WOL_BonusSound", function()
	local e = net.ReadEntity()
	if e.PlayBonusSound ~= nil then
		local doWhat = net.ReadBool()
		if doWhat then
			e:PlayBonusSound()
			timer.Simple(1.66, function()
				e.playBounsLights = true
				e.reels[1].targetSkin = 3 
				e.reels[1]:SetSkin(3)
				e.reels[2].targetSkin = 1
				e.reels[2]:SetSkin(1)
				e.reels[3].targetSkin = 3
				e.reels[3]:SetSkin(3)
				timer.Create(e:EntIndex().."_bonuslights", 0.476, 0, function()
					if e.playBounsLights then
						for k ,v in pairs(e.reels) do 
							if v:GetSkin() ~= 1 then
								v:SetSkin(1)
								v.targetSkin = 1
							else
								v:SetSkin(3)	
								v.targetSkin = 3
							end
						end
					else
						timer.Remove(e:EntIndex().."_bonuslights")
						for k ,v in pairs(e.reels) do
							v:SetSkin(1)
							v.targetSkin = 1
						end
					end
				end)
			end)
		else
			e.playBounsLights = false
			timer.Remove(e:EntIndex().."_bonuslights")
			for k ,v in pairs(e.reels) do
				v:SetSkin(1)
				v.targetSkin = 1
			end
			e.bonusSoundPlaying = false
		end
	end
end)

//Lets trigger the jackpot
net.Receive("WOL_TriggerJackpot" , function()
	local e = net.ReadEntity()
	local doWhat = net.ReadBool()
	if e.PlayJackpotSound ~= nil then
		if doWhat then
			e:PlayJackpotSound()
			e.decendingJackpotAmount = e:GetJackpot()
			e.previousJackpot = e:GetJackpot()
			for k ,v in pairs(e.reels) do 
				v:SetSkin(1)
				v.targetSkin = 1
			end
			timer.Simple(2.28, function()
				e.jackpotIsPlaying = true
				timer.Create(e:EntIndex().."_jackpot", 42, 1 , function()
					e.jackpotIsPlaying = false
					e.decendingJackpotAmount = 0
				end)
				e.playBounsLights = true
				e.reels[1].targetSkin = 3 
				e.reels[1]:SetSkin(3)
				e.reels[2].targetSkin = 1
				e.reels[2]:SetSkin(1)
				e.reels[3].targetSkin = 3
				e.reels[3]:SetSkin(3)
				timer.Create(e:EntIndex().."_jackpotMoney", 0.348 * 2, 0, function()
					e:StopParticleEmission()
					ParticleEffectAttach("wol_money_burst01",PATTACH_POINT_FOLLOW,e,0)
				end)

				timer.Create(e:EntIndex().."_bonuslights", 0.348, 0, function()
					if e.playBounsLights then
						for k ,v in pairs(e.reels) do 
							if v:GetSkin() ~= 1 then
								v:SetSkin(1)
								v.targetSkin = 1
							else
								v:SetSkin(3)	
								v.targetSkin = 3
							end
						end
					else
						timer.Remove(e:EntIndex().."_bonuslights")
						for k ,v in pairs(e.reels) do
							v:SetSkin(1)
							v.targetSkin = 1
						end
					end
				end)
			end)
		else
			e.playBounsLights = false
			timer.Remove(e:EntIndex().."_bonuslights")
			timer.Remove(e:EntIndex().."_jackpotMoney")
			for k ,v in pairs(e.reels) do
				v:SetSkin(1)
				v.targetSkin = 1
			end
			e.bonusSoundPlaying = false
			e.jackpotIsPlaying = false
		end
	end
end)