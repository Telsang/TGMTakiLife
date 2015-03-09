#define strM(x) ([x, ","] call format_integer)
private ["_i","_index","_itemcounter","_c","_spieler","_item","_number","_array"];
if (!(createDialog "inventar")) exitWith {hint "Dialog Error!";};

_itemcounter = 0;

//diag_log format["INV_InventoryArray = %1", INV_InventoryArray];

for [{_i=0}, {_i < (count INV_InventoryArray)}, {_i=_i+1}] do {
	private ["_item", "_number", "_lbl_name"];
	_item   = ((INV_InventoryArray select _i) select 0);
	_number = (_item call INV_GetItemAmount);

	if (_number > 0) then {
		_lbl_name = (_item call INV_GetItemName);
		_index = lbAdd [1, format ["%1",_lbl_name]];
		lbSetData [1, _index, _item];
		_itemcounter = _itemcounter + 1;
	};
};

if (_itemcounter == 0) exitWith {player groupChat localize "STRS_inv_inventardialog_empty";};

for [{_c=0}, {_c < (count INV_PLAYERSTRINGLIST)}, {_c=_c+1}] do {
	_spieler = INV_PLAYERSTRINGLIST select _c;

	if (_spieler call ISSE_UnitExists) then {
		_index = lbAdd [99, format ["%1 - (%2)", _spieler, name (call compile _spieler)]];
		lbSetData [99, _index, format["%1", _c]];
	};
};

lbSetCurSel [99, 0];
lbSetCurSel [1, 0];
buttonSetAction [3,format["[""use"",  lbData [1, (lbCurSel 1)], ctrlText 501, lbData [99, (lbCurSel 99)]] execVM ""INVactions.sqf""; closedialog 0;"] ];
buttonSetAction [4,format["[""drop"", lbData [1, (lbCurSel 1)], ctrlText 501, lbData [99, (lbCurSel 99)]] execVM ""INVactions.sqf""; closedialog 0;"] ];
buttonSetAction [246,format["[""give"", lbData [1, (lbCurSel 1)], ctrlText 501, lbData [99, (lbCurSel 99)]] execVM ""INVactions.sqf""; closedialog 0;"] ];

while {ctrlVisible 1001} do {
	_item   = lbData [1, (lbCurSel 1)];
	_number = _item call INV_GetItemAmount;
	_array  = _item call INV_GetItemArray;

	ctrlSetText [62,  format ["%1", strM(_number)]];
	ctrlSetText [52,  format ["%1", _array call INV_GetItemName]];
	ctrlSetText [72,  format ["%1", _array call INV_GetItemDescription1]];
	ctrlSetText [7,   format ["%1", _array call INV_GetItemDescription2]];
	ctrlSetText [202, format ["%1/%2", (_array call INV_GetItemTypeKg), (((_array call INV_GetItemTypeKg)*(_number)) call ISSE_str_IntToStr)]];
	
	sleep 0.1;
};
