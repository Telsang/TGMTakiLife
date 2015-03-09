#define strM(x) ([x, ","] call format_integer)
private ["_license","_name","_cost","_number","_art"];
_this    = _this select 3;
_number  = _this select 0;
_art     = _this select 1;

Allowed_Hookers = [];

if ((_art == "remove") or (_art == "add")) then {
	if (_art == "add") then {
	
		_license = ((INV_Licenses select _number) select 0);
		_name    = ((INV_Licenses select _number) select 2);
		_cost    = ((INV_Licenses select _number) select 3);
		
		if (_license call INV_HasLicense) exitWith {server globalChat localize "STRS_inv_buylicense_alreadytrue";};
		if (('money' call INV_GetItemAmount) < _cost) exitWith {server globalChat localize "STRS_inv_buylicense_nomoney";};
		//if(_license == "hooker_training" and !(_uid in Allowed_Hookers)) exitWith { server globalChat ":::[NOTICE]::: Hooker training is restricted to hookers only";};
	
		if(_license == "car" or _license == "truck")then{demerits = 10};
		['money', -(_cost)] call INV_AddInventoryItem;
		server globalChat format[localize "STRS_inv_buylicense_gottraining", strM(_cost), _name];
	
		
		INV_LicenseOwner = INV_LicenseOwner + [_license];
		["INV_LicenseOwner", INV_LicenseOwner] spawn ClientSaveVar;
	
	} else {
	
		_license = ((INV_Licenses select _number) select 0);
		_name    = ((INV_Licenses select _number) select 2);
		if (not(_license call INV_HasLicense)) exitWith {server globalChat localize "STRS_inv_buylicense_alreadyfalse";};
		INV_LicenseOwner = INV_LicenseOwner - [_license];
		server globalChat format[localize "STRS_inv_buylicense_losttraining", _name];
		["INV_LicenseOwner", INV_LicenseOwner] spawn ClientSaveVar;
	
	};
	
};