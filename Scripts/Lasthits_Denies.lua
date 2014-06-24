local F13 = drawMgr:CreateFont("F13","Tahoma",13,550)
local info = {}

local sleeptick = 0

if math.floor(client.screenRatio*100) == 177 then
local testX = 1600
local tinfoHeroSize = 55
local tinfoHeroDown = 17.714
local txxB = 2.527
local txxG = 3.47
elseif math.floor(client.screenRatio*100) == 166 then
local testX = 1280
local tinfoHeroSize = 47
local tinfoHeroDown = 17.714
local txxB = 2.558
local txxG = 3.62
elseif math.floor(client.screenRatio*100) == 160 then
local testX = 1280
local tinfoHeroSize = 48.5
local tinfoHeroDown = 17.714
local txxB = 2.579
local txxG = 3.735
elseif math.floor(client.screenRatio*100) == 133 then
local testX = 1024
local tinfoHeroSize = 47
local tinfoHeroDown = 17.714
local txxB = 2.747
local txxG = 4.54
elseif math.floor(client.screenRatio*100) == 125 then
local testX = 1280
local tinfoHeroSize = 58
local tinfoHeroDown = 17.714
local tinfoHeroSS = 23
local txxB = 2.747
local txxG = 4.54
else
local testX = 1600
local tinfoHeroSize = 55
local tinfoHeroDown = 17.714
local tinfoHeroSS = 22
local txxB = 2.527
local txxG = 3.47
end

local x_ = tinfoHeroSize*(client.screenSize.x/testX)
local y_ = client.screenSize.y/tinfoHeroDown

function Tick(tick)

	if not client.connected or client.loading or client.console or tick < sleeptick then return end

	sleeptick = tick + 200

	local me = entityList:GetMyHero()

	if not me then return end

	local heroes = entityList:GetEntities({type=LuaEntity.TYPE_HERO, illusion=false})
	local player = entityList:GetEntities({classId=CDOTA_PlayerResource})[1]

	for i,v in ipairs(heroes) do        
    	local lasthits = player:GetLasthits(v.playerId)
    	local denies = player:GetDenies(v.playerId)
    	local xx = GetXX(v)
    	
    	if not info[v.playerId] then info[v.playerId] = {}
        	info[v.playerId].lhd = drawMgr:CreateText(xx-20+x_*v.playerId,y_,-1,"",F13)
    	end
    	
    	info[v.playerId].lhd.text = " "..lasthits.." / "..denies  
	end
end

function GetXX(ent)
	local team = ent.team
	if team == 2 then		
		return client.screenSize.x/txxG + 1
	elseif team == 3 then
		return client.screenSize.x/txxB 
	end
end
	
function GameClose()
	info = {}
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
