include("shared.lua")

function ENT:Initialize()

	self.targetSkin = 1
	self.isSpinning = false
	self.reelangle = Angle(0,0,0)
	self.targetAngle = Angle(0,0,0)
	self:SetColor(Color(180,180,180,255))
end

function ENT:Draw()
	self:DrawModel()
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
		if self.isSpinning then
			//Spin the wheel if its spinning
			self.reelangle:RotateAroundAxis(Vector(0,1,0), 850 * FrameTime())
			self:SetLocalAngles(self.reelangle)
			self.isSpinning = true
		else
			//Lerp to the correct possition of it (To compensate for the bounce effect :D)					
			self.reelangle.p = LerpAngleCustom(10 * FrameTime(), self.reelangle.p, self.targetAngle.p)
			self:SetLocalAngles(self.reelangle)
		end
		if self:GetSkin() ~= self.targetSkin then
			self:SetSkin(self.targetSkin)
		end
	end
end

//Spins all the wheels
function ENT:Spin()
	self.isSpinning = true
	self:SetSkin(2)
	self.targetSkin = 2
end

//Makes the lights flash.
function ENT:Flash()
	self:SetSkin(3)
	self.targetSkin = 3
	timer.Simple(0.12, function()
		self:SetSkin(1)
		self.targetSkin = 1
		timer.Simple(0.12, function()
			self:SetSkin(3)
			self.targetSkin = 3
			timer.Simple(0.12, function()
				self:SetSkin(1)
				self.targetSkin = 1
			end)
		end)
	end)
end

//Stops the the reel using that index at the item that you set it to
function ENT:StopReel(itemIndex)
	//The target amount that we want to go for?
	local targetAmount = -(45 * (itemIndex - 1))

	self.targetAngle  = Angle(targetAmount, 0, 0)
	self.reelangle = Angle(targetAmount + 30, 0, 0)
	self:SetLocalAngles(self.reelangle)
	//Stop the wheel from spinning
	self.isSpinning = false
	self:SetSkin(1)
	self.targetSkin = 1
end