require("libs.Utils")
require("libs.HeroInfo")

wait = 0 waittime = 0 sleepTick = nil sleep1 = 0  sleepk = 0 tt = nil aa = nil
local activated = 0

function Tick( tick )
	if not client.connected or client.loading or client.console or not entityList:GetMyHero() then return end
	if not SleepCheck("blink") then client:ExecuteCmd("+dota_camera_center_on_hero") client:ExecuteCmd("-dota_camera_center_on_hero") return end
	if sleepTick and sleepTick > tick then return end	
	me = entityList:GetMyHero() if not me then return end
	--Silence Dispell
	if IsSilenced(me) or me:IsSilenced() then
		PurgeMyself()
		UseManta()
	elseif me:DoesHaveModifier("modifier_item_dustofappearance") and CanGoInvis(me) then
		PurgeMyself()
	end
	--Dodge by checking animations--
	local enemies = entityList:GetEntities({type = LuaEntity.TYPE_HERO, alive = true, visible = true, team = me:GetEnemyTeam()})
	for i,v in ipairs(enemies) do
		if not v:IsIllusion() then
			target = v
			if GotHex(v) and ((v:FindItem("item_sheepstick") and GetDistance2D(me,v) <= 900) or GetDistance2D(v,me) <= 500) then
				UseBlinkDagger() Antiblinkhome()
				SlarkDarkPact()
			end
			if v.name == "npc_dota_hero_shadow_shaman" then
				if v:GetAbility(1) and v:GetAbility(1).level > 0 and v:GetAbility(1).abilityPhase then
					if GetDistance2D(v,me) < 610 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							Nyx()
							TemplarRefraction()
						end
					end
				end
			elseif v.name == "npc_dota_hero_bane" then
				if v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase then
					if GetDistance2D(v,me) < 700 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							Nyx()
							TemplarRefraction()
							Useblackking()
							Juggernautfury()
						end
					end
				end
			elseif v.name == "npc_dota_hero_skeleton_king" then
				if v:GetAbility(1) and v:GetAbility(1).level > 0 and v:GetAbility(1).abilityPhase then
					if GetDistance2D(v,me) < 600 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						local turn = (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, UseBlinkDaggervec()))), 0)/(heroInfo[me.name].turnRate*(1/0.03)))
						if GetDistance2D(v,me) < 240 and turntime == 0 then
							UseBlinkDagger() Antiblinkhome()
							UseEulScepterTarget()
							PuckW(true)
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							UseShadowBlade()
							PLDoppleganger()
						end
						if not timesk then
							timesk = client.gameTime
						elseif turntime == 0 and client.gameTime >= timesk+v:GetAbility(1):FindCastPoint()-turn-client.latency/1000 then
							UseBlinkDagger() Antiblinkhome()
							UseEulScepterSelf()
							Puck()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							UseShadowBlade()
							PLDoppleganger()
							timesk = nil
						end
					end	
				else
					timesk = nil
				end
			elseif v.name == "npc_dota_hero_earthshaker" then
				if v:GetAbility(1) and v:GetAbility(1).level > 0 and v:GetAbility(1).abilityPhase then
					if GetDistance2D(v,me) < 1625 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						local turn = (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, UseBlinkDaggervec()))), 0)/(heroInfo[me.name].turnRate*(1/0.03)))
						if not timees then
							timees = client.gameTime
						elseif turntime == 0 and client.gameTime >= timees+v:GetAbility(1):FindCastPoint()-turn-client.latency/1000-0.1 then
							Puck()
							UseBlinkDagger() Antiblinkhome()
							UseEulScepterSelf()
							UseShadowBlade()
							PLDoppleganger()
							OracleFateEdict()
							timees = nil
						end
					end	
				elseif v:GetAbility(2) and v:GetAbility(2).level > 0 and v:GetAbility(2).abilityPhase then
					if GetDistance2D(v,me) < 325 then
						local turn = (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, UseBlinkDaggervec()))), 0)/(heroInfo[me.name].turnRate*(1/0.03)))
						if not timees2 then
							timees2 = client.gameTime
						elseif client.gameTime >= timees2+v:GetAbility(2):FindCastPoint()-turn-client.latency/1000-0.1 then
							Puck()
							UseBlinkDagger() Antiblinkhome()
							UseEulScepterSelf()
							UseShadowBlade()
							PLDoppleganger()
							timees2 = nil
						end
					end	
				else
					if not (v:GetAbility(2) and v:GetAbility(2).level > 0 and v:GetAbility(2).abilityPhase) then
						timees2 = nil
					end
					if not (v:GetAbility(1) and v:GetAbility(1).level > 0 and v:GetAbility(1).abilityPhase) then
						timees = nil
					end
				end
			elseif v.name == "npc_dota_hero_axe" then
				if v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase then
					if GetDistance2D(v,me) < 200 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							UseBlinkDagger() Antiblinkhome()
							UseEulScepterTarget()
							PuckW(true)
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							PLDoppleganger()
							OracleFalsePromise()
						end 
					end
				end
			elseif v.name == "npc_dota_hero_pudge" then
				if v:GetAbility(1) and v:GetAbility(1).level > 0 and v:GetAbility(1).abilityPhase then
					if GetDistance2D(v,me) < 400 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						local turn = (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, UseBlinkDaggervec()))), 0)/(heroInfo[me.name].turnRate*(1/0.03)))
						if GetDistance2D(v,me) < 300 and turntime == 0 then
							PuckW(true)
							UseBlinkDagger() Antiblinkhome()
							UseEulScepterTarget()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							UseShadowBlade()
							PLDoppleganger()
						end
						if not timep then
							timep = client.gameTime
						elseif turntime == 0 and client.gameTime >= timep+v:GetAbility(1):FindCastPoint()-turn-client.latency/1000 then
							PuckW(true)
							UseBlinkDagger() Antiblinkhome()
							UseEulScepterSelf()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							UseShadowBlade()
							PLDoppleganger()
							timep = nil
						end
					end	
				else
					timep = nil
				end
			elseif v.name == "npc_dota_hero_faceless_void" then
				if v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase then
					if GetDistance2D(v,me) <= 1050 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 2, 0))
						if turntime == 0 then
							UseBlinkDagger() Antiblinkhome()
							UseEulScepterTarget()
							if GetDistance2D(v,me) < 400 then
								PuckW(true)
							else
								Puck()
							end 
							target = v
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							UseHalberdtarget()
							UseGhostScepter()
							RazorStaticLink()
							UseEtherealtarget()
							PLDoppleganger()
							Emberremnantnow()
							Nyx()
							UseBladeMail()
						end
					end
				end
			elseif v.name == "npc_dota_hero_puck" then
				if v:GetAbility(2) and v:GetAbility(2).level > 0 and v:GetAbility(2).abilityPhase  then
					if GetDistance2D(v,me) < 400 then
						Nyx()
						UseBlinkDagger() Antiblinkhome()
						UseEulScepterSelf()
						TemplarRefraction()
						PLDoppleganger()
					end
				end
			elseif v.name == "npc_dota_hero_slardar" then
				if v:GetAbility(2) and v:GetAbility(2).level > 0 and v:GetAbility(2).abilityPhase  then
					if GetDistance2D(v,me) < 350 then
						Nyx()
						UseBlinkDagger() Antiblinkhome()
						UseEulScepterTarget()
						TemplarRefraction()
						PuckW(true)
						Useblackking()
						Lifestealerrage()
						UseSheepStickTarget()
						UseOrchidtarget() SkySilence()
						PLDoppleganger()
					end
				end
			elseif v.name == "npc_dota_hero_silencer" then
				if v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase then
					Nyx()
					if GetDistance2D(me,v) < 400 then
						PuckW(true)
					else
						Puck()
					end
					TemplarRefraction()
					Lifestealerrage()
					UseSheepStickTarget()
					UseOrchidtarget() SkySilence()
					PLDoppleganger()
					NagaMirror()
					ObsidianImprisonmentself()
				end
			elseif v.name == "npc_dota_hero_doom_bringer" then
				if v:GetAbility(6) and v:GetAbility(6).level > 0 and v:GetAbility(6).abilityPhase then
					if GetDistance2D(v,me) < 680 then
						if GetDistance2D(v,me) < 400 then
							PuckW(false)
							UseEulScepterTarget()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
						end
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							Nyx()
							Useshadowamulet()
							UseShadowBlade()
							Puck()
							Useblackking()
							Lifestealerrage()
							PLDoppleganger()
							OracleFalsePromise()
						end
					end
				end
			elseif v.name == "npc_dota_hero_nevermore" then
				if v:GetAbility(6) and v:GetAbility(6).level > 0 and v:GetAbility(6).abilityPhase then
					if GetDistance2D(v,me) < 900 then
						if GetDistance2D(v,me) < 400 then
							PuckW(true)
						end
						Nyx()
						Useshadowamulet()
						UseShadowBlade()
						Puck()
						UseSheepStickTarget()
						UseEulScepterTarget()
						Useblackking()
						Lifestealerrage()
						UseBlinkDagger() Antiblinkhome()
						OracleFateEdict()
					end
				end
			elseif v.name == "npc_dota_hero_sven" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 15 then
					if GetDistance2D(v,me) < 680 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							Nyx()
							Useshadowamulet()
						end
					end
				end
			elseif v.name == "npc_dota_hero_bloodseeker" then
				if  v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase then
					if GetDistance2D(v,me) < 1000 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							Nyx()
							TemplarMeld()
							TemplarRefraction()
							UseShadowBlade()
							Useshadowamulet()
						end
					end
				end
			elseif v.name == "npc_dota_hero_queenofpain" then
				if  v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase then
					if GetDistance2D(v,me) < 1200 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							OracleFateEdict()
						end
					end
				end
			elseif v.name == "npc_dota_hero_lina" then
				if  v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase then
					if GetDistance2D(v,me) < 900 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							OracleFateEdict()
						end
					end
				end
			elseif v.name == "npc_dota_hero_lion" then
				if  v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase then
					if GetDistance2D(v,me) < 900 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							OracleFateEdict()
						end
					end
				end
			elseif v.name == "npc_dota_hero_night_stalker" then
				if  v:GetAbility(1) and v:GetAbility(1).level > 0 and v:GetAbility(1).abilityPhase then
					if GetDistance2D(v,me) < 535 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							Nyx()
						end
					end
				end
			elseif v.name == "npc_dota_hero_luna" then
				if v:GetAbility(1) and v:GetAbility(1).level > 0 and v:GetAbility(1).abilityPhase then
					if GetDistance2D(v,me) < 810 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							Nyx()
							OracleFateEdict()
						end
					end
				end
			elseif v.name == "npc_dota_hero_chaos_knight" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 11 then
					if GetDistance2D(v,me) < 680 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							if wait == 0 then
								waittime = GetTick() + 80 - (client.avgLatency / 1000)
								wait = 1 
							else
								if GetTick() > waittime then
									StormUltfront()
									Nyx()
									Useshadowamulet()
									wait = 0
									sleepTick= GetTick() + 1000
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_magnataur" then
				if v:GetAbility(1) and v:GetAbility(1).level > 0 and v:GetAbility(1).abilityPhase then
					if GetDistance2D(v,me) < 200 then
						PuckW(true)	
						target = v
						UseShadowBlade()
						Useblackking()
						UseEulScepterSelf()
						UseBlinkDagger() Antiblinkhome()
						UseSheepStickTarget()
						UseOrchidtarget() SkySilence()
					end
				end
				if v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase then
					if GetDistance2D(v,me) < 400 then
						PuckW(true)	
					end
					if GetDistance2D(v,me) < 420 then
						target = v
						Puck()
						UseShadowBlade()
						Useblackking()
						UseEulScepterSelf()
						UseBlinkDagger() Antiblinkhome()
						UseSheepStickTarget()
						UseOrchidtarget() SkySilence()
					end
				end
				if v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase then
					if GetDistance2D(v,me) < 420 then
						if not timerp then
							timerp = client.gameTime
						elseif client.gameTime >= timerp+v:GetAbility(4):FindCastPoint()-0.1-client.latency/1000 then							
							UseManta()
							timerp = nil
						end
					end	
				else
					if not (v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase) then
						timerp = nil
					end
				end
			elseif v.name == "npc_dota_hero_tinker" then
				if v:GetAbility(1) and v:GetAbility(1).level > 0 and v:GetAbility(1).abilityPhase then
					if GetDistance2D(v,me) < 680 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							if wait == 0 then
								waittime = GetTick() + 200 - (client.avgLatency/1000)
								wait = 1 								
							elseif GetTick() > waittime then
								UseShadowBlade()
								Nyx()
								Puck()
								Lifestealerrage()
								wait = 0								
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_ogre_magi" then
				if v:GetAbility(1) and v:GetAbility(1).level > 0 and v:GetAbility(1).abilityPhase then
					if GetDistance2D(v,me) < 650 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							if wait == 0 then
								waittime = GetTick() + 200 - (client.avgLatency/1000)
								wait = 1 
							else
								if GetTick() > waittime then
									Nyx()
									wait = 0
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_zuus" then
				if v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase then
					if wait == 0 then					
						waittime = GetTick() + 100 - (client.avgLatency/1000)
						wait = 1 						
					elseif GetTick() > waittime then
						Nyx()
						UseShadowBlade()
						TemplarMeld()
						PLDoppleganger()
						SandkinSandstorm()
						NyxVendetta()
						Puck()
						Lifestealerrage()
						UseEulScepterSelf()
						wait = 0						
				elseif  v:GetAbility(2) and v:GetAbility(2).level > 0 and v:GetAbility(2).abilityPhase then
					if GetDistance2D(v,me) < 760 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							if wait == 0 then
								waittime = GetTick() + 100 - (client.avgLatency / 1000)
								wait = 1 
							else
								if GetTick() > waittime then
									Nyx()
									wait = 0
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_templar_assassin" then
		        if v:DoesHaveModifier("modifier_templar_assassin_meld") then                                                      
					if GetDistance2D(v,me) < 390 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
						if turntime == 0 then
							if wait == 0 then
								waittime = GetTick() + 1 - (client.avgLatency / 1000)
								wait = 1 
							else
								if GetTick() > waittime then
									Nyx()
									wait = 0
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_clinkz" then
		        if v:DoesHaveModifier("modifier_clinkz_strafe") then                                                      
					if v.activity == LuaEntityNPC.ACTIVITY_ATTACK then
						if GetDistance2D(v,me) < 650 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								if wait == 0 then
									waittime = GetTick() + 10 - (client.avgLatency/1000)
									wait = 1 
								else
									if GetTick() > waittime then
										Nyx()
										wait = 0
									end
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_phantom_assassin" then
				if v.activity == LuaEntityNPC.ACTIVITY_CRIT then
					if GetDistance2D(v,me) < 360 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.60, 0))
						if turntime == 0 then
							if wait == 0 then
								waittime = GetTick() + 10 - (client.avgLatency / 1000)
								wait = 1 
							else
								if GetTick() > waittime then
									Nyx()
									TemplarMeld()
									TemplarRefraction()
									SandkinSandstorm()
									PLDoppleganger()
									UseBladeMail()
									wait = 0
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_tusk" then
		        if v:DoesHaveModifier("modifier_tusk_walrus_punch") then                                                      
					if v.activity == LuaEntityNPC.ACTIVITY_ATTACK then
						if GetDistance2D(v,me) < 360 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.60, 0))
							if turntime == 0 then
								if wait == 0 then
									waittime = GetTick() + 10 - (client.avgLatency / 1000)
									wait = 1 
								else
									if GetTick() > waittime then
										Nyx()
										wait = 0
									end
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_ursa" then
		        if v:DoesHaveModifier("modifier_ursa_overpower") then                                                      
					if v.activity == LuaEntityNPC.ACTIVITY_ATTACK then
						if GetDistance2D(v,me) < 360 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.60, 0))
							if turntime == 0 then
								if wait == 0 then
									waittime = GetTick() + 10 - (client.avgLatency / 1000)
									wait = 1 
								else
									if GetTick() > waittime then
										Nyx()
										wait = 0
									end
								end
							end
						end
					end
				elseif v:GetAbility(1) and v:GetAbility(1):CanBeCasted() and v:GetAbility(1).abilityPhase then
					if GetDistance2D(v,me) < 389 then
						if wait == 0 then
							waittime = GetTick() + 10 - (client.avgLatency / 1000)
							wait = 1 
						else
							if GetTick() > waittime then
								Nyx()
								wait = 0
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_undying" then
				if v:GetAbility(1) and v:GetAbility(1):CanBeCasted() and v:GetAbility(1).abilityPhase then
					if GetDistance2D(v,me) < 760 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							if wait == 0 then
								waittime = GetTick() + 100 - (client.avgLatency / 1000)
								wait = 1 
							else
								if GetTick() > waittime then
									Nyx()
									wait = 0
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_abaddon" then
				if v:GetAbility(1) and v:GetAbility(1):CanBeCasted() and v:GetAbility(1).abilityPhase then
					if GetDistance2D(v,me) < 820 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							if wait == 0 then
								waittime = GetTick() + 100 - (client.avgLatency / 1000)
								wait = 1 
							else
								if GetTick() > waittime then
									Nyx()
									wait = 0
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_bounty_hunter" then
				if v:GetAbility(1) and v:GetAbility(1):CanBeCasted() and v:GetAbility(1).abilityPhase then
					if GetDistance2D(v,me) < 660 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							if wait == 0 then
								waittime = GetTick() + 100 - (client.avgLatency / 1000)
								wait = 1 
							else
								if GetTick() > waittime then
									Nyx()
									wait = 0
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_troll_warlord" then
				if v:GetAbility(2) and v:GetAbility(2):CanBeCasted() and v:GetAbility(2).abilityPhase then
					if GetDistance2D(v,me) < 450 then
						if wait == 0 then
							waittime = GetTick() + 100 - (client.avgLatency / 1000)
							wait = 1 
						else
							if GetTick() > waittime then
								Nyx()
								wait = 0
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_queenofpain" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 8 then
					if GetDistance2D(v,me) < 760 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.70, 0))
						if turntime == 0 then
							if wait == 0 then
								waittime = GetTick() + 100 - (client.avgLatency / 1000)
								wait = 1 
							else
								if GetTick() > waittime then
									Nyx()
									wait = 0
								end
							end
						end
					end
				elseif v:GetProperty("CBaseAnimating","m_nSequence") ==7 then
					if GetDistance2D(v,me) < 475 then
						Nyx()
					end
				end
			elseif v.name == "npc_dota_hero_crystal_maiden" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 7 then
					if GetDistance2D(v,me) < 1050 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.70, 0))
						if turntime == 0 then
							if wait == 0 then
								waittime = GetTick() + 100 - (client.avgLatency / 1000)
								wait = 1 
							else
								if GetTick() > waittime then
									Nyx()
									wait = 0
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_obsidian_destroyer" then
				if v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase then
				Radius = {375,475,575}
					if GetDistance2D(v,me) < v:GetAbility(4):GetCastRange(v:GetAbility(4).level)+Radius[v:GetAbility(4).level]/2 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.70, 0))
						if turntime == 0 then
							Nyx()
							if GetDistance2D(v,me) < 400 then
								PuckW(true)
							else
								Puck()
							end
							UseEulScepterSelf()
							UseBlinkDagger() Antiblinkhome()
							Useblackking()
							Lifestealerrage()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
						end
					end
				end
			elseif v.name == "npc_dota_hero_lich" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 6 then
					if GetDistance2D(v,me) < 610 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
						if turntime == 0 then
							if wait == 0 then
								waittime = GetTick() + 100 - (client.avgLatency / 1000)
								wait = 1 
							else
								if GetTick() > waittime then
									Nyx()
									wait = 0
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_slardar" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 6 then
					if GetDistance2D(v,me) < 360 then
						if wait == 0 then
							waittime = GetTick() + 150 - (client.avgLatency / 1000)
							wait = 1 
						else
							if GetTick() > waittime then
								Nyx()
								wait = 0
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_centaur" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 6 then
					if GetDistance2D(v,me) < 320 then
						if wait == 0 then
							waittime = GetTick() +150 -(client.avgLatency / 1000)
							wait = 1 
						else
							if GetTick() > waittime then
								Nyx()
								wait = 0
							end
						end
					end
				elseif v:GetProperty("CBaseAnimating","m_nSequence") == 8 then
					if GetDistance2D(v,me) < 340 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 1.7, 0))
						if turntime == 0 then
							if wait == 0 then
								waittime = GetTick() + 150 - (client.avgLatency / 1000)
								wait = 1 
							else
								if GetTick() > waittime then
									Nyx()
									wait = 0
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_dragon_knight" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 10 then
					if GetDistance2D(v,me) < 600 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
						if turntime == 0 then
							Nyx()
						end
					end
				end
			elseif v.name == "npc_dota_hero_riki" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 35 then
					if GetDistance2D(v,me) < 600 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
						if turntime == 0 then
							Nyx()
						end
					end
				end
			elseif v.name == "npc_dota_hero_mirana" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 11 then
					if GetDistance2D(v,me) < 630 then
						Nyx()
						UseShadowBlade()
						SandkinSandstorm()
						PLDoppleganger()
						WeaverShukuchi()
					end
				end
			elseif v.name == "npc_dota_hero_legion_commander" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 17 then
					if GetDistance2D(v,me) < 400 then
						Nyx()
					end
				end
			elseif v.name == "npc_dota_hero_necrolyte" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 2 then
					if GetDistance2D(v,me) < 650 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							Nyx()
							Useblackking()
						end
					end
				end
			elseif v.name == "npc_dota_hero_spirit_breaker" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 16 then
					if GetDistance2D(v,me) < 720 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							if wait == 0 then
								waittime = GetTick() +400 -(client.avgLatency / 1000)
								wait = 1 
							else
								if GetTick() > waittime then
									Nyx()
									wait = 0
								end
							end
						end
					end
				end
			elseif v.name == "npc_dota_hero_doom_bringer" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 9 then
					if GetDistance2D(v,me) < 570 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							Nyx()			
						end
					end
				end
			elseif v.name == "npc_dota_hero_bane" then
				if v:GetProperty("CBaseAnimating","m_nSequence") == 12  or v:GetProperty("CBaseAnimating","m_nSequence") == 14 or v:GetProperty("CBaseAnimating","m_nSequence") == 13  then
					if GetDistance2D(v,me) < 570 then
						turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
						if turntime == 0 then
							StormUltfront()
							Nyx()
						end
					end
				end
			end
	
			--Dodge by modifiers--
			
			if me:DoesHaveModifier("modifier_lina_laguna_blade") then  
				Puck()
				Nyx()
				TemplarRefraction()
				Embersleighttargetcal()
				Emberremnantnow()
				EmberGuard()
				UseEulScepterSelf()	
				PLDoppleganger()
				Useblackking()
				UseShadowBlade()
				if v:GetAbility(4) and v:GetAbility(4).name == "lina_laguna_blade" then
					target = v
					TusksnowballTarget()
					if v:GetAbility(4):GetDamage(v:GetAbility(4).level) * (1 - me.magicDmgResist) >= me.health then
						Phoenixsupernova()
						Abaddonult()
						UseBloodStone()
					else
						sleepTick = GetTick() + 550	
					end
				end
				if not v:AghanimState() then
					Juggernautfury()
					Lifestealerrage()
				end
				UseBladeMail()
				return				
			elseif me:DoesHaveModifier("modifier_pudge_meat_hook") then                                                      
				if v:GetAbility(1) and v:GetAbility(1).name == "pudge_meat_hook" then
					target = v
					PuckW(false)
					UseEulScepterTarget()
					UseOrchidtarget() SkySilence()
					Emberremnantnow()
					OracleFalsePromise()
					UseSheepStickTarget()						
				end
				UseShadowBlade()
				UseManta()
			elseif me:DoesHaveModifier("modifier_crystal_maiden_freezing_field_slow") then                                                      
				Nyx()
				Useblackking()
			elseif me:DoesHaveModifier("modifier_pugna_life_drain") then  
				Nyx()
				Puck()
				PLDoppleganger()
			elseif me:DoesHaveModifier("modifier_orchid_malevolence_debuff") then  
				UseBlinkDagger() Antiblinkhome()
				UseEulScepterTarget()	
				UseSheepStickTarget()
				UseOrchidtarget() SkySilence()
				UseManta()
			elseif me:DoesHaveModifier("modifier_lion_finger_of_death") then    
				Nyx()
				Juggernautfury()
				Puck()
				Lifestealerrage()
				TemplarRefraction()
				Embersleighttargetcal()
				Emberremnantnow()
				EmberGuard()					
				UseEulScepterSelf()
				Useblackking()
				PLDoppleganger()
				OracleFateEdict()
				if v:GetAbility(4) and v:GetAbility(4).name == "lion_finger_of_death" then
					target = v
					TusksnowballTarget()
					if v:GetAbility(4):GetDamage(v:GetAbility(4).level) * (1 - me.magicDmgResist) >= me.health then
						Phoenixsupernova()
						Abaddonult()
						UseBloodStone()
					else
						sleepTick = GetTick() + 550	
					end
				end
				UseBladeMail()
				return	
			elseif me:DoesHaveModifier("modifier_spirit_breaker_charge_of_darkness_vision") then	
				if v.classId == CDOTA_Unit_Hero_SpiritBreaker then
					if GetDistance2D(v,me) < 700 then
						if GetDistance2D(v,me) < 400 then
							Puck()
						end
						UseEulScepterTarget()
						UseSheepStickTarget()
						UseOrchidtarget() SkySilence()
						UseShadowBlade()
						Nyx()
					end
				end
			end
			
			--Projectile dodge--

			local cast = entityList:GetEntities({classId=282})
			local rocket = entityList:GetEntities({classId=CDOTA_BaseNPC})
			local hit = entityList:GetProjectiles({source=v,target=me})
			local notvisible_enemies = entityList:GetEntities({type = LuaEntity.TYPE_HERO, alive = true, team = me:GetEnemyTeam()})
			local projs = entityList:GetProjectiles({})
			for i,k in ipairs(projs) do
				if k.target == me then
					if k.name == "tinker_missile" then
						Nyx()
						Puck()
						TemplarMeld()
						Embersleighttargetcal()
						LoneDruidUlt()
						UseBlinkDaggerfront()
						UseShadowBlade()
						Embersleighttargetcal()
						PLDoppleganger()
						OracleFateEdict()
						return
					elseif k.name == "phantom_assassin_stifling_dagger" then
						Nyx()
						Puck()
						TemplarMeld()
						Embersleighttargetcal()
						LoneDruidUlt()
						UseBlinkDagger() Antiblinkhome()
						UseShadowBlade()
						Embersleighttargetcal()
						PLDoppleganger()
						return
					elseif k.name == "queen_scream_of_pain" then
						Nyx()
						Puck()
						TemplarMeld()
						Embersleighttargetcal()
						LoneDruidUlt()
						UseBlinkDagger() Antiblinkhome()
						UseShadowBlade()
						Embersleighttargetcal()
						PLDoppleganger()
						return
					elseif k.name == "ogre_magi_ignite" then
						Nyx()
						Puck()
						TemplarMeld()
						Embersleighttargetcal()
						LoneDruidUlt()
						UseBlinkDaggerfront()
						UseShadowBlade()
						Embersleighttargetcal()
						PLDoppleganger()
						return
					elseif k.name == "necrolyte_pulse_enemy" and GetDistance2D(me,k.position) < 200 then
						Nyx()
						Puck()
						LoneDruidUlt()
						UseEulScepterSelf()
						PLDoppleganger()
						return
					elseif k.speed == 1000 and v:GetAbility(4).name == "huskar_life_break" then
						if math.ceil(v:GetAbility(4).cd - 0.1) == math.ceil(v:GetAbility(4):GetCooldown(v:GetAbility(4).level)) then									
							Puck()
							Nyx()
							SlarkShadowDance()
							Juggernautfury()
							Lifestealerrage()
							Embersleighttargetcal()
							UseEulScepterSelf()
							UseBlinkDagger() Antiblinkhome()
							UseShadowBlade()
							Useshadowamulet()
							Useblackking()
							UseBladeMail()
							PLDoppleganger()
							OracleFateEdict()
							return
						end
					elseif k.name == "sniper_assassinate" then
						Puck()
						UseBlinkDagger() Antiblinkhome()
						TemplarRefraction()
						AlchemistRage()
						Juggernautfury()
						Nyx()
						UseEulScepterSelf()
						LoneDruidUlt()
						SlarkPounce()
						UseManta()
						UseBladeMail()
						PLDoppleganger()
						EmberGuard()
						if v:GetAbility(4).name == "sniper_assassinate" then
							local sniperultdamage = 0
							if v:GetAbility(4).level == 1 then
								sniperultdamage = 350*3/4
							end
							if v:GetAbility(4).level == 2 then
								sniperultdamage = 505*3/4
							end
							if v:GetAbility(4).level == 3 then
								sniperultdamage = 655*3/4
							end
							if sniperultdamage > me.health then
								if GetDistance2D(v,me) > 1000 then
									ShadowdemonDisruptionself()
									ObsidianImprisonmentself()
								end
								Phoenixsupernova()
								UseBloodStone()
							end
						end
						return
					end
				end
				if k.name == "windrunner_shackleshot" and (k.target == me or AngleBelow(v,k.target,me,7)) then
					Puck()
					Nyx()
					UseBlinkDagger() Antiblinkhome()
					UseShadowBlade()
					SlarkDarkPact()
					SlarkPounce()
					PLDoppleganger()
					return
				end
			end
			for i, z in ipairs(rocket) do
				if z.dayVision == 1000 and z:DoesHaveModifier("modifier_truesight") then
					if GetDistance2D(z,me) < 300 then
						if GetDistance2D(z,me) < 200 + client.latency then
							Puck()
							Lifestealerrage()
							Juggernautfury()
							UseEulScepterSelf()
							SlarkDarkPact()
							SlarkPounce()						
						else
							UseBlinkDagger() Antiblinkhome()							
						end
						return
					end
				elseif z.dayVision == 0 and z.unitState == 59802112 then
					if GetDistance2D(z,me) < 700 then
						if v.classId == CDOTA_Unit_Hero_SpiritBreaker then
							if GetDistance2D(v,me) < 900 then
								target = v 
								UseEulScepterTarget()
								UseSheepStickTarget()
								return
							end
						end
					end
				elseif #z.modifiers > 0 and z:DoesHaveModifier("modifier_lina_light_strike_array") then
					for i,k in ipairs(notvisible_enemies) do
						if k.classId == CDOTA_Unit_Hero_Lina and GetDistance2D(z,me) < 250 then
							Puck()
							UseBlinkDagger() Antiblinkhome()
							Lifestealerrage()
							Juggernautfury()
							UseEulScepterSelf()
							SlarkDarkPact()
							SlarkPounce()	
							PLDoppleganger()
							OracleFateEdict()
							return
						end
					end
				elseif #z.modifiers > 0 and z:DoesHaveModifier("modifier_leshrac_split_earth_thinker") then
					for i,k in ipairs(notvisible_enemies) do
						if k.classId == CDOTA_Unit_Hero_Leshrac and GetDistance2D(z,me) < GetSpecial(k:GetAbility(1),"radius",k:GetAbility(1).level+0)+25 then
							Puck()
							UseBlinkDagger() Antiblinkhome()
							Lifestealerrage()
							Juggernautfury()
							UseEulScepterSelf()
							SlarkDarkPact()
							SlarkPounce()	
							PLDoppleganger()
							return
						end
					end
				end
			end	
			
			for i, z in ipairs(rocket) do
				if z.team ~= me.team and z:DoesHaveModifier("modifier_rattletrap_rocket_flare") then
					if GetDistance2D(z,me) < 650 then
						Puck()
						UseBlinkDagger()
						if v:GetAbility(3).name == "rattletrap_rocket_flare" then
							if v:GetAbility(3):GetDamage(v:GetAbility(3).level)*(1 - me.magicDmgResist) >= me.health then
								UseEulScepterSelf()
								return
							end
						end
					end
				end
			end
			
			for i, z in ipairs(hit) do
				local ShadowBlade = v:FindItem("item_invis_sword")
				if ShadowBlade and ShadowBlade.cd > 14 then
					target = v
					Puck()
					UseBlinkDagger() Antiblinkhome()
					UseEulScepterTarget()
					UseSheepStickTarget()
					UseOrchidtarget() SkySilence()
					UseShadowBlade()
					SlarkPounce()
					PLDoppleganger()
					return
				end
				if z.source and z.source.dmgMin >= me.health then
					target = v
					Puck()
					UseBlinkDagger() Antiblinkhome()
					UseEulScepterSelf()
					UseSheepStickTarget()
					UseOrchidtarget() SkySilence()
					UseShadowBlade()
					SlarkPounce()
					PLDoppleganger()
					ObsidianImprisonmentself()
					SlarkShadowDance()
					return
				end
			end
			
			--Initiation dodge--
			local blink = v:FindItem("item_blink")
			if blink and blink.cd > 11 and v:CanCast() then                                 
				for s = 1, 6 do
					target = v
					if v:GetAbility(s) ~= nil and v:GetAbility(s).state == LuaEntityAbility.STATE_READY then
						if v:GetAbility(s).name == "tiny_avalanche" and GetDistance2D(v,me) < 500 then
							Puck()
							Jugernautomnitarget()
							Lifestealerrage()
							Silencerult()
							UseBlinkDagger() Antiblinkhome()
							Slardar()
							UseEulScepterTarget()
							Juggernautfury()
							PLDoppleganger()
							return 
						elseif v:GetAbility(s).name == "tidehunter_ravage" and GetDistance2D(v,me) < 1050 then
							if GetDistance2D(v,me) < 400 then
								PuckW(true)
								UseSheepStickTarget()
								UseOrchidtarget() SkySilence()
								UseEulScepterTarget()
								UseBlinkDagger() Antiblinkhome()
								Emberremnantnow()
							else
								Emberremnantnow()
								Silencerult()
								TusksnowballTarget()
								UseSheepStickTarget()
								UseBlinkDagger() Antiblinkhome()
								UseOrchidtarget() SkySilence()
								UseEulScepterTarget()
								Puck()
							end
							PLDoppleganger()
							return 
						elseif v:GetAbility(s).name == "puck_waning_rift" and GetDistance2D(v,me) < 400 then
							Emberremnantnow()
							Silencerult()
							UseSheepStickTarget()
							UseBlinkDagger() Antiblinkhome()
							UseOrchidtarget() SkySilence()
							UseEulScepterSelf()
							PLDoppleganger()
							return 
						elseif v:GetAbility(s).name == "treant_overgrowth" and GetDistance2D(v,me) < 625 then
							if GetDistance2D(v,me) < 400 then
								PuckW(true)
								Emberremnantnow()
								UseSheepStickTarget()
								UseOrchidtarget() SkySilence()
								UseEulScepterTarget()
								UseBlinkDagger() Antiblinkhome()
								UseShadowBlade()
							else
								Emberremnantnow()
								UseSheepStickTarget()
								UseOrchidtarget() SkySilence()
								UseEulScepterTarget()
								Puck()
								UseBlinkDagger() Antiblinkhome()
								UseShadowBlade()
							end
							PLDoppleganger()
							return 
						elseif v:GetAbility(s).name == "centaur_hoof_stomp" and GetDistance2D(v,me) < 320 then
							PuckW(true)
							Silencerult()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							Emberremnantnow()
							UseEulScepterTarget()
							UseBlinkDagger() Antiblinkhome()
							Juggernautfury()
							PLDoppleganger()
							return 	
						elseif v:GetAbility(s).name == "slardar_slithereen_crush" and GetDistance2D(v,me) < 350 then
							PuckW(true)	
							Emberremnantnow()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							UseEulScepterTarget()
							UseBlinkDagger() Antiblinkhome()
							UseBlinkDagger() Antiblinkhome()
							Juggernautfury()
							PLDoppleganger()
							return 	
						elseif v:GetAbility(s).name == "brewmaster_thunder_clap" and GetDistance2D(v,me) < 400 then
							PuckW(true)
							Emberremnantnow()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							UseEulScepterTarget()
							UseBlinkDagger() Antiblinkhome()
							Juggernautfury()
							PLDoppleganger()
							return 		
						elseif v:GetAbility(s).name == "venomancer_poison_nova" and GetDistance2D(v,me) < 830 then
							Emberremnantnow()
							Silencerult()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							UseEulScepterTarget()
							Puck()
							UseBlinkDagger() Antiblinkhome()
							Juggernautfury()
							PLDoppleganger()
							return 	
						elseif v:GetAbility(s).name == "magnataur_reverse_polarity" and GetDistance2D(v,me) < 410 then
							if GetDistance2D(v,me) < 400 then
								PuckW(true)
								Emberremnantnow()
								Silencerult()
								UseSheepStickTarget()
								UseOrchidtarget() SkySilence()
								UseEulScepterTarget()
								UseBlinkDagger() Antiblinkhome()
								UseShadowBlade()
							else
								Emberremnantnow()
								Silencerult()							
								UseSheepStickTarget()
								UseOrchidtarget() SkySilence()
								UseEulScepterTarget()
								Puck()
								UseBlinkDagger() Antiblinkhome()
								UseShadowBlade()								
							end
							PLDoppleganger()
							return 	
						elseif v:GetAbility(s).name == "enigma_black_hole" and GetDistance2D(v,me) < 700 then
							if GetDistance2D(v,me) < 400 then
								PuckW(true)
								Emberremnantnow()
								Silencerult()
								UseSheepStickTarget()
								UseOrchidtarget() SkySilence()
								UseEulScepterTarget()
								UseBlinkDagger() Antiblinkhome()
								UseShadowBlade()
							else
								Emberremnantnow()
								Silencerult()							
								UseSheepStickTarget()
								UseOrchidtarget() SkySilence()
								UseEulScepterTarget()
								Puck()
								UseBlinkDagger() Antiblinkhome()
								UseShadowBlade()								
							end
							PLDoppleganger()
							return 	
						elseif v:GetAbility(s).name == "magnataur_skewer" and GetDistance2D(v,me) < 300 then
							Emberremnantnow()
							UseEulScepterTarget()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							PuckW(true)
							UseBlinkDagger() Antiblinkhome()
							PLDoppleganger()
							return 
						elseif v:GetAbility(s).name == "batrider_flaming_lasso" and GetDistance2D(v,me) < 300 then
							Emberremnantnow()
							Silencerult()
							UseEulScepterTarget()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							PuckW(true)
							UseBlinkDagger() Antiblinkhome()
							Juggernautfury()
							UseShadowBlade()
							PLDoppleganger()
							return 	
						elseif v:GetAbility(s).name == "pudge_dismember" and GetDistance2D(v,me) < 200 then
							Emberremnantnow()
							Silencerult()
							UseEulScepterTarget()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							PuckW(false)
							UseBlinkDagger() Antiblinkhome()
							Juggernautfury()
							PLDoppleganger()
							return 	
						elseif v:GetAbility(s).name == "axe_berserkers_call" and GetDistance2D(v,me) < 300 then
							Emberremnantnow()
							PuckW(true)
							UseEulScepterTarget()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							UseBlinkDagger() Antiblinkhome()
							Juggernautfury()
							PLDoppleganger()
							return 	
						elseif v:GetAbility(s).name == "legion_commander_duel" and GetDistance2D(v,me) < 250 then
							PuckW(true)
							Emberremnantnow()
							UseEulScepterTarget()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							UseGhostScepter()
							UseHalberdtarget()
							UseEtherealtarget()
							Silencerult()
							UseBlinkDagger() Antiblinkhome()
							PLDoppleganger()
							return 
						elseif v:GetAbility(s).name == "earthshaker_echo_slam" and GetDistance2D(v,me) < 575 and v:GetAbility(s).state == -1 then
							PuckW(true)
							Emberremnantnow()
							UseEulScepterSelf()
							UseSheepStickTarget()
							UseOrchidtarget() SkySilence()
							Silencerult()
							UseBlinkDagger() Antiblinkhome()
							PLDoppleganger()
							return 
						end
					end
					
					if v.name == "npc_dota_hero_templar_assassin" and GetDistance2D(v,me) < 380 then
						Puck()
						UseEulScepterTarget()
						UseSheepStickTarget()
						UseOrchidtarget() SkySilence()
						UseBlinkDagger() Antiblinkhome()
						PLDoppleganger()
						return
					elseif v.name == "npc_dota_hero_ursa" and GetDistance2D(v,me) < 385 then
						UseBlinkDagger() Antiblinkhome()
						Puck()
						UseEulScepterTarget()
						UseSheepStickTarget()
						UseOrchidtarget() SkySilence()
						PLDoppleganger()
						SkySilence()
						return					
					elseif v.name == "npc_dota_hero_meepo" and GetDistance2D(v,me) < 400 then
						UseBlinkDagger() Antiblinkhome()
						Puck()
						PLDoppleganger()
						return					
					elseif GetDistance2D(v,me) <= v.attackRange+150 then
						UseBlinkDagger() Antiblinkhome()
						UseEulScepterTarget()
						UseSheepStickTarget()
						UseOrchidtarget() SkySilence()
						PLDoppleganger()
						Emberremnantnow()
						UseHalberdtarget()
						RazorStaticLink()
						SkySilence()
						return
					end
				end
			end
			
			--Checking if skill was already casted--
			for t = 1, 4 do 
				if v:GetAbility(t) and v:GetAbility(t).level > 0 then	
					target = v
					if v:GetAbility(t).name == "tidehunter_ravage" then
						if v:GetAbility(t).abilityPhase or math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 1025 then
								Embersleighttargetcal()
								Juggernautfury()
								Nyx()
								Puck()
								TusksnowballTarget()
								UseEulScepterSelf()
								UseBlinkDagger() Antiblinkhome()
								UseShadowBlade()
								Useshadowamulet()
								PLDoppleganger()
							end
						end
					elseif v:GetAbility(t).name == "queenofpain_scream_of_pain" then
						if v:GetAbility(t).abilityPhase or v:GetProperty("CBaseAnimating","m_nSequence") == 10 or math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 475 then
								Embersleighttargetcal()
								Juggernautfury()
								Nyx()
								Puck()
								TusksnowballTarget()
								UseEulScepterSelf()
								UseBlinkDagger() Antiblinkhome()
								UseShadowBlade()
								Useshadowamulet()
								PLDoppleganger()
							end
						end
					elseif v:GetAbility(t).name == "sandking_epicenter" then
						if v:GetAbility(t).channelTime > 0 then
							if GetDistance2D(v,me) < 400 then
								PuckW(false)
							end
							target = v
							UseOrchidtarget() SkySilence()
							UseSheepStickTarget()
							UseEulScepterTarget()
						end
					elseif v:GetAbility(t).name == "bane_fiends_grip" then
						if v:GetAbility(t).channelTime > 0 then
							if GetDistance2D(v,me) < 400 then
								PuckW(false)
							end
							target = v
							UseOrchidtarget() SkySilence()
							UseSheepStickTarget()
							UseEulScepterTarget()
						end
					elseif v:GetAbility(t).name == "drow_ranger_wave_of_silence" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
							if GetDistance2D(v,me) < 1150 and turntime == 0 then
								Puck()
								UseBlinkDagger() Antiblinkhome()
								Juggernautfury()
								Nyx()
								AlchemistRage()
								Embersleighttargetcal()
								EmberGuard()
								UseEulScepterTarget()
								UseShadowBlade()
								Useshadowamulet()
								SlarkPounce()
								PLDoppleganger()
							end
						end	
					elseif v:GetAbility(t).name == "shadow_shaman_shackles" then
						if v:GetAbility(t).channelTime > 0 then
							if GetDistance2D(v,me) < 400 then
								PuckW(false)
							end
							target = v
							UseOrchidtarget() SkySilence()
							UseSheepStickTarget()
							UseEulScepterTarget()
						end
					elseif v:GetAbility(t).name == "luna_eclipse" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 675 then
								Puck()
								UseBlinkDagger() Antiblinkhome()
								UseEulScepterSelf()
								NyxVendetta()
								BountyhunterWindwalk()
								WeaverShukuchi()
								PLDoppleganger()
								SandkinSandstorm()
								UseShadowBlade()
								TusksnowballTarget()
								SlarkShadowDance()
								TemplarMeld()
								Useshadowamulet()
								UseBladeMail()
								OracleFalsePromise()
							end
						end
					elseif v:GetAbility(t).name == "mirana_starfall" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 625 then
								Puck()
								UseBlinkDagger() Antiblinkhome()
								UseEulScepterSelf()
								Nyx()
								BountyhunterWindwalk()
								WeaverShukuchi()
								PLDoppleganger()
								SandkinSandstorm()
								UseShadowBlade()
								TusksnowballTarget()
								TemplarMeld()
								Useshadowamulet()
							end
						end
					elseif v:GetAbility(t).name == "venomancer_poison_nova" then
						if v:GetAbility(t).abilityPhase or v:GetProperty("CBaseAnimating","m_nSequence") == 12 or math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 1025 then
								Juggernautfury()
								Puck()
								UseBlinkDagger() Antiblinkhome()
								PLDoppleganger()
							end
						end
					elseif v:GetAbility(t).name == "sven_storm_bolt" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  13 then
							if GetDistance2D(v,me) < (600 + me.movespeed*((GetDistance2D(v,me)/v:GetAbility(t):GetSpecialData("bolt_speed",v:GetAbility(t).level)) + 1)) then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Puck()
									UseBlinkDagger() Antiblinkhome()
									TemplarMeld()
									Juggernautfury()
									Nyx()
									LoneDruidUlt()
									AlchemistRage()
									Embersleighttargetcal()
									EmberGuard()
									UseEulScepterSelf()
									UseShadowBlade()
									Useshadowamulet()
									UseManta()
									SlarkPounce()
									PLDoppleganger()
									OracleFateEdict()
								end
							end
						end
					elseif v:GetAbility(t).name == "phantom_assassin_phantom_strike" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 1100 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									UseEulScepterTarget()
									UseEtherealtarget()
									UseBlinkDagger() Antiblinkhome()
									UseShadowBlade()
									PLDoppleganger()
									UseHalberdtarget()
									RazorStaticLink()
									UseEtherealtarget()
									OracleFateEdictTarget()
								end
							end
						end
					elseif v:GetAbility(t).name == "tiny_avalanche" then
						if math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 900 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Puck()
									UseEulScepterSelf()
									UseShadowBlade()
									UseBlinkDagger() Antiblinkhome()
									Embersleighttargetcal()
									Juggernautfury()
									Nyx()
									Useshadowamulet()	
									PLDoppleganger()									
								end
							end
						end
					elseif v:GetAbility(t).name == "pugna_nether_blast" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 750 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.70, 0))
								if turntime == 0 then
									Nyx()	
								end
							end
						end
					elseif v:GetAbility(t).name == "dazzle_poison_touch" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 650 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									UseBlinkDagger() Antiblinkhome()
									Puck()
									PLDoppleganger()
								end
							end
						end
					elseif v:GetAbility(t).name == "skeleton_king_hellfire_blast" then 
						if math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 600 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									SlarkDarkPact()
									Puck()
									UseBlinkDagger() Antiblinkhome()
									AlchemistRage()
									Juggernautfury()
									Embersleighttargetcal()
									Nyx()
									LoneDruidUlt()
									UseEulScepterSelf()
									UseShadowBlade()
									Useshadowamulet()
									UseManta()
									PLDoppleganger()
									OracleFateEdict()
								end
							end
						end
					elseif v:GetAbility(t).name == "sandking_burrowstrike" then 
						if math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 600 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									SlarkDarkPact()
									Puck()
									UseBlinkDagger() Antiblinkhome()
									AlchemistRage()
									Juggernautfury()
									Embersleighttargetcal()
									Nyx()
									LoneDruidUlt()
									UseEulScepterSelf()
									UseShadowBlade()
									Useshadowamulet()
									UseManta()
									PLDoppleganger()
								end
							end
						end
					elseif v:GetAbility(t).name == "medusa_mystic_snake" then
						if math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 800 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									UseShadowBlade()
								end
							end
						end
					elseif v:GetAbility(t).name == "lina_dragon_slave" then
						if math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 1275 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Puck()
									if v:GetAbility(t):GetDamage(v:GetAbility(t).level) * (1 - me.magicDmgResist) > me.health then
										UseEulScepterSelf()
									end
									UseEulScepterSelf()
									UseBlinkDagger() Antiblinkhome()
									Juggernautfury()
									Nyx()
								end
							end
						end
					elseif v:GetAbility(t).name == "pudge_meat_hook" then
						if math.ceil(v:GetAbility(t).cd) == math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) and not me:DoesHaveModifier("pudge_meat_hook") then
							if GetDistance2D(v,me) < 1300 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
								if turntime == 0 then
									Nyx()
									Juggernautfury()
									Puck()
									UseBlinkDagger() Antiblinkhome()
									Emberremnantnow()
									Embersleighttargetcal()
									EmberGuard()
									PLDoppleganger()
								end
							end
						end
					elseif v:GetAbility(t).name == "rattletrap_hookshot" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 3000 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Nyx()
									Juggernautfury()
									Puck()
									UseBlinkDagger() Antiblinkhome()
									Useshadowamulet()
									PLDoppleganger()
								end
							end
						end
					elseif v:GetAbility(t).name == "dragon_knight_breathe_fire" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) or v:GetAbility(t).abilityPhase then
							if GetDistance2D(v,me) < 620 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Nyx()
									Puck()
									Juggernautfury()
									UseBlinkDagger() Antiblinkhome()
								end
							end
						end
					elseif v:GetAbility(t).name == "chaos_knight_chaos_bolt" then
						if v:GetAbility(t).abilityPhase then
							if GetDistance2D(v,me) < 580 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									target = v
									tt = nil
									script:RegisterEvent(EVENT_TICK, ChaosKnightChaosBolt)
								end
							end
						end
					elseif v:GetAbility(t).name == "shredder_timber_chain" then
						if math.ceil(v:GetAbility(t).cd-0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)-0.1) then
							if GetDistance2D(v,me) < 1400 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Nyx()
									Juggernautfury()
									Puck()
								end
							end
						end
					elseif v:GetAbility(t).name == "magnataur_shockwave" then
						if math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 1160 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.40, 0))
								if turntime == 0 then
									Nyx()
									Puck()
								end
							end
						elseif math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 600 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.40, 0))
								if turntime == 0 then
									Nyx()
									Puck()
								end
							end	
						end	
					elseif v:GetAbility(t).name == "nyx_assassin_impale" then
						if math.ceil(v:GetAbility(t).cd - 12.9) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 800 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.40, 0))
								if turntime == 0 then
									Puck()
									PLDoppleganger()
								end
							end
						end
					elseif v:GetAbility(t).name == "magnataur_skewer" then
						if math.ceil(v:GetAbility(t).cd - 0.8) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 900 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.80, 0))
								if turntime == 0 then
									Nyx()
									Puck()
									PLDoppleganger()
								end
							end
						end
					elseif v:GetAbility(t).name == "phantom_lancer_spirit_lance" then
						if math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 820 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then						
									Nyx()
									Puck()
								end
							end
						end
					elseif v:GetAbility(t).name == "jakiro_ice_path" then
						if math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 1200 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Nyx()
									Useshadowamulet()
									UseShadowBlade()
									Puck()
									UseSheepStickTarget()
									UseEulScepterTarget()
									Useblackking()
									Lifestealerrage()
									UseBlinkDagger() Antiblinkhome()
								end
							end
						end
					elseif v:GetAbility(t).name == "slark_pounce" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 600 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
								if turntime == 0 then
									Nyx()
									Puck()
									UseShadowBlade()
									PLDoppleganger()
								end
							end
						end
					elseif v:GetAbility(t).name == "vengefulspirit_magic_missile" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 550 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Nyx()
									Puck()
									LoneDruidUlt()
									UseBlinkDaggerfront()
									AlchemistRage()
									UseManta()
									SlarkPounce()
									Embersleighttargetcal()
									EmberGuard()
									PLDoppleganger()
								end
							end
						end
					elseif v:GetAbility(t).name == "bounty_hunter_shuriken_toss" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 750 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Nyx()
									Puck()
									LoneDruidUlt()
									SlarkPounce()
									Embersleighttargetcal()
									UseBlinkDaggerfront()
									AlchemistRage()
									UseShadowBlade()
									UseManta()
									SlarkPounce()
								end
							end
						end
					elseif v:GetAbility(t).name == "viper_viper_strike" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 910 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Puck()
									UseBlinkDagger() Antiblinkhome()
									SlarkPounce()
									LoneDruidUlt()
									Embersleighttargetcal()
									UseManta()
									UseEulScepterSelf()
									PLDoppleganger()
								end
							end
						elseif v:AghanimState() and math.ceil(v:GetAbility(t).cd - 0.1) ==  12 then
							if GetDistance2D(v,me) < 1200 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Puck()
									UseBlinkDagger() Antiblinkhome()
									SlarkPounce()
									LoneDruidUlt()
									Embersleighttargetcal()
									UseManta()
									PLDoppleganger()
								end
							end
						end
					elseif v:GetAbility(t).name == "naga_siren_ensnare" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 670 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									UseBlinkDaggerfront()
									Puck()
									SlarkDarkPact()
									Embersleighttargetcal()
									if v:GetAbility(t).level >= 2 then
										LoneDruidUlt()
									end
								end
							end
						end
					elseif v:GetAbility(t).name == "witch_doctor_paralyzing_cask" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 720 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Puck()
									Embersleighttargetcal()
									if v:GetAbility(t).level >= 2 then
										LoneDruidUlt()
									end
									UseShadowBlade()	
								end
							end
						end
					elseif v:GetAbility(t).name == "spectre_spectral_dagger" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 1000 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Puck()
									Nyx()
								end
							end
						end
					elseif v:GetAbility(t).name == "lich_chain_frost" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 900 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Nyx()
									Puck()
									UseBlinkDagger() Antiblinkhome()
									UseShadowBlade()
									UseEulScepterSelf()
									SlarkShadowDance()
								end
							end
						end
					elseif v:GetAbility(t).name == "juggernaut_omni_slash" then
						if math.ceil(v:GetAbility(t).cd - 0.3) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 900 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Puck()
									TemplarMeld()
									PLDoppleganger()
									NyxVendetta()
									WeaverShukuchi()
									BountyhunterWindwalk()
									UseGhostScepter()
									UseShadowBlade()
									UseEulScepterSelf()
									SlarkShadowDance()
									OracleFalsePromise()
								end
							end
						elseif v:AghanimState() and math.ceil(v:GetAbility(t).cd - 0.3) == 70 then
							if GetDistance2D(v,me) < 900 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Puck()
									TemplarMeld()
									PLDoppleganger()
									NyxVendetta()
									WeaverShukuchi()
									BountyhunterWindwalk()
									UseGhostScepter()
									UseShadowBlade()
									UseEulScepterSelf()
									SlarkShadowDance()
								end
							end
						end
					elseif v:GetAbility(t).name == "death_prophet_carrion_swarm" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 1100 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.40, 0))
								if turntime == 0 then
									Nyx()
									Puck()
									Embersleighttargetcal()
								end
							end
						end
					elseif v:GetAbility(t).name == "invoker_deafening_blast" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 1100 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then									
									Nyx()
									Puck()
									UseShadowBlade()
									PLDoppleganger()
								end
							end
						end
					-- elseif v:GetAbility(t).name == "skywrath_mage_concussive_shot" then
						-- if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							-- if GetDistance2D(v,me) < 1600 then
								-- Puck()
							-- end
						-- end
					elseif v:GetAbility(t).name == "skywrath_mage_mystic_flare" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 1250 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Puck()
									UseEulScepterSelf()
									UseManta()
									PLDoppleganger()
								end
							end
						end
					elseif v:GetAbility(t).name == "puck_illusory_orb" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 750 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Puck()
									Nyx()
								end
							end
						end
					elseif v:GetAbility(t).name == "windrunner_powershot" then
						if math.ceil(v:GetAbility(t).cd + 0.9) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 1500 then
									turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
									if turntime == 0 then
										Nyx()
										Puck()
									end
								end
							end
					elseif v:GetAbility(t).name == "alchemist_unstable_concoction" then
						if math.ceil(v:GetAbility(t).cd) >  10.4 then
							if GetDistance2D(v,me) < 1000 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									Puck()
									Nyx()
									Embersleighttargetcal()
									UseBlinkDagger() Antiblinkhome()
									Juggernautfury()
									UseEulScepterSelf()
									UseShadowBlade()
									Useshadowamulet()
									PLDoppleganger()
								end
							end
						end
					elseif v:GetAbility(t).name == "queenofpain_shadow_strike" then
						if math.ceil(v:GetAbility(t).cd - 0.7) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 625 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									UseBlinkDaggerfront()
									Puck()
									Embersleighttargetcal()
									UseShadowBlade()
								end
							end
						end
					elseif v:GetAbility(t).name == "queenofpain_blink" then
						if math.ceil(v:GetAbility(t).cd - 0.8) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 500 then
								if GetDistance2D(v,me) < 400 then
									PuckW(true)
									UseSheepStickTarget()
									UseOrchidtarget() SkySilence()
									UseEulScepterTarget()
									Emberchains()
								else
									Silencerult()
									TusksnowballTarget()
									UseSheepStickTarget()
									UseOrchidtarget() SkySilence()
									UseEulScepterTarget()
									Puck()
								end
								PLDoppleganger()
							end
						end
					elseif v:GetAbility(t).name == "queenofpain_sonic_wave" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 1300 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.40, 0))
								if turntime == 0 then
									Nyx()
									UseBlinkDagger() Antiblinkhome()
									Juggernautfury()
									Embersleighttargetcal()
									Puck()
									PLDoppleganger()
									OracleFateEdict()
									UseBladeMail()
								end
							end
						end
					elseif v:GetAbility(t).name == "disruptor_glimpse" then
						if math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 2000 then
								turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
								if turntime == 0 then
									UseShadowBlade()
									Useshadowamulet()
								end
							end
						end
					elseif v:GetAbility(t).name == "faceless_void_time_walk" then
						if math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
							if GetDistance2D(v,me) < 1050 and v:CanCast() then
								if v:GetAbility(4).name == "faceless_void_chronosphere" and v:GetAbility(4).state == LuaEntityAbility.STATE_READY then
									if GetDistance2D(v,me) < 400 then
										UseBlinkDagger() Antiblinkhome()
										PuckW(true)
										UseSheepStickTarget()
										UseOrchidtarget() SkySilence()
										UseEulScepterTarget()
										Emberchains()
										OracleFalsePromise()
									else
										Silencerult()
										TusksnowballTarget()
										UseSheepStickTarget()
										UseOrchidtarget() SkySilence()
										UseEulScepterTarget()
										Puck()
										UseBlinkDagger() Antiblinkhome()
									end
									UseHalberdtarget()
									RazorStaticLink()
									UseGhostScepter()
									UseEtherealtarget()
									PLDoppleganger()
									Emberremnantnow()
								end
							end
						end
					end
				end
			end
		end
	end
	activated = 0
	blink = false
end

function GameClose()
	target = nil
	wait = 0
	waittime = 0
	sleepTick = nil
	sleep1 = 0 
	sleepk = 0
	tt = nil
	aa = nil
end

function FindAngleR(entity)
	if entity.rotR < 0 then
		return math.abs(entity.rotR)
	else
		return 2 * math.pi - entity.rotR
	end
end

function AngleBelow(myHero,nearestHero,targetHero,angle)
	local myPos = Vector2D(myHero.position.x,myHero.position.y)
	local nearestHeroPos = Vector2D(nearestHero.position.x,nearestHero.position.y)
	local targetHeroPos = Vector2D(targetHero.position.x,targetHero.position.y)
	local t1 = (nearestHeroPos - myPos)
	local t2 = (targetHeroPos - myPos)
	return math.abs(math.deg(math.atan2(t2.y, t2.x) - math.atan2(t1.y, t1.x))) <= angle
end

function FindAngleBetween(first, second)
	if second.position == nil then second.position = second end
	xAngle = math.deg(math.atan(math.abs(second.position.x - first.position.x)/math.abs(second.position.y - first.position.y)))
	if first.position.x <= second.position.x and first.position.y >= second.position.y then
		return 90 - xAngle
	elseif first.position.x >= second.position.x and first.position.y >= second.position.y then
		return xAngle + 90
	elseif first.position.x >= second.position.x and first.position.y <= second.position.y then
		return 90 - xAngle + 180
	elseif first.position.x <= second.position.x and first.position.y <= second.position.y then
		return xAngle + 90 + 180
	end
	return nil
end

function GotHex(hero)
	return (hero:FindItem("item_sheepstick") and hero:FindItem("item_sheepstick").state == LuaEntityAbility.STATE_READY) or (hero:FindSpell("lion_voodoo") and hero:FindSpell("lion_voodoo").state == LuaEntityAbility.STATE_READY) or (hero:FindSpell("shadow_shaman_voodoo") and hero:FindSpell("shadow_shaman_voodoo").state == LuaEntityAbility.STATE_READY)
end

function Lifestealerrage()
	if activated == 0 then
		local rage = me:FindSpell("lifestealer_rage")
		if rage and rage.level > 0 and rage:CanBeCasted() and me:CanCast() then
			me:CastAbility(rage)
			activated = 1
			sleepTick = GetTick() + 500
			return 
		end
	end
end

function LoneDruidUlt()
	if activated == 0 then
		local trueform1 = me:FindSpell("lone_druid_true_form")
		local trueform2 = me:FindSpell("lone_druid_true_form_druid")
		if trueform1 and trueform1.level > 0 and trueform1:CanBeCasted() and me:CanCast() then
			me:CastAbility(trueform1)
			activated = 1
			sleepTick = GetTick() + 500
		elseif trueform2 and trueform2.level > 0 and trueform2:CanBeCasted() and me:CanCast() then
			me:CastAbility(trueform2)
			activated = 1
			sleepTick = GetTick() + 500
		end
	end
end

function Juggernautfury()
	if activated == 0 then
		local fury = me:FindSpell("juggernaut_blade_fury")
		if fury and fury.level > 0 and fury:CanBeCasted() and me:CanCast() then
			me:CastAbility(fury)
			activated = 1
			sleepTick = GetTick() + 500
		end
	end
end

function Phoenixsupernova()
	if activated == 0 then
		local supernova = me:FindSpell("phoenix_supernova")
		if supernova and supernova.level > 0 and supernova:CanBeCasted() and me:CanCast() then	
			me:CastAbility(supernova)
			activated = 1
			sleepTick = GetTick() + 500
		end
	end
end

function RazorStaticLink()
	if activated == 0 then
		local static_link = me:FindSpell("razor_static_link")
		if target and static_link and static_link.level > 0 and static_link:CanBeCasted() and me:CanCast() and GetDistance2D(me,target) <= 600 then
			me:SafeCastAbility(static_link,target)
			activated = 1
			sleepTick = GetTick() + 500
		end
	end
end

function TemplarMeld()
	if activated == 0 then
		local meld = me:FindSpell("templar_assassin_meld")
		if meld and meld.level > 0 and meld:CanBeCasted() and me:CanCast() then
			me:CastAbility(meld)
			activated = 1
			sleepTick = GetTick() + 500
			script:RegisterEvent(EVENT_TICK,qna)
		end
	end
end

function TemplarRefraction()
	if activated == 0 then
		local refraction = me:FindSpell("templar_assassin_refraction")
		if refraction and refraction.level > 0 and refraction:CanBeCasted() and me:CanCast() then
			me:CastAbility(refraction)
			activated = 1
			sleepTick = GetTick() + 500
		end
	end
end

function NyxVendetta()
	if activated == 0 then
		local vendetta = me:FindSpell("nyx_assassin_vendetta")
		if vendetta and vendetta.level > 0 and vendetta:CanBeCasted() and me:CanCast() then
			me:CastAbility(vendetta)
			activated = 1
			sleepTick = GetTick() + 500
		end
	end
end

function WeaverShukuchi()
	if activated == 0 then
		local shukuchi = me:FindSpell("weaver_shukuchi")
		if shukuchi and shukuchi.level > 0 and shukuchi:CanBeCasted() and me:CanCast() then
			me:CastAbility(shukuchi)
			activated = 1
			sleepTick = GetTick() + 500
		end
	end
end

function SandkinSandstorm()
	if activated == 0 then
		local sandstorm = me:FindSpell("sandking_sandstorm")
		if sandstorm and sandstorm.level > 0 and sandstorm:CanBeCasted() and me:CanCast() then
			me:CastAbility(sandstorm)
			activated = 1
			sleepTick = GetTick() + 500
		end
	end
end

function ClinkzWindwalk()
	if activated == 0 then
		local windwalk = me:FindSpell("clinkz_skeleton_walk")
		if windwalk and windwalk.level > 0 and windwalk:CanBeCasted() and me:CanCast() then
			me:CastAbility(windwalk)
			activated = 1
			sleepTick = GetTick() + 500
		end
	end
end

function PLDoppleganger()
	if activated == 0 then
		local dopplewalk = me:FindSpell("phantom_lancer_doppelwalk")
		if dopplewalk and dopplewalk.level > 0 and dopplewalk:CanBeCasted() and me:CanCast() then
			local v = entityList:GetEntities({classId = CDOTA_Unit_Fountain,team = me.team})[1]
			me:CastAbility(dopplewalk,Vector((v.position.x - me.position.x) * 500 / GetDistance2D(v,me) + me.position.x,(v.position.y - me.position.y) * 500 / GetDistance2D(v,me) + me.position.y,v.position.z))
			activated = 1
			sleepTick = GetTick() + 500
		end
	end
end

function BountyhunterWindwalk()
	if activated == 0 then
		local windwalk = me:FindSpell("bounty_hunter_wind_walk")
		if windwalk and windwalk.level > 0 and windwalk:CanBeCasted() and me:CanCast() then
			me:CastAbility(windwalk)
			activated = 1
			sleepTick = GetTick() + 500
		end
	end
end

function AlchemistRage()
	if activated == 0 then
		local rage = me:FindSpell("alchemist_rage")
		if rage and rage.level > 0 and rage:CanBeCasted() and me:CanCast() then
			me:CastAbility(rage)
			activated = 1
			sleepTick = GetTick() + 500
		end
	end
end

function NagaMirror()
	if activated == 0 then
		local mirror = me:FindSpell("naga_siren_mirror_image")
		if rage and rage.level > 0 and rage:CanBeCasted() and me:CanCast() then
			me:CastAbility(rage)
			activated = 1
			sleepTick = GetTick() + 500
		end
	end
end

function TusksnowballTarget()
	if activated == 0 then
		local snowball = me:FindSpell("tusk_snowball")
		if snowball and snowball.level > 0 and snowball:CanBeCasted() and me:CanCast() then
			if target and GetDistance2D(me,target) < 1250 then
				me:CastAbility(snowball,target)
				activated = 1
				sleepTick = GetTick() + 500
			end
		end
	end
end

function Jugernautomnitarget()
	if activated == 0 then
		local omni = me:FindSpell("juggernaut_omni_slash")
		if omni and omni.level > 0 and omni:CanBeCasted() and me:CanCast() then
			if target and GetDistance2D(me,target) < 450 then
				me:CastAbility(omni,target)
				activated = 1
				sleepTick = GetTick() + 500
			end
		end
	end
end

function Doom()
	if activated == 0 then
		local doom = me:FindSpell("doombringer_doom")
		if doom and doom.level > 0 and doom:CanBeCasted() and me:CanCast() then
			if target and GetDistance2D(me,target) < 560 then
				me:CastAbility(doom,target)
				activated = 1
				sleepTick = GetTick() + 500
			end
		end
	end
end

function SkySilence()
	if activated == 0 then
		local silence = me:FindSpell("skywrath_mage_ancient_seal")
		if silence and silence.level > 0 and silence:CanBeCasted() and me:CanCast() then
			if target and GetDistance2D(me,target) < 700 then
				me:CastAbility(silence,target)
				activated = 1
				sleepTick = GetTick() + 500
			end
		end
	end
end

function Emberchains()
	if activated == 0 then
		local chains = me:FindSpell("ember_spirit_searing_chains")
		if chains and chains.level > 0 and chains:CanBeCasted() and me:CanCast() then
			if target and GetDistance2D(me,target) < 400 then
				me:CastAbility(chains)
				activated = 1
				sleepTick = GetTick() + 500
			end
		end
	end
end

function Embersleighttarget()
	if activated == 0 then
		local sleight = me:FindSpell("ember_spirit_sleight_of_fist")
		if sleight and sleight.level > 0 and sleight:CanBeCasted() and me:CanCast() then
			if target and GetDistance2D(me,target) < 710 then
				me:CastAbility(sleight,target.position)
				activated = 1
				sleepTick = GetTick() + 500
			end
		end
	end
end

function Embersleighttargetcal()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "ember_spirit_sleight_of_fist" and me:GetAbility(t).state == -1 then
				local addrange =0
				if me:GetAbility(t).level == 1 then
					addrange = 250
				elseif me:GetAbility(t).level == 2 then
					addrange = 350
				elseif me:GetAbility(t).level == 3 then
					addrange = 450
				elseif me:GetAbility(t).level == 4 then
					addrange = 550
				end
					if target and GetDistance2D(me,target) < 750 + addrange then

						ember_spirit_sleight_of_fist=me:GetAbility(t)
						local p = Vector((me.position.x - target.position.x) * addrange / GetDistance2D(target,me) + target.position.x,(me.position.y - target.position.y) * addrange / GetDistance2D(target,me) + target.position.y,target.position.z)
						local close = math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, target))))
						local far = math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, p))))
						if GetDistance2D(me,target) < 720 and close < far then
							me:CastAbility(ember_spirit_sleight_of_fist,target.position)
						else
							me:CastAbility(ember_spirit_sleight_of_fist,p)
						end
						activated=1
						sleepTick= GetTick() +500
						return
					end
				end
			end
		end
	end
end

function EmberGuard()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "ember_spirit_flame_guard" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					activated=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end

function Emberremnantnow()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "ember_spirit_activate_fire_remnant" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				activated=1
				sleepTick= GetTick() +160
				return 
			end
		end
	end
end

function StormUltfront()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "storm_spirit_ball_lightning" and me:GetAbility(t).state == -1 then
						alfa = me.rotR
						local p = Vector(me.x + 100 * math.cos(alfa), me.y + 100 * math.sin(alfa), me.z) 
						storm_spirit_ball_lightning=me:GetAbility(t)
						me:CastAbility(storm_spirit_ball_lightning,p)
						activated=1
						sleepTick= GetTick() +600
						return
				end
			end
		end
	end
end

function StormUltfront2(moverange)
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "storm_spirit_ball_lightning" and me:GetAbility(t).state == -1 then
						alfa = me.rotR
						local p = Vector(me.x + moverange * math.cos(alfa), me.y + moverange * math.sin(alfa), me.z) 
						storm_spirit_ball_lightning=me:GetAbility(t)
						me:CastAbility(storm_spirit_ball_lightning,p)
						activated=1
						sleepTick= GetTick() +600
						return
				end
			end
		end
	end
end

function Antiblinkfront()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "antimage_blink" and me:GetAbility(t).state == -1 then
						alfa = me.rotR
						local p = Vector(me.x + 100 * math.cos(alfa), me.y + 100 * math.sin(alfa), me.z) 
						storm_spirit_ball_lightning=me:GetAbility(t)
						me:CastAbility(storm_spirit_ball_lightning,p)
						activated=1
						sleepTick= GetTick() +500
						return
				end
			end
		end
	end
end

function Antiblinkhome()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "antimage_blink" and me:GetAbility(t).state == -1 then
					local fountPos = entityList:FindEntities({team = me.team, classId = CDOTA_Unit_Fountain})[1].position
					local vector = ((fountPos - me.position) * 1150 / me:GetDistance2D(fountPos) ) + me.position
						storm_spirit_ball_lightning=me:GetAbility(t)
						me:CastAbility(storm_spirit_ball_lightning,vector)
						activated=1
						Sleep(500,"blink")
						sleepTick= GetTick() +500
						client:ExecuteCmd("+dota_camera_center_on_hero")
						client:ExecuteCmd("-dota_camera_center_on_hero")
						return
				end
			end
		end
	end
end

function AbaddonShieldtarget()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "abaddon_aphotic_shield" and me:GetAbility(t).state == -1 then
					if target and GetDistance2D(me,target) < 510 then
						abaddon_aphotic_shield=me:GetAbility(t)
						me:CastAbility(abaddon_aphotic_shield,target)
						activated=1
						sleepTick= GetTick() +500
						return
					end
				end
			end
		end
	end
end

function LegionPresstarget()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "legion_commander_press_the_attack" and me:GetAbility(t).state == -1 then
					if target and GetDistance2D(me,target) < 810 then
						legion_commander_press_the_attack=me:GetAbility(t)
						me:CastAbility(legion_commander_press_the_attack,target)
						activated=1
						sleepTick= GetTick() +500
						return
					end
				end
			end
		end
	end
end

function Axe()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t) and me:GetAbility(t).name == "axe_berserkers_call" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					activated=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end

function Puck()
	if activated == 0 then
		local phase = me:FindSpell("puck_phase_shift")
		if phase and phase.level > 0 and phase:CanBeCasted() and me:CanCast() then
			me:CastAbility(phase)
			activated = 1
			pstime = {750,1500,2250,3250}
			sleepTick = GetTick() + pstime[phase.level]
			script:RegisterEvent(EVENT_TICK,qna)
			return
		end
	end
end

function PuckW(ps)
	if activated == 0 then
		local rift = me:FindSpell("puck_waning_rift")
		if me:CanCast() then
			if rift and rift.level > 0 and rift:CanBeCasted() then
				if target and GetDistance2D(me,target) < 410 then
					me:CastAbility(rift)
					activated = 1
					sleepTick = GetTick() + 500
					return
				end
			elseif ps then
				Puck()
			end
		end
	end
end

function Slardar()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "slardar_slithereen_crush" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				activated=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function SlarkDarkPact()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "slark_dark_pact" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				activated=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function SlarkPounce()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "slark_pounce" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				activated=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function SlarkShadowDance()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "slark_shadow_dance" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				activated=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function ObsidianImprisonmentself()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "obsidian_destroyer_astral_imprisonment" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t),me)
				activated=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function ShadowdemonDisruptionself()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "shadow_demon_disruption" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t),me)
				activated=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function OmniknightRepelself()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "omniknight_repel" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t),me)
				activated=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function Abaddonult()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "abaddon_borrowed_time" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				activated=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function SilencerLastWord()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "silencer_last_word" and me:GetAbility(t).state == -1 then
					if target and GetDistance2D(me,target) < 920 then
						silencer_last_word=me:GetAbility(t)
						me:CastAbility(silencer_last_word,target)
						activated=1
						sleepTick= GetTick() +500
						return
					end
				end
			end
		end
	end
end

function Silencerult()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "silencer_global_silence" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				activated=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function Nyx()
	if activated == 0 then
		local carapace = me:FindSpell("nyx_assassin_spiked_carapace")
		if carapace and carapace:CanBeCasted() and not me:DoesHaveModifier("nyx_assassin_vendetta") and not me:IsInvisible() then
			me:CastAbility(carapace)
			activated = 1
			sleepTick = GetTick() + 500
			return 
		end
	end
end

function OracleFateEdict()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "oracle_fates_edict" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t),me)
				activated=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function OracleFateEdictTarget()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "oracle_fates_edict" and me:GetAbility(t).state == -1 then
					if target and GetDistance2D(me,target) < 700 then
						oracle_fates_edict=me:GetAbility(t)
						me:CastAbility(oracle_fates_edict,target)
						activated=1
						sleepTick= GetTick() +500
						return
					end
				end
			end
		end
	end
end

function OracleFalsePromise()
	if activated == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "oracle_false_promise" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t),me)
				activated=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function Useblackking()
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_black_king_bar" then
			item_black_king_bar = me:GetItem(t)
		end
	end
	if activated == 0 then
		if item_black_king_bar and item_black_king_bar.state== -1 then
			me:CastAbility(item_black_king_bar)
			activated=1
			sleepTick= GetTick() +500
			return
		end
	end
end

function ChaosKnightChaosBolt(tick)
	if tt == nil then
		sleepk = tick + 300
		tt = 1
	end
	if tick > sleepk then
		Puck()
		LoneDruidUlt()
		UseBlinkDaggerfront()
		AlchemistRage()
		Nyx()
		SlarkDarkPact()
		Embersleighttargetcal()
		UseEulScepterSelf()
		UseShadowBlade()
		Useshadowamulet()
		UseManta()
		tt = nil
		script:UnregisterEvent(ChaosKnightChaosBolt)
	end	
end

--useitem--------------------------------------------------------------------------------------------------------------------------------------
function UseBlinkDagger() --use blink to home
	if activated == 0 then
		local BlinkDagger = me:FindItem("item_blink")
		local stormult = me:FindSpell("storm_spirit_ball_lightning")
		local v = entityList:GetEntities({classId = CDOTA_Unit_Fountain,team = me.team})[1]
		local vec = Vector((v.position.x - me.position.x) * 1100 / GetDistance2D(v,me) + me.position.x,(v.position.y - me.position.y) * 1100 / GetDistance2D(v,me) + me.position.y,v.position.z)
		if BlinkDagger ~= nil and BlinkDagger.cd == 0 then
			me:CastItem(BlinkDagger.name,vec)
			activated = 1
			Sleep(500,"blink")
			client:ExecuteCmd("+dota_camera_center_on_hero")
			client:ExecuteCmd("-dota_camera_center_on_hero")
			sleepTick = GetTick() + 500
			return
		end
		if stormult and me:CanCast() then
			me:CastAbility(stormult,vec)
			activated = 1
			Sleep(500,"blink")
			client:ExecuteCmd("+dota_camera_center_on_hero")
			client:ExecuteCmd("-dota_camera_center_on_hero")
			sleepTick = GetTick() + 500
			return
		end
	end
	return
end

function UseBlinkDaggervec() --use blink to home
	local v = entityList:GetEntities({classId = CDOTA_Unit_Fountain,team = me.team})[1]
	return Vector((v.position.x - me.position.x) * 1100 / GetDistance2D(v,me) + me.position.x,(v.position.y - me.position.y) * 1100 / GetDistance2D(v,me) + me.position.y,v.position.z)
end

function UseBlinkDaggerfront()--use blink to front of hero distance 100 
	if activated == 0 then
		local BlinkDagger = me:FindItem("item_blink")
		if BlinkDagger ~= nil and BlinkDagger.cd == 0 then
			local v = entityList:GetEntities({classId = CDOTA_Unit_Fountain,team = me.team})[1]
			local alfa = me.rotR
			local p = Vector(me.position.x + 100 * math.cos(alfa), me.position.y + 100 * math.sin(alfa), me.position.z) 
			me:CastAbility(BlinkDagger,p)
			activated = 1
			sleepTick= GetTick() + 500
			return
		end
	end
end

function UseBlinkDaggertarget()--target
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_blink" then
			item_blink = me:GetItem(t)
		end
	end
	if activated == 0 then
		if item_blink and item_blink.state==-1 then
			if target and GetDistance2D(me,target) < 1150 then

				me:CastAbility(item_blink,target.x,target.y,target.z)
				activated=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end

function UseGhostScepter()
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_ghost" then
			GhostScepter = me:GetItem(t)
		end
	end
	if activated == 0 then
		if GhostScepter and GhostScepter.state==-1 then
			--UseAbility(GhostScepter)
			me:CastAbility(GhostScepter)

			activated=1
			sleepTick= GetTick() +500
			return
		end
	end
end

function UseEulScepterSelf()--self	
	local euls = me:FindItem("item_cyclone")
	if activated == 0 then
		if euls and euls.cd == 0 then
			me:SafeCastItem(euls.name,me)
			activated = 1
			sleepTick = GetTick() + 2700
			return
		end
	end
end

function UseEulScepterTarget()--target
	local euls = me:FindItem("item_cyclone")
	if activated == 0 then
		if euls and euls.cd == 0 then
			if target and GetDistance2D(me,target) < 700 then
				me:CastAbility(euls,target)
				activated = 1
				sleepTick = GetTick() + 500
				return
			end
		end
	end
end

function UseBladeMail()
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_blade_mail" then
			item_blade_mail = me:GetItem(t)
		end
	end
	if activated == 0 then
		if item_blade_mail and item_blade_mail.state==-1 then
			me:CastAbility(item_blade_mail)
			activated=1
			sleepTick= GetTick() +500
			return
		end
	end
end

function UseBloodStone()--suiside
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_bloodstone" then
			item_bloodstone = me:GetItem(t)
		end
	end
	if activated == 0 then
		if item_bloodstone and item_bloodstone.state==-1 then
			--UseAbility(item_bloodstone)
			me:CastAbility(item_bloodstone)

			activated=1
			sleepTick= GetTick() +500
			return
		end
	end
end

function UseSheepStickTarget()--target
	for t = 1, 6 do
		if (me:HasItem(t) and me:GetItem(t).name == "item_sheepstick") then
			UseEulScepter = me:GetItem(t)
		end
	end
	if not UseEulScepter or not UseEulScepter:CanBeCasted() then 
		UseEulScepter = me:FindSpell("lion_voodoo") or me:FindSpell("shadow_shaman_voodoo") or nil
	end
	if UseEulScepter then
		local range = UseEulScepter.castRange or 800
		if range == 0 then range = 800 end
		if activated == 0 then
			if UseEulScepter and UseEulScepter:CanBeCasted() then
				if target and GetDistance2D(me,target) < range then
					me:CastAbility(UseEulScepter,target)
					activated=1
					sleepTick= GetTick() +500
					return
				end
			end
		end
	end
end

function UseOrchidtarget()--target
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_orchid" then
			item_orchid = me:GetItem(t)
		end
	end
	if activated == 0 then
		if item_orchid and item_orchid.state==-1 then
			if target and GetDistance2D(me,target) < 900 then

				me:CastAbility(item_orchid,target)
				activated=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end

function UseAbyssaltarget()--target
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_abyssal_blade" then
			item_abyssal_blade = me:GetItem(t)
		end
	end
	if activated == 0 then
		if item_abyssal_blade and item_abyssal_blade.state==-1 then
			if target and GetDistance2D(me,target) < 140 then

				me:CastAbility(item_abyssal_blade,target)
				activated=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end

function UseHalberdtarget()--target
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_heavens_halberd" then
			item_heavens_halberd = me:GetItem(t)
		end
	end
	if activated == 0 then
		if item_heavens_halberd and item_heavens_halberd.state==-1 then
			if target and GetDistance2D(me,target) < 600 then

				me:CastAbility(item_heavens_halberd,target)
				activated=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end

function UseEtherealtarget()--target
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_ethereal_blade" then
			item_ethereal_blade = me:GetItem(t)
		end
	end
	if activated == 0 then
		if item_ethereal_blade and item_ethereal_blade.state==-1 then
			if target and GetDistance2D(me,target) < 800 then

				me:CastAbility(item_ethereal_blade,target)
				activated=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end

function Useblackking()
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_black_king_bar" then
			item_black_king_bar = me:GetItem(t)
		end
	end
	if activated == 0 then
		if item_black_king_bar and item_black_king_bar.state==-1 then
			--UseAbility(item_black_king_bar)
			me:CastAbility(item_black_king_bar)
			activated=1
			sleepTick= GetTick() +500
			return
		end
	end
end

function PurgeMyself()
	local diffusal = me:FindItem("item_diffusal_blade")
	local purge = me:FindSpell("satyr_trickster_purge")
	if activated == 0 then
		if purge and purge:CanBeCasted() and me:CanCast() then
			me:CastAbility(purge, me)
			activated = 1
			sleepTick = GetTick() + 500
			return
		elseif diffusal and diffusal.charges > 0 and diffusal.state == LuaEntityAbility.STATE_READY then
			me:CastItem(diffusal.name, me)
			activated = 1
			sleepTick = GetTick() + 500
			return
		end
	end
end
			

function UseManta()
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_manta" then
			item_manta = me:GetItem(t)
		end
	end
	if activated == 0 then
		if item_manta and item_manta.state==-1 then
			--UseAbility(item_manta)
			me:CastAbility(item_manta)
			activated=1
			sleepTick= GetTick() +500
			return
		end
	end
end

function UseShadowBlade()
	local shadowblade = me:FindItem("item_invis_sword")
	if activated == 0 then
		if shadowblade and shadowblade.cd == 0 then
			me:CastAbility(shadowblade)
			activated = 1
			sleepTick = GetTick() + 500
			return
		end
	end
end

function Useshadowamulet()
	local amulet = me:FindItem("item_shadow_amulet")
	if activated == 0 then
		if amulet and amulet.cd == 0 then
			me:CastAbility(amulet,me)
			activated = 1
			sleepTick = GetTick() + 500
			return
		end
	end
end

function Useshadowamulettarget()--target
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_shadow_amulet" then
			item_shadow_amulet = me:GetItem(t)
		end
	end
	if activated == 0 then
		if item_shadow_amulet and item_shadow_amulet.state==-1 then
			if target and GetDistance2D(me,target) < 600 then
				me:CastAbility(item_shadow_amulet,target)
				activated=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end

function qna(tick)
	client:ExecuteCmd("+sixense_left_shift")
	if aa == nil then
		sleep = tick + 1000
		aa = 1
	end
	if tick > sleep then
		client:ExecuteCmd("-sixense_left_shift")
		aa = nil
		script:UnregisterEvent(qna)
	end	
end

function GetSpecial(spell,Name,lvl)
	local specials = spell.specials
	for _,v in ipairs(specials) do
		if v.name == Name then
			return v:GetData( math.min(v.dataCount,lvl) )
		end
	end
end   

function CanGoInvis(hero) 
	return hero:FindSpell("bounty_hunter_wind_walk") ~= nil or hero:FindSpell("riki_permanent_invisibility") ~= nil or hero:FindSpell("clinkz_skeleton_walk") ~= nil or hero:FindItem("item_invis_sword") ~= nil
end

function IsSilenced(hero)
	return hero:DoesHaveModifier("modifier_drowranger_wave_of_silence_knockback") or hero:DoesHaveModifier("modifier_earth_spirit_boulder_smash_silence") or hero:DoesHaveModifier("modifier_silence") or hero:DoesHaveModifier("modifier_silencer_global_silence")
end

script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_FRAME,Tick)
