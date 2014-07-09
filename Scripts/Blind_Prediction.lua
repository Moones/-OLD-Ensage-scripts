require("libs.Utils")

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

script:RegisterEvent(EVENT_TICK,Prediction.__TrackTick)
