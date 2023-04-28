Config = {}

Config.List = true
-- DEBUG CONFIGS --
Config.Debug = false -- Client / Server Debug Prints
Config.DebugPoly = false -- Debug Polyzones

-- PROGRESSBAR CONFIGS --
Config.Times = { -- Time to make items (Set in seconds)
    Food = 5,
    Drinks = 5,
    WashHands = 5
}

-- MINIGAME CONFIG --
Config.Minigame = {
    Circles = 2,
    Time = 20
}

-- BUSINESS CONFIGS --
Config.Job = 'beanmachine' -- Name of the job in 'qb-core > shared > jobs.lua'
Config.Business = {
    Name = 'Bean Machine', -- Blip Name / Business Name
    AutoDuty = false, -- Players on/off duty auto changes when entering/leaving the polyzone

    -- Business Blip Info
    Blip = {
        coords = vector3(121.48, -1036.02, 29.28),
        sprite = 181,
        color = 31,
        size = 0.8,
    },

    -- For on/off duty when enetering the business (Only used if AutoDuty = true)
    BusinessPoly = {
        Zones = {
            [1] = {
                minZ = 28,
                maxZ = 31,
                zone = {
                    vector2(112.20778656006, -1045.7586669922),
                    vector2(119.12358093262, -1026.5433349609),
                    vector2(128.96510314941, -1029.9719238281),
                    vector2(121.7850112915, -1049.6458740234)
                }
            }
        }
    },
}

Config.Locations = {
    ['Registers'] = { -- Cash Register Locations
        [1] = {
            coords = vector3(120.87, -1040.16, 29.28),
            heading = 340.0,
            length = 0.6,
            width = 0.6,
            info = {
                label = 'Register',
                icon = 'fas fa-dollar-sign',
                event = Config.Job..':client:Charge', -- Use your own payments event
            }
        },
        -- [2] = {
        --     coords = vector3(122.15, -1036.52, 29.28),
        --     heading = 340.0,
        --     length = 0.6,
        --     width = 0.4,
        --     info = {
        --         label = 'Register',
        --         icon = 'fas fa-dollar-sign',
        --         event = Config.Job..':client:Charge', -- Use your own payments event
        --     }
        -- }
    },
    ['Duty'] = { -- On / Off Duty Locations
        [1] = {
            coords = vector3(126.86, -1035.64, 29.28),
            heading = 340.0,
            length = 0.8,
            width = 0.2,
            info = {
                label = 'On / Off Duty',
                icon = 'fas fa-clock',
            }
        }
    },
    ['Stashes'] = { -- Stash Locations
        [1] = {
            coords = vector3(124.12, -1037.79, 29.28),
            heading = 340.0,
            length = 1.0,
            width = 0.6,
            info = {
                label = 'Stash',
                icon = 'fas fa-box',
            }
        }
    },
    ['Trays'] = { -- Locations for Trays (Give Food to Customers)
        [1] = {
            coords = vector3(120.53, -1040.72, 29.28),
            heading = 340.0,
            length = 0.6,
            width = 0.4,
            info = {
                label = 'Tray',
                icon = 'fas fa-box',
            }
        },
        [2] = {
            coords = vector3(121.87, -1037.09, 29.28),
            heading = 340.0,
            length = 0.6,
            width = 0.4,
            info = {
                label = 'Tray',
                icon = 'fas fa-box',
            }
        }
    },
    ['Sink'] = { -- Sink Locations
        [1] = {
            coords = vector3(123.66, -1039.2, 29.28),
            heading = 340.0,
            length = 1.0,
            width = 0.6,
            info = {
                label = 'Wash Hands',
                icon = 'fas fa-soap',
            }
        }
    },
    ['Food'] = { -- Make Food Locations
        [1] = {
            coords = vector3(121.52, -1038.47, 29.28),
            heading = 340.0,
            length = 1.4,
            width = 0.6,
            info = {
                label = 'Bean Machine Food',
                icon = 'fas fa-burger',
            }
        }
    },
    ['Drinks'] = { -- Make Drink Locations
        [1] = {
            coords = vector3(123.5, -1042.79, 29.28),
            heading = 340.0,
            length = 0.4,
            width = 1.6,
            info = {
                label = 'Drinks',
                icon = 'fas fa-droplet',
            }
        }
    },
    ['Coffee'] = { -- Make Coffee Locations
        [1] = {
            coords = vector3(122.78, -1041.63, 29.28),
            heading = 340.0,
            length = 0.8,
            width = 0.6,
            info = {
                label = 'Coffee',
                icon = 'fas fa-mug-hot',
            }
        },
		[2] = {
            coords = vector3(124.33, -1036.84, 29.28),
            heading = 340.0,
            length = 0.8,
            width = 0.4,
            info = {
                label = 'Coffee',
                icon = 'fas fa-mug-hot',
            }
        }
    },
--[[
	['Alcohol'] = { -- Make Alcohol Locations
        [1] = {
            coords = vector3(0,0,0),
            heading = 0,
            length = 0,
            width = 0,
            info = {
                label = 'Alcohol',
                icon = 'fas fa-wine-glass',
            }
        }
    },
]]
}

Config.Items = {
    label = "Shop",
        slots = 7,
        items = {
            [1] = {
                name = "coffeebeans",
                price = 0,
                amount = 10,
                info = {},
                type = "item",
                slot = 1,
            }
        }
    }

-- STASH CONFIG --
Config.Stashes = {
    MaxSlots = 10,
    MaxWeight = 2000
}

-- TRAY CONFIG --
Config.Trays = {
    MaxSlots = 10,
    MaxWeight = 2000
}

-- FOOD CONFIG --
Config.Food = {
    [1] = {
        Item = 'tosti', -- Oooh yeah, a grilled cheese
        CraftEmote = 'bbq', -- Emote used when making the item
        UseEmote = 'burger', -- Emote used when using the item
        UseTime = 5, -- How long you use the item for (set in seconds)
        Hunger = 2, -- How much hunger it refills
        Required = {
            [1] = {
                item = 'water_bottle',
                amount = 1,
            },
        }
    }
}

-- DRINKS CONFIG --
Config.Drinks = {
    [1] = {
        Item = 'icedcoffee', -- Yeah, you make that water bottle...
        CraftEmote = 'handshake', -- Emote used when making the item
        UseEmote = 'coffee', -- Emote used when using the item
        UseTime = 5, -- How long you use the item for (set in seconds)
        Thirst = 2, -- How much thirst it refills
        Required = {
            [1] = {
                item = 'coffee',
                amount = 1,
            },
        }
    }
}

-- COFFEE CONFIG --
Config.Speed = {
    Multiplier = 1.1, -- How fast you run
    Length = math.random(20, 30) -- How long you run fast for (Set in seconds)
}
Config.Coffee = {
    [1] = {
        Item = 'coffee',
        CraftEmote = 'handshake', -- Emote used when making the item
        UseEmote = 'coffee', -- Emote used when using the item
        UseTime = 5, -- How long you use the item for (set in seconds)
        Thirst = 2, -- How much thirst it refills
        Required = {
            [1] = {
                item = 'coffeebeans',
                amount = 1,
            },
        }
    },
	[2] = {
        Item = 'frappuccino',
        CraftEmote = 'handshake', -- Emote used when making the item
        UseEmote = 'coffee', -- Emote used when using the item
        UseTime = 5, -- How long you use the item for (set in seconds)
        Thirst = 2, -- How much thirst it refills
        Required = {
            [1] = {
                item = 'coffeebeans',
                amount = 2,
            },
        }
    }
}

-- ALCOHOL CONFIG --
Config.Drunk = {
    Liquor = { -- Values for liquor
        Min = 1, -- Slight Buzz
        Max = 3, -- Riggity-Wrecked, my guy
        Length = math.random(2, 3) -- How long you are drunk for, in minutes
    },
    Beer = { -- Values for beer
        Min = 1, -- Slight Buzz
        Max = 3, -- Riggity-Wrecked, my guy
        Length = math.random(2, 3) -- How long you are drunk for, in minutes
    }
}
Config.Alcohol = {
    [1] = {
        Item = 'vodka',
        CraftEmote = 'handshake', -- Emote used when making the item
        UseEmote = 'drink', -- Emote used when using the item
        UseTime = 5, -- How long you use the item for (set in seconds)
        Thirst = 2, -- How much thirst it refills
        Required = {
            [1] = {
                item = 'water_bottle',
                amount = 1,
            },
        }
    }
}

Loc = {}
