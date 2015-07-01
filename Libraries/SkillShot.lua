require("libs.Utils")
require("libs.VectorOp")
require("libs.Animations2")

--[[
 0 1 0 1 0 0 1 1    
 0 1 1 0 1 1 1 1        ____          __        __         
 0 1 1 1 0 0 0 0       / __/__  ___  / /  __ __/ /__ ___ __
 0 1 1 0 1 0 0 0      _\ \/ _ \/ _ \/ _ \/ // / / _ `/\ \ /
 0 1 1 1 1 0 0 1     /___/\___/ .__/_//_/\_, /_/\_,_//_\_\ 
 0 1 1 0 1 1 0 0             /_/        /___/             
 0 1 1 0 0 0 0 1    
 0 1 1 1 1 0 0 0    

			SkillShot Library v1.5

		Save as SkillShot.lua into Ensage\Scripts\libs.

		Functions:
			SkillShot.InFront(target,distance): Returns the Vector of the position in front of the target for specified distance
			SkillShot.PredictedXYZ(target,delay): Returns the Vector of the target's predicted location after specified milisecond
			SkillShot.SkillShotXYZ(source,target,speed,castpoint): Returns the Vector of the target's predicted location for a Source is the caster,speed is the speed of the projectile and castpoint is the casting time
			SkillShot.BlockableSkillShotXYZ(source,target,speed,castpoint,aoe,team): Same as SkillShotXYZ, but this time it returns nil if skillshot can be blocked by a unit. AoE is aoe of the spell. Team is true if allies can block, false otherwise.


		Changelog:
			v1.5
			 - Added beta version of juke protection
			 
			v1.4:
			 - Added Blind Prediction
			 
			v1.3: 
			 - Reworked for new version
			 
			v1.2:
			 - Tweaked for new ensage patch
			 - Removed Enable and Disable functions

			v1.1a:
			 - Removed unnecessary tracking of non-npcs

			v1.1:
			 - Added Option to track only heroes

			v1.0:
			 - Release

--]]

SkillShot = {}

SkillShot.trackTable = {}
SkillShot.BlindPredictionTable = {}
SkillShot.lastTrackTick = 0
SkillShot.currentTick = 0

function SkillShot.__TrackTick()
	local tick = GetTick()
	SkillShot.currentTick = tick
	SkillShot.__Track()
end

function SkillShot.__Track()
	local all = entityList:GetEntities({type = LuaEntity.TYPE_HERO})
	for i = 1, #all do
		local v = all[i]
		if SkillShot.trackTable[v.handle] == nil and v.alive and v.visible then
			SkillShot.trackTable[v.handle] = {}
		end
		if SkillShot.trackTable[v.handle] ~= nil and (not v.alive or not v.visible) then
			SkillShot.trackTable[v.handle] = nil
		end
		if SkillShot.trackTable[v.handle] and (not SkillShot.trackTable[v.handle].last or (SkillShot.currentTick - SkillShot.trackTable[v.handle].last.tick) > math.max(math.abs(Animations.maxCount-client.latency),1)) then
			if SkillShot.trackTable[v.handle].last ~= nil then			
				local speed = (v.position - SkillShot.trackTable[v.handle].last.pos)/((SkillShot.currentTick - SkillShot.trackTable[v.handle].last.tick))
				if not SkillShot.trackTable[v.handle].speed or GetDistance2D(speed,SkillShot.trackTable[v.handle].speed) > ((100/Animations.maxCount)*client.latency)*0.001 or speed == Vector(0,0,0) or (SkillShot.trackTable[v.handle].movespeed and v.movespeed ~= SkillShot.trackTable[v.handle].movespeed) 
				or (SkillShot.trackTable[v.handle].rotR and SkillShot.trackTable[v.handle].rotR ~= v.rotR) then
					SkillShot.trackTable[v.handle].speed = speed
					SkillShot.trackTable[v.handle].movespeed = v.movespeed
					SkillShot.trackTable[v.handle].rotR = v.rotR
					SkillShot.trackTable[v.handle].last = {pos = v.position, tick = SkillShot.currentTick}
				end
				-- if SkillShot.trackTable[v.handle].lastpred and SkillShot.trackTable[v.handle].lastpred.pred then
					-- local pred = SkillShot.PredictedXYZ(v,(SkillShot.currentTick - SkillShot.trackTable[v.handle].last.tick), true)
					-- local dist = GetDistance2D(v,pred)
					-- if GetDistance2D(pred,SkillShot.trackTable[v.handle].lastpred.pred) > SkillShot.trackTable[v.handle].lastpred.dist and GetDistance2D(v,SkillShot.trackTable[v.handle].lastpred.pos) <= math.max(SkillShot.trackTable[v.handle].lastpred.dist,100) then
						-- if SkillShot.trackTable[v.handle].lastpred.pred2 and GetDistance2D(pred,SkillShot.trackTable[v.handle].lastpred.pred2) > SkillShot.trackTable[v.handle].lastpred.dist2 and GetDistance2D(v,SkillShot.trackTable[v.handle].lastpred.pos2) <= math.max(SkillShot.trackTable[v.handle].lastpred.dist2,100) then
							-- SkillShot.trackTable[v.handle].SpecialSpeed = Vector(0,0,0)
							-- SkillShot.trackTable[v.handle].lastpred = {}
						-- else
							-- SkillShot.trackTable[v.handle].lastpred.pred2 = SkillShot.PredictedXYZ(v,((SkillShot.currentTick - SkillShot.trackTable[v.handle].last.tick)), true)
							-- SkillShot.trackTable[v.handle].lastpred.dist2 = GetDistance2D(v,SkillShot.trackTable[v.handle].lastpred.pred2)
							-- SkillShot.trackTable[v.handle].lastpred.pos2 = v.position
						-- end
					-- else
						-- SkillShot.trackTable[v.handle].SpecialSpeed = nil
						-- if not SkillShot.trackTable[v.handle].lastpred then SkillShot.trackTable[v.handle].lastpred = {} end
						-- SkillShot.trackTable[v.handle].lastpred.pos = v.position
						-- SkillShot.trackTable[v.handle].lastpred.pred = SkillShot.PredictedXYZ(v,((SkillShot.currentTick - SkillShot.trackTable[v.handle].last.tick)), true)
						-- SkillShot.trackTable[v.handle].lastpred.dist = GetDistance2D(v,SkillShot.trackTable[v.handle].lastpred.pred)
					-- end
				-- else	
					-- if not SkillShot.trackTable[v.handle].lastpred then SkillShot.trackTable[v.handle].lastpred = {} end
					-- SkillShot.trackTable[v.handle].lastpred.pos = v.position
					-- SkillShot.trackTable[v.handle].lastpred.pred = SkillShot.PredictedXYZ(v,((SkillShot.currentTick - SkillShot.trackTable[v.handle].last.tick)), true)
					-- SkillShot.trackTable[v.handle].lastpred.dist = GetDistance2D(v,SkillShot.trackTable[v.handle].lastpred.pred)
				-- end
			else
				SkillShot.trackTable[v.handle].last = {pos = v.position, tick = SkillShot.currentTick}
			end
		end
	end 
end

function SkillShot.InFront(t,distance)
	local alpha = t.rotR
	if alpha then
		local v = t.position + VectorOp.UnitVectorFromXYAngle(alpha) * distance
		return Vector(v.x,v.y,0)
	end
end

function SkillShot.PredictedXYZ(t,delay,test)
	if SkillShot.isIdle(t) then return t.position
	elseif SkillShot.trackTable[t.handle] and SkillShot.trackTable[t.handle].speed and (GetType(SkillShot.trackTable[t.handle].speed) == "Vector" or GetType(SkillShot.trackTable[t.handle].speed) == "Vector2D") and (SkillShot.trackTable[t.handle].speed ~= Vector(0,0,0) or t.activity ~= LuaEntityNPC.ACTIVITY_MOVE) then	
		local a = (1/Animations.maxCount)
		--print(a)
		--local asd = (SkillShot.InFront(t,a) - t.position)/(a*1000)
		local pred = t.position + Vector(SkillShot.trackTable[t.handle].speed.x+a^2, SkillShot.trackTable[t.handle].speed.y+a^2, SkillShot.trackTable[t.handle].speed.z) * delay
		local pred2 = SkillShot.InFront(t,(delay/1000)*t.movespeed)
		local v = pred
		if pred and v then
			if t.activity ~= LuaEntityNPC.ACTIVITY_MOVE or (GetDistance2D(pred,v) > GetDistance2D(t,v)) or SkillShot.AbilityMove(t) or (not t:CanMove() or t:DoesHaveModifier("modifier_invoker_cold_snap_freeze")) then
				v = pred
			end
		end
		if SkillShot.trackTable[t.handle].SpecialSpeed and not test then
			v = t.position + SkillShot.trackTable[t.handle].SpecialSpeed * delay
		end
		return Vector(v.x,v.y,t.position.z)
	end
	return t.position
end

function SkillShot.SkillShotXYZ(source,t,delay,speed)	
	if SkillShot.isIdle(t) then return t.position
	elseif source and t then
		local sourcepos = source.position or source
		local prediction = SkillShot.PredictedXYZ(t,delay)
		if prediction and sourcepos and (GetType(sourcepos) == "Vector" or GetType(sourcepos) == "Vector2D") and delay and SkillShot.trackTable[t.handle] and SkillShot.trackTable[t.handle].speed then 
			prediction = prediction - sourcepos
			local prediction2
			local distance = sourcepos:GetDistance2D(prediction)
			if speed and prediction then
				local delay2 = prediction.x*SkillShot.trackTable[t.handle].speed.x + prediction.y*SkillShot.trackTable[t.handle].speed.y
				local speed1 = SkillShot.trackTable[t.handle].speed.x^2 + SkillShot.trackTable[t.handle].speed.y^2 - (speed/1000)^2
				local predictedTime = (-2*(delay2) - math.sqrt((2*delay2)^2 - 4*speed1*(prediction.x^2 + prediction.y^2)))/(2*speed1)
				prediction2 = SkillShot.PredictedXYZ(t,delay + predictedTime)					
				while math.floor(distance) ~= math.floor(math.sqrt(math.pow(sourcepos.x-prediction.x,2)+math.pow(sourcepos.y-prediction.y,2))) do
					prediction = prediction2
					local delay2 = prediction.x*SkillShot.trackTable[t.handle].speed.x + prediction.y*SkillShot.trackTable[t.handle].speed.y
					local speed1 = SkillShot.trackTable[t.handle].speed.x^2 + SkillShot.trackTable[t.handle].speed.y^2 - (speed/1000)^2
					local predictedTime = (-2*(delay2) - math.sqrt((2*delay2)^2 - 4*speed1*(prediction.x^2 + prediction.y^2)))/(2*speed1)
					prediction2 = SkillShot.PredictedXYZ(t,delay + predictedTime)
				end
			end
			if prediction2 then
				return Vector(prediction2.x, prediction2.y, t.position.z)
			end
		end
	end
end

function SkillShot.BlindSkillShotXYZ(source,t,speed,castpoint)
	if source and SkillShot.BlindPredictionTable[t.handle] and SkillShot.BlindPredictionTable[t.handle].range then
		local distance = GetDistance2D(SkillShot.BlindPredictionTable[t.handle].range, source)
		return Vector(SkillShot.BlindPredictionTable[t.handle].range.x + SkillShot.BlindPredictionTable[t.handle].move * (distance/(speed * math.sqrt(1 - math.pow(SkillShot.BlindPredictionTable[t.handle].move/speed,2))) + castpoint) * math.cos(t.rotR), SkillShot.BlindPredictionTable[t.handle].range.y + SkillShot.BlindPredictionTable[t.handle].move * (distance/(speed * math.sqrt(1 - math.pow(SkillShot.BlindPredictionTable[t.handle].move/speed,2))) + castpoint) * math.sin(t.rotR),SkillShot.BlindPredictionTable[t.handle].range.z)
	end
end		

function SkillShot.BlockableBlindSkillShotXYZ(source,t,speed,castpoint,aoe,team)
	if team == nil then
		team = false
	end
	local pred 
	if source and SkillShot.BlindPredictionTable[t.handle] and SkillShot.BlindPredictionTable[t.handle].range then
		local distance = GetDistance2D(SkillShot.BlindPredictionTable[t.handle].range, source)
		pred = Vector(SkillShot.BlindPredictionTable[t.handle].range.x + SkillShot.BlindPredictionTable[t.handle].move * (distance/(speed * math.sqrt(1 - math.pow(SkillShot.BlindPredictionTable[t.handle].move/speed,2))) + castpoint) * math.cos(t.rotR), SkillShot.BlindPredictionTable[t.handle].range.y + SkillShot.BlindPredictionTable[t.handle].move * (distance/(speed * math.sqrt(1 - math.pow(SkillShot.BlindPredictionTable[t.handle].move/speed,2))) + castpoint) * math.sin(t.rotR),SkillShot.BlindPredictionTable[t.handle].range.z)
	end
	if pred and (GetType(pred) == "Vector" or GetType(pred) == "Vector2D") and not SkillShot.__GetBlock(source.position or source,pred,t,aoe,team) then
		return pred
	end
end		

function SkillShot.BlindPrediction()
	local enemies = entityList:GetEntities({type = LuaEntity.TYPE_HERO})
	for i = 1, #enemies do
		local t = enemies[i]
		if not t:IsIllusion() then
			if SkillShot.BlindPredictionTable[t.handle] == nil and t.alive then
				SkillShot.BlindPredictionTable[t.handle] = {}
			elseif SkillShot.BlindPredictionTable[t.handle] ~= nil and not t.alive then
				SkillShot.BlindPredictionTable[t.handle] = nil
			elseif SkillShot.BlindPredictionTable[t.handle] then
				if t.visible then
					SkillShot.BlindPredictionTable[t.handle].move = t.movespeed
					SkillShot.BlindPredictionTable[t.handle].lastpos = t.position
					SkillShot.BlindPredictionTable[t.handle].range = nil
				end
				if not t.visible and SkillShot.BlindPredictionTable[t.handle].lastpos and SkillShot.BlindPredictionTable[t.handle].move then
					local rotR = SkillShot.BlindPredictionTable[t.handle].rotR local dist = SkillShot.BlindPredictionTable[t.handle].move/(SkillShot.BlindPredictionTable[t.handle].move/50) local speed = 1600
					if not SkillShot.BlindPredictionTable[t.handle].range then
						SkillShot.BlindPredictionTable[t.handle].range = Vector(SkillShot.BlindPredictionTable[t.handle].lastpos.x + SkillShot.BlindPredictionTable[t.handle].move * (dist/(speed * math.sqrt(1 - math.pow(SkillShot.BlindPredictionTable[t.handle].move/speed,2)))) * math.cos(t.rotR), SkillShot.BlindPredictionTable[t.handle].lastpos.y + SkillShot.BlindPredictionTable[t.handle].move * (dist/(speed * math.sqrt(1 - math.pow(SkillShot.BlindPredictionTable[t.handle].move/speed,2)))) * math.sin(t.rotR), SkillShot.BlindPredictionTable[t.handle].lastpos.z)
					else
						if SkillShot.BlindPredictionTable[t.handle].range then
							SkillShot.BlindPredictionTable[t.handle].range = Vector(SkillShot.BlindPredictionTable[t.handle].range.x + SkillShot.BlindPredictionTable[t.handle].move * (dist/(speed * math.sqrt(1 - math.pow(SkillShot.BlindPredictionTable[t.handle].move/speed,2)))) * math.cos(t.rotR), SkillShot.BlindPredictionTable[t.handle].range.y + SkillShot.BlindPredictionTable[t.handle].move * (dist/(speed * math.sqrt(1 - math.pow(SkillShot.BlindPredictionTable[t.handle].move/speed,2)))) * math.sin(t.rotR),SkillShot.BlindPredictionTable[t.handle].range.z)
						end
					end	
				end
			end
		end
	end
end

function SkillShot.BlockableSkillShotXYZ(source,t,speed,delay,aoe,team)
	if team == nil then
		team = false
	end
	local pred = SkillShot.SkillShotXYZ(source,t,delay,speed)
	if pred and (GetType(pred) == "Vector" or GetType(pred) == "Vector2D") and not SkillShot.__GetBlock(source.position or source,pred,t,aoe,team) then
		return pred
	end
end

function SkillShot.__GetBlock(v1,v2,target,aoe,team)
	local me = entityList:GetMyHero()
	local enemyTeam = me:GetEnemyTeam() 
	
	if team == nil then
		team = false
	end
	local block = {}
	local creeps = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Lane,alive=true,team=enemyTeam,visible=true})
	local forge = entityList:GetEntities({classId=CDOTA_BaseNPC_Invoker_Forged_Spirit,alive=true,team=enemyTeam,visible=true})
	local hero = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,team=enemyTeam,visible=true})
	local neutrals = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Neutral,alive=true,visible=true})
	local golem = entityList:GetEntities({classId=CDOTA_BaseNPC_Warlock_Golem,alive=true,team=enemyTeam,visible=true})
	local spiders = entityList:GetEntities({classId=CDOTA_Unit_Broodmother_Spiderling,alive=true,team=enemyTeam,visible=true})
	local boar = entityList:GetEntities({classId=CDOTA_Unit_Hero_Beastmaster_Beasts,alive=true,visible=true,team=enemyTeam})
	local familiars = entityList:GetEntities({classId=CDOTA_Unit_VisageFamiliar,alive=true,visible=true,team=enemyTeam})
	local bear = entityList:GetEntities({classId=CDOTA_Unit_SpiritBear,alive=true,visible=true,team=enemyTeam})[1] 
	local zombies = entityList:GetEntities({classId=CDOTA_Unit_Undying_Zombie,alive=true,visible=true,team=enemyTeam})
	if team == true then
		creeps = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Lane,alive=true,visible=true})
		forge = entityList:GetEntities({classId=CDOTA_BaseNPC_Invoker_Forged_Spirit,alive=true,visible=true})
		hero = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true})
		golem = entityList:GetEntities({classId=CDOTA_BaseNPC_Warlock_Golem,alive=true,visible=true})
		spiders = entityList:GetEntities({classId=CDOTA_Unit_Broodmother_Spiderling,alive=true,visible=true})
		boar = entityList:GetEntities({classId=CDOTA_Unit_Hero_Beastmaster_Beasts,alive=true,visible=true})
		familiars = entityList:GetEntities({classId=CDOTA_Unit_VisageFamiliar,alive=true,visible=true})
		bear = entityList:GetEntities({classId=CDOTA_Unit_SpiritBear,alive=true,visible=true})[1]
		zombies = entityList:GetEntities({classId=CDOTA_Unit_Undying_Zombie,alive=true,visible=true})
	elseif team == "ally" then
		creeps = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Lane,alive=true,visible=true,team=me.team})
		forge = entityList:GetEntities({classId=CDOTA_BaseNPC_Invoker_Forged_Spirit,alive=true,visible=true,team=me.team})
		hero = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true,team=me.team})
		golem = entityList:GetEntities({classId=CDOTA_BaseNPC_Warlock_Golem,alive=true,visible=true,team=me.team})
		spiders = entityList:GetEntities({classId=CDOTA_Unit_Broodmother_Spiderling,alive=true,team=me.team,visible=true})
		boar = entityList:GetEntities({classId=CDOTA_Unit_Hero_Beastmaster_Beasts,alive=true,visible=true,team=me.team})
		familiars = entityList:GetEntities({classId=CDOTA_Unit_VisageFamiliar,alive=true,visible=true,team=me.team})
		bear = entityList:GetEntities({classId=CDOTA_Unit_SpiritBear,alive=true,team=me.team})[1]
		zombies = entityList:GetEntities({classId=CDOTA_Unit_Undying_Zombie,alive=true,visible=true,team=me.team})
	end
	local unitsCount = 0
	for i = 1, #creeps do local v = creeps[i] if (not v:IsInvul() or v:DoesHaveModifier("modifier_eul_cyclone")) and v.spawned then unitsCount = unitsCount + 1 block[unitsCount] = v end end
	for i = 1, #forge do local v = forge[i] if not v:IsInvul() or v:DoesHaveModifier("modifier_eul_cyclone") then unitsCount = unitsCount + 1 block[unitsCount] = v end end
	for i = 1, #hero do local v = hero[i] if (not v:IsInvul() or v:DoesHaveModifier("modifier_eul_cyclone")) and v ~= me then unitsCount = unitsCount + 1 block[unitsCount] = v end end
	for i = 1, #golem do local v = golem[i] if not v:IsInvul() or v:DoesHaveModifier("modifier_eul_cyclone") then unitsCount = unitsCount + 1 block[unitsCount] = v end end
	for i = 1, #neutrals do local v = neutrals[i] if (not v:IsInvul() or v:DoesHaveModifier("modifier_eul_cyclone")) and v.spawned then unitsCount = unitsCount + 1 block[unitsCount] = v end end
	for i = 1, #spiders do local v = spiders[i] if not v:IsInvul() or v:DoesHaveModifier("modifier_eul_cyclone") then unitsCount = unitsCount + 1 block[unitsCount] = v end end
	for i = 1, #boar do local v = boar[i] if not v:IsInvul() or v:DoesHaveModifier("modifier_eul_cyclone") then unitsCount = unitsCount + 1 block[unitsCount] = v end end
	for i = 1, #familiars do local v = familiars[i] if not v:IsInvul() or v:DoesHaveModifier("modifier_eul_cyclone") then unitsCount = unitsCount + 1 block[unitsCount] = v end end
	for i = 1, #zombies do local v = zombies[i] unitsCount = unitsCount + 1 block[unitsCount] = v end
	if bear and (not bear:IsInvul() or bear:DoesHaveModifier("modifier_eul_cyclone")) then unitsCount = unitsCount + 1 block[unitsCount] = bear end
	local block = SkillShot.__CheckBlock(block,v1,v2,aoe+50,target)
	return block
end

function SkillShot.__CheckBlock(units,v1,v2,aoe,target)
	distance = GetDistance2D(v1,v2)
	local mathmax = math.max
	local block = false
	local filterunits = {}
	local unitsCount = 0
	for i = 1, #units do
		local v = units[i]
		if v ~= nil and v.handle ~= target.handle then
			if v1 ~= nil and GetDistance2D(v.position,v1) < distance and GetDistance2D(v.position,target) < distance then
				unitsCount = unitsCount + 1
				filterunits[unitsCount] = v
			end
		end
	end
	local vec = (v2 - v1)
	local vecAngle = vec:GetXYAngle()
	local mathfloor, mathsqrt = math.floor, math.sqrt
	for i = 1, #filterunits do
		local v = filterunits[i]
		local closest = SkillShot.GetClosestPoint(v1,vecAngle,v.position,distance)
		if closest then
			if GetDistance2D(v.position,closest) < aoe then
				block = true
				break
			end
		end	
	end
	return block
end

function SkillShot.GetClosestPoint(A, _a, P,e)
	local mathtan, mathpi, mathfloor, mathcos, mathsin = math.tan, math.pi, math.floor, math.cos, math.sin
	local l1 = {x = mathtan(_a), c = A.y - A.x * mathtan(_a)}
    local l2 = {x = mathtan(_a+mathpi/2), c =  P.y - P.x * mathtan(_a+mathpi/2)}

    local final = Vector((l2.c-l1.c)/(l1.x-l2.x),l1.x*(l2.c-l1.c)/(l1.x-l2.x) + l1.c,A.z)

    local length = GetDistance2D(final, A)
    if mathfloor((final.x - A.x)/length) == mathfloor(mathcos(_a)) and mathfloor((final.y - A.y)/length) == mathfloor(mathsin(_a)) then
        if length <= e then
            return final
        else
            return Vector(A.x + e*mathcos(_a),A.y + e*mathsin(_a),A.z)
        end
    end
end

function SkillShot.AbilityMove(t)
	return t:DoesHaveModifier("modifier_spirit_breaker_charge_of_darkness") or t:DoesHaveModifier("modifier_earth_spirit_boulder_smash") or t:DoesHaveModifier("modifier_earth_spirit_rolling_boulder_caster") or t:DoesHaveModifier("modifier_earth_spirit_geomagnetic_grip") or t:DoesHaveModifier("modifier_huskar_life_break_charge") or t:DoesHaveModifier("modifier_magnataur_skewer_movement") or t:DoesHaveModifier("modifier_storm_spirit_ball_lightning") or t:DoesHaveModifier("modifier_faceless_void_time_walk") or t:DoesHaveModifier("modifier_mirana_leap") 
	or t:DoesHaveModifier("modifier_slark_pounce")
end
	
function SkillShot.isIdle(t)
	return (SkillShot.trackTable[t.handle] and SkillShot.trackTable[t.handle].speed and SkillShot.trackTable[t.handle].speed == Vector(0,0,0)) or t:DoesHaveModifier("modifier_eul_cyclone") or t:DoesHaveModifier("modifier_invoker_tornado") or (t.activity == LuaEntityNPC.ACTIVITY_IDLE and not SkillShot.AbilityMove(t) and not t:DoesHaveModifier("modifier_invoker_deafening_blast_knockback")) or Animations.isAttacking(t)
end

scriptEngine:RegisterLibEvent(EVENT_FRAME,SkillShot.__TrackTick)
scriptEngine:RegisterLibEvent(EVENT_TICK,SkillShot.BlindPrediction)
