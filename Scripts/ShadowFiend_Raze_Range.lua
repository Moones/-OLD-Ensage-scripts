sleep = 10

sleeptick = nil
coils = {}

function Tick( tick )
	if not client.connected or client.loading or client.console or not entityList:GetMyHero() or (sleeptick and tick < sleeptick + sleep ) then
		return		
	end

	me = entityList:GetMyHero()

	if me.name ~= "npc_dota_hero_nevermore" then				
		return
	else
	c_abs = {}
	table.insert(c_abs, me:GetAbility(1))	
	table.insert(c_abs, me:GetAbility(2))
	table.insert(c_abs, me:GetAbility(3))
	end
	
	R = {200, 450, 700}	
	alfa = me.rotR
	for i=1,3 do	
		local p = Vector(me.position.x + R[i] * math.cos(alfa), me.position.y + R[i] * math.sin(alfa), me.position.z)
				
		if not coils[i] then					
			if c_abs[i] and c_abs[i].state == -1 then
				coils[i] = Effect(p,  "range_display")
				coils[i]:SetVector(1, Vector(250,0,0) )
				coils[i]:SetVector(0, p )				
			end
		else
			if c_abs[i] and c_abs[i].state == - 1 then
				coils[i]:SetVector(0, p )	
			else
				coils[i] = nil
				collectgarbage("collect")
			end			
		end
	end			
	
	sleeptick = tick
end

script:RegisterEvent(EVENT_FRAME, Tick)
