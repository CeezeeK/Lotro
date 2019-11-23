-- Turbine Imports..
import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";

-- Plugin Imports..
-- DToX Start
-- Too lazy to leave only necessary parts. So, full package
-- Default: none
import "GaluhadPlugins.Tulkas.VindarPatch";
-- DToX End
import "GaluhadPlugins.Tulkas.Globals";
import "GaluhadPlugins.Tulkas.Items";
import "GaluhadPlugins.Tulkas.Images";
import "GaluhadPlugins.Tulkas.Strings";
import "GaluhadPlugins.Tulkas.AddCallBack";
import "GaluhadPlugins.Tulkas.Functions";
import "GaluhadPlugins.Tulkas.Commands";
import "GaluhadPlugins.Tulkas.Stats";
import "GaluhadPlugins.Tulkas.VersionCheck"

-- Utils Imports..
import "GaluhadPlugins.Tulkas.Utils";

-- Windows..
import "GaluhadPlugins.Tulkas.Windows";


-----------------------------------------------------------------------------------------------------------

function saveData()
	SETTINGS["__VERSION"] = V_SETTINGS;
	_SEARCHHISTORY["__VERSION"] = V_SEARCHHISTORY;
	_BOOKMARKS["__VERSION"] = V_BOOKMARKS;
	_BUILDS["__VERSION"] = V_BUILDS;
	_ITEMS["__VERSION"] = V_ITEMS;

	-- DToX Start
	--[[ Default:
	Turbine.PluginData.Save(Turbine.DataScope.Server, "Tulkas_Settings", SETTINGS);
	Turbine.PluginData.Save(Turbine.DataScope.Server, "Tulkas_SearchHistory", _SEARCHHISTORY);
	Turbine.PluginData.Save(Turbine.DataScope.Server, "Tulkas_Wishlist", _BOOKMARKS);
	Turbine.PluginData.Save(Turbine.DataScope.Server, "Tulkas_Builds", _BUILDS);
	Turbine.PluginData.Save(Turbine.DataScope.Account, "Tulkas_Items", _ITEMS);
	--]]
	-- DToX End
	PatchDataSave(Turbine.DataScope.Server, "Tulkas_Settings", SETTINGS);
	PatchDataSave(Turbine.DataScope.Server, "Tulkas_SearchHistory", _SEARCHHISTORY);
	PatchDataSave(Turbine.DataScope.Server, "Tulkas_Wishlist", _BOOKMARKS);
	PatchDataSave(Turbine.DataScope.Server, "Tulkas_Builds", _BUILDS);
	PatchDataSave(Turbine.DataScope.Account, "Tulkas_Items", _ITEMS);
	-- DToX End
end


function loadData()

	---------------------------------------------------------------------------------------------------------------------------------

	-- SAVED SETTINGS --
	local SavedSettings = {};

	function GetSavedSettings()
		-- DToX Start
		-- Default: SavedSettings = Turbine.PluginData.Load(Turbine.DataScope.Server, "Tulkas_Settings");
		SavedSettings = PatchDataLoad(Turbine.DataScope.Server, "Tulkas_Settings");
		-- DToX End
	end

	if pcall(GetSavedSettings) then
		-- Loaded without error
		GetSavedSettings();
	else
		-- Loaded with errors
		SavedSettings = nil;
		printError(_STRINGS.ADDON[4][LANGID]);
	end

	-- Check the saved settings to make sure it is still compatible with newer updates, add in any missing default settings
	if type(SavedSettings) == 'table' then
		local tempSETTINGS = {};
		tempSETTINGS = Utils.deepcopy(DEFAULT_SETTINGS);
		SETTINGS = Utils.mergeTables(tempSETTINGS,SavedSettings);
	else
		SETTINGS = Utils.deepcopy(DEFAULT_SETTINGS);
	end

	----------------------------------------------------------------------------------------------------------------------------------
	-- SAVED SEARCH HISTORY --
	local SavedHistory = {};

	function GetSavedHistory()
		-- DToX Start
		-- Default: SavedHistory = Turbine.PluginData.Load(Turbine.DataScope.Server, "Tulkas_SearchHistory");
		SavedHistory = PatchDataLoad(Turbine.DataScope.Server, "Tulkas_SearchHistory");
		-- DToX End
	end

	if pcall(GetSavedHistory) then
		-- Loaded without error
		GetSavedHistory();
	else
		-- Loaded with errors
		SavedHistory = nil;
		printError(_STRINGS.ADDON[3][LANGID]);
	end

	if type(SavedHistory) == 'table' then
		_SEARCHHISTORY = SavedHistory;
	end

	----------------------------------------------------------------------------------------------------------------------------------
	-- SAVED BOOKMARKS --
	local SavedBookmarks = {};

	function GetSavedBookmarks()
		-- DToX Start
		-- Default: SavedBookmarks = Turbine.PluginData.Load(Turbine.DataScope.Server, "Tulkas_Wishlist");
		SavedBookmarks = PatchDataLoad(Turbine.DataScope.Server, "Tulkas_Wishlist");
		-- DToX End
	end

	if pcall(GetSavedBookmarks) then
		-- Loaded without error
		GetSavedBookmarks();
	else
		-- Loaded with errors
		SavedBookmarks = nil;
		printError(_STRINGS.ADDON[1][LANGID]);
	end

	if type(SavedBookmarks) == 'table' then
		_BOOKMARKS = SavedBookmarks;
	end

	----------------------------------------------------------------------------------------------------------------------------------
	-- SAVED BUILDS --
	local SavedBuilds = {};

	function GetSavedBuilds()
		-- DToX Start
		-- Default: SavedBuilds = Turbine.PluginData.Load(Turbine.DataScope.Server, "Tulkas_Builds");
		SavedBuilds = PatchDataLoad(Turbine.DataScope.Server, "Tulkas_Builds");
		-- DToX End
	end

	if pcall(GetSavedBuilds) then
		-- Loaded without error
		GetSavedBuilds();
	else
		-- Loaded with errors
		SavedBuilds = nil;
		printError(_STRINGS.ADDON[9][LANGID]);
	end

	if type(SavedBuilds) == 'table' then
		_BUILDS = SavedBuilds;
	end

	----------------------------------------------------------------------------------------------------------------------------------
	-- SAVED ITEMS --
	local SavedItems = {};

	function GetSavedItems()
		-- DToX Start
		-- Default: SavedItems = Turbine.PluginData.Load(Turbine.DataScope.Account, "Tulkas_Items");
		SavedItems = PatchDataLoad(Turbine.DataScope.Account, "Tulkas_Items");
		-- DToX End
	end

	if pcall(GetSavedItems) then
		-- Loaded without error
		GetSavedItems();
	else
		-- Loaded with errors
		SavedItems = nil;
		printError(_STRINGS.ADDON[10][LANGID]);
	end

	if type(SavedItems) == 'table' then
		_ITEMS = SavedItems;
	end

	----------------------------------------------------------------------------------------------------------------------------------
end


function Debug(STRING)
	if STRING == nil or STRING == "" then return end;
	Turbine.Shell.WriteLine("<rgb=#FF6666>" .. tostring(STRING) .. "</rgb>");
end


function print(MESSAGE)
	if MESSAGE == nil then return end;
	Turbine.Shell.WriteLine(tostring(MESSAGE));
end


function printError(STRING)
	if STRING == nil or STRING == "" then return end;
	Turbine.Shell.WriteLine("<rgb=#FF3333>Tulkas: " .. tostring(STRING) .. "\n" .. _STRINGS.ADDON[2][LANGID] .. "</rgb>");
end


function MergeItemTables()

	if _ITEMSDB == nil or type(_ITEMSDB) ~= 'table' then return end;
	if _ITEMS == nil or type(_ITEMS) ~= 'table' then return end;

	for k,v in pairs (_ITEMS) do
		_ITEMSDB[k] = {};
		_ITEMSDB[k] = Utils.deepcopy(v);
	end

end


function LoadSequence()
	-- DToX Start
	-- Moved here for Debug function
	LANGID = Utils.GetClientLanguage();
	-- DToX End
	if PLAYERCHAR:GetAlignment() ~= Turbine.Gameplay.Alignment.FreePeople or string.find(PLAYERCHAR:GetName(),"~") then
		Debug(_STRINGS.ADDON[7][LANGID]);
	else
		-- DToX Start
		-- Default: LANGID = Utils.GetClientLanguage();
		-- DToX End

		loadData();
		UpdateData();

		MergeItemTables();

		SETTINGS.SHOWSCREEN = true;

		Utils.InitiateChatLogger();
		Windows.DrawWindows();
		RegisterCommands();

		Turbine.Plugin.Unload = function (sender, args)
			if Windows.Includes.wEquipment ~= nil and Windows.Includes.wEquipment:IsVisible() then Windows.Includes.wEquipment:Close() end;
			saveData();
		end

		-- Load text
		Debug("Loaded '" .. Plugins["Tulkas"]:GetName() .. "' v" .. Plugins["Tulkas"]:GetVersion() .. " by Galuhad [Eldar]");
		Debug(_STRINGS.ADDON[5][LANGID]);
		Debug(_STRINGS.ADDON[8][LANGID]);
	end
end


-- Initiate load sequence
LoadSequence();
