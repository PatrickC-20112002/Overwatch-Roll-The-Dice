# Roll The Dice Changelog

Release notes for **Roll The Dice (RTD)**, listed from newest to oldest.

- [V2.5](#v25)
- [V2.4](#v24)

---

## V2.5

### General

- D.Mon has been enabled.
- Doctrine has been enabled.
- Increased the total number of available perks from **145 to 157**.

#### Dice Cooldown [BUFF]

- Final Blows now reduce Dice Cooldown by **15s**, but only while no perk is active.

#### Favourite Perks [BUFF]

- Previously restricted Favourite Perks can now be selected as **Rare Favourite Perks**.
- Rare Favourite Perks have **half the normal Favourite Perk roll chance**.
  - Regular Favourite Perks have a default **1 in 5 chance**.
  - Rare Favourite Perks have a default **1 in 10 chance**.
- The Favourite Perk selection menu now displays the roll chance of the selected perk.
- Rare Favourite Perks are highlighted with orange text in the selection menu.
- **Zamasu** can select **Sorcerer's Jackpot (102)** as a Rare Favourite Perk without the reduced roll chance, retaining the default **1 in 5 chance** instead of **1 in 10**.

#### Reroll Mechanic [CHANGE]

- Renamed **Consecutive Roll** to **Reroll**.

#### Soul Score [NEW]

- Introduced a custom Final Blow counter that tracks player eliminations independently of the Deathmatch scoreboard.
- The new system allows RTD to maintain its own score in lobbies where the official Deathmatch scoring system is not being used.
- Players can view their accumulated Final Blows through a new HUD indicator.
- Soul Score is used to calculate the damage dealt by **Soul Punisher**.

#### Workshop Optimisation [OPTIMISATION]

- Reduced the number of enabled Workshop rules by consolidating several existing rules.
- Combined global setup, Favourite Perk navigation and Final Blow tracking into fewer rules.
- Consolidated supporting rules for **Toxic**, **Auto Dodge**, **Cursed Swap** and **Cursed Speech** into their main perk rules.
- Optimised the HUD system to reduce the number of text entities created for individual players.
- These changes aim to improve performance and stability as more perks are added.

#### HUD [CHANGE]

- Updated the Workshop Code, Current Version, Final Blows and Duration Modifier displays to use a more consistent single-line layout.
- The Duration Modifier is now displayed as **DURATION MODIFIER: x1**, updating to show the player's current multiplier.
- Reworked several existing HUD elements to use shared displays instead of creating duplicate text elements for each player.

### Map Pool

- Ecopoint: Antarctica (Winter) **NEW**
- Eichenwalde
- Ilios Lighthouse
- Ilios Well
- Lijiang Garden
- Nepal Sanctum
- Black Forest **REMOVED**

### New Perks

#### Spirit Bomb (145) [NEW]

*Replaces Legendary Warrior.*

- Rare Favourite Perk
- Begins with an opening cinematic during which the user is temporarily invincible and cannot move or attack.
- Survive a **60-second preparation period** to successfully charge the Spirit Bomb.
- Gain **20% Damage Reduction** and **50% Knockback Resistance** during preparation.
- Enemies can see a marker above the Spirit Bomb user, making hiding much harder.
- Gain a **Resolve** meter that charges from taking damage:
  - When filled, heal for **25% of maximum health**.
  - Cleanse negative status effects.
  - Release an **8-meter knockback shockwave**.
- New Ability: **Guard** by holding Crouch:
  - Gain **75% Damage Reduction**.
  - Gain complete Knockback Resistance.
  - Move Speed is reduced, and attacking is disabled.
  - Release a **6-meter knockback shockwave** when Guard ends.
  - Maximum duration of **2s**, with a **7s cooldown**.
- Dying during preparation immediately ends the perk.
- Successfully surviving preparation activates a cinematic finishing sequence.
- The fully charged Spirit Bomb targets the nearest living opponent before being launched onto the battlefield.
- On impact, the Spirit Bomb creates a massive explosion.
- All players within a **75-meter radius** of the explosion, excluding the user, are eliminated and have their active perks nullified and removed.

#### Cursed Speech (125) [NEW]

*Replaces Innate Strength.*

- **30s Perk Duration**.
- Aim at another player and press **Interact** to issue a random Cursed Speech command:
  - **Freeze!** - Freeze the target for **2s**.
  - **Sleep!** - Put the target to sleep for **3s**.
  - **Catch Fire!** - Burn the target for **3s**, dealing damage over time.
  - **Fly!** - Launch the target high into the air.
  - **Hover!** - Slightly launch the target and remove their gravity for **4s**.
  - **Shrink!** - Shrink the target to **50% size** for **4s**, increase their Damage Received to **125%**, and raise their voice pitch.
  - **Grow!** - Enlarge the target to **200% size** for **4s**, reduce their Damage Received to **50%**, and lower their voice pitch.
- Commands consume both health and perk duration depending on their strength.
- Commands cannot kill the user and have a **4s cooldown**.

#### Heat Seaking Meowssile (146) [NEW]

- Transform into Jetpack Cat for up to **13s**.
- Gain **300% Move Speed** and automatically fly forward in the direction you're facing.
- Become visually ignited during flight.
- Normal attacks and abilities are disabled, with the following exceptions:
  - **Secondary Fire** remains available.
  - **Primary Fire** can manually trigger an explosion.
- Dropping below **10 m/s** also triggers an explosion:
  - Deals **200 damage** to other players within a **12-meter radius**.
  - Immediately ends the perk.
  - Returns the user to their original hero with **1 HP**.
- Surviving the entire duration without exploding restores the user's original hero at maximum health.
- Dying during the perk triggers a resurrection, returning the user to their original hero with **1 HP**.

#### Speed Damage (147) [NEW]

- **10s Perk Duration**.
- Damage dealt scales with your horizontal movement speed:
  - Deal **0% Damage** while stationary.
  - Deal **150% Damage** at **5.5 m/s**.
  - Moving faster increases damage further, with **no upper limit**.
- A HUD indicator displays your current Damage Dealt percentage.
- Jumping and falling do not contribute to the speed calculation.

#### Kill Challenge (148) [NEW]

- **15s Perk Duration**.
- Get a Final Blow before time runs out to complete the challenge.
- Successfully getting a Final Blow immediately ends the challenge and resets your Dice Cooldown, allowing you to roll again.
- Failing the challenge reduces your current health to **40%**.

#### Weeping Angel (149) [NEW]

- **15s Perk Duration**.
- Become **Invincible** and gain complete Knockback Resistance.
- Gain **200% Move Speed**, but can only attack using Melee.
- Melee attacks deal damage equivalent to **60% of the target's maximum health**.
- Become **Frozen** when an enemy within **20 meters** looks directly at you with a clear line of sight.
- Enemies must maintain their gaze for 0.2s to freeze the Weeping Angel.
- The Weeping Angel is released after 0.3s without being watched.
- Move freely again when you are no longer being watched.
- New Ability: **Fade** by pressing Interact:
  - Become invisible for **0.8s**.
  - Gain **500% Move Speed**.
  - Cannot be frozen or use Melee during Fade.
  - **6s cooldown**.

#### Earthquake (150) [NEW]

- **10s Perk Duration**.
- Trigger an earthquake that affects all players across the map.
- Grounded players are repeatedly launched slightly into the air.
- Each grounded player has a chance to be:
  - **Stunned** for **0.5s**.
  - **Knocked Down** for **1s**.

#### Hot Potato (151) [NEW]

- Rare Favourite Perk
- **10s Perk Duration**.
- Receive a Hot Potato that must be passed to another player before time runs out.
- Hit another player with a **Melee attack** to pass the Hot Potato.
- Certain melee-based hero abilities can also pass the Hot Potato.
- Passing the Hot Potato transfers its **remaining duration** to the recipient.
- The recipient's existing perk is removed when they receive the Hot Potato.
- Whoever is still holding the Hot Potato when its timer expires is **eliminated**.

#### Soul Punisher (152) [NEW]

- **15s Perk Duration**.
- Press **Interact** to unleash a powerful energy attack.
- Create a small, shimmering rainbow-coloured energy sphere that charges for **0.8s** before launching.
- The sphere travels straight in the direction you're facing at **40 m/s**, with a maximum travel duration of **6s**.
- The projectile explodes upon reaching an opponent within **2 meters**, hitting an obstacle, or reaching its maximum range.
- On impact, the sphere rapidly expands into a massive, multicoloured explosion:
  - **12-meter visual sphere radius**.
  - **8.4-meter damage radius**.
  - Multiple opponents can be damaged by the same explosion.
- All opponents caught within the explosion receive damage based on their individual Soul Score:
  - **100 Base Damage**.
  - **+25 Damage** for each Final Blow the target has accumulated.
  - Damage has **no upper limit**.

#### Devil's Bullet (153) [NEW]

- **20s Perk Duration**.
- Receive **7 magical bullets**.
- Press **Interact** to fire a bullet.
- The first **6 bullets**:
  - Deal **150 damage**.
  - Travel in a straight line with a **200-meter range**.
  - Pierce through multiple enemies and walls.
- The **7th bullet belongs to the Devil**:
  - Randomly targets any living player, including the user.
  - Deals **300 damage** to the chosen target.
  - The chosen target is announced to everyone.
  - Automatically fires when the perk expires, even if the user has not fired all previous bullets.
- The perk ends after the Devil's seventh bullet is fired.

#### Psychokinesis (154) [NEW]

- Rare Favourite Perk
- **15s Perk Duration**.
- Press **Interact** to target the opponent closest to your reticle.
- The target must have **50% or less of their maximum health** and be within your line of sight.
- Successfully targeting an opponent activates a powerful execution:
  - The victim is immobilised and lifted **8 meters** into the air over **1.5s**.
  - The user is forced to face the victim during the execution.
  - The victim is suspended briefly before triggering a massive explosion.
  - The explosion deals **99999 damage** to all players within a **6-meter radius**, including the user.
- Unsuccessful targeting attempts do not consume the perk.
- The perk ends after the execution.

#### One Trick (155) [NEW]

- **10s Perk Duration**.
- Primary Fire remains available, but only **one randomly selected ability** can be used:
  - Secondary Fire.
  - Ability 1.
  - Ability 2.
- The selected ability has **no cooldown** and its charges are continuously replenished.
- All other listed abilities and Ultimate are disabled for the duration.

#### Poisoned (156) [NEW]

- **30s Perk Duration**.
- Become poisoned, continuously taking **5 damage per second**.
- Collect Health Packs for a chance to cure the poison.
- Each Health Pack has a **1 in 10 chance** of curing the poison and ending the perk.
- Failing to cure the poison before the timer expires results in **death**.

#### Alien Invasion (157) [NEW]

- **15s Perk Duration**.
- Trigger an Alien Invasion that temporarily transforms all eligible players into **Juno**.
- Each affected player receives a random character size between **50% and 175%**.
- All affected players gain:
  - **Unlimited Ultimates**.
  - **No ability cooldowns**.
  - Continuously replenished ability charges.
- Dummy bots and players with certain hero-changing perks are excluded.
- When the invasion ends, players return to their original heroes and sizes, with their previous Ultimate Charge restored.

### Perk Changes

#### Sorcerer's Jackpot (102) [REWORK]

- Sorcerer's Jackpot now begins with **Idle Death Gamble**.
- The user has up to **5 spins** to hit the Jackpot.
- Each spin has a **1 in 6 chance** of winning the Jackpot.
- Failing to hit the Jackpot can result in:
  - **Close:** Gain **20% Ultimate Charge**.
  - **Miss:** Gain **10% Ultimate Charge**.
- Failing to win after all 5 spins ends the perk.
- Successfully hitting the Jackpot activates its effects for **254s**.
- Final Blows during the Jackpot restore **10s of Perk Duration**, up to a maximum of **254s**.
- Healing during the Jackpot consumes remaining Perk Duration.
- When the Jackpot expires naturally, the user suffers **Burnout** for **5s**:
  - Move Speed reduced to **75%**.
  - Damage Dealt reduced to **75%**.
- Rerolled Sorcerer's Jackpot skips Idle Death Gamble and immediately activates the Jackpot with a reduced **60s Perk Duration**.

#### Soul Link (138) [REWORK]

- Soul Link now works **both ways**.
- Two players are randomly linked together for up to **10s**.
- If either linked player dies, the other is also eliminated.
- Both players receive a message identifying their linked partner.
- A visible beam connects the two linked players.
- The link is removed when the perk ends.

#### Equalizer (137) [REWORK]

- Equalizer is no longer activated automatically.
- Perk Duration increased from **1s to 25s**.
- Press **Interact** to activate Equalizer.
- On activation, nearby players within **15 meters** have their health percentages and Ultimate Charge matched to yours.
- The perk ends immediately after activation.

#### Grounded (131) [REWORK]

- Grounded no longer directly disables jumping.
- Instead, leaving the ground causes the player to be repeatedly forced downward, preventing sustained airborne movement.

#### No Cooldowns (41) [BUFF]

- Improved support for abilities with multiple charges.

#### Black Flash (123) [BUFF]

- Successful Black Flashes now grant an additional **3s Perk Duration**.
- Increased In the Zone Move Speed from **115% to 125%**.

#### Filled with: Perseverance (116) [CHANGE]

- The Perseverance meter now continues charging while its defensive buff is active.
- No longer grants Knockback Immunity.
- Fully charging the Perseverance meter while the defensive buff is active now refreshes its **3s duration**.
- Each successful meter activation still heals the user for **30% of maximum health**.

#### Double Duration / Halved Duration (126 / 127) [CHANGE]

- Duration multipliers no longer affect **Ban Hammer** or **Spirit Bomb**.
- Multipliers remain pending while either of these perks is active and can be applied to the next eligible perk.

#### Heart Virus (86) [CHANGE]

- Infecting a player now ends their existing perk before applying Heart Virus, allowing its normal ending effects and cleanup to occur.
- Added a brief delay between ending the previous perk and applying the infection.
- Players who die during this transition are no longer infected.
- Heart Virus can no longer infect dummy bots.
- Optimised infection spreading by removing duplicate proximity checks and unnecessary processing.

#### Random Hero (47) [CHANGE]

- Reduced the delay before restoring health and Ultimate Charge after returning to the original hero from **1s to 0.5s**.

#### High Gravity (27) [NERF]

- Move Speed is now reduced to **65%** while High Gravity is active.
- Landing after a sufficiently fast fall now:
  - Deals **25 damage**.
  - Knocks the user down for **1s**.

#### Frail (28) [NERF]

- Now also increases Knockback Received to the maximum allowed value.

#### Innate Strength (125) [REPLACED]

- Innate Strength has been removed and replaced by **Cursed Speech**.

#### Legendary Warrior (145) [REPLACED]

- Legendary Warrior has been removed and replaced by **Spirit Bomb**.

### Bug Fixes

#### Dice Roll Announcements [BUG FIX]

- Fixed a bug introduced in V2.4 where normal Dice Rolls would no longer announce which perk the player received.
- Restored Dice Roll announcements for both normal rolls and Favourite Perk rolls.
- In Deathmatch, the player rolling the dice sees their perk name, while other players receive a general roll announcement.
- In team modes, teammates can see the rolled perk, while enemies receive a general announcement.
- Improved announcement timing to prevent the previous perk's name from being displayed.

#### Sorcerer's Jackpot (102) [BUG FIX]

- Fixed an issue where excessive energy consumption could prevent Sorcerer's Jackpot from ending correctly for "Zamasu".
- Improved energy depletion handling to ensure the Jackpot expires and cleans up properly when its remaining duration runs out.

#### Constant Nullification (88) [BUG FIX]

- Fixed an issue where environmental eliminations involving players inside the nullification field were not correctly credited to the perk user.
- Optimised nearby-player detection to reduce unnecessary processing while Constant Nullification is active.

#### Duration Modifier [BUG FIX]

- Fixed an issue where additional Duration Modifiers could be lost when multiple modifiers were received within a short period.
- Duration Modifiers are now consumed immediately after being applied, allowing new modifiers to stack correctly on active perks.

#### Spirit Bomb (145) [BUG FIX]

- Fixed an interaction where **Heart Virus** could cause Spirit Bomb's preparation timer to trigger its finishing sequence prematurely.
- Becoming infected with Heart Virus during preparation now interrupts the Spirit Bomb sequence.
- Fixed an issue where Spirit Bomb could leave players stuck with an active perk timer if the perk was interrupted during its opening cinematic.

#### Skill Check (133) [BUG FIX]

- Fixed a bug where successfully completing a Skill Check would not immediately end the perk.
- The perk duration and progress bar now stop when the Skill Check is completed successfully, rather than continuing until the timer expires.
- Successful Skill Checks now correctly apply their reduced **1s Dice Cooldown** after the perk ends.

#### Dice Reroll [BUG FIX]

- Improved Reroll announcement timing to prevent the previous perk's name from being displayed.
- Fixed an issue where consecutive Rerolls could be lost when a rerolled perk granted another Reroll.

#### Stole the Dice (93) [BUG FIX]

- Improved perk stealing reliability by capturing the victim's perk information immediately upon selection.
- Stole the Dice can no longer steal another player's Stole the Dice perk.
- Improved victim cleanup to avoid cancelling a different perk acquired after the theft began.

#### Dummy Bots [BUG FIX]

- Fixed an issue where dummy bots could unnecessarily initialise RTD's HUD elements and other player-specific features.

---

## V2.4

### General

- Most perks have been optimised to reduce the total number of rules used by the mode.
- Due to the large number of optimisation changes, some perks may not function in exactly the same way they used to.
- **Please report any unexpected perk behaviour.**
- The internal cooldown for jumping by 5 within the Favourite Perk menu has been decreased.

#### Duration Modifier System — New System

*This system allows Double Duration and Halved Duration to affect future perk rolls more consistently.*

- Added a Duration Modifier HUD element.
- Players can now see their current pending duration modifier.
- Several perk wait times have been changed from static waits to dynamic waits.
- This allows perks to better support unexpected duration changes from Double Duration and Halved Duration.
- **Please report any perks that do not correctly work with this new system.**

---

### Map Pool

#### Added

- **Black Forest**

#### Available

- Eichenwalde
- Ilios Lighthouse
- Ilios Well
- Lijiang Garden
- Nepal Sanctum

#### Removed

- Castillo
- Malevento

---

### New Perks

#### Endurance

*Restores own health once it reaches 1.*

- If the user drops to 1 HP, the perk is consumed.
- The user is healed for **50% of their Max Health**.
- The user is granted **+1s Phased Out**.

#### Camera Lock

- The user's camera is detached from them and locked in place for **10s**.

#### Brain Worm

*Take control of another player.*

- Searches for a random living enemy to attach to.
- Once attached, the user becomes invisible, Phased Out and unable to use their own actions.
- While attached, the user can force the host to perform any input they enter, other than the host's camera and movement.

#### Auto Counter

*Automatically punishes the next player that damages you.*

When rolled, Auto Counter is randomly assigned one of three types:

- **Auto Counter: Offense Type**
- **Auto Counter: Defense Type**
- **Auto Counter: Disruption Type**

Auto Counter is consumed after successfully triggering.

##### Auto Counter: Offense Type

- Teleports the user in front of the attacker.
- Deals **125 damage** to the attacker.
- Knocks the attacker away.

##### Auto Counter: Defense Type

- Teleports the user away from the attacker.
- Clears several negative statuses from the user.
- Stops all damage-over-time effects on the user.
- Fully heals the user.
- Grants the user **+1.5s Phased Out**.

##### Auto Counter: Disruption Type

- Teleports the user behind the attacker.
- Hacks the attacker for **3s**.
- Adds **+5s** to the attacker's Ability 1, Ability 2 and Secondary Fire cooldowns.
- Removes **5% Ultimate Charge** from the attacker.

#### Legendary Warrior

*GRAAAAAAAAAAGH.*

- The user grows larger and gains increased damage, damage resistance, move speed, jump height, knockback resistance and bonus health.
- While active, damaging enemies heals the user and extends the perk duration.
- Final Blows heal the user and extend the perk duration even further.
- The perk duration can be extended up to a maximum of **90s**.
- The user gains **3 Stomp charges**.
- Pressing Crouch while airborne consumes a Stomp charge, slamming the user downward.
- Landing with Stomp knocks nearby enemies down, launches them slightly upward and deals **40 damage**.
- Stomp charges regenerate over time.
- Legendary Warrior clears negative statuses from the user while active.
- Legendary Warrior **cannot be selected as a Favourite Perk**.

---

### Perk Changes

#### Filled with: Bravery — Rework

*Refuse to fall.*

*This rework gives Bravery a much stronger and more unique identity, now focusing on last-stand power rather than proximity-based stat buffs.*

- The user becomes stronger and faster as their health gets lower.
- At lower health, the user gains increased damage, move speed, damage resistance and knockback immunity.
- At critical health, the user gains extreme damage, speed, healing received and knockback immunity.

#### Double Duration / Halved Duration — Rework

*These perks now have a more consistent impact on perk duration.*

- Double Duration now adds to the player's pending duration modifier.
- Halved Duration now reduces the player's pending duration modifier.
- If a player has no active perk, the duration modifier will apply to their next valid perk.
- Rolling Double Duration or Halved Duration multiple times can stack the duration modifier.
- The modifier is consumed when the player receives a valid non-duration perk.

#### Melee Activated Perks — Buff

The following melee-activated perks can now be activated by specific melee-type abilities:

- Black Flash
- 0.2 Second Void
- Berserk
- Filled with: Justice
- One Punch Man
- Strip To Melee

These perks can now be triggered by:

- Brigitte Rocket Flail
- Reinhardt Rocket Hammer
- Vendetta Palatine Fang
- Doomfist Rocket Punch
- Hazard Violent Leap
- Ramattra Pummel — Ability 1 & Ultimate
- Torbjörn Forge Hammer
- Venture Drill Dash
- Universal Melee

#### Auto Dodge — New Ability

- Pressing Interact now allows the user to **force dodge** and smoothly move behind their target.

#### Black Flash — Buff

- Successfully hitting a Black Flash changes the activation chance from **33%** to **50%**.

#### A-Train — Buff

*This change aims to add greater chain-kill potential and strategy to A-Train.*

- Final Blows now add **+5s perk duration** instead of resetting the perk duration to 5s.

#### The Horse is Here — Buff

- Removed the **+10s dice cooldown** penalty.

#### Filled with: Justice — Buff

*This perk felt like just another instant-kill perk for victims. This change attempts to add more impact to the perk and allow it to stand out.*

- Now removes the guilty player's perk.
- The guilty player is now Hacked for **15s**.

#### Filled with: Kindness — Buff

- Healing Aura: **75 HP/s → 100 HP/s**
- User Bonus Healing Aura: **75 HP/s → 100 HP/s**

#### Accelerated Ultimate — Buff

- Ultimate charge gain: **20%/s → 40%/s**

#### Godmode — Buff

Godmode now protects against:

- Golden Gun
- Yippee
- Kings Demand

#### Temporary Ultimate — Buff

- Perk Duration: **15s → 25s**

#### Primal Rage — Buff

- **+100% Damage Dealt**

#### Flamethrower — Buff

- No longer grants the user an aura.

#### Keyboard Spam — Nerf

- Keyboard Spam now also forces Jump, Melee and Crouch inputs.

#### Heavenly Restriction — Buff / Rename

- Renamed to **Innate Strength**.
- Now hides the user's outline.

---

### Bug Fixes

- Patched a bug where Ban Hammer would not end after missing Earthshatter.
- Patched a bug that resulted in the Knocked Down effect of Auto Dodge not triggering when the perk ends.
- Many other fixes.
