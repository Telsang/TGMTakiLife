private "_num";

if(_this select 4 == "add")then{_num = call compile format["%1", _this select 1]}else{_num = call compile format["-%1", _this select 1]};

format["
if(player == %3) then
	{
		[""%1"",%2] call INV_AddInventoryItem;
		[""stealmoney"", ""%4""] call A_SCRIPT_CIVMENU;
	};
	if(player == %4)then{[""%1"",-(%2)] call INV_AddInventoryItem};
", _this select 0, _num, _this select 2, _this select 3] call broadcast;
