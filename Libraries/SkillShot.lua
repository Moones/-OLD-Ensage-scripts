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

			SkillShot Library v1.3

		Save as SkillShot.lua into Ensage\Scripts\libs.

		Functions:
			SkillShot.InFront(target,distance): Returns the Vector of the position in front of the target for specified distance
			SkillShot.PredictedXYZ(target,delay): Returns the Vector of the target's predicted location after specified milisecond
			SkillShot.SkillShotXYZ(source,target,delay,speed): Returns the Vector of the target's predicted location for a  Souce is the caster,speed is the speed of the projectile and delay is the casting time
			(Currently not working)SkillShot.BlockableSkillShotXYZ(source,target,delay,speed,aoe,team): Same as SkillShotXYZ, but this time it returns nil if skillshot can be blocked by a unit. AoE is aoe of the spell. Team is true if allies can block, false otherwise.


		Changelog:
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
SkillShot.lastTrackTick = 0
SkillShot.currentTick = 0

function SkillShot.__TrackTick(tick)
	SkillShot.currentTick = tick
	if tick > SkillShot.lastTrackTick + 50 then
		SkillShot.__Track()
		SkillShot.lastTrackTick = tick 	
	end
end

function SkillShot.__Track()
	local all = entityList:GetEntities({type = TYPE_HERO})
	for i,v in ipairs(all) do
		if SkillShot.trackTable[v.handle] == nil and v.alive and v.visible then
			SkillShot.trackTable[v.handle] = {nil,nil,nil,v,nil}
		elseif SkillShot.trackTable[v.handle] ~= nil and (not v.alive or not v.visible) then
			SkillShot.trackTable[v.handle] = nil
		elseif SkillShot.trackTable[v.handle] then
			if SkillShot.trackTable[v.handle].last ~= nil then
				SkillShot.trackTable[v.handle].speed = (v.position - SkillShot.trackTable[v.handle].last.pos)/(SkillShot.currentTick - SkillShot.trackTable[v.handle].last.tick)
			end
			SkillShot.trackTable[v.handle].last = {pos = v.position, tick = SkillShot.currentTick}
		end
	end
end

function SkillShot.InFront(t,distance)
	local alpha = t.rotR
	if alpha then
		local v = t.position + vectorOp:UnitVectorFromXYAngle(alpha) * distance
		return Vector(v.x,v.y,0)
	end
end

function SkillShot.PredictedXYZ(t,delay)
	if not t:CanMove() then
		return t.position
	elseif SkillShot.trackTable[t.handle] and SkillShot.trackTable[t.handle].speed then
		local v = t.position + SkillShot.trackTable[t.handle].speed * delay
		return Vector(v.x,v.y,0)
	end
end

function SkillShot.SkillShotXYZ(source,t,delay,speed,castpoint)
	if not t:CanMove() then
		return t.position
	elseif source and t and delay and speed then
		local delay1 = delay + (GetDistance2D(source,t)*1000/speed)
		local stage1 = SkillShot.PredictedXYZ(t,delay1)
		if stage1 then
			local sourcepos = source.position
			local distance = math.sqrt(math.pow(sourcepos.x-stage1.x,2)+math.pow(sourcepos.y-stage1.y,2))
			local delay2 = delay + (distance*1000/speed)
			local stage2 = SkillShot.PredictedXYZ(t,delay2)
			local i = 1
			while (math.floor(distance) ~= math.floor(math.sqrt(math.pow(sourcepos.x-stage1.x,2)+math.pow(sourcepos.y-stage1.y,2)))) do
				stage1 = stage2
				distance = math.sqrt(math.pow(sourcepos.x-stage1.x,2)+math.pow(sourcepos.y-stage1.y,2))
				delay2 = delay + (distance*1000/speed)
				stage2 = SkillShot.PredictedXYZ(t,delay2)
				i = i + 1
			end
			return Vector(stage2.x,stage2.y,stage2.z)
		end
	end
end

scriptEngine:RegisterLibEvent(EVENT_TICK,SkillShot.__TrackTick)
