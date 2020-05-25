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
            ["iron"] = {label = "Besi", count = 10},
            ["blowtorch"] = {label = "blowtorch", count = 2},
            ["wood"] = {label = "Kayu", count = 5},
        },
        threshold = 0,
    },
    ["advancedlockpick"] = {
        label = "Advance Lockpick",
        needs = {
            ["iron"] = {label = "Besi", count = 20},
            ["blowtorch"] = {label = "blowtorch", count = 10},
            ["wood"] = {label = "Kayu", count = 3},
        },
        threshold = 0,
    },
    ["rope"] = {
        label = "Tali",
        needs = {
            ["leather"] = {label = "Kulit", count = 15},
        },
        threshold = 0,
    },
    ["handcuffs"] = {
        label = "Borgol",
        needs = {
            ["iron"] = {label = "Besi", count = 30},
            ["diamond"] = {label = "Berlian", count = 5},
        },
        threshold = 0,
    },
    ["weapon_pistol"] = {
        label = "Pistol",
        needs = {
            ["weaclip"] = {label = "Ammo clip", count = 2},
            ["gold"] = {label = "Emas", count = 20},
        },
        threshold = 0,
    },
    ["weapon_pistol50"] = {
        label = "Pistol 50",
        needs = {
            ["weaclip"] = {label = "Ammo clip", count = 4},
            ["gold"] = {label = "Emas", count = 40},
        },
        threshold = 0,
    },
    ["weaclip"] = {
        label = "Ammo clip",
        needs = {
            ["leather"] = {label = "Kulit", count = 2},
            ["baggie"] = {label = "Plastik Bag", count = 5},
        },
        threshold = 0,
    },
    ["weabox"] = {
        label = "Ammo box",
        needs = {
            ["leather"] = {label = "Kulit", count = 6},
            ["baggie"] = {label = "Plastik Bag", count = 20},
        },
        threshold = 0,
    },
    ["weapon_assaultrifle"] = {
        label = "AK - 47",
        needs = {
            ["weabox"] = {label = "Ammo senjata", count = 5},
            ["iron"] = {label = "Iron", count = 20},
            ["leather"] = {label = "Kulit", count = 20},
            ["batteryacid"] = {label = "Battery Acid", count = 5},
        },
        threshold = 0,
    },
    ["weapon_doubleaction"] = {
        label = "Doubleaction Revolver",
        needs = {
            ["weabox"] = {label = "Ammo senjata", count = 5},
            ["iron"] = {label = "Iron", count = 10},
            ["leather"] = {label = "Kulit", count = 5},
            ["batteryacid"] = {label = "Battery Acid", count = 1},
        },
        threshold = 0,
    },
    ["raspberry"] = {
        label = "Raspberry",
        needs = {
            ["copper"] = {label = "Tembaga", count = 15},
            ["highrim"] = {label = "Iron", count = 2},
            ["rolex"] = {label = "Rolex", count = 1},
            ["batteryacid"] = {label = "Battery Acid", count = 3},
        },
        threshold = 0,
    },
    ["batteryacid"] = {
        label = "Baterry Acid",
        needs = {
            ["psuedoephedrine"] = {label = "psuedoephedrine", count = 5},
        },
        threshold = 0,
    },
    ["bulletproof"] = {
        label = "bulletproof",
        needs = {
            ["shark"] = {label = "Hiu", count = 1},
            ["turtle"] = {label = "Kura kura", count = 5},
            ["iron"] = {label = "Besi", count = 25},
            ["leather"] = {label = "Kulit", count = 10},
        },
        threshold = 0,
    },
    ["baggie"] = {
        label = "Plastik",
        needs = {
            ["leather"] = {label = "Kulit", count = 2},
        },
        threshold = 0,
    },
    ["weapon_knife"] = {
        label = "Knife",
        needs = {
            ["iron"] = {label = "Besi", count = 5},
        },
        threshold = 0,
    },
}