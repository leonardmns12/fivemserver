Config              = {}
Config.MarkerType   = 21
Config.DrawDistance = 25.0
Config.ZoneSize     = {x = 5.0, y = 5.0, z = 3.0}
Config.MarkerColor  = {r = 100, g = 204, b = 100}
Config.RequiredCopsCoke = 1
Config.RequiredCopsMeth = 1
Config.RequiredCopsWeed = 1
Config.RequiredCopsOpium = 1
Config.RequiredCopsMoonshine = 1
Config.Locale = 'en'

Config.Zones = {
	CokeFarm =			{x = 1389.08,	y = 3604.37,	    z = 38.94},
	CokeTreatment =		{x = 1393.51,	y= 3602.06,		    z = 38.94},
	-- CokeResell =		{x = 959.93,	y = -122.02,		z = 74.35},
	MethFarm =			{x = 1531.33,	y = 1703.44,		z = 109.77},
	MethTreatment =		{x = 1378.43,	y = 2172.47,		z = 97.72},
	-- MethResell =		{x = -241.03,	y = 6354.96,		z = 30.6},
	-- WeedFarm =			{x = 2233.6,	y = 5577.64,		z = 53.01},
	-- WeedTreatment =		{x = 2329.49,	y = 2573.48,		z = 46.01},
	-- WeedResell =		{x = 996.555,	y = 3574.94,		z = 34.5},
	OpiumFarm =			{x = 2488.92,	y = 4962.15,		z = 44.77},
	OpiumTreatment =	{x = 2531.7,	y = 4982.62,		z = 44.9},
	-- OpiumResell =		{x = -3157.28,	y = 1127.4,	    	z = 20.85}
	-- MoonshineFarm =     {x = 1901.8,	y = 4917.04,	    z = 48.77},
	-- MoonshineTreatment = {x = 1981.56,	y = 5174.5,	   		 z = 47.64},
	-- MoonshineResell =   {x = 1741.95,	y = 6419.28,	    z = 34.1}
}

Config.Blips = {
    {name = "Coke Farm", 		 color=50, scale=0.8, id=501,	     x = 1389.08,	y= 3604.37,	    z = 38.94},
	{name = "Coke Treatment",  color=50, scale=0.8, id=501,          x = 1393.51,	y= 3602.06,		z = 38.94},
	-- {name = "Coke Sales", 	 color=50, scale=0.8, id=501,	         x = 959.93,	y = -122.02,		z = 74.35},
	{name = "Meth Farm",       color=77, scale=0.8, id=499,	         x = 1531.33,	y = 1703.44,		z = 109.77},
	{name = "Meth Treatment",  color=77, scale=0.8, id=499,	         x = 1378.43,	y = 2172.47,		z = 97.72},
	-- {name = "Meth Sales",      color=77, scale=0.8, id=499,          x = -241.03,	y = 6354.96,	z = 30.6},
	-- {name = "Weed Farm",       color=69, scale=0.8, id=140,	         x = 2233.6,	y= 5577.64,		z = 53.01},
	-- {name = "Weed Treatment",  color=69, scale=0.8, id=140,	         x = 2329.49,	y= 2573.48,		z = 46.01},
	-- {name = "Weed Sales",	     color=69, scale=0.8, id=140,        x = 996.555,	y= 3574.94,		z = 34.5},
	{name = "Opium Farm",      color=49, scale=0.8, id=403,	         x = 2488.92,	y = 4962.15,	z = 44.77},
	{name = "Opium Treatment", color=49, scale=0.8, id=403,	         x = 2531.7,	y = 4982.62,	z = 44.9}
	-- {name = "Opium Sales",     color=49, scale=0.8, id=403,      	 x = -3157.28,	y = 1127.4,	    z = 20.85},
	-- {name = "MooneShine Farm",     color=1, scale=0.8, id=514,      x = 1901.8,	y = 4917.04,	z = 48.77},
	-- {name = "MooneShine Treatment",     color=1, scale=0.8, id=514, x = 1981.56,	y = 5174.5,		z = 47.64},	
	-- {name = "MooneShine Sales",     color=1, scale=0.8, id=514,	 x = 1741.95,	y = 6419.28,	z = 35.039}


}