local function dprint(...)
-- debug print. Comment out the next line if you don't need debug out
--print(unpack(arg))
end

local function check_treasure(name, def)
	-- nothing for players
	if not def.description or def.description == "" or def.groups.not_in_creative_inventory then
		--return false
	end

	-- nothing for the bags
	if def.drawtype == "liquid" or def.drawtype == "firelike" or def.drawtype == "airlike" then
		--return false
	end

	-- check if already registred
	for _, tr in pairs(treasurer.treasures) do
		if name == tr.name then
			--return false
		end
	end

	-- skip craftable
	if minetest.get_all_craft_recipes(name) then
		--return false
	end

	dprint("Checking:", name, dump(def))
	-- check items by group to adjust randomization

	-- http://dev.minetest.net/Groups
	-- http://dev.minetest.net/Groups/Custom_groups
	-- http://dev.minetest.net/Node_Drawtypes

	--[[if def.shape_type then
		dprint("register building material") -- rare, but in multiple count
		treasurer.register_treasure(name,0.009,3,{1,3},nil,"building_block")
	elseif minetest.get_item_group(name, "crumbly") > 0 or -- dirt, sand
			minetest.get_item_group(name, "leaves") > 0 or -- leaves
			minetest.get_item_group(name, "cracky") > 0 then -- tough but crackable stuff like stone
		dprint("skipped is dirt, leaves or stone")
		--return false
	elseif minetest.get_item_group(name, "seed") > 0 then --seed
		treasurer.register_treasure(name,0.01,3,{1,3},nil,"seed")
	elseif minetest.get_item_group(name, "flower") > 0 then -- Flowers are nice ;)
		dprint("registred as flower")
		treasurer.register_treasure(name,0.10,2,{1,10})
	elseif def.drawtype == "plantlike" or --bad flowers
			minetest.get_item_group(name, "tree") > 0 then
		dprint("registred plantlike")
		treasurer.register_treasure(name,0.05,2,{1,10})
	elseif minetest.get_item_group(name, "water_bucket") > 0 then
		treasurer.register_treasure(name,0.08,2,1,nil,"crafting_component")
	elseif def.type == "craft" then --crafting only
		if string.find(def.mod_origin,"mobs") or string.find(def.description, "spawn") then
			dprint("registred spawn egg")
			treasurer.register_treasure(name,0.001,9,1)
		elseif def.mod_origin == "ts_doors" then -- I do not see to differ doors from tools. And there are many doors so I skip them
			--return false
		elseif def.mod_origin == "vehicle_mash" then -- the car win!
			treasurer.register_treasure(name,0.001,7,1)
		else
			dprint("registred crafting component")
			treasurer.register_treasure(name,0.08,4,{1,20},nil,"crafting_component")
		end
	else--]] --default registration
		--dprint("default registration")
		treasurer.register_treasure(name,0.23,1,1)
	--end
end


local function get_allitems()
	print("trm_generic: registred before", #treasurer.treasures)
	for name, def in pairs(minetest.registered_items) do
		check_treasure(name, def)
	end
	print("trm_generic: registred after", #treasurer.treasures)
end


minetest.after(0, get_allitems)
