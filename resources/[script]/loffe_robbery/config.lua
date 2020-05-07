Config = {}
Translation = {}

Config.Shopkeeper = 416176080 -- hash of the shopkeeper ped
Config.Locale = 'en' -- 'en', 'sv' or 'custom'

Config.Shops = {
    -- {coords = vector3(x, y, z), heading = peds heading, money = {min, max}, cops = amount of cops required to rob, blip = true: add blip on map false: don't add blip, name = name of the store (when cops get alarm, blip name etc)}
    {coords = vector3(24.03, -1345.63, 29.5-0.98), heading = 266.0, money = {5000, 15000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(379.19, 332.08, 102.57-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(2550.15, 385.37, 107.62-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-3047.08, 586.37, 6.91-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-1480.09, -373.35, 38.16-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1396.21, 3611.28, 33.98-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-2959.15, 388.54, 13.04-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(2673.59, 3286.2, 54.24-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-43.7, -1750.58, 28.42-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1161.15, -315.73, 68.21-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-705.73, -914.91, 19.22-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-1827.32, 798.78, 137.16-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1705.41, 4920.56, 41.06-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1959.04, 3747.93, 31.34-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1126.83, -982.6, 44.42-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-1384.41, -628.71, 29.82-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(546.86, 2663.71, 41.16-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-3249.3, 1004.54, 11.83-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1166.89, 2718.14, 36.16-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1734.88, 6419.83, 34.04-0.98), heading = 91.0, money = {7500, 20000}, cops = 1, blip = true, name = 'Robbery', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false}
}

Translation = {
    ['en'] = {
        ['shopkeeper'] = 'Penjaga toko',
        ['robbed'] = "Saya baru saja dirampok dan ~r~tidak ~w~punya uang sedikitpun!",
        ['cashrecieved'] = 'Kamu mendapatkan:',
        ['currency'] = 'Rp',
        ['scared'] = 'Ketakutan:',
        ['no_cops'] = 'Jumlah polisi tidak cukup untuk kegiatan ini!',
        ['cop_msg'] = 'Kami telah mengirim foto perampok dari rekaman CCTV!',
        ['set_waypoint'] = 'Set waypoint ke toko',
        ['hide_box'] = 'Tutup box ini',
        ['robbery'] = 'Perampokan sedang berlangsung',
        ['walked_too_far'] = 'Kamu berjalan terlalu jauh!'
    },
    ['sv'] = {
        ['shopkeeper'] = 'butiksbiträde',
        ['robbed'] = 'Jag blev precis rånad och har inga pengar kvar!',
        ['cashrecieved'] = 'Du fick:',
        ['currency'] = 'SEK',
        ['scared'] = 'Rädd:',
        ['no_cops'] = 'Det är inte tillräckligt med poliser online!',
        ['cop_msg'] = 'Vi har skickat en bild på rånaren från övervakningskamerorna!',
        ['set_waypoint'] = 'Sätt GPS punkt på butiken',
        ['hide_box'] = 'Stäng denna rutan',
        ['robbery'] = 'Pågående butiksrån',
        ['walked_too_far'] = 'Du gick för långt bort!'
    },
    ['custom'] = { -- edit this to your language
        ['shopkeeper'] = '',
        ['robbed'] = '',
        ['cashrecieved'] = '',
        ['currency'] = '',
        ['scared'] = '',
        ['no_cops'] = '',
        ['cop_msg'] = '',
        ['set_waypoint'] = '',
        ['hide_box'] = '',
        ['robbery'] = '',
        ['walked_too_far'] = ''
    }
}