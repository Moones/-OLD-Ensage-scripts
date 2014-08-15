require("libs.Utils")
require("libs.VectorOp")

--[[
 0 1 0 1 0 0 1 1    
 0 1 1 0 1 1 1 1        ____          __        __         
 0 1 1 1 0 0 0 0       / __/__  ___  / /  __ __/ /__ ___ __
 0 1 1 0 1 0 0 0      _\ \/ _ \/ _ \/ _ \/ // / / _ `/\ \ /
 0 1 1 1 1 0 0 1     /___/\___/ .__/_//_/\_, /_/\_,_//_\_\ 
 0 1 1 0 1 1 0 0             /_/        /___/             
 0 1 1 0 0 0 0 1    
 0 1 1 1 1 0 0 0    

			SkillShot Library v1.4

		Save as SkillShot.lua into Ensage\Scripts\libs.

		Functions:
			SkillShot.InFront(target,distance): Returns the Vector of the position in front of the target for specified distance
			SkillShot.PredictedXYZ(target,delay): Returns the Vector of the target's predicted location after specified milisecond
			SkillShot.SkillShotXYZ(source,target,speed,castpoint): Returns the Vector of the target's predicted location for a Source is the caster,speed is the speed of the projectile and castpoint is the casting time
			SkillShot.BlockableSkillShotXYZ(source,target,speed,castpoint,aoe,team): Same as SkillShotXYZ, but this time it returns nil if skillshot can be blocked by a unit. AoE is aoe of the spell. Team is true if allies can block, false otherwise.


		Changelog:
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

function SkillShot.__TrackTick(tick)
	SkillShot.currentTick = tick
	SkillShot.BlindPrediction()
	if tick > SkillShot.lastTrackTick + 50 then
		SkillShot.__Track()
		SkillShot.lastTrackTick = tick 	
	end
end

function SkillShot.__Track()
	local all = entityList:GetEntities({type = LuaEntity.TYPE_HERO})
	for i,v in ipairs(all) do
		if SkillShot.trackTable[v.handle] == nil and v.alive then
			SkillShot.trackTable[v.handle] = {}
		elseif SkillShot.trackTable[v.handle] ~= nil and not v.alive then
			SkillShot.trackTable[v.handle] = nil
		elseif SkillShot.trackTable[v.handle] and (not SkillShot.trackTable[v.handle].last or SkillShot.currentTick > SkillShot.trackTable[v.handle].last.tick) then
			if SkillShot.trackTable[v.handle].last ~= nil then
				SkillShot.trackTable[v.handle].speed = (v.position - SkillShot.trackTable[v.handle].last.pos)/(SkillShot.currentTick - SkillShot.trackTable[v.handle].last.tick)
			end
			SkillShot.trackTable[v.handle].last = {pos = v.position:Clone(), tick = SkillShot.currentTick}
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

function SkillShot.PredictedXYZ(t,delay)
	if not t:CanMove() then
		return Vector(t.position.x,t.position.y,0)
	elseif SkillShot.trackTable[t.handle] and SkillShot.trackTable[t.handle].speed then
		local v = t.position + SkillShot.trackTable[t.handle].speed * delay
		return Vector(v.x,v.y,t.z or t.position.z)
	end
end

function SkillShot.SkillShotXYZ(source,t,delay,speed)	
	if source and t then
		local sourcepos = source.position
		if delay and SkillShot.trackTable[t.handle] and SkillShot.trackTable[t.handle].speed then 
			local prediction = SkillShot.PredictedXYZ(t,delay) - sourcepos
			if speed then
				local delay2 = prediction.x*SkillShot.trackTable[t.handle].speed.x + prediction.y*SkillShot.trackTable[t.handle].speed.y
				local speed1 = SkillShot.trackTable[t.handle].speed.x^2 + SkillShot.trackTable[t.handle].speed.y^2 - (speed/1000)^2
				local predictedTime = (-2*(delay2) - math.sqrt((2*delay2)^2 - 4*speed1*(prediction.x^2 + prediction.y^2)))/(2*speed1)
				prediction = SkillShot.PredictedXYZ(t,delay + predictedTime)
			end
			return Vector(prediction.x, prediction.y, prediction.z)
		end
	end
end

function SkillShot.BlindSkillShotXYZ(source,t,speed,castpoint)
	if SkillShot.BlindPredictionTable[t.handle].range then
		local distance = GetDistance2D(SkillShot.BlindPredictionTable[t.handle].range, source)
		return Vector(SkillShot.BlindPredictionTable[t.handle].range.x + SkillShot.BlindPredictionTable[t.handle].move * (distance/(speed * math.sqrt(1 - math.pow(SkillShot.BlindPredictionTable[t.handle].move/speed,2))) + castpoint) * math.cos(t.rotR), SkillShot.BlindPredictionTable[t.handle].range.y + SkillShot.BlindPredictionTable[t.handle].move * (distance/(speed * math.sqrt(1 - math.pow(SkillShot.BlindPredictionTable[t.handle].move/speed,2))) + castpoint) * math.sin(t.rotR),SkillShot.BlindPredictionTable[t.handle].range.z)
	end
end			

function SkillShot.BlindPrediction()
	for i,t in ipairs(entityList:GetEntities({type = LuaEntity.TYPE_HERO})) do
		if not t:IsIllusion() then
			if SkillShot.BlindPredictionTable[t.handle] == nil and t.alive then
				SkillShot.BlindPredictionTable[t.handle] = {}
			elseif SkillShot.BlindPredictionTable[t.handle] ~= nil and not t.alive then
				SkillShot.BlindPredictionTable[t.handle] = nil
			elseif SkillShot.BlindPredictionTable[t.handle] and SkillShot.trackTable[t.handle] and SkillShot.trackTable[t.handle].last then
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
	if pred and not SkillShot.__GetBlock(source.position,pred,t,aoe,team) then
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
	if team then
		creeps = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Lane,alive=true,visible=true})
		forge = entityList:GetEntities({classId=CDOTA_BaseNPC_Invoker_Forged_Spirit,alive=true,visible=true})
		hero = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true})
		golem = entityList:GetEntities({classId=CDOTA_BaseNPC_Warlock_Golem,alive=true,visible=true})
	end
	for k,v in pairs(creeps) do block[#block + 1] = v end
	for k,v in pairs(forge) do block[#block + 1] = v end
	for k,v in pairs(hero) do block[#block + 1] = v end
	for k,v in pairs(golem) do block[#block + 1] = v end	
	for k,v in pairs(neutrals) do block[#block + 1] = v end	
	local block = SkillShot.__CheckBlock(block,v1,v2,aoe,target)
	return block
end

function SkillShot.__CheckBlock(units,v1,v2,aoe,target)
	distance = GetDistance2D(v1,v2)
	local i = 1
	local block = false
	local filterunits = {}
	for k,v in pairs(units) do
		if v ~= nil and v.handle ~= target.handle and v.GetDistance2D then
			if v1 ~= nil and v:GetDistance2D(v1) < distance and v:GetDistance2D(target) < distance then
				filterunits[#filterunits + 1] = v
			end
		end
	end
	for i,v in ipairs(filterunits) do
		local vec = (v2 - v1)
		local closest = SkillShot.GetClosestPoint(v1,vec:GetXYAngle(),v.position,distance-aoe)
		if closest then
			if GetDistance2D(v,closest) < aoe then
				block = true
			end
		end
	end
	return block
end

function SkillShot.GetClosestPoint(A, _a, P,e)
    local l1 = {x = math.tan(_a), c = A.y - A.x * math.tan(_a)}
    local l2 = {x = math.tan(_a+math.pi/2), c =  P.y - P.x * math.tan(_a+math.pi/2)}

    local final = Vector((l2.c-l1.c)/(l1.x-l2.x),l1.x*(l2.c-l1.c)/(l1.x-l2.x) + l1.c,A.z)

    local length = GetDistance2D(final, A)
    if math.floor((final.x - A.x)/length) == math.floor(math.cos(_a)) and math.floor((final.y - A.y)/length) == math.floor(math.sin(_a)) then
        if length <= e then
            return final
        else
            return Vector(A.x + e*math.cos(_a),A.y + e*math.sin(_a),A.z)
        end
    end
end

scriptEngine:RegisterLibEvent(EVENT_TICK,SkillShot.__TrackTick)
