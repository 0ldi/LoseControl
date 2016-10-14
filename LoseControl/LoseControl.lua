local L = "LoseControl"
local CC      = "CC"
local Silence = "Silence"
local Disarm  = "Disarm"
local Root    = "Root"
local Snare   = "Snare"
local Immune  = "Immune"
local PvE     = "PvE"

local spellIds = {
	-- Druid
	["Bash"] = CC, -- Bash
	["Feral Charge Efect"] = Root, -- Feral Charge Efect
	["Hibernate"] = CC, -- Hibernate
	["Pounce"] = CC, -- Pounce
	["Entangling Roots"] = Root, -- Entangling Roots
	["Starfire Stun"] = CC, -- Starfire Stun
	["Feral Charge Effect"] = Root, -- Feral Charge Effect
	-- Hunter
	["Freezing Trap"] = CC, -- Freezing Trap
	["Intimidation"] = CC, -- Intimidation
	["Scare Beast"] = CC, -- Scare Beast
	["Scatter Shot"] = CC, -- Scatter Shot
	["Wyvern Sting"] = CC, -- Wyvern Sting; requires a hack to be removed later
	["Improved Concussive Shot"] = CC, -- Improved Concussive Shot
	["Counterattack"] = Root, -- Counterattack
	["Improved Wing Clip"] = Root, -- Improved Wing Clip
	["Entrapment"] = Root, -- Entrapment
	["Wing Clip"] = Snare, -- Wing Clip
	-- Mage
	["Frost Nova"] = Root, -- Frost Nova
	["Polymorph"] = CC, -- Polymorph
	["Frostbite"] = Root, -- Frostbite
	["Freeze"] = Root, -- Freeze
	["Cone of Cold"] = Snare, -- Cone of Cold	
	["Counterspell - Silenced"] = Silence, -- Counterspell - Silenced
	["Impact"] = CC, -- Impact
	["Chill"] = Snare, -- Chill
	["Blast Wave"] = Snare, -- Blast Wave
	["Frostbolt"] = Snare, -- Frostbolt
	-- Paladin
	["Hammer of Justice"] = CC, -- Hammer of Justice
	["Repentance"] = CC, -- Repentance
	["Seal of Justice"] = CC, -- Seal of Justice
	-- Priest
	["Mind Control"] = CC, -- Mind Control
	["Psychic Scream"] = CC, -- Psychic Scream
	["Silence"] = Silence, -- Silence
	["Blackout"] = CC, -- Blackout
	["Mind Flay"] = Snare, -- Mind Flay
	-- Rogue
	["Blind"] = CC, -- Blind
	["Cheap Shot"] = CC, -- Cheap Shot
	["Gouge"] = CC, -- Gouge
	["Kidney Shot"] = CC, -- Kidney shot; the buff is 30621
	["Sap"] = CC, -- Sap
	["Kick - Silenced"] = Silence, -- Kick - Silenced
	["Crippling Poison"] = Snare, -- Crippling Poison
	-- Warlock
	["Death Coil"] = CC, -- Death Coil
	["Fear"] = CC, -- Fear
	["Howl of Terror"] = CC, -- Howl of Terror
	["Seduction"] = CC, -- Seduction
	["Inferno Effect"] = CC, -- Inferno Effect
	["Inferno"] = CC, -- Inferno
	["Pyroclasm"] = CC, -- Pyroclasm
	["Curse of Exhaustion"] = Snare, -- Curse of Exhaustion
	["Aftermath"] = Snare, -- Aftermath
	-- Warrior
	["Charge Stun"] = CC, -- Charge Stun
	["Intercept Stun"] = CC, -- Intercept Stun
	["Intimidating Shout"] = CC, -- Intimidating Shout
	["Piercing Howl"] = Snare, -- Piercing Howl
	["Shield Bash - Silenced"] = Silence, -- Shield Bash - Silenced
	["Revenge Stun"] = CC, -- Revenge Stun
	["Concussion Blow"] = CC, -- Concussion Blow
	["Charge"] = CC, -- Charge
	--Shaman	
	["Frostbrand Weapon"] = Snare, -- Frostbrand Weapon
	["Frost Shock"] = Snare, -- Frost Shock
	["Earthbind"] = Snare, -- Earthbind
	["Earthbind Totem"] = Snare, -- Earthbind Totem
	-- other
	["War Stomp"] = CC, -- War Stomp
	["Tidal Charm"] = CC, -- Tidal Charm
	["Mace Stun Effect"] = CC, -- Mace Stun Effect
	["Stun"] = CC, -- Stun
	["Gnomish Mind Control Cap"] = CC, -- Gnomish Mind Control Cap
	["Reckless Charge"] = CC, -- Reckless Charge
	["Sleep"] = CC, -- Sleep
	["Boar Charge"] = Root, -- Boar Charge
	["Cripple"] = Snare, -- Cripple
	["Chilled"] = Snare, -- Chilled
	["Dazed"] = Snare, -- Dazed
	["Spell Lock"] = Silence, -- Spell Lock
	
}

function LCPlayer_OnLoad()	
	this:SetHeight(50)
	this:SetWidth(50)
	this:SetPoint("CENTER", 0, 0)
	this:RegisterEvent("UNIT_AURA")
	this:RegisterEvent("PLAYER_AURAS_CHANGED")

	this.texture = this:CreateTexture(this, "BACKGROUND")
	this.texture:SetAllPoints(this)
	this.cooldown = CreateFrame("Model", "Cooldown", this, "CooldownFrameTemplate")
	this.cooldown:SetAllPoints(this) 
	this.maxExpirationTime = 0
	this:Hide()
end

function LCPlayer_OnEvent()
	local spellFound = false
	for i=1, 16 do -- 16 is enough due to HARMFUL filter
		local texture = UnitDebuff("player", i)
		LCTooltip:ClearLines()
		LCTooltip:SetUnitDebuff("player", i)
		local buffName = LCTooltipTextLeft1:GetText()
		
		if spellIds[buffName] then
			spellFound = true
			for j=0, 31 do
				local buffTexture = GetPlayerBuffTexture(j)
				if texture == buffTexture then
					local expirationTime = GetPlayerBuffTimeLeft(j)
					this:Show()
					this.texture:SetTexture(buffTexture)
					this.cooldown:SetModelScale(1)
					if this.maxExpirationTime <= expirationTime then
						CooldownFrame_SetTimer(this.cooldown, GetTime(), expirationTime, 1)
						this.maxExpirationTime = expirationTime
					end
					return
				end
			end		
		end
	end
	if spellFound == false then
		this.maxExpirationTime = 0
		this:Hide()
	end
end

function LCTarget_OnLoad()
	
end

function LCTarget_OnEvent()
	
end
