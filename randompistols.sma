#include <amxmodx>
#include <cstrike>
#include <fakemeta_util>
#include <hamsandwich>

new const PriBit = (1<<CSW_SCOUT)|(1<<CSW_XM1014)|(1<<CSW_MAC10)|(1<<CSW_AUG)|(1<<CSW_UMP45)|(1<<CSW_SG550)|(1<<CSW_GALIL)|(1<<CSW_FAMAS)|(1<<CSW_AWP)|(1<<CSW_MP5NAVY)|(1<<CSW_M249)|(1<<CSW_M3)|(1<<CSW_M4A1)|(1<<CSW_TMP)|(1<<CSW_G3SG1)|(1<<CSW_SG552)|(1<<CSW_AK47)|(1<<CSW_P90);
new const SecBit = (1<<CSW_P228)|(1<<CSW_ELITE)|(1<<CSW_FIVESEVEN)|(1<<CSW_USP)|(1<<CSW_GLOCK18)|(1<<CSW_DEAGLE);

enum _:pistype {
	displayN[20], pisName[20], pisAmmo[10]
}

new pistols[][pistype] = 
{
	{ "USP", "weapon_usp", 100},
	{ "GLOCK", "weapon_glock18", 120},
	{ "DEAGLE", "weapon_deagle", 35},
	{ "FIVE SEVEN", "weapon_fiveseven", 100},
	{ "P228", "weapon_p228", 52}
}

public plugin_init()
{
	register_plugin("Free Random Pistols", "1.0", "DiGiTaL")
	register_cvar("ranPistols", "1.0", FCVAR_SERVER| FCVAR_SPONLY)
	RegisterHam(Ham_Spawn, "player", "hamSpawn", 1);
}

public hamSpawn(id) 
{
	if(!is_user_alive(id)) return 0;

	new i = random_num(0, sizeof pistols -1)
	sendItem(id, pistols[i][pisName], pistols[i][pisAmmo])
	ColorPrint(id, "[^4RANDOM PISTOLS^1] Your ^3Free ^1Pistol ^1is ^3: ^4%s", pistols[i][displayN])
	return 0;
}

stock sendItem(id, weapName[], ammoNum) 
{
	static curWeaps[32], weaponName[32], weaponsNum, curId;		
	curId = get_weaponid(weapName);
	weaponsNum = 0;

	get_user_weapons(id, curWeaps, weaponsNum);
	for(new i;i < weaponsNum;i++) 
	{
		if(((1 << curId) & PriBit && (1 << curWeaps[i]) & PriBit) | ((1 << curId) & SecBit && (1 << curWeaps[i]) & SecBit)) {		
			get_weaponname(curWeaps[i], weaponName, charsmax(weaponName));
			engclient_cmd(id, "drop", weaponName);
		}
	}
	fm_give_item(id, weapName);
	cs_set_user_bpammo(id, curId, ammoNum);
	return 1;
}

stock ColorPrint(const id, const input[], any:...) 
{ 
	new count = 1, players[32]; 
	static msg[191]; 
	vformat(msg, 190, input, 3); 

	replace_all(msg, 190, "^4", "^x04");
	replace_all(msg, 190, "^1", "^x01");
	replace_all(msg, 190, "^3", "^x03");

	if (id) players[0] = id; else get_players(players, count, "ch"); 
	{ 
		for (new i = 0; i < count; i++) 
		{ 
			if (is_user_connected(players[i])) 
			{ 
				message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i]); 
				write_byte(players[i]); 
				write_string(msg); 
				message_end(); 
			} 
		} 
	} 
}
