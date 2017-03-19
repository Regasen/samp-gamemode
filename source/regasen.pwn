/**
*
*	Regasen Play
*	������� ����� ��� ������� ����������� ���� GTA: San-Andreas
*	�����������: Yuriy Abramov a.k.a yuriy5022
*
*/
#include <a_samp>

#undef MAX_PLAYERS 
#undef MAX_PLAYER_NAME

#include "../source/config.cfg"

#define BYTES_PER_CELL 						(4)

#define foreach(%0) 						for(new _i, %0=array_players[_i]; _i <total_players; %0=array_players[++_i])
#define void%0(%1) 							forward %0(%1); public %0(%1)

#include "../source/include/sscanf2.inc"
#include "../source/include/a_mysql.inc"
#include "../source/include/Pawn.CMD.inc"
#include "../source/include/Pawn.Regex.inc"
#include "../source/include/streamer.inc"
#include "../source/include/fixes.inc"
#include "../source/include/textdraws.inc"

main()
{
} 

enum ePlayer
{
	pLogin[MAX_PLAYER_NAME + 1],
	pPassword[MAX_PLAYER_PASSWORD + 1],
	pPINAttempt[9 + 1],
	pAdminLastIP[24 + 1],
	pAdminRegIP[24 + 1],
	pPIN[10 + 1],
	pIP[24 + 1],
	
	pID,
	pGender,
	pSkin,
	pMoney,
	pAttempt,
	pLevel,
	pLogged,
	Float:pHealth,
	pMuteTime,
	pAdminLevel,
	pAdminLastDate,
	pAdminRegDate
};

enum
{
	dRegistry,
	dLogin,
	dGender,
	dMenu,
	dSecurity,
	dReplacePassword,
	dReplacePassword2,
	dReport
};

new PlayerData[MAX_PLAYERS][ePlayer];

new array_players[MAX_PLAYERS];

new MySQL:connect_id;

new regex:check_nickname; 
new regex:check_password;

new total_players;

new convert[11 + 3];

new novice_skin[2][10] = {
	{LIST_SKIN_MALE},
	{LIST_SKIN_FEMALE}
};

public OnGameModeInit()
{
	LoadingTextDraws();

	SetNameTagDrawDistance(20);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(false);
	ManualVehicleEngineAndLights();

	check_nickname = regex_new("[A-Z][a-z]+_[A-Z][a-z]+");
	check_password = regex_new("^([A-Z]|[a-z]|[0-9]){5,20}$");

	connect_id = mysql_connect("localhost", "root", "", "regasen");
	AddPlayerClass(289,1958.3783,1343.1572,1100.3746,269.1425,-1,-1,-1,-1,-1,-1);

	SetGameModeText("RolePlay");
	return true;
}

public OnGameModeExit()
{
	regex_delete(check_nickname); 
	regex_delete(check_password); 
	return true;
}

public OnPlayerConnect(playerid)
{
	new 
		request[81 + (-2 + MAX_PLAYER_NAME) + 1];

	array_players[total_players++] = playerid;

	LoadingPlayerTextDraws(playerid);
	
	GetPlayerName(playerid, PlayerData[playerid][pLogin], MAX_PLAYER_NAME);

	SetTimerEx("OnTimeLogin", 30000, false, "d", playerid);
	
	if(!regex_check(PlayerData[playerid][pLogin], check_nickname)) return 
		SendClientMessage(playerid, -1, "��� ��� {"#MAIN_COLOR"}�� �������������{FFFFFF} ��������"),
		SendClientMessage(playerid, -1, "����������, �������� ������� �� ����� �����: {"#MAIN_COLOR"}"#SERVER_SITE),
		Kick(playerid);
	
	mysql_format(connect_id, request, sizeof(request), "SELECT * FROM users WHERE login = '%e' LIMIT 1", PlayerData[playerid][pLogin]);
	mysql_query(connect_id, request);

	switch(cache_num_rows())
	{
		case 0:
		{
			ShowPlayerDialog(playerid, dRegistry, DIALOG_STYLE_INPUT, "�������� ��������", "{FFFFFF}����� ���������� �� {"#MAIN_COLOR"}"#SERVER_NAME"{FFFFFF}\n��� ��� �� ��������������� � �������.\n\n���������� ������, ������� ����� ��������������� ������ �����������:\n - ������ ������ �������� �� ��������� ���� � ����.\n - ����� ������ ������ ���� ������ 5 � ������ 20 ��������.\n - ������ ������ ��������� ������� 1 ��������� ������.\n\n������� ���� ������ � ���� ����:", "�����", "");
		}

		case 1:
		{
			cache_get_value_name(0, "password",     PlayerData[playerid][pPassword], MAX_PLAYER_PASSWORD);
			cache_get_value_name(0, "pin",          PlayerData[playerid][pPIN], 10);

			cache_get_value_name_int(0, "id",       PlayerData[playerid][pID]);
			cache_get_value_name_int(0, "gender",   PlayerData[playerid][pGender]);
			cache_get_value_name_int(0, "skin",     PlayerData[playerid][pSkin]);
			cache_get_value_name_int(0, "level",    PlayerData[playerid][pLevel]);
			cache_get_value_name_int(0, "money",    PlayerData[playerid][pMoney]);
			cache_get_value_name_int(0, "mute",     PlayerData[playerid][pMuteTime]);

			cache_get_value_name_float(0, "health", PlayerData[playerid][pHealth]);

			GetPlayerIp(playerid, PlayerData[playerid][pIP], 24);
			
			ShowPlayerDialog(playerid, dLogin, DIALOG_STYLE_INPUT, "���� � �������", "{FFFFFF}����� ���������� �� {"#MAIN_COLOR"}"#SERVER_NAME"{FFFFFF}\n��������� ������, ������� �� ��������� ��� �������� ��������.\n\n������� ��� ������ ����:", "�����", "");
		}
	}

	SetSpawnInfo(playerid, 0, PlayerData[playerid][pSkin], 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	SetPlayerColor(playerid,0xFFFFFF20);

	PlayerData[playerid][pAttempt] = (MAX_PLAYER_ATTEMPT - 1);
	return true;
}

void OnTimeLogin(playerid)
{
	if(1 == PlayerData[playerid][pLogin]) return true;
	SendClientMessage(playerid, -1, "����� �� ����������� �������");
	Kick(playerid);
	return true;
}

void OnPlayerTimer(playerid)
{
	if(PlayerData[playerid][pMuteTime] > 0)
	{
		PlayerData[playerid][pMuteTime] -= 1;
		if(PlayerData[playerid][pMuteTime] == 1)
		{
			SendClientMessage(playerid, -1, "����� ������� �������");
		}
	}
	if(PlayerData[playerid][pLogged] == 1)
	{
		SetTimerEx("OnPlayerTimer", 1000, false, "d", playerid);
	}
	return true;
}

public OnPlayerDisconnect(playerid, reason)
{
	GetPlayerHealth(playerid, PlayerData[playerid][pHealth]);

	UpdateDatabase("users", "health", FloatToStr(PlayerData[playerid][pHealth]), "id", IntToStr(PlayerData[playerid][pID]));
	UpdateDatabase("users", "mute", IntToStr(PlayerData[playerid][pMuteTime]), "id", IntToStr(PlayerData[playerid][pID]));
	

	for(new i = 0; i < total_players; i++)
    {
        if(array_players[i] == playerid)
        {
            array_players[i] = array_players[--total_players];
            array_players[total_players] = -1;
            break;
        }
    } 

    for(new ePlayer:i; i < ePlayer; ++i) PlayerData[playerid][i] = 0;
	return true;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case dRegistry:
		{
			new 
				length = strlen(inputtext);

			if(length < 5 || length > MAX_PLAYER_PASSWORD || !regex_check(inputtext, check_password)) return 
					SendClientMessage(playerid, -1, "��� ������ �� ������������� ��������, ���������� ����� ������"),
					ShowPlayerDialog(playerid, dRegistry, DIALOG_STYLE_INPUT, "�������� ��������", "{FFFFFF}����� ���������� �� {"#MAIN_COLOR"}"#SERVER_NAME"{FFFFFF}\n��� ��� �� ��������������� � �������.\n\n���������� ������, ������� ����� ��������������� ������ �����������:\n - ������ ������ �������� �� ��������� ���� � ����.\n - ����� ������ ������ ���� ������ 5 � ������ 20 ��������.\n - ������ ������ ��������� ������� 1 ��������� ������.\n\n������� ���� ������ � ���� ����:", "�����", "");
			
			strmid(PlayerData[playerid][pPassword], inputtext, 0, MAX_PLAYER_PASSWORD, MAX_PLAYER_PASSWORD + 1);

			ShowPlayerDialog(playerid, dGender, DIALOG_STYLE_MSGBOX, "��� ���������", "{FFFFFF}����������� �� {"#MAIN_COLOR"}"#SERVER_NAME"{FFFFFF}\n���������, ������ ���� ����� ��� ��������.\n\n�������� ��������������� ������ ����:", "�������", "�������");
		}

		case dGender:
		{
			new 
				request[81 + (-2 + MAX_PLAYER_NAME) + (-2 + MAX_PLAYER_PASSWORD) + (-2 + 1) + (-2 + 3) + 1], 
				skin = novice_skin[response ? 0 : 1][random(10) + 1];

			mysql_format(connect_id, request, sizeof(request), "INSERT INTO users (login, password, gender, skin) VALUES ('%e', '%e', '%d', '%d')", PlayerData[playerid][pLogin], PlayerData[playerid][pPassword], response ? 1 : 2, skin);
			mysql_query(connect_id, request);

			PlayerData[playerid][pID]     = cache_insert_id();
			PlayerData[playerid][pGender] = response ? 1 : 2;
			PlayerData[playerid][pSkin]   = skin;
			PlayerData[playerid][pHealth] = 100.0;
			PlayerData[playerid][pMoney]  = 500;
			PlayerData[playerid][pLevel]  = 1;

			SendClientMessage(playerid, -1, "�� ������� ������� �������");
			PlayerSpawn(playerid);

		}

		case dLogin:
		{
			if(strcmp(PlayerData[playerid][pPassword], inputtext, false))
			{
				if(PlayerData[playerid][pAttempt] == 0) 
				{
					SendClientMessage(playerid, -1, "���������� ������� ����� {"#MAIN_COLOR"}����������");
					return Kick(playerid);
				}

				SendClientMessage(playerid, -1, "��������� ������ �� ������, {"#MAIN_COLOR"}���������� ��� ���");

				ShowPlayerDialog(playerid, dLogin, DIALOG_STYLE_INPUT, "���� � �������", "{FFFFFF}����� ���������� �� {"#MAIN_COLOR"}"#SERVER_NAME"{FFFFFF}\n��������� ������, ������� �� ��������� ��� �������� ��������.\n\n������� ��� ������ ����:", "�����", "");
				
				PlayerData[playerid][pAttempt] -= 1;
				return true;
			}
			SetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
			switch(strlen(PlayerData[playerid][pPIN]))
			{
				case 0..3: PlayerSpawn(playerid);
				default:
				{
					SetPlayerVirtualWorld(playerid, 100);
					TogglePlayerSpectating(playerid, true);

					for(new i = 0; i < sizeof(TD_PinCode); i++) 
						TextDrawShowForPlayer(playerid, TD_PinCode[i]);

					PlayerTextDrawShow(playerid, TD_PinCodeDisplay[playerid]);
					SelectTextDraw(playerid, 0xFFFFFFFF);
					SetPVarInt(playerid, "PIN", 2);
				}
			}
		}

		case dMenu:
		{
			if(!response) return true;
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, dSecurity, DIALOG_STYLE_LIST, "������������ ��������", "������ �������� ��������� ������� (PIN)\n����� ������ �� ��������", "�����", "�����");
				}
				
				case 1:
				{
				    ShowPlayerDialog(playerid, dReport, DIALOG_STYLE_INPUT, "����� � ��������������", "{FFFFFF}������� ���� �������� ������� � ����:", "���������", "�����");
				}
			}
		}

		case dReport:
		{
			new
			    msg[32 + (-2 + MAX_PLAYER_NAME) + (-2 + 3) + (-2 + 100) + 1];
			    
		    if(!response) return
				callcmd::mn(playerid);
				
			format(msg, sizeof(msg), "[A] ������ �� %s[%d]: %s", PlayerData[playerid][pLogin], playerid, inputtext);
			SendAdminMessage(0xA2D246FF, msg);
		}
		
		case dSecurity:
		{
			if(!response) return callcmd::mn(playerid);
			switch(listitem)
			{
				case 0:
				{
					if(strlen(PlayerData[playerid][pPIN]) < 3)
					{
						for(new i = 0; i < sizeof(TD_PinCode); i++) 
							TextDrawShowForPlayer(playerid, TD_PinCode[i]);

						PlayerTextDrawShow(playerid, TD_PinCodeDisplay[playerid]);
						SelectTextDraw(playerid, 0xFFFFFFFF);
						SetPVarInt(playerid, "PIN", 1);
					}
				}

				case 1:
				{
					ShowPlayerDialog(playerid, dReplacePassword, DIALOG_STYLE_INPUT, "����� ������ �� ��������", "{FFFFFF}����� ������ �� �������� �� {"#MAIN_COLOR"}"#SERVER_NAME"{FFFFFF}\n��������� ���� ������ ������.\n\n������� ���� ������ � ���� ����:", "�����", "������");
				}
			}
		}

		case dReplacePassword:
		{
			if(!response) return callcmd::mn(playerid);
			if(!strcmp(PlayerData[playerid][pPassword], inputtext, false)) return true;
			ShowPlayerDialog(playerid, dReplacePassword2, DIALOG_STYLE_INPUT, "����� ������ �� ��������", "{FFFFFF}����� ������ �� �������� �� {"#MAIN_COLOR"}"#SERVER_NAME"{FFFFFF}\n���������� ������, ������� ����� ��������������� ������ �����������:\n - ������ ������ �������� �� ��������� ���� � ����.\n - ����� ������ ������ ���� ������ 5 � ������ 20 ��������.\n - ������ ������ ��������� ������� 1 ��������� ������.\n\n������� ���� ������ � ���� ����:", "�����", "������");
		}

		case dReplacePassword2: 
		{
			new 
				length = strlen(inputtext);

			if(!response) return callcmd::mn(playerid);
			if(length < 5 || length > MAX_PLAYER_PASSWORD || !regex_check(inputtext, check_password)) return 
					SendClientMessage(playerid, -1, "��� ������ �� ������������� ��������, ���������� ����� ������");

			strmid(PlayerData[playerid][pPassword], inputtext, 0, MAX_PLAYER_PASSWORD, MAX_PLAYER_PASSWORD + 1);

			UpdateDatabase("users", "password", PlayerData[playerid][pPassword], "id", IntToStr(PlayerData[playerid][pID]));
		}
	}
	return true;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(_:clickedid == INVALID_TEXT_DRAW)
	{
		if(GetPVarInt(playerid, "PIN") != 0)
		{
			for(new i = 0; i < sizeof(TD_PinCode); i++) 
				TextDrawHideForPlayer(playerid, TD_PinCode[i]);

			PlayerTextDrawHide(playerid, TD_PinCodeDisplay[playerid]);
			SetPVarInt(playerid, "PIN", 0);
			CancelSelectTextDraw(playerid);
		}
	}
	if(GetPVarInt(playerid, "PIN") != 0) 
	{
		if(clickedid == TD_PinCode[0])
		{
			PlayerData[playerid][pPINAttempt][0] = '\0';
			PlayerTextDrawSetString(playerid, TD_PinCodeDisplay[playerid], "");
			return true;
		}
		for(new i = 0; i < sizeof(TD_PinCode); i++)
		{
			if(clickedid == TD_PinCode[i] && i >= 3 && i <= 11)
			{
				for(new j = 0; j < 10; j++)
				{
					if(PlayerData[playerid][pPIN][j] == 0)
					{
						strcat(PlayerData[playerid][pPINAttempt], IntToStr(i-2), 10);
						PlayerTextDrawSetString(playerid, TD_PinCodeDisplay[playerid], PlayerData[playerid][pPINAttempt]);
						return true;
					}
				}
			}
		}
		if(clickedid == TD_PinCode[12])
		{
			if(strlen(PlayerData[playerid][pPINAttempt]) < 3) return
				SendClientMessage(playerid, -1, "PIN ��� ������ ��������� ������ 3 ��������");
				
			switch(GetPVarInt(playerid, "PIN"))
			{
				case 1:
				{
					format(PlayerData[playerid][pPIN], 10, "%s", PlayerData[playerid][pPINAttempt]);
					UpdateDatabase("users", "pin", PlayerData[playerid][pPIN], "id", IntToStr(PlayerData[playerid][pID]));
					
					for(new i = 0; i < sizeof(TD_PinCode); i++) 
						TextDrawHideForPlayer(playerid, TD_PinCode[i]);

					SendClientMessage(playerid, MAIN_COLOR_PREFIX, "PIN{FFFFFF} ��� ��������");
					PlayerTextDrawHide(playerid, TD_PinCodeDisplay[playerid]);

					SetPVarInt(playerid, "PIN", 0);
					CancelSelectTextDraw(playerid);
				}
				case 2:
				{
					if(strcmp(PlayerData[playerid][pPINAttempt], PlayerData[playerid][pPIN], false))
					{
					    SendClientMessage(playerid, -1, "�� ����� �� ������ {"#MAIN_COLOR"}��������� ������");
						Kick(playerid);
						return true;
					}

					for(new i = 0; i < sizeof(TD_PinCode); i++) 
						TextDrawHideForPlayer(playerid, TD_PinCode[i]);

					PlayerTextDrawHide(playerid, TD_PinCodeDisplay[playerid]);
					TogglePlayerSpectating(playerid, false);
					SetPlayerVirtualWorld(playerid, 0);
					SetPVarInt(playerid, "PIN", 0);
					CancelSelectTextDraw(playerid);
					PlayerSpawn(playerid);
				}
			}
		}
	}
	return true;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);

	SetPlayerPos(playerid, 1743.2384, -1861.7690, 13.5771);
	SetPlayerFacingAngle(playerid, 356.6750);

	SetCameraBehindPlayer(playerid);
	return true;
}

public OnPlayerDeath(playerid)
{
	PlayerData[playerid][pHealth] = 100.0;
	return true;
}

public OnPlayerText(playerid, text[])
{
	if(PlayerData[playerid][pMuteTime] > 0)
	{
		SendClientMessage(playerid, -1, "�� �� ������ ��������");
		return false;
	}

	format(text, 144, "%s[%d]: %s", PlayerData[playerid][pLogin], playerid, text);
	SendClientMessage(playerid, -1, text);

	foreach(i)
	{
		if(IsPlayerConnected(i) && PlayerBesideTheOther(100.0, playerid, i))
		{
		    SendClientMessage(i, -1, text);
		}
	}
	return false;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	if(0 == PlayerData[playerid][pLogin])
	{
	    SendClientMessage(playerid, -1, "��� ������������� ������ ������� � �������");
	    return false;
	}
	return true;
}

/**
*
*	�����: _cmd
*
*/

CMD:mn(playerid)
{
	return ShowPlayerDialog(playerid, dMenu, DIALOG_STYLE_LIST, "������� ����", "������������ ��������\n����� � ��������������", "�����", "�������");
}

CMD:addadmin(playerid, params[])
{
	new 
		request[104 + (-2 + 11) + (-2 + 1) + (-2 + 15) + (-2 + 24) + (-2 + MAX_PLAYER_NAME) + 1],
		targetid,
		level;

	if(!IsAdmin(playerid, ADMIN_LEVEL_DEVELOPER)) return true;
	if(sscanf(params, "dd", targetid, level)) return SendClientMessage(playerid, -1, "�������: {"#MAIN_COLOR"}/addadmin{FFFFFF} [targetid] [level]");
	
	mysql_format(connect_id, request, sizeof(request), "INSERT INTO admins (id, level, reg_date, reg_ip, reg_admin) VALUES ('%d', '%d', UNIX_TIMESTAMP(), '%s', '%e')", PlayerData[targetid][pID], level, PlayerData[targetid][pIP], PlayerData[playerid][pLogin]);
	mysql_query(connect_id, request);

	PlayerData[targetid][pAdminLevel] = level;
	PlayerData[targetid][pAdminRegDate] = gettime();
	format(PlayerData[targetid][pAdminRegIP], 24, "%s", PlayerData[targetid][pIP]);

	SendClientMessage(playerid, -1, "���������� ������");
	return true;
}

CMD:ahelp(playerid)
{
	if(IsAdmin(playerid, ADMIN_LEVEL_IMPROVER))  SendClientMessage(playerid, -1, "/mute /kick /tp");
	if(IsAdmin(playerid, ADMIN_LEVEL_MODERATOR)) SendClientMessage(playerid, -1, "/unmute /ban /offban");
	if(IsAdmin(playerid, ADMIN_LEVEL_SPECTATE))  SendClientMessage(playerid, -1, "/unban");
	if(IsAdmin(playerid, ADMIN_LEVEL_MAIN))      SendClientMessage(playerid, -1, "");
	if(IsAdmin(playerid, ADMIN_LEVEL_SPECIAL))   SendClientMessage(playerid, -1, "");
	if(IsAdmin(playerid, ADMIN_LEVEL_DEVELOPER)) SendClientMessage(playerid, -1, "/addadmin");
	return true;
}

CMD:unban(playerid, params[])
{
	new
	    request[91 + (-2 + 11) + 1],
	    reason[50 + 1],
		nickname[MAX_PLAYER_NAME + 1],
	    id;
	    
	if(!IsAdmin(playerid, ADMIN_LEVEL_SPECTATE)) return true;
	
	if(sscanf(params, "s[24]s[50]", nickname, reason)) return
	    SendClientMessage(playerid, -1, "�������: {"#MAIN_COLOR"}/unban{FFFFFF} [nickname] [reason]");

	mysql_format(connect_id, request, sizeof(request), "SELECT id FROM users WHERE login = '%e'", nickname);
	mysql_query(connect_id, request);
	
	if(cache_num_rows() == 0) return
	    SendClientMessage(playerid, -1, "������ � ������ ����� ������������");

	cache_get_value_name_int(0, "id", id);
	
	mysql_format(connect_id, request, sizeof(request), "SELECT id FROM bans WHERE time_end > UNIX_TIMESTAMP() AND user_id = '%d' AND unbanned = '0'", id);
	mysql_query(connect_id, request);
	
	if(cache_num_rows() == 0) return
		SendClientMessage(playerid, -1, "����� � ������ ����� �� ������������");
		
	UpdateDatabase("bans", "unbanned", IntToStr(1), "id", IntToStr(id));
	
	format(request, sizeof(request), "������������� %s[%d] ������������� ������ %s.�������: %s", PlayerData[playerid][pLogin], playerid, nickname, reason);
	SendClientMessageToAll(0xFF0000FF, request);
	
	return true;
}

CMD:ban(playerid, params[])
{
	new
	    targetid,
	    time,
	    request[114 + ((-2 + MAX_PLAYER_NAME) * 2) + 50 + 1];
	    
	if(!IsAdmin(playerid, ADMIN_LEVEL_MODERATOR)) return true;
	
	if(sscanf(params, "dds[50]", targetid, time, request) || !IsPlayerConnected(targetid) || time < 1 || time > 30) return
		SendClientMessage(playerid, -1, "�������: {"#MAIN_COLOR"}/ban{FFFFFF} [targetid] [day(1-30)] [reason]");
	
	format(request, sizeof(request), "������������� %s[%d] ������������ �� %d ���� ������ %s[%d].�������: %s", PlayerData[playerid][pLogin], playerid, time, PlayerData[targetid][pLogin], targetid, request);
	SendClientMessageToAll(0xFF0000FF, request);

	mysql_format(connect_id, request, sizeof(request), "INSERT INTO bans (user_id, admin_id, time_start, time_end, user_ip, admin_ip) VALUES ('%d', '%d', '%d', '%d', '%s', '%s')", PlayerData[targetid][pID], PlayerData[playerid][pID], gettime(), (gettime() + (86400 * time)), PlayerData[targetid][pIP], PlayerData[playerid][pIP]);
	mysql_query(connect_id, request);
	
	Kick(targetid);
	return true;
}

CMD:offban(playerid, params[])
{
	new
	    id,
	    time,
	    nickname[MAX_PLAYER_NAME + 1],
	    reason[50 + 1],
	    request[114 + ((-2 + MAX_PLAYER_NAME) * 2) + 50 + 1];

	if(!IsAdmin(playerid, ADMIN_LEVEL_MODERATOR)) return true;

	if(sscanf(params, "s[24]ds[50]", nickname, time, reason) || time < 1 || time > 30) return
		SendClientMessage(playerid, -1, "�������: {"#MAIN_COLOR"}/ban{FFFFFF} [nickname] [day(1-30)] [reason]");


	mysql_format(connect_id, request, sizeof(request), "SELECT id FROM users WHERE login = '%e'", nickname);
	mysql_query(connect_id, request);

	if(cache_num_rows() == 0) return
	    SendClientMessage(playerid, -1, "������ � ������ ����� ������������");

	cache_get_value_name_int(0, "id", id);

	mysql_format(connect_id, request, sizeof(request), "SELECT id FROM bans WHERE UNIX_TIMESTAMP() > time_end AND user_id = '%d' AND unbanned = '0'", id);
	mysql_query(connect_id, request);

	if(cache_num_rows() != 0) return
		SendClientMessage(playerid, -1, "����� � ������ ����� ��� ������������");
		
	format(request, sizeof(request), "������������� %s[%d] ������������ �� %d ���� ������� ������ %s.�������: %s", PlayerData[playerid][pLogin], playerid, time, nickname, reason);
	SendClientMessageToAll(0xFF0000FF, request);

	mysql_format(connect_id, request, sizeof(request), "INSERT INTO bans (user_id, admin_id, time_start, time_end, user_ip, admin_ip) VALUES ('%d', '%d', '%d', '%d', '%s', '%s')", id, PlayerData[playerid][pID], gettime(), (gettime() + (86400 * time)), "OFFLINE-BAN", PlayerData[playerid][pIP]);
	mysql_query(connect_id, request);
	return true;
}

CMD:tp(playerid, params[])
{
	new 
		targetid,
		Float:_x,
		Float:_y,
		Float:_z;
		
	if(!IsAdmin(playerid, ADMIN_LEVEL_IMPROVER)) return true;

	if(sscanf(params, "d", targetid) || !IsPlayerConnected(targetid)) return
		SendClientMessage(playerid, -1, "�������: {"#MAIN_COLOR"}/tp{FFFFFF} [targetid]");
	
	GetPlayerPos(targetid, _x, _y, _z);
	SetPlayerPos(playerid, _x, _y, _z);

	SendFormattedMessage(playerid, -1, "�� ����������������� � ������ %s[%d]", PlayerData[targetid][pLogin], targetid);
	SendFormattedMessage(targetid, -1, "������������� %s[%d] ���������������� � ���", PlayerData[playerid][pLogin], playerid);
	
	return true;
}

CMD:kick(playerid, params[])
{
	new 
		targetid, 
		msg[68 + ((-2 + MAX_PLAYER_NAME) * 2) + ((-2 + 3) * 2) + 50 + 1];

	if(sscanf(params, "ds[50]", targetid, msg) || !IsPlayerConnected(targetid)) return
		SendClientMessage(playerid, -1, "�������: {"#MAIN_COLOR"}/kick{FFFFFF} [targetid] [reason]");
		
	if(IsAdmin(targetid, ADMIN_LEVEL_IMPROVER) && !IsAdmin(playerid, ADMIN_LEVEL_SPECTATE)) return
		SendClientMessage(playerid, -1, "�� �� ������ ������� ��������������");
		
	format(msg, sizeof(msg), "������������� %s[%d] ���������� �� ������� ������ %s[%d].�������: %s", PlayerData[playerid][pLogin], playerid, PlayerData[targetid][pLogin], targetid, msg);
	SendClientMessageToAll(0xFF0000FF, msg);
	
	Kick(targetid);
	return true;
}

CMD:mute(playerid, params[])
{
	new 
		time,
		targetid, 
		msg[75 + ((-2 + MAX_PLAYER_NAME) * 2) + ((-2 + 3) * 2) + 50 + 1];

	if(!IsAdmin(playerid, ADMIN_LEVEL_IMPROVER)) return true;

	if(sscanf(params, "dds[50]", targetid, time, msg) || time > 300 || time < 1 || !IsPlayerConnected(targetid)) return
		SendClientMessage(playerid, -1, "�������: {"#MAIN_COLOR"}/mute{FFFFFF} [targetid] [count minute (1-300)] [reason]");
	
	format(msg, sizeof(msg), "������������� %s[%d] �������� ������� �� %d ����� ������ %s[%d].�������: %s", PlayerData[playerid][pLogin], playerid, time, PlayerData[targetid][pLogin], targetid, msg);
	SendClientMessageToAll(0xE18D8DFF, msg);
	
	PlayerData[targetid][pMuteTime] += (time * 60);
	return true;
}

CMD:unmute(playerid, params[])
{
	new 
		targetid, 
		msg[49 + ((-2 + MAX_PLAYER_NAME) * 2) + ((-2 + 3) * 2) + 50 + 1];

	if(!IsAdmin(playerid, ADMIN_LEVEL_MODERATOR)) return true;
	
	if(sscanf(params, "d", targetid) || !IsPlayerConnected(targetid)) return
		SendClientMessage(playerid, -1, "�������: {"#MAIN_COLOR"}/unmute{FFFFFF} [targetid]");

	format(msg, sizeof(msg), "������������� %s[%d] ���� ������� � ������ %s[%d]", PlayerData[playerid][pLogin], playerid, PlayerData[targetid][pLogin], targetid);
	SendClientMessageToAll(0xE18D8DFF, msg);
	
	PlayerData[targetid][pMuteTime] = 0;
	return true;
}

CMD:time(playerid)
{
	new msg[45 + (-2 + 5) + 1];
	format(msg, sizeof(msg), "%d{FFFFFF} ������ �������� �� ������ �������", PlayerData[playerid][pMuteTime]);
	SendClientMessage(playerid, MAIN_COLOR_PREFIX, msg);
	return true;
}
/**
*
*	�����: _stock
*
*/
stock SendAdminMessage(color, text[])
{
    foreach(i)
	{
		if(!IsPlayerConnected(i) || !IsAdmin(i, ADMIN_LEVEL_IMPROVER)) continue;
		SendClientMessage(i, color, text);
	}
}

stock SendFormattedMessage(playerid, color, fstring[], {Float, _}:...)
{
	static const
		STATIC_ARGS = 3;

	new
		n = (numargs() - STATIC_ARGS) * BYTES_PER_CELL;

	if (n)
	{
		new
			message[128],
			arg_start,
			arg_end;

		#emit CONST.alt        	fstring
		#emit LCTRL          	5
		#emit ADD
		#emit STOR.S.pri       	arg_start

		#emit LOAD.S.alt       	n
		#emit ADD
		#emit STOR.S.pri       	arg_end

		do
		{
			#emit LOAD.I
			#emit PUSH.pri
			arg_end -= BYTES_PER_CELL;
			#emit LOAD.S.pri 	arg_end
		}
		while (arg_end > arg_start);

		#emit PUSH.S         	fstring
		#emit PUSH.C         	128
		#emit PUSH.ADR        	message

		n += BYTES_PER_CELL * 3;
		#emit PUSH.S         	n
		#emit SYSREQ.C        	format

		n += BYTES_PER_CELL;
		#emit LCTRL          	4
		#emit LOAD.S.alt       	n
		#emit ADD
		#emit SCTRL          	4

		return SendClientMessage(playerid, color, message);
	}
	else
	{
		return SendClientMessage(playerid, color, fstring);
	}
}

stock PlayerSpawn(playerid)
{
	new request[90 + (-2 + 11) + 1];
	
	mysql_format(connect_id, request, sizeof(request), "SELECT * FROM bans WHERE time_end > UNIX_TIMESTAMP() AND user_id = '%d' AND unbanned = '0'", PlayerData[playerid][pID]);
	mysql_query(connect_id, request);
	
	if(cache_num_rows() != 0)
	{
		SendClientMessage(playerid, -1, "��� ������� ������������, ��������� � ������ ��������: {"#MAIN_COLOR"}"#SERVER_SITE"/lk");
		Kick(playerid);
		return true;
	}
	
	PlayerData[playerid][pLogged] = 1;
	
	UpdateDatabase("users", "last_date", IntToStr(gettime()), "id", IntToStr(PlayerData[playerid][pID]));
	UpdateDatabase("users", "last_ip", PlayerData[playerid][pIP], "id", IntToStr(PlayerData[playerid][pID]));

	mysql_format(connect_id, request, sizeof(request), "SELECT * FROM admins WHERE id = '%d'", PlayerData[playerid][pID]);
	mysql_query(connect_id, request);

	if(cache_num_rows())
	{
		cache_get_value_name_int(0, "level", PlayerData[playerid][pAdminLevel]);

		cache_get_value_name_int(0, "last_date", PlayerData[playerid][pAdminLastDate]);
		cache_get_value_name_int(0, "reg_date", PlayerData[playerid][pAdminRegDate]);

		cache_get_value_name(0, "last_ip", PlayerData[playerid][pAdminLastIP], 24);
		cache_get_value_name(0, "reg_ip", PlayerData[playerid][pAdminRegIP], 24);

        UpdateDatabase("admins", "last_date", IntToStr(gettime()), "id", IntToStr(PlayerData[playerid][pID]));
        UpdateDatabase("admins", "last_ip", PlayerData[playerid][pIP], "id", IntToStr(PlayerData[playerid][pID]));
	}
	
	if(strlen(PlayerData[playerid][pPIN]) == 0)
	{
 		SendClientMessage(playerid, 0xA2D246, "������������ ����������� ��������� ������ ��������� �������");
		SendClientMessage(playerid, 0xA2D246, "��� ����� ������� /mn � �������� ����� '������������ ��������'");
	}
	
	SpawnPlayer(playerid);
			
	SetTimerEx("OnPlayerTimer", 1000, false, "d", playerid);
	return true;
}

stock IsAdmin(playerid, level)
{
	if(PlayerData[playerid][pAdminLevel] >= level) return true;
	return false;
}

stock UpdateDatabase(table_name[], key[], value[], where_key[], where_value[])
{
	new request[39 + (-2 + 10) + ((-2 + 32) * 4) + 1];

	mysql_format(connect_id, request, sizeof(request), "UPDATE %s SET %s = '%s' WHERE %s = '%s'", table_name, key, value, where_key, where_value);
	mysql_query(connect_id, request);

	return true;
}

stock FloatToStr(Float:float)
{
	convert[0] = '\0';
	format(convert, sizeof(convert), "%f", float);
	return convert;
}

stock IntToStr(integer)
{
	convert[0] = '\0';
	format(convert, sizeof(convert), "%d", integer);
	return convert;
}

stock GiveMoney(playerid, count)
{
	ResetPlayerMoney(playerid);
	PlayerData[playerid][pMoney] += count;
	GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
	format(convert, sizeof(convert), "~g~+$%d", count);
	GameTextForPlayer(playerid, convert, 5000, 1);
	UpdateDatabase("users", "money", IntToStr(PlayerData[playerid][pMoney]), "id", IntToStr(PlayerData[playerid][pID]));
	return true;
}

stock TakeMoney(playerid, count)
{
	ResetPlayerMoney(playerid);
	PlayerData[playerid][pMoney] -= count;
	GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
	format(convert, sizeof(convert), "~r~-$%d", count);
	GameTextForPlayer(playerid, convert, 5000, 1);
	UpdateDatabase("users", "money", IntToStr(PlayerData[playerid][pMoney]), "id", IntToStr(PlayerData[playerid][pID]));
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
