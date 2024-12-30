surface.CreateFont( "BeeperText", {
  font = "Fixedsys",
  size = 32
} )

surface.CreateFont( "DealerText", {
  font = "Fixedsys",
  size = 42
} )

surface.CreateFont( "MainWeedFont", {
  font = "Akbar",
  size = 64
} )

surface.CreateFont( "MainWeedFont_med", {
  font = "Akbar",
  size = 48
} )

surface.CreateFont( "MainWeedFont_min", {
  font = "Akbar",
  size = 34
} )

surface.CreateFont( "RobotText_beeper", {
	font = "Fixedsys",
	size = 30,
	weight = 1,
} )
surface.CreateFont( "RobotText_hud", {
	font = "Fixedsys",
	size = 18,
	weight = 1,
} )


function draw.TextRotated( text, x, y, color, font, ang,scl )
	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )
	surface.SetFont( font )
	surface.SetTextColor( color )
	surface.SetTextPos( 0, 0 )
	local textWidth, textHeight = surface.GetTextSize( text )
	local rad = -math.rad( ang )
	x = x - ( math.cos( rad ) * textWidth / 2 + math.sin( rad ) * textHeight / 2 )
	y = y + ( math.sin( rad ) * textWidth / 2 + math.cos( rad ) * textHeight / 2 )
	local m = Matrix()
	m:SetAngles( Angle( 0, ang, 0 ) )
  m:SetScale(Vector(scl or 1,scl or 1,scl or 1))
	m:SetTranslation( Vector( x, y, 0 ) )
	cam.PushModelMatrix( m )
		surface.DrawText( text )
	cam.PopModelMatrix()
	render.PopFilterMag()
	render.PopFilterMin()
end
