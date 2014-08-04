require("libs.ScriptConfig")
require("libs.Utils")
local config = ScriptConfig.new()
config:SetParameter("CreepBlockKey", "N", config.TYPE_HOTKEY)
config:Load()	
creepblockkey = config.CreepBlockKey
local reg = false local firstmove = false local closestCreep = nil local blocksleep = 0
local monitor = client.screenSize.x/1600
local F14 = drawMgr:CreateFont("F14","Tahoma",14*monitor,550*monitor) 
local statusText = drawMgr:CreateText(-50,-25,-1,"AutoBlock: Hold ''" .. string.char(creepblockkey) .. "''",F14) statusText.visible = false
local disableText = drawMgr:CreateText(-50,-15,-1,"",F14) disableText.visible = false

function Main(tick)
	if not PlayingGame() or client.paused then return end	
	local me = entityList:GetMyHero()
	statusText.entity = me
	statusText.entityPosition = Vector(0,0,me.healthbarOffset)
	disableText.entity = me
	disableText.entityPosition = Vector(0,0,me.healthbarOffset)	
	if client.gameTime > 0 then 
		disableText.visible = true
		disableText.text = "Disable in " .. math.floor(25 - client.gameTime) .. " seconds."
	else
		disableText.visible = false
		disableText.text = ""
	end
	if client.gameTime >= 25 then
		disableText.visible = false
		statusText.visible = false
		myId = nil
		closestCreep = nil
		script:Disable()
	else
		statusText.visible = true
	end	
	if IsKeyDown(creepblockkey) and not client.chat then
		local startingpoint = Vector(-4781,-3969,261)
		local startingpoint2 = Vector(-4250,-3983,273)
		local endingpoint = Vector(-1159,-725,132)
		local starttime = 0.48
		if me.team == LuaEntity.TEAM_DIRE then
			startingpoint = Vector(3929,3420,263)
			startingpoint2 = Vector(3854,3319,191)
			endingpoint = Vector(116,250,127)
			starttime = 0.35
		end
		if client.gameTime >= (starttime - client.latency/1000 - (GetDistance2D(startingpoint,startingpoint2)/me.movespeed)/10) then
			if isPosEqual(me.position, startingpoint2, 3) or GetDistance2D(endingpoint,me) < 4000 then
				firstmove = true
			end
			if not firstmove then 
				if SleepCheck("firstmove") then
					me:Move(startingpoint2) 
					Sleep(125, "firstmove")
				end
			elseif tick > blocksleep then
				for creepHandle, creep in ipairs(entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Lane,alive=true,visible=true,team=me.team})) do	
					if creep.spawned and creep.health > 0 and GetDistance2D(me,creep) < 500 then
						if not closestCreep or (GetDistance2D(creep,endingpoint) - 25) < GetDistance2D(closestCreep,endingpoint) then
							closestCreep = creep
						end
						if closestCreep and GetDistance2D(me,closestCreep) <= 500 then
							local alfa = closestCreep.rotR
							local p = Vector(closestCreep.position.x + math.max((GetDistance2D(me,closestCreep)/closestCreep.movespeed)*1000, 100) * math.cos(alfa), closestCreep.position.y + math.max((GetDistance2D(me,closestCreep)/closestCreep.movespeed)*1000, 100) * math.sin(alfa), closestCreep.position.z)
							if (GetDistance2D(creep.position, endingpoint) - GetDistance2D(closestCreep.position, endingpoint) - 50) <= 0 and creep.handle ~= closestCreep.handle then
								alfa = creep.rotR
								p = Vector(creep.position.x + math.max((GetDistance2D(me,creep)/creep.movespeed)*1000, 100) * math.cos(alfa), creep.position.y + math.max((GetDistance2D(me,creep)/creep.movespeed)*1000, 100) * math.sin(alfa), creep.position.z)
							end
							me:Move(p)
							if GetDistance2D(endingpoint,me) < 4600 and GetDistance2D(me, closestCreep) > (25 + client.latency/1000) and (GetDistance2D(me,endingpoint) + 50) < GetDistance2D(closestCreep,endingpoint) and SleepCheck("stop") then
								me:Stop()
								Sleep(GetDistance2D(me,closestCreep)/closestCreep.movespeed + client.latency/1000, "stop")
							end
							if blocksleep <= tick then
								blocksleep = tick + me.movespeed/2 - GetDistance2D(me, p)/me.movespeed + client.latency/1000
							end
						end
					end
				end
			end
		elseif client.gameTime < 0 and not isPosEqual(me.position, startingpoint, 3) and SleepCheck("move") then
			me:Move(startingpoint) Sleep(1000,"move")
		end
	end
end

function Length(v1, v2)
	return (v1-v2).length
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
			statusText.visible = false
			disableText.visible = false
			reg = true
			firstmove = false
			closestCreep = nil
			blocksleep = 0
			script:RegisterEvent(EVENT_TICK, Main)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	statusText.visible = false
	disableText.visible = false
	closestCreep = nil
	if reg then
		script:UnregisterEvent(Main)
		script:RegisterEvent(EVENT_TICK, Load)	
		reg = false
	end
end

script:RegisterEvent(EVENT_CLOSE, Close)
script:RegisterEvent(EVENT_TICK, Load)
