
local ply = FindMetaTable("Player")

local w = 0
local real = 0
net.Receive("UpdateWeedState",function()
	w = net.ReadInt(16)
end)

function ply:GetWeed()
	if(math.abs(real-w) < 1) then
		w = Lerp(FrameTime()*2,w,self:GetNWFloat("WeedLevel",0))
		return w
	else
		real = Lerp(FrameTime()*2,real,w)
		return real
	end
	return 0
end

local def = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}
local mod = {}
local pix = 1


hook.Add("RenderScreenspaceEffects","DrawWeed",function()
	if(LocalPlayer():GetWeed() > 0) then
		local w = LocalPlayer():GetWeed()
		if(FrameNumber()%30 == 0) then
			render.CapturePixels()
			pix = render.ReadPixel(ScrW()/2,ScrH()/2)
		end

		local pow = pix/50
		mod = {
			["$pp_colour_addr"] = math.Clamp(math.tan(0.1*w*RealTime())*0.01*pow,0,.1),
			["$pp_colour_addg"] = math.Clamp(math.cos(0.1*w*RealTime())*0.01*pow,0,0.25),
			["$pp_colour_addb"] = math.Clamp(math.sin(0.1*w*RealTime())*0.01*pow,0,0.3),
			["$pp_colour_brightness"] = math.abs(math.cos(RealTime()*w*0.1*0.25)*0.1),
			["$pp_colour_contrast"] = 1,
			["$pp_colour_colour"] = 1+math.cos(w*0.1*RealTime())*(0.1*w/50),
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		}
		DrawColorModify( mod )
		DrawMotionBlur( 0.8-0.6*(math.Clamp(w,0,100)/100), math.Clamp((math.Clamp(w,0,100)/100)*0.8*2,0,1), 0.01+(math.Clamp(w,0,100)/5000) )
	end
end)


hook.Add("CalcView","DistorTView",function(ply, pos, angles, fov )
	if(LocalPlayer():GetWeed() > 0) then
		w = LocalPlayer():GetWeed()
		local tr = LocalPlayer():GetEyeTrace().HitPos
		local nfov = math.Clamp(math.sqrt(tr:Distance(ply:GetPos()))*10,50,100) + math.cos(RealTime()*0.5)*(w*0.3)
		local view = {}
		view.origin = pos
		view.angles = angles + Angle(math.sin(math.ceil(w/25)*RealTime())*4,0,math.cos(math.ceil(w/25)*RealTime())*6)
		view.fov = nfov

		return view
	end
end)

hook.Add("EntityEmitSound","SoundWanna",function(t)
	if(isfunction(LocalPlayer().GetWeed) && LocalPlayer():GetWeed() > 0) then
		local w = LocalPlayer():GetWeed()
		local p = t.Pitch
		t.Pitch = math.Clamp( t.Pitch * (1 - ((w*0.75)/100)), 100, 255 )
		return true
	end
end)

local msg = {"vo/npc/male01/doingsomething.wav","vo/npc/male01/gordead_ans01.wav",
"vo/npc/male01/holddownspot01.wav","vo/npc/male01/question04.wav",
"vo/npc/male01/question09.wav","vo/npc/male01/question12.wav",
"vo/npc/male01/question17.wav","vo/npc/male01/question18.wav",
"vo/npc/male01/question19.wav","vo/npc/male01/question27.wav",
"vo/npc/male01/whoops01.wav","vo/npc/male01/waitingsomebody.wav"}

hook.Add("Think","DrugThink",function()
	if(LocalPlayer():GetWeed() > 0) then
		if((LocalPlayer().NextMsg or 0) < CurTime()) then
			LocalPlayer():SetDSP(50)
			LocalPlayer():EmitSound(table.Random(msg),100,150)
			LocalPlayer():SetDSP(1)
			LocalPlayer().NextMsg = CurTime() + math.random(10,30)
		end
	end
end)
