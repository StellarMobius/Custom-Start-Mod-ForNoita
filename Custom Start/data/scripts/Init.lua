dofile("mods/Custom Start/MOUSE POSITION.lua")

function OnPlayerSpawned(player_entity)
    local x, y = EntityGetTransform(player_entity)

    -- Coordinates for altars
    local wand_3_altar_x, wand_3_altar_y = 587, -108
    local wand_4_altar_x, wand_4_altar_y = 625, -108

    -- Coordinates for wands (adjust these as needed for precise placement)
    local wand_3_x, wand_3_y = 592, -112  -- Adjust as needed for the third wand
    local wand_4_x, wand_4_y = 632 , -112  -- Adjust as needed for the fourth wand

    -- Load the wand altar for wand 3
    local altar_3 = EntityLoad("mods/Custom Start/data/entities/wand_altar.xml", wand_3_altar_x, wand_3_altar_y)
    if altar_3 then
        print("Wand altar 3 loaded successfully at (" .. wand_3_altar_x .. ", " .. wand_3_altar_y .. ")")
    else
        print("Failed to load wand altar 3")
    end

    -- Load the wand altar for wand 4
    local altar_4 = EntityLoad("mods/Custom Start/data/entities/wand_altar.xml", wand_4_altar_x, wand_4_altar_y)
    if altar_4 then
        print("Wand altar 4 loaded successfully at (" .. wand_4_altar_x .. ", " .. wand_4_altar_y .. ")")
    else
        print("Failed to load wand altar 4")
    end

    -- Check if the third wand should be loaded
    local wand_3_enabled = ModSettingGet("Custom_Start.enable_tertiary_wand") or false
    if wand_3_enabled then
        local wand_003 = EntityLoad("mods/Custom Start/data/items_gfx/wands/wand_003.xml", wand_3_x, wand_3_y)
        if wand_003 then
            local item_component = EntityGetFirstComponentIncludingDisabled(wand_003, "ItemComponent")
            if item_component then
                ComponentSetValue2(item_component, "play_hover_animation", true)
            end
            print("Third wand loaded successfully at (" .. wand_3_x .. ", " .. wand_3_y .. ").")
        else
            print("Failed to load third wand: wand_003.xml not found")
        end
    else
        print("Third wand is disabled in settings, not loading.")
    end

    -- Check if the fourth wand should be loaded
    local wand_4_enabled = ModSettingGet("Custom_Start.enable_quaternary_wand") or false
    if wand_4_enabled then
        local wand_004 = EntityLoad("mods/Custom Start/data/items_gfx/wands/wand_004.xml", wand_4_x, wand_4_y)
        if wand_004 then
            local item_component = EntityGetFirstComponentIncludingDisabled(wand_004, "ItemComponent")
            if item_component then
                ComponentSetValue2(item_component, "play_hover_animation", true)
            end
            print("Fourth wand loaded successfully at (" .. wand_4_x .. ", " .. wand_4_y .. ").")
        else
            print("Failed to load fourth wand: wand_004.xml not found")
        end
    else
        print("Fourth wand is disabled in settings, not loading.")
    end
end
