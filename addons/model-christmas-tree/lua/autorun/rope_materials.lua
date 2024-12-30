
if SERVER then

	resource.AddFile("materials/grinchfox/rope/cmlight.vmt")

	resource.AddFile("materials/grinchfox/rope/cmlight.vtf")

	resource.AddFile("materials/grinchfox/rope/cmlight_large.vmt")

	resource.AddFile("materials/grinchfox/rope/cmlight_large.vtf")

	resource.AddFile("materials/grinchfox/rope/cmlight_selfillum.vtf")

	resource.AddFile("materials/grinchfox/rope/tinsel.vtf")

	resource.AddFile("materials/grinchfox/rope/tinsel_blue.vmt")

	resource.AddFile("materials/grinchfox/rope/tinsel_blue.vtf")

	resource.AddFile("materials/grinchfox/rope/tinsel_green.vmt")

	resource.AddFile("materials/grinchfox/rope/tinsel_green.vtf")

	resource.AddFile("materials/grinchfox/rope/tinsel_normal.vtf")

	resource.AddFile("materials/grinchfox/rope/tinsel_purple.vmt")

	resource.AddFile("materials/grinchfox/rope/tinsel_purple.vtf")

	resource.AddFile("materials/grinchfox/rope/tinsel_red.vmt")

	resource.AddFile("materials/grinchfox/rope/tinsel_red.vtf")

	resource.AddFile("materials/grinchfox/rope/tinsel_white.vmt")

	resource.AddFile("materials/grinchfox/rope/tinsel_yellow.vmt")

	resource.AddFile("materials/grinchfox/rope/tinsel_yellow.vtf")

	AddCSLuaFile()

	return

end



local function AddNewRopeMaterial( name, mat )

	list.Set( "RopeMaterials", name, mat )

end



AddNewRopeMaterial( "White Tinsel", "grinchfox/rope/tinsel_white" )

AddNewRopeMaterial( "Purple Tinsel", "grinchfox/rope/tinsel_purple" )

AddNewRopeMaterial( "Green Tinsel", "grinchfox/rope/tinsel_green" )

AddNewRopeMaterial( "Blue Tinsel", "grinchfox/rope/tinsel_blue" )

AddNewRopeMaterial( "Yellow Tinsel", "grinchfox/rope/tinsel_yellow" )

AddNewRopeMaterial( "Red Tinsel", "grinchfox/rope/tinsel_red" )

AddNewRopeMaterial( "Christmas Lights", "grinchfox/rope/cmlight" )

AddNewRopeMaterial( "Christmas Lights Balls", "grinchfox/rope/cmlight_large" )



local light_mats = {

	(Material"grinchfox/rope/cmlight_large"),

	(Material"grinchfox/rope/cmlight"),

	(Material"models/grinchfox/foliage/christmastree_lights")

}



local period = 0

local offset = 0

local voffset = 0

local offset_mtx = Matrix()

hook.Add("Tick","SetChristmasProxyOffset",function()

	period = (RealTime())%1

	offset = 0.5 -- math.floor(period%4)/4

	voffset = 1-period

	offset_mtx:Identity()

	offset_mtx:Translate( Vector(voffset,offset,0) )

	offset_mtx:Scale( Vector(0,4,1) )



	for _, mat in pairs( light_mats ) do

		mat:SetMatrix("$detailtexturetransform",offset_mtx)

	end

end)



local colors = {

	Color(0,255,0),

	Color(255,255,0),

	Color(255,0,0),

	Color(0,0,255)

}

local errcolor = Color(255,0,255)

function GetCurrentChristmasLightsColor()

	return colors[ math.floor(period*4+1) ] or errcolor

end



