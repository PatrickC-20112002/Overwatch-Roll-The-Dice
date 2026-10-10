variables
{
	player:
		0: Dice
		1: IsEffectActive
		2: EffectTimer
		3: RollCd
		4: Data1
		5: Data2
		6: Data3
		7: Data4
}

disabled rule("Spirit Bomb Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 35;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 15;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Please, lend me some of your energy."));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Spirit Bomb", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Spirit Bomb", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Aqua), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

disabled rule("Spirit Bomb")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 35;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Set Status(Event Player, Null, Rooted, 9999);
		Set Status(Event Player, Null, Phased Out, 9999);
		Wait(0.250, Ignore Condition);
		Play Effect(All Players(All Teams), Sombra Translocating Material Effect, Color(White), Event Player, 200);
		Set Gravity(Event Player, 0);
		Start Accelerating(Event Player, Up, 1, 25, To World, Direction Rate and Max Speed);
		Wait(2, Ignore Condition);
		Event Player.Data1 = 0;
		Event Player.Data3 = Vector(X Component Of(Position Of(Event Player)), Y Component Of(Position Of(Event Player)) + 15,
			Z Component Of(Position Of(Event Player)));
		Create Effect(All Players(All Teams), Sphere, Color(Aqua), Event Player.Data3, Event Player.Data1, Position and Radius);
		Event Player.Data2 = Last Created Entity;
		Stop Accelerating(Event Player);
		Apply Impulse(Event Player, Down, Vertical Speed Of(Event Player), To World, Incorporate Contrary Motion);
		Wait(0.250, Ignore Condition);
		Create Effect(All Players(All Teams), Echo Focusing Beam Sound, Color(Aqua), Event Player, 200, Position and Radius);
		Event Player.Data4 = Last Created Entity;
		Chase Player Variable Over Time(Event Player, Data1, 10, 5, Destination and Duration);
		Wait(4, Ignore Condition);
		Destroy Effect(Event Player.Data4);
		Wait(1, Ignore Condition);
		Set Gravity(Event Player, 100);
		Clear Status(Event Player, Phased Out);
		Clear Status(Event Player, Rooted);
		Chase Player Variable Over Time(Event Player, Data3, Ray Cast Hit Position(Position Of(Event Player), Eye Position(Event Player)
			+ Facing Direction Of(Event Player) * 100, Null, Null, False), 5, None);
		Wait(5, Ignore Condition);
		Play Effect(All Players(All Teams), DVa Self Destruct Explosion Sound, Color(White), Event Player, 200);
		Damage(Filtered Array(Players Within Radius(Event Player.Data3, 10, All Teams, Off), Current Array Element != Event Player),
			Event Player, 500);
		Destroy Effect(Event Player.Data2);
		Wait(1, Ignore Condition);
		Event Player.Data1 = 0;
		Event Player.Data3 = 0;
		Event Player.Data2 = 0;
		Event Player.Data4 = 0;
	}
}

disabled rule("Spirit Bomb Damage")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 35;
		Event Player.IsEffectActive == True;
		Event Player.Data1 > 0;
	}

	actions
	{
		Damage(Filtered Array(Players Within Radius(Event Player.Data3, 10, All Teams, Off), Current Array Element != Event Player),
			Event Player, 25);
		Wait(0.100, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("Init")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Has Spawned(Event Player) == True;
	}

	actions
	{
		Event Player.Dice = Empty Array;
		Wait Until(Has Spawned(Event Player), 99999);
		Wait(1, Ignore Condition);
		Big Message(Event Player, Custom String("Press Interact to roll the dice!"));
	}
}

rule("Roll The Dice")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Is Button Held(Event Player, Button(Interact)) == True;
		Is Alive(Event Player) == True;
		Event Player.IsEffectActive == False;
		Event Player.RollCd == 0;
	}

	actions
	{
		disabled Event Player.Dice = 38;
		Event Player.Dice = Random Integer(1, 39);
		Wait Until(Event Player.IsEffectActive == True, 99999);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Event Player.RollCd = 10;
		Chase Player Variable At Rate(Event Player, RollCd, 0, 1, Destination and Rate);
		Wait Until(Event Player.RollCd == 0, 99999);
		Play Effect(Event Player, Ring Explosion Sound, Color(White), Event Player, 100);
		Big Message(Event Player, Custom String("The dice is ready!"));
	}
}

rule("Roll The Dice Cd")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Is Button Held(Event Player, Button(Interact)) == True;
		Is Alive(Event Player) == True;
		Event Player.IsEffectActive == False;
		Event Player.RollCd > 0;
	}

	actions
	{
		Small Message(Event Player, Custom String("{0}s cd", Round To Integer(Event Player.RollCd, Up)));
	}
}

rule("Unkillable Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 1;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 10;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Unkillable"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Unkillable", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Unkillable: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(White), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Unkillable")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 1;
	}

	actions
	{
		Set Status(Event Player, Null, Unkillable, 9999);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Clear Status(Event Player, Unkillable);
	}
}

rule("Toxic Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 2;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Toxic"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String("{0}{1} rolled Toxic",
			Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Toxic: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Red), Color(White), Color(White), Visible To and String, Default Visibility);
		Create Effect(All Players(All Teams), Sphere, Color(Red), Event Player, 6.500, Visible To Position and Radius);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
		Destroy Effect(Last Created Entity);
	}
}

rule("Toxic")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 2;
	}

	actions
	{
		Wait(0.250, Ignore Condition);
		Damage(Filtered Array(Players Within Radius(Event Player, 6.500, All Teams, Surfaces And Enemy Barriers),
			Current Array Element != Event Player), Event Player, 15);
		Loop If(Event Player.IsEffectActive == True);
	}
}

rule("Beat Drop Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 3;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Beat Drop"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Beat Drop", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Beat Drop: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Green), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Beat Drop")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 3;
	}

	actions
	{
		Apply Impulse(Event Player, Up, 10, To World, Cancel Contrary Motion);
		Wait(0.500, Ignore Condition);
		Wait Until(Is On Ground(Event Player), 5);
		Play Effect(Event Player, Doomfist Meteor Strike Impact Sound, Color(White), Event Player, 200);
		Add Health Pool To Player(Event Player, Health, 750, False, True);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Remove Health Pool From Player(Last Created Health Pool);
	}
}

rule("Increased Speed Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 4;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Increased Speed"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Increased Speed", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Increased Speed: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null,
			Top, 0, Color(White), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Increased Speed")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 4;
	}

	actions
	{
		Set Move Speed(Event Player, 200);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Set Move Speed(Event Player, 100);
	}
}

rule("idclip Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 5;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Noclip"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String("{0}{1} rolled Noclip",
			Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Noclip: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Sky Blue), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.Dice = Empty Array;
		Event Player.IsEffectActive = False;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Nanoboost Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 7;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Nanoboost"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Nanoboost", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Nanoboost: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Blue), Color(White), Color(White), Visible To and String, Default Visibility);
		Create Effect(All Players(All Teams), Ana Nano Boosted Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.Data1 = Last Created Entity;
		Create Effect(All Players(All Teams), Ana Nano Boosted Sound, Color(White), Event Player, 100, Visible To Position and Radius);
		Event Player.Data2 = Last Created Entity;
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
		Destroy Effect(Event Player.Data1);
		Destroy Effect(Event Player.Data2);
		Event Player.Data1 = 0;
		Event Player.Data2 = 0;
	}
}

rule("Nanoboost")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 7;
	}

	actions
	{
		Set Damage Dealt(Event Player, 150);
		Set Damage Received(Event Player, 50);
		Heal(Event Player, Null, 250);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Set Damage Dealt(Event Player, 100);
		Set Damage Received(Event Player, 100);
	}
}

rule("idclip")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 5;
	}

	actions
	{
		Disable Movement Collision With Environment(Event Player, False);
		Disable Movement Collision With Players(Event Player);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Enable Movement Collision With Environment(Event Player);
		Enable Movement Collision With Players(Event Player);
	}
}

rule("Low Gravity Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 6;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Low Gravity"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Low Gravity", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Low Gravity: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top,
			0, Color(Purple), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Low Gravity")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 6;
	}

	actions
	{
		Set Gravity(Event Player, 25);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Set Gravity(Event Player, 100);
	}
}

rule("Invisibility Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 8;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Invisibility"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Invisibility", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Invisibility: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top,
			0, Color(Gray), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.Dice = Empty Array;
		Event Player.IsEffectActive = False;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Invisibility")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 8;
	}

	actions
	{
		Set Invisible(Event Player, All);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Set Invisible(Event Player, None);
	}
}

rule("Equalized Buff Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 9;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Equalized Buff"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Equalized Buff", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Equalized Buff: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null,
			Top, 0, Color(Rose), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Equalized Buff")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 9;
	}

	actions
	{
		Set Damage Dealt(Event Player, 200);
		Set Damage Received(Event Player, 150);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Set Damage Dealt(Event Player, 100);
		Set Damage Received(Event Player, 100);
	}
}

rule("Bottomless Clip Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 10;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Bottomless Clip"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Bottomless Clip", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Bottomless Clip: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null,
			Top, 0, Color(Purple), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Bottomless Clip Clip 0")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 10;
		Event Player.IsEffectActive == True;
		Ammo(Event Player, 0) <= Max Ammo(Event Player, 0);
	}

	actions
	{
		Set Ammo(Event Player, 0, 500);
	}
}

rule("Bottomless Clip Clip 1")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 10;
		Event Player.IsEffectActive == True;
		Ammo(Event Player, 1) <= Max Ammo(Event Player, 1);
	}

	actions
	{
		Set Ammo(Event Player, 1, 500);
	}
}

rule("Scary Bullets Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 11;
	}

	actions
	{
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Scary Bullets"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Scary Bullets", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Scary Bullets: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top,
			0, Color(Orange), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Scary Bullets")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 11;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Set Status(Victim, Event Player, Stunned, 0.250);
	}
}

rule("Resistance Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 12;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Resistance"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Resistance", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Resistance: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Orange), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Resistance")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 12;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Set Damage Received(Event Player, 50);
		Set Knockback Received(Event Player, 0);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Set Damage Received(Event Player, 100);
		Set Knockback Received(Event Player, 100);
	}
}

rule("Snail Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 13;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 10;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Snail"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String("{0}{1} rolled Snail",
			Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Snail: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Violet), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Destroy HUD Text(Last Text ID);
		Event Player.Dice = Empty Array;
	}
}

rule("Snail")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 13;
	}

	actions
	{
		Set Move Speed(Event Player, 50);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Set Move Speed(Event Player, 100);
	}
}

rule("Frozen Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 14;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 5;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Frozen"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String("{0}{1} rolled Frozen",
			Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Frozen: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Sky Blue), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Destroy HUD Text(Last Text ID);
		Event Player.Dice = Empty Array;
	}
}

rule("Frozen")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 14;
	}

	actions
	{
		Set Status(Event Player, Null, Frozen, 9999);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Clear Status(Event Player, Frozen);
	}
}

rule("Firework Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 15;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 3;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Firework"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Firework", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Firework", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0, Color(
			White), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Debuff Impact Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Destroy HUD Text(Last Text ID);
		Event Player.Dice = Empty Array;
	}
}

rule("Firework")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 15;
	}

	actions
	{
		Apply Impulse(Event Player, Up, 45, To World, Cancel Contrary Motion);
		Wait(1, Ignore Condition);
		Damage(Event Player, Null, 100);
	}
}

rule("Timebomb Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 16;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 5;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Timebomb"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Timebomb", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Timebomb: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Red), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Debuff Impact Sound, Color(White), Event Player, 100);
		Create Effect(All Players(All Teams), Sphere, Color(Gray), Event Player, 1, Visible To Position and Radius);
		Event Player.Data1 = Last Created Entity;
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Destroy HUD Text(Last Text ID);
		Destroy Effect(Event Player.Data1);
		Event Player.Data1 = 0;
		Event Player.Dice = Empty Array;
	}
}

rule("Timebomb")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 16;
	}

	actions
	{
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Kill(Players Within Radius(Event Player, 30, All Teams, Surfaces And Enemy Barriers), Event Player);
		Create Effect(All Players(All Teams), Sphere, Color(Yellow), Event Player, 30, Visible To Position and Radius);
		Event Player.Data2 = Last Created Entity;
		Wait(0.500, Ignore Condition);
		Destroy Effect(Event Player.Data2);
		Event Player.Data2 = 0;
	}
}

rule("Flamethrower Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 17;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Flamethrower"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Flamethrower", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Flamethrower: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top,
			0, Color(Orange), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Destroy HUD Text(Last Text ID);
		Event Player.Dice = Empty Array;
	}
}

rule("Flamethrower Primary")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 17;
		Event Player.IsEffectActive == True;
		Event Ability == Button(Primary Fire);
	}

	actions
	{
		Start Damage Over Time(Victim, Event Player, 3, 10);
		Set Status(Victim, Event Player, Burning, 3);
	}
}

rule("Flamethrower Secondary")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 17;
		Event Player.IsEffectActive == True;
		Event Ability == Button(Secondary Fire);
	}

	actions
	{
		Start Damage Over Time(Victim, Event Player, 3, 10);
		Set Status(Victim, Event Player, Burning, 3);
	}
}

rule("Flamethrower Ability 1")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 17;
		Event Player.IsEffectActive == True;
		Event Ability == Button(Ability 1);
	}

	actions
	{
		Start Damage Over Time(Victim, Event Player, 3, 10);
		Set Status(Victim, Event Player, Burning, 3);
	}
}

rule("Flamethrower Ability 2")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 17;
		Event Player.IsEffectActive == True;
		Event Ability == Button(Ability 2);
	}

	actions
	{
		Start Damage Over Time(Victim, Event Player, 3, 10);
		Set Status(Victim, Event Player, Burning, 3);
	}
}

rule("Flamethrower Ultimate")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 17;
		Event Player.IsEffectActive == True;
		Event Ability == Button(Ultimate);
	}

	actions
	{
		Start Damage Over Time(Victim, Event Player, 3, 10);
		Set Status(Victim, Event Player, Burning, 3);
	}
}

rule("Hell's Reach Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 18;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 10;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Hell's Reach"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Hell's Reach", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Hell's Reach", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Red), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Destroy HUD Text(Last Text ID);
		Event Player.Dice = Empty Array;
	}
}

rule("Hell's Reach")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 18;
	}

	actions
	{
		Create Dummy Bot(Hero(Torbjörn), All Teams, -1, Random Value In Array(Spawn Points(All Teams)), Facing Direction Of(Event Player));
		Disable Movement Collision With Environment(Last Created Entity, True);
		Disable Movement Collision With Players(Last Created Entity);
		Set Status(Last Created Entity, Null, Phased Out, 9999);
		Set Invisible(Last Created Entity, All);
		Wait(0.250, Ignore Condition);
		Attach Players(Last Created Entity, Event Player, Vector(0, 5, Facing Direction Of(Event Player) + 1));
		Start Facing(Last Created Entity, Up, 10000, To World, Direction and Turn Rate);
		Wait(1, Ignore Condition);
		Set Ultimate Charge(Last Created Entity, 100);
		Start Holding Button(Last Created Entity, Button(Ultimate));
		Start Holding Button(Last Created Entity, Button(Primary Fire));
		Wait(1, Ignore Condition);
		Wait Until(Is Using Ultimate(Last Created Entity) == False, 99999);
		Stop Holding Button(Last Created Entity, Button(Primary Fire));
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Destroy Dummy Bot(All Teams, Slot Of(Last Created Entity));
	}
}

rule("Half Health Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 19;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 3;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Half Health"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Half Health", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Half Health", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Orange), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Destroy HUD Text(Last Text ID);
		Event Player.Dice = Empty Array;
	}
}

rule("Half Health")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 19;
	}

	actions
	{
		Set Player Health(Event Player, Max Health(Event Player) / 2);
	}
}

rule("Infinite Jump Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 20;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Infinite Jump"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Infinite Jump", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Infinite Jump: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top,
			0, Color(Lime Green), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		"Variables"
		Event Player.Dice = Empty Array;
		Event Player.IsEffectActive = False;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Infinite Jump")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 20;
		Is Button Held(Event Player, Button(Jump)) == True;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Apply Impulse(Event Player, Up, 10, To World, Cancel Contrary Motion);
	}
}

rule("Powerful Hits Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 21;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Powerful Hits"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Powerful Hits", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Powerful Hits: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top,
			0, Color(Orange), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Powerful Hits")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 21;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Set Damage Dealt(Event Player, 175);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Set Damage Dealt(Event Player, 100);
	}
}

rule("Knockback Hits Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 22;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Knockback Hits"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Knockback Hits", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Knockback Hits: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null,
			Top, 0, Color(White), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Knockback Hits")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 22;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Apply Impulse(Victim, Direction Towards(Event Player, Victim), 15, To World, Cancel Contrary Motion);
		Apply Impulse(Victim, Up, 3, To World, Cancel Contrary Motion);
	}
}

rule("Big Man Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 23;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Big Man"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String("{0}{1} rolled Big Man",
			Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Big Man: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Blue), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Big Man")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 23;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Set Max Health(Event Player, 200);
		Set Damage Received(Event Player, 50);
		Wait(0.100, Ignore Condition);
		Set Player Health(Event Player, Health(Event Player) * 2);
		Start Scaling Player(Event Player, 2, True);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Stop Scaling Player(Event Player);
		Set Player Health(Event Player, Health(Event Player) / 2);
		Wait(0.100, Ignore Condition);
		Set Max Health(Event Player, 100);
		Set Damage Received(Event Player, 100);
	}
}

rule("Small Man Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 24;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Small Man"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Small Man", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Small Man: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Yellow), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Small Man")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 24;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Set Max Health(Event Player, 50);
		Set Player Health(Event Player, Health(Event Player) / 2);
		Wait(0.100, Ignore Condition);
		Start Scaling Player(Event Player, 0.250, True);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Stop Scaling Player(Event Player);
		Set Max Health(Event Player, 100);
		Wait(0.100, Ignore Condition);
		Set Player Health(Event Player, Health(Event Player) * 2);
	}
}

rule("Eye for an Eye Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 25;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Eye for an Eye"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Eye for an Eye", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Eye for an Eye: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null,
			Top, 0, Color(Black), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Eye for an Eye Damage")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 25;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Damage(Event Player, Null, Event Damage);
	}
}

rule("Eye for an Eye Reflect")
{
	event
	{
		Player Took Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 25;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Damage(Attacker, Null, Event Damage);
	}
}

rule("Heroes Never Die Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 26;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 25;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Heroes Never Die"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Heroes Never Die", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Heroes Never Die: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null,
			Top, 0, Color(Yellow), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Heroes Never Die")
{
	event
	{
		Player Died;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 26;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Resurrect(Event Player);
		Event Player.EffectTimer = 0;
		Set Status(Event Player, Null, Phased Out, 1);
	}
}

rule("Mercy Pocket Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 27;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Mercy Pocket"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Mercy Pocket", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Mercy Pocket: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top,
			0, Color(Yellow), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
		Set Damage Dealt(Event Player, 100);
		Stop Heal Over Time(Last Heal Over Time ID);
		Destroy Effect(Event Player.Data1);
		Destroy Effect(Event Player.Data2);
		Event Player.Data1 = 0;
		Event Player.Data2 = 0;
	}
}

rule("Mercy Pocket Damage Boost")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 27;
		Event Player.IsEffectActive == True;
		Health(Event Player) >= Max Health(Event Player) / 100 * 75;
	}

	actions
	{
		Destroy Effect(Event Player.Data1);
		Destroy Effect(Event Player.Data2);
		Stop Heal Over Time(Last Heal Over Time ID);
		Create Effect(All Players(All Teams), Mercy Damage Boosted Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.Data1 = Last Created Entity;
		Create Effect(All Players(All Teams), Mercy Damage Boosted Sound, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.Data2 = Last Created Entity;
		Set Damage Dealt(Event Player, 125);
	}
}

rule("Mercy Pocket Heal Boost")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 27;
		Event Player.IsEffectActive == True;
		Health(Event Player) < Max Health(Event Player) / 100 * 75;
	}

	actions
	{
		Destroy Effect(Event Player.Data1);
		Destroy Effect(Event Player.Data2);
		Set Damage Dealt(Event Player, 100);
		Create Effect(All Players(All Teams), Heal Target Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.Data1 = Last Created Entity;
		Create Effect(All Players(All Teams), Mercy Heal Beam Sound, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.Data2 = Last Created Entity;
		Start Heal Over Time(Event Player, Event Player, 9999, 55);
	}
}

rule("Siphon Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 28;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 25;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Siphon"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String("{0}{1} rolled Siphon",
			Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Siphon: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Yellow), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
		Remove All Health Pools From Player(Event Player);
	}
}

rule("Siphon")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 28;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Heal(Event Player, Event Player, Event Damage);
	}
}

rule("Forced Ult Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 29;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 3;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Forced Ult"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Forced Ult", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Forced Ult", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Blue), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Forced Ult")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 29;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Event Player.Data1 = Ultimate Charge Percent(Event Player);
		Set Ultimate Charge(Event Player, 100);
		Wait(0.500, Ignore Condition);
		Start Holding Button(Event Player, Button(Ultimate));
		Wait Until(Is Using Ultimate(Event Player), 99999);
		Stop Holding Button(Event Player, Button(Ultimate));
		Wait Until(!Is Using Ultimate(Event Player), 99999);
		Set Ultimate Charge(Event Player, Event Player.Data1);
		Event Player.Data1 = 0;
	}
}

rule("Dance or you die Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 30;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 3;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Dance or you die"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Dance or you die", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Dance or you die: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null,
			Top, 0, Color(Blue), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Dance or you die")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 30;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Wait Until(Event Player.IsEffectActive == False, 99999);
		If(Is Communicating Any Emote(Event Player));
			Abort;
		End;
		If(!Is Communicating Any Emote(Event Player));
			Kill(Event Player, Null);
		End;
	}
}

rule("Fast Melee Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 31;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Fast Melee"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Fast Melee", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Fast Melee: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Gray), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Fast Melee")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 31;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Set Move Speed(Event Player, 200);
		Set Damage Dealt(Event Player, 500);
		Disallow Button(Event Player, Button(Primary Fire));
		Disallow Button(Event Player, Button(Secondary Fire));
		Disallow Button(Event Player, Button(Ability 1));
		Disallow Button(Event Player, Button(Ability 2));
		Disallow Button(Event Player, Button(Ultimate));
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Allow Button(Event Player, Button(Primary Fire));
		Allow Button(Event Player, Button(Secondary Fire));
		Allow Button(Event Player, Button(Ability 1));
		Allow Button(Event Player, Button(Ability 2));
		Allow Button(Event Player, Button(Ultimate));
		Set Move Speed(Event Player, 100);
		Set Damage Dealt(Event Player, 100);
	}
}

rule("Yippee! Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 32;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 3;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Yippee!"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String("{0}{1} rolled Yippee!",
			Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Yippee!", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0, Color(
			White), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Yippee!")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 32;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Kill(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Event Player);
		Wait Until(Event Player.RollCd > 0, 99999);
		Event Player.RollCd = 1;
	}
}

rule("Jackpot Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 33;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Jackpot"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String("{0}{1} rolled Jackpot",
			Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Jackpot: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Yellow), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Jackpot")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 33;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Heal(Event Player, Event Player, 500);
		Set Ultimate Charge(Event Player, 100);
		Set Move Speed(Event Player, 200);
		Set Status(Event Player, Null, Invincible, 9999);
		Set Damage Dealt(Event Player, 250);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Set Move Speed(Event Player, 100);
		Set Damage Dealt(Event Player, 100);
		Clear Status(Event Player, Invincible);
	}
}

rule("High Tempo Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 34;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("High Tempo"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled High Tempo", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("High Tempo: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Green), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("High Tempo Ability 1")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 34;
		Event Player.IsEffectActive == True;
		Is Using Ability 1(Event Player) == True;
	}

	actions
	{
		Wait Until(!Is Using Ability 1(Event Player), 99999);
		Wait(0.500, Ignore Condition);
		Set Ability Cooldown(Event Player, Button(Ability 1), Ability Cooldown(Event Player, Button(Ability 1)) * 0.100);
	}
}

rule("High Tempo Ability 2")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 34;
		Event Player.IsEffectActive == True;
		Is Using Ability 2(Event Player) == True;
	}

	actions
	{
		Wait Until(!Is Using Ability 2(Event Player), 99999);
		Wait(0.500, Ignore Condition);
		Set Ability Cooldown(Event Player, Button(Ability 2), Ability Cooldown(Event Player, Button(Ability 2)) * 0.150);
	}
}

rule("High Tempo Secondary Fire")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 34;
		Event Player.IsEffectActive == True;
		Is Firing Secondary(Event Player) == True;
	}

	actions
	{
		Wait Until(!Is Firing Secondary(Event Player), 99999);
		Wait(0.500, Ignore Condition);
		Set Ability Cooldown(Event Player, Button(Secondary Fire), Ability Cooldown(Event Player, Button(Secondary Fire)) * 0.100);
	}
}

rule("Phlog Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 35;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Phlog"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String("{0}{1} rolled Phlog",
			Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Phlog: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Blue), Color(White), Color(White), Visible To and String, Default Visibility);
		Create Effect(All Players(All Teams), Echo Cloning Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.Data1 = Last Created Entity;
		Create Effect(All Players(All Teams), Echo Cloning Sound, Color(White), Event Player, 100, Visible To Position and Radius);
		Event Player.Data2 = Last Created Entity;
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
		Destroy Effect(Event Player.Data1);
		Destroy Effect(Event Player.Data2);
		Event Player.Data1 = 0;
		Event Player.Data2 = 0;
	}
}

rule("Phlog")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 35;
	}

	actions
	{
		Set Status(Event Player, Null, Invincible, 9999);
		Wait(0.016, Ignore Condition);
		Cancel Primary Action(Event Player);
		Communicate(Event Player, Emote Up);
		Communicate(Event Player, Emote Left);
		Communicate(Event Player, Emote Right);
		Communicate(Event Player, Emote Down);
		Wait(3, Ignore Condition);
		Wait Until(!Is Communicating Any Emote(Event Player), 99999);
		Clear Status(Event Player, Invincible);
		Set Damage Dealt(Event Player, 200);
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Set Damage Dealt(Event Player, 100);
	}
}

rule("Primal Rage Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 36;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 10;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Primal Rage"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Primal Rage", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Primal Rage: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top,
			0, Color(Red), Color(White), Color(White), Visible To and String, Default Visibility);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Primal Rage")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 36;
	}

	actions
	{
		Event Player.Data1 = Ultimate Charge Percent(Event Player);
		Event Player.Data2 = Hero Of(Event Player);
		Start Forcing Player To Be Hero(Event Player, Hero(Winston));
		Wait(1, Ignore Condition);
		Set Ultimate Charge(Event Player, 100);
		Wait(0.500, Ignore Condition);
		Start Holding Button(Event Player, Button(Ultimate));
		Wait Until(Is Using Ultimate(Event Player), 99999);
		Stop Holding Button(Event Player, Button(Ultimate));
		Wait Until(Event Player.IsEffectActive == False, 99999);
		Start Forcing Player To Be Hero(Event Player, Event Player.Data2);
		Stop Forcing Player To Be Hero(Event Player);
		Wait(0.250, Ignore Condition);
		Set Ultimate Charge(Event Player, Event Player.Data1);
		Event Player.Data1 = 0;
		Event Player.Data2 = 0;
	}
}

rule("Slow Tempo Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 37;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 15;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("High Tempo"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled High Tempo", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("High Tempo: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Green), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Slow Tempo Ability 1")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 37;
		Event Player.IsEffectActive == True;
		Is Using Ability 1(Event Player) == True;
	}

	actions
	{
		Wait Until(!Is Using Ability 1(Event Player), 99999);
		Wait(0.500, Ignore Condition);
		Set Ability Cooldown(Event Player, Button(Ability 1), Ability Cooldown(Event Player, Button(Ability 1)) * 1.500);
	}
}

rule("Slow Tempo Ability 2")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 37;
		Event Player.IsEffectActive == True;
		Is Using Ability 2(Event Player) == True;
	}

	actions
	{
		Wait Until(!Is Using Ability 2(Event Player), 99999);
		Wait(0.500, Ignore Condition);
		Set Ability Cooldown(Event Player, Button(Ability 2), Ability Cooldown(Event Player, Button(Ability 2)) * 1.500);
	}
}

rule("Slow Tempo Secondary Fire")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 37;
		Event Player.IsEffectActive == True;
		Is Firing Secondary(Event Player) == True;
	}

	actions
	{
		Wait Until(!Is Firing Secondary(Event Player), 99999);
		Wait(0.500, Ignore Condition);
		Set Ability Cooldown(Event Player, Button(Secondary Fire), Ability Cooldown(Event Player, Button(Secondary Fire)) * 1.500);
	}
}

rule("Bronze Menace Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 38;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 20;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Bronze Menace"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Bronze Menace", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Bronze Menace: {0}", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top,
			0, Custom Color(165, 42, 42, 255), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Set Aim Speed(Event Player, 50);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
		Set Aim Speed(Event Player, 100);
	}
}

rule("Bronze Menace")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 38;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Press Button(Event Player, Button(Ability 1));
		Press Button(Event Player, Button(Ability 2));
		Press Button(Event Player, Button(Ultimate));
		Press Button(Event Player, Button(Secondary Fire));
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("Forced Emote Text")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 39;
	}

	actions
	{
		"Timer"
		Event Player.EffectTimer = 3;
		Event Player.IsEffectActive = True;
		"Text"
		Big Message(Event Player, Custom String("Forced Emote"));
		Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
			"{0}{1} rolled Forced Emote", Hero Icon String(Hero Of(Event Player)), Event Player));
		Create HUD Text(Event Player, Custom String("Forced Emote", Round To Integer(Event Player.EffectTimer, Up)), Null, Null, Top, 0,
			Color(Blue), Color(White), Color(White), Visible To and String, Default Visibility);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Event Player, 100);
		"Timer Function"
		Chase Player Variable At Rate(Event Player, EffectTimer, 0, 1, Destination and Rate);
		Wait Until(Event Player.EffectTimer == 0, 99999);
		Event Player.IsEffectActive = False;
		Event Player.Dice = Empty Array;
		Destroy HUD Text(Last Text ID);
	}
}

rule("Forced Emote")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.Dice == 39;
		Event Player.IsEffectActive == True;
	}

	actions
	{
		Cancel Primary Action(Event Player);
		Communicate(Event Player, Emote Up);
		Communicate(Event Player, Emote Left);
		Communicate(Event Player, Emote Right);
		Communicate(Event Player, Emote Down);
		Wait Until(Event Player.RollCd > 0, 5);
		Event Player.RollCd = 5;
	}
}