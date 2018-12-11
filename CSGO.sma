#include <amxmodx>
#include <amxmisc>
#include <dhudmessage>
#include <colorchat>
#include <engine>

#define MAXPLAYER 33
#define MAXSKIN 26
#define MAXCHEST 7

new const PluginName[] = "Global Offensive";
new const PluginVersion[] = "1.0";
new const PluginAuthor[] = "Supra";

enum _:Data 
{
	sName[32],
	sModel[64],
	sRarity,
	sWeapon
}
enum _:WeaponData
{
	wWeapon = 0,
	wStatrak
};

new const WeaponName[] = { CSW_AK47, CSW_M4A1, CSW_AWP, CSW_FAMAS, CSW_GALIL, CSW_P90, CSW_SCOUT, CSW_MP5NAVY, CSW_M3, CSW_DEAGLE, CSW_GLOCK18, CSW_USP, CSW_KNIFE };
new const FegyverSkin[MAXSKIN][Data] =
{
	{ "1", "default/Ak47", 0, CSW_AK47 },
	{ "AK47 |", "", 1 , CSW_AK47 },
	
	{ "2", "default/M4a1", 0, CSW_M4A1 },
	{ "M4A1 |", "default/", 2, CSW_M4A1 },
	
	{ "3", "default/Awp", 0, CSW_AWP },
	{ "AWP |", "", 3, CSW_AWP },
	
	{ "4", "default/Deagle", 0, CSW_DEAGLE },
	{ "DEAGLE |", "", 4, CSW_DEAGLE },
	
	{ "5", "default/Famas", 0, CSW_FAMAS },
	{ "FAMAS |", "", 5, CSW_FAMAS },
	
	{ "6", "default/Mp5", 0, CSW_MP5NAVY },
	{ "MP5 |", "", 6, CSW_MP5NAVY },
	
	{ "7", "default/Galil", 0, CSW_GALIL },
	{ "GALIL |", "", 7, CSW_GALIL },
	
	{ "8", "default/P90", 0, CSW_P90 },
	{ "P90 |", "", 8, CSW_P90 },
	
	{ "9", "default/M3", 0, CSW_M3 },
	{ "M3 |", "", 9, CSW_M3 },
	
	{ "10", "default/Glock", 0, CSW_GLOCK18 },
	{ "GLOCK18 |", "", 10, CSW_GLOCK18 },
	
	{ "11", "default/Usp", 0, CSW_USP },
	{ "USP |", "", 11, CSW_USP },
	
	{ "12", "default/Scout", 0, CSW_SCOUT },
	{ "SCOUT |", "", 12, CSW_SCOUT },
	
	{ "13", "default/Knife.mdl", 0, CSW_KNIFE },
	{ "KNIFE |", "", 13, CSW_KNIFE }
};
new const ChestName[MAXCHEST][] =
{
	"Chroma",
	"Chroma II",
	"Chroma III",
	"Gamma",
	"Gamma II",
	"Falchion"
};
new const ChestDrops[][] =
{
	{ 10, 5 },
	{ 15, 15 },
	{ 32, 25 },
	{ 63, 55 },
	{ 85, 80 },
	{ 100, 100 }
};

new g_Skin[MAXPLAYER][MAXSKIN], g_StatTrak[MAXPLAYER][MAXSKIN], g_StatTrakKills[MAXPLAYER][MAXSKIN], g_Chest[MAXPLAYER][MAXCHEST], g_Keys[MAXPLAYER][MAXCHEST], g_Dollar[MAXPLAYER], g_Vip[MAXPLAYER], g_Name[32][33];
new g_Choose[MAXPLAYER][WeaponData][sizeof(WeaponName)], g_MenuMod[MAXPLAYER];
new sHud[MAXPLAYER];

public plugin_init()
{
	register_plugin(PluginName, PluginVersion, PluginAuthor);
	
	register_clcmd("say /add", "Addolas");
	register_impulse(201, "MainMenu");
	
	register_event("DeathMsg", "Halal", "a");
	//register_event("CurWeapon", "WeaponSwitch", "be", "1=1");
}
public Addolas(id)
{
	for(new i;i < sizeof(ChestName); i++)
	{
		g_Chest[id][i] += 100;
		g_Keys[id][i] += 100;
	}
}
public Halal()
{
	new id = read_data(1);
	new y = read_data(3); 
	
	if(id == read_data(2))
		return;

	new aDrop
	new userWeapon = get_user_weapon(id);
	new iSize = sizeof(WeaponName);
	for(new i;i < iSize; i++)
	{
		if(userWeapon == FegyverSkin[g_Choose[id][1][i]][sWeapon])
		{
			if(g_StatTrak[id][g_Choose[id][1][i]] >= 1 && g_Choose[id][1][i] == g_Choose[id][0][i])
			{
				g_StatTrakKills[id][g_Choose[id][1][i]] ++;
				sHud[id] = g_StatTrakKills[id][g_Choose[id][1][i]];
			}
		}
	}
	
	if(g_Vip[id] == 0)
	{
		if(y) aDrop = random_num(15, 25);
		else aDrop = random_num(10, 20);
	}
	else
	{
		if(y) aDrop = random_num(30, 40);
		else aDrop = random_num(15, 25);
	}
	
	g_Dollar[id] += aDrop;
	set_dhudmessage(random(255), random(255), random(255), -1.0, 0.15, 0, 6.0, 2.0);
	show_dhudmessage(id, "+ %d $", aDrop);
	
	if(random_num(1, 3) == 2) ChestDrop(id);
	else KeyDrop(id);
}
public ChestDrop(id)
{
	new aChance = random_num(0, 100);
	new i = random_num(0, 6);
	
	if(aChance <= ChestDrops[i][0])
	{
		g_Chest[id][i] ++;
		ColorChat(0, NORMAL, "^4* ^3%s ^1Talált egy ^4%s Case^1 -t!", g_Name[id], ChestName[i]);
	}
}
public KeyDrop(id)
{
	new aChance = random_num(0, 100);
	new i = random_num(0, 6);
	
	if(aChance <= ChestDrops[i][1])
	{
		g_Keys[id][i] ++;
		ColorChat(0, NORMAL, "^4* ^3%s ^1Talált egy ^4%s Keys^1 -t!", g_Name[id], ChestName[i]);
	}
}
public WeaponSwitch(id)
{
	sHud[id] = 0
	
	new userWeapon = get_user_weapon(id);
	new iSize = sizeof(WeaponName);
	for(new i;i < iSize; i++)
	{
		if(userWeapon == FegyverSkin[g_Choose[id][1][i]][sWeapon])
		{
			if(g_StatTrak[id][g_Choose[id][1][i]] >= 1 && g_Choose[id][1][i] == g_Choose[id][0][i])
				sHud[id] = g_StatTrakKills[id][g_Choose[id][1][i]];
		}
	}
}
public MainMenu(id)
{
	new String[128];
	formatex(String, charsmax(String), "\r[\dGlobal Offensive\r] \r| \r[\dFõmenü\r]^n\r[\dDollár: \y%d\r]", g_Dollar[id]);
	new Menu = menu_create(String, "MainMenu_h");
	
	menu_additem(Menu, "Felszerelés", "", 0);
	menu_additem(Menu, "Láda Nyitás", "", 0);
	menu_additem(Menu, "Piactér", "", 0);
	menu_additem(Menu, "Ujrahasznósitás", "", 0);
	menu_additem(Menu, "Beállitások\r/\wProfil", "", 0);
	
	menu_display(id, Menu, 0);
}
public MainMenu_h(id, Menu, Item)
{
	if(Item == MENU_EXIT)
	{
		menu_destroy(Menu);
		return;
	}
	
	new iData[32], iName[64];
	new Access, Callback;
	menu_item_getinfo(Menu, Item, Access, iData, charsmax(iData), iName, charsmax(iName), Callback);
	
	switch(Item)
	{
		case 0: Inventory(id);
		case 1: ChestMenu(id);
		case 2: MarketMenu(id);
	}
}
public Inventory(id)
{
	new String[128], StTString[121],Num[8];
	formatex(String, charsmax(String), "\r[\dGlobal Offensive\r] \r| \r[\dFelszerelés\r]");
	new Menu = menu_create(String, "Inventory_h");
	
	for(new i;i < MAXSKIN; i++)
	{
		if(g_Skin[id][i] > 0)
		{
			num_to_str(i, Num, charsmax(Num));
			formatex(StTString, charsmax(StTString), "\y(StatTrak)\r* \r(\d%d\r)", g_StatTrakKills[id][i]);
			formatex(String, charsmax(String), "%s \w%s \r(\d%d\r)", g_StatTrak[id][i] >= 1 ? StTString:"", FegyverSkin[i][sName], g_Skin[id][i]);
			menu_additem(Menu, String, Num);
		}
	}
	menu_display(id, Menu, 0);
}
public Inventory_h(id, Menu, Item)
{
	if(Item == MENU_EXIT)
	{
		menu_destroy(Menu);
		return;
	}
	
	new iData[32], iName[64];
	new Access, Callback;
	menu_item_getinfo(Menu, Item, Access, iData, charsmax(iData), iName, charsmax(iName), Callback);
	new Key = str_to_num(iData);
	
	new iSize = sizeof(WeaponName);
	for(new i;i < iSize; i++)
	{
		if(FegyverSkin[Key][sWeapon] == WeaponName[i])
		{
			g_Choose[id][0][i] = Key;
			
			if(g_StatTrak[id][Key] > 0)
				g_Choose[id][1][i] = Key;
		}
	}
	ColorChat(id, NORMAL, "^4* ^1Kiválasztottad ^4%s^1%s -t!", g_StatTrak[id][Key] >= 1 ? "(StatTrak)":"", FegyverSkin[Key][sName]);
}
public ChestMenu(id)
{
	new String[128],Num[8];
	formatex(String, charsmax(String), "\r[\dGlobal Offensive\r] \r| \r[\dLáda Nyitás\r]");
	new Menu = menu_create(String, "ChestMenu_h");
	
	for(new i;i < MAXCHEST; i++)
	{
		num_to_str(i, Num, charsmax(Num));
		formatex(String, charsmax(String), "%s Case \r[\d%d\r]", ChestName[i], g_Chest[id][i]);
		menu_additem(Menu, String, Num, 0);
	}
	
	menu_display(id, Menu, 0);
}
public ChestMenu_h(id, Menu, Item)
{
	if(Item == MENU_EXIT)
	{
		menu_destroy(Menu);
		return;
	}
	
	new iData[32], iName[64];
	new Access, Callback;
	menu_item_getinfo(Menu, Item, Access, iData, charsmax(iData), iName, charsmax(iName), Callback);
	new Key = str_to_num(iData);			
	
	ChestMenuMod(id)
	g_MenuMod[id] = Key;
}
public ChestMenuMod(id)
{
	new String[128];
	formatex(String, charsmax(String), "\r[\dGlobal Offensive\r] \r| \r[\dLáda Nyitás\r]");
	new Menu = menu_create(String, "ChestMenuMod_h");
	
	formatex(String, charsmax(String), "\wLáda: \r%s Case", ChestName[g_MenuMod[id]]);
	menu_additem(Menu, String, "0", 0);
	
	formatex(String, charsmax(String), "\wKulcs:\r%s Key^n^n", ChestName[g_MenuMod[id]]);
	menu_additem(Menu, String, "1", 0);
	
	formatex(String, charsmax(String), "\wLáda Nyitás^n\r[\d1 Láda és 1 Kulcs]");
	menu_additem(Menu, String, "2", 0);
	
	menu_display(id, Menu, 0);
}
public ChestMenuMod_h(id, Menu, Item)
{
	if(Item == MENU_EXIT)
	{
		menu_destroy(Menu);
		return;
	}
	
	new iData[32], iName[64];
	new Access, Callback;
	menu_item_getinfo(Menu, Item, Access, iData, charsmax(iData), iName, charsmax(iName), Callback);
	
	switch(Item)
	{
		case 0:ChestMenuMod(id);
		case 1:ChestMenuMod(id);
		case 2:
		{
			if(g_Chest[id][g_MenuMod[id]] >= 1 && g_Keys[id][g_MenuMod[id]] >= 1)
			{
				ChestOpen(id);
			}
			else 
			{
				if(g_Chest[id][g_MenuMod[id]] == 0 && g_Keys[id][g_MenuMod[id]] == 0)
					ColorChat(id, NORMAL, "^4*^1Nincs elég ^4%s Case^1-t se ^4%s Key^1-t!", ChestName[g_MenuMod[id]], ChestName[g_MenuMod[id]]);
				else if(g_Chest[id][g_MenuMod[id]] == 0)
					ColorChat(id, NORMAL, "^4* ^1Nincs elég ^4%s Case^1-t!", ChestName[g_MenuMod[id]]);
				else if(g_Keys[id][g_MenuMod[id]] == 0)
					ColorChat(id, NORMAL, "^4* ^1Nincs elég ^4%s Key^1-t!", ChestName[g_MenuMod[id]]);
			}
		}
	}
	ChestMenuMod(id);
}
public ChestOpen(id)
{
	new RandomCucc = random_num(1, 13);
	new Float:Random = random_float(0.0, 100.0);
	new StT = random_num(0, 20);
	new StTOpen;
	
	for(new i;i < MAXSKIN; i++)
	{
		if(RandomCucc <= FegyverSkin[i][sRarity] && Random <= 99.6)
		{
			g_Chest[id][g_MenuMod[id]] --;
			g_Keys[id][g_MenuMod[id]] --;
		
			if(StT >= 18)
			{
				g_StatTrak[id][i] ++;
				StTOpen = 1;
			}
		
			g_Skin[id][i] ++;
			ColorChat(0, NORMAL, "^4* ^3%s ^1Talált egy ^4%s^1%s -t! ^4%s Case^1 -ból!", g_Name[id], StTOpen > 0 ? "(StatTrak)":"", FegyverSkin[i][sName], ChestName[g_MenuMod[id]]);
			return PLUGIN_HANDLED;
		}
	}
	return PLUGIN_CONTINUE;
}
public MarketMenu(id)
{
	new 
}
public client_connect(id)
{
	g_Choose[id][0][0] = 0;
}
public client_putinserver(id)
{
	get_user_name(id, g_Name[id], charsmax(g_Name[]));
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
