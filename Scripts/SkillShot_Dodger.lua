--[[

	-------------------------------------
	    | SkillShot Dodger by Moones |
	-------------------------------------
	========== Version 1.0.0 ============
	 
	Description:
	------------
	
		Auto Dodge of any SkillShot:
			- This script tries to move perpendicular to avid any skillshot.
			
]]--

require("libs.Utils")
require("libs.VectorOp")
require("libs.SkillShot")

local reg = false local start, vec = nil, nil

local SkillShotList = {
	{ 
		spellName = "pudge_meat_hook";
		distance = "hook_distance";
		radius = "hook_width";
		block = true;
		team = true;
	};	
	{ 
		spellName = "windrunner_powershot";
		distance = "arrow_range";
		radius = "arrow_width";
	};	
	--[[{ 
		spellName = "mirana_arrow";
		distance = "arrow_range";
		radius = "arrow_width";
		speed = "arrow_speed";
		block = true;
		team = false;
	};	]]
	{ 
		spellName = "nyx_assassin_impale";
		distance = "length";
		radius = "width";
	};
	{ 
		spellName = "lion_impale";
		distance = "length";
		radius = "width";
	};
	{ 
		spellName = "death_prophet_carrion_swarm";
		distance = "range";
		radius = "end_radius";
	};
	{ 
		spellName = "magnataur_shockwave";
		distance = "shock_distance";
		radius = "shock_width";
	};
	{ 
		spellName = "rattletrap_hookshot";
		distance = "tooltip_range";
		radius = "latch_radius";
		block = true;
		team = true;
	};
	{ 
		spellName = "earthshaker_fissure";
		distance = "fissure_range";
		radius = "fissure_radius";
	};
	{ 
		spellName = "queenofpain_sonic_wave";
		distance = "distance";
		radius = "final_aoe";
	};
	{ 
		spellName = "tusk_ice_shards";
		distance = 1500;
		radius = "shard_width";
	};
	{ 
		spellName = "puck_illusory_orb";
		distance = "max_distance";
		radius = "radius";
	};
	{ 
		spellName = "lina_dragon_slave";
		distance = "dragon_slave_distance";
		radius = "dragon_slave_width_initial";
	};
}
		
function Main(tick)
	if not PlayingGame() or client.console or not SleepCheck() then return end
	local me = entityList:GetMyHero()
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team=me:GetEnemyTeam(),visible=true,alive=true})	
	--default spell
	for i,v in ipairs(enemies) do
		if not v:IsIllusion() then
			for z, skillshot in ipairs(SkillShotList) do
				local spell = v:FindSpell(skillshot.spellName)
				if spell and spell.abilityPhase then
					local radius = spell:GetSpecialData(skillshot.radius)
					local distance = (spell:GetSpecialData(skillshot.distance,spell.level) or skillshot.distance)  + radius
					local team = skillshot.team or nil
					local block = skillshot.block or false
					if GetDistance2D(v,me) < distance then
						if (block and WillHit(v,me,radius,team)) or not block then						
							LineDodge(Vector(v.position.x + distance * math.cos(v.rotR), v.position.y + distance * math.sin(v.rotR), v.position.z), v.position, radius*2.5, me)	
							Sleep(125)
							break
						end
					end
				end
			end
		end
	end
	--other spell
	local cast = entityList:GetEntities({classId=CDOTA_BaseNPC})
	local Arrow = FindArrowHandle(cast,me)
	if Arrow then
		if not start then
			start = Arrow.position
		end
		if Arrow.visibleToEnemy and not vec then
			vec = Arrow.position
			if GetDistance2D(vec,start) < 50 then
				vec = nil
			end
		end
		if start and vec then
			if WillHit(Arrow,me,115,false) and GetDistance2D(Arrow,start) < GetDistance2D(me,start) then
				LineDodge((FindAB(start,vec,GetDistance2D(me,start)*10)), start, 375, me)
				Sleep(125)
			end
		end
	elseif start then	
		start,vec,ArrowHandle = nil,nil,nil
	end
end

function Key(msg,code) 
	if client.chat or not PlayingGame() then return end
	if msg == RBUTTON_UP then
		if not SleepCheck() then
			return true
		end
	end
end

function FindArrowHandle(cast,me)
	for i, z in ipairs(cast) do
		if z.team ~= me.team and z.dayVision == 650 then
			return z
		end
	end
	return nil
end

function LineDodge(pos1, pos2, radius, me)
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
		me:Move(Vector(dodgex,dodgey,me.position.z))
	end
end

-- function AoeDodge(pos1, pos2, radius, me)
	-- local calc = (math.floor(math.sqrt((pos2.x-me.position.x)^2 + (pos2.y-me.position.y)^2)))
	-- local dodgex, dodgey
	-- dodgex = pos2.x + (radius/calc)*(me.position.x-pos2.x)
	-- dodgey = pos2.y + (radius/calc)*(me.position.y-pos2.y)
	-- if calc < radius then
		-- me:Move(Vector(dodgex,dodgey,me.position.z))
	-- end
-- end

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

function WillHit(source,v,radius,team)
	if not SkillShot.__GetBlock(source.position,v.position,v,radius,team) then
		return true
	else
		return false
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me then 
			script:Disable()
		else			
			reg = true
			start, vec = nil, nil
			script:RegisterEvent(EVENT_TICK, Main)
			script:RegisterEvent(EVENT_KEY, Key)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	reg = true
	start, vec = nil, nil
	if reg then
		script:UnregisterEvent(Main)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK, Load)	
		reg = false
	end
end

script:RegisterEvent(EVENT_TICK, Load)	
script:RegisterEvent(EVENT_CLOSE, Close)
