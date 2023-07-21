local COMMAND = Clockwork.command:New("StorageTakeItem");
	COMMAND.tip = "Take an item from storage.";
	COMMAND.text = "<string uniqueID> <string ItemID>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local storageTable = player:GetStorageTable();
		local uniqueID = arguments[1];
		local itemID = tonumber(arguments[2]);
		
		if (storageTable and IsValid(storageTable.entity)) then
			local itemTable = Clockwork.inventory:FindItemByID(
				storageTable.inventory, uniqueID, itemID
			);
			
			if (!itemTable) then
				Clockwork.player:Notify(player, "The storage does not contain an instance of this item!");
				return;
			end;
			
			Clockwork.storage:TakeFrom(player, itemTable);
		else
			Clockwork.player:Notify(player, "You do not have storage open!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("Unequip");
	COMMAND.tip = "Unequip a weapon.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = arguments[1];
		
		for k, v in pairs (player:GetWeapons()) do
			if (string.lower(v:GetClass()) == string.lower(target)) then
				local itemTable = item.GetByWeapon(v);

				if (itemTable) then
					Clockwork.kernel:ForceUnequipItem(player, itemTable.uniqueID, itemTable.itemID)
				end;
			end;
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StorageTakeCash");
	COMMAND.tip = "Take some cash from storage.";
	COMMAND.text = "<number Cash>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local storageTable = player:GetStorageTable();
		
		if (storageTable) then
			local target = storageTable.entity;
			local cash = math.floor(tonumber(arguments[1]));
			
			if (!IsValid(target) or !config.Get("cash_enabled"):Get()) then
				return;
			end;
			
			if (cash and cash > 1 and cash <= storageTable.cash) then
				if (!storageTable.CanTakeCash
				or (storageTable.CanTakeCash(player, storageTable, cash) != false)) then
					if (!target:IsPlayer()) then
						Clockwork.player:GiveCash(player, cash, nil, true);
						Clockwork.storage:UpdateCash(player, storageTable.cash - cash);
					else
						Clockwork.player:GiveCash(player, cash, nil, true);
						Clockwork.player:GiveCash(target, -cash, nil, true);
						Clockwork.storage:UpdateCash(player, target:GetCash());
					end;
					
					if (storageTable.OnTakeCash
					and storageTable.OnTakeCash(player, storageTable, cash)) then
						Clockwork.storage:Close(player);
					end;
				end;
			end;
		else
			Clockwork.player:Notify(player, "You do not have storage open!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StorageGiveItem");
	COMMAND.tip = "Give an item to storage.";
	COMMAND.text = "<string UniqueID> <string ItemID>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local storageTable = player:GetStorageTable();
		local uniqueID = arguments[1];
		local itemID = tonumber(arguments[2]);
		
		if (storageTable and IsValid(storageTable.entity)) then
			local itemTable = player:FindItemByID(uniqueID, itemID);
			local target = storageTable.entity;
			
			if (!itemTable) then
				Clockwork.player:Notify(player, "You do not have an instance of this item!");
				return;
			end;
			
			if (storageTable.isOneSided) then
				Clockwork.player:Notify(player, "You cannot give items to this container!");
				return;
			end;
			
			Clockwork.storage:GiveTo(player, itemTable);
		else
			Clockwork.player:Notify(player, "You do not have storage open!");
		end;
	end;
COMMAND:Register();

local NAME_CASH = Clockwork.option:GetKey("name_cash");
local COMMAND = Clockwork.command:New("StorageGiveCash");
	COMMAND.tip = "Give some cash to storage.";
	COMMAND.text = "<number Cash>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local storageTable = player:GetStorageTable();
		
		if (storageTable) then
			local target = storageTable.entity;
			local cash = math.floor(tonumber(arguments[1]));
			
			if (!IsValid(target) or !config.Get("cash_enabled"):Get()) then
				return;
			end;
				
			if (cash and cash > 1 and Clockwork.player:CanAfford(player, cash)) then
				if (!storageTable.CanGiveCash
				or (storageTable.CanGiveCash(player, storageTable, cash) != false)) then
					if (!target:IsPlayer()) then
						local cashWeight = config.Get("cash_weight"):Get();
						local myWeight = Clockwork.storage:GetWeight(player);

						local cashSpace = config.Get("cash_space"):Get();
						local mySpace = Clockwork.storage:GetSpace(player);
						
						if (myWeight + (cashWeight * cash) <= storageTable.weight and mySpace + (cashSpace * cash) <= storageTable.space) then
							Clockwork.player:GiveCash(player, -cash, nil, true);
							Clockwork.storage:UpdateCash(player, storageTable.cash + cash);
						end;
					else
						Clockwork.player:GiveCash(player, -cash, nil, true);
						Clockwork.player:GiveCash(target, cash, nil, true);
						Clockwork.storage:UpdateCash(player, target:GetCash());
					end;
					
					if (storageTable.OnGiveCash
					and storageTable.OnGiveCash(player, storageTable, cash)) then
						Clockwork.storage:Close(player);
					end;
				end;
			end;
		else
			Clockwork.player:Notify(player, "You do not have storage open!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StorageClose");
	COMMAND.tip = "Close the active storage.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local storageTable = player:GetStorageTable();
		
		if (storageTable) then
			Clockwork.storage:Close(player, true);
		else
			Clockwork.player:Notify(player, "You do not have storage open!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("SetClass");
	COMMAND.tip = "Set the class of your character.";
	COMMAND.text = "<string Class>";
	COMMAND.flags = CMD_HEAVY;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local class = Clockwork.class:FindByID(arguments[1]);
		
		if (player:InVehicle()) then
			Clockwork.player:Notify(player, "You cannot do this action at the moment!");
			return;
		end;
		
		if (class) then
			local limit = Clockwork.class:GetLimit(class.name);
			
			if (hook.Run("PlayerCanBypassClassLimit", player, class.index)) then
				limit = game.MaxPlayers();
			end;
			
			if (_team.NumPlayers(class.index) < limit) then
				local previousTeam = player:Team();
				
				if (player:Team() != class.index
				and Clockwork.kernel:HasObjectAccess(player, class)) then
					if (hook.Run("PlayerCanChangeClass", player, class)) then
						local bSuccess, fault = Clockwork.class:Set(player, class.index, nil, true);
						
						if (!bSuccess) then
							Clockwork.player:Notify(player, fault);
						end;
					end;
				else
					Clockwork.player:Notify(player, "You do not have access to this class!");
				end;
			else
				Clockwork.player:Notify(player, "There are too many characters with this class!");
			end;
		else
			Clockwork.player:Notify(player, "This is not a valid class!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("OrderShipment");
	COMMAND.tip = "Order an item shipment at your target position.";
	COMMAND.text = "<string UniqueID>";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local itemTable = item.FindByID(arguments[1]);
		
		if (!itemTable or !itemTable:CanBeOrdered()) then
			return false;
		end;
		
		itemTable = item.CreateInstance(itemTable.uniqueID);
		hook.Run("PlayerAdjustOrderItemTable", player, itemTable);
		
		if (!Clockwork.kernel:HasObjectAccess(player, itemTable)) then
			Clockwork.player:Notify(player, "You not have access to order this item!");
			return false;
		end;
		
		if (!hook.Run("PlayerCanOrderShipment", player, itemTable)) then
			return false;
		end;
		
		if (Clockwork.player:CanAfford(player, itemTable.cost * itemTable.batch)) then
			local trace = player:GetEyeTraceNoCursor();
			local entity = nil;

			if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
				if (itemTable.CanOrder and itemTable:CanOrder(player, v) == false) then
					return false;
				end;
				
				if (itemTable.batch > 1) then
					Clockwork.player:GiveCash(player, -(itemTable.cost * itemTable.batch), itemTable.batch.." "..Clockwork.kernel:Pluralize(itemTable.name));
					Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has ordered "..itemTable.batch.." "..Clockwork.kernel:Pluralize(itemTable.name)..".");
				else
					Clockwork.player:GiveCash(player, -(itemTable.cost * itemTable.batch), itemTable.batch.." "..itemTable.name);
					Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has ordered "..itemTable.batch.." "..itemTable.name..".");
				end;
				
				if (itemTable.OnCreateShipmentEntity) then
					entity = itemTable:OnCreateShipmentEntity(player, itemTable.batch, trace.HitPos);
				end;
				
				if (!IsValid(entity)) then
					if (itemTable.batch > 1) then
						entity = Clockwork.entity:CreateShipment(player, itemTable.uniqueID, itemTable.batch, trace.HitPos);
					else
						entity = Clockwork.entity:CreateItem(player, itemTable, trace.HitPos);
					end;
				end;
				
				if (IsValid(entity)) then
					Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
				end;
				
				if (itemTable.OnOrder) then
					itemTable:OnOrder(player, entity);
				end;
				
				hook.Run("PlayerOrderShipment", player, itemTable, entity);
				player.cwNextOrderTime = CurTime() + (2 * itemTable.batch);
				
				netstream.Start(player, "OrderTime", player.cwNextOrderTime);
			else
				Clockwork.player:Notify(player, "You cannot order this item that far away!");
			end;
		else
			local amount = (itemTable.cost * itemTable.batch) - player:GetCash();
			Clockwork.player:Notify(player, "You need another "..Clockwork.kernel:FormatCash(amount, nil, true).."!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("InvAction");
	COMMAND.tip = "Run an inventory action on an item.";
	COMMAND.text = "<string Action> <string UniqueID> [string ItemID]";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 3;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local itemAction = string.lower(arguments[1]);
		local itemTable = player:FindItemByID(arguments[2], tonumber(arguments[3]));
		
		if (itemTable) then
			local customFunctions = itemTable.customFunctions;
			
			if (customFunctions) then
				for k, v in pairs(customFunctions) do
					if (string.lower(v) == itemAction) then
						if (itemTable.OnCustomFunction) then
							itemTable:OnCustomFunction(player, v);
							return;
						end;
					end;
				end;
			end;

			if (itemAction == "equipmelee") then
				if (hook.Run("PlayerEquipItemWeapon", player, itemTable)) then
					itemTable:Equip(player);
				end;
			elseif (itemAction == "repair") then
				local itemCondition = itemTable:GetCondition();
				
				if itemCondition <= 0 then
					if !cwBeliefs or !player:HasBelief("artisan") then
						Clockwork.player:Notify(player, "You cannot repair broken items!");
						return false;
					end
				end

				if itemCondition < 100 then
					if itemTable.repairItem then
						local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
						local repairItemTable;

						for k, v in pairs (itemList) do
							if v.uniqueID == itemTable.repairItem then
								repairItemTable = v;
								break;
							end
						end
			
						if (repairItemTable) then
							if repairItemTable then
								itemTable:GiveCondition(repairItemTable.conditionReplenishment or 50);
								
								player:TakeItem(repairItemTable, true);
								
								Clockwork.player:Notify(player, "You have repaired your "..itemTable.name);
							else
								Clockwork.player:Notify(player, "You do not have an item you can repair this item with!");
								return false;
							end
						end
					end
				else
					Clockwork.player:Notify(player, "This item is already in perfect condition and cannot be repaired.");
					return false;
				end
			elseif (itemAction == "breakdown") then
				if (itemTable.components) then
					if itemTable.components.breakdownType == "meltdown" then
						if (player:HasItemByID("charcoal")) then
							if !cwBeliefs or (cwBeliefs and player:HasBelief("smith")) then
								local smithy_found = false;
								
								for i = 1, #cwRecipes.smithyLocations do
									if player:GetPos():DistToSqr(cwRecipes.smithyLocations[i]) < (256 * 256) then
										local itemCondition = itemTable:GetCondition();
										
										for j = 1, #itemTable.components.items do
											local componentItem = item.CreateInstance(itemTable.components.items[j]);
											local condition = itemCondition - math.random(15, 40);
											
											if condition > 0 then
												componentItem:SetCondition(condition, true);
												
												player:GiveItem(componentItem);
											end
										end
										
										Clockwork.player:Notify(player, "You have melted down your "..itemTable.name.." into its component pieces.");
										player:EmitSound("generic_ui/smelt_success_02.wav");
										
										local coal = player:FindItemByID("charcoal");
										player:TakeItem(coal);
										
										player:TakeItem(itemTable, true);
										smithy_found = true;
										break;
									end
								end
								
								if not smithy_found then
									Clockwork.player:Notify(player, "You must be standing near a smithy to melt down this item!");
									return false;
								end
							else
								Clockwork.player:Notify(player, "You must have the 'Smith' belief to melt down this item!");
								return false;
							end
						else
							Clockwork.player:Notify(player, "You need charcoal to melt down this item!");
						end
					elseif itemTable.components.breakdownType == "breakdown" then
						local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
						local breakdownItemTable;

						for k, v in pairs (itemList) do
							if v.uniqueID == "breakdown_kit" then
								breakdownItemTable = v;
								break;
							end
						end
						
						if breakdownItemTable then
							local conditionTaken = math.max(1, math.Round((itemTable.weight * 3)));
							local itemCondition = breakdownItemTable:GetCondition() or 100;
							
							if conditionTaken <= itemCondition then
								for i = 1, #itemTable.components.items do
									local componentItem = item.CreateInstance(itemTable.components.items[i]);
									local condition = (componentItem:GetCondition() or 100) - math.random(15, 40);
									
									if condition > 0 then
										componentItem:SetCondition(condition, true);
										
										player:GiveItem(componentItem);
									end
								end
							
								Clockwork.player:Notify(player, "You have broken down your "..itemTable.name.." into its component pieces.");
								player:EmitSound("generic_ui/takeall_03.wav");
								
								breakdownItemTable:TakeCondition(conditionTaken);
								
								if breakdownItemTable:GetData("condition") <= 0 then
									player:TakeItem(breakdownItemTable, true);
								end
								
								player:TakeItem(itemTable, true);
							else
								Clockwork.player:Notify(player, "You do not have enough workable tools left in your breakdown kit to break down this item!");
							end
						else
							Clockwork.player:Notify(player, "You do not have an item you can break down this item with!");
							return false;
						end
					end
				end
			elseif (itemAction == "destroy") then
				if (hook.Run("PlayerCanDestroyItem", player, itemTable)) then
					item.Destroy(player, itemTable);
				end;
			elseif (itemAction == "drop") then
				local position = player:GetEyeTraceNoCursor().HitPos;
				
				if (player:GetShootPos():Distance(position) <= 192) then
					if (hook.Run("PlayerCanDropItem", player, itemTable, position)) then
						item.Drop(player, itemTable, position);
					end;
				else
					Clockwork.player:Notify(player, "You cannot drop the item that far away!");
				end;
			elseif (itemAction == "use") then
				if (player:InVehicle() and itemTable.useInVehicle == false) then
					Clockwork.player:Notify(player, "You cannot use this item in a vehicle!");
					
					return;
				end;

				if (hook.Run("PlayerCanUseItem", player, itemTable)) then
					return item.Use(player, itemTable);
				end;
			elseif (itemAction == "examine") then
				local itemCondition = itemTable:GetCondition();
				local examineText = itemTable.description
				local itemEngraving = itemTable:GetData("engraving");
				local conditionTextCategories = {"Armor", "Firearms", "Helms", "Melee", "Shields", "Javelins"};

				if (itemTable.GetEntityExamineText) then
					examineText = itemTable:GetEntityExamineText(entity)
				end
				
				if itemEngraving and itemEngraving ~= "" then
					examineText = examineText.." It has \'"..itemEngraving.."\' engraved into it.";
				end
				
				if table.HasValue(conditionTextCategories, itemTable.category) then
					if itemCondition >= 90 then
						examineText = examineText.." It appears to be in immaculate condition.";
					elseif itemCondition < 90 and itemCondition >= 60 then
						examineText = examineText.." It appears to be in a somewhat battered condition.";
					elseif itemCondition < 60 and itemCondition >= 30 then
						examineText = examineText.." It appears to be in very poor condition.";
					elseif itemCondition < 30 and itemCondition > 0 then
						examineText = examineText.." It appears to be on the verge of breaking.";
					elseif itemCondition <= 0 then
						if itemTable:IsBroken() then
							examineText = examineText.." It is completely destroyed and only worth its weight in scrap now.";
						else
							examineText = examineText.." It is broken yet still usable to some degree.";
						end
					end
				elseif itemTable.category == "Shot" and itemTable.ammoMagazineSize then
					local rounds = itemTable:GetAmmoMagazine();
					
					examineText = examineText.." The magazine has "..tostring(rounds).." "..itemTable.ammoName.." rounds loaded.";
				end

				Clockwork.player:Notify(player, examineText);
			elseif (itemAction == "ammo") then
				if (item.IsWeapon(itemTable)) then
					local ammo = itemTable:GetData("Ammo");
					
					if ammo and #ammo > 0 then
						if #ammo == 1 then
							if itemTable.usesMagazine and !string.find(ammo[1], "Magazine") then
								local ammoItemID = string.gsub(string.lower(ammo[1]), " ", "_");
								local magazineItem = item.CreateInstance(ammoItemID);
								
								if magazineItem and magazineItem.SetAmmoMagazine then
									magazineItem:SetAmmoMagazine(1);
									
									player:GiveItem(magazineItem);
								end
							else
								local ammoItemID = string.gsub(string.lower(ammo[1]), " ", "_");
								
								player:GiveItem(item.CreateInstance(ammoItemID));
							end
						elseif itemTable.usesMagazine then
							local ammoItemID = string.gsub(string.lower(ammo[1]), " ", "_");
							
							local magazineItem = item.CreateInstance(ammoItemID);
							
							if magazineItem and magazineItem.SetAmmoMagazine then
								magazineItem:SetAmmoMagazine(#ammo);
								
								player:GiveItem(magazineItem);
							end
						else
							for i = 1, #ammo do
								local round = ammo[i];
								
								if round then
									local roundItemID = string.gsub(string.lower(round), " ", "_");
									local roundItemInstance = item.CreateInstance(roundItemID);
									
									player:GiveItem(roundItemInstance);
								end
							end
						end

						itemTable:SetData("Ammo", {});
					end
				end
			elseif (itemAction == "magazineammo") then
				if (itemTable.category == "Shot" and itemTable.ammoMagazineSize) then
					if itemTable.TakeFromMagazine then
						itemTable:TakeFromMagazine(player);
					end
				end
			else
				hook.Run("PlayerUseUnknownItemFunction", player, itemTable, itemAction, arguments[4], arguments[5]);
			end;
		else
			Clockwork.player:Notify(player, "You do not own this item!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("GiveCoin");
COMMAND.tip = "Give coin to a target character.";
COMMAND.text = "<number Coin>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;
COMMAND.alias = {"GiveTokens", "GiveCash"}

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	
	if arguments[1] and tonumber(arguments[1]) then
		local cash = math.floor(tonumber((arguments[1] or 0)));
		
		if (target and target:IsPlayer()) then
			if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then			
				if (cash and cash >= 1) then
					if (Clockwork.player:CanAfford(player, cash)) then
						local playerName = player:Name();
						local targetName = target:Name();
						
						if (!Clockwork.player:DoesRecognise(player, target)) then
							targetName = Clockwork.player:GetUnrecognisedName(target, true);
						end;
						
						if (!Clockwork.player:DoesRecognise(target, player)) then
							playerName = Clockwork.player:GetUnrecognisedName(player, true);
						end;
						
						player:EmitSound("generic_ui/coin_0"..tostring(math.random(1, 3))..".wav");
						
						Clockwork.player:GiveCash(player, -cash);
						Clockwork.player:GiveCash(target, cash);
						
						Clockwork.player:Notify(player, "You have given "..Clockwork.kernel:FormatCash(cash, nil, true).." to "..targetName..".");
						Clockwork.player:Notify(target, "You were given "..Clockwork.kernel:FormatCash(cash, nil, true).." by "..playerName..".");
					else
						local amount = cash - player:GetCash();
						Clockwork.player:Notify(player, "You need another "..Clockwork.kernel:FormatCash(amount, nil, true).."!");
					end;
				else
					Clockwork.player:Notify(player, "This is not a valid amount!");
				end;
			else
				Clockwork.player:Notify(player, "This character is too far away!");
			end;
		else
			Clockwork.player:Notify(player, "You must look at a valid character!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid amount!");
	end
end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("DropWeapon");
	COMMAND.tip = "Drop your weapon at your target position.";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if not player.opponent then
			local weapon = player:GetActiveWeapon();
			
			if (IsValid(weapon)) then
				local class = weapon:GetClass();
				local itemTable = item.GetByWeapon(weapon);
				
				if (!itemTable) then
					Clockwork.player:Notify(player, "This is not a valid weapon!");
					return;
				end;
				
				if (hook.Run("PlayerCanDropWeapon", player, itemTable, weapon)) then
					local trace = player:GetEyeTraceNoCursor();
					
					if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
						local entity = Clockwork.entity:CreateItem(player, itemTable, trace.HitPos);
						
						if (IsValid(entity)) then
							local slots = {"Primary", "Secondary", "Tertiary"};
							
							Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
							Clockwork.kernel:ForceUnequipItem(player, itemTable.uniqueID, itemTable.itemID);
							
							player:TakeItem(itemTable, true);
							player:StripWeapon(class);
							player:SelectWeapon("begotten_fists");
								
							for i = 1, #slots do
								local gear = Clockwork.player:GetGear(player, slots[i]);
								
								if IsValid(gear) and gear:GetItemTable().uniqueID == self.uniqueID then
									Clockwork.player:RemoveGear(player, slots[i]);
									break;
								end
							end
							
							local weaponData = player.bgWeaponData or {}

							for i = 1, #weaponData do
								if weaponData[i].uniqueID == self.uniqueID then
									table.remove(weaponData, i);
									break;
								end
							end

							Clockwork.datastream:Start(player, "BGWeaponData", weaponData);
							Clockwork.player:SaveGear(player);
							
							player.bgWeaponData = weaponData;
							
							hook.Run("PlayerDropWeapon", player, itemTable, entity, weapon);
						end;
					else
						Clockwork.player:Notify(player, "You cannot drop your weapon that far away!");
					end;
				end;
			else
				Clockwork.player:Notify(player, "This is not a valid weapon!");
			end;
		else
			Clockwork.player:Notify(player, "You cannot perform this action while in a duel!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("DropShield");
	COMMAND.tip = "Drop your shield at your target position.";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if not player.opponent then
			local shieldData = player.bgShieldData;
			
			if shieldData and shieldData.uniqueID and shieldData.realID then
				local itemTable = player:FindItemByID(shieldData.uniqueID, shieldData.realID);
				
				if (!itemTable) then
					Clockwork.player:Notify(player, "This is not a valid shield!");
					return;
				end;
				
				local trace = player:GetEyeTraceNoCursor();
				
				if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
					local entity = Clockwork.entity:CreateItem(player, itemTable, trace.HitPos);
					
					if (IsValid(entity)) then
						if (itemTable:HasPlayerEquipped(player)) then
							Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
							Clockwork.kernel:ForceUnequipItem(player, itemTable.uniqueID, itemTable.itemID);
							player:TakeItem(itemTable, true);

							player.bgShieldData = {};
						end
					end;
				else
					Clockwork.player:Notify(player, "You cannot drop your shield that far away!");
				end;
			else
				Clockwork.player:Notify(player, "This is not a valid shield!");
			end;
		else
			Clockwork.player:Notify(player, "You cannot perform this action while in a duel!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("DropCoin");
	COMMAND.tip = "Drop coin at your target position.";
	COMMAND.text = "<number Coin>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;
	COMMAND.alias = {"DropTokens", "DropCash"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if not player.opponent then
			local trace = player:GetEyeTraceNoCursor();
			local cash = tonumber(arguments[1]);
			
			if (cash and isnumber(cash) and cash > 1) then
				cash = math.floor(cash);
				
				if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
					if (Clockwork.player:CanAfford(player, cash)) then
						Clockwork.player:GiveCash(player, -cash, "Dropping "..Clockwork.option:GetKey("name_cash"));
						
						local entity = Clockwork.entity:CreateCash(player, cash, trace.HitPos);
						
						if (IsValid(entity)) then
							Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
						end;
					else
						local amount = cash - player:GetCash();
						Clockwork.player:Notify(player, "You need another "..Clockwork.kernel:FormatCash(amount, nil, true).."!");
					end;
				else
					Clockwork.player:Notify(player, "You cannot drop "..string.lower(NAME_CASH).." that far away!");
				end;
			else
				Clockwork.player:Notify(player, "This is not a valid amount!");
			end;
		else
			Clockwork.player:Notify(player, "You cannot perform this action while in a duel!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharPhysDesc");
	COMMAND.tip = "Change your character's physical description.";
	COMMAND.text = "[string Text]";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 0;
	COMMAND.alias = {"PhysDesc", "SetPhysDesc"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local minimumPhysDesc = config.Get("minimum_physdesc"):Get();

		if (arguments[1]) then
			local text = table.concat(arguments, " ");
			
			if (string.len(text) < minimumPhysDesc) then
				Clockwork.player:Notify(player, "The physical description must be at least "..minimumPhysDesc.." characters long!");
				return;
			end;
			
			player:SetCharacterData("PhysDesc", Clockwork.kernel:ModifyPhysDesc(text));
			player:SaveCharacter();
		else
			Clockwork.dermaRequest:RequestString(player, "Physical Description Change", "What do you want to change your physical description to?", player:GetCharacterData("PhysDesc"), function(result)
				player:RunClockworkCmd(self.name, result);
			end)
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharGetUp");
	COMMAND.tip = "Get your character up from the floor.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if (player:GetRagdollState() == RAGDOLL_FALLENOVER and Clockwork.player:GetAction(player) != "unragdoll") then
			if (hook.Run("PlayerCanGetUp", player)) then
				local get_up_time = 5;
				
				if player:HasBelief("dexterity") then
					get_up_time = get_up_time * 0.67;
				end
				
				Clockwork.player:SetUnragdollTime(player, get_up_time);
				hook.Run("PlayerStartGetUp", player);
			end;
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharCancelGetUp");
	COMMAND.tip = "Stop your character from getting up.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if (player:GetRagdollState() == RAGDOLL_FALLENOVER and Clockwork.player:GetAction(player) == "unragdoll") then
			if cwMelee and player.stabilityStunned then
				return false;
			end
			
			if (hook.Run("PlayerCanGetUp", player)) then
				Clockwork.player:SetUnragdollTime(player, nil);
				hook.Run("PlayerCancelGetUp", player);
			end;
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharFallOver");
	COMMAND.tip = "Make your character fall to the floor.";
	COMMAND.text = "[number Seconds]";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local curTime = CurTime();
		
		if (!player.cwNextFallTime or curTime >= player.cwNextFallTime) then
			player.cwNextFallTime = curTime + 5;
			
			if (!player:InVehicle() and !Clockwork.player:IsNoClipping(player) and hook.Run("PlayerCanFallover", player) ~= false) then
				local seconds = tonumber(arguments[1]);
				
				if (seconds) then
					seconds = math.Clamp(seconds, 2, 30);
				elseif (seconds == 0) then
					seconds = nil;
				end;
				
				if (!player:IsRagdolled()) then
					Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, seconds);
					if (IsValid(player.Cum)) then
						player.Cum:Remove()
						player.Cum = nil
					end;
				end;
			else
				Clockwork.player:Notify(player, "You cannot do this action at the moment!");
			end;
		end;
	end;
COMMAND:Register();