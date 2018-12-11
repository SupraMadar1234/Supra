#include <amxmodx>
#include <amxmisc>
#include <dhudmessage>
#include <hamsandwich>
#include <cstrike>
#include <fakemeta>
#include <colorchat>
#include <engine>
#include <sqlx>

#define MAXPLAYER 33
#define MAXCHEST 6

new const PluginName[] = "OnlyDust2";
new const PluginVersion[] = "1.0";
new const PluginAuthor[] = "Supra";
new const Prefix[] = "Ultimate Only Dust2";
new const PREFIX[] = "[Ultiamte Only Dust2]";

new const SQL_HOSZT[] = "";
new const SQL_ADATBAZIS[] = "";
new const SQL_FELHASZNALO[] = "";
new const SQL_JELSZO[] = "";
new Handle:g_SqlTuple;

enum _:eData 
{
	sName[32],
	sModel[64],
	sRarity,
	sWeapon[8]
}
enum _:MarketData
{
	inMarket,
	itemMarket,
	MarketDollar
}

new const EntityNevek[][] = {
	"weapon_ak47", //28
	"weapon_m4a1", //22
	"weapon_awp", //18
	"weapon_famas", //15
	"weapon_mp5navy", //19
	"weapon_m3", //21
	"weapon_deagle", //26
	"weapon_usp", //16
	"weapon_knife" //29
}
new const FegyverSkin[][eData] =
{
	{ "", "", 0 ,0 },
	{ "AK47 | Frontside Misty", "ultimate/ak47/frontsidex", 1 , "28"},
	{ "AK47 | Beast Prime", "ultimate/ak47/beastprime", 2, "28" },
	{ "AK47 | Carbon", "ultimate/ak47/carbon", 3 , "28"},
	{ "AK47 | Paladon", "ultimate/ak47/paladin", 4 , "28"},
	{ "AK47 | Graffiti", "ultimate/ak47/graffiti", 5 , "28"},
	{ "AK47 | Shark", "ultimate/ak47/shark", 6 , "28"},
	{ "M4A1 | Colored", "ultimate/m4a1/colored", 7, "22"},
	{ "M4A1 | Hyper Beast", "ultimate/m4a1/hyperbeast", 8, "22"},
	{ "M4A1 | Cyrex", "ultimate/m4a1/cyrex", 9, "22"},
	{ "M4A1 | White Gold", "ultimate/m4a1/whitegold", 10, "22"},
	{ "M4A1 | Asiimov", "ultimate/m4a1/asiimov", 11, "22"},
	{ "AWP | Dragon Lore", "ultimate/awp/dragonlore", 12,  "18"},
	{ "AWP | White Tiger", "ultimate/awp/whitetiger", 13,  "18"},
	{ "AWP | Bluvy", "ultimate/awp/bluvy", 14,  "18"},
	{ "AWP | Graphite", "ultimate/awp/graphite", 15,  "18"},
	{ "AWP | Boom", "ultimate/awp/boom", 16,  "18"},
	{ "DEAGLE | Hypnotic", "ultimate/dealge/hypnotic", 17, "26"},
	{ "DEAGLE | Gold", "ultimate/dealge/gold", 18, "26"},
	{ "DEAGLE | Armoured Beast", "ultimate/dealge/armouredbeastx", 19, "26"},
	{ "DEAGLE | Black & Red", "ultimate/dealge/blakred", 20, "26"},
	{ "DEAGLE | Fire Gold", "ultimate/dealge/firegold", 21, "26"},
	{ "DEAGLE | Crimson Hunter", "ultimate/dealge/crimsonhunter", 22, "26"},
	{ "KARAMBIT | Autumn", "ultimate/knife/autumn", 23, "29"},
	{ "KARAMBIT | Crimson Web", "ultimate/knife/crimsonweb", 24, "29"},
	{ "KARAMBIT | Fade", "ultimate/knife/fade", 25, "29"},
	{ "M9BAYONET | Crimson Web", "ultimate/knife/m9crimsonweb", 26, "29"},
	{ "M9BAYONET | Slaughter", "ultimate/knife/m9slaughter", 27, "29"},
	{ "M9BAYONET | Gamma Doppler", "ultimate/knife/m9doppler", 28, "29"},
	{ "FLIP | Fire", "ultimate/knife/fire", 29, "29"},
	{ "BUTTERFLY | Fade", "ultimate/knife/fadev2", 30, "29"},
	{ "BAYONET | Boom", "ultimate/knife/boom", 31, "29"},
	{ "BAYONET | Echo Tek", "ultimate/knife/echotek", 32, "29"}
};
new const PiacCuccok[][] =
{
	"Válasz valamit!",
	"AK47 | Frontside Misty",
	"AK47 | Beast Prime",
	"AK47 | Carbon",
	"AK47 | Paladon",
	"AK47 | Graffiti",
	"AK47 | Shark",
	"M4A1 | Colored",
	"M4A1 | Hyper Beast",
	"M4A1 | Cyrex",
	"M4A1 | White Gold",
	"M4A1 | Asiimov",
	"AWP | Dragon Lore",
	"AWP | White Tiger",
	"AWP | Bluvy",
	"AWP | Graphite",
	"AWP | Boom",
	"DEAGLE | Hypnotic",
	"DEAGLE | Gold",
	"DEAGLE | Armoured Beast",
	"DEAGLE | Black & Red",
	"DEAGLE | Fire Gold",
	"DEAGLE | Crimson Hunter",
	"KARAMBIT | Autumn",
	"KARAMBIT | Crimson Web",
	"KARAMBIT | Fade",
	"M9BAYONET | Crimson Web",
	"M9BAYONET | Slaughter",
	"M9BAYONET | Gamma Doppler",
	"FLIP | Fire",
	"BUTTERFLY | Fade",
	"BAYONET | Boom",
	"BAYONET | Echo Tek"
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
	{ 25, 10 },
	{ 50, 20 },
	{ 100, 30 },
	{ 120, 40 },
	{ 170, 50 },
	{ 200, 60 }
};
new const FegyverIdSzamok[] ={
	0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 3, 1
}
new const LenStars[][] = {
	"",
	"*",
	"**",
	"***",
	"****",
	"*****",
	"******",
	"*******",
	"********",
	"*********",
	"**********",
	"***********",
	"************",
	"*************",
	"**************",
	"***************",
	"****************"
}

new g_Skin[MAXPLAYER][sizeof(FegyverSkin)], g_Chest[MAXPLAYER][MAXCHEST], g_Keys[MAXPLAYER], g_Dollar[MAXPLAYER], g_Vip[MAXPLAYER], g_Name[32][33];
new g_Choose[MAXPLAYER][4], g_Market[MAXPLAYER][MarketData];

new g_Felhasznalonev[33][100], g_Jelszo[33][100], g_Email[33][100], g_RegisztracioVagyBejelentkezes[33], g_Id[33],g_Folyamatban[33],bool:g_Bejelentkezve[33], bool:g_Mail[33], g_Jelszo1[33][100]

public plugin_init()
{
	register_plugin(PluginName, PluginVersion, PluginAuthor);
	
	for(new i;i < sizeof(EntityNevek); i++)
	{
		if(strlen(EntityNevek[i]) > 0)
			RegisterHam(Ham_Item_Deploy, EntityNevek[i], "WeaponSwitch", 1);
	}
	
	register_impulse(201, "MainMenu");
	
	register_clcmd("say /add", "Addolas");
	register_clcmd("PIAC", "cmdDollarMarket");
	
	register_clcmd("FELHASZNALONEV", "cmdFelhasznalonev")
	register_clcmd("JELSZAVAD", "cmdJelszo")
	register_clcmd("JELSZAVAD_UJRA", "cmdJelszo1")
	register_clcmd("EMAIL", "cmdEmail")
	
	register_event("DeathMsg", "Halal", "a");
}
public plugin_precache()
{
	for(new i;i < sizeof(FegyverSkin); i++)
	{
		if(strlen(FegyverSkin[i][sModel]) == 0)
			continue;
			
		new TextModel[64];
		formatex(TextModel, charsmax(TextModel), "models/%s.mdl", FegyverSkin[i][sModel]);
		precache_model(TextModel);
	}
}
public Addolas(id)
{
	if(get_user_flags(id) & ADMIN_IMMUNITY)
	{
		for(new i;i < sizeof(ChestName); i++)
		{
			g_Chest[id][i] += 100;
			g_Keys[id] += 100;
		}
		g_Dollar[id] += 12312;
	}
}
public Halal()
{
	new id = read_data(1);
	new y = read_data(3); 
	
	if(id == read_data(2) || !g_Bejelentkezve[id] == true)
		return;

	new aDrop, hDrop = random_num(0, 100);
	
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
	
	ChestDrop(id);
	
	if(hDrop >= 50)
	{
		g_Keys[id] ++;
		ColorChat(0, NORMAL, "^4[%s] ^3%s ^1^1Talált egy: ^4Kulcsot!", Prefix, g_Name[id]);
	}
}
public ChestDrop(id)
{
	new aChance = random_num(0, 200);
	new i = random_num(0, 6);
	
	if(aChance <= ChestDrops[i][0])
	{
		g_Chest[id][i] ++;
		ColorChat(0, NORMAL, "^4[%s] ^3%s ^1Talált egy: ^4%s ládát^1 -t!", Prefix, g_Name[id], ChestName[i]);
	}
}
public WeaponSwitch(x)
{
	new id = get_pdata_cbase(x, 41, 4);
	new wid = cs_get_weapon_id(x);
	
	if(id > 32 || id < 1 || !is_user_alive(id))
	{
		return HAM_SUPERCEDE;
	}
	
	new i = g_Choose[id][FegyverIdSzamok[wid]], TextModel[86];
	if(i > 0 && str_to_num(FegyverSkin[i][sWeapon]) == wid)
	{
		formatex(TextModel, charsmax(TextModel), "models/%s.mdl", FegyverSkin[i][sModel]);
		set_pev(id, pev_viewmodel2, TextModel);
	}
	return HAM_IGNORED;
}

public cmdJelszo(id)
{
	if(g_Bejelentkezve[id] == true)
		return PLUGIN_HANDLED
	
	g_Jelszo[id][0] = EOS
	read_args(g_Jelszo[id], 99)
	remove_quotes(g_Jelszo[id])
	
	if((strlen(g_Jelszo[id]) < 4) || (strlen(g_Jelszo[id]) > 16))
	{
		ColorChat(id, GREEN, "^4%s^1 A jelszavad nem lehet rövidebb 4, illetve hosszabb 16 karakternél!", PREFIX)
		g_Jelszo[id][0] = EOS
	}
	
	showMenu_RegLog(id)
	return PLUGIN_HANDLED
}
public cmdJelszo1(id)
{
	if(g_Bejelentkezve[id] == true)
		return PLUGIN_HANDLED
	
	g_Jelszo1[id][0] = EOS
	read_args(g_Jelszo1[id], 99)
	remove_quotes(g_Jelszo1[id])
	
	if((strlen(g_Jelszo1[id]) < 4) || (strlen(g_Jelszo1[id]) > 16))
	{
		ColorChat(id, GREEN, "^4%s^1 A jelszavad nem lehet rövidebb 4, illetve hosszabb 16 karakternél!", PREFIX)
		g_Jelszo1[id][0] = EOS
	}
	
	showMenu_RegLog(id)
	return PLUGIN_HANDLED
}
public cmdFelhasznalonev(id)
{
	if(g_Bejelentkezve[id])
		return PLUGIN_HANDLED
	
	g_Felhasznalonev[id][0] = EOS
	read_args(g_Felhasznalonev[id], 99)
	remove_quotes(g_Felhasznalonev[id])
	
	if(contain(g_Felhasznalonev[id], " ") != -1)
	{
		ColorChat(id, GREEN, "^4%s^1 A ^3Felhasználónevedben ^1nem használhatsz szóközt!", PREFIX)
		g_Felhasznalonev[id][0] = EOS
		return PLUGIN_HANDLED
	}
	
	if((strlen(g_Felhasznalonev[id]) < 2) || (strlen(g_Felhasznalonev[id]) > 20))
	{
		ColorChat(id, GREEN, "^4%s^1 A ^3Felhasználóneved ^1nem lehet rövidebb 2, illetve hosszabb 20 karakternél!", PREFIX)
		g_Felhasznalonev[id][0] = EOS
		return PLUGIN_HANDLED
	}
	
	if(g_Mail[id]) showMenu_GotBackPass(id)
	else showMenu_RegLog(id)
	return PLUGIN_HANDLED
}
public cmdEmail(id)
{
	if(g_Bejelentkezve[id])
		return PLUGIN_HANDLED

	g_Email[id][0] = EOS
	read_args(g_Email[id], 99)
	remove_quotes(g_Email[id])
	
	if(contain(g_Email[id], ".hu") != -1
	|| contain(g_Email[id], ".com") != -1
	|| contain(g_Email[id], ".ro") != -1 
	|| contain(g_Email[id], ".cz") != -1
	|| contain(g_Email[id], ".de") != -1 
	|| contain(g_Email[id], ".pl") != -1 
	|| contain(g_Email[id], ".eu") != -1 
	|| contain(g_Email[id], ".lt") != -1)
	{
		if(contain(g_Email[id], "@") != -1)
		{
			new const VP[] = "\"
			
			if(contain(g_Email[id], VP) != -1
			|| contain(g_Email[id], "'") != -1)
			{
				ColorChat(id, GREEN, "^4%s^1 Hibás ^3E-Mail^1 formátum!", PREFIX)
				g_Email[id][0] = EOS
			}
			else {
				if(g_Mail[id]) showMenu_GotBackPass(id)
				else showMenu_RegLog(id)
			}
		}
		else
		{
			ColorChat(id, GREEN, "^4%s^1 Hibás ^3E-Mail^1 formátum!", PREFIX)
			g_Email[id][0] = EOS
		}
		
	}
	else
	{
		ColorChat(id, GREEN, "^4%s^1 Hibás ^3E-Mail^1 formátum!", PREFIX)
		g_Email[id][0] = EOS
	}
	
	if(g_Mail[id]) showMenu_GotBackPass(id)
	else showMenu_RegLog(id)
	return PLUGIN_HANDLED
}
public cmdRegisztracioBejelentkezes(id)
{
	if(g_Bejelentkezve[id] == true)
		return PLUGIN_HANDLED
		
	if((strlen(g_Felhasznalonev[id]) == 0))
	{
		ColorChat(id, GREEN, "^4%s^1 Nem adtál meg felhasználónevet!", PREFIX)
		showMenu_RegLog(id)
		return PLUGIN_HANDLED
	}
	
	if((strlen(g_Jelszo[id]) == 0))
	{
		ColorChat(id, GREEN, "^4%s^1 Nem adtál meg jelszót!", PREFIX)
		showMenu_RegLog(id)
		return PLUGIN_HANDLED
	}

	if(g_RegisztracioVagyBejelentkezes[id] == 1)
	{
		if(!equali(g_Jelszo[id], g_Jelszo1[id]))
		{
			ColorChat(id, GREEN, "^4%s^1 A megadott két jelszó nem egyezik!", PREFIX)
			showMenu_RegLog(id)
			return PLUGIN_HANDLED
		}
	}
	
	switch(g_RegisztracioVagyBejelentkezes[id])
	{
		case 1:
		{
			if(g_Folyamatban[id] == 0)
			{
				ColorChat(id, GREEN, "^4%s^1 A Regisztráció folyamatban... Kérlek várj!", PREFIX)
				sql_account_check(id)
				showMenu_RegLog(id)
				g_Folyamatban[id] = 1
			}
			else showMenu_RegLog(id)
		}
		case 2:
		{
			if(g_Folyamatban[id] == 0)
			{
				ColorChat(id, GREEN, "^4%s^1 A Bejelentkezés folyamatban... Kérlek várj!", PREFIX)
				sql_account_check(id)
				showMenu_RegLog(id)
				g_Folyamatban[id] = 1
			}
			else showMenu_RegLog(id)
		}
	}
	
	return PLUGIN_CONTINUE
}
public showMenu_Main(id){	
	new menu = menu_create("\w[Ultiamte Only Dust2] \yRegisztrálj vagy Jelentkezz be!", "menu_rego");

	menu_additem(menu, "Regisztráció", "0", 0);
	menu_additem(menu, "Bejelentkezés^n", "1", 0);
	menu_additem(menu, "\rElfelejtettem a jelszavam!", "2", 0);

	menu_display(id, menu, 0);
	return PLUGIN_HANDLED;
}
public menu_rego(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_CONTINUE;
	}

	switch(item)
	{
		case 0:
		{
			g_RegisztracioVagyBejelentkezes[id] = 1
			g_Mail[id] = false
			showMenu_RegLog(id)
		}
		case 1:
		{
			g_RegisztracioVagyBejelentkezes[id] = 2
			g_Mail[id] = false
			showMenu_RegLog(id)
		}
		case 2:
		{
			g_Email[id][0] = EOS
			g_Mail[id] = true
			showMenu_GotBackPass(id)
		}
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public showMenu_GotBackPass(id)
{
	new szMenu[121]
	format(szMenu, charsmax(szMenu), "\w[Ultiamte Only Dust2] \yJelszó visszaszerzés")
	new menu = menu_create(szMenu, "menu_backpass");
	
	formatex(szMenu, charsmax(szMenu), "E-Mail:\d %s^n^n", g_Email[id][0] == EOS ? "Nincs megadva" : g_Email[id])
	menu_additem(menu, szMenu, "0", 0);
	
	menu_additem(menu, "\rKérem a jelszavam!", "1", 0);

	menu_display(id, menu, 0);
	return PLUGIN_HANDLED;
}
public menu_backpass(id, menu, item)
{	
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_CONTINUE;
	}
	
	switch(item)
	{
		case 0:
		{
			client_cmd(id, "messagemode EMAIL")
			showMenu_GotBackPass(id)
		}
		case 1: sql_gotpass_check(id)
	}
	return PLUGIN_HANDLED;
}
public sql_gotpass_check(id)
{
	new szQuery[2048]
	new len = 0
	new a[191]
	
	if((strlen(g_Email[id]) == 0))
	{
		ColorChat(id, GREEN, "^4%s^1 Nem adtál meg E-Mailt!", PREFIX)
		showMenu_GotBackPass(id)
		return PLUGIN_HANDLED
	}
	
	format(a, 190, "%s", g_Email[id])

	replace_all(a, 190, "\", "\\")
	replace_all(a, 190, "'", "\'") 
	
	len += format(szQuery[len], 2048, "SELECT * FROM onlydust ")
	len += format(szQuery[len], 2048-len,"WHERE Email = '%s'", a)
	
	new szData[2];
	szData[0] = id;
	szData[1] = get_user_userid(id);

	SQL_ThreadQuery(g_SqlTuple,"sql_gotpass_check_thread", szQuery, szData, 2)
	
	return PLUGIN_CONTINUE;
}

public sql_gotpass_check_thread(FailState,Handle:Query,Error[],Errcode,szData[],DataSize)
{
	if(FailState == TQUERY_CONNECT_FAILED || FailState == TQUERY_QUERY_FAILED)
	{
		log_amx("%s", Error)
		return
	}
	else
	{
		new id = szData[0];
		
		if (szData[1] != get_user_userid(id))
			return;
		
		new iRowsFound = SQL_NumRows(Query)
		
		if(iRowsFound == 0)
		{
			ColorChat(id, GREEN, "^4%s^1 Nem található ilyen ^3E-Mail ^1cím!", PREFIX)
			showMenu_GotBackPass(id)
		}
		else 
		{	
			new szSqlPass[100]
			SQL_ReadResult(Query, 2, szSqlPass, 99)
			
			ColorChat(id, GREEN, "^4%s^1 Ehez az ^3E-Mail ^1címhez tartozó jelszó:^3 %s",PREFIX, szSqlPass)
			showMenu_Main(id)
		}
	}
}
public showMenu_RegLog(id)
{
	new szMenu[121]
	format(szMenu, charsmax(szMenu), "\w[Ultiamte Only Dust2] \yRegisztrálj vagy Jelentkezz be!")
	new menu = menu_create(szMenu, "menu_reglog");
	
	formatex(szMenu, charsmax(szMenu), "\yFelhasználónév:\w %s", g_Felhasznalonev[id][0] == EOS ? "Nincs megadva \r*" : g_Felhasznalonev[id])
	menu_additem(menu, szMenu, "0", 0);
	formatex(szMenu, charsmax(szMenu), "\yJelszó:\w %s%s", g_Jelszo[id][0] == EOS ? "Nincs megadva \r*" : LenStars[strlen(g_Jelszo[id])], g_RegisztracioVagyBejelentkezes[id] == 2 ? "^n" : "")
	menu_additem(menu, szMenu, "1", 0);
	if(g_RegisztracioVagyBejelentkezes[id] == 1 ){
		formatex(szMenu, charsmax(szMenu), "\yJelszó Újra:\w %s", g_Jelszo1[id][0] == EOS ? "Nincs megadva \r*" : LenStars[strlen(g_Jelszo1[id])])
		menu_additem(menu, szMenu, "2", 0);
		formatex(szMenu, charsmax(szMenu), "\yE-Mail:\w %s^n^n", g_Email[id][0] == EOS ? "Nincs megadva" : g_Email[id])
		menu_additem(menu, szMenu, "3", 0);
	}
	
	if(g_RegisztracioVagyBejelentkezes[id] == 1 ) menu_additem(menu, "\rRegisztráció", "4", 0);
	else menu_additem(menu, "\rBejelentkezés", "4", 0);

	menu_display(id, menu, 0);
	return PLUGIN_HANDLED;
}
public menu_reglog(id, menu, item)
{	
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_CONTINUE;
	}
		
	new data[9], szName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
	
	switch(key)
	{
		case 0:
		{
			client_cmd(id, "messagemode FELHASZNALONEV")
			showMenu_RegLog(id)
		}
		case 1:
		{
			client_cmd(id, "messagemode JELSZAVAD")
			showMenu_RegLog(id)
		}
		case 2:
		{
			client_cmd(id, "messagemode JELSZAVAD_UJRA")
			showMenu_RegLog(id)
		}
		case 3:
		{
			client_cmd(id, "messagemode EMAIL")
			showMenu_RegLog(id)
		}
		case 4: cmdRegisztracioBejelentkezes(id) 
	}
	return PLUGIN_HANDLED;
}
public MainMenu(id)
{
	if(!g_Bejelentkezve[id]) 
	{
		showMenu_Main(id);
		return;
	}
	
	new String[128];
	formatex(String, charsmax(String), "\r[\dUltiamte Only Dust2\r] \d| \r[\dFõmenü\r]^n\r[\dDollár: \y%d\r]", g_Dollar[id]);
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
		case 3: DeleteSkins(id);
		case 4: Options(id);
	}
}
public Options(id)
{
	new szMenu[128];
	formatex(szMenu, charsmax(szMenu), "\r[\dUltiamte Only Dust2\r] \d| \r[\dBeállitások\r]");
	new Menu = menu_create(szMenu, "Optionh");
	
	formatex(szMenu, charsmax(szMenu), "Felhasználónév: \r%s \d(ID: #%d)", g_Felhasznalonev[id], g_Id[id]);
	menu_additem(Menu, szMenu, "0", 0);
	formatex(szMenu, charsmax(szMenu), "Jelszó: \r%s", g_Jelszo[id]);
	menu_additem(Menu, szMenu, "1", 0);
	formatex(szMenu, charsmax(szMenu), "E-Mail: \r%s^n", g_Email[id][0] == EOS ? "Nincs megadva" : g_Email[id]);
	menu_additem(Menu, szMenu, "2", 0);
	
	menu_display(id, Menu, 0);
}
public Optionh(id, Menu, Item)
{
	if(Item == MENU_EXIT)
	{
		menu_destroy(Menu);
		return;
	}
	
	new iData[32], iName[64];
	new Access, Callback;
	menu_item_getinfo(Menu, Item, Access, iData, charsmax(iData), iName, charsmax(iName), Callback);
	
	Options(id);
}
public Inventory(id)
{
	new String[128],Num[8];
	formatex(String, charsmax(String), "\r[\dUltimate Only Dust2\r] \d| \r[\dFelszerelés\r]");
	new Menu = menu_create(String, "Inventory_h");
	
	new Size = sizeof(FegyverSkin);
	for(new i=1;i < Size; i++)
	{
		if(g_Skin[id][i] > 0)
		{
			num_to_str(i, Num, charsmax(Num));
			formatex(String, charsmax(String), "%s \r[\d%d\r]", FegyverSkin[i][sName], g_Skin[id][i]);
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
	
	new y = str_to_num(FegyverSkin[Key][sWeapon]);
	log_amx("%d", y);
	g_Choose[id][FegyverIdSzamok[y]] = Key;
	
	ColorChat(id, NORMAL, "^4[%s] ^1Kiválasztottad a ^4%s ^1-t!", Prefix, FegyverSkin[Key][sName]);
}
public DeleteSkins(id)
{
	new String[128],Num[8];
	formatex(String, charsmax(String), "\r[\dUltimate Only Dust2\r] \d| \r[\dUjrahasznósitás\r]");
	new Menu = menu_create(String, "DeleteSkins_h");
	
	new Size = sizeof(FegyverSkin);
	for(new i=1;i < Size; i++)
	{
		if(g_Skin[id][i] > 0)
		{
			num_to_str(i, Num, charsmax(Num));
			formatex(String, charsmax(String), "%s \r[\d%d\r]", FegyverSkin[i][sName], g_Skin[id][i]);
			menu_additem(Menu, String, Num);
		}
	}
	menu_display(id, Menu, 0);
}
public DeleteSkins_h(id, Menu, Item)
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
	new Random = random_num(10, 20);
	
	g_Skin[id][Key] --;
	g_Dollar[id] += Random;
	DeleteSkins(id);
	ColorChat(id, NORMAL, "^4[%s] ^1Ujrahasznósitottad a ^4%s ^1és kaptál ^4%d ^1dollárt", Prefix, FegyverSkin[Key][sName], Random);
}
public ChestMenu(id)
{
	new String[128],Num[8];
	formatex(String, charsmax(String), "\r[\dUltimate Only Dust2\r] \d| \r[\dLáda Nyitás\r]^n\r[\dKulcs: \y%d\r]", g_Keys[id]);
	new Menu = menu_create(String, "ChestMenu_h");
	
	for(new i;i < MAXCHEST; i++)
	{
		num_to_str(i, Num, charsmax(Num));
		formatex(String, charsmax(String), "%s Case \r[\d%d\r]", ChestName[i], g_Chest[id][i]);
		menu_additem(Menu, String, Num);
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
	
	if(g_Chest[id][Key] >= 1 && g_Keys[id] >= 1)
	{
		ChestOpen(id);
		g_Chest[id][Key] --;
		g_Keys[id] --;
	}
	else 
	{
		if(g_Chest[id][Key] == 0 && g_Keys[id] == 0)
			ColorChat(id, NORMAL, "^4[%s]^1Nincs elég ^4%s ládá ^1-t! se ^4Kulcs ^1-ot!", Prefix, ChestName[Key]);
		else if(g_Chest[id][Key] == 0)
			ColorChat(id, NORMAL, "^4[%s] ^1Nincs elég ^4%s ládá ^1-t!", Prefix, ChestName[Key]);
		else if(g_Keys[id] == 0)
			ColorChat(id, NORMAL, "^4[%s] ^1Nincs elég ^4Kulcsot!", Prefix);
	}
	ChestMenu(id);
}

public ChestOpen(id)
{
	new RandomCucc = random_num(1, 32);
	new Float:Random = random_float(0.0, 100.0);
	
	new Size = sizeof(FegyverSkin);
	for(new i=1;i < Size; i++)
	{
		if(RandomCucc <= FegyverSkin[i][sRarity] && Random <= 99.6)
		{
			g_Skin[id][i] ++;
			ColorChat(0, NORMAL, "^4[%s] ^3%s ^1Talált egy ^4%s -t!", Prefix, g_Name[id], FegyverSkin[i][sName]);
			return PLUGIN_HANDLED;
		}
	}
	return PLUGIN_CONTINUE;
}
public MarketMenu(id)
{
	new String[128];
	formatex(String, charsmax(String), "\r[\dUltimate Only Dust2\r] \d| \r[\dPiactér\r]^n\r[\dDollár: \y%d\r]", g_Dollar[id]);
	new Menu = menu_create(String, "MarketMenu_h");
	
	menu_additem(Menu, "Eladás", "0", 0);
	menu_additem(Menu, "Vásárlás", "1", 0);
	
	menu_display(id, Menu, 0);
}
public MarketMenu_h(id, Menu, Item)
{
	if(Item == MENU_EXIT)
	{
		menu_destroy(Menu);
		return;
	}
	
	new iData[32], iName[64];
	new Access, Callback;
	menu_item_getinfo(Menu, Item, Access, iData, charsmax(iData), iName, charsmax(iName), Callback);
	new i = str_to_num(iData);	

	switch(i)
	{
		case 0: SellMenu(id);
		case 1: BuyMenu(id);
	}
}
public SellMenu(id)
{
	new String[128];
	formatex(String, charsmax(String), "\r[\dUltimate Only Dust2\r] \d| \r[\dEladás Menü\r]^n\r[\dDollár: \y%d\r]", g_Dollar[id]);
	new Menu = menu_create(String, "SellMenu_h");
	
	if(g_Market[id][MarketDollar] != 0 && g_Market[id][inMarket] == 1)
	{
		formatex(String, charsmax(String), "Targy:\d%s \y(%d $) \rVisszavonás!", FegyverSkin[g_Market[id][itemMarket]][sName], g_Market[id][MarketDollar]);
		menu_additem(Menu, String, "-1");
	}
	if(g_Market[id][inMarket] == 0)
	{
		formatex(String, charsmax(String), "Tárgy Név:\w%s", PiacCuccok[g_Market[id][itemMarket]]);
		menu_additem(Menu, String, "0", 0);
		
		formatex(String, charsmax(String), "Ár: \y%d", g_Market[id][MarketDollar]);
		menu_additem(Menu, String, "1", 0);
		
		if(g_Market[id][itemMarket] > 0 && g_Market[id][itemMarket] < 50 && g_Market[id][MarketDollar] > 0 && g_Skin[id][g_Market[id][itemMarket]] > 0)
			menu_additem(Menu, "\yKirakás\r!", "2", 0);
	}
	
	menu_display(id, Menu, 0);
}
public SellMenu_h(id, Menu, Item)
{
	if(Item == MENU_EXIT)
	{
		menu_destroy(Menu);
		return;
	}
	
	new iData[32], iName[64];
	new Access, Callback;
	menu_item_getinfo(Menu, Item, Access, iData, charsmax(iData), iName, charsmax(iName), Callback);
	new i = str_to_num(iData);
	
	switch(i)
	{
		case -1:
		{
			g_Market[id][inMarket] = 0;
			g_Market[id][itemMarket] = 0;
			g_Market[id][MarketDollar] = 0;
		}
		case 0: OpenSkinMenu(id);
		case 1: client_cmd(id, "messagemode PIAC");
		case 2:
		{
			g_Market[id][inMarket] = 1;
			SellMenu(id);
			ColorChat(0, NORMAL, "^4[%s] ^3%s ^1kirakott egy ^4%s ^1tárgyat a piacra ^4%d ^1dollárért!", Prefix, g_Name[id], FegyverSkin[g_Market[id][itemMarket]][sName],g_Market[id][MarketDollar]);
		}
	}
}
public BuyMenu(id)
{
	new String[128], Num[10];
	formatex(String, charsmax(String), "\r[\dUltimate Only Dust2\r] \d| \r[\dVásárlás Menü\r]^n\r[\dDollár: \y%d\r]", g_Dollar[id]);
	new Menu = menu_create(String, "BuyMenu_h");
	
	new players[32], pnum
	get_players(players, pnum, "c")
	
	for(new y;y < pnum; y++)
	{
		if(g_Market[players[y]][inMarket] == 1 && g_Market[players[y]][MarketDollar] > 0 && g_Market[players[y]][itemMarket] < 50)
		{
			num_to_str(players[y], Num, charsmax(Num));
			formatex(String, charsmax(String), "\y%s \w(Eladó: \r%s \d| \wÁra: \r%d\w)", FegyverSkin[g_Market[players[y]][itemMarket]][sName], g_Name[players[y]], g_Market[players[y]][MarketDollar]);
			menu_additem(Menu, String, Num);
		}
	}
	
	menu_display(id, Menu, 0);
}
public BuyMenu_h(id, Menu, Item)
{
	if(Item == MENU_EXIT)
	{
		menu_destroy(Menu);
		return;
	}
	
	new iData[32], iName[64];
	new Access, Callback;
	menu_item_getinfo(Menu, Item, Access, iData, charsmax(iData), iName, charsmax(iName), Callback);
	new userId = str_to_num(iData);
	
	if(g_Market[userId][inMarket] > 0)
	{
		if(g_Dollar[id] >= g_Market[userId][MarketDollar])
		{
			g_Skin[userId][g_Market[userId][itemMarket]] --;
			g_Skin[id][g_Market[userId][itemMarket]] ++;
			
			g_Dollar[userId] -= g_Market[userId][MarketDollar];
			g_Dollar[id] += g_Market[userId][MarketDollar];
		
			g_Market[userId][inMarket] = 0;	
			g_Market[userId][itemMarket] = 0;
			g_Market[userId][MarketDollar] = 0;
			ColorChat(0, NORMAL, "^4[%s] ^3%s ^1vett egy ^4%s ^1fegyvert! ^3%s ^1-tól! ^4%d ^1dollárért!", Prefix, g_Name[id], FegyverSkin[g_Market[userId][itemMarket]][sName], g_Name[userId], g_Market[userId][MarketDollar]);
		}
		else
		{
			ColorChat(id, NORMAL, "^4[%s] ^1Nincs elég dollárod!", Prefix);
			BuyMenu(id);
		}
	}
}
public OpenSkinMenu(id)
{
	new String[128],Num[8];
	formatex(String, charsmax(String), "\r[\dUltimate Only Dust2\r] \d| \r[\dFelszerelés\r]");
	new Menu = menu_create(String, "OpenSkinMenu_h");
	
	new Size = sizeof(FegyverSkin);
	for(new i=1;i < Size; i++)
	{
		if(g_Skin[id][i] > 0)
		{
			num_to_str(i, Num, charsmax(Num));
			formatex(String, charsmax(String), "%s \r[\d%d\r]", FegyverSkin[i][sName], g_Skin[id][i]);
			menu_additem(Menu, String, Num);
		}
	}
	menu_display(id, Menu, 0);
}
public OpenSkinMenu_h(id, Menu, Item)
{
	if(Item == MENU_EXIT)
	{
		menu_destroy(Menu);
		return;
	}
	
	new iData[32], iName[64];
	new Access, Callback;
	menu_item_getinfo(Menu, Item, Access, iData, charsmax(iData), iName, charsmax(iName), Callback);
	
	g_Market[id][itemMarket] = str_to_num(iData);
	SellMenu(id);
}
public cmdDollarMarket(id)
{
	new Ertek, iData[32];
	read_args(iData, charsmax(iData));
	remove_quotes(iData);
	
	Ertek = str_to_num(iData);
	
	if(Ertek <= 50)
	{
		SellMenu(id);
		client_cmd(id, "messagemode PIAC");
		ColorChat(id, NORMAL, "^4[%s] ^1Minimum kirakási ár:^4 50", Prefix);
	}
	else if(100000 >= Ertek)
	{
		g_Market[id][MarketDollar] = Ertek;
		SellMenu(id);
	}
	else
	{
		SellMenu(id);
		client_cmd(id, "messagemode PIAC");
		ColorChat(id, NORMAL, "^4[%s] ^1Maximum kirakási ár::^4 1000000", Prefix);
	}	
}
public plugin_cfg() {
	g_SqlTuple = SQL_MakeDbTuple(SQL_HOSZT, SQL_FELHASZNALO, SQL_JELSZO, SQL_ADATBAZIS);
}
public sql_account_check(id)
{
	new szQuery[2048]
	new len = 0
	
	new a[191]
	
	format(a, 190, "%s", g_Felhasznalonev[id])

	replace_all(a, 190, "\", "\\")
	replace_all(a, 190, "'", "\'") 
	
	len += format(szQuery[len], 2048, "SELECT * FROM onlydust ")
	len += format(szQuery[len], 2048-len,"WHERE Felhasznalonev = '%s'", a)
	
	new szData[2];
	szData[0] = id;
	szData[1] = get_user_userid(id);

	SQL_ThreadQuery(g_SqlTuple,"sql_account_check_thread", szQuery, szData, 2)
}

public sql_account_check_thread(FailState,Handle:Query,Error[],Errcode,szData[],DataSize)
{
	if(FailState == TQUERY_CONNECT_FAILED)
	{
		set_fail_state("[ *HIBA* ] NEM LEHET KAPCSOLODNI AZ ADATBAZISHOZ!")
		return 
	}
	else if(FailState == TQUERY_QUERY_FAILED)
	{
		set_fail_state("[ *HIBA* ] A LEKERDEZES MEGSZAKADT!")
		return 
	}
	
	if(Errcode)
	{
		log_amx("[ *HIBA* ] PROBLEMA A LEKERDEZESNEL! ( %s )",Error)
		return 
	}
	
	new id = szData[0];
	
	if (szData[1] != get_user_userid(id))
		return;
	
	new iRowsFound = SQL_NumRows(Query)
	
	if(g_RegisztracioVagyBejelentkezes[id] == 1)
	{	
		if(iRowsFound > 0)
		{
			ColorChat(id, GREEN, "^4%s^1 Ezzel a Felhasználónévvel már Regisztráltak!", PREFIX)
			g_Folyamatban[id] = 0
			showMenu_RegLog(id)
		}
		else sql_account_create(id)
	}
	else if(g_RegisztracioVagyBejelentkezes[id] == 2)
	{	
		if(iRowsFound == 0)
		{
			ColorChat(id, GREEN, "^4%s^1 Hibás ^3Felhasználónév^1 vagy ^3Jelszó^1!", PREFIX)
			g_Folyamatban[id] = 0
			showMenu_RegLog(id)
		}
		else sql_account_load(id)
	}
}

public sql_account_create(id)
{
	new szQuery[2048]
	new len = 0
	
	new a[191], b[191], c[191]
	
	format(a, 190, "%s", g_Felhasznalonev[id])
	format(b, 190, "%s", g_Jelszo[id])
	format(c, 190, "%s", g_Email[id])

	replace_all(a, 190, "\", "\\")
	replace_all(a, 190, "'", "\'") 
	replace_all(b, 190, "\", "\\")
	replace_all(b, 190, "'", "\'") 
	replace_all(c, 190, "\", "\\")
	replace_all(c, 190, "'", "\'") 
	 
	len += format(szQuery[len], 2048, "INSERT INTO onlydust ")
	len += format(szQuery[len], 2048-len,"(Felhasznalonev,Jelszo,Email) VALUES('%s','%s','%s')", a, b, c)
	
	new szData[2];
	szData[0] = id;
	szData[1] = get_user_userid(id);

	SQL_ThreadQuery(g_SqlTuple,"sql_account_create_thread", szQuery, szData, 2)
}

public sql_account_create_thread(FailState,Handle:Query,Error[],Errcode,szData[],DataSize)
{
	if(FailState == TQUERY_CONNECT_FAILED)
	{
		set_fail_state("[ *HIBA* ] NEM LEHET KAPCSOLODNI AZ ADATBAZISHOZ!")
		return 
	}
	else if(FailState == TQUERY_QUERY_FAILED)
	{
		set_fail_state("[ *HIBA* ] A LEKERDEZES MEGSZAKADT!")
		return 
	}
	
	if(Errcode)
	{
		log_amx("[ *HIBA* ] PROBLEMA A LEKERDEZESNEL! ( %s )",Error)
		return 
	}
		
	new id = szData[0];
	
	if (szData[1] != get_user_userid(id))
		return;
	
	if(g_Email[id][0] == EOS) ColorChat(id, GREEN, "^4%s^1 Sikeresen regisztráltál! Felhasználónév:^3 %s^1 | Jelszó:^3 %s", PREFIX, g_Felhasznalonev[id], g_Jelszo[id])
	else ColorChat(id, GREEN, "^4%s^1 Sikeresen regisztráltál! Felhasználónév:^3 %s^1 | Jelszó:^3 %s^1 | E-Mail:^3 %s", PREFIX, g_Felhasznalonev[id], g_Jelszo[id], g_Email[id])
	g_Folyamatban[id] = 0
	g_RegisztracioVagyBejelentkezes[id] = 2
	showMenu_RegLog(id)
	return
}

public sql_account_load(id)
{
	new szQuery[2048]
	new len = 0
	
	new a[191]
	
	format(a, 190, "%s", g_Felhasznalonev[id])

	replace_all(a, 190, "\", "\\")
	replace_all(a, 190, "'", "\'") 
	
	len += format(szQuery[len], 2048, "SELECT * FROM onlydust ")
	len += format(szQuery[len], 2048-len,"WHERE Felhasznalonev = '%s'", a)
	
	new szData[2];
	szData[0] = id;
	szData[1] = get_user_userid(id);

	SQL_ThreadQuery(g_SqlTuple,"sql_account_load_thread", szQuery, szData, 2)
}
public sql_account_load_thread(FailState,Handle:Query,Error[],Errcode,szData[],DataSize) {
	if(FailState == TQUERY_CONNECT_FAILED || FailState == TQUERY_QUERY_FAILED)
	{
		log_amx("%s", Error)
		return
	}
	else
	{
		new id = szData[0];
		
		if (szData[1] != get_user_userid(id))
			return ;
		
		new szSqlPassword[100]
		SQL_ReadResult(Query, 2, szSqlPassword, 99)
		
		if(equal(g_Jelszo[id], szSqlPassword))
		{	
			SQL_ReadResult(Query, 3, g_Email[id], 99)

			g_Id[id] = SQL_ReadResult(Query, 0)
			
			g_Dollar[id] = SQL_ReadResult(Query, 5);
			g_Keys[id] = SQL_ReadResult(Query, 6);
			g_Vip[id] = SQL_ReadResult(Query, 7);
			
			for(new i;i < MAXCHEST; i++)
			{
				g_Chest[id][i] = SQL_ReadResult(Query, 8+i);
			}
			for(new i=1;i < 32; i++)
			{
				g_Skin[id][i] = SQL_ReadResult(Query, 14+i);
			}

			ColorChat(id, GREEN, "^4%s^1 Üdv^3 %s^1, sikeresen bejelentkeztél!",PREFIX, g_Felhasznalonev[id])
			g_Folyamatban[id] = 0
			g_Bejelentkezve[id] = true
			MainMenu(id)
		}
		else
		{
			ColorChat(id, GREEN, "^4%s^1 Hibás ^3Felhasználónév^1 vagy ^3Jelszó^1!", PREFIX)
			g_Folyamatban[id] = 0
			showMenu_RegLog(id)
		}
	}
}
public sql_update_account(id)
{	
	new Query[2508], Len
	
	new c[191]
	
	format(c, 190, "%s", g_Name[id])
	
	replace_all(c, 190, "\", "\\")
	replace_all(c, 190, "'", "\'") 

	Len += format(Query[Len], charsmax(Query), "UPDATE onlydust SET ")
	
	Len += formatex(Query[Len], charsmax(Query)-Len, "Dollar = '%d', ", g_Dollar[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "Kulcs = '%d', ", g_Keys[id]);
	Len += formatex(Query[Len], charsmax(Query)-Len, "Vip = '%d', ", g_Vip[id]);
	
	for(new i;i < MAXCHEST; i++)
	{
		Len += formatex(Query[Len], charsmax(Query)-Len, "Ld%d = '%d', ", i, g_Chest[id][i]);
	}
	
	for(new i=1;i < 32; i++)
	{
		Len += formatex(Query[Len], charsmax(Query)-Len, "Skin%d = '%d', ", i, g_Skin[id][i]);
	}

	Len += format(Query[Len], charsmax(Query)-Len,"Jatekosnev = '%s' ", c)
	Len += format(Query[Len], charsmax(Query)-Len,"WHERE Id = '%d'", g_Id[id])
	
	SQL_ThreadQuery(g_SqlTuple,"sql_update_account_thread", Query);
}
public sql_update_account_thread(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
	if(FailState == TQUERY_CONNECT_FAILED)return set_fail_state("[ *HIBA* ] NEM LEHET KAPCSOLODNI AZ ADATBAZISHOZ!")
	else if(FailState == TQUERY_QUERY_FAILED) return set_fail_state("[ *HIBA* ] A LEKERDEZES MEGSZAKADT!")
	
	if(Errcode) return log_amx("[ *HIBA* ] PROBLEMA A LEKERDEZESNEL! ( %s )",Error)
	
	return PLUGIN_CONTINUE
}
public client_disconnect(id)
{
	if(g_Bejelentkezve[id])
		sql_update_account(id);
		
	g_Bejelentkezve[id] = false
	
	g_Felhasznalonev[id][0] = EOS
	g_Folyamatban[id] = 0;
	g_Jelszo[id][0] = EOS
	g_Jelszo1[id][0] = EOS
	g_Email[id][0] = EOS
	g_Id[id] = 0
}
public client_putinserver(id)
{	
	g_Bejelentkezve[id] = false;
	g_Choose[id][1] = 0;
	g_Choose[id][2] = 0;
	g_Choose[id][3] = 0;
	get_user_name(id, g_Name[id], charsmax(g_Name[]));
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
