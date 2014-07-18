require("libs.Utils")
require("libs.Res")
require("libs.DrawManager3D")

Prediction = {}

Prediction.trackTable = {}
Prediction.BlindPredictionTable = {}

function Prediction.__TrackTick(tick)
	Prediction.__Track()	
end

function Prediction.__Track()
	if not IsIngame() or client.console then return end
	local me = entityList:GetMyHero()	
	if not me then return end	
	for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO})) do	
		if v.team ~= me.team and not v:IsIllusion() then
			if Prediction.trackTable[v.handle] == nil and v.alive then
				Prediction.trackTable[v.handle] = {}
			elseif Prediction.trackTable[v.handle] ~= nil and not v.alive then
				Prediction.trackTable[v.handle] = nil
			elseif Prediction.trackTable[v.handle] then
				if v.visible then
					Prediction.trackTable[v.handle].last = {pos = v.position, move = v.movespeed}
				end
			end
			Prediction.BlindPrediction(v)
		end
	end
end

function Prediction.BlindPrediction(t)
	if Prediction.BlindPredictionTable[t.handle] == nil and t.alive then
		Prediction.BlindPredictionTable[t.handle] = {}
	elseif Prediction.BlindPredictionTable[t.handle] ~= nil and not t.alive then
		Prediction.BlindPredictionTable[t.handle] = nil
	elseif Prediction.BlindPredictionTable[t.handle] and Prediction.trackTable[t.handle] and Prediction.trackTable[t.handle].last then
		Prediction.BlindPredictionTable[t.handle].move = Prediction.trackTable[t.handle].last.move
		local pos = Prediction.trackTable[t.handle].last.pos local distance = Prediction.BlindPredictionTable[t.handle].move/(Prediction.BlindPredictionTable[t.handle].move/50) local cast = 0 local rotR = Prediction.BlindPredictionTable[t.handle].rotR
		if not Prediction.BlindPredictionTable[t.handle].icon then
			Prediction.BlindPredictionTable[t.handle].icon = drawMgr:CreateRect(0,0,18,18,0x000000ff, drawMgr:GetTextureId("NyanUI/miniheroes/"..t.name:gsub("npc_dota_hero_",""))) Prediction.BlindPredictionTable[t.handle].icon.visible = false
		end
		if not Prediction.BlindPredictionTable[t.handle].iconmap then
			Prediction.BlindPredictionTable[t.handle].iconmap = drawMgr3D:CreateRect(Vector(0,0,0), Vector(0,0,110), Vector2D(0,0), Vector2D(50,30), 0x000000ff, drawMgr:GetTextureId("NyanUI/heroes_horizontal/"..t.name:gsub("npc_dota_hero_",""))) Prediction.BlindPredictionTable[t.handle].iconmap.visible = false
		end
		if not t.visible then
			Prediction.BlindPredictionTable[t.handle].icon.visible = true
			Prediction.BlindPredictionTable[t.handle].iconmap.visible = true
			if not Prediction.BlindPredictionTable[t.handle].range then
				Prediction.BlindPredictionTable[t.handle].range = Vector(pos.x + Prediction.BlindPredictionTable[t.handle].move * (distance/(1600 * math.sqrt(1 - math.pow(Prediction.BlindPredictionTable[t.handle].move/1600,2))) + cast) * math.cos(t.rotR), pos.y + Prediction.BlindPredictionTable[t.handle].move * (distance/(1600 * math.sqrt(1 - math.pow(Prediction.BlindPredictionTable[t.handle].move/1600,2))) + cast) * math.sin(t.rotR), pos.z)	
				Prediction.BlindPredictionTable[t.handle].minimap = MapToMinimap(Prediction.BlindPredictionTable[t.handle].range.x,Prediction.BlindPredictionTable[t.handle].range.y)
				Prediction.BlindPredictionTable[t.handle].icon.x = Prediction.BlindPredictionTable[t.handle].minimap.x-20/2
				Prediction.BlindPredictionTable[t.handle].icon.y = Prediction.BlindPredictionTable[t.handle].minimap.y-20/2
				Prediction.BlindPredictionTable[t.handle].iconmap.pos = Prediction.BlindPredictionTable[t.handle].range
			else
				if Prediction.BlindPredictionTable[t.handle].range then
					Prediction.BlindPredictionTable[t.handle].range = Vector(Prediction.BlindPredictionTable[t.handle].range.x + Prediction.BlindPredictionTable[t.handle].move * (distance/(1600 * math.sqrt(1 - math.pow(Prediction.BlindPredictionTable[t.handle].move/1600,2))) + cast) * math.cos(t.rotR), Prediction.BlindPredictionTable[t.handle].range.y + Prediction.BlindPredictionTable[t.handle].move * (distance/(1600 * math.sqrt(1 - math.pow(Prediction.BlindPredictionTable[t.handle].move/1600,2))) + cast) * math.sin(t.rotR),Prediction.BlindPredictionTable[t.handle].range.z)
					Prediction.BlindPredictionTable[t.handle].minimap = MapToMinimap(Prediction.BlindPredictionTable[t.handle].range.x,Prediction.BlindPredictionTable[t.handle].range.y)
					Prediction.BlindPredictionTable[t.handle].icon.x = Prediction.BlindPredictionTable[t.handle].minimap.x-20/2
					Prediction.BlindPredictionTable[t.handle].icon.y = Prediction.BlindPredictionTable[t.handle].minimap.y-20/2
					Prediction.BlindPredictionTable[t.handle].iconmap.pos = Prediction.BlindPredictionTable[t.handle].range
				end
			end
		else
			Prediction.BlindPredictionTable[t.handle].icon.visible = false
			Prediction.BlindPredictionTable[t.handle].iconmap.visible = false
			Prediction.BlindPredictionTable[t.handle].range = nil
			collectgarbage("collect")
		end
	end
end

script:RegisterEvent(EVENT_TICK,Prediction.__TrackTick)
