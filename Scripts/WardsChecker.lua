--<<Wards Checker by Moones version 1.1 - Shows wards by checking for charges>>
require("libs.Utils")
require("libs.DrawManager3D")
require("libs.Res")

--[[
                                                    `-.
                                                      .`
            Wards Checker made by Moones           _.`.`
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^       _.-` .`
                                       ___.---` _.-`
                               __..---`___..---`
                      _...--.-`   _.--`
                  _.-`.-`.-`  _.-`
               .-` .`  .`   .`    VERSION 1.1
    .         /   /   /    /      ===========   .
    \`-.._    |  |    \    `.              _..-`/
   .'-.._ ``--.._\     `. -- `.      _..-``  _..-`.
   `_    _       `-. .`        `. .-`      _    _`
     `.``           .            \          ``.`
      `-.-'    _   .              :   _   `-.-`
        `..-..'    ;       .` `.  '    `..-..`
            /      .      : .-. : :        \
            `._     \     ;( O ) /      _.`
               `-._.'`.    .`-'.' `._.-'
                       `-....-`					                                                                      
        Description:
        ------------
	
             This script will create icon 500 range infront of enemies on ground as well as on minimap, whenever their wards charges decreases.
             The script checks also for cooldown of wards, so it prevents creating icons when ward was placed in FOW and enemy then came out of it.
             When the ward becomes visible and is destroyed then the icon will disappear. (only if distance between icon and ward is less than 500)	 
		
        Changelog:
		----------
		
             v1.1 - Added range indicator
	   
]]--

local ObserverWards = {} ObserverWards.charges = {} ObserverWards.icons_ground = {} ObserverWards.times = {} ObserverWards.icons_minimap = {} ObserverWards.ranges = {}
local SentryWards = {} SentryWards.charges = {} SentryWards.icons_ground = {} SentryWards.times = {} SentryWards.icons_minimap = {} SentryWards.ranges = {}

function Tick(tick)
	if not PlayingGame() or client.console then return end
	local me = entityList:GetMyHero()
	local enemies = entityList:GetEntities({type = LuaEntity.TYPE_HERO, illusion = false, alive = true, visible = true, team = me:GetEnemyTeam()})
	local observer_wards = entityList:GetEntities({classId = CDOTA_NPC_Observer_Ward, visible = true, team = me:GetEnemyTeam()})
	local sentry_wards = entityList:GetEntities({classId = CDOTA_NPC_Observer_Ward_TrueSight, visible = true, team = me:GetEnemyTeam()})	
	for i,v in ipairs(enemies) do        
		local ObserverWard, SentryWard = v:FindItem("item_ward_observer"), v:FindItem("item_ward_sentry")
		if ObserverWard and not ObserverWards.charges[v.handle] then
			ObserverWards.charges[v.handle] = ObserverWard.charges
		end
		if ObserverWards.charges[v.handle] and ((not ObserverWard and ObserverWards.charges[v.handle] == 1) or (ObserverWard and ObserverWard.charges < ObserverWards.charges[v.handle] and ObserverWard.cd > 0)) then
			if not ObserverWards.icons_ground[v.handle] then
				ObserverWards.icons_ground[v.handle] = drawMgr3D:CreateRect(Vector(0,0,0), Vector(0,0,110), Vector2D(0,0), Vector2D(64,32), 0x000000ff, drawMgr:GetTextureId("NyanUI/other/item_ward_observer"))
				local vec = Vector(v.position.x + 500 * math.cos(v.rotR), v.position.y + 500 * math.sin(v.rotR), v.position.z)
				ObserverWards.icons_ground[v.handle].pos = vec
				ObserverWards.times[v.handle] = client.gameTime
				ObserverWards.icons_ground[v.handle].visible = true
				ObserverWards.icons_minimap[v.handle] = drawMgr:CreateRect(0,0,24,16,0x000000ff, drawMgr:GetTextureId("NyanUI/other/item_ward_observer"))
				local minimap_vec = MapToMinimap(vec.x,vec.y)
				ObserverWards.icons_minimap[v.handle].x = minimap_vec.x-10
				ObserverWards.icons_minimap[v.handle].y = minimap_vec.y-10
				ObserverWards.icons_minimap[v.handle].visible = true					
				ObserverWards.ranges[v.handle] = Effect(vec, "range_display" )
				ObserverWards.ranges[v.handle]:SetVector(1,Vector(1600,0,0))
				ObserverWards.ranges[v.handle]:SetVector(0, vec )
				if ObserverWard then
					ObserverWards.charges[v.handle] = ObserverWard.charges
				else
					ObserverWards.charges[v.handle] = nil
				end
				break
			elseif not ObserverWards.icons_ground[v.handle+1] then
				ObserverWards.icons_ground[v.handle+1] = drawMgr3D:CreateRect(Vector(0,0,0), Vector(0,0,110), Vector2D(0,0), Vector2D(64,32), 0x000000ff, drawMgr:GetTextureId("NyanUI/other/item_ward_observer"))
				local vec = Vector(v.position.x + 500 * math.cos(v.rotR), v.position.y + 500 * math.sin(v.rotR), v.position.z)
				ObserverWards.icons_ground[v.handle+1].pos = vec
				ObserverWards.times[v.handle+1] = client.gameTime
				ObserverWards.icons_ground[v.handle+1].visible = true
				ObserverWards.icons_minimap[v.handle+1] = drawMgr:CreateRect(0,0,24,16,0x000000ff, drawMgr:GetTextureId("NyanUI/other/item_ward_observer"))
				local minimap_vec = MapToMinimap(vec.x,vec.y)
				ObserverWards.icons_minimap[v.handle+1].x = minimap_vec.x-10
				ObserverWards.icons_minimap[v.handle+1].y = minimap_vec.y-10
				ObserverWards.icons_minimap[v.handle+1].visible = true
				ObserverWards.ranges[v.handle+1] = Effect(vec, "range_display" )
				ObserverWards.ranges[v.handle+1]:SetVector(1,Vector(1600,0,0))
				ObserverWards.ranges[v.handle+1]:SetVector(0, vec )
				if ObserverWard then
					ObserverWards.charges[v.handle] = ObserverWard.charges
				else
					ObserverWards.charges[v.handle] = nil
				end
				break
			end
		end
		if ObserverWards.times[v.handle] and ObserverWards.icons_ground[v.handle] and (client.gameTime - ObserverWards.times[v.handle]) > 420 then
			ObserverWards.icons_ground[v.handle].visible = false
			ObserverWards.icons_ground[v.handle] = nil
			ObserverWards.icons_minimap[v.handle].visible = false
			ObserverWards.icons_minimap[v.handle] = nil
			ObserverWards.times[v.handle] = nil
			ObserverWards.ranges[v.handle] = nil
		end
		if ObserverWards.times[v.handle+1] and ObserverWards.icons_ground[v.handle+1] and (client.gameTime - ObserverWards.times[v.handle+1]) > 420 then
			ObserverWards.icons_ground[v.handle+1].visible = false
			ObserverWards.icons_ground[v.handle+1] = nil
			ObserverWards.icons_minimap[v.handle+1].visible = false
			ObserverWards.icons_minimap[v.handle+1] = nil
			ObserverWards.times[v.handle+1] = nil
			ObserverWards.ranges[v.handle+1]= nil
		end
		if SentryWard and not SentryWards.charges[v.handle] then
			SentryWards.charges[v.handle] = SentryWard.charges
		end
		if SentryWards.charges[v.handle] and ((not SentryWard and SentryWards.charges[v.handle] == 1) or (SentryWard and SentryWard.charges < SentryWards.charges[v.handle] and SentryWard.cd > 0)) then
			if not SentryWards.icons_ground[v.handle] then
				SentryWards.icons_ground[v.handle] = drawMgr3D:CreateRect(Vector(0,0,0), Vector(0,0,50), Vector2D(0,0), Vector2D(64,32), 0x000000ff, drawMgr:GetTextureId("NyanUI/other/item_ward_sentry"))
				local vec = Vector(v.position.x + 500 * math.cos(v.rotR), v.position.y + 500 * math.sin(v.rotR), v.position.z)
				SentryWards.icons_ground[v.handle].pos = vec
				SentryWards.times[v.handle] = client.gameTime
				SentryWards.icons_ground[v.handle].visible = true
				SentryWards.icons_minimap[v.handle] = drawMgr:CreateRect(0,0,24,16,0x000000ff, drawMgr:GetTextureId("NyanUI/other/item_ward_sentry"))
				local minimap_vec = MapToMinimap(vec.x,vec.y)
				SentryWards.icons_minimap[v.handle].x = minimap_vec.x-10
				SentryWards.icons_minimap[v.handle].y = minimap_vec.y-10
				SentryWards.icons_minimap[v.handle].visible = true
				SentryWards.ranges[v.handle] = Effect(vec, "range_display" )
				SentryWards.ranges[v.handle]:SetVector(1,Vector(850,0,0))
				SentryWards.ranges[v.handle]:SetVector(0, vec )
				if SentryWard then
					SentryWards.charges[v.handle] = SentryWard.charges
				else
					SentryWards.charges[v.handle] = nil
				end
				break
			elseif not SentryWards.icons_ground[v.handle+1] then
				SentryWards.icons_ground[v.handle+1] = drawMgr3D:CreateRect(Vector(0,0,0), Vector(0,0,50), Vector2D(0,0), Vector2D(64,32), 0x000000ff, drawMgr:GetTextureId("NyanUI/other/item_ward_sentry"))
				local vec = Vector(v.position.x + 500 * math.cos(v.rotR), v.position.y + 500 * math.sin(v.rotR), v.position.z)
				SentryWards.icons_ground[v.handle+1].pos = vec
				SentryWards.times[v.handle+1] = client.gameTime
				SentryWards.icons_ground[v.handle+1].visible = true
				SentryWards.icons_minimap[v.handle+1] = drawMgr:CreateRect(0,0,24,16,0x000000ff, drawMgr:GetTextureId("NyanUI/other/item_ward_sentry"))
				local minimap_vec = MapToMinimap(vec.x,vec.y)
				SentryWards.icons_minimap[v.handle+1].x = minimap_vec.x-10
				SentryWards.icons_minimap[v.handle+1].y = minimap_vec.y-10
				SentryWards.icons_minimap[v.handle+1].visible = true
				SentryWards.ranges[v.handle+1] = Effect(vec, "range_display" )
				SentryWards.ranges[v.handle+1]:SetVector(1,Vector(850,0,0))
				SentryWards.ranges[v.handle+1]:SetVector(0, vec )
				if SentryWard then
					SentryWards.charges[v.handle] = SentryWard.charges
				else
					SentryWards.charges[v.handle] = nil
				end
				break
			end
		end
		if SentryWards.times[v.handle] and SentryWards.icons_ground[v.handle] and (client.gameTime - SentryWards.times[v.handle]) > 240 then
			SentryWards.icons_ground[v.handle].visible = false
			SentryWards.icons_ground[v.handle] = nil
			SentryWards.times[v.handle] = nil
			SentryWards.icons_minimap[v.handle].visible = false
			SentryWards.icons_minimap[v.handle] = nil
			SentryWards.ranges[v.handle] = nil
		end
		if SentryWards.times[v.handle+1] and SentryWards.icons_ground[v.handle+1] and (client.gameTime - SentryWards.times[v.handle+1]) > 240 then
			SentryWards.icons_ground[v.handle+1].visible = false
			SentryWards.icons_ground[v.handle+1] = nil
			SentryWards.times[v.handle+1] = nil
			SentryWards.icons_minimap[v.handle+1].visible = false
			SentryWards.icons_minimap[v.handle+1] = nil
			SentryWards.ranges[v.handle+1] = nil
		end
		for i,z in ipairs(observer_wards) do
			if not z.alive then
				if ObserverWards.icons_ground[v.handle] and GetDistance2D(ObserverWards.icons_ground[v.handle].pos,z.position) <= 500 then
					ObserverWards.icons_ground[v.handle].visible = false
					ObserverWards.icons_ground[v.handle] = nil
					ObserverWards.icons_minimap[v.handle].visible = false
					ObserverWards.icons_minimap[v.handle] = nil
					ObserverWards.times[v.handle] = nil
					ObserverWards.ranges[v.handle] = nil
				elseif ObserverWards.icons_ground[v.handle+1] and GetDistance2D(ObserverWards.icons_ground[v.handle+1].pos,z.position) <= 500 then
					ObserverWards.icons_ground[v.handle+1].visible = false
					ObserverWards.icons_ground[v.handle+1] = nil
					ObserverWards.icons_minimap[v.handle+1].visible = false
					ObserverWards.icons_minimap[v.handle+1] = nil
					ObserverWards.times[v.handle+1] = nil
					ObserverWards.ranges[v.handle+1] = nil
				end
			end
		end
		for i,z in ipairs(sentry_wards) do
			if not z.alive then
				if SentryWards.icons_ground[v.handle] and GetDistance2D(SentryWards.icons_ground[v.handle].pos,z.position) <= 500 then
					SentryWards.icons_ground[v.handle].visible = false
					SentryWards.icons_ground[v.handle] = nil
					SentryWards.icons_minimap[v.handle].visible = false
					SentryWards.icons_minimap[v.handle] = nil
					SentryWards.times[v.handle] = nil
					SentryWards.ranges[v.handle] = nil
				elseif SentryWards.icons_ground[v.handle+1] and GetDistance2D(SentryWards.icons_ground[v.handle+1].pos,z.position) <= 500 then
					SentryWards.icons_ground[v.handle+1].visible = false
					SentryWards.icons_ground[v.handle+1] = nil
					SentryWards.times[v.handle+1] = nil
					SentryWards.icons_minimap[v.handle+1].visible = false
					SentryWards.icons_minimap[v.handle+1] = nil
					SentryWards.ranges[v.handle+1] = nil
				end
			end
		end
	end
end
	
function GameClose()
	if ObserverWards.icons_ground then
		for i,v in pairs(ObserverWards.icons_ground) do
			v.visible = false
			ObserverWards.icons_ground[i] = nil
		end
	end
	if ObserverWards.icons_minimap then
		for i,v in pairs(ObserverWards.icons_minimap) do
			v.visible = false
			ObserverWards.icons_minimap[i] = nil
		end
	end
	if SentryWards.icons_ground then
		for i,v in pairs(SentryWards.icons_ground) do
			v.visible = false
			SentryWards.icons_ground[i] = nil
		end
	end
	if SentryWards.icons_minimap then
		for i,v in pairs(SentryWards.icons_minimap) do
			v.visible = false
			SentryWards.icons_minimap[i] = nil
		end
	end
	ObserverWards = {} ObserverWards.charges = {} ObserverWards.icons_ground = {} ObserverWards.times = {} ObserverWards.icons_minimap = {} ObserverWards.ranges = {}
	SentryWards = {} SentryWards.charges = {} SentryWards.icons_ground = {} SentryWards.times = {} SentryWards.icons_minimap = {} SentryWards.ranges = {}
	collectgarbage("collect")
end

function GameLoad()
	if ObserverWards.icons_ground then
		for i,v in pairs(ObserverWards.icons_ground) do
			v.visible = false
			ObserverWards.icons_ground[i] = nil
		end
	end
	if ObserverWards.icons_minimap then
		for i,v in pairs(ObserverWards.icons_minimap) do
			v.visible = false
			ObserverWards.icons_minimap[i] = nil
		end
	end
	if SentryWards.icons_ground then
		for i,v in pairs(SentryWards.icons_ground) do
			v.visible = false
			SentryWards.icons_ground[i] = nil
		end
	end
	if SentryWards.icons_minimap then
		for i,v in pairs(SentryWards.icons_minimap) do
			v.visible = false
			SentryWards.icons_minimap[i] = nil
		end
	end
	ObserverWards = {} ObserverWards.charges = {} ObserverWards.icons_ground = {} ObserverWards.times = {} ObserverWards.icons_minimap = {} ObserverWards.ranges = {}
	SentryWards = {} SentryWards.charges = {} SentryWards.icons_ground = {} SentryWards.times = {} SentryWards.icons_minimap = {} SentryWards.ranges = {}
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_LOAD, GameLoad)
script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
