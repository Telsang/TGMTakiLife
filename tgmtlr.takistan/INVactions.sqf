
private ["_pfad","_filename","_action","_item","_amount","_plyer"];
_action = _this select 0;
_item   = _this select 1;
_amount = _this select 2;

if (!(_amount call ISSE_str_isInteger))   exitWith {player groupChat localize "STRS_inv_no_valid_number";};
_amount = _amount call ISSE_str_StrToInt;
if (_amount > (_item call INV_GetItemAmount)) exitWith {};
_plyer = _this select 3;
if ((player call ISSE_IsVictim) or (!INV_CanUseInventory)) exitWith {player groupChat localize "STRS_inv_cannotUseNow";};
INV_InventarGiveReceiver = _plyer;

if ((_action == "use") and (INV_CanUseItem)) then

{

_filename = _item call INV_GetItemFilename;

if (_filename != "") then

	{

	_pfad     = format["%1", _item call INV_GetItemFilename];
	["use", _item, _amount, [] ] execVM _pfad;

	}
	else
	{

	player groupChat localize "STRS_inv_inventar_cannotuse";

	};

};

if ((_action == "drop") and (INV_CanDropItem)) then

{

[_item, _amount] execVM "drop.sqf";

};

if ((_action == "give") and (INV_CanGiveItem)) then

{

["uebergabe", _item, _amount, _plyer] execVM "give.sqf";

};