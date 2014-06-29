require("libs.ScriptConfig")
require("libs.Utils")
require("libs.SideMessage")
require("libs.HeroInfo")

config = ScriptConfig.new()
config:SetParameter("Toggle", "G", config.TYPE_HOTKEY)
config:SetParameter("ToggleLasthits", "H", config.TYPE_HOTKEY)
config:SetParameter("ToggleDenies", "J", config.TYPE_HOTKEY)
config:SetParameter("enableLasthits", true)
config:SetParameter("enableDenies", true)
config:SetParameter("AutoOff", true)
config:Load()

togglekey = config.Toggle
togglelhkey = config.ToggleLasthits
toggledenykey = config.ToggleDenies
enablelasthits = config.enableLasthits
enabledenies = config.enableDenies
autooff = config.AutoOff
local active = nil local lasthit = nil local stage = 1

sleep = 0

local monitor = client.screenSize.x/1600
local F15 = drawMgr:CreateFont("F15","Tahoma",15*monitor,550*monitor)

trackTable = {}
lastTrackTick = 0

function __TrackTick(tick)
	if tick > lastTrackTick then
		__Track()
		lastTrackTick = tick + 100
	end
end

function __Track()
	local lasthits = {}
	local creeps = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Lane})
	local catapults = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Siege})
	for k,v in ipairs(creeps) do lasthits[#lasthits + 1] = v end
	for k,v in ipairs(catapults) do lasthits[#lasthits + 1] = v end
	for i,v in ipairs(lasthits) do
		if trackTable[v.handle] == nil and v.alive and v.visible then
			trackTable[v.handle] = {nil,nil,nil,v,nil}
		elseif trackTable[v.handle] ~= nil and (not v.alive or not v.visible) then
			trackTable[v.handle] = nil
		elseif trackTable[v.handle] then
			if trackTable[v.handle].last ~= nil then
				trackTable[v.handle].hploss = (trackTable[v.handle].last.hp - v.health)
			end
			trackTable[v.handle].last = {hp = v.health}
		end
	end
end


function Key(msg,code)	
    if client.chat then return end
	local me = entityList:GetMyHero()
	if not me then return end
	if msg ~= KEY_UP and code == togglekey then
		if not active then
			active = true
			GenerateSideMessage(me.name,"     Advanced CreepControl is ON!")
		else
			active = nil
			GenerateSideMessage(me.name,"    Advanced CreepControl is OFF!")
			if stage == 2 then
				script:UnregisterEvent(AutoOFF)
			end
		end
	end
	if msg ~= KEY_UP and code == togglelhkey then
		if not enablelasthits then
			enablelasthits = true
			GenerateSideMessage(me.name,"             Lasthitting is ON!")
		else 
			enablelasthits = nil
			GenerateSideMessage(me.name,"            Lasthitting is OFF!")
		end
	end
	if msg ~= KEY_UP and code == toggledenykey then
		if not enabledenies then
			enabledenies = true
			GenerateSideMessage(me.name,"                Denying is ON!")
		else
			enabledenies = nil
			GenerateSideMessage(me.name,"               Denying is OFF!")
		end
	end
	if msg == RBUTTON_DOWN then
		if active and autooff then
			local danger = {}
			for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,illusion=false,visible=true})) do
				if v.team ~= me.team then
					if GetDistance2D(me, v) < 1200 then
						danger[#danger + 1] = v
					end
				end
			end
			if danger[2] ~= nil then
				script:RegisterEvent(EVENT_TICK,AutoOFF)
			end
		end
	end
end

function AutoOFF()
	local me = entityList:GetMyHero()
	if stage == 1 then
		active = nil
		GenerateSideMessage(me.name,"Advanced CreepControl auto OFF!")
		stage = 2
		sleepp = math.floor(client.gameTime)		
	elseif sleepp + 5 <= math.floor(client.gameTime) and stage == 2 and active == nil then
		stage = 1
		GenerateSideMessage(me.name,"Advanced CreepControl auto ON!")
		active = true
	end
	if active == true then
		script:UnregisterEvent(AutoOFF)
	end
end

function Main(tick)
	if not client.connected or client.loading or client.console or sleep > tick or not SleepCheck() then return end	
	sleep = tick + 200
	local me = entityList:GetMyHero()	
	local player = entityList:GetMyPlayer()
	if not me or not player then return end
	local dmg = GetDamage(me)
	local lasthits = {}
	local creeps = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Lane})
	local catapults = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Siege})
	for k,v in pairs(creeps) do lasthits[#lasthits + 1] = v end
	for k,v in pairs(catapults) do lasthits[#lasthits + 1] = v end
	if active then
		for i,v in ipairs(lasthits) do
			script:RegisterEvent(EVENT_TICK,__TrackTick)
			local creepHp = nil
			--print(me.name)
			if v.visible and v.alive then
				if trackTable[v.handle] and trackTable[v.handle].hploss and trackTable[v.handle].hploss ~= 0 and trackTable[v.handle].hploss > 0 then
					if heroInfo[me.name].projectileSpeed then
						creepHp = (v.health - trackTable[v.handle].hploss * ((me.attackSpeed/100) - heroInfo[me.name].attackRate + heroInfo[me.name].attackPoint +1) - (me:GetDistance2D(v)/heroInfo[me.name].projectileSpeed)*10)
					else
						creepHp = (v.health - trackTable[v.handle].hploss * ((me.attackSpeed/100) - heroInfo[me.name].attackRate + heroInfo[me.name].attackPoint +1) - (me:GetDistance2D(v)/100))
					end
					if creepHp < ((dmg*(1-v.dmgResist)+1)*2) and creepHp > (dmg*(1-v.dmgResist)+1) and enablelasthits then
						if me.activity ~= 424 and not lasthit and v.team ~= me.team and me:GetDistance2D(v) < me.attackRange + 400 and me:GetDistance2D(v) > me.attackRange + 100 then
							player:Move(v.position)
						end
					end
				else
					creepHp = v.health
				end
				if me.activity ~= 424 and creepHp > 0 and creepHp <= (dmg*(1-v.dmgResist)+1) then
					if not lasthit and v.team ~= me.team and me:GetDistance2D(v) < me.attackRange + 200 and enablelasthits then
						lasthit = v
						player:Attack(v) break
					end
					if not lasthit and v.team == me.team and me:GetDistance2D(v) < me.attackRange + 200 and enabledenies then
						lasthit = v
						player:Attack(v) break
					end 
				end
			else
				lasthit = nil
			end
		end
		for i,v in ipairs(creeps) do
			local projectiles = entityList:GetProjectiles({target=me})
			for k,z in ipairs(projectiles) do
				if z.source then
					if z.source.type ~= LuaEntity.TYPE_HERO then
						if me.activity ~= 424 and v.team == me.team and v.visible and v.alive and me:GetDistance2D(v) < me.attackRange + 600 then	
							player:Attack(v)
							lasthit = nil
							Sleep(500)
						end
					end
				end
			end
		end
	else
		script:UnregisterEvent(__TrackTick)
	end
end

function GenerateSideMessage(heroname,msg)
	local sidemsg = sideMessage:CreateMessage(300,60,0x111111C0,0x444444FF,150,1000)
	sidemsg:AddElement(drawMgr:CreateRect(10,10,72,40,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/"..heroname:gsub("npc_dota_hero_",""))))
	sidemsg:AddElement(drawMgr:CreateText(85,16,-1,"" .. msg,F15))
end

function GetDamage(hero)
	local dmg =  hero.dmgMin + hero.dmgBonus
	local qblade = hero:FindItem("item_quelling_blade")
	if qblade then
		return dmg*1.32
	end
	return dmg
end 

script:RegisterEvent(EVENT_TICK,Main)
script:RegisterEvent(EVENT_KEY,Key)
