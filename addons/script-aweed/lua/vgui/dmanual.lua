MGZ = MGZ or nil
net.Receive("ShowManual",function(l,ply)
  if(MGZ != nil) then
    MGZ:Remove()
  end
  MGZ = vgui.Create("DManual")
end)

local MANUAL = {}

function MANUAL:Init()
  self:SetSize(300,520)
  self:Center()
  self:MakePopup()
  self:SetTitle("")

  self:ShowCloseButton(false)

  self.CButton = vgui.Create("DButton",self)
  self.CButton:SetSize(32,32)
  self.CButton:SetPos(300-32-8,8)
  self.CButton:SetText("")
  self.CButton.Paint = function(s,w,h)
    surface.SetDrawColor(231, 76, 60)
    surface.DrawRect(0,0,w,h)
    surface.SetDrawColor(240, 240, 241)
    surface.DrawRect(4,h-8,w-8,4)
  end
  self.CButton.DoClick = function() self:Remove() end

  self.Icons = {}
  self.Icons[1] = vgui.Create( "SpawnIcon" , self ) -- SpawnIcon
  self.Icons[1]:SetPos( 16, 64 )
  self.Icons[1]:SetModel( "models/gonzo/weedb/pot3.mdl" ) -- Model we want for this spawn icon
  self.Icons[1]:SetToolTip("Pot")

  self.Icons[2] = vgui.Create( "DLabel" , self ) -- SpawnIcon
  self.Icons[2]:SetText("You'll need a pot")
  self.Icons[2]:SetFont("WeedItemDesc")
  self.Icons[2]:SetColor(Color(52,73,94))
  self.Icons[2]:SetPos( 16+64+16, 70 )
  self.Icons[2]:SetSize( 300-(16+64+32), 48 )
  self.Icons[2]:SetWrap(true)

  self.Icons[3] = vgui.Create( "SpawnIcon" , self ) -- SpawnIcon
  self.Icons[3]:SetPos( 16, 64+64 )
  self.Icons[3]:SetModel( "models/gonzo/weedb/soil_bag.mdl" ) -- Model we want for this spawn icon
  self.Icons[3]:SetToolTip("Soil")

  self.Icons[4] = vgui.Create( "DLabel" , self ) -- SpawnIcon
  self.Icons[4]:SetText("Touch the pot with the bag")
  self.Icons[4]:SetFont("WeedItemDesc")
  self.Icons[4]:SetColor(Color(52,73,94))
  self.Icons[4]:SetPos( 16+64+16, 70+16 )
  self.Icons[4]:SetSize( 300-(16+64+32), 48+96 )
  self.Icons[4]:SetWrap(true)

  self.Icons[5] = vgui.Create( "SpawnIcon" , self ) -- SpawnIcon
  self.Icons[5]:SetPos( 16, 64+64+64 )
  self.Icons[5]:SetModel( "models/props_junk/watermelon01.mdl" ) -- Model we want for this spawn icon
  self.Icons[5]:SetToolTip("Seed")

  self.Icons[6] = vgui.Create( "DLabel" , self ) -- SpawnIcon
  self.Icons[6]:SetText("Put the seed")
  self.Icons[6]:SetFont("WeedItemDesc")
  self.Icons[6]:SetColor(Color(52,73,94))
  self.Icons[6]:SetPos( 16+64+16, 70+16+64 )
  self.Icons[6]:SetSize( 300-(16+64+32), 48+96 )
  self.Icons[6]:SetWrap(true)

  self.Icons[7] = vgui.Create( "SpawnIcon" , self ) -- SpawnIcon
  self.Icons[7]:SetPos( 16, 64+64+64+64 )
  self.Icons[7]:SetModel( "models/gonzo/weedb/water_pot.mdl" ) -- Model we want for this spawn icon
  self.Icons[7]:SetToolTip("Water jar")

  self.Icons[8] = vgui.Create( "DLabel" , self ) -- SpawnIcon
  self.Icons[8]:SetText("Tilt the jar to drop water")
  self.Icons[8]:SetFont("WeedItemDesc")
  self.Icons[8]:SetColor(Color(52,73,94))
  self.Icons[8]:SetPos( 16+64+16, 70+16+64+64 )
  self.Icons[8]:SetSize( 300-(16+64+32), 48+96 )
  self.Icons[8]:SetWrap(true)

  self.Icons[9] = vgui.Create( "SpawnIcon" , self ) -- SpawnIcon
  self.Icons[9]:SetPos( 16, 64+64+64+64+64 )
  self.Icons[9]:SetModel( "models/gonzo/weedb/lamp.mdl" ) -- Model we want for this spawn icon
  self.Icons[9]:SetToolTip("Lamp")

  self.Icons[10] = vgui.Create( "DLabel" , self ) -- SpawnIcon
  self.Icons[10]:SetText("Place a battery into the lamp and turn it on")
  self.Icons[10]:SetFont("WeedItemDesc")
  self.Icons[10]:SetColor(Color(52,73,94))
  self.Icons[10]:SetPos( 16+64+16, 70+16+64+64+68 )
  self.Icons[10]:SetSize( 300-(16+64+32), 48+96 )
  self.Icons[10]:SetWrap(true)

  self.Icons[11] = vgui.Create( "SpawnIcon" , self ) -- SpawnIcon
  self.Icons[11]:SetPos( 16, 64+64+64+64+64+64 )
  self.Icons[11]:SetModel( "models/gonzo/weedb/bag/bag.mdl" ) -- Model we want for this spawn icon
  self.Icons[11]:SetToolTip("Smoke it")

  self.Icons[12] = vgui.Create( "DLabel" , self ) -- SpawnIcon
  self.Icons[12]:SetText("Harvest your plant and use a bong")
  self.Icons[12]:SetFont("WeedItemDesc")
  self.Icons[12]:SetColor(Color(52,73,94))
  self.Icons[12]:SetPos( 16+64+16, 70+16+64+64+68+64 )
  self.Icons[12]:SetSize( 300-(16+64+32), 48+96 )
  self.Icons[12]:SetWrap(true)

  self.Icons[13] = vgui.Create( "SpawnIcon" , self ) -- SpawnIcon
  self.Icons[13]:SetPos( 16, 64+64+64+64+64+64+64 )
  self.Icons[13]:SetModel( "models/dav0r/camera.mdl" ) -- Model we want for this spawn icon
  self.Icons[13]:SetToolTip("Smoke it")

  self.Icons[14] = vgui.Create( "DButton" , self ) -- SpawnIcon
  self.Icons[14]:SetText("Watch instructions (Youtube)")
  //self.Icons[14]:SetFont("WeedItemDesc")
  self.Icons[14]:SetColor(Color(52,73,94))
  self.Icons[14]:SetPos( 16+64+16, 520-52 )
  self.Icons[14]:SetSize( 300-(16+64+32), 32 )
  self.Icons[14].DoClick = function()
      gui.OpenURL("https://www.youtube.com/watch?v=HBFwxzacwhc")
  end
end

function MANUAL:Paint(w,h)
  surface.SetDrawColor(240,240,240)
  surface.DrawRect(0,0,w,h)
  surface.SetDrawColor(52, 73, 94)
  surface.DrawRect(0,0,w,48)

  draw.SimpleText("Harvest 101","WeedTitle",16,10,Color(240,240,240))
end

derma.DefineControl("DManual","DManual",MANUAL,"DFrame")
