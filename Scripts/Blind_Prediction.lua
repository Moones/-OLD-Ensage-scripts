require("libs.Utils")
require("libs.ScriptConfig")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "F", config.TYPE_HOTKEY)
config:Load()

local togglekey = config.Hotkey
local active = true 

Prediction = {}

Prediction.trackTable = {}
Prediction.BlindPredictionTable = {}
Prediction.lastTrackTick = 0
Prediction.currentTick = 0

function Key(msg,code)	
    if msg ~= KEY_UP or client.chat then return end
	if code == togglekey then
		if not active then
			active = true
		else
			active = nil
		end
	end
end

function Prediction.__TrackTick(tick)
	Prediction.currentTick = tick
	if tick > Prediction.lastTrackTick + 50 then
		Prediction.__Track()
		Prediction.lastTrackTick = tick 	
	end
end

function Prediction.__Track()
	local all = entityList:GetEntities({type = LuaEntity.TYPE_HERO})
	for i,v in ipairs(all) do
		if Prediction.trackTable[v.handle] == nil and v.alive then
			Prediction.trackTable[v.handle] = {nil,nil,nil,v,nil}
		elseif Prediction.trackTable[v.handle] ~= nil and not v.alive then
			Prediction.trackTable[v.handle] = nil
		elseif Prediction.trackTable[v.handle] then
			if Prediction.trackTable[v.handle].last ~= nil then
				Prediction.trackTable[v.handle].speed = (v.position - Prediction.trackTable[v.handle].last.pos)/(Prediction.currentTick - Prediction.trackTable[v.handle].last.tick)
			end
			Prediction.trackTable[v.handle].last = {pos = v.position, hp = v.health, tick = Prediction.currentTick}
		end
	end
end

function Prediction.BlindPrediction(t)
	if Prediction.BlindPredictionTable[t.handle] == nil then
		Prediction.BlindPredictionTable[t.handle] = {nil,nil,nil,t,nil}
	elseif Prediction.BlindPredictionTable[t.handle] ~= nil and not t.alive then
		Prediction.BlindPredictionTable[t.handle] = nil
	elseif Prediction.BlindPredictionTable[t.handle] and Prediction.trackTable[t.handle] and Prediction.trackTable[t.handle].last then
		if Prediction.BlindPredictionTable[t.handle].move == nil or Prediction.BlindPredictionTable[t.handle].move < t.movespeed then Prediction.BlindPredictionTable[t.handle].move = t.movespeed end
		local pos = Prediction.trackTable[t.handle].last.pos local distance = Prediction.BlindPredictionTable[t.handle].move/(Prediction.BlindPredictionTable[t.handle].move/50) local cast = 0 local rotR = Prediction.BlindPredictionTable[t.handle].rotR local lasttime = Prediction.BlindPredictionTable[t.handle].time
		if not t.visible then
			if not Prediction.BlindPredictionTable[t.handle].eff then
				Prediction.BlindPredictionTable[t.handle].range = Vector(pos.x + Prediction.BlindPredictionTable[t.handle].move * (distance/(1600 * math.sqrt(1 - math.pow(Prediction.BlindPredictionTable[t.handle].move/1600,2))) + cast) * math.cos(t.rotR), pos.y + Prediction.BlindPredictionTable[t.handle].move * (distance/(1600 * math.sqrt(1 - math.pow(Prediction.BlindPredictionTable[t.handle].move/1600,2))) + cast) * math.sin(t.rotR), pos.z)	
				Prediction.BlindPredictionTable[t.handle].eff = Effect(Prediction.BlindPredictionTable[t.handle].range,  "range_display")
				Prediction.BlindPredictionTable[t.handle].eff:SetVector(1, Vector(65,0,0) )
				Prediction.BlindPredictionTable[t.handle].eff:SetVector(0, Prediction.BlindPredictionTable[t.handle].range)
			else
				if Prediction.BlindPredictionTable[t.handle].eff then
					Prediction.BlindPredictionTable[t.handle].range = Vector(Prediction.BlindPredictionTable[t.handle].range.x + Prediction.BlindPredictionTable[t.handle].move * (distance/(1600 * math.sqrt(1 - math.pow(Prediction.BlindPredictionTable[t.handle].move/1600,2))) + cast) * math.cos(t.rotR), Prediction.BlindPredictionTable[t.handle].range.y + Prediction.BlindPredictionTable[t.handle].move * (distance/(1600 * math.sqrt(1 - math.pow(Prediction.BlindPredictionTable[t.handle].move/1600,2))) + cast) * math.sin(t.rotR),Prediction.BlindPredictionTable[t.handle].range.z)
					Prediction.BlindPredictionTable[t.handle].eff:SetVector(0, Prediction.BlindPredictionTable[t.handle].range)
				else	
					Prediction.BlindPredictionTable[t.handle].eff = nil
					collectgarbage("collect")
				end
			end
		else
			Prediction.BlindPredictionTable[t.handle].eff = nil
			collectgarbage("collect")
		end
	end
end

function Main(tick)
	if not IsIngame() or client.console then return end
	local me = entityList:GetMyHero()	
	if not me then return end	
	if active then	
		for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true})) do	
			if v.team ~= me.team and not v:IsIllusion() then
				Prediction.BlindPrediction(v)
			end
		end
	end
end

script:RegisterEvent(EVENT_TICK,Prediction.__TrackTick)
script:RegisterEvent(EVENT_TICK,Main)
script:RegisterEvent(EVENT_KEY,Key)
