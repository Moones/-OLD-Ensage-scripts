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
			(Currently not working)SkillShot.BlockableSkillShotXYZ(source,target,delay,speed,aoe,team): Same as SkillShotXYZ, but this time it returns nil if skillshot can be blocked by a unit. AoE is aoe of the spell. Team is true if allies can block, false otherwise.


		Changelog:
			v1.4:
			 - Improved prediction
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
		SkillShot.lastTrackTick = tick 	
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
		return t.position
	else
		tpos = t.position
		local thandle = t.handle
		local target = entityList:GetEntity(thandle)
		local move = target.movespeed	
		local v = Vector(tpos.x + move * delay * math.cos(t.rotR), tpos.y + move * delay * math.sin(t.rotR),tpos.z)
		return v
	end
end

function SkillShot.SkillShotXYZ(source,t,speed,castpoint)
	if t.activity ~= LuaEntityNPC.ACTIVITY_MOVE or not t:CanMove() then
		return t.position
	else
		local thandle = t.handle
		local target = entityList:GetEntity(thandle)
		local move = target.movespeed		
		local castpoint1 = (GetDistance2D(t,source)/(speed * math.sqrt(1 - math.pow(move/speed,2))) + castpoint)
		local stage1 = SkillShot.PredictedXYZ(t,castpoint1)
		if stage1 then
			local sourcepos = source.position
			local distance = stage1:GetDistance2D(sourcepos)
			local castpoint2 = (distance/(speed * math.sqrt(1 - math.pow(move/speed,2))) + castpoint)
			local stage2 = SkillShot.PredictedXYZ(t,castpoint2)
			while (math.floor(distance) ~= math.floor(stage2:GetDistance2D(sourcepos))) do
				stage1 = stage2
				distance = stage1:GetDistance2D(sourcepos)
				castpoint2 = (distance/(speed * math.sqrt(1 - math.pow(move/speed,2))) + castpoint)
				stage2 = SkillShot.PredictedXYZ(t,castpoint2)
			end
			return Vector(stage2.x,stage2.y,stage2.z)
		end
	end
end


scriptEngine:RegisterLibEvent(EVENT_TICK,SkillShot.__TrackTick)
