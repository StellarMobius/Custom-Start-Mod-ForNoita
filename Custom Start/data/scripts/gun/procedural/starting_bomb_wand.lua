-- Load utility scripts
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

function spell_action()
    local spell = tostring(ModSettingGet("Custom_Start.secondary_spell") or "1")
    local spell_map = {
        ["1"] = "DYNAMITE",
        ["2"] = "BOMB",
        ["3"] = "BOMB_CART",
        ["4"] = "PROPANE_TANK",
        ["5"] = "TNTBOX",
        ["6"] = "TNTBOX_BIG",
        ["7"] = "BOMB_HOLY",
        ["8"] = "NUKE",
        ["9"] = "FIREBOMB",
        ["10"] = "GRENADE",
        ["11"] = "GRENADE_ANTI",
        ["12"] = "GRENADE_TRIGGER",
        ["13"] = "GRENADE_LARGE",
        ["14"] = "GRENADE_TIER_2",
        ["15"] = "GRENADE_TIER_3",
        ["16"] = "MINE",
        ["17"] = "MINE_DEATH_TRIGGER",
        ["18"] = "PIPE_BOMB",
        ["19"] = "PIPE_BOMB_DEATH_TRIGGER",
        ["20"] = "ROCKET",
        ["21"] = "ROCKET_TIER_2",
        ["22"] = "ROCKET_TIER_3",
        ["23"] = "MISSILE"
        -- Add more mappings as needed.
    }

    local selected_spell = spell_map[spell] or "BOMB" -- Default to "BOMB" if not found
    print("Debug: Selected spell for bomb wand: " .. tostring(selected_spell))
    return selected_spell
end

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
SetRandomSeed(x - 1, y)

local ability_comp = EntityGetFirstComponent(entity_id, "AbilityComponent")

local gun = {
    name = {"Bomb Wand"},
    actions_per_round = 1,
    reload_time = tonumber(ModSettingGet("Custom_Start.secondary_cast_delay") or 20), -- Adjusted for cast delay
    shuffle_deck_when_empty = 1,
    fire_rate_wait = tonumber(ModSettingGet("Custom_Start.secondary_recharge_time") or 15), -- Adjusted for recharge time
    spread_degrees = 0,
    speed_multiplier = 1,
    mana_charge_speed = tonumber(ModSettingGet("Custom_Start.secondary_mana_charge_speed") or 20),
    mana_max = tonumber(ModSettingGet("Custom_Start.secondary_mana_max") or 100)
}

-- Set the wand's properties
ComponentSetValue(ability_comp, "ui_name", "Bomb Wand")
ComponentObjectSetValue(ability_comp, "gun_config", "reload_time", tostring(gun.reload_time))
ComponentObjectSetValue(ability_comp, "gunaction_config", "fire_rate_wait", tostring(gun.fire_rate_wait))
ComponentSetValue(ability_comp, "mana_charge_speed", tostring(gun.mana_charge_speed))
ComponentObjectSetValue(ability_comp, "gun_config", "actions_per_round", tostring(gun.actions_per_round))
ComponentObjectSetValue(ability_comp, "gun_config", "shuffle_deck_when_empty", tostring(gun.shuffle_deck_when_empty))
ComponentObjectSetValue(ability_comp, "gunaction_config", "spread_degrees", tostring(gun.spread_degrees))
ComponentObjectSetValue(ability_comp, "gunaction_config", "speed_multiplier", tostring(gun.speed_multiplier))
ComponentSetValue(ability_comp, "mana_max", tostring(gun.mana_max))
ComponentSetValue(ability_comp, "mana", tostring(gun.mana_max))

-- Add the selected spell to the wand
local action_count = math.min(
    tonumber(ModSettingGet("Custom_Start.secondary_spell_count") or 1),
    tonumber(ModSettingGet("Custom_Start.secondary_deck_capacity") or 1)
)

for i = 1, action_count do
    AddGunAction(entity_id, spell_action())
end
