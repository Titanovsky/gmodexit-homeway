BEEPER_ON = false
BEEPER_MESSAGE = "YOU HAVE NO MESSAGES"

local readed = true
local x_bep = 0
local x_text = 0
local x_temp,_ = 0,0

concommand.Add("+show_beeper",function(ply)
  if(ply:GetNWBool("HasBeeper",false)) then
    BEEPER_ON = true
    readed = true
    x_bep = 0
    x_text = 0
    net.Start("IsBeeping")
    net.WriteBool(true)
    net.SendToServer()
  end
end)

concommand.Add("-show_beeper",function(ply)
  if(ply:GetNWBool("HasBeeper",false)) then
    BEEPER_ON = false
    net.Start("IsBeeping")
    net.WriteBool(false)
    net.SendToServer()
  end
end)

net.Receive("UpdateBeeper",function()
  BEEPER_MESSAGE = net.ReadString()
  readed = false
  surface.PlaySound("beeper/sms.mp3")
  timer.Simple(0.5,function()
    surface.PlaySound("beeper/sms.mp3")
    timer.Simple(0.2,function()
      surface.PlaySound("beeper/sms.mp3")
    end)
  end)
end)
local beeper = surface.GetTextureID("gui/beeper")
local glow = surface.GetTextureID("sprites/orangeflare1")

hook.Add("HUDPaint","DrawBeeper",function()

  if(!readed) then
    surface.SetTexture(glow)
    surface.SetDrawColor(255,150,0,200)
    surface.DrawTexturedRect(ScrW()-128,ScrH()/2-128,256,256)
    draw.TextRotated("New Message",ScrW()-82,ScrH()/2+20,Color(255,150,50),"RobotText_hud",270,1.5)
  end

  x_bep = Lerp(FrameTime()*4,x_bep,Either(BEEPER_ON,256,0))

  surface.SetTexture(beeper)
  surface.SetDrawColor(255,255,255)
  surface.DrawTexturedRect(ScrW()-x_bep,ScrH()/2-128,256,256)

  if(IsValid(LocalPlayer():GetEyeTrace().Entity) && (LocalPlayer():GetEyeTrace().Entity.Linkable or false)) then
    if(!LocalPlayer():GetEyeTrace().Entity:GetNWBool("Linked",false)) then
      draw.SimpleText("Press E to link with beeper","RobotText_hud",ScrW()-x_bep+20,ScrH()/2-128+12,Color(255,255,255))
    else
      draw.SimpleText("Press E to unlink the beeper","RobotText_hud",ScrW()-x_bep+20,ScrH()/2-128+12,Color(150,255,50))
    end
  end

  render.SetScissorRect( ScrW()-x_bep+48,ScrH()/2-128+88, ScrW()-x_bep+48+160,ScrH()/2-128+512, true )
    x_temp,_ = draw.SimpleText(BEEPER_MESSAGE,"RobotText_beeper",ScrW()-x_bep+212 + x_text,ScrH()/2-128+88,Color(0,0,0))
  render.SetScissorRect( 0, 0, 0, 0, false )

  x_text = x_text - 0.5
  if(x_text < -(212+x_temp)) then
    x_text = 0
  end

end)
