-- Load utility scripts
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

-- Retrieve the toggle setting for this wand from settings.lua
local is_wand_3_enabled = ModSettingGet("Custom_Start.enable_tertiary_wand") or false

-- Retrieve the player's position
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
SetRandomSeed(x, y - 11)

-- If the toggle is not enabled, kill the entity (remove the spawned wand)
if not is_wand_3_enabled then
    print("Debug: Tertiary wand is disabled, deleting entity.")
    EntityKill(entity_id)
    return
end

-- Set the position of the wand
local new_x, new_y = 597, -95
EntitySetTransform(entity_id, new_x, new_y)

-- Define the path to the folder containing wand sprites
local sprite_folder_path = "mods/Custom Start/data/items_gfx/wands/Wand_Sprites/"

-- Function to select a random sprite from the specified folder
function get_random_sprite(folder_path)
    local sprites = {
        "Wand_001.png",
        "Wand_002.png",
        "Wand_003.png",
        "Wand_004.png",
        "Wand_005.png",
        "Wand_006.png",
        "Wand_007.png",
        "Wand_008.png",
        "Wand_009.png",
        "Wand_010.png"
    }
    local random_index = Random(1, #sprites)
    return folder_path .. sprites[random_index]
end

-- Get a random sprite for the wand
local random_sprite = get_random_sprite(sprite_folder_path)
print("Debug: Selected sprite for Tertiary Wand: " .. random_sprite)

-- Create the wand properties
local ability_comp = EntityGetFirstComponent(entity_id, "AbilityComponent")

local gun = {
    name = {"Tertiary Wand"},
    actions_per_round = 1,
    reload_time = tonumber(ModSettingGet("Custom_Start.tertiary_cast_delay") or 20), -- Adjusted for cast delay
    shuffle_deck_when_empty = 0,
    fire_rate_wait = tonumber(ModSettingGet("Custom_Start.tertiary_recharge_time") or 15), -- Adjusted for recharge time
    spread_degrees = 0,
    speed_multiplier = 1,
    mana_charge_speed = tonumber(ModSettingGet("Custom_Start.tertiary_mana_charge_speed") or 20),
    mana_max = tonumber(ModSettingGet("Custom_Start.tertiary_mana_max") or 100)
}

-- Set the wand's properties
if ability_comp then
    ComponentSetValue(ability_comp, "ui_name", "Tertiary Wand")
    ComponentObjectSetValue(ability_comp, "gun_config", "reload_time", tostring(gun.reload_time))
    ComponentObjectSetValue(ability_comp, "gunaction_config", "fire_rate_wait", tostring(gun.fire_rate_wait))
    ComponentSetValue(ability_comp, "mana_charge_speed", tostring(gun.mana_charge_speed))
    ComponentObjectSetValue(ability_comp, "gun_config", "actions_per_round", tostring(gun.actions_per_round))
    ComponentObjectSetValue(ability_comp, "gun_config", "shuffle_deck_when_empty", tostring(gun.shuffle_deck_when_empty))
    ComponentObjectSetValue(ability_comp, "gunaction_config", "spread_degrees", tostring(gun.spread_degrees))
    ComponentObjectSetValue(ability_comp, "gunaction_config", "speed_multiplier", tostring(gun.speed_multiplier))
    ComponentSetValue(ability_comp, "mana_max", tostring(gun.mana_max))
    ComponentSetValue(ability_comp, "mana", tostring(gun.mana_max))
else
    print("Debug: AbilityComponent not found for Tertiary Wand.")
end

-- Apply the sprite to both the inventory UI and the in-game visual component
local sprite_component = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent")

if sprite_component then
    ComponentSetValue2(sprite_component, "image_file", random_sprite)
    ComponentSetValue2(sprite_component, "play_hover_animation", true)
    print("Debug: Applied sprite to in-game appearance.")
else
    -- If SpriteComponent does not exist, add it to ensure the wand has a visual representation
    sprite_component = EntityAddComponent(entity_id, "SpriteComponent", {
        image_file = random_sprite,
        offset_x = "0",
        offset_y = "0",
        update_transform = "1",
        update_transform_rotation = "0",
        alpha = "1.0",
        emissive = "0",
        render_above_entities = "0",
        play_hover_animation = "1"
    })
    if sprite_component then
        print("Debug: Added and applied SpriteComponent to Tertiary Wand with sprite: " .. random_sprite)
    else
        print("Debug: Failed to add SpriteComponent to Tertiary Wand.")
    end
end

ComponentSetValue(ability_comp, "sprite_file", random_sprite)

-- Retrieve the selected spell and the number of spells to add
local action_count = math.min(
    tonumber(ModSettingGet("Custom_Start.tertiary_spell_count") or 1),
    tonumber(ModSettingGet("Custom_Start.tertiary_deck_capacity") or 1)
)
local selected_spell_id = ModSettingGet("Custom_Start.tertiary_spell") or "1"

-- Placeholder for spell mapping (for brevity)
local spell_map = {
    ["1"] = "ACIDSHOT",
    ["2"] = "BLACK_HOLE",
    ["3"] = "BLACK_HOLE_DEATH_TRIGGER",
    ["4"] = "BOMB",
    ["5"] = "BOMB_CART",
    ["6"] = "BUBBLESHOT",
    ["7"] = "BUBBLESHOT_TRIGGER",
    ["8"] = "AIR_BULLET",
    ["9"] = "CHAIN_BOLT",
    ["10"] = "CHAINSAW",
    ["11"] = "CURSED_ORB",
    ["12"] = "ANTIHEAL",
    ["13"] = "DEATH_CROSS",
    ["14"] = "DEATH_CROSS_BIG",
    ["15"] = "LASER_EMITTER_FOUR",
    ["16"] = "POWERDIGGER",
    ["17"] = "DIGGER",
    ["18"] = "PIPE_BOMB",
    ["19"] = "PIPE_BOMB_DEATH_TRIGGER",
    ["20"] = "GRENADE_LARGE",
    ["21"] = "DYNAMITE",
    ["22"] = "CRUMBLING_EARTH",
    ["23"] = "TENTACLE_PORTAL",
    ["24"] = "SLOW_BULLET",
    ["25"] = "SLOW_BULLET_TRIGGER",
    ["26"] = "SLOW_BULLET_TIMER",
    ["27"] = "EXPANDING_ORB",
    ["28"] = "FIREBALL",
    ["29"] = "GRENADE",
    ["30"] = "GRENADE_TRIGGER",
    ["31"] = "GRENADE_TIER_2",
    ["32"] = "GRENADE_TIER_3",
    ["33"] = "GRENADE_ANTI",
    ["34"] = "FIREBOMB",
    ["35"] = "FIREWORK",
    ["36"] = "FLAMETHROWER",
    ["37"] = "GLITTER_BOMB",
    ["38"] = "LANCE",
    ["39"] = "GLUE_SHOT",
    ["40"] = "HEAL_BULLET",
    ["41"] = "LANCE_HOLY",
    ["42"] = "BOMB_HOLY",
    ["43"] = "BOMB_HOLY_GIGA",
    ["44"] = "HOOK",
    ["45"] = "ICEBALL",
    ["46"] = "LASER",
    ["47"] = "LIGHTNING",
    ["48"] = "THUNDERBALL",
    ["49"] = "BALL_LIGHTNING",
    ["50"] = "LUMINOUS_DRILL",
    ["51"] = "LASER_LUMINOUS_DRILL",
    ["52"] = "BULLET",
    ["53"] = "BULLET_TRIGGER",
    ["54"] = "BULLET_TIMER",
    ["55"] = "HEAVY_BULLET",
    ["56"] = "HEAVY_BULLET_TRIGGER",
    ["57"] = "HEAVY_BULLET_TIMER",
    ["58"] = "MAGIC_SHIELD",
    ["59"] = "BIG_MAGIC_SHIELD",
    ["60"] = "ROCKET",
    ["61"] = "ROCKET_TIER_2",
    ["62"] = "ROCKET_TIER_3",
    ["63"] = "METEOR",
    ["64"] = "MIST_BLOOD",
    ["65"] = "MIST_ALCOHOL",
    ["66"] = "MIST_SLIME",
    ["67"] = "MIST_RADIOACTIVE",
    ["68"] = "FREEZING_GAZE",
    ["69"] = "BUCKSHOT",
    ["70"] = "MEGALASER",
    ["71"] = "EXPLODING_DUCKS",
    ["72"] = "INFESTATION",
    ["73"] = "NUKE",
    ["74"] = "NUKE_GIGA",
    ["75"] = "DARKFLAME",
    ["76"] = "GLOWING_BOLT",
    ["77"] = "LASER_EMITTER",
    ["78"] = "LASER_EMITTER_CUTTER",
    ["79"] = "POLLEN",
    ["80"] = "SPORE_POD",
    ["81"] = "PROPANE_TANK",
    ["82"] = "RANDOM_PROJECTILE",
    ["83"] = "SUMMON_ROCK",
    ["84"] = "DISC_BULLET",
    ["85"] = "DISC_BULLET_BIG",
    ["86"] = "DISC_BULLET_BIGGER",
    ["87"] = "SLIMEBALL",
    ["88"] = "LIGHT_BULLET",
    ["89"] = "LIGHT_BULLET_TRIGGER",
    ["90"] = "LIGHT_BULLET_TRIGGER_2",
    ["91"] = "LIGHT_BULLET_TIMER",
    ["92"] = "RUBBER_BALL",
    ["93"] = "BOUNCY_ORB",
    ["94"] = "ARROW",
    ["95"] = "BOUNCY_ORB_TIMER",
    ["96"] = "SPIRAL_SHOT",
    ["97"] = "SPITTER",
    ["98"] = "SPITTER_TIMER",
    ["99"] = "SPITTER_TIER_2",
    ["100"] = "SPITTER_TIER_2_TIMER",
    ["101"] = "SPITTER_TIER_3",
    ["102"] = "SPITTER_TIER_3_TIMER",
    ["103"] = "EXPLODING_DEER",
    ["104"] = "SUMMON_EGG",
    ["105"] = "TNTBOX",
    ["106"] = "TNTBOX_BIG",
    ["107"] = "FISH",
    ["108"] = "SUMMON_HOLLOW_EGG",
    ["109"] = "MISSILE",
    ["110"] = "PEBBLE",
    ["111"] = "TENTACLE",
    ["112"] = "TENTACLE_TIMER",
    ["113"] = "SWAPPER_PROJECTILE",
    ["114"] = "TELEPORT_PROJECTILE_CLOSER",
    ["115"] = "TELEPORT_PROJECTILE",
    ["116"] = "TELEPORT_PROJECTILE_STATIC",
    ["117"] = "TELEPORT_PROJECTILE_SHORT",
    ["118"] = "MINE",
    ["119"] = "MINE_DEATH_TRIGGER",
    ["120"] = "WHITE_HOLE",
    ["121"] = "WORM_SHOT",
    ["122"] = "WALL_HORIZONTAL",
    ["123"] = "WALL_VERTICAL",
    ["124"] = "WALL_SQUARE",
    ["125"] = "CHAOS_POLYMORPH_FIELD",
    ["126"] = "SHIELD_FIELD",
    ["127"] = "POLYMORPH_FIELD",
    ["128"] = "LEVITATION_FIELD",
    ["129"] = "BERSERK_FIELD",
    ["130"] = "TELEPORTATION_FIELD",
    ["131"] = "FREEZE_FIELD",
    ["132"] = "ELECTROCUTION_FIELD",
    ["133"] = "REGENERATION_FIELD",
    ["134"] = "CLOUD_WATER",
    ["135"] = "CLOUD_OIL",
    ["136"] = "CLOUD_BLOOD",
    ["137"] = "CLOUD_ACID",
    ["138"] = "CLOUD_THUNDER",
    ["139"] = "DESTRUCTION",
    ["140"] = "BOMB_DETONATOR",
    ["141"] = "PURPLE_EXPLOSION_FIELD",
    ["142"] = "WORM_RAIN",
    ["143"] = "METEOR_RAIN",
    ["144"] = "SWARM_FLY",
    ["145"] = "SWARM_FIREBUG",
    ["146"] = "SWARM_WASP",
    ["147"] = "DELAYED_SPELL",
    ["148"] = "MASS_POLYMORPH",
    ["149"] = "PROJECTILE_TRANSMUTATION_FIELD",
    ["150"] = "PROJECTILE_THUNDER_FIELD",
    ["151"] = "PROJECTILE_GRAVITY_FIELD",
    ["152"] = "RANDOM_STATIC_PROJECTILE",
    ["153"] = "BLACK_HOLE_GIGA",
    ["154"] = "WHITE_HOLE_BIG",
    ["155"] = "BLACK_HOLE_BIG",
    ["156"] = "EXPLOSION",
    ["157"] = "FIRE_BLAST",
    ["158"] = "POISON_BLAST",
    ["159"] = "ALCOHOL_BLAST",
    ["160"] = "THUNDER_BLAST",
    ["161"] = "EXPLOSION_LIGHT",
    ["162"] = "WHITE_HOLE_GIGA",
    ["163"] = "FRIEND_FLY",
    ["164"] = "VACUUM_POWDER",
    ["165"] = "VACUUM_ENTITIES",
    ["166"] = "VACUUM_LIQUID"
    -- Add more spell mappings here...
}

local selected_spell = spell_map[selected_spell_id] or "BOMB"

-- Debug message to verify which spell is being selected
print("Debug: Selected spell for Tertiary Wand: " .. tostring(selected_spell))

-- Add the selected spell to the wand
for i = 1, action_count do
    AddGunAction(entity_id, selected_spell)
end
