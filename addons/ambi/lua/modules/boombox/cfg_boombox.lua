Ambi.General.CreateModule( 'BoomBox', '2.0', 'Homeway' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
Ambi.BoomBox.Config.enable = true -- Включить систему?
Ambi.BoomBox.Config.can_kick = true -- Кикать игроков, если они не проходят проверку античита?

--todo добавить дистанцию и проверку на то, надо ли оповещать игрока?

Ambi.BoomBox.Config.ent_class = 'boombox' -- Класс бумбокса
Ambi.BoomBox.Config.ent_model = 'models/custom/boombox.mdl' -- Моделька бумбокса
Ambi.BoomBox.Config.ent_damage_enable = true -- Можно наносить урон бумбоксу?
Ambi.BoomBox.Config.ent_health = 500 -- Здоровье бумбокса и его максимальное здоровье.

Ambi.BoomBox.Config.radio = { -- Таблица с радио станциями (Максимум 1023)
    { header = 'Christmas', url = 'http://prmstrm.1.fm:8000/christmas' },
    { header = 'Винтаж Радио', url = 'http://46.174.55.216:8000/stream.mp3' },
    { header = 'Radio Record', url = 'http://radio-srv1.11one.ru/record192k.mp3' },
    { header = 'Ретро ФМ', url = 'http://retroserver.streamr.ru:8043/retro256.mp3' },
    { header = 'Advance Radio', url = 'https://radio.advance-rp.ru/channel1.ogg' },
    { header = 'Trinity FM', url = 'http://trinitx.cluster030.hosting.ovh.net/trinity.m3u' },
    { header = 'Radio Record 2 [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/record.m3u' },
    { header = 'Europa Plus [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/europa.m3u' },
    { header = 'NRJ [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/nrj.m3u' },
    { header = 'DFM [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/dfm.m3u' },
    { header = 'Rock FM [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/rockfm.m3u' },
    { header = 'Record Black [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/black.m3u' },
    { header = 'Русское Радио [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/russian.m3u' },
    { header = 'Наше Радио [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/nashe.m3u' },
    { header = 'Дорожное Радио [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/dorozhnoe.m3u' },
    { header = 'Радио Шансон [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/chanson.m3u' },
    { header = 'Ретро ФМ [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/retro.m3u' },
    { header = '100 Hitz [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/100hitz.m3u' },
    { header = 'Jazz [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/jazz.m3u' },
    { header = 'Soul Radio [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/soulradio.m3u' },
    { header = 'Easy Hits Florida [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/easyhits.m3u' },
    { header = '181 FM Hip Hop [•]', url = 'http://trinitx.cluster030.hosting.ovh.net/181hiphop.m3u' },
}