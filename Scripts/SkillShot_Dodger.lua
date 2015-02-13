--[[

	-------------------------------------
	    | SkillShot Dodger by Moones |
	-------------------------------------
	============ Version 1.2 ============
	 
	Description:
	------------
	
		Auto Dodge of any SkillShot:
			 - This script tries to move perpendicular to avid any skillshot.
			 - Only abilities with green color in list are dodged when casted from fog.
			 - It checks if given Skillshot will hit you and if it is not blocked by any unit.
			 - If you cannot dodge SkillShot with your movespeed it will use leap abilities.
			 - You can enable/disable dodging of any skillshot in Scripts/config/Skillshot_dodger.txt file.
			
	Changelog:
	----------
	
		Update 1.2:
			Added:
				Clockwerk - Rocket Flare
				Lina - Light Strike Array
				Leshrac - Split Earth
				Pugna - Nether Blast
				Skywrath Mage - Mystic Flare
				Invoker - EMP
				Ancient Apparition - Ice Blast
				Shadow Fiend - Shadow Raze
				Invoker - Sun Strike
				Kunkka - Torrent
				
			- More abilities will be now dodged when casted from fog, these will be marked with green color.
			- Added AOE dodge calculation
	
		Update 1.1:
			Added:
				Jakiro - Ice Path
				Tiny - Avalanche
				Invoker - Chaos Meteor
				Invoker - Deafening Blast
				Invoker - Tornado
				Shadow Demon - Shadow Poison
				Magnus - Skewer
				Meepo - Earthbind
				Spectre - Spectral Dagger
				Timbersaw - Timber Chain
				Timbersaw - Chakram
				Weaver - The Swarm
				Jakiro - Dual Breath
				Venomancer - Venomous gale
				VengefulSpirit - Wave Of Terror
				Jakiro - Macropyre
				Elder Titan - Earth Splitter
				Beastmaster - Wild Axes
				Slark - Pounce
				Earth Spirit - Boulder Smash
				Earth Spirit - Rolling Boulder
				Batrider - Flamebreak
				
			- When you cannot dodge Skillshot with your movespeed it will use leap abilities.
			- Improved performance
			- Added options to disable/enable dodging of each skillshot.

			
]]--

require("libs.Utils")
require("libs.VectorOp")
require("libs.SkillShot")
require("libs.ScriptConfig")
require("libs.HeroInfo")

local reg = false local start, vec = nil, nil local dodgevector = nil local dodging = false local dodged = false local dodgingname = nil local config = ScriptConfig.new() local count = 0

local LineSkillShotList = {
	{ 
		spellName = "pudge_meat_hook";
		heroId = CDOTA_Unit_Hero_Pudge;
		distance = "hook_distance";
		radius = "hook_width";
		speed = "hook_speed";
		block = true;
		team = true;
		cdodge = true;
	};	
	{ 
		spellName = "windrunner_powershot";
		heroId = CDOTA_Unit_Hero_Windrunner;
		distance = "arrow_range";
		speed = "arrow_speed";
		radius = "arrow_width";
		entity = true;
		dayvision = 800;
	};	 
	{
		spellName = "mirana_arrow";
		heroId = CDOTA_Unit_Hero_Mirana;
		distance = "arrow_range";
		radius = "arrow_width";
		speed = "arrow_speed";
		block = true;
		team = "ally";
		cdodge = true;
		entity = true;
		dayvision = 650;
	};
	{
		spellName = "nyx_assassin_impale";
		heroId = CDOTA_Unit_Hero_Nyx_Assassin;
		distance = "length";
		radius = "width";
		speed = "speed";
		cdodge = true;
	};
	{ 
		spellName = "lion_impale";
		heroId = CDOTA_Unit_Hero_Lion;
		distance = "length";
		radius = "width";
		cdodge = true;
		speed = "speed";
	};
	{ 
		spellName = "death_prophet_carrion_swarm";
		heroId = CDOTA_Unit_Hero_DeathProphet;
		distance = "range";
		radius = "end_radius";
		speed = "speed";
	};
	{ 
		spellName = "magnataur_shockwave";
		heroId = CDOTA_Unit_Hero_Magnataur;
		distance = "shock_distance";
		radius = "shock_width";
		speed = "shock_speed";
	};
	{ 
		spellName = "rattletrap_hookshot";
		heroId = CDOTA_Unit_Hero_Rattletrap;
		distance = "tooltip_range";
		radius = "latch_radius";
		block = true;
		team = true;
		cdodge = true;
		speed = "speed";
		entity = true;
		dayvision = 100;
		m1 = "modifier_invisible";
	};
	{ 
		spellName = "rattletrap_rocket_flare";
		heroId = CDOTA_Unit_Hero_Rattletrap;
		distance = 22000;
		radius = "radius";
		speed = "speed";
		entity = true;
		dayvision = 600;
	};
	{ 
		spellName = "earthshaker_fissure";
		heroId = CDOTA_Unit_Hero_Earthshaker;
		distance = "fissure_range";
		radius = "fissure_radius";
		cdodge = true;
	};
	{ 
		spellName = "queenofpain_sonic_wave";
		heroId = CDOTA_Unit_Hero_QueenOfPain;
		distance = "distance";
		radius = "final_aoe";
		cdodge = true;
		speed = "speed";
	};
	{ 
		spellName = "tusk_ice_shards";
		heroId = CDOTA_Unit_Hero_Tusk;
		distance = 1500;
		radius = "shard_width";
		cdodge = true;
		speed = "shard_speed";
		entity = true;
		dayvision = 200;
	};
	{ 
		spellName = "puck_illusory_orb";
		heroId = CDOTA_Unit_Hero_Puck;
		distance = "max_distance";
		radius = "radius";
		speed = "orb_speed";
		entity = true;
		dayvision = 800;
		u1 = 59802112;
		m1 = "modifier_truesight";
	};
	{ 
		spellName = "lina_dragon_slave";
		heroId = CDOTA_Unit_Hero_Lina;
		distance = "dragon_slave_distance";
		radius = "dragon_slave_width_initial";
		speed = "dragon_slave_speed";
	};
	{ 
		spellName = "lina_light_strike_array";
		heroId = CDOTA_Unit_Hero_Lina;
		distance = 600;
		radius = "light_strike_array_aoe";
	};
	{ 
		spellName = "leshrac_split_earth";
		heroId = CDOTA_Unit_Hero_Leshrac;
		distance = 750;
		radius = "radius";
	};
	{ 
		spellName = "pugna_nether_blast";
		heroId = CDOTA_Unit_Hero_Pugna;
		distance = 400;
		radius = 200;
	};
	{ 
		spellName = "skywrath_mage_mystic_flare";
		heroId = CDOTA_Unit_Hero_Skywrath_Mage;
		radius = 100;
		distance = 1200;
	};
	{ 
		spellName = "jakiro_ice_path";
		heroId = CDOTA_Unit_Hero_Jakiro;
		distance = 1100;
		cdodge = true;
		radius = "path_radius";
	};
	{ 
		spellName = "tiny_avalanche";
		heroId = CDOTA_Unit_Hero_Tiny;
		distance = 600;
		radius = "radius";
		speed = 0.5;
		cdodge = true;
	};
	{ 
		spellName = "invoker_chaos_meteor";
		heroId = CDOTA_Unit_Hero_Invoker;
		distance = "travel_distance";
		radius = "area_of_effect";
		speed = "travel_speed";
		entity = true;
		dayvision = 500;
	};
	{ 
		spellName = "invoker_deafening_blast";
		heroId = CDOTA_Unit_Hero_Invoker;
		distance = "travel_distance";
		radius = "radius_end";
		speed = "travel_speed";
		cdodge = true;
	};
	{ 
		spellName = "invoker_tornado";
		heroId = CDOTA_Unit_Hero_Invoker;
		distance = "travel_distance";
		radius = "area_of_effect";
		speed = "travel_speed";
		cdodge = true;
		entity = true;
		dayvision = 1200;
	};
	{ 
		spellName = "invoker_emp";
		heroId = CDOTA_Unit_Hero_Invoker;
		distance = 950;
		radius = 300;
	};	
	{ 
		spellName = "shadow_demon_shadow_poison";
		heroId = CDOTA_Unit_Hero_Shadow_Demon;
		distance = 1500;
		radius = "radius";
		speed = "speed";
		entity = true;
		dayvision = 400;
	};
	{ 
		spellName = "magnataur_skewer";
		heroId = CDOTA_Unit_Hero_Magnataur;
		distance = "range";
		radius = "skewer_radius";
		speed = "skewer_speed";
		cdodge = true;
	};
	{ 
		spellName = "meepo_earthbind";
		heroId = CDOTA_Unit_Hero_Meepo;
		distance = "tooltip_range";
		radius = "radius";
		speed = "speed";
		entity = true;
		dayvision = 300;
	};
	{ 
		spellName = "spectre_spectral_dagger";
		heroId = CDOTA_Unit_Hero_Spectre;
		distance = 2000;
		radius = "dagger_radius";
		speed = "speed";
	};
	{ 
		spellName = "shredder_timber_chain";
		heroId = CDOTA_Unit_Hero_Shredder;
		distance = "range";
		radius = "damage_radius";
		speed = "speed";
	};
	{ 
		spellName = "shredder_chakram";
		heroId = CDOTA_Unit_Hero_Shredder;
		distance = 1200;
		radius = "radius";
		speed = "speed";
		entity = true;
		dayvision = 0;
		m1 = "modifier_projectile_vision";
	};
	{ 
		spellName = "weaver_the_swarm";
		heroId = CDOTA_Unit_Hero_Weaver;
		distance = 3000;
		radius = "spawn_radius";
		speed = "speed";
		entity = true;
		dayvision = 100;
	};
	{ 
		spellName = "jakiro_dual_breath";
		heroId = CDOTA_Unit_Hero_Jakiro;
		distance = "range";
		radius = "end_radius";
		speed = "speed";
	};
	{ 
		spellName = "venomancer_venomous_gale";
		heroId = CDOTA_Unit_Hero_Venomancer;
		distance = 800;
		radius = "radius";
		speed = "speed";
		cdodge = true;
	};
	{ 
		spellName = "vengefulspirit_wave_of_terror";
		heroId = CDOTA_Unit_Hero_VengefulSpirit;
		distance = 1400;
		radius = "wave_width";
		speed = "wave_speed";
	};
	{ 
		spellName = "jakiro_macropyre";
		heroId = CDOTA_Unit_Hero_Jakiro;
		distance = "cast_range";
		radius = "path_radius";
		agadistance = "cast_range_scepter";	
		speed = 0.5;
	};
	{ 
		spellName = "elder_titan_earth_splitter";
		heroId = CDOTA_Unit_Hero_ElderTitan;
		distance = "crack_distance";
		radius = "crack_width";
		speed = "speed";
	};
	{ 
		spellName = "beastmaster_wild_axes";
		heroId = CDOTA_Unit_Hero_Beastmaster;
		distance = "range";
		radius = "spread";
	};
	{ 
		spellName = "slark_pounce";
		heroId = CDOTA_Unit_Hero_Slark;
		distance = "pounce_distance";
		radius = "pounce_radius";
		speed = "pounce_speed";
		cdodge = true;
	};
	{ 
		spellName = "earth_spirit_boulder_smash";
		heroId = CDOTA_Unit_Hero_EarthSpirit;
		distance = "rock_distance";
		radius = "radius";
		speed = "speed";
	};
	{ 
		spellName = "earth_spirit_rolling_boulder";
		heroId = CDOTA_Unit_Hero_EarthSpirit;
		distance = "rock_distance";
		radius = "radius";
		speed = "rock_speed";
	};
	{ 
		spellName = "batrider_flamebreak";
		heroId = CDOTA_Unit_Hero_Batrider;
		distance = 1500;
		radius = "explosion_radius";
		speed = "speed";
	};
	{ 
		spellName = "ancient_apparition_ice_blast";
		heroId = CDOTA_Unit_Hero_AncientApparition;
		distance = 22000;
		radius = "radius_min";
		speed = "speed";
		entity = true;
		dayvision = 550;
	};
}	

local AOESkillShotList = {
	{ 
		spellName = "nevermore_shadowraze1";
		heroId = CDOTA_Unit_Hero_Nevermore;
		distance = "shadowraze_range";
		radius = "shadowraze_radius";
		fixedPosition = true;
	};	
	{ 
		spellName = "nevermore_shadowraze2";
		heroId = CDOTA_Unit_Hero_Nevermore;
		distance = "shadowraze_range";
		radius = "shadowraze_radius";
		fixedPosition = true;
	};	
	{ 
		spellName = "nevermore_shadowraze3";
		heroId = CDOTA_Unit_Hero_Nevermore;
		distance = "shadowraze_range";
		radius = "shadowraze_radius";
		fixedPosition = true;
	};
	{ 
		spellName = "lina_light_strike_array";
		heroId = CDOTA_Unit_Hero_Lina;
		radius = "light_strike_array_aoe";
		entity = true;
		m1 = "modifier_lina_light_strike_array";
	};
	{ 
		spellName = "leshrac_split_earth";
		heroId = CDOTA_Unit_Hero_Leshrac;
		radius = "radius";
		entity = true;
		m1 = "modifier_leshrac_split_earth_thinker";
	};
	{ 
		spellName = "invoker_sun_strike";
		heroId = CDOTA_Unit_Hero_Invoker;
		radius = "area_of_effect";
		entity = true;
		m1 = "modifier_invoker_sun_strike";
	};
	{ 
		spellName = "kunkka_torrent";
		heroId = CDOTA_Unit_Hero_Kunkka;
		radius = "radius";
		entity = true;
		m1 = "modifier_kunkka_torrent_thinker";
	};
	{ 
		spellName = "skywrath_mage_mystic_flare";
		heroId = CDOTA_Unit_Hero_Skywrath_Mage;
		radius = 200;
		entity = true;
		m1 = "modifier_skywrath_mage_mystic_flare";
	};
}

local dodgeAbilitiesList = {puck_phase_shift = {target = false, name = "puck_phase_shift"}, slark_pounce = {target = false, name = "slark_pounce"},mirana_leap = {target = false, name = "mirana_leap"},faceless_void_time_walk = {target = true, position = true, name = "faceless_void_time_walk", distance = "tooltip_range"},item_blink = {target = true, position = true, name = "item_blink"} ,item_force_staff = {target = true, name = "item_force_staff"}}
	
function Main(tick)
	if not PlayingGame() or client.console then return end
	
	local player = entityList:GetMyPlayer()
	local me = entityList:GetMyHero()
	
	--Replacing users moving orders to ensure avoid
	if dodgevector and player.orderId and player.orderPosition ~= dodgevector and player.orderPosition ~= Vector(0,0,0) and GetDistance2D(player.orderPosition, dodgevector) > 100 then
		me:Stop()
		me:Move(dodgevector)
	end
	
	--If we already are in dodge position we are good to go
	if me:IsChanneling() or (dodgevector and (isPosEqual(me.position, dodgevector, 5) or GetDistance2D(me,dodgevector) < 100 or count == 3)) then 
		dodgevector = nil
		dodging = false
		dodged = false
		return 	
	end
	
	if not SleepCheck() then return end
	
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team=me:GetEnemyTeam(),alive=true})	
	local cast = entityList:GetEntities({classId=CDOTA_BaseNPC})	
	
	for i,v in ipairs(enemies) do
		if not v:IsIllusion() then
		
			--==LINE SKILLSHOTS==--
			
			for z, skillshot in ipairs(LineSkillShotList) do
				if v.classId == skillshot.heroId or v.classId == CDOTA_Unit_Hero_Rubick then
					local name = skillshot.spellName:gsub("_","")
					if config:GetParameter(name, true) then
						local spell = v:FindSpell(skillshot.spellName)
						if spell and spell.level > 0 then
						
							--Checking by entity
							
							if skillshot.entity and (not dodgingname or dodgingname == skillshot.spellName) then
								local u1, u2, m1 = skillshot.u1 or nil, skillshot.u2 or nil, skillshot.m1 or nil
								local entity = FindEntity(cast,me,skillshot.dayvision,u1,u2,m1)
								if entity and not dodging then
									dodgingname = skillshot.spellName
									if not start then
										start = entity.position
									end
									if entity.visibleToEnemy and not vec then
										vec = entity.position
										if GetDistance2D(vec,start) < 50 then
											vec = nil
										end
									end
									if start and vec then
										local radius
										if type(skillshot.radius) == "string" then
											radius = spell:GetSpecialData(skillshot.radius)
										else
											radius = skillshot.radius
										end
										local team = skillshot.team or nil
										local block = skillshot.block or false
										local speed
										if skillshot.speed then
											if type(skillshot.speed) == "string" then
												speed = spell:GetSpecialData(skillshot.speed,spell.level)
											else
												speed = skillshot.speed
											end
										else
											speed = 0
										end
										local distance = FindAB(start,vec,GetDistance2D(me,start)*10)
										--check for block
										if GetDistance2D(me, start) <= (GetDistance2D(start,distance) + radius + 25) and ((block and WillHit(entity,me,radius,team)) or not block) and GetDistance2D(entity,start) <= GetDistance2D(me,start) then
											--dodge
											LineDodge(distance, start, radius*2.5, me, skillshot.cdodge, speed, 0)
										end
									end
								elseif start then	
									start,vec,entity,dodged,dodging,dodgingname = nil,nil,nil,false,false,nil
								end
							end
							
							--Checking by animations
							
							if v.visible and (spell.abilityPhase or math.ceil(spell.cd) ==  math.ceil(spell:GetCooldown(spell.level))) then
								local radius
								if type(skillshot.radius) == "string" then
									radius = spell:GetSpecialData(skillshot.radius)
								else
									radius = skillshot.radius
								end
								local distance
								local spelllevel = spell.level
								if skillshot.spellName == "invoker_chaos_meteor" or skillshot.spellName == "invoker_tornado" then
									spelllevel = v:GetAbility(2).level
								end
								if type(skillshot.distance) == "string" then
									distance = spell:GetSpecialData(skillshot.distance,spelllevel)
								else
									distance = skillshot.distance
								end
								if v:AghanimState() and skillshot.agadistance then
									distance = spell:GetSpecialData(skillshot.agadistance,spelllevel)
								end
								distance = distance + radius
								local team = skillshot.team or nil
								local block = skillshot.block or false
								local speed
								if skillshot.speed then
									if type(skillshot.speed) == "string" then
										speed = spell:GetSpecialData(skillshot.speed,spell.level)
									else
										speed = skillshot.speed
									end
								else
									speed = 0
								end
								--check for if any unit could block the skillshot
								if GetDistance2D(v,me) <= distance+25 then	
									if (block and WillHit(v,me,radius,team)) or not block then						
										--dodge skillshot
										LineDodge(Vector(v.position.x + distance * math.cos(v.rotR), v.position.y + distance * math.sin(v.rotR), v.position.z), v.position, radius*2.5, me, skillshot.cdodge, speed, spell:FindCastPoint(), spell)	
										dodging = true
									end
								end
							elseif math.ceil(spell.cd+2) ==  math.ceil(spell:GetCooldown(spell.level)) or (spell.state == LuaEntityAbility.STATE_READY == 0 and not spell.abilityPhase) then
								dodgevector = nil
								dodging = false
								dodged = false	
							end
						end
					end
				end
			end
			
			--==AOE SKILSHOTS==--
			
			for z, skillshot in ipairs(AOESkillShotList) do
				if v.classId == skillshot.heroId or v.classId == CDOTA_Unit_Hero_Rubick then
					local name = skillshot.spellName:gsub("_","")
					if config:GetParameter(name, true) then
						local spell = v:FindSpell(skillshot.spellName)
						if spell and spell.level > 0 then
							
							--Checking by entity
							
							if skillshot.entity then
								local u1, u2, m1, dayvision = skillshot.u1 or nil, skillshot.u2 or nil, skillshot.m1 or nil, skillshot.dayvision or nil
								local entity = FindEntity(cast,me,dayvision,u1,u2,m1)
								if entity then
									local radius
									if type(skillshot.radius) == "string" then
										radius = spell:GetSpecialData(skillshot.radius)
									else
										radius = skillshot.radius
									end
									if GetDistance2D(me, entity) <= radius + 50 then
										AOEDodge(entity.position, entity.position, radius*1.5, me, 0)
									end
								end
							end
							
							--Checking by animations
							
							if skillshot.fixedPosition and v.visible and (spell.abilityPhase or math.ceil(spell.cd) ==  math.ceil(spell:GetCooldown(spell.level))) then
								local radius = spell:GetSpecialData(skillshot.radius)
								local distance
								local spelllevel = spell.level
								if type(skillshot.distance) == "string" then
									distance = spell:GetSpecialData(skillshot.distance,spelllevel)
								else
									distance = skillshot.distance
								end
								if v:AghanimState() and skillshot.agadistance then
									distance = spell:GetSpecialData(skillshot.agadistance,spelllevel)
								end
								if GetDistance2D(v,me) <= (distance + radius + 25) then	
									AOEDodge(v.position, Vector(v.position.x + distance * math.cos(v.rotR), v.position.y + distance * math.sin(v.rotR), v.position.z), radius*1.5, me, spell:FindCastPoint())	
									dodging = true
								end
							elseif math.ceil(spell.cd+2) ==  math.ceil(spell:GetCooldown(spell.level)) or (spell.state == LuaEntityAbility.STATE_READY and not spell.abilityPhase) then
								dodgevector = nil
								dodging = false
								dodged = false	
							end
						end
					end
				end
			end
		end
	end	
end

function Key(msg,code) 
	if client.chat or not PlayingGame() then return end
	if msg == RBUTTON_UP then
		if dodgevector and not SleepCheck() then
			if count == 0 then
				count = 1
			elseif count == 1 then
				count = 2
			elseif count == 2 then
				count = 3
			end
			entityList:GetMyHero():Move(dodgevector)
			return true
		else
			dodgevector = nil
			return false
		end
	end
end

function FindEntity(cast,me,dayvision,u1,u2,m1)
	for i, z in ipairs(cast) do
		if z.team ~= me.team then
			if (not u1 or z.unitState == u1) and (not u2 or z.unitState == u2) and (not m1 or (#z.modifiers > 0 and z:DoesHaveModifier(m1))) and (not dayvision or z.dayVision == dayvision) then
				return z
			end
		end
	end
	return nil
end

function LineDodge(pos1, pos2, radius, me, cdodge, speed, delay, spell)
	local calc1 = (math.floor(math.sqrt((pos2.x-me.position.x)^2 + (pos2.y-me.position.y)^2)))
	local calc2 = (math.floor(math.sqrt((pos1.x-me.position.x)^2 + (pos1.y-me.position.y)^2)))
	local calc4 = (math.floor(math.sqrt((pos1.x-pos2.x)^2 + (pos1.y-pos2.y)^2)))
	local calc3, perpendicular, k, x4, z4, dodgex, dodgey
	perpendicular = (math.floor((math.abs((pos2.x-pos1.x)*(pos1.y-me.position.y)-(pos1.x-me.position.x)*(pos2.y-pos1.y)))/(math.sqrt((pos2.x-pos1.x)^2 + (pos2.y-pos1.y)^2))))
	k = ((pos2.y-pos1.y)*(me.position.x-pos1.x) - (pos2.x-pos1.x)*(me.position.y-pos1.y)) / ((pos2.y-pos1.y)^2 + (pos2.x-pos1.x)^2)
	x4 = me.position.x - k * (pos2.y-pos1.y)
	z4 = me.position.y + k * (pos2.x-pos1.x)
	calc3 = (math.floor(math.sqrt((x4-me.position.x)^2 + (z4-me.position.y)^2)))
	dodgex = x4 + (radius/calc3)*(me.position.x-x4)
	dodgey = z4 + (radius/calc3)*(me.position.y-z4)
	if perpendicular < radius and calc1 < calc4 and calc2 < calc4 then
		dodgevector = Vector(dodgex,dodgey,me.position.z)
		local dodgevector2 = Vector(x4 + ((radius/2.3)/calc3)*(me.position.x-x4), z4 + ((radius/2.3)/calc3)*(me.position.y-z4), me.position.z)
		if isPosEqual(me.position, dodgevector, 5) or GetDistance2D(me,dodgevector) < 100 then 
			dodgevector = nil
			dodging = false
			dodged = false
			return 	
		end
		me:Move(dodgevector)
		local distance = GetDistance2D(me,dodgevector2)
		if speed > 1 then
			delay = GetDistance2D(pos2, me)/speed + delay
		else
			delay = speed + delay
		end
		local turn = (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, dodgevector))) - 0.69, 0)/(heroInfo[me.name].turnRate*(1/0.03)))
		if cdodge and (distance/me.movespeed + turn + client.latency/1000) > delay then
			for i,v in pairs(dodgeAbilitiesList) do
				local dItem = me:FindItem(v.name)
				local dSpell = me:FindSpell(v.name)
				if dItem and dItem.state == LuaEntityAbility.STATE_READY and not dodged and dItem:FindCastPoint() <= delay then
					local position = me
					if dItem.name == "item_blink" then position = (dodgevector - me.position) * (dItem:GetSpecialData("blink_range")-100) / GetDistance2D(me,dodgevector) + me.position end
					me:SafeCastAbility(dItem, position, false)
					dodged = true
					break
				elseif dSpell and dSpell.state == LuaEntityAbility.STATE_READY and not dodged and dSpell:FindCastPoint() <= delay and ((spell.name == "earthshaker_fissure" and dSpell.name ~= "puck_phase_shift") or spell.name ~= "earthshaker_fissure") then
					if dSpell:IsBehaviourType(LuaEntityAbility.BEHAVIOR_POINT) and (dSpell:FindCastPoint() + turn) <= delay then	
						me:SafeCastAbility(dSpell,(dodgevector - me.position) * dSpell:GetSpecialData(v.distance,dSpell.level) / GetDistance2D(me,dodgevector) + me.position, false) 
					else
						me:SafeCastAbility(dSpell, false)
					end
					dodged = true
					break
				end
			end
		end	
		Sleep(math.max(delay*1000 + client.latency, 125))
	else
		dodgevector = nil
	end
end

function AOEDodge(pos1, pos2, radius, me, delay)
	local calc = (math.floor(math.sqrt((pos2.x-me.position.x)^2 + (pos2.y-me.position.y)^2)))
	local dodgex, dodgey
	dodgex = pos2.x + (radius/calc)*(me.position.x-pos2.x)
	dodgey = pos2.y + (radius/calc)*(me.position.y-pos2.y)
	if calc < radius then
		dodgevector = Vector(dodgex,dodgey,me.position.z)
		if isPosEqual(me.position, dodgevector, 5) or GetDistance2D(me,dodgevector) < 100 then 
			dodgevector = nil
			dodging = false
			dodged = false
			return 	
		end
		me:Move(dodgevector)
		Sleep(math.max(delay*1000 + client.latency,  125))
	else
		dodgevector = nil
	end
end

function FindAB(first, second, distance)
	local xAngle = math.deg(math.atan(math.abs(second.x - first.x)/math.abs(second.y - first.y)))
	local retValue = nil
	local retVector = Vector()
	if first.x <= second.x and first.y >= second.y then
			retValue = 270 + xAngle
	elseif first.x >= second.x and first.y >= second.y then
			retValue = (90-xAngle) + 180
	elseif first.x >= second.x and first.y <= second.y then
			retValue = 90+xAngle
	elseif first.x <= second.x and first.y <= second.y then
			retValue = 90 - xAngle
	end
	retVector = Vector(first.x + math.cos(math.rad(retValue))*distance,first.y + math.sin(math.rad(retValue))*distance,0)
	client:GetGroundPosition(retVector)
	retVector.z = retVector.z+100
	return retVector
end

function FindAngleR(entity)
	if entity.rotR < 0 then
		return math.abs(entity.rotR)
	else
		return 2 * math.pi - entity.rotR
	end
end

function FindAngleBetween(first, second)
	xAngle = math.deg(math.atan(math.abs(second.x - first.position.x)/math.abs(second.y - first.position.y)))
	if first.position.x <= second.x and first.position.y >= second.y then
		return 90 - xAngle
	elseif first.position.x >= second.x and first.position.y >= second.y then
		return xAngle + 90
	elseif first.position.x >= second.x and first.position.y <= second.y then
		return 90 - xAngle + 180
	elseif first.position.x <= second.x and first.position.y <= second.y then
		return xAngle + 90 + 180
	end
	return nil
end

function WillHit(source,v,radius,team)
	if not SkillShot.__GetBlock(source.position,v.position,v,radius,team) then
		return true
	else
		return false
	end
end

function isPosEqual(v1, v2, d)
    return (v1-v2).length <= d
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me then 
			script:Disable()
		else			
			reg = true
			start, vec = nil, nil
			dodgevector = nil
			dodging = false
			dodged = false
			count = 0
			dodgingname = nil
			
			--Config--
			config = ScriptConfig.new()
			for z, skillshot in ipairs(LineSkillShotList) do
				local name = skillshot.spellName:gsub("_","")
				if config:GetParameter(name, true) == nil then
					config:SetParameter(name, true)
				end
			end
			for z, skillshot in ipairs(AOESkillShotList) do
				local name = skillshot.spellName:gsub("_","")
				if config:GetParameter(name, true) == nil then
					config:SetParameter(name, true)
				end
			end
			config:Load()
			
			script:RegisterEvent(EVENT_TICK, Main)
			script:RegisterEvent(EVENT_KEY, Key)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	start, vec = nil, nil
	dodgevector = nil
	dodging = false
	dodged = false
	count = 0
	dodgingname = nil
	if reg then
		script:UnregisterEvent(Main)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK, Load)	
		reg = false
	end
end

script:RegisterEvent(EVENT_TICK, Load)	
script:RegisterEvent(EVENT_CLOSE, Close)
