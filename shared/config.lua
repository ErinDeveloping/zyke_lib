Config = Config or {}

-- Set to true to enable debug messages, recommended to always keep true since it doesn't spam the console
-- It only gives relevant information such as critical errors
Config.Debug = false

-- Make sure to use the correct fetching when switching over to ESX
-- Please note that you have to disable the QBCore fetching in your framework files when switching over to ESX
-- If you're using an up to date server, ESX Legacy when this was created, use the fetching in your fxmanifest.lua, otherwise use the fetching in the unlocked files
Config.WeaponType = "item" -- "item" / "weapon", whether to remove and give the weapon as an item or as a scrollwheel weapon, most will use item hence why it's default
Config.Progressbar = "ox_lib" -- "ox_lib" or "default", "default" will use the progressbar in your framework, note that if it is out of date it may not work, ox_lib is recommended to use
Config.FuelSystem = "LegacyFuel" -- "LegacyFuel" / nil (nil = no fuel system, will use default Gta natives)
Config.CustomDeathScript = false -- Support false, "wasabi_ambulance"
Config.GangScript = false -- Support false, "zyke_gangphone"

Config.Minigames = {
    ["lockpick"] = {
        active = "ox_lib_skillcheck",
        minigames = {
            ["ox_lib_skillcheck"] = {
                -- https://overextended.dev/ox_lib/Modules/Interface/Client/skillcheck
                easy = {
                    difficulty = {"easy", "easy", "easy"},
                    inputs = {"W"}
                },
                medium = {
                    difficulty = {"easy", "medium", "medium"},
                    inputs = {"A", "D"}
                },
                hard = {
                    difficulty = {"medium", "medium", "hard"},
                    inputs = {"W", "A", "S", "D"}
                },
            },
        }
    },
    ["memorize"] = {
        active = "ps-ui_thermite",
        minigames = {
            ["ps-ui_thermite"] = {
                -- https://overextended.dev/ox_lib/Modules/Interface/Client/skillcheck
                easy = {
                    time = 20,
                    gridSize = 5,
                    incorrectBlocks = 3,
                },
                medium = {
                    time = 15,
                    gridSize = 6,
                    incorrectBlocks = 3,
                },
                hard = {
                    time = 10,
                    gridSize = 7,
                    incorrectBlocks = 3,
                },
            },
        },
    },
}

Config.BlipColors = {
    {label = "Light Red #1", value = 6, hex = "#c25050", rgb = {194, 80, 80}},
    {label = "Violet", value = 7, hex = "#9c6eaf", rgb = {156, 110, 175}},
    {label = "Pink", value = 8, hex = "#fe7ac3", rgb = {254, 122, 195}},
    {label = "Light Orange #1", value = 9, hex = "#f59d79", rgb = {245, 157, 121}},
    {label = "Light Brown #1", value = 10, hex = "#b18f83", rgb = {177, 143, 131}},
    {label = "Light Green #1", value = 11, hex = "#8dcea7", rgb = {141, 206, 167}},
    {label = "Light Blue #1", value = 12, hex = "#70a8ae", rgb = {112, 168, 174}},
    {label = "Light Purple", value = 13, hex = "#d3d1e7", rgb = {211, 209, 231}},
    {label = "Dark Purple", value = 14, hex = "#8f7e98", rgb = {143, 126, 152}},
    {label = "Cyan", value = 15, hex = "#6ac4bf", rgb = {106, 196, 191}},
    {label = "Light Yellow #1", value = 16, hex = "#d5c398", rgb = {213, 195, 152}},
    {label = "Orange #1", value = 17, hex = "#ea8e50", rgb = {234, 142, 80}},
    {label = "Light Blue #2", value = 18, hex = "#97cae9", rgb = {151, 202, 233}},
    {label = "Dark Pink", value = 19, hex = "#b26287", rgb = {178, 98, 135}},
    {label = "Dark Yellow #1", value = 20, hex = "#8f8d79", rgb = {143, 141, 121}},
    {label = "Dark Orange", value = 21, hex = "#a6755e", rgb = {166, 117, 94}},
    {label = "Light Gray #1", value = 22, hex = "#afa8a8", rgb = {175, 168, 168}},
    {label = "Light Pink #1", value = 23, hex = "#e78d9a", rgb = {231, 141, 154}},
    {label = "Lemon Green", value = 24, hex = "#bbd65b", rgb = {187, 214, 91}},
    {label = "Forest Green", value = 25, hex = "#0c7b56", rgb = {12, 123, 86}},
    {label = "Electric Blue", value = 26, hex = "#7ac3fe", rgb = {122, 195, 254}},
    {label = "Bright Purple", value = 27, hex = "#ab3ce6", rgb = {171, 60, 230}},
    {label = "Dark Yellow #2", value = 28, hex = "#cda80c", rgb = {205, 168, 12}},
    {label = "Dark Blue", value = 29, hex = "#4561ab", rgb = {69, 97, 171}},
    {label = "Dark Cyan", value = 30, hex = "#29a5b8", rgb = {41, 165, 184}},
    {label = "Light Brown 2", value = 31, hex = "#b89b7b", rgb = {184, 155, 123}},
    {label = "Light Blue #3", value = 32, hex = "#c8e0fe", rgb = {200, 224, 254}},
    {label = "Light Yellow #2", value = 33, hex = "#f0f096", rgb = {240, 240, 150}},
    {label = "Light Pink #2", value = 34, hex = "#ed8ca1", rgb = {237, 140, 161}},
    {label = "Light Red 2", value = 35, hex = "#f98a8a", rgb = {249, 138, 138}},
    {label = "Beige", value = 36, hex = "#fbeea5", rgb = {251, 238, 165}},
    {label = "White #1", value = 37, hex = "#fefefe", rgb = {254, 254, 254}},
    {label = "Blue", value = 38, hex = "#2c6db8", rgb = {44, 109, 184}},
    {label = "Light Gray #2", value = 39, hex = "#9a9a9a", rgb = {154, 154, 154}},
    {label = "Dark Gray", value = 40, hex = "#4c4c4c", rgb = {76, 76, 76}},
    {label = "Pink Red", value = 41, hex = "#F29D9D", rgb = {242, 157, 157}},
    {label = "Light Green #2", value = 43, hex = "#AFEDAE", rgb = {175, 237, 174}},
    {label = "Light Orange 2", value = 44, hex = "#FFA75F", rgb = {255, 167, 95}},
    {label = "White #2", value = 45, hex = "#F1F1F1", rgb = {241, 241, 241}},
    {label = "Gold", value = 46, hex = "#ECF029", rgb = {236, 240, 41}},
    {label = "Orange #2", value = 47, hex = "#FF9A18", rgb = {255, 154, 24}},
    {label = "Brilliant Rose", value = 48, hex = "#F644A5", rgb = {246, 68, 165}},
    {label = "Medium Purple", value = 50, hex = "#8A6DE3", rgb = {138, 109, 227}},
    {label = "Salmon", value = 51, hex = "#FF8B5C", rgb = {255, 139, 92}},
    {label = "Dark Green", value = 52, hex = "#416C41", rgb = {65, 108, 65}},
    {label = "Blizzard Blue", value = 53, hex = "#B3DDF3", rgb = {179, 221, 243}},
    {label = "Oracle Blue #1", value = 54, hex = "#3A6479", rgb = {58, 100, 121}},
    {label = "Silver", value = 55, hex = "#A0A0A0", rgb = {160, 160, 160}},
    {label = "Brown", value = 56, hex = "#847232", rgb = {132, 114, 50}},
    {label = "East Bay", value = 58, hex = "#4B4175", rgb = {75, 65, 117}},
    {label = "Red", value = 59, hex = "#E13B3B", rgb = {225, 59, 59}},
    {label = "Yellow Orange", value = 60, hex = "#F0CB58", rgb = {240, 203, 88}},
    {label = "Mulberry Pink", value = 61, hex = "#CD3F98", rgb = {205, 63, 152}},
    {label = "Alto Gray", value = 62, hex = "#CFCFCF", rgb = {207, 207, 207}},
    {label = "Jelly Bean Blue", value = 63, hex = "#276A9F", rgb = {39, 106, 159}},
    {label = "Deep red", value = 76, hex = "#782323", rgb = {120, 35, 35}},
    {label = "Oracle Blue #2", value = 78, hex = "#3A6479", rgb = {58, 100, 121}},
    {label = "Orange #3", value = 81, hex = "#F2A40C", rgb = {242, 164, 12}},
    {label = "Light Green #3", value = 82, hex = "#A4CCAA", rgb = {164, 204, 170}},
    {label = "Purple", value = 83, hex = "#A854F2", rgb = {168, 84, 242}},
}