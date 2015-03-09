
private ["_num","_fabname","_cost","_moneh"];
_num     = ((_this select 3) select 0);
_fabname = ((INV_ItemFactories select _num) select 1);
_cost    = ((INV_ItemFactories select _num) select 6);
_moneh    = 'money' call INV_GetItemAmount;

if (_fabname in INV_Fabrikowner) exitWith {player groupChat localize "STRS_inv_alreadygotshop";};
if (_moneh < _cost) 		 exitWith {player groupChat localize "STRS_inv_kein_moneh";};

INV_Fabrikowner = INV_Fabrikowner + [ _fabname ];
['money', -(_cost)] call INV_AddInventoryItem;
["INV_Fabrikowner", INV_Fabrikowner] spawn ClientSaveVar;

player groupChat format[localize "STRS_inv_gotshop", player, (_cost call ISSE_str_IntToStr)];
