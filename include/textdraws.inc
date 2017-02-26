new Text:TD_PinCode[13];
new PlayerText:TD_PinCodeDisplay[MAX_PLAYERS];

stock LoadingPlayerTextDraws(playerid)
{

	TD_PinCodeDisplay[playerid] = CreatePlayerTextDraw(playerid, 278.301361, 187.249984, "");
	PlayerTextDrawLetterSize(playerid, TD_PinCodeDisplay[playerid], 0.340980, 1.389166);
	PlayerTextDrawAlignment(playerid, TD_PinCodeDisplay[playerid], 1);
	PlayerTextDrawColor(playerid, TD_PinCodeDisplay[playerid], -1);
	PlayerTextDrawSetShadow(playerid, TD_PinCodeDisplay[playerid], 0);
	PlayerTextDrawSetOutline(playerid, TD_PinCodeDisplay[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, TD_PinCodeDisplay[playerid], 51);
	PlayerTextDrawFont(playerid, TD_PinCodeDisplay[playerid], 2);
	PlayerTextDrawSetProportional(playerid, TD_PinCodeDisplay[playerid], 1);

	return true;
}

stock LoadingTextDraws()
{
	 
	TD_PinCode[0] = TextDrawCreate(363.698394, 159.583343, "usebox");
	TextDrawLetterSize(TD_PinCode[0], 0.000000, 2.146298);
	TextDrawTextSize(TD_PinCode[0], 275.364562, 0.000000);
	TextDrawAlignment(TD_PinCode[0], 1);
	TextDrawColor(TD_PinCode[0], 0);
	TextDrawUseBox(TD_PinCode[0], true);
	TextDrawBoxColor(TD_PinCode[0], -218959326);
	TextDrawSetShadow(TD_PinCode[0], 0);
	TextDrawSetOutline(TD_PinCode[0], 0);
	TextDrawFont(TD_PinCode[0], 0);
	 
	TD_PinCode[1] = TextDrawCreate(363.229797, 188.166656, "usebox");
	TextDrawLetterSize(TD_PinCode[1], 0.000000, 1.368520);
	TextDrawTextSize(TD_PinCode[1], 274.427459, 0.000000);
	TextDrawAlignment(TD_PinCode[1], 1);
	TextDrawColor(TD_PinCode[1], 0);
	TextDrawUseBox(TD_PinCode[1], true);
	TextDrawBoxColor(TD_PinCode[1], -218959326);
	TextDrawSetShadow(TD_PinCode[1], 0);
	TextDrawSetOutline(TD_PinCode[1], 0);
	TextDrawFont(TD_PinCode[1], 0);
	 
	TD_PinCode[2] = TextDrawCreate(281.258739, 161.583389, "PIN-CODE");
	TextDrawLetterSize(TD_PinCode[2], 0.429999, 1.400000);
	TextDrawAlignment(TD_PinCode[2], 1);
	TextDrawColor(TD_PinCode[2], -1);
	TextDrawUseBox(TD_PinCode[2], true);
	TextDrawBoxColor(TD_PinCode[2], 0);
	TextDrawSetShadow(TD_PinCode[2], 0);
	TextDrawSetOutline(TD_PinCode[2], -1);
	TextDrawBackgroundColor(TD_PinCode[2], 51);
	TextDrawFont(TD_PinCode[2], 2);
	TextDrawSetProportional(TD_PinCode[2], 1);
	 
	TD_PinCode[3] = TextDrawCreate(277.364379, 218.166656, "1");
	TextDrawLetterSize(TD_PinCode[3], 0.665988, 2.160001);
	TextDrawAlignment(TD_PinCode[3], 1);
	TextDrawColor(TD_PinCode[3], -1);
	TextDrawSetShadow(TD_PinCode[3], 0);
	TextDrawSetOutline(TD_PinCode[3], -1);
	TextDrawBackgroundColor(TD_PinCode[3], 51);
	TextDrawFont(TD_PinCode[3], 3);
	TextDrawSetProportional(TD_PinCode[3], 1);
	 
	TD_PinCode[4] = TextDrawCreate(313.440856, 218.166748, "2");
	TextDrawLetterSize(TD_PinCode[4], 0.593367, 2.095832);
	TextDrawAlignment(TD_PinCode[4], 1);
	TextDrawColor(TD_PinCode[4], -1);
	TextDrawSetShadow(TD_PinCode[4], 0);
	TextDrawSetOutline(TD_PinCode[4], -1);
	TextDrawBackgroundColor(TD_PinCode[4], 51);
	TextDrawFont(TD_PinCode[4], 3);
	TextDrawSetProportional(TD_PinCode[4], 1);
	 
	TD_PinCode[5] = TextDrawCreate(349.048950, 218.750030, "3");
	TextDrawLetterSize(TD_PinCode[5], 0.553074, 2.084167);
	TextDrawAlignment(TD_PinCode[5], 1);
	TextDrawColor(TD_PinCode[5], -1);
	TextDrawSetShadow(TD_PinCode[5], 0);
	TextDrawSetOutline(TD_PinCode[5], 1);
	TextDrawBackgroundColor(TD_PinCode[5], 51);
	TextDrawFont(TD_PinCode[5], 3);
	TextDrawSetProportional(TD_PinCode[5], 1);
	 
	TD_PinCode[6] = TextDrawCreate(277.833343, 249.666610, "4");
	TextDrawLetterSize(TD_PinCode[6], 0.535270, 2.154166);
	TextDrawAlignment(TD_PinCode[6], 1);
	TextDrawColor(TD_PinCode[6], -1);
	TextDrawSetShadow(TD_PinCode[6], 0);
	TextDrawSetOutline(TD_PinCode[6], 1);
	TextDrawBackgroundColor(TD_PinCode[6], 51);
	TextDrawFont(TD_PinCode[6], 3);
	TextDrawSetProportional(TD_PinCode[6], 1);
	 
	TD_PinCode[7] = TextDrawCreate(313.440582, 250.249938, "5");
	TextDrawLetterSize(TD_PinCode[7], 0.558228, 2.159999);
	TextDrawAlignment(TD_PinCode[7], 1);
	TextDrawColor(TD_PinCode[7], -1);
	TextDrawUseBox(TD_PinCode[7], true);
	TextDrawBoxColor(TD_PinCode[7], 0);
	TextDrawSetShadow(TD_PinCode[7], 0);
	TextDrawSetOutline(TD_PinCode[7], 1);
	TextDrawBackgroundColor(TD_PinCode[7], 51);
	TextDrawFont(TD_PinCode[7], 3);
	TextDrawSetProportional(TD_PinCode[7], 1);
	 
	TD_PinCode[8] = TextDrawCreate(349.048339, 249.083282, "6");
	TextDrawLetterSize(TD_PinCode[8], 0.525900, 2.125001);
	TextDrawAlignment(TD_PinCode[8], 1);
	TextDrawColor(TD_PinCode[8], -1);
	TextDrawSetShadow(TD_PinCode[8], 0);
	TextDrawSetOutline(TD_PinCode[8], 1);
	TextDrawBackgroundColor(TD_PinCode[8], 51);
	TextDrawFont(TD_PinCode[8], 3);
	TextDrawSetProportional(TD_PinCode[8], 1);
	 
	TD_PinCode[9] = TextDrawCreate(279.238647, 280.583221, "7");
	TextDrawLetterSize(TD_PinCode[9], 0.529648, 1.961667);
	TextDrawAlignment(TD_PinCode[9], 1);
	TextDrawColor(TD_PinCode[9], -1);
	TextDrawSetShadow(TD_PinCode[9], 0);
	TextDrawSetOutline(TD_PinCode[9], 1);
	TextDrawBackgroundColor(TD_PinCode[9], 51);
	TextDrawFont(TD_PinCode[9], 3);
	TextDrawSetProportional(TD_PinCode[9], 1);
	 
	TD_PinCode[10] = TextDrawCreate(313.440765, 279.999938, "8");
	TextDrawLetterSize(TD_PinCode[10], 0.538081, 2.008333);
	TextDrawAlignment(TD_PinCode[10], 1);
	TextDrawColor(TD_PinCode[10], -1);
	TextDrawUseBox(TD_PinCode[10], true);
	TextDrawBoxColor(TD_PinCode[10], 0);
	TextDrawSetShadow(TD_PinCode[10], 0);
	TextDrawSetOutline(TD_PinCode[10], 1);
	TextDrawBackgroundColor(TD_PinCode[10], 51);
	TextDrawFont(TD_PinCode[10], 3);
	TextDrawSetProportional(TD_PinCode[10], 1);
	 
	TD_PinCode[11] = TextDrawCreate(349.048248, 281.166625, "9");
	TextDrawLetterSize(TD_PinCode[11], 0.548389, 2.113333);
	TextDrawAlignment(TD_PinCode[11], 1);
	TextDrawColor(TD_PinCode[11], -1);
	TextDrawUseBox(TD_PinCode[11], true);
	TextDrawBoxColor(TD_PinCode[11], 0);
	TextDrawSetShadow(TD_PinCode[11], 0);
	TextDrawSetOutline(TD_PinCode[11], 1);
	TextDrawBackgroundColor(TD_PinCode[11], 51);
	TextDrawFont(TD_PinCode[11], 3);
	TextDrawSetProportional(TD_PinCode[11], 1);
	 
	TD_PinCode[12] = TextDrawCreate(345.769042, 303.333343, "OK");
	TextDrawLetterSize(TD_PinCode[12], 0.462181, 2.113335);
	TextDrawAlignment(TD_PinCode[12], 1);
	TextDrawColor(TD_PinCode[12], -1);
	TextDrawSetShadow(TD_PinCode[12], 0);
	TextDrawSetOutline(TD_PinCode[12], 1);
	TextDrawBackgroundColor(TD_PinCode[12], 51);
	TextDrawFont(TD_PinCode[12], 3);
	TextDrawSetProportional(TD_PinCode[12], 1);

	for(new i = 0; i < sizeof(TD_PinCode); i++) 
	{
		if(i == 0 || i >= 3 && i <= 12) TextDrawSetSelectable(TD_PinCode[i], true);
	}
}