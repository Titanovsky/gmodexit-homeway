
util.AddNetworkString("UpdateBeeper")
util.AddNetworkString("IsBeeping")

net.Receive("IsBeeping",function(l,ply)
  ply.IsBeeping = net.ReadBool()
end)

function DoBeep(ent,msg)
  for k,v in pairs(player.GetAll()) do
    if(IsValid(ent) && table.HasValue(v.Links or {},ent)) then
      net.Start("UpdateBeeper")
      net.WriteString(msg)
      net.Send(v)
    end
  end
end

local meta = FindMetaTable("Player")

function meta:AddLink(ent)
  if(self.Links == nil) then
    self.Links = {}
  end
  if(!table.HasValue(self.Links,ent)) then
    table.insert(self.Links,ent)
    ent:SetNWBool("Linked",true)
  else
    table.RemoveByValue(self.Links,ent)
    ent:SetNWBool("Linked",false)
  end
end
