
WEED_ITEMS = {}

WEED_ITEMS.__index = __index
WEED_ITEMS.Items = {}

if SERVER then
  util.AddNetworkString("PurchaseItem")
end

function WEED_ITEMS:Add(item,data)
  if(self.Items[data.category or "Pots"] == nil) then
    self.Items[data.category or "Pots"] = {}
  end
  self.Items[data.category or "Pots"][item] = data
end

function WEED_ITEMS:Purchase(who,item)
  local f = false
  _weedDebug("Purchase started")
  if(item == "Beeper") then
    if(who:getDarkRPVar("money") >= WEED_CONFIG.BeeperPrice) then
      who:SetNWBool("HasBeeper",true)
      who:addMoney(-WEED_CONFIG.BeeperPrice)
      DarkRP.notify(who, 3, 3, "You bought the beeper at $"..WEED_CONFIG.BeeperPrice)
    end
    return
  end
  for k,v in pairs(self.Items) do
    for a,j in pairs(v) do
      if(a==item) then
        if(who:getDarkRPVar("money") >= j.price) then
          if(WEED_CONFIG.UseGroupData && (j.max or 0) > 0) then
              for k,v in pairs(WEED_CONFIG.GroupData) do
                  if(k==who:GetUserGroup()) then
                      if(who.Pots == nil) then
                          who.Pots = {}
                      end
                      if(who.Pots[a] == nil) then
                          who.Pots[a] = 1
                      else
                          if(who.Pots[a] < (j.max or 0)*v) then
                              who.Pots[a] = who.Pots[a] + 1

                          else
                            DarkRP.notify(who, 1, 3, "You already hit this item limit")
                            return
                        end
                      end
                  end
              end
          end
          if(j.ent != nil) then

            local trace = {}
            trace.start = who:EyePos()
            trace.endpos = trace.start + who:GetAimVector() * 85
            trace.filter = who

            local tr = util.TraceLine(trace)

            _weedDebug("Enitty "..j.ent.." has been created")
            local ent = ents.Create(j.ent)
            ent:SetPos(tr.HitPos)
            ent:SetAngles(Angle(0,who:EyeAngles().y,0))
            ent:Spawn()
            ent.SID = who.SID
            if(ent.Setowning_ent) then
                ent:Setowning_ent(who)
            end
            ent:CPPISetOwner(who)
            ent.Owner = who
            ent.cls = a
            if(isfunction(j.purchase)) then
              j:purchase(ent)
            end
          end
          if(j.wep != nil) then
            if(!who:HasWeapon(j.wep)) then
              who:Give(j.wep)
            else
              DarkRP.notify(who, 1, 3, "У вас уже есть этот предмет!")
              return
            end
          end
          who:addMoney(-j.price)
          DarkRP.notify(who, 3, 3, "Вы купили "..j.name.." за "..j.price)
          _weedDebug("Money deduced")
        end
        f = true
        break
      end
      if(f) then
        break
      end
    end
  end
end

if SERVER then
hook.Add("EntityRemoved","RemovePotPetition",function(ent)
    if(ent.Owner != nil) then
        if(ent.Owner.Pots != nil && ent.Owner.Pots[ent.cls or ""] != nil) then
            ent.Owner.Pots[ent.cls or ""] = ent.Owner.Pots[ent.cls or ""] - 1
        end
    end
end)


end

net.Receive("PurchaseItem",function(l,ply)
  WEED_ITEMS:Purchase(ply,net.ReadString())
end)


WEED_ITEMS:Add("base_seed",{name="Amnesia Haze",
category="Seeds",
description="Amnesia Haze seeds from Gonzo Seeds, you’ll be able to produce some amazing plants that taste great",
price=19,
ent="sent_seed",
purchase=function(_,ent) ent:SetSeed(1) end,
draw=function(_,ent,b)
  ent:SetMaterial("models/gonzo/weed/weed")
  b:SetColor(Color(150,200,150))
end,
model="models/props_junk/watermelon01.mdl",
max=5})

WEED_ITEMS:Add("base_seed3",{name="Amnesia Haze (Bulk)",
category="Seeds",
description="Amnesia Haze seeds package",
price=75,
ent="sent_seed",
purchase=function(_,ent) ent:SetSeed(1)
    for k=1,2 do
        local a = ents.Create("sent_seed")
        a:SetPos(ent:GetPos() + ent:GetUp()*24*k)
        a:Spawn()
        a:CPPISetOwner(ent.Owner)
        a:SetSeed(1)
    end
end,
draw=function(_,ent,b)
  ent:SetMaterial("models/gonzo/weed/weed")
  b:SetColor(Color(150,200,150))
end,
model="models/props_junk/watermelon01.mdl",
max=5})

WEED_ITEMS:Add("water_seed",{name="Bubble Kush",
category="Seeds",
description="Cool seed! But you'll need a lot water to maintain this seed. Although, you'll get some awesome kush!",
price=45,
ent="sent_seed",
purchase=function(_,ent) ent:SetSeed(2) end,
draw=function(_,ent,b)
  ent:SetMaterial("models/gonzo/weed/weed")
  b:SetColor(Color(255,175,100))
end,
model="models/props_junk/watermelon01.mdl",
max=5})

WEED_ITEMS:Add("water_seed3",{name="Bubble Kush (Bulk)",
category="Seeds",
description="Bubble Kush seeds package",
price=40*3,
ent="sent_seed",
purchase=function(_,ent) ent:SetSeed(2)
    for k=1,2 do
        local a = ents.Create("sent_seed")
        a:SetPos(ent:GetPos() + ent:GetUp()*24*k)
        a:Spawn()
        a:CPPISetOwner(ent.Owner)
        a:SetSeed(2)
    end
end,
draw=function(_,ent,b)
  ent:SetMaterial("models/gonzo/weed/weed")
  b:SetColor(Color(255,175,75))
end,
model="models/props_junk/watermelon01.mdl",
max=5})

WEED_ITEMS:Add("elder_seed",{name="O.G. Kush",
category="Seeds",
description="This seed takes much more time to grow, but DAMN! You'll get the best weed ever, bro!",
price=75,
ent="sent_seed",
purchase=function(_,ent) ent:SetSeed(3) end,
draw=function(_,ent,b)
  ent:SetMaterial("models/gonzo/weed/weed")
  b:SetColor(Color(25,75,25)) end,
model="models/props_junk/watermelon01.mdl",
max=5})

WEED_ITEMS:Add("elder_seed3",{name="O.G. Kush (Bulk)",
category="Seeds",
description="O.G. Kush seeds package",
price=65*3,
ent="sent_seed",
purchase=function(_,ent) ent:SetSeed(3)
    for k=1,2 do
        local a = ents.Create("sent_seed")
        a:SetPos(ent:GetPos() + ent:GetUp()*24*k)
        a:Spawn()
        a:CPPISetOwner(ent.Owner)
        a:SetSeed(3)
    end
end,
draw=function(_,ent,b)
  ent:SetMaterial("models/gonzo/weed/weed")
  b:SetColor(Color(25,75,25))
end,
model="models/props_junk/watermelon01.mdl",
max=5})
WEED_ITEMS:Add("quick_seed",{name="Haze Berry",
category="Seeds",
description="Are you lazy? Sell this for some easy money!",
price=50,
ent="sent_seed",
purchase=function(_,ent) ent:SetSeed(4) end,
draw=function(_,ent,b)
  ent:SetMaterial("models/gonzo/weed/weed")
  b:SetColor(Color(255,75,255)) end,
model="models/props_junk/watermelon01.mdl",
max=5})

WEED_ITEMS:Add("quick_seed3",{name="Haze Berry (Bulk)",
category="Seeds",
description="Quick seeds package",
price=40*3,
ent="sent_seed",
purchase=function(_,ent) ent:SetSeed(4)
    for k=1,2 do
        local a = ents.Create("sent_seed")
        a:SetPos(ent:GetPos() + ent:GetUp()*24*k)
        a:Spawn()
        a:CPPISetOwner(ent.Owner)
        a:SetSeed(4)
    end
end,
draw=function(_,ent,b)
  ent:SetMaterial("models/gonzo/weed/weed")
  b:SetColor(Color(255,75,255))
end,
model="models/props_junk/watermelon01.mdl",
max=5})

--------------------------------------------------------------------------------

WEED_ITEMS:Add("plastic_pot",{name="Ведро",
category="Pots",
description="Looks like a regular paint bucket, but a plant could easily grow here!",
price=30,
ispot = true,
ent="sent_pot",
purchase=function(_,ent) ent:SetPot(2) end,
model="models/gonzo/weedb/pot2.mdl",
max=7})

WEED_ITEMS:Add("stone_pot",{name="Сломанный горшок",
category="Pots",
description="Very sturdy and can retain a lot more water!",
price=50,
ispot = true,
ent="sent_pot",
purchase=function(_,ent) ent:SetPot(1) end,
model="models/gonzo/weedb/pot1.mdl",
max=7})

WEED_ITEMS:Add("cool_pot",{name="Цветочный горшок",
category="Pots",
description="This is a great vessel to grow your weed in!",
price=100,
ispot = true,
ent="sent_pot",
purchase=function(_,ent) ent:SetPot(3) end,
model="models/gonzo/weedb/pot3.mdl",
max=7})

WEED_ITEMS:Add("extra_pot",{name="Ванна",
category="Pots",
description="Need to grow 3 plants at once? No problem, here's my deal.",
price=250,
ispot = true,
ent="sent_pot",
purchase=function(_,ent) ent:SetPot(4) end,
model="models/gonzo/weedb/pot4.mdl",
max=4})

-----------------------------------------------------------------------

WEED_ITEMS:Add("battery_simple",{name="Одноразовая батарея",
category="Energy",
description="Do you need a quick and disposable energy source? Try this One-Use Battery!",
price=100,
ent="sent_battery",
purchase=function(_,ent) ent:SetBattery(1) end,
model="models/gonzo/weedb/battery.mdl",
max=6})

WEED_ITEMS:Add("battery_rechargeable",{name="Многоразовая батарея",
category="Energy",
description="Do you need to continue your production? Grab a rechargeable lithium battery.",
price=200,
ent="sent_battery",
purchase=function(_,ent) ent:SetBattery(2) end,
model="models/gonzo/weedb/battery.mdl",
max=3})

WEED_ITEMS:Add("charger",{name="Зарядка для батарей",
category="Energy",
description="Recharge your batteries with this device! *WARNING! You can only recharge up to 20 batteries before this device expires*",
price=400,
ent="sent_charger",
model="models/gonzo/weedb/charger.mdl",
max=6})

-----------------------------------------------------------------------

WEED_ITEMS:Add("lamp_base",{name="Лампа",
category="Lighting",
description="Do you need a lamp to keep your plants warm? No problem! This lamp emits warmth in a cone in front of it.",
price=250,
ent="sent_light",
purchase=function(_,ent) ent:SetLight(1) end,
model="models/gonzo/weedb/lamp.mdl",
max=6})

WEED_ITEMS:Add("lamp_radial",{name="Радиальная лампа",
category="Lighting",
description="Do you need a lamp to keep your plants warm? No problem! This lamp emits warmth in a grid around it.",
price=400,
ent="sent_light",
purchase=function(_,ent) ent:SetLight(2) end,
model="models/gonzo/weedb/lamp2.mdl",
max=6})

-----------------------------------------------------------------------

WEED_ITEMS:Add("water_pot",{name="Водолейка",
category="Water",
description="Keep your growing plants hydrated with this basic watering can!",
price=40,
ent="sent_water_pot",
purchase=function(_,ent) ent:SetWater(1) end,
model="models/gonzo/weedb/water_pot.mdl",
max=8})

WEED_ITEMS:Add("water_shower",{name="Душ",
category="Water",
description="Water your Multiple Pots without any effort!",
price=200,
ent="sent_water_pot",
purchase=function(_,ent) ent:SetWater(2) end,
model="models/gonzo/weedb/shower.mdl",
max=5})

WEED_ITEMS:Add("water_tank",{name="Цистерна",
category="Water",
description="Extract water from the floor! You can extract up to "..WEED_CONFIG.WaterSourceBuckets.." watering cans!",
price=400,
ent="sent_water_tank",
model="models/gonzo/weedb/water_source.mdl",
max=4})

WEED_ITEMS:Add("water_supply",{name="Водная подача",
category="Water",
description="Recharge showers, 3 charges",
price=200,
ent="sent_water_loader",
model="models/props_c17/canister01a.mdl",
max=3})

-----------------------------------------------------------------------

WEED_ITEMS:Add("base_soil",{name="Почва",
category="Soil",
description="Makes your seed grow strong and healthy!",
price=100,
purchase=function(_,ent) ent:SetSoil(1) end,
ent="sent_soil",
model="models/gonzo/weedb/Soil_bag.mdl",
max=5})

WEED_ITEMS:Add("acid_soil",{name="Окислённая почва",
category="Soil",
description="Your weed will grow faster, but this will require more water than usual.",
price=200,
purchase=function(_,ent) ent:SetSoil(2) end,
draw=function(_,ent) ent:SetSkin(1) end,
ent="sent_soil",
model="models/gonzo/weedb/Soil_bag.mdl",
max=5})

WEED_ITEMS:Add("soft_soil",{name="Мокрая почва",
category="Soil",
description="Your weed will grow slower, but forget about watering your plant once you fill the pot!",
price=300,
purchase=function(_,ent) ent:SetSoil(3) end,
draw=function(_,ent) ent:SetSkin(2) end,
ent="sent_soil",
model="models/gonzo/weedb/Soil_bag.mdl",
max=5})

-----------------------------------------------------------------------

WEED_ITEMS:Add("bong",{name="Бонг",
category="Tools",
description="Smoke your weed with this crazy ass bong!",
price=500,
wep="sent_bong",
model="models/weapons/w_bong.mdl"})

WEED_ITEMS:Add("messure",{name="Измеритель",
category="Tools",
description="Watch your plant health and water level, useful to check with precision your love",
price=350,
wep="sent_messure",
model="models/weapons/w_messure.mdl"})

WEED_ITEMS:Add("magazine",{name="Учебник по выращиванию травки",
category="Tools",
description="Learn how to grow a plant! 101 before start to do weed",
price=30,
ent="sent_magazine",
model="models/props_lab/bindergreenlabel.mdl",
max=5})
