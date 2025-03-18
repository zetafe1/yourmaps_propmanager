Config = {}

Config.DeletingZones = {
    {
        name = "DELETE PROPS TEST WAGON VAL", --- to delete all props inside polyzone
        height = 20, 
        deleteAll = true,
        outerZoneDistance = 50.0, 
        polyzone = { 
            vec3(-325.3065, 825.7692, 118.3944),
            vec3(-332.8815, 824.8253, 117.7589),
            vec3(-330.8560, 817.0329, 117.4958),
            vec3(-325.6482, 819.3895, 117.8933),
        }
    },
    {
        name = "DELETE PROPS TEST SALOON VAL MLO", --- to delete one specific props make delete all = false and tell the script which prop and where
        height = 20, 
        deleteAll = false,
        outerZoneDistance = 50.0, 
        polyzone = { 
            vec3(-310.0007, 805.9210, 118.9796),
            vec3(-308.1084, 806.2673, 118.9796),
            vec3(-306.7399, 803.5799, 118.9788),
            vec3(-309.5346, 802.9152, 118.9795),
        },
        objects = { 
            {
                model = `p_furnace01x`,
                coords = vec3(-308.6759, 804.7166, 117.9824),
                distance = 10.0
            },
        }
    },
}

Config.SpawningZones = {
    {
        name = "CHAIR SALOON VAL MLO", --- adding prop inside mlo instance
        height = 20,
        polyzone = { 
            vec3(-311.6527, 806.6274, 118.9800),
            vec3(-309.1632, 806.7526, 118.9795),
            vec3(-309.4609, 803.8412, 118.9795),
            vec3(-311.3997, 803.6340, 118.9800),
        },
        spawnObjects = { 
            {
                model = `p_chair06x`,
                coords = vec3(-310.605133, 805.131897, 117.983551),
                rotation = vec3(0.0, 0.0, 179.405502),
            },
        }
    },
    {
        name = "OAK TREE VALENTINE", --- adding tree with collision into the world
        height = 20,
        polyzone = { 
            vec3(-272.2913, 777.9733, 116.9161),
            vec3(-275.6877, 802.0674, 116.9161),
            vec3(-253.8508, 811.8986, 116.9161),
            vec3(-245.3607, 787.2230, 116.9161), 
        },
        spawnObjects = { 
            {
                model = `p_tree_orange_01`,
                coords = vec3(-264.741852,793.701965,116.93),
                rotation = vec3(4.174147,1.846838,-123.073624),
            },
        }
    }
} 
