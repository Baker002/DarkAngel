local debug = false
local L = LibStub("AceLocale-3.0"):NewLocale("DarkAngel", "enUS", true, debug)

--other
L["Scale"]=true
L['close']=true

-- Opt Menu
do
L["Whisper"]=true
L["Invite"]=true
L["Details"]=true
L["Twinks"]=true
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

L['deleted local']=true
L['deleted data']=true
L['old data']=true
L['detplinguild']='player is in guild'
L['detoldrecord']='probably an old incorrect record'
end

--Guild
do
L['roster from backup']=true
L["Hold Ctrl to see more details"]=true
L['delete']=true
L["locals"]=true
L["online"]=true
L['reverse']=true
L["class"]=true
L["patterns"]=true
L["sort"]=true
L["clear"]=true
L["refresh"]=true
L["re-twink twins assigned to"]=true
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
L['DESCr-SR_lfg_messages']=[[In this menu you can come up with some secret phrases
that the addon will track in global chat channels.
As soon as such a phrase is detected, its author will be invited by the autoinviter.

Phrases are recognized wholly, not in a pattern. The design is very human
You can add several phrases on a new line]]
L['start silently']=true
L['DESCr-silentlstart']=[[Do not send initial message when starting
Announces on timer will be still sent, if enabled]]
L['Also invite:']=true
L['guild: all 80 lvl online']=true
L['Guild tool: selected']=true
L['Guild tool: all found online']=true


L['DESCr-inv_timer_tt']=[[|cffff9999Invite people to raid by timer|r
If your server has a limit on the number of invites sent,
some of them may not go through and will be skipped]]
L['DESCr-inv_fast_tt']=[[|cffff9999Automatic invitations speed|r
The addon will also track successful and unsuccessful invitations.
In case of failure, the sending speed will be reduced and the failed invitations will be repeated]]
L['DESCr-inv_instant_tt']=[[|cffff9999Instant invites|r
If your server does not have a limit on sending invites (for example, Warmane), this option is suitable for you
Raid invitations will be sent without a timer, immediately (without checking for success)]]



L['auto-stop timer re-set']=true
L['Raid inviter is already disabled']=true
L['Raid inviter started']=true
L['Raid inviter is disabled now']=true
L['LFG samples are nil, LFG inviter disabled']=true
L['Ongoing raid']=true
L['RL/assist']=true
L['inv_RL']="\nRL: "
L['inv_inv']="\nInviter: "

L["joining raid..."]=true
L['Type + in guild chat if you are still not in raid']=true
L["guild ping"]='ping'
L['raidinv_stop_msg']='# raid inviter is disabled now, you may go fuck around (respectfully)'
L['auto-stop']=true
L['join raid']=true
L['You are already in raid!']=true
L['Cant find any raids']=true
L["auto-anons RT each"]=true
L['provide discord if asked']=true
L['send']=true
L['auto-join RT']=true
L['auto-accept party']=true
L['accept from guild chat']=true
L['accept from pm']=true
L['accept from global']=true
L['dispenser']=true
L['empty set']=true
L['You are not in raid']=true
L['minutes_short']='min'
L['Invite auto-stopped']=true

L['DA_Default_LFG_samples']=[==[Secret phrase123
you can create more each from new line]==]
end

--opt
do
L["Bidder module is disabled. Enable it in main addon options"]=true
L["Store logs"]=true
L["Trusted players"]=true
L["Texture Options"]=true
L["Art texture alpha"]=true
L["BG texture alpha"]=true
L['+transp']=true
L["texture presets"]=true
L['guild window alias button']=true
L['Additional binds']=true

L["EPGP decay precising"]=true
L['Group-up clear decay in Log']=true
L['Print leavers in chat']=true
L["example"]=true
L['Track suspicious changes']=true
L['DKP improvement']=true

L["Details for each player"]=true
L["Store leavers data"]=true

L['epgp: officer note warning']=true
L['epgp: multiple masters warning']=true
L['epgp: custom tvins and loot']=true
L['epgp: EP Auc']=true
L['raidroll_epgp: DarkAngel tvins']=true

L['commands on whisper']=true
L['only in raid']=true
			
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
L["Player not found"]=true
L["Trade window opened with wrong player!!!"]=true
L["You are too far away from player"]=true


L["Bid raise settings"]=true
L["Bound"]=true
L["Step"]=true
L["Step in thousands"]=true
L["'Bid confirmed' message"]=true
L["Allow 'all in'"]=true
end

--EP Awarder
do
L["DESCr-aw_auto_locals"]=[[|cffff9999Automatic Locals|r
When one of the "Trusted Players" creates a local binding, you will automatically save it as well]]
L["DESCr-aw_auto_Ch_locals"]=[[If the received local binding modifies an existing one, it will be accepted automatically
If disabled, such a binding is skipped]]
L['subscribe to auto locals']=true
L['apply changes']=true
L['silent mode']=true
L["DESCr-aw_trusted_players"]=[[|cffff9999Trusted Players|r
-can take/remove the assistant role in the raid if you are RL
-can share local twins with you ("Any" works same as "Any Guild")]]
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
L['DESCr-Raid difficulty']="Raid difficulty"
L["Lock raid"]="Lock"
L["Unlock raid"]="Unlock"
L["Get standby %"]=true
L['From EPGP settings']=true
L['Use custom']=true
L['options']=true
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
L['darken\noffline']="offline"
L['apply']=true
L['getlocals']='locals'
L['ask guild']=true
L['export']=true
L['qDKPexp']='qDKP'
L['qDKP addon not found']=true
L['standby']=true
L['fepassign']="Assign!"
L['mark on role']=true
L['mark on class']=true
L['misc']=true
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
L['zamprocep']='%raid award for standby'
L['zamenagudok']='# whisper me \'epgp standby\' to join the raid standby'
L["settingep0"]="Player $1 got less EP than you try to spend ($2). Wrote EP as 0"
L["settinggp0"]="Player $1 got less GP than you try to spend ($2). Wrote GP as 0"
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
L['added to Death Note']=true
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
L['clear all marks']=true
L['reset all']=true
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

|cffff9999All changes are virtual. To save changes you must be |cff99ffffGuild Master|r]]
L["got it, close"]=true
end

--Descriptions
do
L['DESCr-lootBtnSelect']=[==[Set looting method]==]
L['DESCr-speedSelect']=[==[Raid invitations sending speed]==]
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
L['DESCr-do_decay_checks']=[[|cffff9999Enable EPGP Decay checks|r
Useful for EPGP guilds that do Decay]]
L['DESCr-auto_cbs']=[[|cffff9999Automatic checkbox setup|r
|cff943838You'll learn of that first hand. When my work is complete, you will beg for mercy -- and I will deny you.
Your anguished cries will be testament to my |cffbd0000unbridled |cff943838power...|r]]
L['DESCr-auc_RR_hide']=[[|cffff9999Hide RaidRoll addon|r
When the addon starts a new betting session, it will prevent the RaidRoll addon window from opening
However, RaidRoll will still be running, tracking rolls. In this case, the RaidRoll window will pop up normally]]
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
L['DESCr-auc_allow_lower']=[[|cffff9999Allow players to place not competitive bids|r
These bids would be shown lower than the winning ones
Otherwise, such new bids would not be processed, however, old low bids would stay]]
L['DESCr-auc_thousands']=[[|cffff9999Thousands betting mode|r
Bets made by players will be multiplied by 1000
All settings in this screen will also be multiplied.

|cffff9999exception: bets above 1000|r]]
L['DESCr-desc_evaluate']="Show alternative officer notes"
L['DESCr-desc_onlinefirst']="sort online and offline players separately; put online players at the top of the list"
L['DESCr-desc_reverse']="reverse sort"
L['DESCr-onltvingrps']=[[|cffff9999Perfect sorting when kicking afk players|r
Groups mains with alts and detects the last online via any character,
then sorts such groups by online]]
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
|cff99ffffCtrl-O|r — Open main addon window (Guild)
|cff99ffffShift-O|r — Open Inviter/Flask Dispenser
|cff99ffffAlt-O|r — Open Awarder window
|cff99ffffCtrl-Alt-O|r — Open EP-Auc/DKP bid tool]==]
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
|cff99ffff?dkp|r / |cff99ffff?epgp|r - Get player's DKP/EPGP values
|cff99ffff?main|r <|cff99ffffnickname|r> - assign in-guild player to their main
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
L['DESCr-disp_speed']=[==[Set speed at which an addon will create and gather stacks.
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
L["DESCr-BulkHelp"]=[==[|cffffaaffApply to|r - players the bulk will be applied to:
   |cffffaaffselected|r - select players in Guild list via 
      --Ctrl+click (one player) 
      --Shift+click (many players) -same way as you do in Windows
   |cffffaaffall found|r - use all players from the Guild menu
      useful when editing tvins, found via "twins" button
      |cffff0000be careful not to kick all guild members using this option!|r
|cffffaaffaction|r - select the bulk action^
   |cffffaaffnote|r - set same public note
   |cffffaaffof.note|r - set same officer note
   |cffffaaffrank|r - set specific rank
   |cffff8888kick|r - yes.
   
|cffffaaffStart|r - launch bulk
|cffffaaffStop|r - try to stop the running bulk [ be careful, some operations are very fast :) ]]==]
L['DESCr-BulkHelp2']=[==[If you are unsure of what you are doing,
you can create a full guild backup in the 'Backup' tab :)
With a backup, it will be possible to quickly roll back any changes, except, perhaps, a kick from the guild]==]
L["DESCr-optmenuleader"]=[==[Left click - give Assist
Shift+Right click - set new |cffff5555Raid Leader|r]==]
L["DESCr-awardlocker"]=[==[|cffff9999Freeze Window|r
Useful before awarding, if there are raid members prone to leaving
or if you want to do award outside of raid.

data is NOT stored on logout -use Snapshots]==]
L["DESCr-precisematchsearch"]=[==[|cff00ff00enabled|cffffffff:|r Find players matching |cffaaccffALL|r of the entered |cffaaccffsearch|r fields.
Example: By filling in "bis" in |cffaaccffnote|r, you will see all bis characters in guild. 
         Adding "death" to |cffaaccffclass|r, will show only bis Death knights
|cffff0000disabled|cffffffff:|r Display players with |cffaaccffANY|r match in |cffaaccffANY|r |cffaaccffsearch|r field.]==]
L["DESCr-grefr"]=[==[Automatically refresh data.]==]
L["DESCr-procepzamene"]=[==[Players on standby and 6-8 party (if the option above is enabled) will receive % of the raid award
Raid award is the first award criteria (mark)

Off: 100%]==]
L["DESCr-showlocals"]=[==[|cff00ff00Enabled|cffffffff:|r Include non-guild characters locally bound with guild mains
|cffff0000Disabled|cffffffff:|r (default) Show only guild members]==]
L["DESCr-mmenuqcopy"]=[==[While typing in "note" or "officer note" fields, the sidebar copy menus will be shown automatically.]==]
L["DESCr-mmenuleavefocus"]=[==[Leave the typing focus untouched in officer/note while selecting a player
so you can select players one-by-one and fill in the needed officer/notes manually/via Ctrl+V
If disabled, the typing focuses will be cleared.]==]
L['DESCr-mmenucloserank']=[==[Close rank selection after change]==]
L["DESCr-maxlog"]=[==[Max number of Log lines to store.
Be careful, large log may cause lags when scrolling
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
L["DESCr-epgpdecayprec"]=[==[Set the number of days that may pass between |cffffaaffaddon|r check and guild |cffaaccffEPGP|r:|cffaaccffDecay|r.
If the guild was not checked at least once in this period, next time you see the EPGP changes, they will be shown as total difference.
This function will try to re-calculate the |cffaaccffEPGP|r:|cffaaccffDecay|r and show the difference between the latest values and the actual ones.
It means that if the guild was |cffaaccffDecay|red while you were online, you will be able to see any security violations :)
If any suspicious changes were spotted, they might have happened due to the following reasons:
1) Player obtained EP/GP before the |cffaaccffDecay|r and you were not online to spot it, or the |cffaaccffDecay|r was performed right away
     (the difference in this case may be not precise due to math :) )
2) Player obtained EP/GP after the |cffaaccffDecay|r and you were not online to spot it, or the EP/GP award was performed right away after the |cffaaccffDecay|r
     (the difference in this case will be rather precise)
3) Someone is cheating :) Depending on the types of differences you see and their amount, it is possible to guess when the violation of The Law happened.
|cff9966a6Use your brains to figure out if this is valid or not; ffs, I made an addon for you, all the hard work. 
You just fcking read and think, use your head. To listen, you need ears, you know? :)|cff2282aa (c) Roman B. , Senior Panasonic SSL Subject Matter Expert|r
|cffffaeaeRecommended|r: no more than 3 days, depending on the guild activity and your online. 0-means only online changes (precise: 2.2*Auto-update_rate/60  )
|cff99eeeeDefault|r: 2]==]
L["DESCr-arttextalpha"]=[==[|cffff9999Art texture transparency|r
|cff99eeeeDefault|r: |cff99ff990.2|r]==]
L["DESCr-txt1extra"]=[==[|cffff9999Art texture extended transparency|r
|cff99eeeeDefault|r: |cff99ff99Disabled|r]==]
L["DESCr-bgtextalpha"]=[==[|cffff9999BG texture transparency|r
|cff99eeeeDefault|r: |cff99ff990.5|r]==]
L["DESCr-txt2extra"]=[==[|cffff9999BG texture extended transparency|r
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


L["DA_Funlist"]={
"Spider overdose",
"Choked on an HP stone",
"Allergic to light magic",
"Impaled on a bone spike",
"Tank's negligence",
"Caught in a time loop",
"Game crashed at the phase change",
"Heroically fell during trash clearing",
"Fell victim to market grannies",
"Offered as a sacrifice to the fertility goddess",
"Stolen by Amazons",
"Death due to lack of health points",
"Slipped on beer",
"Forgot to wear the H.E.V. suit",
"Sacrificium resuscitati daemonum bellator",
"Didn't call the she-healer 'doctress'",
"Summoned into a wall by a novice warlock",
"Died on replacement duty at the tavern",
"Showed the panda monk lack of respect",
"Unpaid communal healing debt",
"Insulted the RL's feelings",
"Failed to dodge the wipe on trash",
"Low-quality healthstone from the nether",
"Broke the law prohibiting law-breaking",
"Incorrect Jeeves exploitation",
"Broke the piñata",
"Fatal yawn",
"Deadly spot",
"Erotic tragedy",
"Bell tower in the anus",
"Caution - snake",
"Brazilian porn on board",
"Fell victim to a prolonged mole hunt",
"Stool",
"Converted to Islam",
"Maid trap",
"Got sucked off by vampires",
"This is a fiasco, bro",
"Oh my God, they killed Kenny",
"Didn't work out, wasn't lucky",
"E. coli in the Americano",
"Negatively alive",
"Stuffed with dumplings",
"Strangled by a goose",
"Scared to death by spirits",
"Died like a jug",
"Expired",
"Died from a nut cracking",
"Died from a light bulb in the ass",
"Giglet pie",
"Spontaneous combustion of the anus",
"Standard hit from Saitama",
"Plague infection while feeding squirrels in Dalaran",
"Dies from cringe",
"Charge, BS, release",
"Health to the deceased",
"Went to grandma's place",

"got scammed by indians",
"Wasted",
"Got consumed by big dick energy",
"Went to a farm",
"Flushed down the toilet like a goldfish",
"Got bonked and went to horny jail",
"Punished for not wearing panties",
"Too big of a dick overweighed him",
"That's a fiesta, bro",
"Brah...",
"\"I am getting PTSD from this\"",
"Got cancer",
"Cracked his arse",
"No nut November failed",
"Drank too much piss",
"decided to kick the bucket",
"Yesterday he was fine, now look at him",
"Down the drain he goes",
"got crushed by big tiddies",
"Hoe town summoned him",
"Shot from a nerf gun",
"You get what you deserve",
"Should have stacked stamina gems",
"Did not practice how to use CDs on manikin",
"That's a fucking 50 DKP minus",
"Healer's fault",
"Snitches be lying dead in ditches",
"Run over by a long vehicle",
"Unprotected sex kills",
"Got severe syphilis",
"Anal infection",
"Due to masturbation in a public place",
"Harakiri would be a more noble way to go",
"What a disgrace to all of us",
"You call that a hit? That's a hit",
"Sorry, I was lagging",
"Press F to pay respect",
"Decided to go buy more beer",
}

