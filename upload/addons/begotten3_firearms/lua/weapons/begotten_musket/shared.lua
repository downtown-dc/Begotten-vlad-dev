-- Variables that are used on both client and server
SWEP.Gun = ("bb_musket")					-- must be the name of your swep
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "bobs_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Category				= "Begotten"
SWEP.Author					= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions			= ""
SWEP.MuzzleAttachment		= "1" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" 		-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Musket"	-- Weapon name (Shown on HUD)	
SWEP.Slot					= 2			-- Slot in the weapon selection menu
SWEP.SlotPos				= 79		-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox		= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   	= false		-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight					= 30		-- rank relative to other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "rpg"		-- how others view you carrying the weapon

-- View Model
SWEP.ViewModelFOV			= 50
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_snip_musket.mdl"
SWEP.WorldModel				= "models/weapons/w_airgun.mdl"
SWEP.ShowWorldModel = false

-- World Model
SWEP.Base					= "begotten_firearm_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater 		= false

SWEP.Primary.Sound			= Sound("weapons/cb4/cb4-1.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 25		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize		= 1		-- Size of a clip
SWEP.Primary.DefaultClip	= 0			-- Bullets you start with
SWEP.Primary.KickUp			= 30		-- Maximum up recoil (rise)
SWEP.Primary.KickDown		= 1			-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal	= 1			-- Maximum up recoil (stock)
SWEP.Primary.Automatic		= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "ar2"

SWEP.Secondary.IronFOV		= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.data 					= {}		-- The starting firemode
SWEP.data.ironsights		= 1

SWEP.Primary.NumShots		= 1			-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage			= 85		-- Base damage per bullet
SWEP.Primary.Spread			= .05		-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy 	= .02 		-- Ironsight accuracy, should be the same for shotguns

SWEP.SelectiveFire			= false

-- Enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(-2.36, -4.02, 0.6)
SWEP.IronSightsAng = Vector(0, 0, -10.554)
SWEP.SightsPos = Vector(-2.36, -4.02, 0.6)
SWEP.SightsAng = Vector(0, 0, -10.554)
SWEP.RunSightsPos = Vector(-0.361, 0, 0.4)
SWEP.RunSightsAng = Vector(-17.588, 31.658, -20.403)

SWEP.WElements = {
	["elephant"] = { type = "Model", model = "models/weapons/w_snip_ele.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.557, 1.7, -0.519), angle = Angle(0, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.AmmoTypes = {
	["Grapeshot"] = function(SWEP)
		SWEP.Primary.Sound = Sound("Weapon_BulkCannon.Fire");
		SWEP.Primary.NumShots = 32;
		SWEP.Primary.Damage = 7;
		SWEP.Primary.Spread = .4;
		SWEP.Primary.IronAccuracy = .4;
		SWEP.Primary.Ammo = "buckshot";
		
		SWEP.Primary.KickUp				= 50		-- Maximum up recoil (rise)
		SWEP.Primary.KickDown			= 1		-- Maximum down recoil (skeet)
		SWEP.Primary.KickHorizontal		= 25		-- Maximum up recoil (stock)
		
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") then
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .19;
						SWEP.Primary.IronAccuracy = .19;
					else
						SWEP.Primary.Spread = .2;
						SWEP.Primary.IronAccuracy = .2;
					end
				else
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .25;
						SWEP.Primary.IronAccuracy = .25;
					else
						SWEP.Primary.Spread = .28;
						SWEP.Primary.IronAccuracy = .28;
					end
				end
			end
		end
		
		return true;
	end,
	["Longshot"] = function(SWEP)
		SWEP.Primary.Sound = Sound("weapons/cb4/cb4-1.wav");
		SWEP.Primary.NumShots = 1;
		SWEP.Primary.Damage = 85;
		SWEP.Primary.Spread = .1;
		SWEP.Primary.IronAccuracy = .035;
		SWEP.Primary.Ammo = "ar2";
		
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") then
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .02;
						SWEP.Primary.IronAccuracy = .0075;
					else
						SWEP.Primary.Spread = .025;
						SWEP.Primary.IronAccuracy = .01;
					end
				else
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .045;
						SWEP.Primary.IronAccuracy = .0225;
					else
						SWEP.Primary.Spread = .05;
						SWEP.Primary.IronAccuracy = .025;
					end
				end
			end
		end
		
		return true;
	end,
};

function SWEP:PrimaryAttack()
	local curTime = CurTime();

	if not IsValid(self) or not IsValid(self.Weapon) or not IsValid(self.Owner) then 
		return;
	end
	
	if IsFirstTimePredicted() then
		if self.Owner:IsPlayer() and self:CanFireBegotten() then
			if !self.Owner:KeyDown(IN_SPEED) then
				if !self:AdjustFireBegotten() then
					return;
				end
				
				self:ShootBulletInformation();
				self.Weapon:TakeAmmoBegotten(1); -- This should really only ever be 1 unless for some reason we have burst-fire guns or some shit, especially since we have different ammo types.
				--self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
				self.Weapon:EmitSound(self.Primary.Sound)

				local effect = EffectData();
				local Forward = self.Owner:GetForward()
				local Right = self.Owner:GetRight()
				
				effect:SetOrigin(self.Owner:GetShootPos() + (Forward * 65) + (Right * 5));
				effect:SetNormal( self.Owner:GetAimVector());
				util.Effect( "effect_awoi_smoke", effect );

				self.Owner:SetAnimation( PLAYER_ATTACK1 )
				self.Owner:MuzzleFlash()
				self.Weapon:SetNextPrimaryFire(curTime + 1 / (self.Primary.RPM / 60))
				
				if self.BoltAction then 
					self:BoltBack() 
				end
				
				if SERVER then
					self.Owner.cloakCooldown = CurTime() + 30;
				end
			end
		end
	elseif self:CanPrimaryAttack() and self.Owner:IsNPC() then
		self:ShootBulletInformation()
		self.Weapon:TakePrimaryAmmo(1)
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.Weapon:EmitSound(self.Primary.Sound)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Owner:MuzzleFlash()
		self.Weapon:SetNextPrimaryFire(curTime + 1 / (self.Primary.RPM / 60))
	end
end