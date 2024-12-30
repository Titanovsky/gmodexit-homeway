local tbl = {"Magnum.ClipOut","weapons/deagle_beast/de_clipout.wav",
"Magnum.ClipIn","weapons/deagle_beast/de_clipin.wav",
"Magnum.SlideForward","weapons/deagle_beast/de_slideback.wav",
"Magnum.Deploy","weapons/deagle_beast/de_deploy.wav",
"Rifle.FullAutoButton","weapons/m4a1_beast/rifle_fullautobutton_1.wav",
"Rifle.ClipOut","weapons/m4a1_beast/rifle_clip_out_1.wav",
"Rifle.Clipin","weapons/m4a1_beast/rifle_clip_in_1.wav",
"Rifle.ClipLocked","weapons/m4a1_beast/rifle_clip_locked_1.wav",
"AK47.SlideBack","weapons/ak47_beast/rifle_slideback.wav",
"AK47.ClipIn","weapons/ak47_beast/rifle_clip_in_1.wav",
"AK47.SlideForward","weapons/ak47_beast/rifle_slideforward.wav",
"AK47.Deploy","weapons/ak47_beast/rifle_deploy_1.wav"
}
for i = 1,#tbl,2 do
	sound.Add(
	{
		name = tbl[i],
		channel = CHAN_WEAPON,
		volume = 1.0,
		soundlevel = 80,
		sound = tbl[i+1]
	})
end