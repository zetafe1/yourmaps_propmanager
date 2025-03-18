Config = {}

Config.Zones = {
    {
        name = "DELETE PROPS TEST WAGON VAL", 
        height = 20, 
        polyzone = { 
            {x = -332.0286, y = 818.6135, z = 117.5874},
            {x = -330.5692, y = 826.1956, z = 117.9967},
            {x = -324.5566, y = 825.6779, z = 118.4437},
            {x = -326.9659, y = 817.7468, z = 117.7001},
        },
        outerZoneDistance = 50.0, 
        deleteAll = true, 
        objects = { 
            {
                model = `s_wagonparked01x`,
                coords = {x = -327.8159, y = 822.6702, z = 116.9792},
                distance = 10.0
            },
            {
                model = `p_floursackstack02x`,
                coords = {x = -328.5218, y = 821.0494, z = 118.1592},
                distance = 10.0
            },
            {
                model = `p_bucket03x`,
                coords = {x = -327.0702, y = 823.3459, z = 117.1584},
                distance = 10.0
            },
        }
    },
    {
        name = "DELETE PROPS TEST WATER VAL", 
        height = 20, 
        polyzone = { 
            {x = -310.0087, y = 827.3268, z = 119.5516},
            {x = -314.4506, y = 826.5724, z = 119.4093},
            {x = -316.6091, y = 830.8356, z = 119.1890},
            {x = -311.8716, y = 832.5375, z = 119.5608},
        },
        outerZoneDistance = 50.0, 
        deleteAll = true, 
        objects = { 
            {
                model = `p_watertrough01x`,
                coords = {x = -313.1519, y = 829.1815, z = 118.4938},
                distance = 10.0
            },
        }
    },
    {
        name = "DELETE PROPS TEST SALOON VAL MLO", 
        height = 20, 
        polyzone = { 
            {x = -310.0007, y = 805.9210, z = 118.9796},
            {x = -308.1084, y = 806.2673, z = 118.9796},
            {x = -306.7399, y = 803.5799, z = 118.9788},
            {x = -309.5346, y = 802.9152, z = 118.9795},
        },
        outerZoneDistance = 50.0, 
        deleteAll = true, 
        objects = { 
            {
                model = `p_furnace01x`,
                coords = {x = -308.6759, y = 804.7166, z = 117.9824, h = 189.4987},
                distance = 10.0
            },
        }
    },
}
