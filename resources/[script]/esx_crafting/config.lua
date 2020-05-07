Crafting = {}
-- You can configure locations here
Crafting.Locations = {
    [1] = {x = 1015.003, y = -3158.878, z = -38.907},
    [2] = {x = 1175.433, y = 2635.81, z = 37.755},
    [3] = {x = -1154.895, y = -2022.624, z = 13.176},
}
--[[
    You can add or remove if you want, be sure to use the right format like this:
    ["item_name"] = {
        label = "Item Label",
        needs = {
            ["item_to_use_name"] = {label = "Item Use Label", count = 1}, 
            ["item_to_use_name2"] = {label = "Item Use Label", count = 2},
        },
        threshold = 0,
    },

    #! 
        Threshold level is a level that gets saved (in the database) by crafting, if you craft succefully you gain points, if you fail you lose points.
        The threshold level can be changed to your liking.
    #!

    Also if you don't have the items below make sure to remove it and create your own version.
]]--
Crafting.Items = {
    ["lockpick"] = {
        label = "Lockpick",
        needs = {
            ["iron"] = {label = "Metalscrap", count = 10},
            ["blowtorch"] = {label = "Plastic", count = 5},
            ["wood"] = {label = "Wood", count = 5},
        },
        threshold = 100,
    },
    ["advancelockpick"] = {
        label = "Advance Lockpick",
        needs = {
            ["iron"] = {label = "Metalscrap", count = 20},
            ["blowtorch"] = {label = "Plastic", count = 10},
            ["wood"] = {label = "Wood", count = 10},
        },
        threshold = 100,
    },
    ["rope"] = {
        label = "Tali",
        needs = {
            ["leather"] = {label = "Kulit", count = 15},
        },
        threshold = 100,
    },
    ["handcuffs"] = {
        label = "Borgol",
        needs = {
            ["iron"] = {label = "Metalscrap", count = 30},
            ["diamond"] = {label = "Small lockpick", count = 5},
        },
        threshold = 250,
    },
    ["weapon_pistol"] = {
        label = "Pistol",
        needs = {
            ["weaclip"] = {label = "Ammo clip", count = 5},
            ["gold"] = {label = "Plastic", count = 20},
        },
        threshold = 450,
    },
    ["weaclip"] = {
        label = "Ammo clip",
        needs = {
            ["leather"] = {label = "Kulit", count = 10},
            ["baggie"] = {label = "Plastik Bag", count = 5},
            ["lockpick"] = {label = "Lockpick", count = 1},
        },
        threshold = 450,
    },
    ["weabox"] = {
        label = "Ammo box",
        needs = {
            ["leather"] = {label = "Kulit", count = 25},
            ["baggie"] = {label = "Plastik Bag", count = 20},
            ["lockpick"] = {label = "Lockpick", count = 1},
        },
        threshold = 450,
    },
    ["weapon_advancerifle"] = {
        label = "AK - 47",
        needs = {
            ["weabox"] = {label = "Ammo senjata", count = 5},
            ["iron"] = {label = "Iron", count = 20},
            ["leather"] = {label = "Kulit", count = 20},
            ["batteryacid"] = {label = "Battery Acid", count = 5},
        },
        threshold = 600,
    },
    ["weapon_doubleaction"] = {
        label = "Doubleaction Revolver",
        needs = {
            ["weabox"] = {label = "Ammo senjata", count = 5},
            ["iron"] = {label = "Iron", count = 10},
            ["leather"] = {label = "Kulit", count = 5},
            ["batteryacid"] = {label = "Battery Acid", count = 1},
        },
        threshold = 600,
    },
}