import core/models/common.{type Edition, BaseGame}

pub type ActionCardIdentifier {
  AncientBurialSites
  AssassinateRepresentative
  Bribery
  Bunker
  ConfusingLegalText
  ConstructionRider
  CourageousToTheEnd
  CrippleDefenses
  DiplomacyRider
  DirectHit
  Disable
  DistinguishedCouncilor
  EconomicInitiative
  EmergencyRepairs
  ExperimentalBattlestation
  FighterPrototype
  FireTeam
  FlankSpeed
  FocusedResearch
  FrontlineDeployment
  GhostShip
  ImperialRider
  InTheSilenceOfSpace
  IndustrialInitiative
  Infiltrate
  Insubordination
  Intercept
  LeadershipRider
  LostStarChart
  LuckyShot
  ManeuveringJets
  MiningInitiative
  MoraleBoost
  Parley
  Plague
  PoliticalStability
  PoliticsRider
  PublicDisgrace
  ReactorMeltdown
  Reparations
  RepealLaw
  RiseOfAMessiah
  Sabotage
  Salvage
  ShieldsHolding
  SignalJamming
  SkilledRetreat
  Spy
  Summit
  TacticalBombardment
  TechnologyRider
  TradeRider
  UnexpectedAction
  UnstablePlanet
  Upgrade
  Uprising
  Veto
  WarEffort
  WarfareRider
  Blitz
  Counterstroke
  FighterConscription
  ForwardSupplyBase
  GhostSquad
  HackElection
  HarnessEnergy
  Impersonation
  InsiderInformation
  MasterPlan
  Plagiarize
  Rally
  ReflectiveShielding
  Sanction
  ScrambleFrequency
  SolarFlare
  WarMachine
  ArchaeologicalExpedition
  ConfoundingLegalText
  CoupDetat
  DeadlyPlot
  DecoyOperation
  DiplomaticPressure
  DivertFunding
  ExplorationProbe
  ManipulateInvestments
  NavSuite
  RefitTroops
  RevealPrototype
  ReverseEngineer
  Rout
  Scuttle
  SeizeArtifact
  Waylay
}

pub type ActionCard {
  ActionCard(
    card: ActionCardIdentifier,
    name: String,
    edition: Edition,
    amount: Int,
    trigger_text: String,
    effect_text: String,
    flavor_text: String,
  )
}

pub const action_cards_deck = [
  ActionCard(
    card: AncientBurialSites,
    name: "Ancient Burial Sites",
    edition: BaseGame,
    amount: 1,
    trigger_text: "At the start of the agenda phase",
    effect_text: "Choose 1 player. Exhaust each cultural planet owned by that player.",
    flavor_text: "The images depicted a race that Rin had never seen before. Curious. Could it be that this was a race that was exterminated by the Lazax?",
  ),

  ActionCard(
    card: AssassinateRepresentative,
    name: "Assassinate Representative",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After an agenda is revealed",
    effect_text: "Choose 1 player. That player cannot vote on this agenda.",
    flavor_text: "With a sickening crunch of bone and metal, unit.desgn.FLAYESH extracted its stinger from the blood-drenched skull of the Jol-Nar councilor.",
  ),

  ActionCard(
    card: Bribery,
    name: "Bribery",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After the speaker votes on an agenda",
    effect_text: "Spend any number of trade goods. For each trade good spent, cast 1 additional vote for the outcome on which you voted.",
    flavor_text: "\"We think that this initiative would spell disaster for the galaxy, not just the Creuss.\" Taivra said, quietly slipping Z'eu an envelope. \"Don't you agree?\"",
  ),

  ActionCard(
    card: Bunker,
    name: "Bunker",
    edition: BaseGame,
    amount: 1,
    trigger_text: "At the start of an invasion",
    effect_text: "During this invasion, apply -4 to the result of each Bombardment roll against planets you control.",
    flavor_text: "Elder Junn crossed his arms and steadied his breathing. The bombs could not reach them, not this far down. At least, that is what the soldiers had told him.",
  ),

  ActionCard(
    card: ConfusingLegalText,
    name: "Confusing Legal Text",
    edition: BaseGame,
    amount: 1,
    trigger_text: "When you are elected as the outcome of an agenda",
    effect_text: "Choose 1 player. That player is the elected player instead.",
    flavor_text: "Somehow, even after the Council had adjourned, none of them were any closer to understanding the strange and confusing events of the day.",
  ),

  ActionCard(
    card: ConstructionRider,
    name: "Construction Rider",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After an agenda is revealed",
    effect_text: "You cannot vote on this agenda. Predict aloud an outcome of this agenda. If your prediction is correct, place 1 space dock from your reinforcements on a planet you control.",
    flavor_text: "The vote was nearly unanimous. The council would provide funding for the restoration. Ciel was furious.",
  ),

  ActionCard(
    card: CourageousToTheEnd,
    name: "Courageous to the End",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After 1 of your ships is destroyed during a space combat",
    effect_text: "Roll 2 dice. For each result equal to or greater than that ship's combat value, your opponent must choose and destroy 1 of their ships.",
    flavor_text: "Coughing up blood and covered in burns, Havvat collapsed against the rapidly overheating ship core. She smiled. She would be remembered.",
  ),

  ActionCard(
    card: CrippleDefenses,
    name: "Cripple Defenses",
    edition: BaseGame,
    amount: 1,
    trigger_text: "Action: Choose 1 planet.",
    effect_text: "Destroy each PDS on that planet.",
    flavor_text: "Titanic vines burst forth from the ground, wrapping themselves around the system's primary firing cylinder, breaking it free from its moorings, and bringing it crashing down upon the installation below.",
  ),

  ActionCard(
    card: DiplomacyRider,
    name: "Diplomacy Rider",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After an agenda is revealed",
    effect_text: "You cannot vote on this agenda. Predict aloud an outcome of this agenda. If your prediction is correct, choose 1 system that contains a planet you control. Each other player places a command token from their reinforcements in that system.",
    flavor_text: "Ciel evaluated the other senators. Weak, all of them. This was his game to win.",
  ),

  ActionCard(
    card: DirectHit,
    name: "Direct Hit",
    edition: BaseGame,
    amount: 4,
    trigger_text: "After another player's ship uses Sustain Damage to cancel a hit produced by your units or abilities",
    effect_text: "Destroy that ship.",
    flavor_text: "(1) There it was! An opening! Neekuaq gestured wildly, a rare display for one normally quite reserved. \"Fire the main battery!\"(2) The Loncara Ssodu's main battery flared to life, firing a volley directly into the flickering starboard shield of the Letnev dreadnought.(3) For a moment, it looked as if the dreadnought's shield would hold, but a moment later, the ship began to come apart where the attack had pierced its hull.(4) Neekuaq watched, satisfied, as the ship was wracked by a series of explosions from within, huge armored plates and other debris hurtling off into the darkness.",
  ),

  ActionCard(
    card: Disable,
    name: "Disable",
    edition: BaseGame,
    amount: 1,
    trigger_text: "At the start of an invasion in a system that contains 1 or more of your opponents' PDS units",
    effect_text: "Your opponents' PDS units lose Planetary Shield and Space Cannon during this invasion.",
    flavor_text: "\"Ssruu has met their systems and fixed them.\" Ssruu dropped a handful of ripped wires and broken circuitry on the pedestal before Q'uesh Sish. \"He will await his next task aboard his ship.\"",
  ),

  ActionCard(
    card: DistinguishedCouncilor,
    name: "Distinguished Councilor",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After you cast votes on an outcome of an agenda",
    effect_text: "Cast 5 additional votes for that outcome.",
    flavor_text: "Elder Junn was a wonder to behold. He knew the name of every senator, made small talk effortlessly, and commanded attention when he spoke. Magmus hated everything about him.",
  ),

  ActionCard(
    card: EconomicInitiative,
    name: "Economic Initiative",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Ready each cultural planet you control.",
    flavor_text: "Large sum of Hacan currency flowed freely into the project, and somehow, defying all logic, the returns were even greater.",
  ),

  ActionCard(
    card: EmergencyRepairs,
    name: "Emergency Repairs",
    edition: BaseGame,
    amount: 1,
    trigger_text: "At the start or end of a combat round",
    effect_text: "Repair all of your units that have Sustain Damage in the active system.",
    flavor_text: "\"What do you mean 'It's fine!?'\" Dahla said, nearly tripping over a damaged bulkhead as the ship rocked from the explosive barrage.",
  ),

  ActionCard(
    card: ExperimentalBattlestation,
    name: "Experimental Battlestation",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After another player moves ships into a system during a tactical action",
    effect_text: "Choose 1 of your space docks that is either in or adjacent to that system. That space dock uses Space Cannon 5 (x3) against ships in the active system.",
    flavor_text: "\"Arm the relay!\" Mendosa bared his fangs. \"The Saar will not submit!\"",
  ),

  ActionCard(
    card: FighterPrototype,
    name: "Fighter Prototype",
    edition: BaseGame,
    amount: 1,
    trigger_text: "At the start of the first round of a space combat",
    effect_text: "Apply +2 to the result of each of your fighters' combat rolls during this combat round.",
    flavor_text: "Suffi vaulted excitedly off the prototype's sleek, azure wing, landing effortlessly in its cockpit. \"Let's see those damn snakes keep up with us now!\"",
  ),

  ActionCard(
    card: FireTeam,
    name: "Fire Team",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After your ground forces make combat rolls during a round of ground combat",
    effect_text: "Reroll any number of your dice.",
    flavor_text: "Grinning, Jael spun towards the familiar noise of heavy boots hitting the ground. Backup had arrived.",
  ),

  ActionCard(
    card: FlankSpeed,
    name: "Flank Speed",
    edition: BaseGame,
    amount: 4,
    trigger_text: "After you activate a system",
    effect_text: "Apply +1 to the move value of each of your ships during this tactical action.",
    flavor_text: "(1) Mendosa smirked. \"Don't ye fret now, girl. It sounds like ye've got somewhere ta be in a hurry, and it just se happens that I ken get ye there right quick.\"(2) There was a low-pitched hum throughout the station and the gigantic, bulky constructions on the hull spat blue flame. Massive ion thrusters! So this was how the Saar moved the damned things.(3) Mendosa grinned at the young Mentak pilot's astonishment. \"Mobility-the Clan's greatest strength. Ye'd be amazed at how fast this thing ken go.\"(4) With a sound like thunder and a flash of neon blue light, the thrusters accelerated full bore, nearly knocking Suffi off her feet.",
  ),

  ActionCard(
    card: FocusedResearch,
    name: "Focused Research",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Spend 4 trade goods to research 1 technology.",
    flavor_text: "Stunned, Rin looked over the data, scarcely able to believe what he was seeing. It was nothing short of a major breakthrough. The Headmaster would be pleased.",
  ),

  ActionCard(
    card: FrontlineDeployment,
    name: "Frontline Deployment",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Place 3 infantry from your reinforcements on 1 planet you control.",
    flavor_text: "The soldiers poured fire on the writhing mass, but as each tendril vaporized, two more took its place. Panic wormed into the troopers' minds; was the creature growing?",
  ),

  ActionCard(
    card: GhostShip,
    name: "Ghost Ship",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Place 1 destroyer from your reinforcements in a non-home system that contains a wormhole and does not contain other players' ships.",
    flavor_text: "Reports of Creuss vessels sighted in the area had surely been exaggerated. After all, the Creuss had no business this far from the Shaleri passage, and usually kept to themselves.",
  ),

  ActionCard(
    card: ImperialRider,
    name: "Imperial Rider",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After an agenda is revealed",
    effect_text: "You cannot vote on this agenda. Predict aloud an outcome of this agenda. If your prediction is correct, gain 1 victory point.",
    flavor_text: "In a sweeping victory that surprised absolutely no one, the Winnu representative singlehandedly elected himself to oversee the analysis of a recently uncovered Lazax data cache.",
  ),

  ActionCard(
    card: InTheSilenceOfSpace,
    name: "In The Silence Of Space",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After you activate a system",
    effect_text: "Choose 1 system. During this tactical action, your ships in the chosen system can move through systems that contain other players' ships.",
    flavor_text: "The Barony ships seemed to defy reality, bending light around them at impossible angles - naught but inky-black contours could be seen.",
  ),

  ActionCard(
    card: IndustrialInitiative,
    name: "Industrial Initiative",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Gain 1 trade good for each industrial planet you control.",
    flavor_text: "The Gashlai reactors proved to be extremely effective. With the conversion rate practically doubled, the factories' output was immense.",
  ),

  ActionCard(
    card: Infiltrate,
    name: "Infiltrate",
    edition: BaseGame,
    amount: 1,
    trigger_text: "When you gain control of a planet",
    effect_text: "Replace each PDS and space dock that is on that planet with a matching unit from your reinforcements.",
    flavor_text: "The 1X had scarcely interfaced with the mainframe before it belonged to them completely.",
  ),

  ActionCard(
    card: Insubordination,
    name: "Insubordination",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Remove 1 token from another player's tactic pool and return it to their reinforcements.",
    flavor_text: "Kilik had never been particularly good at following orders. It only seemed natural to get paid for exercising that trait, as long as she didn't think to hard about where the money was coming from.",
  ),

  ActionCard(
    card: Intercept,
    name: "Intercept",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After your opponent declares a retreat during a space combat",
    effect_text: "Your opponent cannot retreat during this round of space combat.",
    flavor_text: "The space before the fleeing ship shimmered and warped, revealing the bow of the Y'sia Yssrila bearing down on its position. There would be no escape today.",
  ),

  ActionCard(
    card: LeadershipRider,
    name: "Leadership Rider",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After an agenda is revealed",
    effect_text: "You cannot vote on this agenda. Predict aloud an outcome of this agenda. If your prediction is correct, gain 3 command tokens.",
    flavor_text: "Rev's impassioned speech stunned the other councilors. Perhaps there was more to these humans than they had initially thought.",
  ),

  ActionCard(
    card: LostStarChart,
    name: "Lost Star Chart",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After you activate a system",
    effect_text: "During this tactical action, systems that contain alpha and beta wormholes are adjacent to each other.",
    flavor_text: "The ship's sensors showed that the ancient star-map had somehow led them beyond the Mahact plateau.",
  ),

  ActionCard(
    card: LuckyShot,
    name: "Lucky Shot",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Destroy 1 dreadnought, cruiser, or destroyer in a system that contains a planet you control.",
    flavor_text: "The missile - an insignificant spark against the darkness - struck the hull of the dreadnought. Moments later, the starboard flank erupted in flames.",
  ),

  ActionCard(
    card: ManeuveringJets,
    name: "Maneuvering Jets",
    edition: BaseGame,
    amount: 4,
    trigger_text: "Before you assign hits produced by another player's Space Cannon roll",
    effect_text: "Cancel 1 hit.",
    flavor_text: "(1) Something was wrong. T'esla sensed a flicker of movement on the planet's surface, followed by a faint glint of light. Reflexively, she veered her fighter to the side - an action that saved her life.(2) The fighter's thruster boosted her just out of the cannon's firing solution, and a metal slug the size of a building rocketed past her crystalline ship.(3) T'esla breathed a sigh of relief as the massive slug disappeared into the distance. A touch slower and she would have been annihilated.(4) The flickering red warning lights on her control panel reflected in her scales as she regained her composure. \"Well,\" she said aloud. \"Zat was close.\"",
  ),

  ActionCard(
    card: MiningInitiative,
    name: "Mining Initiative",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Gain trade goods equal to the resource value of 1 planet you control.",
    flavor_text: "To support its voracious war machine, the N'orr empire cracked the planet's crust and began mining its very core.",
  ),

  ActionCard(
    card: MoraleBoost,
    name: "Morale Boost",
    edition: BaseGame,
    amount: 4,
    trigger_text: "At the start of a combat round",
    effect_text: "Apply +1 to the result of each of your unit's combat rolls during this combat round.",
    flavor_text: "(1) Harrugh stood before his warriors, searching for the words that would express the pride that swelled within him.(2) \"We have done the impossible. I am proud to call you my brothers. My equals. My betters.\" Harrugh's whiskers bristled with energy as he spoke.(3) \"Today we turn these invaders to ash and take back what is ours!\" Harrugh paused, noting the murmurs of approval rippling through the ranks.(4) The whispering gradually died down and his warriors watched Harrugh expectantly. Every muscle in his body tensed, and he thrust his gyro-spear skyward. \"For Kenara!\"",
  ),

  ActionCard(
    card: Parley,
    name: "Parley",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After another player commits units to land on a planet you control",
    effect_text: "Return the committed units to the space area.",
    flavor_text: "The human admiral returned to his ship, struggling to remember precisely how his meeting with the Collective had gone.",
  ),

  ActionCard(
    card: Plague,
    name: "Plague",
    edition: BaseGame,
    amount: 1,
    trigger_text: "Action: Choose 1 planet that is controlled by another player.",
    effect_text: "Roll 1 die for each infantry on that planet. For each result of 6 or greater, destroy 1 of those units.",
    flavor_text: "The letani dipped a mossy limb beneath the surface of the reservoir, feeling the flow of the particles within, shifting them, changing them into something different. Something dangerous.",
  ),

  ActionCard(
    card: PoliticalStability,
    name: "Political Stability",
    edition: BaseGame,
    amount: 1,
    trigger_text: "When you would return your strategy card(s) during the status phase",
    effect_text: "Do not return your strategy card(s). You do not choose strategy cards during the next strategy phase.",
    flavor_text: "The Winnu councilor breathed a sigh of relief. This opportunity would not be wasted. The peace of the Lazax was within grasp.",
  ),

  ActionCard(
    card: PoliticsRider,
    name: "Politics Rider",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After an agenda is revealed",
    effect_text: "You cannot vote on this agenda. Predict aloud an outcome of this agenda. If your prediction is correct, draw 3 action cards and gain the speaker token.",
    flavor_text: "The Dirzuga had managed to negotiate themselves into a position of power amongst the other councilors, all of whom still looked terribly uncomfortable in their presence.",
  ),

  ActionCard(
    card: PublicDisgrace,
    name: "Public Disgrace",
    edition: BaseGame,
    amount: 1,
    trigger_text: "When another player chooses a strategy card during the strategy phase",
    effect_text: "That player must choose a different strategy card instead, if able.",
    flavor_text: "In the months that followed the report, the Council was quick to censure the Jol-Nar for their unethical practices.",
  ),

  ActionCard(
    card: ReactorMeltdown,
    name: "Reactor Meltdown",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Destroy 1 space dock in a non-home system.",
    flavor_text: "Flames engulfed the shipyard, a vortex of fire and shrapnel that left nothing untouched.",
  ),

  ActionCard(
    card: Reparations,
    name: "Reparations",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After another player gains control of a planet you control",
    effect_text: "Exhaust 1 planet that player controls and ready 1 planet you control.",
    flavor_text: "Gila oversaw the reconstruction of the Hacan outpost, but neglected to inform the N'orr representative that the damage was not nearly as severe as he was led to believe.",
  ),

  ActionCard(
    card: RepealLaw,
    name: "Repeal Law",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Discard 1 law from play.",
    flavor_text: "Eventually, the N'orr diplomat came to an agreement with Hacan Garrus, and the embargo was repealed. Still, he couldn't shake the feeling that Garrus had gotten the better end of the deal.",
  ),

  ActionCard(
    card: RiseOfAMessiah,
    name: "Rise of a Messiah",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Place 1 infantry from your reinforcements on each planet you control.",
    flavor_text: "Harrugh stood atop the dunes, looking down at the thousands of Hacan warriors mustered below. Gathering his strength, he let loose a mighty roar, the will of his people throughout the galaxy echoing forth from within.",
  ),

  ActionCard(
    card: Sabotage,
    name: "Sabotage",
    edition: BaseGame,
    amount: 4,
    trigger_text: "When another player plays an action card other than \"Sabotage\"",
    effect_text: "Cancel that action card.",
    flavor_text: "(1) Q'uesh Sish tapped her claws impatiently. \"You were sssaying?\" But the confused Jol-Nar envoy stood silent. It was as if the words had escaped his thoughts entirely.        (2) trjn.desgn.ALIZARIN introduced itself to each data nodes, incorporating them into its platform, expunging any data it deemed a threat to the Virus.        (3) unit.desgn.BEELZEBUL followed the group of men through the winding hallways until they stopped at an intersection. Investigators would later find its cracked oculus at the center of a smoking crater, singed, but still functional.        (4) Unlenn smashed a clenched fist into the bulkhead, green eyes ablaze with rage. The entire plan had been turned on its head. Such incompetence was unfathomable.",
  ),

  ActionCard(
    card: Salvage,
    name: "Salvage",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After you win a space combat",
    effect_text: "Your opponent gives you all of their commodities.",
    flavor_text: "When the Coalition raiders had finally returned to their ships, scarcely a bolt remained to salvage from the destroyed vessel.",
  ),

  ActionCard(
    card: ShieldsHolding,
    name: "Shields Holding",
    edition: BaseGame,
    amount: 4,
    trigger_text: "Before you assign hits to your ships during a space combat",
    effect_text: "Cancel up to 2 hits.",
    flavor_text: "(1) T'ro stared unflinching at the incoming barrage through the bridge's observation deck. The shield would hold.(2) The blast from the enemy's main cannon slammed into the space in front of the warship, splitting into two streams across the bow.(3) The ship's shields sizzled and sparked but remained active despite the heavy assault.(4) As the assault died down and it became clear that the ship sustained no major damage, T'ro clicked his mandibles in anticipation. \"Return fire!\"",
  ),

  ActionCard(
    card: SignalJamming,
    name: "Signal Jamming",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Chose 1 non-home system that contains or is adjacent to 1 of your ships. Place a command token from another player's reinforcements in that system.",
    flavor_text: "Meian was practically aglow, wisps of her ether crackling with delight. It was amazing what could be achieved with a well-timed electromagnetic discharge.",
  ),

  ActionCard(
    card: SkilledRetreat,
    name: "Skilled Retreat",
    edition: BaseGame,
    amount: 4,
    trigger_text: "At the start of a combat round",
    effect_text: "Move all of your ships from the active system into an adjacent system that does not contain another player's ships; the space combat ends in a draw. Then, place a command token from your reinforcements in that system.",
    flavor_text: "(1) In an instant, the Sol fleet vanished from the Barony's scanners.        (2) The Creuss fleet was gone. No trace remained of their passage.        (3) T'ro gave the order, and the entire fleet withdrew without question.        (4) \"We have no choice, captain.\" Ciel looked nervous.\"We must retreat.\"",
  ),

  ActionCard(
    card: Spy,
    name: "Spy",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Choose 1 player. That player gives you 1 random action card from their hand.",
    flavor_text: "\"I'm no spy,\" Connor said, casually stuffing the data drives into his pack. \"Now, how can I get out of here without being seen?\"",
  ),

  ActionCard(
    card: Summit,
    name: "Summit",
    edition: BaseGame,
    amount: 1,
    trigger_text: "At the start of the strategy phase",
    effect_text: "Gain 2 command tokens.",
    flavor_text: "At the end of the twelfth day, Rev returned home from the summit in New Moscow feeling physically exhausted and mentally drained. But she was also satisfied. They had a plan - finally - and it was a good plan.",
  ),

  ActionCard(
    card: TacticalBombardment,
    name: "Tactical Bombardment",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Choose 1 system that contains 1 or more of your units that have Bombardment. Exhaust each planet controlled by other players in that system.",
    flavor_text: "A6's red eyes flickered with activity and a string of numbers flashed briefly across the screen before he spoke. \"Bombardment complete. All enemy installations have been neutralized.\"",
  ),

  ActionCard(
    card: TechnologyRider,
    name: "Technology Rider",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After an agenda is revealed",
    effect_text: "You cannot vote on this agenda. Predict aloud an outcome of this agenda. If your prediction is correct, research 1 technology.",
    flavor_text: "The Council granted the Yin funding to research an effective countermeasure to combat the virus. After all, keeping the Yin occupied with the virus meant killing two birds with one stone.",
  ),

  ActionCard(
    card: TradeRider,
    name: "Trade Rider",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After an agenda is revealed",
    effect_text: "You cannot vote on this agenda. Predict aloud an outcome of this agenda. If your prediction is correct, gain 5 trade goods.",
    flavor_text: "The Letnev councilor begrudgingly accepted the N'orr's core mining contract, if only so that the \"gracious\" Hacan senator didn't secure yet another source of income for his clan.",
  ),

  ActionCard(
    card: UnexpectedAction,
    name: "Unexpected Action",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Remove 1 of your command tokens from the game board and return it to your reinforcements.",
    flavor_text: "M'aban's voice was barely a whisper, cracking as hundreds of flashing lights appeared on her scanner. \"We've been tricked.\"",
  ),

  ActionCard(
    card: UnstablePlanet,
    name: "Unstable Planet",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Choose 1 hazardous planet. Exhaust that planet and destroy up to 3 infantry on it.",
    flavor_text: "Another quake shook the planet, and a wave of dirt and rock rose up to swallow the Tekklar legion.",
  ),

  ActionCard(
    card: Upgrade,
    name: "Upgrade",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After you activate a system that contains 1 or more of your ships",
    effect_text: "Replace one of your cruisers in that system with one of your dreadnoughts from your reinforcements.",
    flavor_text: "\"More guns?\" Connor shook his head. \"Not more guns. Let's try something bigger.\"",
  ),

  ActionCard(
    card: Uprising,
    name: "Uprising",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Exhaust 1 non-home planet controlled by another player. Then gain trade goods equal to its resource value.",
    flavor_text: "Harrugh leapt down from the ledge, gyro-spear blazing in the sunlight. In front, the L1Z1X began to take notice. Behind his warriors stood at the ready. Win or lose, this would be the end.",
  ),

  ActionCard(
    card: Veto,
    name: "Veto",
    edition: BaseGame,
    amount: 1,
    trigger_text: "When an agenda is revealed",
    effect_text: "Discard that agenda and reveal 1 agenda from the top of the deck. Players vote on this agenda instead.",
    flavor_text: "Magmus batted the now charred corpse aside with the back of his golden gauntlet. \"The Muuat reject your proposal.\"",
  ),

  ActionCard(
    card: WarEffort,
    name: "War Effort",
    edition: BaseGame,
    amount: 1,
    trigger_text: "As an Action",
    effect_text: "Place 1 cruiser from your reinforcements in a system that contains 1 or more of your ships.",
    flavor_text: "The N'orr may not be the most proficient shipwrights, but the willingness of their citizens to do their part far exceeds that of the other great races.",
  ),

  ActionCard(
    card: WarfareRider,
    name: "Warfare Rider",
    edition: BaseGame,
    amount: 1,
    trigger_text: "After an agenda is revealed",
    effect_text: "You cannot vote on this agenda. Predict aloud an outcome of this agenda. If your prediction is correct, place 1 dreadnought from your reinforcements in a system that contains 1 or more of your ships.",
    flavor_text: "Elder Junn sighed. \"Disarmament, it seems, has fallen out of fashion in these dark days.\"",
  ),
  // ActionCard(
//   card: Blitz,
//   name: "Blitz",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "At the start of an invasion:",
//   effect_text: "Each of your non-fighter ships in the active system that do not have BOMBARDMENT gain BOMBARDMENT 6 until the end of the invasion.",
//   flavor_text: "\"T-these weren't meant to be used like this. T-this is a t-terrible idea.\" Tai mumbled, wringing his hands. \"Well 'course it is,\" Dart grinned, slamming his fist down on the release lock. \"But we've got about sixty kilotons of 'surprise' and nothing to lose!\"",
// ),
//
// ActionCard(
//   card: Counterstroke,
//   name: "Counterstroke",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "After a player activates a system that contains 1 of your command tokens:",
//   effect_text: "Return that command token to your tactic pool.",
//   flavor_text: "\"That's the thing about loyalty - \" Viktor mused, turning one of the pieces backward, facing its own side. \"It can be bought.\"",
// ),
//
// ActionCard(
//   card: FighterConscription,
//   name: "Fighter Conscription",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "As an Action:",
//   effect_text: "Place 1 fighter from your reinforcements in each system that contains 1 or more of your space docks or units that have capacity; they cannot be placed in systems that contain other players' ships.",
//   flavor_text: "T'esla grinned as her shimmering vessel lifted off the flight deck - at last, that damned Viscount would experience the superiority of Naalu dogfighting. \"Get ready,\" she hissed into the comms.",
// ),
//
// ActionCard(
//   card: ForwardSupplyBase,
//   name: "Forward Supply Base",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "After another player activates a system that contains your units:",
//   effect_text: "Gain 3 trade goods. Then, choose another player to gain 1 trade good.",
//   flavor_text: "All eyes turned toward the darkening skies as the only surviving supply truck rolled through the gates. \"Get these checked in and send the last shipment to our allies!\" Harrugh yelled over the din of the engines.",
// ),
//
// ActionCard(
//   card: GhostSquad,
//   name: "Ghost Squad",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "After a player commits units to land on a planet you control:",
//   effect_text: "Move any number of ground forces from any planet you control in the active system to any other planet you control in the active system.",
//   flavor_text: "The L1 advance team was expecting to find the outpost abandoned. What they found - unfortunately for them - was Connor.",
// ),
//
// ActionCard(
//   card: HackElection,
//   name: "Hack Election",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "After an agenda is revealed:",
//   effect_text: "During this agenda, voting begins with the player to the right of the speaker and continues counterclockwise.",
//   flavor_text: "YOUR [NULL ID] STATELY GAME WILL BE FOR NAUGHT<<[VAR:42687] ORDER WILL ARISE FROM [VAR:89001] CHAOS<< IT IS OUR HAND THAT CONTROLS THE OUTCOME",
// ),
//
// ActionCard(
//   card: HarnessEnergy,
//   name: "Harness Energy",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "After you activate an anomaly:",
//   effect_text: "Replenish your commodities.",
//   flavor_text: "\"Manipulating the cosmos was a power reserved for the gods.\" Rowl spat at the ground as his contraption whirred to life. \"Not anymore.\"",
// ),
//
// ActionCard(
//   card: Impersonation,
//   name: "Impersonation",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "As an Action:",
//   effect_text: "Spend 3 influence to draw 1 secret objective.",
//   flavor_text: "\"Also,\" Connor continued, bemused. \"Someone just handed me this as I was leaving. I think it was meant for our dear friend Sucaban. We should be able to put it to good use.\"",
// ),
//
// ActionCard(
//   card: InsiderInformation,
//   name: "Insider Information",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "After an agenda is revealed:",
//   effect_text: "Look at the top card of the agenda deck.",
//   flavor_text: "M'aban yawned. Another filibuster. Politics could be so flavorless at times. Besides, she already knew how this one was going to turn out. Not well. Not well at all...",
// ),
//
// ActionCard(
//   card: MasterPlan,
//   name: "Master Plan",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "After you perform an action:",
//   effect_text: "You may perform an additional action this turn.",
//   flavor_text: "Viktor laced his long fingers with a wicked smile. Unlenn would be proud. The tactician's reputation was well-earned; even pawns could unseat kings.",
// ),
//
// ActionCard(
//   card: Plagiarize,
//   name: "Plagiarize",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "As an Action:",
//   effect_text: "Spend 5 influence and choose a non-faction technology owned by 1 of your neighbors; gain that technology.",
//   flavor_text: "The Yssaril spies handed over their prize to Connor, who in turn passed it to the Sol engineers with a grim smile. \"Now then, boys,\" he said, one hand on his rifle, \"about those loose ends...\"",
// ),
//
// ActionCard(
//   card: Rally,
//   name: "Rally",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "After you activate a system that contains another player's ships:",
//   effect_text: "Place 2 command tokens from your reinforcements in your fleet pool.",
//   flavor_text: "The Federation advance would not be halted - not today. Claire set her broadcast to play on all open channels. She began, her voice fierce and unwavering \"Friends! On this day, our names shall be inscribed in the pages of legend!\"",
// ),
//
// ActionCard(
//   card: ReflectiveShielding,
//   name: "Reflective Shielding",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "When one of your ships uses SUSTAIN DAMAGE during combat:",
//   effect_text: "Produce 2 hits against your opponent's ships in the active system.",
//   flavor_text: "Prit scrambled up Hesh's shoulder, gleefully clapping as the entropic shielding tore the mercenary cruisers apart.",
// ),
//
// ActionCard(
//   card: Sanction,
//   name: "Sanction",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "After an agenda is revealed:",
//   effect_text: "You cannot vote on this agenda. Predict aloud an outcome of this agenda. If your prediction is correct, each player that voted for that outcome returns 1 command token from their fleet supply to their reinforcements.",
//   flavor_text: "Two can play at this game.",
// ),
//
// ActionCard(
//   card: ScrambleFrequency,
//   name: "Scramble Frequency",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "After another player makes a BOMBARDMENT, SPACE CANNON, or ANTI-FIGHTER BARRAGE roll:",
//   effect_text: "That player rerolls all of their dice.",
//   flavor_text: "\"I will not accept this from that worthless scum!\" Feng growled as his enigmatic companion interfaced with the ship's nav suite. The Memoria's position flickered and shifted, and the blast flashed harmlessly by.",
// ),
//
// ActionCard(
//   card: SolarFlare,
//   name: "Solar Flare",
//   edition: Codex,
//   amount: 1,
//   trigger_text: "After you activate a system:",
//   effect_text: "During this movement, other players cannot use SPACE CANNON against your ships.",
//   flavor_text: "Meian braced for combat as the fleet entered the Ordinian system, but there were no Valefar droneships waiting to meet them. The solar flare gambit had succeeded - they were completely undetected.",
// ),
//
// ActionCard(
//   card: WarMachine,
//   name: "War Machine",
//   edition: Codex,
//   amount: 4,
//   trigger_text: "When 1 or more of your units use PRODUCTION:",
//   effect_text: "Apply +4 to the total PRODUCTION value of your units and reduce the combined cost of the produced units by 1.",
//   flavor_text: "(1) \"This would take weeks to replace if you had run it backwards,\" Varish called as she rotated the massive capacitor bank. \"Okay, fire it up.\"(2) The station vibrated as the device sputtered to life, emitting a high-pitched buzz to Varish's ears. \"Micro-wormholes are cycling at 19 kilohertz,\" Cole read. \"The entropic field tap's stable.\"(3) The station's production facilities spooled up to new intensities, lights flaring as the assembly line drones increased their speeds to keep up.(4) \"Varish, let the Commanders know they can contact the Tetrarchy. Tell them the fighter squadron assembly will be done ahead of schedule, and under budget.\"",
// ),
//
// ActionCard(
//   card: ArchaeologicalExpedition,
//   name: "Archaeological Expedition",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "As an Action:",
//   effect_text: "Reveal the top 3 cards of an exploration deck that matches a planet you control; gain any relic fragments that you reveal and discard the rest.",
//   flavor_text: "Hiari pressed the activation glyphs, and the ancient door hissed open. As she stepped into the pitch-black interior of the Mahact tomb, she felt a shiver of anticipation. Perhaps, finally, she would find the Codex.",
// ),
//
// ActionCard(
//   card: ConfoundingLegalText,
//   name: "Confounding Legal Text",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "When another player is elected as the outcome of an agenda:",
//   effect_text: "You are the elected player instead.",
//   flavor_text: "\"Unfortunately,\" Cinnabian said in a level voice, \"the Galactic Council requires the dispute be arbitrated by a truly neutral party. As the Titans were still slumbering when your war began, we will oversee your negotiations... instead of your friends on Jord.\"",
// ),
//
// ActionCard(
//   card: CoupDetat,
//   name: "Coup d'Etat",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "When another player would perform a strategic action:",
//   effect_text: "End that player's turn; the strategic action is not resolved and the strategy card is not exhausted.",
//   flavor_text: "Artuno shoved the slug pistol into Huro's face as armored mercenaries stormed into the office. \"I'm afraid the station's undergoing a change in management.\"",
// ),
//
// ActionCard(
//   card: DeadlyPlot,
//   name: "Deadly Plot",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "During the agenda phase, when an outcome would be resolved:",
//   effect_text: "If you voted for or predicted another outcome, discard the agenda instead; the agenda is resolved with no effect and it is not replaced.Then, exhaust all of your planets.",
//   flavor_text: "The hooded envoy erupted into a nightmare of black metal, lunging at the shocked diplomats.",
// ),
//
// ActionCard(
//   card: DecoyOperation,
//   name: "Decoy Operation",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "After another player activates a system that contains 1 or more of your structures:",
//   effect_text: "Remove up to 2 of your ground forces from the game board and place them on a planet you control in the active system.",
//   flavor_text: "Enemy fire lashed the abandoned positions on the ridgeline as Trilossa's flock slipped unseen around their flanks.",
// ),
//
// ActionCard(
//   card: DiplomaticPressure,
//   name: "Diplomatic Pressure",
//   edition: ProphecyOfKings,
//   amount: 4,
//   trigger_text: "When an agenda is revealed:",
//   effect_text: "Choose another player; that player must give you 1 promissory note from their hand.",
//   flavor_text: "(1) The Arborec emissary leaned close, and Brother Milor flinched at the faint whiff of decay. \"You do not understand,\" Dirzuga Ohao rasped. \"You must support this measure.\"(2) Brother Milor shook his head. \"The Brotherhood cannot support your war against this extra-dimensional threat.\" Dirzuga Ohao raised an eyebrow. \"Are you certain?\"(3) \"It would be unfortunate,\" the Arborec Dirzuga said, \"if your supplies of diraxium were to dry up. How would your fleet defend you if we stopped supplying its fuel?\"(4) \"Damn you!\" Brother Milor hissed. \"You leave us no choice but to fight in your war.\" Dirzuga Ohao smiled, dead skin stretching over her teeth.",
// ),
//
// ActionCard(
//   card: DivertFunding,
//   name: "Divert Funding",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "As an Action:",
//   effect_text: "Return a non-unit upgrade, non-faction technology that you own to your technology deck. Then, research another technology.",
//   flavor_text: "\"I am sorry, Academician,\" Arbiter Berekon shrugged. \"I am sure psychoarchaeology is an interesting subject, but the supreme leader feels your budget would be better spent on more militaristic research.\"",
// ),
//
// ActionCard(
//   card: ExplorationProbe,
//   name: "Exploration Probe",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "As an Action:",
//   effect_text: "Explore a frontier token that is in or adjacent to a system that contains 1 or more of your ships.",
//   flavor_text: "With a dull thud, the probe shot from the cruiser and accelerated into the writhing maelstrom of the gravity rift. Admiral DeLouis paced on the bridge. Hopefully, this time the probe would return.",
// ),
//
// ActionCard(
//   card: ManipulateInvestments,
//   name: "Manipulate Investments",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "At the start of the Strategy Phase:",
//   effect_text: "Place a total of 5 trade goods from the supply on strategy cards of your choice; you must place these tokens on at least 3 different cards.",
//   flavor_text: "\"But my good fellow,\" the envoy sputtered. \"Surely you can't expect me to agree to those prices!\" Durruq leaned in close. \"Check again. You may find your goods are trading for less than you think.\"",
// ),
//
// ActionCard(
//   card: NavSuite,
//   name: "Nav Suite",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "After you activate a system:",
//   effect_text: "During the \"Movement\" step of this tactical action, ignore the effects of anomalies.",
//   flavor_text: "\"The field is too thick!\" Sikosk gasped. Trrakan's plume flared. \"Not for me, and not for Iruth.\" A flick of his talon, and the destroyer flipped and dove for the asteroid field.",
// ),
//
// ActionCard(
//   card: RefitTroops,
//   name: "Refit Troops",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "As an Action:",
//   effect_text: "Choose 1 or 2 of your infantry on the game board; replace each of those infantry with mechs.",
//   flavor_text: "Sek'kus leapt from the trenches, the plasma projectors on her Valkyrie ekoskeleton howling as they scoured the field ahead of her.",
// ),
//
// ActionCard(
//   card: RevealPrototype,
//   name: "Reveal Prototype",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "At the start of a combat:",
//   effect_text: "Spend 4 resources to research a unit upgrade technology of the same type as 1 of your units that is participating in this combat.",
//   flavor_text: "Varish and Cole completed the final linkages, activating the field harvester. The cruiser's beams roared with renewed power, cutting through the enemy ship.",
// ),
//
// ActionCard(
//   card: ReverseEngineer,
//   name: "Reverse Engineer",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "When another player discards an action card that has a component action:",
//   effect_text: "Take that action card from the discard pile.",
//   flavor_text: "Xuange spread their hands over the captured harvester. Mirroring their careful gestures, dark energy fields unfolded and began delicately disassembling the device.",
// ),
//
// ActionCard(
//   card: Rout,
//   name: "Rout",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "At the start of the \"Announce Retreats\" step of space combat, if you are the defender:",
//   effect_text: "Your opponent must announce a retreat, if able.",
//   flavor_text: "Vuil'raith fleshships swarmed the weary defenders, sending unease and sweeping through the telepathic links. But Z'eu projected a powerful feeling of calm, and the Naalu fighters began to drive the Cabal back toward the rift.",
// ),
//
// ActionCard(
//   card: Scuttle,
//   name: "Scuttle",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "As an Action:",
//   effect_text: "Choose 1 or 2 of your non-fighter ships on the game board and return them to your reinforcements; gain trade goods equal to the combined cost of those ships.",
//   flavor_text: "Rear Admiral Farran saluted as he watched the blasted starship being towed to the scrap yard. \"You served me well,\" he whispered. \"Now you can serve the Barony once more.\"",
// ),
//
// ActionCard(
//   card: SeizeArtifact,
//   name: "Seize Artifact",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "As an Action:",
//   effect_text: "Choose 1 of your neighbors that has 1 or more relic fragments. That player must give you 1 relic fragment of your choice.",
//   flavor_text: "Armored dropships crashed into the main dock. Hatches blew open, and Captain Mentarion and her commando raider charged into the facility's heart.",
// ),
//
// ActionCard(
//   card: Waylay,
//   name: "Waylay",
//   edition: ProphecyOfKings,
//   amount: 1,
//   trigger_text: "Before you roll dice for ANTI-FIGHTER BARRAGE:",
//   effect_text: "Hits from this roll are produced against all ships (not just fighters).",
//   flavor_text: "The destroyers sprayed fire with their secondary batteries as they advanced. The Mahact dreadnought began to list, fire and atmosphere gushing from a thousand tiny wounds.",
// ),
]
