// "Function-Call" Script.
// invActions.sqf

INV_Heal = {
	if(_this == player) exitWith {
		liafu = true;

		format ["%1 switchmove ""AinvPknlMstpSlayWrflDnon_medic"";", player] call broadcast;
		player groupChat format[localize "STRS_inv_items_medikit_benutzung"];
		sleep 5;
		player setdamage 0;
		player groupChat format[localize "STRS_inv_items_medikit_fertig"];
		true
	};
	
	format ["%1 switchmove ""AinvPknlMstpSlayWrflDnon_medic"";", _this] call broadcast;
	player groupChat "Healing civ...";
	sleep 5;
	_this setdamage 0;

	true
};

// Add Item to Inventory
INV_AddInventoryItem = {
	private ["_Fitem","_Famount","_Finfos","_Fgesamtgewicht"];
	_Fitem          = _this select 0;
	_Famount        = _this select 1;
	_Finfos         = _Fitem call INV_GetItemArray;
	_Fgesamtgewicht = 0;
	_Fgesamtgewicht = ( (call INV_GetOwnWeight) + (_Famount * (_Finfos call INV_GetItemTypeKg)) );
	if (_Famount > 0) then {
		if (_Fgesamtgewicht <= INV_CarryingCapacity) then {
			([_Fitem, _Famount, "INV_InventoryArray"] call INV_AddItemStorage)
		} 
		else {
			false
		};
	} 
	else {
		([_Fitem, _Famount, "INV_InventoryArray"] call INV_AddItemStorage)
	};
};


// Add Items to Storage
INV_AddItemStorage = {
	private ["_Fitem","_Fquantity","_Farrname","_Farr","_Farraynum","_Fnumber","_Fextra","_maxGewicht","_curGewicht","_addGewicht","_i"];
	_Fitem      = _this select 0;
	_Fquantity     = _this select 1;
	_Farrname   = _this select 2;
	if (isNil(_Farrname)) then {_Farrname call INV_StorageEmpty};
	_Farr       = call compile _Farrname;
	_Farraynum  = -1;
	_Fnumber    = 0;
	_maxGewicht = -1;
	_curGewicht = 0;
	_addGewicht = 0;

	if (count _this > 3) then {
		if (_Fextra != "") then {
			_Fextra     = _this select 3;
			_maxGewicht = ((_Fextra call INV_GetItemOtherStuff) select 0);
			_curGewicht = _Farrname call INV_GetStorageWeight;
			_addGewicht = (_Fitem call INV_GetItemTypeKg) * _Fquantity;
		};
	};

	if ( (_maxGewicht < 0) or (_maxGewicht >= (_curGewicht+_addGewicht)) ) then {
		for [{_i=0}, {_i < (count _Farr)}, {_i=_i+1}] do {
			if (((_Farr select _i) select 0) == _Fitem) exitWith {
				_Farraynum = _i;
				_Fnumber   = [((_Farr select _i) select 1)] call decode_number;
			};
		};
		if (_Fquantity > 0) then {
			if (_Farraynum == -1) then {
				call compile format ['%1 = %1 + [ [_Fitem, ([_Fquantity] call encode_number)] ];', _Farrname];
				true
			} else {
				call compile format ['%1 SET [_Farraynum, [_Fitem, ([(_Fnumber+_Fquantity)] call encode_number)] ];', _Farrname];
				true
			};
		} else {
			if (_Farraynum == -1) then {
				false
			} else {
				if ((_Fnumber+_Fquantity) < 0) then {
					false
				} else {
					call compile format ['%1 SET [_Farraynum, [_Fitem, ([(_Fnumber+_Fquantity)] call encode_number)] ];', _Farrname];
					true
				};
			};
		};
	} else {
		false
	};
};


// Calculate How Many Items are Stored.
INV_GetStorageAmount = {
	private ["_c", "_Result", "_arrname", "_Array", "_Itemname"];
	_Itemname = _this select 0;
	_arrname  = _this select 1;
	if (isNil(_arrname)) then {_arrname call INV_StorageEmpty};
	_Array    = call compile (_this select 1);
	_Result = 0;
	for [{_c=0}, {_c < (count _Array)}, {_c=_c+1}] do {
		if (((_Array select _c) select 0) == _Itemname) exitWith {
			_Result = ((_Array select _c) select 1);
			_Result = [_Result] call decode_number;
		};
	};
	
	_Result
};

// Storage (probably factories)
INV_ReturnAblage = {
	private ["_Result"];
	if (isNil(_this)) then {_this call INV_StorageLeeren};
	_Result = call compile _this;
	_Result};


// Find Quantity of Items
INV_GetItemAmount = {([_this, "INV_InventoryArray"] call INV_GetStorageAmount)};


// Change Amount of Items
INV_SetStorageAmount = {
	private ["_c", "_Result", "_Itemname", "_Array", "_Arrayname", "_number"];
	_Result    = false;
	_Itemname  = _this select 0;
	_number    = _this select 1;
	_Arrayname = _this select 2;
	if (isNil(_Arrayname)) then {_Arrayname call INV_StorageEmpty};
	_Array = call compile (_Arrayname);
	for [{_c=0}, {_c < (count _Array)}, {_c=_c+1}] do {
		if (((_Array select _c) select 0) == (_this select 0)) exitWith {
			call compile format ["(%1 select %2) SET [1, %3];", _Arrayname, _c, ([_number] call encode_number)];
			_Result = true;
		};
	};

	if ( (!(_Result)) and (_number != 0) ) then {
		_Result = [_Itemname, _number, _Arrayname] call INV_AddItemStorage;
	};

	_Result
};


// Change Amount of Items
INV_SetItemAmount = {
	([(_this select 0), (_this select 1), "INV_InventoryArray"] call INV_SetStorageAmount)
};

INV_InventoryEmpty = {
	private [];
	{
		if ((_x select 0) call INV_GetItemLooseable) then {[(_x select 0), 0] call INV_SetItemAmount;};
	}
	forEach INV_InventoryArray;
};


// Check for a Type of Item in Storage
INV_StorageHasKindOf = {
	private ["_c", "_Itemart", "_Arrayname", "_Array", "_re"];
	_Arrayname = _this select 0;
	_Itemart   = _this select 1;
	_re         = false;
	if (isNil(_Arrayname)) then {_Arrayname call INV_StorageEmpty};
	_Array = call compile (_Arrayname);
	for [{_c=0}, {_c < (count _Array)}, {_c=_c+1}] do {
		if (  ( (((_Array select _c) select 0) call INV_GetItemKindOf)  == _Itemart ) and (([((_Array select _c) select 1)] call decode_number) > 0)  ) exitWith {
			_re = true;
		};
	};
	_re
};


// Remove One Type of Item From Storage
INV_StorageRemoveKindOf = {
	private ["_c", "_Itemart", "_Arrayname", "_Array"];
	_Arrayname = _this select 0;
	_Itemart   = _this select 1;
	if (isNil(_Arrayname)) then {_Arrayname call INV_StorageEmpty};
	_Array = call compile (_Arrayname);
	for [{_c=0}, {_c < (count _Array)}, {_c=_c+1}] do {
		if ( (((_Array select _c) select 0) call INV_GetItemKindOf)  == _Itemart ) then {
			call compile format ["(%1 select %2) SET [1, 0];", _Arrayname, _c];
		};
	};
	true
};


// Unknown
INV_StorageEmpty = {
	call compile format ["%1 = [];", _this];
};
	
INV_ArrayConvert = {call compile (toString _this);};
	
// Check Stored Item Weight
INV_GetStorageWeight = {
	private ["_c","_Gewichtinfos","_Arrayname","_Array","_Fgewicht"];
	_Fgewicht     = 0;
	_Gewichtinfos = 0;
	_Arrayname    = _this;
	_Array        = [];
	if ((typeName _this) == "STRING") then {
		if (isNil(_Arrayname)) then {_Arrayname call INV_StorageEmpty};
		_Array = call compile (_Arrayname);
	} else {
		_Array = _Arrayname;
	};
	for [{_c=0}, {_c < (count _Array)}, {_c=_c+1}] do {
		_Fgewicht = _Fgewicht + ( ([((_Array select _c) select 1)] call decode_number) * (((_Array select _c) select 0) call INV_GetItemTypeKg) );
	};
	_Fgewicht
};


// Get Current Weight
INV_GetOwnWeight = {("INV_InventoryArray" call INV_GetStorageWeight)};


// Check if you are Allowed This Item
INV_CheckIllegalStorage = {
	private ["_Arrayname","_Array","_re"];
	_Arrayname = _this;		_re        = false;
	if (isNil(_Arrayname)) then {_Arrayname call INV_StorageEmpty};
	_Array = call compile (_Arrayname);
	{
		if
		( ( ([(_x select 1)] call decode_number) > 0) and ((_x select 0) call INV_GetItemIsIllegal) ) exitWith {
			_re = true;
		};
	}
	forEach _Array;
	_re
};


// Remove Items that Cannot Exist
INV_RemoveIllegalStorage = {
	private ["_Arrayname","_Array","_re","_i","_amount","_preis","_item","_infos","_vcl"];
	_vcl       = _this select 0;
	_Arrayname = _this select 1;
	_re        = false;
	drugsvalue = 0;

	if ([_arrayname, "drug"] call INV_StorageHasKindOf) then {
		_array = call compile format["%1", _arrayname];

		for [{_i=0}, {_i < (count _Array)}, {_i=_i+1}] do {
			_item   = ((_Array select _i) select 0);
			_infos  = _item call INV_GetItemArray;

			if(_item call INV_GetItemKindOf == "drug") then {

				_amount = ([_item, _arrayname] call INV_GetStorageAmount);
				_preis  = (_infos call INV_GetItemBuyCost);

				drugsvalue = drugsvalue + (_preis*_amount);
			};
		};

		[_arrayname, "drug"] call INV_StorageRemoveKindOf;
		_re = true;
		(format ["if (player == %2) then {player groupChat ""%1 had drugs in its trunk, you removed them. You should jail the owner of %1 for %4 minutes or give him a ticket of $%5.""}; titletext [format[localize ""STRS_civmenucheck_haddrugs"", %1, %3], ""plain""];", _vcl, player, drugsvalue, ceil(drugsvalue/20000), ceil(drugsvalue/2)]) call broadcast;
	}
	else {
		player groupchat "No illegal things found.";
	};
	_re
};


// Remove Illegal Items
INV_RemoveIllegal = {
   private ["_Fhasnvgoogles","_Fhasbinoculars"];
   _Fhasnvgoogles  = 0;
   if (player hasWeapon "NVGoggles") then {_Fhasnvgoogles = 1; };
   _Fhasbinoculars = 0;
   if (player hasWeapon "Binocular") then {_Fhasbinoculars = 1;};
   REMOVEALLWEAPONS player;
   player REMOVEMAGAZINES "Handgrenade";
   //player REMOVEMAGAZINES "Pipebomb";
   player REMOVEMAGAZINES "Mine";
   If (_Fhasnvgoogles == 1)  then {player addWeapon "NVGoggles";};
   If (_Fhasbinoculars == 1) then {player addWeapon "Binocular";};
   {
      if ( ((_x select 0) call INV_GetItemAmount) > 0) then {
         if ((_x select 0) call INV_GetItemIsIllegal) then {[(_x select 0), 0] call INV_SetItemAmount;};
      };
   }
   forEach INV_InventoryArray;
};


// Check if Storage is a Factory
INV_StorageIsFactory = {
	private ["_result","_i"];
	_result = false;
	for [{_i=0}, {_i < (count INV_ItemFactories)}, {_i=_i+1}] do {
		if (((INV_ItemFactories select _i) select 7) == _this) exitWith {
			_result = true;
		};
	};
	_result
};

// Check if Player Can Carry More
INV_CanCarryItems = {
	private ["_Fcheckitem", "_Fcheckzahl"];
	_Fcheckitem = _this select 0;
	_Fcheckzahl = _this select 1;
	if ( ((_Fcheckitem call INV_GetItemTypeKg)*_Fcheckzahl) > (INV_CarryingCapacity - (call INV_GetOwnWeight)) ) then {
		false
	} 
	else {
		true
	};
};


// Function Object Taxes
INV_GetObjectTax = {
	private ["_result"];
	_result = 0;
	//for [{_c=0}, {_c < (count INV_ItemTypeArray)}, {_c=_c+1}] do {
	for "_c" from 0 to (count INV_ItemTypeArray - 1) do {
		if (((INV_ItemTypeArray select _c) select 0) == _this) exitWith {
			_result = ((INV_ItemTypeArray select _c) select 2);
		};
	};
	_result
};


// Fuction Add Percent (Taxes)
INV_AddPercent = {
	private ["_worth","_percent","_result","_round"];
	_worth    = _this select 0;
	_percent = _this select 1;
	_round  = true;
	if (count _this > 2) then {_round = _this select 2};
	if (_round) then {
		_result  = round (  _worth + ((_worth / 100) * _percent) );
	} 
	else {
		_result  = (  _worth + ((_worth / 100) * _percent)  );
	};
	_result
};


// Unknown
INV_IsArmedWith = {
	private ["_Fresult"];
	_Fresult = [false, false, false];
	{
	if ( (((_x select 2) select 0) in (weapons player)) and (((_x select 4) select 0) > 0) ) then {
			if (((_x select 4) select 0) == 1) exitwith {_Fresult SET [0, true];};
			if (((_x select 4) select 0) == 2) exitwith {_Fresult SET [1, true];};
			if (((_x select 4) select 0) == 3) exitwith {_Fresult SET [2, true];};

		};

	}
	forEach INV_AllWeaponObjects;
	_Fresult

};


// Find Player Weapon Type, is either 1,2 or 3. See in INV_AllWeaponObjects, select 4 then select 0. Handgun is "1", rifle "2", explosives "3".
INV_GetWeaponType = {
	private ["_Fresult"];
	_Fresult = -1;
	{
		if (((_x select 2) select 0) == _this) then {
			_Fresult = ((_x select 4) select 0);
		};
	}
	forEach AllLifeMissionObjects;
	_Fresult
};


// Get Kind of Vehicle
INV_GetVehicleType = {
	private ["_Fresult"];
	_Fresult = -1;
	{
		if (((_x select 2) select 0) == _this) then {
			_Fresult = ((_x select 4) select 0);
		};
	}
	forEach AllLifeMissionObjects;
	_Fresult
};

// Check if Player is Armed
INV_IsArmed = {if (count (weapons player - nonlethalweapons) > 0) then {true}else{false}};

// Check if unit is Armed
INV_UnitArmed = {if (count (weapons _this - nonlethalweapons) > 0) then {true}else{false}};

//Function Item Taxes
INV_GetItemTax = {
	private ["_type","_cost"];
	_type = _this call INV_GetItemType;
	_cost = _this call INV_GetItemBuyCost;
	[_cost, (_type call INV_GetObjectTax)] call INV_AddPercent;
};


//Function Price Taxes
INV_GetItemTaxPrice= {
	private ["_type","_preis"];
	_type  = (_this select 0) call INV_GetItemType;
	_preis = (_this select 1);
	[_preis, (_type call INV_GetObjectTax)] call INV_AddPercent;
};


// Add Items to Storage Window Box
INV_AddStorageToDialog = {
	private ["_c","_item","_number","_infos","_KindOf","_CrctlID","_Findex","_Arrayname","_Array","_KindsOf"];
	_Arrayname = _this select 0;
	_CrctlID   = _this select 1;
	_KindsOf   = "";
	if (count _this > 2) then {_KindOf = _this select 2;};
	if (isNil(_Arrayname)) then {_Arrayname call INV_StorageEmpty};
	_Array = call compile (_Arrayname);
	for [{_c=0}, {_c < (count _Array)}, {_c=_c+1}] do {
		_item   = ((_array select _c) select 0);
		_number = [((_array select _c) select 1)] call decode_number;
		_infos  = _item call INV_GetItemArray;
		if ( ((_KindsOf == "") or (_infos call INV_GetItemKindOf == _KindsOf)) and (_number > 0) ) then {
			_Findex = lbAdd [_CrctlID, format ["%1 - (%2)", _infos call INV_GetItemName, _number]];
			lbSetData [_CrctlID, _Findex, _item];
		};
	};
	true
};

// Check if Player Owns Licence
INV_HasLicense = {
	if ( (_this == "") or (_this in INV_LicenseOwner) ) then {
		true
	}
	else {
		false
	};
};


// Get Name of Licence
INV_GetLicenseName = {
	private [];
	for "_c" from 0 to (count INV_Licenses - 1) do {
		if (((INV_Licenses select _c) select 0) == _this) exitWith {
			((INV_Licenses select _c) select 2)
		};
	};
};


// Unknown
INV_GetScriptFromClass_Mag = {
	private ["_result"];
	_result = "";
	for "_c" from 0 to (count AllLifeMissionObjects - 1) do {
		if ((((INV_AllMagazineObjects select _c) select 2) select 0) == _this) exitWith {
			_result = ((INV_AllMagazineObjects select _c) select 0);
		};
	};
	_result
};


// Unknown
INV_GetScriptFromClass_Weap = {
	private ["_result"];
	_result = "";
	for "_c" from 0 to (count AllLifeMissionObjects - 1) do {
		if ((((INV_AllWeaponObjects select _c) select 2) select 0) == _this) exitWith {
			_result = ((INV_AllWeaponObjects select _c) select 0);
		};
	};
	_result
};


// Get item Array
INV_GetItemArray = {
	private ["_Fobjarray","_Nname"];
	_Fobjarray = [];
	if ((typeName _this) == "STRING") then {
			_Nname = format["A_MS_%1", _this];
			_Fobjarray = missionNamespace getVariable [_Nname, objNull];
		};
		
	if ((typeName _this) == "ARRAY") then {
			_Fobjarray = _this;
		};

	_Fobjarray
};

// Get shop array

INV_GetShopArray = {
	private ["_Fshoparray"];
	_Fshoparray = [];
	if ((typeName _this) == "OBJECT") then {
		for "_c" from 0 to (count INV_ItemShops - 1) do {
			if (((INV_ItemShops select _c) select 0) == _this) then {
				_Fshoparray = INV_ItemShops select _c;
			};
		};
	};
	if ((typeName _this) == "ARRAY") then {
		_Fshoparray = _this;
	};
	_Fshoparray
};

// Get shop number

INV_GetShopNum = {
	private ["_c", "_Fshopnum"];
	_Fshopnum = [];
	if ((typeName _this) == "OBJECT") then {
		for [{_c=0}, {_c < (count INV_ItemShops)}, {_c=_c+1}] do {
			if (((INV_ItemShops select _c) select 0) == _this) then {
				_Fshopnum = _c;
			};
		};
	};

	_Fshopnum
};

// Get shopitem number

INV_GetShopItemNum = {

private ["_c","_Fshopitemnum","_item","_shopinv"];
_Fshopitemnum = [];
_item = _this select 0;
_shopinv = _this select 1;

if ((typeName _item) == "STRING") then

	{

	for [{_c=0}, {_c < (count _shopinv)}, {_c=_c+1}] do

		{

		if ((_shopinv select _c) == _item) then

			{

			_Fshopitemnum = _c;

			};

		};

	};

_Fshopitemnum

};

// check if item is in a shop

INV_ItemInShop = {
	private ["_c","_Fiteminshop","_item","_shopinv"];
	_Fiteminshop = [];
	_item = _this select 0;
	_shopinv = _this select 1;
	if ((typeName _item) == "STRING") then {
		for [{_c=0}, {_c < (count _shopinv)}, {_c=_c+1}] do {
			if ((_shopinv select _c) == _item) then {
				_Fiteminshop = true;
			};
		};
	};

	if((typeName _Fiteminshop) == "ARRAY")then{_Fiteminshop = false};

	_Fiteminshop
};

INV_GetStock = {
	
private ["_item","_shopnum","_shoparr","_shopinv","_itemnum"];
_item    = _this select 0;
	_shopnum = (_this select 1);
	_shoparr = INV_ItemShops select _shopnum;
	_shopinv = _shoparr select 4;
	_itemnum = [_item, _shopinv] call INV_GetShopItemnum;

	if (!(format["%1", typename _shopnum] == "SCALAR" && format["%1", typename _itemnum] == "SCALAR")) exitWith {-1};

	if(typename (INV_ItemMaxStocks select _shopnum) != "ARRAY")exitwith{-1};

	(INV_ItemStocks select _shopnum) select _itemnum

};

INV_GetMaxStock = {
	
private ["_item","_shopnum","_shoparr","_shopinv","_itemnum"];
_item 	 = _this select 0;
	_shopnum = (_this select 1);
	_shoparr = INV_ItemShops select _shopnum;
	_shopinv = _shoparr select 4;
	_itemnum = [_item, _shopinv] call INV_GetShopItemNum;

	if (!(format["%1", typename _shopnum] == "SCALAR" && format["%1", typename _itemnum] == "SCALAR")) exitWith {-1};

	if(typename (INV_ItemMaxStocks select _shopnum) != "ARRAY")exitwith{-1};

	(INV_ItemMaxStocks select _shopnum) select _itemnum

};

INV_ItemStocksupdate = {
	
private ["_item","_stock","_shopnum","_shoparr","_shopinv","_itemnum"];
_item     = _this select 0;
	_stock    = _this select 1;
	_shopnum  = _this select 2;
	_shoparr  = INV_ItemShops select _shopnum;
	_shopinv  = (_shoparr select 4);
	_itemnum  = [_item, _shopinv] call INV_GetShopItemNum;

	if (isNil "_shopnum") exitWith {};
	if (typeName _shopnum != "SCALAR") exitWith {};
	if (isNil "_itemnum") exitWith {};
	if (typeName _itemnum != "SCALAR") exitWith {};

	(INV_ItemStocks select _shopnum) SET [_itemnum, _stock];
};

INV_FindUnit = {
	
private ["_unit","_obj","_name","_arr"];
_name   = _this select 0;
	_arr    = _this select 1;
	_unit   = objnull;

	for "_i" from 0 to (count _arr) do {
		_obj = _arr select _i;
		if(!isnull _obj and name _obj == _name)exitwith{_unit = _obj};
	};
	_unit
};

INV_MyGang = {
	
private ["_mygang","_gangarray","_gang","_members"];
_mygang  = "";

	for "_c" from 0 to (count gangsarray - 1) do {
		_gangarray = gangsarray select _c;
		_gang = _gangarray select 0;
		_members = _gangarray select 1;
		if(name player in _members)then{_mygang = _gang};
	};

	_mygang
};

INV_Seen = {
	private ["_obj","_arr","_dis","_res","_exitvar","_gangarray","_gang","_members","_mygang"];
	_obj = _this select 0;
	_arr = (_this select 1) - [_obj];
	_dis = _this select 2;
	_res = false;
	if (isNull _obj) then {
		_res = false;
	}
	else {
		for "_c" from 0 to (count _arr - 1) do {
			if (not(isNull(_arr select _c))) then {
				if ((_obj distance (_arr select _c)) < _dis) then {
					_mygang = call INV_MyGang;
					_exitvar = false;

					if(_mygang != "")then {
						for "_i" from 0 to (count gangsarray - 1) do {
							_gangarray = gangsarray select _i;
							_gang = _gangarray select 0;
							_members = _gangarray select 1;

							if(_mygang == _gang and name (_arr select _c) in _members)then{_exitvar=true};
						};
					};

					if(!_exitvar)then{_res = true};
				};
			};
		};
	};
	_res
};


// Get Object Details
INV_GetItemScriptName = { ((_this call INV_GetItemArray) select 0)};
INV_GetItemType = {((_this call INV_GetItemArray) select 1) select 0};
INV_GetItemKindOf = { ((_this call INV_GetItemArray) select 1) select 1	 };
INV_GetItemClassName = { ((_this call INV_GetItemArray) select 2) select 0 };
INV_GetItemName = {((_this call INV_GetItemArray) select 2) select 1};
INV_GetItemBuyCost = {((_this call INV_GetItemArray) select 3) select 0 };
INV_GetItemSellCost = { ((_this call INV_GetItemArray) select 3) select 1 };
INV_GetItemTypeKg = { ((_this call INV_GetItemArray) select 4) select 0 };
INV_GetVehMaxKg = { ((_this call INV_GetItemArray) select 4) select 3 };
INV_GetItemLicense = { private["_license_1"]; _license_1 = (((_this call INV_GetItemArray) select 4) select 1); if (isNil "_license_1") exitWith {""}; _license_1};
INV_GetItemLicense2 = { private["_license_2"]; _license_2 = (((_this call INV_GetItemArray) select 4) select 2); if (isNil "_license_2") exitWith {""}; _license_2};
INV_GetItemOtherStuff = { ((_this call INV_GetItemArray) select 5) };
INV_GetItemDescription1 = { ((_this call INV_GetItemArray) select 6) };
INV_GetItemDescription2 = { ((_this call INV_GetItemArray) select 7) };
INV_GetItemMaterials = { ((_this call INV_GetItemArray) select 8) };
INV_GetItemCostWithTax  = { ((_this call INV_GetItemArray) call INV_GetItemTax) };
INV_GetItemGiveable = { ((_this call INV_GetItemArray) select 5) select 0 };
INV_GetItemDropable = { ((_this call INV_GetItemArray) select 5) select 1 };
INV_GetItemLooseable = { ((_this call INV_GetItemArray) select 5) select 2 };
INV_GetItemIsIllegal = { ((_this call INV_GetItemArray) select 5) select 3 };
INV_GetItemFilename = { ((_this call INV_GetItemArray) select 5) select 4 };
INV_GetVehicleCanCarry = { ((_this call INV_GetItemArray) select 5) select 0 };
INV_GetVehicleSeats = { ((_this call INV_GetItemArray) select 5) select 1 };

//player groupChat "Done definining INV_Functions!";
