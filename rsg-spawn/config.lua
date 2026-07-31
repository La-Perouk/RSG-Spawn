Config = {}

-- Settings
Config.AutoDualWield = true

-- Discord Logs
Config.DiscordWebhook = {
    default = "",
    ban     = "",
    kick    = "",
}

-- spawn locations if Config.SelectLocations is true
Config.SpawnLocations = {
    { id = 'annesburg',     label = 'Annesburg',     desc = 'The Coal Village',      image = 'nui://rsg-spawn/html/img/annesburg.jpg',      coords = vec4(2929.7390, 1270.4764, 44.6728, 253.0386) },       -- Annesburg Train Station
    { id = 'saintdenis',    label = 'Saint Denis',   desc = 'The Big City',          image = 'nui://rsg-spawn/html/img/saintdenis.jpg',     coords = vec4(2724.6819, -1437.5935, 46.0862, 31.9468) },       -- Saint Denis Train Station
    { id = 'rhodes',        label = 'Rhodes',        desc = 'The Lemoyne Heart',     image = 'nui://rsg-spawn/html/img/rhodes.jpg',         coords = vec4(1237.5671, -1301.8521, 76.9192, 133.9272) },      -- Rhodes Train Station
    { id = 'emeraldranch',  label = 'Emerald Ranch', desc = 'The iconic and mysterious town',   image = 'nui://rsg-spawn/html/img/emeraldranch.jpg',   coords = vec4(1525.6299, 435.8587, 90.6808, 273.5405) },      -- Emerald Ranch Train Station
    { id = 'valentine',     label = 'Valentine',     desc = 'The Heartlands',        image = 'nui://rsg-spawn/html/img/valentine.jpg',      coords = vec4(-174.6007, 641.3490, 114.0897, 237.8759) },       -- Valentine Train Station
    { id = 'blackwater',    label = 'Blackwater',    desc = 'Blackwater Massacre',   image = 'nui://rsg-spawn/html/img/blackwater.jpg',     coords = vec4(-874.7919, -1337.3678, 43.9783, 84.1052) },       -- Blackwater Train Station
    { id = 'armadillo',     label = 'Armadillo',     desc = 'The Ghost Town',        image = 'nui://rsg-spawn/html/img/armadillo.jpg',      coords = vec4(-3739.9980, -2605.9001, -13.2331, 94.9683) },     -- Armadillo Train Station
    { id = 'tumbleweed',    label = 'Tumbleweed',    desc = 'The Godforsaken Town',  image = 'nui://rsg-spawn/html/img/tumbleweed.jpg',     coords = vec4(-5225.5869, -3479.7458, -20.5653, 104.5866) },    -- Tumbleweed Train Station
    
}

Config.RandomTips = {
    'TIP : use [LALT] to target',
    'TIP : use [H] to call your horse',
    'TIP : use [I] to open your inventory',
}
