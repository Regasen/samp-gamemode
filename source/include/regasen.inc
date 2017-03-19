stock UpdateAccountString(playerid, key[], value[])
{
	static const fmt_update_account[] = "UPDATE `accounts` SET `%s` = '%e' WHERE `id` = '%d'";
	new update_account[sizeof(fmt_update_account) + (-2 + 32) + (-2 + 60) + (-2 + 11) + 1];

	mysql_format(connect, update_account, sizeof(update_account), fmt_update_account, key, value, PlayerData[playerid][pID]);
	mysql_query(connect, update_account);
	return true;
}

stock UpdateAccountFloat(playerid, key[], Float:value)
{
	static const fmt_update_account[] = "UPDATE `accounts` SET `%s` = '%f' WHERE `id` = '%d'";
	new update_account[sizeof(fmt_update_account) + (-2 + 32) + (-2 + 60) + (-2 + 11) + 1];

	mysql_format(connect, update_account, sizeof(update_account), fmt_update_account, key, value, PlayerData[playerid][pID]);
	mysql_query(connect, update_account);
	return true;
}

stock UpdateAccountInt(playerid, key[], value)
{
	static const fmt_update_account[] = "UPDATE `accounts` SET `%s` = '%d' WHERE `id` = '%d'";
	new update_account[sizeof(fmt_update_account) + (-2 + 32) + (-2 + 11) + (-2 + 11) + 1];

	mysql_format(connect, update_account, sizeof(update_account), fmt_update_account, key, value, PlayerData[playerid][pID]);
	mysql_query(connect, update_account);
	return true;
}

stock UpdateBizzInt(cell, key[], value)
{
	new string[48 + (-2 + 11) + (-2 + 30) + 1];
	mysql_format(connect, string, sizeof(string), "UPDATE `bizz` SET `%s` = '%d' WHERE `id` = '%d'", key, value, BizzData[cell][bID]);
	mysql_query(connect, string);
	return true;
}


stock GiveMoney(playerid, count)
{
	new money[7 + (-2 + 11) + 1];

	ResetPlayerMoney(playerid);
	PlayerData[playerid][pMoney] += count;
	GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
	format(money, sizeof(money), "~g~+$%i", count);
	GameTextForPlayer(playerid, money, 5000, 1);
	UpdateAccountInt(playerid, "money", PlayerData[playerid][pMoney]);
	return true;
}

stock TakeMoney(playerid, count)
{
	new money[7 + (-2 + 11) + 1];

	ResetPlayerMoney(playerid);
	PlayerData[playerid][pMoney] -= count;
	GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
	format(money, sizeof(money), "~r~-$%i", count);
	GameTextForPlayer(playerid, money, 5000, 1);
	UpdateAccountInt(playerid, "money", PlayerData[playerid][pMoney]);
	return true;
}

stock PlayerBesideTheOther(Float: radius, playerid, targetid)
{
    if(0 == IsPlayerStreamedIn(playerid, targetid))
        return 0;

    new Float: pos_x,
        Float: pos_y,
        Float: pos_z;

    GetPlayerPos(targetid, pos_x, pos_y, pos_z);
    return (IsPlayerInRangeOfPoint(playerid, radius, pos_x, pos_y, pos_z));
}

stock PlayerToKvadrat(playerid,Float:min_x,Float:min_y,Float:max_x,Float:max_y)
{
	new Float:Pos_X,Float:Pos_Y,Float:Pos_Z;
	GetPlayerPos(playerid, Pos_X,Pos_Y,Pos_Z);
	if((Pos_X <= max_x && Pos_X >= min_x) && (Pos_Y <= max_y && Pos_Y >= min_y)) return true;
	return false;
}

stock IsAMeshok(playerid)
{
	for(new i;i<5;i++)
	{
	    if(PlayerData[playerid][pAttach][i] == 15) return true;
	}
	return false;
}