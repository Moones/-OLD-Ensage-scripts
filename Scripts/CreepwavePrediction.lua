--<<Shows location of creepwaves in fog>>

--[[ CreepwavePrediction by Moones ]]--

require("libs.ScriptConfig")
require("libs.Utils")
require("libs.DrawManager3D")
require("libs.Res")

local config = ScriptConfig.new()
config:SetParameter("ShowOnMap", true, config.TYPE_BOOL)
config:SetParameter("ShowOnMinimap", true, config.TYPE_BOOL)
config:SetParameter("Sleep", 0, config.TYPE_NUMBER)
config:Load()

local showOnMap = config.ShowOnMap
local showOnMinimap = config.ShowOnMinimap

local F14 = drawMgr:CreateFont("F14","Tahoma",25,600)
local F13 = drawMgr:CreateFont("F13","Tahoma",12,600)
local topLaneData = {} local midLaneData = {} local botLaneData = {} local dataSaved = false local dataUpdated = false
local topLane = drawMgr3D:CreateText(Vector(0,0,0) , Vector(0,0,0), Vector2D(0,0), -1, "Creeps", F14) topLane.visible = false
local topLane2 = drawMgr3D:CreateText(Vector(0,0,0) , Vector(0,0,0), Vector2D(0,0), -1, "Creeps", F14) topLane2.visible = false
local midLane = drawMgr3D:CreateText(Vector(0,0,0) , Vector(0,0,0), Vector2D(0,0), -1, "Creeps", F14) topLane.visible = false
local midLane2 = drawMgr3D:CreateText(Vector(0,0,0) , Vector(0,0,0), Vector2D(0,0), -1, "Creeps", F14) topLane2.visible = false
local botLane = drawMgr3D:CreateText(Vector(0,0,0) , Vector(0,0,0), Vector2D(0,0), -1, "Creeps", F14) topLane.visible = false
local botLane2 = drawMgr3D:CreateText(Vector(0,0,0) , Vector(0,0,0), Vector2D(0,0), -1, "Creeps", F14) topLane2.visible = false
local topLaneMin = drawMgr:CreateText(0,0,-1,"C",F13) topLaneMin.visible = false
local topLaneMin2 = drawMgr:CreateText(0,0,-1,"C",F13) topLaneMin2.visible = false
local midLaneMin = drawMgr:CreateText(0,0,-1,"C",F13) topLaneMin.visible = false
local midLaneMin2 = drawMgr:CreateText(0,0,-1,"C",F13) topLaneMin2.visible = false
local botLaneMin = drawMgr:CreateText(0,0,-1,"C",F13) topLaneMin.visible = false
local botLaneMin2 = drawMgr:CreateText(0,0,-1,"C",F13) topLaneMin2.visible = false

function FRAME()
	local gameTime = client.gameTime
	if not PlayingGame() or gameTime < 0 or not SleepCheck() then return end
	Sleep(config.Sleep)
	local me = entityList:GetMyHero()
	local meTeam = me.team
	local lanecreeps = entityList:GetEntities({classId = CDOTA_BaseNPC_Creep_Lane,team = me:GetEnemyTeam(),visible = true,alive = true})	
	
	--After 7:30 min mark creeps on offlanes/hardlanes dont change their movespeed
	if gameTime > 450 and gameTime < 451 and not dataUpdated then
		local team = "Dire"
		if meTeam == LuaEntity.TEAM_DIRE then team = "Radiant" end
		local topLanedata = io.open(SCRIPT_PATH.."/CreepsPathData/"..team.."TopLane2.txt", "r")	
		if topLanedata then
			local count = 0
			topLaneData = {}
			while true do
				local time, posX, posY, posZ = topLanedata:read("*number", "*number", "*number", "*number")
				if not time or not posX or not posY or not posZ then break end
				count = count + 1
				topLaneData[count] = {time, Vector(posX, posY, posZ)}
			end
			topLanedata:close()
		else
			print("Please download CreepsPathData in order to use this script!")
			script:Disable()
		end
		local botLanedata = io.open(SCRIPT_PATH.."/CreepsPathData/"..team.."BotLane2.txt", "r")	
		botLaneData = {}
		if botLanedata then
			local count = 0
			while true do
				local time, posX, posY, posZ = botLanedata:read("*number", "*number", "*number", "*number")
				if not time or not posX or not posY or not posZ then dataUpdated = true break end
				count = count + 1
				botLaneData[count] = {time, Vector(posX, posY, posZ)}
			end
			botLanedata:close()
		end
	end
	
	local seconds = gameTime % 60
	local seconds2 = (gameTime + 30) % 60
	
	if seconds < 1 then
		if showOnMap then
			topLane.visible = true
			midLane.visible = true
			botLane.visible = true
		end
		if showOnMinimap then
			topLaneMin.visible = true
			midLaneMin.visible = true
			botLaneMin.visible = true
		end
	end
	if seconds2 < 1 then
		if showOnMap then
			topLane2.visible = true
			midLane2.visible = true
			botLane2.visible = true
		end
		if showOnMinimap then
			topLaneMin2.visible = true
			midLaneMin2.visible = true
			botLaneMin2.visible = true
		end
	end
	
	--Update position
	if dataSaved then
		local position, position2 = nil, nil
		for i = 1, #topLaneData do
			local data = topLaneData[i]
			local time, pos = data[1], data[2]
			if time <= seconds and topLane.visible then
				position = pos
			end
			if time <= seconds2 and topLane2.visible then
				position2 = pos
			end
		end
		if position then
			if showOnMap then
				topLane.pos = position
			end
			if showOnMinimap then
				local minimap_vec = MapToMinimap(position.x,position.y)
				topLaneMin.position = Vector2D(minimap_vec.x-2,minimap_vec.y-5)
			end
		end
		if position2 then
			if showOnMap then
				topLane2.pos = position2
			end
			if showOnMinimap then
				local minimap_vec = MapToMinimap(position2.x,position2.y)
				topLaneMin2.position = Vector2D(minimap_vec.x-2,minimap_vec.y-5)
			end
		end
		position, position2 = nil, nil
		for i = 1, #midLaneData do
			local data = midLaneData[i]
			local time, pos = data[1], data[2]
			if time <= seconds and midLane.visible then
				position = pos
			end
			if time <= seconds2 and midLane2.visible then
				position2 = pos
			end
		end
		if position then
			if showOnMap then
				midLane.pos = position
			end
			if showOnMinimap then
				local minimap_vec = MapToMinimap(position.x,position.y)
				midLaneMin.position = Vector2D(minimap_vec.x-2,minimap_vec.y-5)
			end
		end
		if position2 then
			if showOnMap then
				midLane2.pos = position2
			end
			if showOnMinimap then
				local minimap_vec = MapToMinimap(position2.x,position2.y)
				midLaneMin2.position = Vector2D(minimap_vec.x-2,minimap_vec.y-5)
			end
		end
		position, position2 = nil, nil
		for i = 1, #botLaneData do
			local data = botLaneData[i]
			local time, pos = data[1], data[2]
			if time <= seconds and botLane.visible then
				position = pos
			end
			if time <= seconds2 and botLane2.visible then
				position2 = pos
			end
		end
		if position then
			if showOnMap then
				botLane.pos = position
			end
			if showOnMinimap then
				local minimap_vec = MapToMinimap(position.x,position.y)
				botLaneMin.position = Vector2D(minimap_vec.x-2,minimap_vec.y-5)
			end
		end
		if position2 then
			if showOnMap then
				botLane2.pos = position2
			end
			if showOnMinimap then
				local minimap_vec = MapToMinimap(position2.x,position2.y)
				botLaneMin2.position = Vector2D(minimap_vec.x-2,minimap_vec.y-5)
			end
		end
	end
	
	--If creeps visible then hide signs
	for i = 1, #lanecreeps do
		local v = lanecreeps[i]
		if v.spawned then
			if GetDistance2D(v,topLane.pos) < 700 then
				topLane.visible = false
				topLaneMin.visible = false
			end
			if GetDistance2D(v,topLane2.pos) < 700 then
				topLane2.visible = false
				topLaneMin2.visible = false
			end
			if GetDistance2D(v,midLane.pos) < 700 then
				midLane.visible = false
				midLaneMin.visible = false
			end
			if GetDistance2D(v,midLane2.pos) < 700 then
				midLane2.visible = false
				midLaneMin2.visible = false
			end
			if GetDistance2D(v,botLane.pos) < 700 then
				botLane.visible = false
				botLaneMin.visible = false
			end
			if GetDistance2D(v,botLane2.pos) < 700 then
				botLane2.visible = false
				botLaneMin2.visible = false
			end
		end
	end					
end
	
function LOAD()	
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me then 
			script:Disable()
		else
			topLaneData = {}
			midLaneData = {}
			botLaneData = {}
			dataSaved = false
			local team = "Dire"
			if me.team == LuaEntity.TEAM_DIRE then team = "Radiant" end
			if not dataSaved then
				local topLanedata = io.open(SCRIPT_PATH.."/CreepsPathData/"..team.."TopLane.txt", "r")	
				if topLanedata then
					local count = 0
					while true do
						local time, posX, posY, posZ = topLanedata:read("*number", "*number", "*number", "*number")
						if not time or not posX or not posY or not posZ then break end
						count = count + 1
						topLaneData[count] = {time, Vector(posX, posY, posZ)}
					end
					topLanedata:close()
				else
					print("Please download CreepsPathData in order to use this script!")
					script:Disable()
				end
				local midLanedata = io.open(SCRIPT_PATH.."/CreepsPathData/"..team.."MidLane.txt", "r")	
				if midLanedata then
					local count = 0
					while true do
						local time, posX, posY, posZ = midLanedata:read("*number", "*number", "*number", "*number")
						if not time or not posX or not posY or not posZ then break end
						count = count + 1
						midLaneData[count] = {time, Vector(posX, posY, posZ)}
					end
					midLanedata:close()
				end
				local botLanedata = io.open(SCRIPT_PATH.."/CreepsPathData/"..team.."BotLane.txt", "r")	
				if botLanedata then
					local count = 0
					while true do
						local time, posX, posY, posZ = botLanedata:read("*number", "*number", "*number", "*number")
						if not time or not posX or not posY or not posZ then dataSaved = true break end
						count = count + 1
						botLaneData[count] = {time, Vector(posX, posY, posZ)}
					end
					botLanedata:close()
				end
			end
			topLane.visible = false
			midLane.visible = false
			botLane.visible = false
			topLaneMin.visible = false
			midLaneMin.visible = false
			botLaneMin.visible = false
			topLane2.visible = false
			midLane2.visible = false
			botLane2.visible = false
			topLaneMin2.visible = false
			midLaneMin2.visible = false
			botLaneMin2.visible = false
			dataUpdated = false
			reg = true
			script:RegisterEvent(EVENT_FRAME, FRAME)
			script:UnregisterEvent(LOAD)
		end
	end	
end

function CLOSE()
	if reg then
		topLane.visible = false
		midLane.visible = false
		botLane.visible = false
		topLaneMin.visible = false
		midLaneMin.visible = false
		botLaneMin.visible = false
		topLane2.visible = false
		midLane2.visible = false
		botLane2.visible = false
		topLaneMin2.visible = false
		midLaneMin2.visible = false
		botLaneMin2.visible = false
		dataUpdated = false
		topLaneData = {}
		midLaneData = {}
		botLaneData = {}
		dataSaved = false
		script:UnregisterEvent(FRAME)
		script:RegisterEvent(EVENT_TICK, LOAD)	
		reg = false
	end
end

script:RegisterEvent(EVENT_CLOSE, CLOSE)
script:RegisterEvent(EVENT_TICK, LOAD)
