

local debug = false
local L = LibStub("AceLocale-3.0"):NewLocale("DarkAngel", "enUS", true, debug)
L.lang = "enUS"
--other
L["Scale"]=true
L['close']=true
-- Opt Menu
do
L["Whisper"]=true
L["Invite"]=true
L["Details"]=true
L["Twins"]=true
L['award']=true
L["add"]=true
L["I am not a guild officer"]=true
L["reason"]=true
L["value"]=true
L["G.Kick"]=true
L["requires Shift+Click"]=true
L["I am not allowed to kick guild members"]=true
L["target"]=true
L["focus"]=true
L["kick"]=true

end

--Log
do
L["Logging Config"]=true
L["No log is stored for this entry"]=true
L["gm_changes_in"]="Detected changes in $1 guild ranks"
L["gm_additions_in"]="Guild rank(s) added $1"
L["gm_removals_in"]="Guild rank(s) removed $1"
L["Guild Information changed"]=true
L["Guild Information added"]=true
L["Guild Information removed"]=true
L["Message of the day added"]=true
L["Message of the day removed"]=true
L["Message of the day changed"]=true
L["copy"]=true
L["separator"]=true
L["lines to print"]=true
L['addon_failed_recognize_gtype_set']="an addon have failed to recognize guild type. Setting up |cff00ffffEPGP|r mode as default"
L['addon_registered_gtype_change']='an addon registered guild type change'
L['DESCr-LogConfHelp']=[==[|cffff9999Logging options by data types|r
Here you can configure what data the addon will collect and store:
None - data of this type will not be collected
Last - only the latest changes ​​are logged
Full - full logging

|cffff9999When changing the logging method, some data of this type is erased according to settings|r
Full => Last - all data except the latest is deleted
Any => None - all data is deleted]==]
end

--Details
do
L["Minimum log"]=true
L["4 days"]=true
L["1 week"]=true
L["2 weeks"]=true
L["3 weeks"]=true
L["1 month"]=true
L["2 months"]=true
L["3 months"]=true
L["Search"]=true
L["Target"]=true
L['detmanchange']="|cffff00ffchange detected for "
L['detmcstr']="|cfff05541Possible done by:\n|cfff07930"
L['detmostlikely']="|cffb139edMost-likely by |cffaaffff"
L['detposby']='possible by:\n|cffba8222'
-- L['detnomsg']="|cff99ffaacmd, no msg |cffaaffff"
L['detinvited']="|cff22a0ffInvited by |cff99ffaa"
L['detkicked']="|cffffa022Kicked by |cff99ffaa"
L['detrerankedby']="|cff22a0ffChange by |cffaaffff"


L['deleted local']=true
L['deleted data']=true
L['old data']=true
L['detplinguild']='player is in guild'
L['detoldrecord']='probably an old incorrect record'
end

--Guild
do
L["DESCr-awardprocent_tt"]=[[|cffff9999Percentage-based award|r
To apply a percentage-based award/deduction, enter W followed by the percentage value in the "value" field:
   W100 - doubles the player's points (+100%)
  -W5   - deducts 5%
Deduction range: 0 < x <= 100
Award range: 0 < x <= 500]]
L["percentageAwardValueIsZero"] = "Player $1 has too few points — percentage-based award rounds to 0"
L['roster from backup']=true
L["hold_ctrl_for_more"]="|cff507375<Hold Ctrl to see more details>|r"
L["simplified_dkp_tooltip"]="|cffc96d6d<[DKP simplified]: The list of reasons may contain duplicates and extra entries>|r\n"
L['delete']=true
L["locals"]=true
L["online"]=true
L['reverse']=true
L["class"]=true
L["patterns"]=true
L["sort"]=true
L["clear"]=true
L["refresh"]=true
L["re-assign players assigned to"]=true
L["to the new main"]=true
L["Make it new Main"]='transfer\nmain'
L["name"]=true
L["lvl"]=true
L["note"]=true
L["officer note"]=true
L["rank"]=true
L['set']=true
L['cancel']=true
L['target is having a higher rank than me']=true
L['requested rank is too high']=true
L['target on the same rank as me']=true
L['same rank as me']=true
L['I cannot promote players']=true
L['I cannot demote players']=true
L['already this rank']=true
L['select at least one criteria']=true
L['Select at least one option mains/tvins to restore']=true


--Guild patterns
L['tvins']=true

L['DESCr-p_tvins']="Twins"
L['DESCr-p_mains']="Mains"
L['DESCr-p_frozen_main']="|cff7366eeFrozen Mains"
L['DESCr-p_frozen_tvins']="|cff7366eeTwins with frozen main"
L['DESCr-p_main_frozen_m']="All mains, normal and |cff7366eefrozen"
L['DESCr-p_dupl_tvins']="|cffff88ffDouble twins |r- player twinned to player who is twin"
L["DESCr-p_leaver_s_tvins"]="|cffb24c4cTwins of recent leaver|r = addon still keeps mains data in Details"
L["pattern name"]=true
L["All search fields are empty"]=true
L['DESCr-p_not_assigned']="Error twins, incorrect main nicknames or assigned to those who have left the guild long time ago"
L['DESCr-p_na_tvins']="Empty officer note (not assigned)"
L['DESCr-local_assign']="All local assignments stored in the addon (for current guild)"

--Guild micromenu Bulk
L['assigned to']=true
L['Bulk actions']=true
L["desaftblk"]='clear\nafter'
L['Apply to']=true
L['action']='Action'
L['selected']=true
L['all found']=true
L['no apply to selected']='no \'Apply to\' selected'
L['no action selected']='no \'Action\' selected'
L['no players found']=true
L["bulkstart"]='Start'
L["bulkstop"]='Stop'
L['no rank selected']=true
L["is not main"]=true
L["mains merged"]=true
end

--Backups
do
L['backup_reload_ui']='The backup you created will only be physically written to disk after you reboot the user interface. If you want additional assurance that the backup will be saved no matter what, it is highly recommended to reboot the user interface.\n\nDo you want to reboot now?'
L["guild MOTD"]=true
L["guild info"]=true
L["Guild GM system"]=true
L["Automatic_backups"]=true
L["Automatic_backups"]="|cffaaffa0Automatic backups"
L["Create_Manual_backup"]="|cffc490fcCreate Manual backup"
L["Create Backup"]=true
L["players data"]=true
L["full guild"]=true
L["Global_storage"]="|cffe0e022Global |rstorage"
L["Local_storage"]="|cff0de0cbLocal |rstorage"
L["joins_guild"]="has%sjoined%sthe%sguild"
L["number of automatic backups to keep"]=true
L["each"]=true
L["hour"]=true
L["Saved guilds"]=true
L["Saves"]=true
L["Restore data"]=true
L["restore backup mains"]=true
L["restore backup tvins"]=true
-- L["skip on filled note"]=true
-- L["skip on filled officer note"]=true
L["start"]=true
L["stop"]=true
L["Guild inviter"]=true
-- L["Secret phrase"]=true
L["passive restoration"]=true
L['passiverestdisabl']='passive restoration mode disabled'
L["restored"]=true

L['I am not allowed to edit public notes']=true
L['I am not allowed to edit officer notes']=true
L['I cant demote and/or promote']=true
L['I am not allowed to edit guild message of the day']=true
L['I am not allowed to edit guild information tab']=true
L['only guild master can use it']=true
end

--Gui2
do
L["reset"]=true
L['guild raid']=true
L['pure guild']="full guild"
L["DESCr-dkpCommTT"]=[[Defines the conditions for accepting messages:

|cffaaccffAlways|r — works even if you are not in a raid.
|cffaaccffIn Raid|r — requires both you and the message sender to be in a raid.
|cffaaccffGuild Raid|r — same as "|cffaaccffIn Raid|r", but the raid must consist of at least 70% guild members.
|cffaaccffFull Guild|r — same as "|cffaaccffGuild Raid|r", but requires 100% guild members (current and locally linked).
  -- With this option enabled, the linking command will only work for players who have already joined the guild but are not linked yet, 
  -- since for security reasons the auto-link command cannot modify existing guild or local links.]]
L["DESCr-OnlyInGuildRaid"]=[[Only in guild raid]]
L["DESCr-OnlyInFullGuildRaid"]=[[Strictly 100% of raid members must be in a guild or locally bound
Off: minimum 70%]]
L["DESCr-anyjoin"]=[[Join the first available raid announced in guild chat
The addon will track raids created through this addon, or announcements starting with "RT+" or "РТ+"]]
L["DESCr-ongRaidstt"]=[[Want to always be first into the raid? This menu is for you...
|cff507375This window tracks all active guild raid times created through this addon and displays a convenient clickable roster]]
L["inv_browser_join"]="found |cffffaaff$1|r raid(s)\n|cff507375<click to join>"
L['DESCr-invprovidediscord']=[[If someone asks for Discord in raid chat, the addon will automatically send the link you enter in the field below (the example link will not be sent).
Works only on messages with a clear request.
|cff507375It often happens that a person is fully capable of typing "+" in guild chat, yet somehow unable to find the Discord link in the guild info.|r]]
L['DESCr-Inviter_AdditInvitHelp']=[[In this menu, you can add players to the "invite queue" using other addon modules
|cffff9999Make sure the required options are selected before you start the inviter|r

--The Raid Snapshot option requires a previously saved raid "snapshot" and an active Awarder module. No magic here — if you didn’t save one, it won’t work. Shocking, I know.
--The selective invite option via Guild Tool lets you pick raid members from the guild window using Shift or Ctrl — just like in Windows. Ever used Windows before?
    |cff507375Well! Hello there! I don't believe we've been properly introduced.  I'm Bonzi!  What is your name?|r
--The "all found online" option (Guild Tool) will add all players matching the specified search criteria to the queue, with an additional check to ensure they are actually online. Not offline.
    |cff507375Want to build a raid of 25 DK tanks by setting class = Death Knight and note "bis tank"? No? Alright then.]]
L['DESCr-invAutostpdsc']=[[|cffaaccffSchedule raid invite stop|r
Supports 2 operating modes:
   -- <number> - inviter will stop after the specified amount of minutes; the timer is set after changing the value/switching the option/starting the inviter
   -- <time in 24:00 format> - uses local time instead of server time]]
L['DESCr-invRepMsgdsc']=[[Enabled: the addon takes your message (from the box below) and calmly reminds the guild
about the raid at the interval set by the slider on the right. Yes, repeatedly.

Disabled: one polite message at the start only,
but only if "start silently" is disabled.

It’s not spam. It’s persistence.]]
L["I am missing required guild permissions:"]=true
L["It looks like your guild rank doesn't allow you to read guild chat"]=true
L["It looks like your guild rank doesn't allow you to use guild chat"]=true
L["Please select at least one option for accepting players into the raid"]=true
L['DESCr-Inviter_AcceptFromLFG_messages']=[[Here you can come up with some secret phrases
that the addon will monitor in global chat channels.
As soon as such a phrase is detected, its author will be invited by the auto-inviter.

The message must be exactly equal to the phrase, not just contain it. The design is very human.
You can add multiple phrases, each on a new line.

Tip:
  1. Keep the phrases short
  2. The phrases should be simple, so no one guesses they’re a secret
  3. Drink more water]]
L['start silently']=true
L['DESCr-silentlstart']=[[Do not send initial message when starting
Announces on timer will be still sent, if enabled]]
L['Also invite:']=true
L['guild: all 80 lvl online']=true
L['Guild tool: selected']=true
L['Guild tool: all found online']=true


L['DESCr-inv_timer_tt']=[[|cffff9999Invite players to the raid using a timer|r
If you are playing on an older server that penalizes you for sending invites too frequently,
and/or the 'automatic invitations speed' does not work, this option is for you]]
L['DESCr-inv_fast_tt']=[[|cffff9999Automatic invitations speed|r
The addon will also track successful and unsuccessful invitations.
In case of failure, the sending speed will be reduced and the failed invitations will be repeated]]
L['DESCr-inv_instant_tt']=[[|cffff9999Instant invites|r
If your server does not have a limit on sending invites (for example, Warmane), this option is suitable for you
Raid invitations will be sent without a timer, immediately (without checking for success)]]

L['auto-stop timer re-set']=true
L['Raid inviter started']=true
L['Raid inviter is disabled now']=true
L['LFG samples are nil, LFG inviter disabled']=true
L['Ongoing raid']=true
L['RL/assist']=true
L['inv_RL']="RL: "

L["joining raid..."]=true
L["guild ping"]='ping'
L['raidinv_stop_msg']='# raid inviter is disabled now'
L['auto-stop']=true
L['join raid']=true
L['You are already in raid!']=true
L['Cant find any raids']="Cant find any raids. Come back tomorrow"
L["repeating announce"]=true
L['provide discord if asked']=true
L['send']=true
L['auto-join']=true
L['auto-accept party']=true
L['accept from guild chat']=true
L['accept from pm']=true
L['accept from global']=true
L['dispenser']=true
L['empty set']=true
L['You are not in raid']=true
L['minutes_short']='min'
L['Invite auto-stopped']="Invite auto-stopped $1"
L["Player not found"]=true
end

--opt
do
L["Store logs"]=true
L["Trusted players"]=true
L["Texture Options"]=true
L["Art texture alpha"]=true
L["BG texture alpha"]=true
L["texture presets"]=true
L['guild window alias button']=true
L['Additional binds']=true
L["EPGP decay precising"]=true
L['Group-up clear decay in Log']=true
L['Print leavers in chat']=true
L["example"]=true
L['Track suspicious changes']=true
L['DKP simplified']=true
L["Details for each player"]=true
L["Store leavers data"]=true
L['epgp: officer note warning']=true
L['epgp: multiple masters warning']=true
L['epgp: custom tvins and loot']=true
L['epgp: EP Auc']=true
L['raidroll_epgp: DarkAngel tvins']=true
L['commands on whisper']=true
L['in raid']=true
L["always"]=true
L["TXTArtOnFront"]="Front Art"
L["DESCr-TXTArtOnFront"]=[[|cffff9999Art layering|r
Controls which texture is rendered on top.

|cff88ccffEnabled:|r
The Art texture is displayed above the Background.
Useful for semi-transparent artwork while keeping the menu visually solid and readable through the backing layer.

|cff88ccffDisabled:|r
The Background becomes the front layer and softens the Art beneath it.
Perfect for dark UI styles with that "barely visible but definitely artistic" background everyone pretends was intentional.

|cffa19375If you have cranked everything to 100%, may the Light have mercy upon you... for I shall not.|r]]
L['share new locals']=true
L["DESCr-dkpcomm_sendLocals"]=[[New auto bindings created by players will be sent to "subscribers" in the guild
|cffa19375Screw security]]
L["List Players"]=true
L["Guild Rank"]=true
L["Guild Any"]=true
L["Raid Any"]=true
L["Disabled"]=true
L["DESCr-aw_trusted_players"]=[[|cffff9999Trusted Players|r
-Can give/remove the assistant role to themselves if you are the raid leader.
-Can share local character links with you:

|cff88ccffPlayer List|r — specify trusted player names below, separated by commas.
|cff88ccffGuild Rank|r — players with this rank or higher will be considered trusted.
|cff88ccffGuild|r — every guild member is trusted.
    |cff507375Are you absolutely sure this is what you want?..|r
|cff88ccffRaid|r — same as |cff88ccffGuild|r, plus any raid member can give themselves assistant.
    |cff507375What could possibly go wrong|r
|cff88ccffDisabled|r — Disabled
    |cff507375Allah once said: The safest system is the one nobody can use]]
L['Old data notice']=true
L["DESCr-OldDataDeletionPrint"]=[[When the retention period for a player who left the guild expires and their data is deleted, 
it will also be printed in chat as a last chance to copy it]]
L["Auto"]=true
L["Instant"]=true
L["By Timer"]=true
L["Invitations speed"]=true
L["Invite trigger"]=true
L["Stop message"]=true
L["Auto-stop message"]=true
L["Loot Method"]=true
L["more..."]=true
L["transfer_settings"]="transfer\nsettings"
L["DESCr-transfer_settings_tt1"]=[[|cffff9999Addon Settings Transfer|r
Most players will never need this feature, 
but it can be useful if you play on multiple accounts or want to transfer settings from one guild to another.]]
L["DESCr-transfer_settings_tt2"]=[[|cff88ccffThis menu allows you to|r
 1) transfer settings between different WoW accounts
   |cff507375if you have characters on another account and want to use the same addon configuration there|r
 2) transfer settings from one guild to another within the same account

Most settings are shared between all characters or stored separately per guild while still remaining account-wide, so a full profile system is unnecessary.

For your convenience, the data type checkboxes affect both which data 
will be exported and which of the provided data will be used.]]
L["Manual settings transfer"]=true
L["global setings"]=true
L["guild setings"]=true
L["import_settings_success"]="|cff00ffa0Settings imported successfully. |cffff8888To ensure proper functionality, it is highly recommended to reload the UI using /reload"
L["Migrate guild settings"]=true
L["DESCr-transfer_settings_tt3"]=[[|cff88ccffThis menu allows you to|r
Easily transfer addon settings from one guild to another within the same account.
|cffa19375Keep in mind that settings are copied with replacement|r

If you are not sure what you are doing, it may be a good idea to export the settings in the menu above first, so they can later be restored via import if needed]]
end

do -- Bid Tracker
L["current"]=true
L["MS Change"]=true
L["DESCr-mschange_rightclickmenu"]=[[|cffff9999Main Spec (MS) change for loot distribution|r
If a player wants to receive loot that does not match their raid spec, this menu will help you manage it.
The icons on the left show the spec and role currently detected by the addon. On the right are buttons for selecting the custom MS.

If a question mark icon is displayed instead of a spec, it means the addon currently has no data about the player’s spec.
If you do not intend to change a player’s MS, there is no need to manually set their current spec.

To change MS, in most cases, selecting the appropriate role or spec is sufficient. However, for some classes it may be necessary to specify both.
The setting is saved between game sessions and is automatically reset when entering a new raid.]]
L["Minimal bid"]=true
L["Bidder module is disabled. Enable it in main addon options"]=true
L["Any higher"]=true
L['ep-auc/dkp bid tracker']=true
L['only mine']=true
L["Bid tracker"]=true
L["Bid"]=true
L["Player"]=true
L["Bank"]=true
L['You cannot afford such bid. Your current credit is']=true
L['Your bid must be a multiple of']=true
L['when placing bid higher than']=true
L['when placing bid up to']=true
L["Spend"]=true
L["Give item"]=true
L["Time is up!"]=true
L["wins"]=true
L["Bet"]=true
L["No bids for"]=true
L["Bid cancelled!"]=true
L["Fill in the price"]=true
L["Select winner"]=true
L["Item or player not found"]=true
L["Item not found"]=true
L["Trade window opened with wrong player!!!"]=true
L["You are too far away from player"]=true
L["Bid raise settings"]=true
L["Up to"]=true
L["Step"]=true
L['Allow lower bids']=true
L["Auction Timer"]=true
L['Bids in thousands']=true
L["Step in thousands"]=true
L["'Bid confirmed' message"]=true
L["Allow 'all in'"]=true
L["winner"]=true
L["pause"]=true
L["infinite"]=true
L["DESCr-BT_winner"]=[[|cffff9999Announce the winner|r]]
L["DESCr-BT_countdown"]=[[|cffff99995-second countdown|r
Each second will be announced in a separate message
|cffff9999Motivation for slow players|r]]
L["DESCr-BT_timerpause"]=[[|cffff9999Pause countdown|r
Pause until another bid is placed]]
L["DESCr-BT_timerinf"]=[[|cffff9999Disable timer|r
The countdown will resume if you press any of the buttons on the left or start another auction]]
L["DESCr-BT_about"]=[[|cffff9999About Bid tracker|r
This module allows you to start boss loot "auctions" the same way many guilds do with QDKP or EPGP-auction systems.
|cff507375Addon supports both systems|r

|cffff9999How to use|r
  Drag an item from your bags into the appropriate slot in the module window to |cffd8d8a0start an auction|r.
  If you do not have the item, you can simply make a raid warning (/rw) with the item link.
After the announcement, the addon will track player bids in |cffd8d8a0raid chat|r as numbers and automatically run the auction.

When finished, you can give the item to the winner from your bags or from the opened loot window, and also deduct the required amount from the player's balance.

In the settings, you can change auction duration, bid acceptance and increment rules, as well as RaidRoll interaction.

|cff507375If you have RaidRoll with the Loot Tracker module installed, auctions can be launched very conveniently from it.
For a more detailed explanation, read the description of the "RaidRoll Interaction" option in settings (RaidRoll must be enabled).|r]]
L["RaidRoll Interaction"]=true
L['DESCr-auc_RR_collab']=[[|cffff9999RaidRoll interaction|r
If an item announcement in /rw does not contain the word 'roll', Bid Tracker will suppress RaidRoll from opening.

You can configure Main Spec / Off Spec roll messages in RaidRoll so that
one announces an auction, while the other contains the word "roll" and starts a normal roll.

|cff507375Example setup:
Esc > Interface > Raid Roll > Loot Window :
First template: Auction [Item]
Second template: Roll [Item]|r]]
L['DESCr-auc_bidconfirmed']=[[|cffff9999Send raid message confirming new bids accepted|r
Will also print current bid for 'all in's if it is enabled]]
L['DESCr-auc_allin']=[[|cffff9999Allow 'all in' bids|r
Bid equan to the player's total score (message=number) would be also calculated as 'all in'

'All in' bids are not subject to bid growth interwals]]
L['DESCr-auc_classspecinf']=[[|cffff9999Checking by class\spec|r
Color indication:
|cff888888member cannot wear item|r
can wear, but item does not match their spec
|cff1ced93can wear, item by spec|r
|cfffc96ffcan wear, matches MS Change|r

|cffff9999May work badly for some trinkets|r
The check function is very simple, so it is still recommended to use the head when distributing loot :)

The loots are recognized depending on stats and item type by following rules (simplified):
[Spell Power]
   SP+Spirit = healers, mainly priests and restoration druids
   SP+MP5 = wider range of healers
   SP+Hit = spellcasters, sorcerers, youkai and other ranged spellweavers
   SP = all casters and healers, as well as beer amateurs
[AttackPower]
   leather/mail melee bastards: hunters, rogues, enh shamans, kitties, sometimes paladins
[Strenght]
   plate melee damage: warriors, paladins, death knights
[Defense/Parry/Dodge]
   tin cans

Also, it should be noted that some items are prioritized by a strict spec,
for example, staves with SP+Spirit are defined as a priority for holy priests, what else did you expect from me :)]]
L['DESCr-LootTrackerOptHelp']=[[|cffff9999Setting up the rate growth|r
In this menu you can define the conditions under which proceeding bets will be accepted and set the growth conditions at each interval.

Please note that the "Step" value implies the required multiplier of the bet, and not the increase from the previous bet

For example, by setting the intervals
|cff22999920 — 1
100 — 5
300 — 20
and higher — 25|r
players will be forced to make bets of this format:
|cff2299991, 2, 3 ... 19, 20,
25, 30, 35, ... 95, 100
100, 120, 140 ... 280, 300
325, 350, 375, 400 ...|r

The addon will also not allow bets that violate the multiplicity within the interval, the increase must be to the smallest or closest multiple within the interval:
|cff22999919|r>|cffff999921|r/|cffff999924|r/|cffff999937|r/|cffff999999|r ...
|cff22999919|r>|cff00ffff20|r/|cff00ffff25|r/|cff00ffff45|r/|cff00ffff70|r ...]]
L['DESCr-auc_allow_lower']=[[|cffff9999Non-Competitive Bids|r
Allow players to place bids lower than the current winning bid
|cff507375In time, you will come to understand the value of this option]]
L['DESCr-auc_thousands']=[[|cffff9999Thousands Betting Mode|r
Small bids placed by players will be multiplied by 1000:
    1=1000;     45=45000
All settings on this screen will also be multiplied.

Bids above 1000 will be processed normally:
    2000=2000;  3121=3121]]
L['DESCr-auc_bidBtnsTutorial']=[[If you are already familiar with the functions of the "winner" "5" "pause" and "infinite" buttons
in the main window, and the explanatory tooltips are getting in your way, you can disable this option.]]
L["guide"]=true
L["bid_accepted"] = "'s bid accepted"
L["all_in_bid_accepted"] = "'s ALL IN accepted"
end

--EP Awarder
do
L['empty groups']=true
L['hide more']=true
L["DESCr-hideemptygrps"]=[[|cffff9999Hide groups with no players|r
If the option below is disabled, the addon will check groups starting from group 8
and stop once it finds a group that contains players.

With the "hide more" option enabled, all empty groups will be hidden.]]
L["DESCr-aw_sc_bossfights"]=[[Show only boss fights

|cffff9999This affects all scada logs processing, not only this list|r]]
L["DESCr-aw_sc_long"]=[[Show only long (>2min) fights

|cffff9999This affects all scada logs processing, not only this list|r]]
L["DESCr-aw_readycheck"]=[[Run a ready check]]
L["DESCr-aw_auto_locals"]=[[|cffff9999Automatic Locals|r
When one of the "Trusted Players" creates a local binding, you will automatically save it as well
|cff507375Only a small percentage of viewers are actually subscribed]]
L["DESCr-aw_auto_Ch_locals"]=[[If the received local binding modifies an existing one, it will be accepted automatically
If disabled, such a binding is skipped]]
L['subscribe to auto locals']=true
L['apply changes']=true
L['silent mode']=true
L["DESCr-dkpWhispers"]="Send whispers for DKP awards instead of guild chat messages"
L["dkpWhispers"]="DKP: whispers"
L["Promoted to Raid Assistant: "]=true
L['disband raid']=true
L["DESCr-take_assistant"]=[[Request for Raid Assistant
Will work only if the Raid Leader has DarkAngel installed and you have the needed permission

If you are already have this status, it will be removed]]
L["DESCr-disband_raid"]=[[Disband raid
|cffff9999Requires Ctrl+Shift+Alt+Click]]
L["Do not forget to do the guild assignments:"]=true
L["New player in guild or not assigned tvin?"]=true
L["Not in guild , not assigned or assigned incorrectly?"]=true
L["You can set your main via '?main <name>' command. You need to PM me this"]=true
L["Relax, nothing's broken, ease off the clicking!"]=true
L["DESCr-fep_check"]=[[print a list of non-assigned players in the raid chat and instructions on how to assign, if this option is enabled.
I recommend enabling the option "'commands on whisper'" in the addon options menu, in the main window]]
L["Raid Role Summary"]=true
L["roleshelp_details"]="Click to see $1 values"
L["N/A spec"]=true
L['Raid difficulty']=true
L['DESCr-Raid difficulty']=true
L["Lock raid"]="Lock"
L["Unlock raid"]="Unlock"
L['From EPGP settings']=true
L['Use custom']=true
L["No new locals found"]=true
L["load"]=true
L['lock raid']=true
L['save raid']=true
L['save']=true
L["raid is empty"]=true
L['awarder_warn']="Double-check if\nthe awarding values\nare correct"
L["Skada db"]=true
L['party']=true
L['test']=true
-- L['award']=true
L['criterias']=true
L['setname']='name'
L['show locals']=true
L['fepfor']='to'
L['auto']=true
L['darken_offline']="offline"
L['apply']=true
L['getlocals']='locals'
L['ask guild']=true
L['export']=true
L['qDKPexp']='qDKP'
L['qDKP addon not found']=true
L['standby']=true
L['fepassign']="Assign!"
L['and higher']=true
L['no people saved']=true
L['players saved']=true
L['hold Shift to see names']=true
L['alt-click to DELETE all saved characters']=true
L['award for raid']=true
L['award for leader']=true
L['guild rank award']=true
L['Skada-based award']=true
L['tanking award']=true
L['healer award']=true
L['meelee dps award']=true
L['ranged dps award']=true
L['Skada logs not found']=true
L['failed to determine Skada version. Report this bug']=true
L["no Scada logs were found. It would be not possible to set checking mode for specific bosses, only for total"]=true
L['remmarkpl']=[[remember marked players.
does not work with "set all" buttons, 
(the ones with verticall criteria name, in the main window)]]
L['remmandcl']=[[role+class matching
|cffff88ffexample: role: meelee +class shaman and paladin - all retri paladins and enhance shamans will be marked with this criteria|r
if disabled, will mark any matching role/class players]]

L['AW_raid68']=[[raid 6-8]]
L['AW_skada68']=[[skada 6-8]]
L['AW_saved68']=[[saved 6-8]]
L['AW_roles68']=[[roles 6-8]]
L['DESCr-AW_raid68']=[[set "raid" criteria for all raid members
if disabled, only 1-5 parties will be marked]]
L['DESCr-AW_skada68']=[[do skada checks for all raid members
if disabled, only 1-5 parties will be processed]]
L['DESCr-AW_saved68']=[[mark saved players in all the raid
if disabled, only 1-5 party saved players will be marked]]
L['DESCr-AW_roles68']=[[mark roles and classes for all raid members
if disabled, only 1-5 parties will be marked]]
L['setalldescr']=[[|cff1eebe4Click|r - mark/unmark all
|cff1eebe4Ctrl+Click|r - add automatic marks
|cff1eebe4Ctrl+Shift+Click|r - overwrite marks with automatic marks
|cff1eebe4Right click|r - inverse current marks]]

L['zamclear']='c\nl\ne\na\nr'
L['enable']=true
L['raid award']=true
L['anonszam']='declare'
L['zamclearafteraward']='clear after\naward'
L['6-8 standby']=true
L['profile']='set'
L['jokes']=true
L['zamprocep']='%standby award'
L['zamenagudok']='# whisper me \'epgp standby\' to join the raid standby'
L["settingep0"]="Player $1 has less EP than you’re trying to spend ($2). EP set to 0."
L["settinggp0"]="Player $1 has less GP than you’re trying to spend ($2). GP set to 0."
L['seems you forgot to enable some checks']=true
L['Awarder_start']='|cff00ffffStarting award...'
L["ignored"]=true
L['removed from standby, present in raid']=true
L['I am not RL/assist']=true

L['fepupdating']='|cffeedd00updating...'
L['fepupddone']='|cff88ffbbfinished'
L['raid frames locked!']=true
L['no such player in guild']=true
L['[OK] local created, however, main is frozen']=true
L['this is a dublicated tvin!']=true
L['local de-assigned, was assigned to']=true
L['local tvin']=true
L['cannot set nil criteria for #']=true
L['cannotset2']="cant give name \"$1\" for #$2 criteria ; #$3 is named the same"
L['error, i cant read officer notes']=true
L['i cant edit officer notes']=true
L["[FROZEN]"]=true
L["Your main is"]=true
L["Your character is main in guild"]=true
L["Your character is main in guild (empty note = main). You can set your main via '?main <name>' command"]=true
L["No such character found in guild - "]=true
L["You cant assign your character to itself. dumbass (respectfully)"]=true
L["Your credit is"]=true
L["Broken guild officer note. You can set your main via '?main <name>' command"]=true
L["Broken guild officer note (double tvin). You can set your main via '?main <name>' command"]=true
L["You are not in guild and not assigned. You can set your main via '?main <name>' command"]=true
L["Broken local assignment. You can set your main via '?main <name>' command"]=true
L["Cant change main automatically"]=true
L["Cant change local assignment automatically"]=true
L["You are already assigned correctly"]=true
L["This main is frozen. Do you want to un-freeze it?"]=true
L["Your current values are frozen. You need to un-freeze it?"]=true

L['funny phrases not found. Using backup']=true
L['heart attack']=true
L['character already in raid']=true
L['is already in raid']=true
L['is already on standby']=true
L['added on standby']=true
L['added to the Death Note']=true
L["seems you got incorrect officer note in guild (double tvin). Contact officer to fix it"]=true
L['seems your main got frozen epgp. Contact officer to fix it']=true
L['seems you got frozen epgp. Contact officer to fix it']=true
L['you are locally assigned, try to use standby without main nickname']=true
L["You are not in guild. Try adding your main nickname: epgp standby Player"]=true
L["there is no such main in guild"]=true
L["corrupted local assign. The Old Buddy is back?"]=true

L['removed from standby (doubled)']=true
L['removed from standby (not in guild)']=true
L['removed from standby (bad note)']=true
L['removed from standby (frozen)']=true
L['removed from standby (frozen main)']=true

L['empty note']=true
L['in raid on Main']=true
L['new player or not tvined?']=true
L['in raid on 2+ chars']=true
L['this one is main']=true
L['main is frozen']=true
L['un-frozeeze main']=true
L['frozen']=true
L['decay']=true
L['twined']=true
L['new player']=true
L['deserter']=true
L["re-joined"]=true
L["suspic/twin"]=true
L['un-freeze']=true
L['invalid note']=true

L["You have zero Skada logs available; skada checks are skipped"]=true

L['AW_frozen']="|cff2299ffPlayer is frozen|r \nShift+RightClick to un-freeze.\n"
L['AW_frozen_main']="|cff2299ffPlayer's main is frozen|r \nShift+RightClick to un-freeze.\n"
L['AW_empty_note']="Empty officer note \nIs it someone's alt or new player?\n\nNote: \""
L['AW_empty_note_1']="\" \n\nLeftClick - open assignment menu\nShift+RightClick - set default zero officernote"
L['AW_empty_note_2']="\" \n\nYou cannot actually do anything with it. Useless scum"
L['AW_not_in_guild1']="Player not in guild \nShift+RightClick to invite"
L['AW_not_in_guild2']="Player not in guild \nYou dont have permission for guild invites"

L['AW_local_ex1']="locally assigned to non-guild player \nleaver's local tvin?\n\n"
L['AW_local_ex2']="locally assigned to player with incorrect EPGP value (comma instead of dot separator) \n(fucked up)\n\n"
L['AW_local_ex3']="locally assigned to player with incorrect EPGP value (comma instead of dot separator) \nby the way, main is also frozen, all possible fucked up.\n\n"
L['AW_local_ex4']="local tvin's tvin \n\n"
L['AW_local_ex5']="corrupted note, idk what it is #1 \n\n"
L['AW_local_ex6']="incorrect EPGP value (comma instead of dot separator)"
L['AW_local_ex7']="incorrect EPGP value (comma instead of dot separator)\nis also frozen"
L['AW_local_ex8']="assigned to non-guild player"
L['AW_local_ex9']="assigned to player with incorrect EPGP value (comma instead of dot separator) \n(fucked up)"
L['AW_local_ex10']="assigned to player with incorrect EPGP value (comma instead of dot separator) \nby the way, main is also frozen, all possible fucked up."
L['AW_local_ex11']="tvin's tvin"
L['AW_local_ex12']="corrupted note, idk what it is #2 "

L['Standby']=true
L['group']=true
-- L['clear all marks']=true
-- L['reset all']=true
end

--GC
do
L["skipped"]=true
L['not required']=true
L['no transpositions']=true
L['moving players disabled']=true
L["lock ranks"]=true
L["unlock+save rank permissions"]=true
L['create guild backup']=true
L['add/remove ranks']=true
L['freeze ranks']=true
L['save rank permissions']=true
L['move players']=true
L["Save options"]=true
L['import']=true
L['players']=true
L['mover']=true
L['guildchat_listen']="guildchat: listen"
L['guildchat_speak']="guildchat: speak"
L['officerchat_listen']="officerchat: listen"
L['officerchat_speak']="officerchat: speak"
L['promote']=true
L['demote']=true
L['invite_member']="invite"
L['remove_member']="kick"
L['set_motd']="message of the day"
L['edit_public_note']="note: edit"
L['view_officer_note']="officer note: view"
L['edit_officer_note']="officer note: edit"
L['modify_guild_info']="guild info change"
L['withdraw_repair']="repair"
L['withdraw_gold']="withdraw gold"
L['create_guild_event']="create events"
L['gwithraw']='gold withdraw'
L['Bank Tab']=true
L['bank_tabs_notes']="View/Put/Edit info | Take stacks per day"
L["create new rank here, shift rest right"]=true
L["create duplicate rank, shift rest right"]=true
L["clear permissions"]=true
L["delete rank, shift rest left"]=true
L['gc_helper']=[[This menu provides a guild rank system visualization where you can:
  —add/remove* any ranks including intermediate ones
  —move players between ranks
  —edit guild/-bank permissions for all ranks at once
  —create a template of the guild rank system
  —build a guild rank system from a template
*there is a limit on the minimum/maximum number of ranks

|cffff9999All changes are virtual. To save changes you must be |cffaaccffGuild Master|r]]
L["got it, close"]=true
end

--Descriptions
do
L["DESCr-procepzam_usemanual"]=[[|cffaaccffDetermines the standby percentage|r
  |cffff9999Disabled|r:
    The standby receives a percentage of the raid reward based on the EPGP addon settings in "O > Guild > Info" :
      -EPGP-
      @BASE_GP:1
      @DECAY_P:30
      @MIN_EP:0
      |cffaaccff@EXTRAS_P:70|r << defines the percentage
      -EPGP-

  |cffaaccffEnabled|r:
    The percentage is set manually.]]
L['DESCr-bt_open']=[==[You got tricked :)
Hit Ctrl+Alt+O baka
Btw, I recommend to get used to binds :)]==]
L['DESCr-whatthepricol']=[[Replaces boring standby confirmation messages with Death Note–style dramatic lines:

[G] [Yourname]: Player1 added on standby
becomes
[G] [Yourname]: Player1 added to the Death Note (Didn't call the she-healer 'doctress').

The quoted joke at the end is randomly selected from the list on the right.]]
L['DESCr-lootBtnSelect']=[==[Set looting method]==]
L['DESCr-awgrpmover']=[==[|cffff9999   Drag|r
Move group members to another group

|cffff9999   Shift + Drag|r
Swap group members with another group
If any of the groups have 4/5 players, some will be moved in transit through the free groups to avoid overflow]==]
L['DESCr-logCleandesc']=[[|cffff9999Store players data for the specified time|r
When changing the storage period to a shorter one, excessive data will be gradually deleted]]
L['DESCr-minlog']=[[An addon will always keep this amount of log entries for any data type with "Full" logging]]
L['DESCr-doginviter_d']=[[|cffff9999Enable automatic invitations|r
An addon will monitor all available chat channels for the specified "secret phrase" and once such is found, send guild invite to an author

Is a perfect solution along with 'passive restoration' option when you need to migrate members between guilds]]
L['DESCr-patternsFrame_save']=[[|cffff9999Save current search settings as a template|r
Often using complex search criterias? For example, wanna see "mains" with "<5" rank? (try it) ? - create a pattern with this option

|cff2282aaClick the button, and the world of automation will open for you! 
Save a search template with the new adaptive design that’s always by your side. 
We are trusted, and you’ll be proud of how easily everything works. 
Need help? Just add water and enjoy the process!]]
L['DESCr-Backup_seedata']=[[|cffff9999See player's stored data|r
notes, officer notes, ranks, local twins, whichever is present in the backup]]
L['DESCr-Backup_seeGMranks']=[[|cffff9999See stored guild ranks system|r]]
L['DESCr-do_decay_checks']=[[|cffff9999Enable EPGP Decay checks|r
Useful for EPGP guilds that do Decay]]
L['DESCr-auto_cbs']=[[|cffff9999Automatic checkbox assignment|r
Automatically assigns reward checkmarks to all raid members according to the automation settings (gear icon menu).
|cff88ccff+Shift|r - also removes checkmarks that do not match the automation rules

|cff943838If you truly want to experience the full joy of automation, it is highly recommended to explore these settings,
as well as the explanatory tooltip in the settings menu next to the close button|r]]
L['DESCr-autoopt_tt']=[[|cffff9999Automation settings|r |cff507375(please forgive me for this)|r
Each bonus entry in the main window has condition icons displayed next to it.
These conditions determine who will automatically receive the mark for that bonus.

Multiple conditions can be assigned to the same bonus.
For example, the |cff88ccfftank_heal|r bonus may include both |cff88ccffTank|r and |cff88ccffHealer|r conditions
— in this case, both roles will receive the same bonus.

|cffff9999Condition types:|r
  - Raid participation reward — available only for Bonus #1
  |cff88ccffGroup 1 — raid roles:|r
    - Tank/Healer/Melee/Caster
    - "Memory" mode — see the condition tooltip for details
      |cff507375may be useful as bis character bonus|r

  |cff88ccffGroup 2 — classes:|r
    - Conditions based on player class
    - Can be combined with raid roles
    - Supports AND / OR modes

  |cff88ccffGroup 3 — miscellaneous:|r
    - Skada-based rewards (uses data from the latest kill of the selected boss)
      Examples for "Deathbringer Saurfang"
        mode:"damage done to enemy"="Blood Beast", condition:"top X"=3 |cff507375— top 3 damage dealers on adds|r
        mode:"damage done (DPS)", condition:">= X"=20000 |cff507375— players with 20k+ DPS|r
    - Raid Leader bonus
    - Guild rank bonus

|cffff9999Raid conditions:|r
  Some conditions depend on the player's raid group number.
  By default:
  - raid participation bonuses apply to groups 1-8
  - role, Skada, and "Memory" bonuses apply only to groups 1-5
  This behavior can be changed.

|cffff9999Additional options:|r
  - change the number of bonuses (3-8)
  - select the Skada data source
  - create and switch bonus profiles

|cff507375One day, in a dream, you had the idea to create two additional profiles besides the main one — each containing 8 bonuses,
with every bonus having carefully designed "Skada"-based conditions.
Then export the profiles and make all guild officers clear their Skada logs before raids,
and distribute rewards strictly according to this new "standard"...

Find someone reasonably sane and delegate this task to them :)|r]]
L['DESCr-desc_evaluate']="Show alternative officer notes"
L['DESCr-desc_onlinefirst']="sort online and offline players separately; put online players at the top of the list"
L['DESCr-desc_reverse']="reverse sort"
L['DESCr-onltvingrps']=[[|cffff9999Perfect sorting for kicking AFK players|r
Groups mains with their alts and determines the most recent online activity across all characters,
then sorts such groups by last online time.
|cffa19375For this to work correctly, enable both online and offline player display and clear all search fields!]]
L['DESCr-gc_run_notif']=[[The needed options are already enabled, depending on the changes you have made
However, you can surely make adjustments]]
L['DESCr-gc_createbackup']=[[|cffff9999Create a full guild backup before making changes.|r

If you are making massive changes and want to be on the safe side, I recommend creating such a backup manually in the Backups tab and doing /restart.
This way you can guarantee that the backup will be saved no matter what, even if your game crashes,
since the addon's memory is written to disk only during an UI reboot]]
L['DESCr-gc_matchranks']=[[If the number of ranks in the guild does not match the one in the template, the addon will add/remove the needed rank(s)]]
L['DESCr-gc_lockranks']=[[If enabled, the addon will lock all permissions for all ranks (except GM) for the duration of the process.
The usefulness is due to the non-simultaneous changes in rank system and the movement of players through ranks

In short, this is usefull when simultaneously changing rank permissions and moving players in large guilds]]
L['DESCr-gc_saveranks']=[[Actually save the permissions of all ranks as set in this window]]
L['DESCr-gc_moveplayers']=[[Move players in the guild between ranks, as set in this window
Will be skipped if there is nothing to move

|cffff9999Warn guild players before starting, there will be a LOT of spam :)]]
L['DESCr-clallmarks-confirm_rightclick']="Clear all marks\n|cffff9999requires right click"
L['DESCr-confirm_rightclick']="|cffff9999requires right click"
L['DESCr-awlocalstt_ask']=[[An addon will try to check if there are any available locals in guild 
(there should be someone else who has this addon)]]
L['DESCr-awlocalstt_import']=[[Import locals from the list below]]
L['DESCr-awlocalstt_export']=[[Export list of locals currently stored in the addon
Why?:)]]
L['DESCr-awlocalstt_qdkp']="If you have QDKP addon enabled, we may try to fetch the local assignments from there, so you can import it to DarkAngel"
L['DESCr-awlocalstt_qdkp_sync']="Import locals from DarkAngel to QDKP"

L['DESCr-ZamenaFrBtn']=[==[|cffff9999Additional standby|r
Useful when there is not enough space in the raid to keep the standby players
Players can whisper "epgp standby" (by default) to you to join standby

The list of players is saved even when you re-enter the game (saved within your account>guild)]==]
L['DESCr-additionalbinds']=[==[|cffff9999Additional binds|r
|cffaaccffCtrl-O|r — Open main addon window (Guild)
|cffaaccffShift-O|r — Open Inviter
|cffaaccffCtrl-Shift-O|r — Open Flask Dispenser
|cffaaccffAlt-O|r — Open Awarder window
|cffaaccffCtrl-Alt-O|r — Open EP-Auc/DKP bid tool]==]
L['DESCr-GCmover']=[==[|cffff9999   Click|r
Open the rank options menu

|cffff9999   Right click|r
Display all guild members on this rank

|cffff9999   Drag|r
Move rank or swap places with nearby rank
Hold Shift to move players
Hold Ctrl to move the rank along with the players
|cffff9999***Note that moving ranks does not move players, so you might need to also move players between ranks since
they will remain at their current rank IDs. You can blame Blizzard for dis :)|r]==]
L['DESCr-bidtracker']=[==[Track "Raid Warning" messages containing itemlinks
If such message was spotted, the addon will open a special tool for bidding items via EP-auc/DKP systems]==]
L['DESCr-loadsave']=[==[|cffff9999load stored raid|r
Click — load selected save (players + award checks)
Shift + Click — load players only
Ctrl + Click — load award checks only
Alt + Click — print raid composition link
  (player names with non-verified specs would have @@)]==]
L['DESCr-saveraid']=[==[save current raid members and their award checks]==]
L['DESCr-sixeightdet']=[==[|cffff99996-8 parties - standby|r
The addon will treat players in 6-8 groups as standby as well
These players will be shown in the "stock" menu on the right
Such players also receive only % of %raid% (first tick) award
(if the option below is enabled)]==]
L['DESCr-darkenoffline']=[==[|cffff9999Darken offline players|r
darkening may not work for all players
in locked raids or loaded snapshots]==]
L['DESCr-dkpcomm']=[==[|cffff9999On whisper commands|r
|cffaaccff?dkp|r / |cffaaccff?epgp|r - Get player's DKP/EPGP values
|cffaaccff?main|r <|cffaaccffnickname|r> - assign in-guild player to their main
           (non-guild players will be assigned locally)]==]
L['DESCr-warnsuspic']=[==[|cffff9999Chat transaction verification|r
addon will try to verify each spotted transaction
comparing it with recent guild/whisper messages
If there were no messages for some transactions, addon will warn you

May work incorrectly with DKP guilds

original DKP addon may not always send such notifications and does not sent internal msgs like EPGP addon does
(DKP awards made via DarkAngel should work fine)]==]
L['DESCr-warn_improv_suspic']=[==[|cffff9999Less strict verification of DKP transactions|r
If any of the guild officers use the standard DKP addon when making awards
there may be a time discrepancy between the award messages and the moment when these changes are "Sent"
when closing the award session in the QDKP addon

If there are math teachers in the guild, they can use this with malicious intent]==]
L['DESCr-disp_speed']=[==[Set speed at which an addon will create and dispense stacks.
Also affects global dispenser sequences.

0.1 option is the fastest one
If the module keeps failing stacks creations, especially if you dispense 
a lot of items of the same type for many roles, you may think of increasing this value (0.2 should work just fine)
|cff99eeeeDefault|r: 0.15]==]
L['DESCr-LogHelp']=[==[The time displayed for each line is colored |cff4d7f7fgreen|r
for changes that were noticed online, so the changes are fairly accurate.
For changes that happened while you were offline, their times are marked |cff7f4d4dred|r.
The red values ​​are not as accurate, as they show the overall difference and represent when the change was |cffffaaffnoted|r, not committed

(+10+20+30-50 in |cff4d7fonline|r mode would be shown as +10 in |cff7f4d4doffline|r mode)]==]
L["DESCr-DetailsHelp"]=[==[asdasd]==]
L["DESCr-GuildHelp"]=[==[asd]==]
L["DESCr-storeautoman"]=[==[If selected, the backup will be saved in local character storage
and will be not accessible from other characters on the same account.
Good for automatic backups
If deselected, the backup gets saved in account-wide folder
(accessible from all of the characters on the same account. Uses more memory.)
Good for manual backups]==]
L["DESCr-doautohours"]=[==[By default, an addon creates |cffaaffff1|r automatic backup per day on login
This option will force an addon to create backups periodically, once per |cffaaffffN|r hours
(Possible range: 1-10 hours)]==]
L["DESCr-bckgmckb"]=[==[Restore guild ranking system.
It includes all guild ranks, their guild and guild bank permissions
Only Guild Master can use it]==]
L["DESCr-bckpassive"]=[==[tracks new players joining guild and restores their data from the selected backup]==]
L["DESCr-bckpassive"]=[==[|cffff9999Enable passive restoration mode|r
Monitors players joining the guild and attempts to restore their data from the selected backup, if possible
Restoration occurs with a delay of 10-15 seconds, since a newly joined player may not immediately appear correctly in the guild]==]
L["DESCr-bckprm"]=[==[Restore players data that are stored as |cffa0ffffmains|r |cffffaaaain the backup|r
(having main values in the officer note)]==]
L["DESCr-bckprt"]=[==[Restore players data that are stored as |cffa0fffftvins|r |cffffaaaain the backup|r
(having non-main values in the officer note)]==]
L["DESCr-bckpin"]=[==[When processing, skip actual guild members that are having
any |cffaaffffnote|r filled]==]
L["DESCr-bckpio"]=[==[When processing, skip actual guild members that are having
any |cffaaffffofficer note|r filled]==]
L["DESCr-pricolsedit"]=[==[Edit list of jokes]==]
L["DESCr-BulkHelp"]=[==[|cffff9999Bulk actions menu|r
|cff88ccffApply to|r - players the bulk will be applied to:
   |cff88ccffselected|r - |cff88eeffselect players in Guild list via|r
      --Ctrl+click (one player) 
      --Shift+click (many players) -same way as you do in Windows
   |cff88ccffall found|r - use all players found
      (taking into account the current search criteria)

|cff88ccffStart|r - launch bulk
|cff88ccffStop|r - try to stop the running bulk [ be careful, some operations are very fast ]]==]
L['DESCr-BulkHelp2']=[==[If you are unsure of what you are doing,
you can create a full guild backup in the 'Backup' tab :)
With a backup, it will be possible to quickly roll back any changes, except, perhaps, a kick from the guild]==]
L["DESCr-optmenuleader"]=[==[Left click - give Assist
Shift+Right click - set new |cffff5555Raid Leader|r]==]
L["DESCr-awardlocker"]=[==[|cffff9999Freeze Window|r
Useful before awarding, if there are raid members prone to leaving
or if you want to do award outside of raid.

data is NOT stored on logout -use Snapshots]==]
L["DESCr-precisematchsearch"]=[==[|cff88ccffEnabled|cffffffff:|r Show only players matching |cffaaccffall|r entered search fields:
Searching "bis" in |cffaaccffnote|r and "m" in |cffaaccffonline|r will show only bis players inactive for more than a month.

|cff88ccffDisabled|cffffffff:|r Show players matching |cffaaccffany|r entered search field:
Searching "bis" and "m" will show players matching at least one of the values.
|cff507375The "twins" and "clear" buttons also toggle this function|r]==]
L["DESCr-grefr"]=[==[Automatically refresh data.]==]
L["DESCr-procepzamene"]=[==[Players on standby and 6-8 party (if the option above is enabled) will receive % of the raid award
Raid award is the first award criteria (mark)

Off: 100%]==]
L["DESCr-showlocals"]=[==[|cffaaccffEnabled|cffffffff:|r Include non-guild characters locally bound with guild mains
|cffaaccffDisabled|cffffffff:|r (default) Show only guild members]==]
L["DESCr-mmenuqcopy"]=[==[While typing in "note" or "officer note" fields, the sidebar copy menus will be shown automatically.]==]
L["DESCr-mmenuleavefocus"]=[==[Leave the typing focus untouched in officer/note while selecting a player
so you can select players one-by-one and fill in the needed officer/notes manually/via Ctrl+V
If disabled, the typing focuses will be cleared.]==]
L['DESCr-mmenucloserank']=[==[Close rank selection after change]==]
L["DESCr-maxlog"]=[==[Max number of Log lines to store.
Be careful, large cock, i mean, log... crap, anyways it may cause lags when scrolling
|cffffaeaeRecommended|r: no more than 200-300
|cff99eeeeDefault|r: 150]==]
L["DESCr-maxperplayer"]=[==[Max number of records 2b stored per guild's player.
The setting also affects your characters in other guilds,
which have this addon enabled and share same game account.
|cffffaeaeRecommended|r: 8 < x < 60
|cff99eeeeDefault|r: 30]==]
L["DESCr-maxleavers"]=[==[Set the number of days to store the data of leavers.
|cff99eeeeDefault|r: 30]==]
L["DESCr-addonscale"]=[==[Sets the Scale value of the addon.
Not to be confused with |cffff00ffSize|r 
(you may play with Alt-draging the addon window).
|cff99eeeeDefault|r: 1.0]==]
L['DESCr-epgpdecayprec']=[==[If the addon detects that an |cffaaccffEPGP|r:|cffaaccffDecay|r recently happened when you log in, this option determines whether expected values should be recalculated.
If you were offline during |cffaaccffDecay|r and could not see EP/GP changes happening in the guild, the addon will try to approximately reconstruct them and show possible suspicious gains.

When a decay is detected, players whose decayed values are as expected are marked as "cl" (clean) in Log, while players with discrepancies are marked with the difference amount and the letter "d" (diff).
|cff88ccffTip|r: if you see a "clean" difference value, the EP/GP gain most likely happened |cff88ccffafter|r the decay. Messy-looking values usually mean there was an EP/GP gain before the decay (or possibly both before and after).
Keep in mind that the more days passed since your last login, the less accurate this estimation becomes.

|cffffaeaeRecommended|r: 1–3 days depending on guild activity.  
0 = only track changes seen online.
|cff99eeeeDefault|r: 2]==]
L["DESCr-arttextalpha"]=[==[|cffff9999Art texture transparency|r
|cff99eeeeDefault|r: |cff99ff990.2|r]==]
L["DESCr-TXTArtTransp"]=[==[|cffff9999Art texture extended transparency|r
|cff99eeeeDefault|r: |cff99ff99Disabled|r]==]
L["DESCr-bgtextalpha"]=[==[|cffff9999BG texture transparency|r
|cff99eeeeDefault|r: |cff99ff990.5|r]==]
L["DESCr-TXTBgTransp"]=[==[|cffff9999BG texture extended transparency|r
|cff99eeeeDefault|r: |cff99ff99Disabled|r]==]

L['DESCr-epgpofficernote']=[==[Injection in |cffaaccffEPGP|r addon:
removing the warning when manually editing the guild Officer notes.

Disabling will re-inject the original code from |cffaaccffEPGP|r v5.5.19
Disable+Reload to restore defaults.
|cff99eeeeDefault|r: |cff99ff99Enabled|r]==]
L['DESCr-epgpmmasters']=[==[Injection in |cffaaccffEPGP|r addon:
remove warnings when normally adding EP/GP using |cffaaccffEPGP|r.

Disabling will re-enable the default 15 sec warning
Disable+Reload to restore defaults.
|cff99eeeeDefault|r: |cff99ff99Enabled|r]==]
L['DESCr-epgptwinsandloot']=[==[Injection in |cffaaccffEPGP|r addon:
1) add items, such as |cffff00ff[Emblem of Frost]|r, to |cffaaccffEPGP:Loot|r's internal blacklist.
2) add local tvins support from |cffffaaffEP Awarder|r in |cffaaccffEPGP:Loot|r.

Disable+Reload to restore |cffaaccffdefaults|r.
|cff99eeeeDefault|r: |cff99ff99Enabled|r]==]
L['DESCr-epgpepauc']=[==[|cffff9999Outdated feature! Use "ep-auc/dkp bid tracker"|r
Injection in |cffaaccffEPGP|r addon:
change item prices from to +GP to -EP when using |cffaaccffEPGP:Loot|r

This option is saved for account and is guild-dependant.

Disabling this will restore the initial injection made by "epgp: custom tvins and loot" option.
(restores default GP loot award)
|cff99eeeeDefault|r: |cff99ff99Disabled|r]==]
L['DESCr-rrtwins']=[==[Injection in |cffaaccffRaidRoll_EPGP|r addon:
adding local tvins support from |cffffaaffAwarder|r module

Disabling will re-inject the original code from |cffaaccffRaidRoll_EPGP|r v4.4.15 
Disable+Reload to restore defaults.
|cff99eeeeDefault|r: |cff99ff99Enabled|r]==]

L['DESCr-dispenser_gmembers']=[==[Provide items only for guild members or localy assigned
Off: Any raid members]==]
L['DESCr-dispenser_marktypes']=[==[1 = Yellow Star
2 = Orange Circle
3 = Purple Diamond
4 = Green Triangle
5 = White Crescent Moon
6 = Blue Square
7 = Red "X" Cross
8 = White Skull]==]
end

--Flask disp
do
L["DESCr-dispenser_guide"]=[[|cffff9999Flask Dispenser|r
The module can dispense up to 5 selected items for each of 4 roles:
  Tank | Healer | Melee | Caster

To add an item to the dispenser, simply drag it from your bag to the appropriate dispenser slot.
For convenience, the most popular flasks/potions are available in the settings menu; you can drag them from there.
To clear an item, right-click on the slot with an empty hand.

If you want, you can create separate distribution sets for different raids.
If you get tired of a set, remove all the items from it – empty sets are deleted upon restart.]]
L['rename set']=true
L["DESCr-dispenser_hide_on_set_selection"]=[[Hide sets on selection]]
L['DESCr-aw_flaskdisp_manual']=[[|cffff9999Show players that took a flask|r
Shift-click - open a flask dispenser module]]
L["options"]=true
L["Distribution of flasks is completed! Got flasks"]=true
L["already working"]=true
L["starting distribution from another set..."]=true
L['DISPnotenoughtslots']='You need at least $1 free slots in backpack'
L["NO CLASS DETECTED"]=true
L['Frost Presence']=true
L['Righteous Fury']=true
L["DAdonotforgetbuff"]='# You are missing buff $1 . hey dummy, call your mummy, ask for tanking advice ;)'
L['Shadowform']=true
L['Dire Bear Form']=true
L["failed to detect specialization"]=true
L['these notifications are muted now']=true
L["|cffa82222we're running out of"]=true
L['You can trade me for flasks!']=true
L["dispensed "]=true
L['mark self']=true
L["cant mark myself, not a raid officer"]=true
L["is not in guild"]=true
L["Grouping-up items"]=true
L['DESCr-disp_clear']=[[clear list of players that got items
Is automatically cleared when changing dispense set]]

L['announce dispense']=true
L['On Dispense Start']=true
L['Dispense']=true
L['only guild members']=true
L['print dispensed']=true
L['say in raid']=true
L['say in guild']=true
L['On Stop']=true
L['group up items']=true
L['print results']=true
L['results in raid']=true
L['results in guild']=true
L['d_speed']='dispenser\nspeed'
L['slow']=true
L['fast']=true
end

L["minimaptooltip"]=[==[|cffa7faf7Click|r |cff12a39e- main window|r
|cffa7faf7Shift+click|r |cff12a39e- inviter/dispenser|r
|cffa7faf7Ctrl+click|r |cff12a39e- quick logs by target|r
|cffa7faf7Alt+click|r |cff12a39e- raid tool/Awarder|r

|cffa7faf7Ctrl+Shift+O|r |cff12a39e- dispenser|r
|cffa7faf7Ctrl+Alt+O|r |cff12a39e- Bid tool|r

|cffa7faf7Right click|r |cff12a39e- all options|r]==]
