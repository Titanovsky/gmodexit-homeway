Ambi.General.CreateModule( 'FogOpti' )

-- --------------------------------------------------------------------------------------------------------------------------------------------
Ambi.FogOpti.Config.default = {
    create = true, -- создать при спавне? --! Требуется рестарт
    fogenable = true, -- даже выключенным туман работает (просто не отображается цвет) 
    fogstart = 200,
    fogend = 4000,
    farz = 4000,
    fogmaxdensity = 0.00, -- чувствительность света
    fogblend = false,
    fogcolor = Color(0, 0, 0),
    fogcolor2 = Color(0, 0, 0),
}