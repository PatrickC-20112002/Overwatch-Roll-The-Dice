
# 🎲 Roll The Dice

**Roll The Dice (RTD)** is an Overwatch Workshop Deathmatch / Free-For-All game mode where players can roll the dice to receive one of over 100 random perks.

Each perk can help or hinder the player, ranging from simple stat modifications to entirely new abilities, hero transformations, unique mechanics and chaotic effects.

Inspired by the **Roll the Dice** server plugin from *Team Fortress 2*, RTD expands on the original concept with mechanics designed specifically around Overwatch and its heroes.

## Current Version

| | |
| --- | --- |
| **Stable Version** | V2.4 |
| **Workshop Code** | `4C92C` |
| **Available Perks** | 145 |
| **Game Mode** | Deathmatch / Free-For-All |
| **Development Version** | V2.5 |

**V2.5 is currently in development**, with 146 perks implemented so far.

The `main` branch contains the current stable version, while the `dev` branch contains ongoing development.

## How to Play

1. Launch Overwatch.
2. Create a Custom Game.
3. Open the Custom Game settings.
4. Select **Import Code**.
5. Enter the Workshop code: `4C92C`.
6. Start the game.
7. Press **Interact** to roll the dice.

A random perk will activate, granting either a positive, negative or unpredictable effect.

Once the perk expires, players must wait for their Dice Cooldown before rolling again.

## Features

- Over **145 unique perks**.
- Randomised positive, negative and chaotic effects.
- Custom abilities, attacks and mechanics.
- Hero transformations and ability modifications.
- Custom visual and sound effects.
- Unique perk interactions.
- Custom HUD elements and progress bars.
- Configurable Favourite Perk system.
- Duration Modifier system.
- Regular perk additions, reworks and improvements.

### Example Perks

- **GodMode**
- **Noclip**
- **Pocket Mercy**
- **One Punch Man**
- **A-Train**
- **The Floor Is Lava**
- **Sorcerer's Jackpot**
- **Black Flash**
- **Cursed Swap**
- **Hamon**

Some perks have simple effects, while others introduce completely new gameplay mechanics.

## Favourite Perk System

Roll The Dice includes an optional **Favourite Perk** system.

Before playing, players can select a perk as their favourite.

Each time they roll the dice, there is a configurable chance that their favourite perk will be selected instead of a completely random perk.

### Features

- Select a favourite perk before entering the game.
- Navigate the perk list using Primary Fire, Secondary Fire and abilities.
- Configure the probability of rolling a favourite.
- Change your favourite while dead or in the spawn room.
- Disable the system entirely through Workshop settings.

Certain perks cannot be selected as favourites because of their mechanics or potential impact on gameplay.

## Duration Modifier System

Some perks can modify the duration of future perks.

**Double Duration** and **Halved Duration** apply modifiers that can stack and affect the next applicable perk.

Players can view their current pending modifier through the custom HUD.

This system was introduced in **V2.4**.

## Development

Roll The Dice is developed using the **Overwatch Workshop**, **OverPy** and **Visual Studio Code**.

The repository contains the project's source code and version history.

### Branches

| Branch | Purpose |
| --- | --- |
| `main` | Current stable/public release |
| `dev` | Active development and testing |

Development changes are made on `dev`.

Once a new version has been completed and tested, the stable changes can be merged into `main`.

### Version Management

- Work on new perks, improvements and bug fixes in `dev`.
- Keep unfinished changes out of `main`.
- Update the changelog when preparing a new release.
- Merge tested releases into `main`.
- Use Git tags to preserve released versions.

### Version History

Previous versions preserved through Git include:

- V2.2.6
- V2.2.7
- V2.3.0
- V2.4

Earlier versions, including Legacy and Celebration Edition, are also preserved in the project's history.

## Releases

### V2.4 — Current Stable Version

**Workshop Code:** `4C92C`

**145 available perks**

Major changes include:

- Extensive perk optimisations.
- New Duration Modifier system.
- New perks.
- Perk reworks and balance changes.
- Bug fixes and general improvements.

See [CHANGELOG.md](CHANGELOG.md) for the full V2.4 patch notes.

### V2.5 — In Development

V2.5 is currently being developed on the `dev` branch.

Development includes:

- New perks.
- Existing perk reworks.
- Bug fixes.
- Gameplay improvements.
- Further optimisation.

**146 perks are currently implemented.**

V2.5 patch notes will be published when the update is ready for release.

## Inspiration

Roll The Dice was originally inspired by the **Roll the Dice (RTD)** server plugin from *Team Fortress 2*, which grants players random effects that can either benefit or disadvantage them.

This Overwatch version is an independent Workshop implementation, expanding the concept with a large collection of custom perks and systems.

## Credits

**Created by Patrick Carroll / MarkedDerp**

Roll The Dice is an unofficial fan-made Overwatch Workshop project.

Overwatch and its characters, names and related assets are the property of Blizzard Entertainment.

This project is not affiliated with or endorsed by Blizzard Entertainment.