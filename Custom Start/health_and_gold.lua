-- health_and_gold.lua

-- Desired initial health value (adjust this as needed)
local desired_health = 100  -- Adjust this to your preferred health value

-- Function to set the player's health to the desired value
function set_initial_health(entity_id)
    local damagemodel = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
    if damagemodel ~= nil then
        -- Set the max HP and the current HP to the desired value
        ComponentSetValue2(damagemodel, "max_hp", desired_health)
        ComponentSetValue2(damagemodel, "hp", desired_health)
    end
end

-- Ensure the function is called when the player is initialized
local player_entity = EntityGetWithTag("player_unit")[1]
if player_entity then
    set_initial_health(player_entity)
end
