private ["_i"];
waitUntil {((alive player) or (local server))};

if(local server and !local player)then{dedicatedServer = true};
if(local server and local player)then{hostedServer = true};

playerstringarray = [
"Civ1","Civ2","Civ3","Civ4","Civ5","Civ6","Civ7","Civ8","Civ9","Civ10","Civ11","Civ12","Civ13","Civ14","Civ15","Civ16","Civ17","Civ18","Civ19","Civ20","Civ21","Civ22","Civ23","Civ24","Civ25","Civ26","Civ27","Civ28","Civ29","Civ30","Civ31","Civ32","Civ33","Civ34","Civ35","Civ36","Civ37","Civ38","Civ39","Civ40",
"ins1","ins2","ins3","ins4","ins5","ins6","ins7","ins8","ins9","ins10","ins11","ins12","ins13","ins14","ins15","ins16","ins17","ins18","ins19","ins20",
"opf1","opf2","opf3","opf4","opf5","opf6","opf7","opf8","opf9","opf10","opf11","opf12","opf13","opf14","opf15","opf16","opf17","opf18","opf19","opf20",
"Cop1","Cop2","Cop3","Cop4","Cop5","Cop6","Cop7","Cop8","Cop9","Cop10","Cop11","Cop12","Cop13","Cop14","Cop15","Cop16","Cop17","Cop18","Cop19","Cop20"
];

for [{_i=0}, {_i < (count playerstringarray)}, {_i=_i+1}] do {if (isNil (playerstringarray select _i)) then { call compile format["%1 = objNull;", (playerstringarray select _i)]; }; };

playerarray = [
civ1,civ2,civ3,civ4,civ5,civ6,civ7,civ8,civ9,civ10,civ11,civ12,civ13,civ14,civ15,civ16,civ17,civ18,civ19,civ20,civ21,civ22,civ23,civ24,civ25,civ26,civ27,civ28,civ29,civ30,civ31,civ32,civ33,civ34,civ35,civ36,civ37,civ38,civ39,civ40,
ins1,ins2,ins3,ins4,ins5,ins6,ins7,ins8,ins9,ins10,ins11,ins12,ins13,ins14,ins15,ins16,ins17,ins18,ins19,ins20,
opf1,opf2,opf3,opf4,opf5,opf6,opf7,opf8,opf9,opf10,opf11,opf12,opf13,opf14,opf15,opf16,opf17,opf18,opf19,opf20,
cop1,cop2,cop3,cop4,cop5,cop6,cop7,cop8,cop9,cop10,cop11,cop12,cop13,cop14,cop15,cop16,cop17,cop18,cop19,cop20
];
civstringarray    = ["Civ1","Civ2","Civ3","Civ4","Civ5","Civ6","Civ7","Civ8","Civ9","Civ10","Civ11","Civ12","Civ13","Civ14","Civ15","Civ16","Civ17","Civ18","Civ19","Civ20","Civ21","Civ22","Civ23","Civ24","Civ25","Civ26","Civ27","Civ28","Civ29","Civ30","Civ31","Civ32","Civ33","Civ34","Civ35","Civ36","Civ37","Civ38","Civ39","Civ40","ins1","ins2","ins3","ins4","ins5","ins6","ins7","ins8","ins9","ins10","opf1","opf2","opf3","opf4","opf5","opf6","opf7","opf8","opf9","opf10"];
civarray          = [civ1,civ2,civ3,civ4,civ5,civ6,civ7,civ8,civ9,civ10,civ11,civ12,civ13,civ14,civ15,civ16,civ17,civ18,civ19,civ20,civ21,civ22,civ23,civ24,civ25,civ26,civ27,civ28,civ29,civ30,civ31,civ32,civ33,civ34,civ35,civ36,civ37,civ38,civ39,civ40,ins1,ins2,ins3,ins4,ins5,ins6,ins7,ins8,ins9,ins10,opf1,opf2,opf3,opf4,opf5,opf6,opf7,opf8,opf9,opf10];

copstringarray    = ["Cop1","Cop2","Cop3","Cop4","Cop5","Cop6","Cop7","Cop8","Cop9","Cop10","Cop11","Cop12","Cop13","Cop14","Cop15","Cop16","Cop17","Cop18","Cop19","Cop20"];
coparray 		  = [cop1,cop2,cop3,cop4,cop5,cop6,cop7,cop8,cop9,cop10,cop11,cop12,cop13,cop14,cop15,cop16,cop17,cop18,cop19,cop20];

insarray			= [ins1,ins2,ins3,ins4,ins5,ins6,ins7,ins8,ins9,ins10,ins11,ins12,ins13,ins14,ins15,ins16,ins17,ins18,ins19,ins20];
insstringarray		= ["ins1","ins2","ins3","ins4","ins5","ins6","ins7","ins8","ins9","ins10","ins11","ins12","ins13","ins14","ins15","ins16","ins17","ins18","ins19","ins20"];

opfarray			= [opf1,opf2,opf3,opf4,opf5,opf6,opf7,opf8,opf9,opf10,opf11,opf12,opf13,opf14,opf15,opf16,opf17,opf18,opf19,opf20];
opfstringarray		= ["opf1","opf2","opf3","opf4","opf5","opf6","opf7","opf8","opf9","opf10","opf11","opf12","opf13","opf14","opf15","opf16","opf17","opf18","opf19","opf20"];

rolenumber = 0;

for [{_i=0}, {_i < (count playerarray)}, {_i=_i+1}] do {
	call compile format["if ((playerarray select %1) == player) then {rolenumber = (%1 + 1);}", _i];
};
role = player;
	

if (player in coparray) then{
iscop          = true;
isciv	       = false;
isopf		   = false;
isins 		   = false;							
rolecop        = 1;								
sidenumber     = rolenumber - civscount;			
longrolenumber = 1100 + sidenumber;			
rolestring     = format["Cop%1", sidenumber];
};

if (player in civarray) then {
	if (player in insarray) then {
		isins = true;
	} else {
		isins = false;
	};
	
	if (player in opfarray) then {
		isopf = true;
	} else {
		isopf = false;
	};
	
	isciv          = true;
	iscop          = false;
	rolecop        = 0;
	sidenumber     = rolenumber;
	longrolenumber = 1000 + sidenumber;
	rolestring     = format["Civ%1", sidenumber];
};

if (typeName player == "OBJECT") then {
	if (!isNull player) then {
		call compile format["old%1 = objnull", player];
	};
};

	_uid  = getPlayerUID player;
	_civnum = player;
	
{
	if (_civnum == _x) then
	{
		if !(isDonator) then
		{
			player groupChat "This slot is reserved to donators! You will be kicked back to lobby!";
			sleep 10;
			failMission "END1";
		}
		else
		{
			player groupChat "Welcome Donator."
		};
	};
} foreach donatorslots;