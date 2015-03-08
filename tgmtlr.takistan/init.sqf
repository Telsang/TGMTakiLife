sleep 0.5;
enableSaving [false, false];

//Setting Friendlies
WEST setFriend [EAST, 0];
WEST setFrined[RESISTANCE, 0];

EAST setFriend [WEST, 0];
EAST setFriend [RESISTANCE, 0];

RESISTANCE setFriend [EAST, 0];
RESISTANCE setFriend [WEST, 0];

CIVILIAN setFriend [WEST, 0];
CIVILIAN setFriend [EAST, 0];
CIVILIAN setFriend [RESISTANCE, 0];

isClient = !isServer ||(isServer && !isDedicated);

if (!isServer) then {
		[] spawn {
				TGM_CLIENT_LOAD = false;
				
				waitUntil {!isNull player};
				waitUntil {vehicle player == player};
				waitUntil {(getPlayerUID player) != ""};
				
				TGM_CLIENT_VVN	= vehicleVarName player;
				TGM_CLIENT_UID	= getPlayerUID player;
				TGM_CLIENT_SIDE	= playerSide;
				TGM_CLIENT_ID	= owner player;
				
				TGM_CLIENT_LOAD = true;
				
			};
	} else {
		
		onplayerconnected {
				publicVariable "GesetzArray";
				publicvariable "INV_ItemStocks";
				format["if(%1)then{power1 setdamage 0;liafu = true;};if(%2)then{power2 setdamage 0;liafu = true;};", alive power1, alive power2] call broadcast;
				missionNamespace setVariable [format["A_STAT_%1_LOADED", _uid], false];
				waitUntil {!isNil "A_STAT_SLR"};
				waitUntil {A_STAT_SLR};
				publicVariable "A_STAT_SLR";
			};
		
	};

if(!debug)then{["basicintro"] execVM "introcam.sqf";};