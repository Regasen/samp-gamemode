void PlayerKick(playerid)
{
	Kick(playerid);
}

#define Kick(%0) SetTimerEx("PlayerKick", 50, false, "i", %0)