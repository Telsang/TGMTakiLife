private ["_handler"];
INV_PLAYERLIST	        = _this select 0;
INV_PLAYERSTRINGLIST    = _this select 1;
INV_CANDOILLEGAL        = _this select 2;
INV_ROLESTRING          = format["%1", player];
INV_MAX_ITEMS           = 1000000;
INV_MAX_DROPS	 		= 300;
INV_PLAYERCOUNT         = count INV_PLAYERSTRINGLIST;
INV_SaveVclArray        = true;
INV_VehicleArray        = [];
INV_VehicleArrayS		= [];
INV_SaveObjArray        = false;
INV_shortcuts           = true;
INV_SperrenVerbotArray  = [[copbase1, 250],[mosqueprop, 120], [banklogic, 35], [pmcprop, 70], [asairspawn, 30], [afacspawn, 30], [insvehspawn, 80],[redhelispawn, 100],[CopPrisonAusgang, 20]];
INV_JIP = true; publicVariable "INV_JIP";


_handler = [] execVM "INVfunctions.sqf";
waitUntil {scriptDone _handler};
_handler = [] execVM "masterarray.sqf";
waitUntil {scriptDone _handler};
_handler = [] execVM "createfunctions.sqf";
waitUntil {scriptDone _handler};
_handler = [] execVM "carparks.sqf";
waitUntil {scriptDone _handler};

_handler = [] execVM "Awesome\Scripts\optimize_2.sqf";
waitUntil {scriptDone _handler};

_handler = [] execVM "Awesome\Scripts\shops.sqf";
waitUntil {scriptDone _handler};

_handler = [] execVM "facharvest.sqf";
waitUntil {scriptDone _handler};
_handler = [] execVM "licensearray.sqf";
waitUntil {scriptDone _handler};
_handler = [] execVM "vclarrsave.sqf";

if (isCLient) then {
	[] execVM "shopfarmfaclicenseactions.sqf";
};