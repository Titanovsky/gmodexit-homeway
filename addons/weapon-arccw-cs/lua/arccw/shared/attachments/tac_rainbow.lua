att.PrintName = 'Rainbow Laser'
att.Icon = Material("entities/acwatt_tac_green.png")
att.Description = 'Разноцветный лазер'
att.Desc_Pros = {
}
att.Desc_Cons = {
    "con.beam"
}
att.AutoStats = true
att.Slot = {"tac_pistol", "tac"}

att.Model = "models/weapons/arccw/atts/laser_green.mdl"

att.Laser = true
att.LaserStrength = 1
att.LaserBone = "laser"

att.ColorOptionsTable = {Color(50, 255, 50)}
att.Rainbow = true

att.Mult_HipDispersion = 0.85
att.Mult_SightTime = 0.8
--att.Mult_Recoil = 0.9