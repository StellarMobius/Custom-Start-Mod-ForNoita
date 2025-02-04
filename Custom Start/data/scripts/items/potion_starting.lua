dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/items/init_potion.lua")
-- NOTE( Petri ): 
-- There is a mods/nightmare potion.lua which overwrites this one.


function potion_a_materials()


	local num = tonumber(ModSettingGet("Copis_CYOL.starting_flask"))
	GamePrint(num)
	if(num == 1) then return "mud"
	elseif(num == 2) then return "water_swamp"
	elseif(num == 3) then return "water_salt"
	elseif(num == 4) then return "Swamp"
	elseif(num == 5) then return "snow"
	elseif(num == 6) then return "water"
	elseif(num == 7) then return "blood"
	elseif(num == 8) then return "acid"
	elseif(num == 9) then return "magic_liquid_polymorph"
	elseif(num == 10) then return "magic_liquid_random_polymorph"
	elseif(num == 11) then return "magic_liquid_berserk"
	elseif(num == 12) then return "magic_liquid_charm"
	elseif(num == 13) then return "magic_liquid_movement_faster"
	elseif(num == 14) then return "urine"
	elseif(num == 15) then return "gold"
	elseif(num == 16) then return "slime"
	elseif(num == 17) then return "gunpowder_unstable"
	elseif(num == 18) then return "sima"
	elseif(num == 19) then return "magic_liquid_faster_levitation_and_movement"
	elseif(num == 20) then return "magic_liquid_hp_regeneration"
	elseif(num == 21) then return "magic_liquid_hp_regeneration_unstable"
	elseif(num == 22) then return "midas"
	elseif(num == 23) then return "rat_powder"
	elseif(num == 24) then return "pea_soup"
	elseif(num == 25) then return "cheese_static"
	end

	--[[
	local r_value = Random( 1, 100 )
	if( r_value <= 65 ) then
		r_value = Random( 1, 100 )

		if( r_value <= 10 ) then return "mud" end
		if( r_value <= 20 ) then return "water_swamp" end
		if( r_value <= 30 ) then return "water_salt" end
		if( r_value <= 40 ) then return "swamp" end
		if( r_value <= 50 ) then return "snow" end

		return "water"
	elseif( r_value <= 70 ) then
		return "blood"
	elseif( r_value <= 99 ) then
		r_value = Random( 0, 100 )
		return random_from_array( { "acid", "magic_liquid_polymorph", "magic_liquid_random_polymorph", "magic_liquid_berserk", "magic_liquid_charm","magic_liquid_movement_faster" } )
	else
		-- one in a million shot
		r_value = Random( 0, 100000 )
		if( r_value == 666 ) then return "urine" end
		if( r_value == 79 ) then return "gold" end 
		return random_from_array( { "slime", "gunpowder_unstable" } )
	end

	]]--
end


function init( entity_id )
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y ) -- so that all the potions will be the same in every position with the same seed
	local potion_material = "water"

	local n_of_deaths = tonumber( StatsGlobalGetValue("death_count") )
	if( n_of_deaths >= 1 ) then

		potion_material = potion_a_materials()
	end


	--[[
	local year,month,day = GameGetDateAndTimeLocal()

	if ((( month == 5 ) and ( day == 1 )) or (( month == 4 ) and ( day == 30 ))) and (Random( 0, 100 ) <= 20) then
		potion_material = "sima"
	end
	]]--


	init_potion( entity_id, potion_material )
end

