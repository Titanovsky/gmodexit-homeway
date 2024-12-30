ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.AutomaticFrameAdvance = true

AddCSLuaFile()

function ENT:Initialize( )

	self:SetModel( "models/player/monk.mdl" )

	if SERVER then
		self:SetHullType( HULL_HUMAN )
		self:SetHullSizeNormal( )
		self:SetNPCState( NPC_STATE_SCRIPT )
		self:SetSolid(  SOLID_BBOX )
		self:CapabilitiesAdd( CAP_ANIMATEDFACE )
		self:CapabilitiesAdd( CAP_TURN_HEAD )
		self:SetUseType( SIMPLE_USE )
		self:DropToFloor()

		self:SetMaxYawSpeed( 90 )
	end

end

function ENT:Think()
  if(self.DoAttack == nil) then
	  self:ResetSequence("menu_combine")
	  self:SetSequence("menu_combine")
	  self:NextThink(CurTime()+self:SequenceDuration())
	  return true
  else
    self:ResetSequence("pose_standing_01")
	  self:SetSequence("pose_standing_01")
	  self:NextThink(CurTime()+self:SequenceDuration())
	  return true
  end
  self:SetPoseParameter("pose_x",CurTime()%1)
end

local a

if SERVER then
  util.AddNetworkString("CreateDealer")
  util.AddNetworkString("SendDealerInfo")
  util.AddNetworkString("CallDealer")
  util.AddNetworkString("DoDealerDeliver")
end


function ENT:AcceptInput( Name, Activator, Caller )
	if Name == "Use" and Caller:IsPlayer() then
		net.Start("CallDealer")
		net.Send(Caller)
    if(!WEED_CONFIG:CanDeal(Caller)) then
      self:ResetSequence("pose_standing_01")
      self:SetSequence("pose_standing_01")
      self.DoAttack = self:SequenceDuration()
      timer.Simple(self.DoAttack,function() self.DoAttack = nil end)
    end
	end
end

ENT.Notified = false

local lns = {"Псс...чел, не хочешь дурь?",
"Я смотрю, ты хочешь развлечься?",
"Хей, дури хочешь?",
"Иди ко мне, я покажу тебе кое-что!",
"Ты не из полиции? Тогда ко мне!"}

function ENT:GetPlayerColor()
  if(!self.Notified) then
    if(LocalPlayer():GetPos():Distance(self:GetPos()) < 1024)  then
      self.TR = util.TraceLine( {
	      start = self:EyePos(),
      endpos = LocalPlayer():EyePos() + (self:EyePos()-LocalPlayer():EyePos())*-0.4,
	     filter = self
     } )
      if(self.TR.Entity == LocalPlayer()) then
        chat.AddText(Color(155, 89, 182),"[ДИЛЕР] ",Color(235,235,235),lns[math.random(1,#lns)])
        self.Notified = true
        self.TR = nil
      end
    end
  end
	return Vector(1,0.2,1)
end

concommand.Add("create_dealer",function(ply)
	if(ply:IsAdmin()) then
		net.Start("CreateDealer")
		net.SendToServer()
	end
end)

--[[
net.Receive("CreateDealer",function(l,ply)
	if(ply:IsAdmin()) then
		local tbl = {}
		if(file.Exists(game.GetMap().."_dealers.txt","DATA")) then
			tbl = util.JSONToTable(file.Read(game.GetMap().."_dealers.txt","DATA"))
		end
		table.insert(tbl,{ply:GetPos(),ply:GetAngles().y})
		file.Write(game.GetMap().."_dealers.txt",util.TableToJSON(tbl,true))
    	DarkRP.notify(ply, 3, 3, "Dealer created, check console for instructions!")
    	net.Start("SendDealerInfo")
    	net.Send(ply)
	end
end)

net.Receive("SendDealerInfo",function()
  MsgN("Copy data/"..(game.GetMap().."_dealers.txt").." file into your server once you placed all dealers!")
end)

hook.Add("InitPostEntity","CreateQuests",function()

	if CLIENT then return end

	_weedDebug("Initialize ran from the server, this is good")

	local tbl = {}
	if(file.Exists(game.GetMap().."_dealers.txt","DATA")) then
		tbl = util.JSONToTable(file.Read(game.GetMap().."_dealers.txt","DATA"))
	end
	_weedDebug("We got the table, we have "..#tbl.." dealers in the map")
	for k,v in pairs(tbl) do
		local ent = ents.Create("npc_drug_dealer")
		ent:SetPos(v[1])
		ent:SetAngles(Angle(0,v[2],0))
		ent:Spawn()
		_weedDebug("Dealer spawned. "..Either(util.IsInWorld(ent:GetPos()),"It's","It's not").." in the world")
	end
end)
--]]

net.Receive("DoDealerDeliver",function(l,ply)
	local b = net.ReadBool()

	if((!b && ply:HasWeapon("sent_tablet")) || (b && ply:HasWeapon("sent_bong"))) then
		DarkRP.notify(ply, 1, 3, "У вас уже есть этот предмет!")
		return
	end

	if(!b && ply:getDarkRPVar("money")>=WEED_CONFIG.TabletPrice) then
		DarkRP.notify(ply, 3, 3, "Вы купили планшет за $"..(WEED_CONFIG.TabletPrice or 0))
		ply:addMoney(-WEED_CONFIG.TabletPrice)
		ply:Give("sent_tablet")
	end

	if(b && ply:getDarkRPVar("money")>=WEED_ITEMS.Items["Tools"]["bong"].price) then
		DarkRP.notify(ply, 3, 3, "Вы купили бонг за $"..(WEED_ITEMS.Items["Tools"]["bong"].price or 0))
		ply:addMoney(-WEED_ITEMS.Items["Tools"]["bong"].price)
		ply:Give("sent_bong")
	end
end)

if CLIENT then

local pnl

surface.CreateFont("Trebuchet24", {
	font = "Trebuchet MS",
	size = 24,
	weight = 900
})

local rpl = {"школьник, иди гуляй!",
"Что тебе надо от меня? Уходи!",
"У меня нет ничего нелегального, теперь можешь уйти?",
"Если не уйдешь, я вызову полицию, понятно?!",
"ПОШЁЛ ВОН, УРОД!"}

net.Receive("CallDealer",function(l,ply)
	local a,b = table.Random(rpl)
  	if(!WEED_CONFIG:CanDeal(LocalPlayer())) then
    	chat.AddText(Color(155, 89, 182),"[ДИЛЕР] ",Color(235,235,235),a)
    	return
  	end

	if(pnl != nil) then
		pnl:Remove()
		pnl = nil
	end
	pnl = vgui.Create("gDealer")
	pnl:MakePopup()

end)

end
