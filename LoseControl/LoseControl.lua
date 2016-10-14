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
	["Hibernate"] = CC, -- Hibernate
	["Starfire Stun"] = CC, -- Starfire
	["Entangling Roots"] = Root, -- Entangling Roots
	["Bash"] = CC, -- Bash
	["Pounce Bleed"] = CC, -- Pounce
	["Feral Charge Effect"] = Root, -- Feral Charge
	-- Hunter
	["Intimidation"] = CC, -- Intimidation
	["Scare Beast"] = CC, -- Scare Beast
	["Scatter Shot"] = CC, -- Scatter Shot
	["Improved Concussive Shot"] = CC, -- Improved Concussive Shot
	["Concussive Shot"] = Snare, -- Concussive Shot
	["Freezing Trap Effect"] = CC, -- Freezing Trap
	["Freezing Trap"] = CC, -- Freezing Trap
	["Frost Trap Aura"] = Root, -- Freezing Trap
	["Frost Trap"] = Root, -- Frost Trap
	["Entrapment"] = Root, -- Entrapment
	["Wyvern Sting"] = CC, -- Wyvern Sting; requires a hack to be removed later
	["Counterattack"] = Root, -- Counterattack
	["Improved Wing Clip"] = Root, -- Improved Wing Clip
	["Wing Clip"] = Snare, -- Wing Clip
	["Boar Charge"] = Root, -- Boar Charge
	-- Mage
	["Polymorph"] = CC, -- Polymorph: Sheep
	["Polymorph: Turtle"] = CC, -- Polymorph: Turtle
	["Polymorph: Pig"] = CC, -- Polymorph: Pig
	["Polymorph: Cow"] = CC, -- Polymorph: Cow
	["Polymorph: Chicken"] = CC, -- Polymorph: Chicken
	["Counterspell - Silenced"] = Silence, -- Counterspell
	["Impact"] = CC, -- Impact
	["Blast Wave"] = Snare, -- Blast Wave
	["Frostbite"] = Root, -- Frostbite
	["Frost Nova"] = Root, -- Frost Nova
	["Frostbolt"] = Snare, -- Frostbolt
	["Cone of Cold"] = Snare, -- Cone of Cold
	["Chilled"] = Snare, -- Improved Blizzard + Ice armor
	-- Paladin
	["Hammer of Justice"] = CC, -- Hammer of Justice
	["Repentance"] = CC, -- Repentance
	-- Priest
	["Mind Control"] = CC, -- Mind Control
	["Psychic Scream"] = CC, -- Psychic Scream
	["Blackout"] = CC, -- Blackout
	["Silence"] = Silence, -- Silence
	["Mind Flay"] = Snare, -- Mind Flay
	-- Rogue
	["Blind"] = CC, -- Blind
	["Cheap Shot"] = CC, -- Cheap Shot
	["Gouge"] = CC, -- Gouge
	["Kidney Shot"] = CC, -- Kidney shot; the buff is 30621
	["Sap"] = CC, -- Sap
	["Kick - Silenced"] = Silence, -- Kick
	["Crippling Poison"] = Snare, -- Crippling Poison
	-- Warlock
	["Death Coil"] = CC, -- Death Coil
	["Fear"] = CC, -- Fear
	["Howl of Terror"] = CC, -- Howl of Terror
	["Curse of Exhaustion"] = Snare, -- Curse of Exhaustion
	["Pyroclasm"] = CC, -- Pyroclasm
	["Aftermath"] = Snare, -- Aftermath
	["Seduction"] = CC, -- Seduction
	["Spell Lock"] = Silence, -- Spell Lock
	["Inferno Effect"] = CC, -- Inferno Effect
	["Inferno"] = CC, -- Inferno
	["Cripple"] = Snare, -- Cripple
	-- Warrior
	["Charge Stun"] = CC, -- Charge Stun
	["Intercept Stun"] = CC, -- Intercept Stun
	["Intimidating Shout"] = CC, -- Intimidating Shout
	["Revenge Stun"] = CC, -- Revenge Stun
	["Concussion Blow"] = CC, -- Concussion Blow
	["Piercing Howl"] = Snare, -- Piercing Howl
	["Shield Bash - Silenced"] = Silence, -- Shield Bash - Silenced
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
	["Dazed"] = Snare, -- Dazed
	["Freeze"] = Root, -- Freeze
	["Chill"] = Snare, -- Chill
	["Charge"] = CC, -- Charge
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
