Config = {}
Config.Locale = 'en'

Config.MarkerType   = 21
Config.DrawDistance = 100.0
Config.MarkerSize   = {x = 0.8 ,y = 0.2, z = 1.0}
Config.MarkerColor  = {r = 102, g = 102, b = 204}

Config.BlipPlasticSurgery = {
	Sprite = 403,
	Color = 0,
	Display = 2,
	Scale = 1.0
}

Config.Price = 10000 -- Edit to your liking.

Config.EnableUnemployedOnly = false -- If true it will only show Blips to Unemployed Players | false shows it to Everyone.
Config.EnableBlips = false -- If true then it will show blips | false does the Opposite.
Config.EnablePeds = false -- If true then it will add Peds on Markers | false does the Opposite.

Config.Locations = {
	--{ x = 402.85, y = -998.4, z = -100.0, heading = 180.0 }, -- Police Booking Room
	-- { x = 260.3, y = -1343.68, z = 23.54, heading = 257.66 } -- Hospital Bottom Floor
	{ x = 345.87	, y = -579.04	, z = 43.18, heading = 260.37 } -- Pillbox Hill MLO
}

Config.Zones = {}

for i=1, #Config.Locations, 1 do
	Config.Zones['Shop_' .. i] = {
		Pos   = Config.Locations[i],
		Size  = Config.MarkerSize,
		Color = Config.MarkerColor,
		Type  = Config.MarkerType
	}
end
