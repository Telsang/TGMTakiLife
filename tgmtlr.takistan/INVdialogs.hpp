class factory_manifacture {

	idd = 2002;
	movingEnable = true;
	controlsBackground[] = {DLG_BACK1, background};
	objects[] = { };
	controls[] = {list_manifacture, list_needed, manifacture_edit, manifacture, close, create_edit, create, export, dummybutton};

	class DLG_BACK1: Rscbackground {
		x = 0.30; y = 0.10;
		w = 0.34; h = 0.80;
	};

	class background : RscBgRahmen {
		x = 0.30; y = 0.10;
		w = 0.34; h = 0.80;
		text = $STRS_inv_fac_dia_herstellen;
	};

	class list_manifacture : RscListBox {
		idc = 1;
		x = 0.32; y = 0.14;
		w = 0.30; h = 0.25;
	};

	class list_needed : RscListBox {
		idc = 2;
		x = 0.32; y = 0.42;
		w = 0.30; h = 0.25;
	};
	
	class create_edit : RscEdit {
		idc = 9;
		x = 0.32; y = 0.69;
		w = 0.13; h = 0.04;
		text = "1";
	};
	
	class create : RscButton {
		idc = 4;
		x = 0.47; y = 0.69;
		w = 0.15; h = 0.04;
		text = "Create";
	};
	
	
	class export : RscButton {
		idc = 5;
		x = 0.32; y = 0.74;
		w = 0.30; h = 0.04;
		text = "Export";
	};
	
	class manifacture_edit : RscEdit {
		idc = 8;
		x = 0.32; y = 0.79;
		w = 0.13; h = 0.04;
		text = "1";
	};
	
	class manifacture : RscButton {
		idc = 3;
		x = 0.47; y = 0.79;
		w = 0.15; h = 0.04;
		text = "Manufacture";
	};

	class close : RscButton {
		x = 0.32; y = 0.84;
		w = 0.30; h = 0.04;
		text = $STRD_inv_description_close;
		action = "closeDialog 0;";
	};

	class dummybutton : RscDummy {idc = 1030;};

};


class itemkaufdialog {

	idd = -1;
	movingEnable = true;
	controlsBackground[] = {DLG_BACK1, DLG_BACK2, background1, background2};
	objects[] = { };
	controls[] = {itemliste, itemeingabe, submit, cancel, weight, cancel2, submit2, itemeingabe2, itemliste2, text_inventargeld, dummybutton};

	onUnload = "call trunk_close;";
	
	class DLG_BACK1: RscBackground {
		x = 0.02; y = 0.07;
		w = 0.46; h = 0.63;
	};

	class DLG_BACK2: RscBackground {
		x = 0.51; y = 0.07;
		w = 0.46; h = 0.63;
	};

	class background1 : RscBgRahmen {
		x = 0.02; y = 0.07;
		w = 0.46; h = 0.63;
		text = $STRD_inv_description_itemmenu_title;
		idc = 91;
	};

	class itemliste : RscListBox {
		idc = 1;
		x = 0.04; y = 0.10;
		w = 0.42; h = 0.48;
	};

	class itemeingabe : RscEdit {
		idc = 2;
		x = 0.04; y = 0.60;
		w = 0.20; h = 0.04;
		text = "1";
	};

	class submit : RscButton {
		idc = 3;
		x = 0.25; y = 0.60;
		w = 0.20; h = 0.04;
	};

	class cancel : RscButton {
		x = 0.25; y = 0.65;
		w = 0.20; h = 0.04;

		text = $STRD_inv_description_buyitem_close;
		action = "closedialog 0";
	};

	class weight : RscText {
		idc = 765;
		x = 0.04; y = 0.65;
		w = 0.20; h = 0.04;
	};

	class background2 : RscBgRahmen {
		x = 0.51; y = 0.07;
		w = 0.46; h = 0.63;
		idc = 92;
		text = $STRD_inv_description_itemmenu_title2;
	};

	class cancel2 : RscButton {
		x = 0.74; y = 0.65;
		w = 0.20; h = 0.04;
		text = $STRD_inv_description_buyitem_close;
		action = "closedialog 0;";
	};

	class submit2 : RscButton {
		idc = 103;
		x = 0.74; y = 0.60;
		w = 0.20; h = 0.04;
	};

	class itemeingabe2 : RscEdit {
		idc = 102;
		x = 0.53; y = 0.60;
		w = 0.20; h = 0.04;
		text = "1";
	};

	class itemliste2 : RscListBox 	{
		idc = 101;
		w = 0.42; h = 0.48;
		x = 0.53; y = 0.10;
	};

	class text_inventargeld : RscText {
		idc = 100;
		x = 0.04; y = 0.65;
		w = 0.20; h = 0.04;
	};

	class dummybutton : RscDummy {idc = 1015;};

};

class inventar {										
	idd = -1;														
	movingEnable = true;								
	controlsBackground[] = {background};									
	objects[] = { };															
	controls[] = {
		mainframe,
		button_use, 
		button_drop, 
		button_cancel, 
		TransferButton,
		InfoItem, 
		InfoItemVar, 
		InfoAnzahl, 
		InfoAnzahlVar, 
		InfoAddinfo, 
		InfoAddinfoVar, 
		InfoGewicht, 
		InfoGewichtVar,
		UseAmounteingabe, 
		description, 
		playerlist, 
		Itemlist, 
		dummybutton
	};																					

	class background: RscBackground
	{
		idc = -1;
		x = 0.00476342;
		y = 0.00793712;
		w = 0.990477;
		h = 0.587301;
		colorText[] = {0,0.7,0.9,1};
		colorBackground[] = {0,0,0,0.7235};
	};
	
	class mainframe: RscFrame
	{
		idc = -1;
		text = "JGGaming Inventory";
		x = 0.00476342;
		y = 0.00793712;
		w = 0.990477;
		h = 0.587301;
		colorText[] = {0,0.7,0.9,1};
		colorBackground[] = {0,0,0,0.7235};
	};

	class button_use: RscButton
	{
		idc = 3;
		text = "Use Item";
		x = 0.0107146;
		y = 0.280952;
		w = 0.302381;
		h = 0.0476191;
		colorText[] = {0,0.7,0.9,1};
		colorBackground[] = {0,0,0,1};
		colorBackgroundActive[] = {0,0.3,0.9,1};
	};			

	class button_cancel: RscButton
	{
		idc = -1;
		text = "Cancel";
		action = "closedialog 0;";
		x = 0.35;
		y = 0.539683;
		w = 0.302381;
		h = 0.0476191;
		colorText[] = {0,0.7,0.9,1};
		colorBackground[] = {0,0,0,1};
		colorBackgroundActive[] = {0,0.3,0.9,1};
	};										

	class button_drop: RscButton
	{
		idc = 4;
		text = "Drop Item";
		x = 0.00952387;
		y = 0.347619;
		w = 0.302381;
		h = 0.0476191;
		colorText[] = {0,0.7,0.9,1};
		colorBackground[] = {0,0,0,1};
		colorBackgroundActive[] = {0,0.3,0.9,1};
	};												

	class TransferButton: RscButton
	{
		idc = 246;
		text = "Give Item";
		x = 0.0107138;
		y = 0.539682;
		w = 0.302381;
		h = 0.0476191;
		colorText[] = {0,0.7,0.9,1};
		colorBackground[] = {0,0,0,1};
		colorBackgroundActive[] = {0,0.3,0.9,1};
	};														

	class UseAmounteingabe: RscEdit
	{
		idc = 501;
		x = 0.0107146;
		y = 0.41111;
		w = 0.302381;
		h = 0.0492058;
		colorText[] = {0,0.7,0.9,1};
		text = "1";
		SizeEX = 0.0250;
	};																													

	class playerlist: RscCombo
	{
		idc = 99;
		x = 0.0107144;
		y = 0.48254;
		w = 0.302381;
		h = 0.0365081;
		colorText[] = {0,0.7,0.9,1};
	};															

	class InfoItem: RscText
	{
		idc = 51;
		text = "Item:";
		x = 0.0107147;
		y = 0.0587305;
		w = 0.0642852;
		h = 0.0349205;
		colorText[] = {0,0.7,0.9,1};
		SizeEX = 0.0250;
	};										

	class InfoItemVar: RscText
	{
		idc = 52;
		x = 0.0773811;
		y = 0.0587296;
		w = 0.294047;
		h = 0.0349206;
		colorText[] = {0,0.7,0.9,1};
		SizeEX = 0.0220;
	};			

	class InfoAnzahl: RscText
	{
		idc = 61;
		text = "Amount:";
		x = 0.0107146;
		y = 0.107937;
		w = 0.098809;
		h = 0.0365078;
		colorText[] = {0,0.7,0.9,1};
		SizeEX = 0.0250;
	};														

	class InfoAnzahlVar: RscText
	{
		idc = 62;
		x = 0.113095;
		y = 0.106349;
		w = 0.289285;
		h = 0.0365079;
		colorText[] = {0,0.7,0.9,1};
		SizeEX = 0.0220;
	};															

	class InfoAddinfo: RscText
	{
		idc = 71;
		text = "Extra Info:";
		x = 0.00952411;
		y = 0.157143;
		w = 0.128571;
		h = 0.0365078;
		colorText[] = {0,0.7,0.9,1};
		SizeEX = 0.0250;
	};						

	class InfoAddinfoVar: RscText
	{
		idc = 72;
		x = 0.142857;
		y = 0.157143;
		w = 0.22738;
		h = 0.0365079;
		colorText[] = {0,0.7,0.9,1};
		SizeEX = 0.0220;
	};													
	
	class InfoGewicht: RscText
	{
		idc = 201;
		text = "Weight Item/Total:";
		x = 0.0107144;
		y = 0.20794;
		w = 0.221428;
		h = 0.0365078;
		colorText[] = {0,0.7,0.9,1};
		SizeEX = 0.0250;
	};									 
	
	class InfoGewichtVar: RscText
	{
		idc = 202;
		x = 0.236905;
		y = 0.207941;
		w = 0.10238;
		h = 0.0365079;
		colorText[] = {0,0.7,0.9,1};
		SizeEX = 0.0220;
	};																			

	class description: RscText
	{
		idc = 7;
		x = 0.348809;
		y = 0.20635;
		w = 0.396428;
		h = 0.287301;
		colorText[] = {0,0.7,0.9,1};
		SizeEX = 0.0250;
		style = ST_MULTI;																
		lineSpacing = 1;
	};													

	class Itemlist: RscListbox
	{
		idc = 1;
		x = 0.755948;
		y = 0.0333334;
		w = 0.227381;
		h = 0.546031;
		colorText[] = {0,0.7,0.9,1};
		SizeEX = 0.0250;
	};									

	class dummybutton : RscDummy {
		idc = 1001;
	};
};

class INV_list
{						
	idd = -1;
	movingEnable = true;
	controlsBackground[] = {DLG_BACK1, background};
	objects[] = { };
	controls[] = {liste, close, dummybutton};
														
	class DLG_BACK1: RscBackground {
		x = 0.21; y = 0.05;																												
		w = 0.52; h = 0.84;									
	};										

	class background : RscBgRahmen {																														
		x = 0.21; y = 0.05;						
		w = 0.52; h = 0.84;						
		text = "List";					
	};						

	class liste : RscListBox {												
		idc = 1;																				
		x = 0.22; y = 0.08;																														
		w = 0.50; h = 0.73;																				
		SizeEX = 0.0195; 																
		RowHeight = 0.03; 			
	};										

	class close : RscButton {						
		idc = 2;																								
		x = 0.39; y = 0.83;										
		w = 0.20; h = 0.04;																										
		text = $STRD_inv_description_buyitem_close;																														
		action = "closedialog 0;";															
	};			

	class dummybutton : RscDummy {idc = 2017;};

};

class INV_ItemListDialog
{													
	idd = -1;														
	movingEnable = true;									
	controlsBackground[] = {DLG_BACK1, background};							
	objects[] = { };											
	controls[] = {Itemlist, InfoText, InfoGewicht, list_needed, button_cancel, dummybutton};									
	
	class DLG_BACK1: Rscbackground {																										
		x = 0.05; y = 0.05;															   
		w = 0.90; h = 0.90;				
	};									
	
	class background : RscBgRahmen {												
		x = 0.05; y = 0.05;													    
		w = 0.90; h = 0.90;																										
		text = "Item Information";												
	};																						
	
	class Itemlist : RscListBox {										
		idc = 1;										
		x = 0.10; y = 0.10;																										
		w = 0.20; h = 0.70;														
	};																								
	
	class InfoText : RscText {										
		idc = 2;																								
		x = 0.35; y = 0.10;		   
		w = 0.55; h = 0.34;												
		style = ST_MULTI;												
		lineSpacing = 1;							
	};																												
	
	class InfoGewicht : RscText {																						
		idc = 3;								
		x = 0.66; y = 0.55;		   
		w = 0.25; h = 0.04;																				
		style = ST_RIGHT;										
	};																		
	
	class list_needed : RscListBox {										
		idc = 4;										
		x = 0.35; y = 0.45;																						
		w = 0.30; h = 0.35;						
	};																	
	
	class button_cancel : RscButton {																
		x = 0.40; y = 0.90;								
		w = 0.20; h = 0.04;														
		idc = 5;																						
		action = "closedialog 0;";			
	};						
	
	class dummybutton : RscDummy {idc = 1038;};
};
