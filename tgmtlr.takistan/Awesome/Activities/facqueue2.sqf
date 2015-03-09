
private ["_id","_arr","_queue","_fqueue","_moneh","_workers"];
if(typename _this == "ARRAY") exitwith

	{

	_id	 = _this select 3;	
	_arr 	 = (INV_ItemFactories select _id);
	_queue	 = (_arr select 8);
	_fqueue  = call compile format["%1", _queue];
	_moneh 	 = "money" call INV_GetItemAmount;
	_workers = call compile format['%1workers', _queue];

	if(_workers >= maxfacworkers2)exitwith{player groupchat "max factory workers reached!"};
	if(_moneh < (facworkercost*10) )exitwith{player groupchat "you do not have enough money"};
	
	["money", -(facworkercost*10)] call INV_AddInventoryItem;

	call compile format['%1workers = %1workers + 10;["%1workers", %1workers] spawn ClientSaveVar;', _queue];

	player groupchat "factory 10 workers hired!";

	if(count _fqueue > 0)then{call compile format['%1eta = %1eta - (%1eta/maxfacworkers);', (_fqueue select 0)];};

	};












