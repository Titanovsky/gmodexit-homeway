

-- Usergroups allowed to view/handle reports
SH_REPORTS.Usergroups = {
	[ 'superadmin' ] = true,
    [ 'founder-assistant' ] = true,
    [ 'head-admin' ] = true,
	[ 'sub-head-admin' ] = true,
    [ 'senior-admin' ] = true,
    [ 'd-senior-curator' ] = true,
    [ 'admin' ] = true,
    [ 'dcurator' ] = true,
    [ 'junior-admin' ] = true,
	[ 'dsadmin' ] = true,
	[ 'senior-moder' ] = true,
	[ 'moder' ] = true,
	[ 'dmoder' ] = true,
}

-- Usergroups allowed to view performance reports
SH_REPORTS.UsergroupsPerformance = {
	[ 'superadmin' ] = true,
    [ 'founder-assistant' ] = true,
    [ 'head-admin' ] = true,
	[ 'sub-head-admin' ] = true,
}

-- Customize your report reasons here.
-- Try to keep them short as they appear in full in the reports list.
SH_REPORTS.ReportReasons = {
	'Фри Дамаг',
	'Фри Килл',
	'Фри Арест',
	'Важный вопрос',
	'Абуз доната',
	'Абуз ранга',
	'Читер / Эксплойтер',
	'Другое'
}

-- How many reports can a player make?
SH_REPORTS.MaxReportsPerPlayer = 1

-- Play a sound to admins whenever a report is made?
SH_REPORTS.NewReportSound = {
	enabled = true,
	path = Sound("buttons/button16.wav"),
}

-- Enable ServerLog support? Any actions related to reports will be ServerLog'd IN ENGLISH if true.
-- NOTE: ServerLogs are in English.
SH_REPORTS.UseServerLog = true

-- Should admins be able to create reports?
SH_REPORTS.StaffCanReport = true

-- Can players report admins?
SH_REPORTS.StaffCanBeReported = true

-- Should admins be able to delete unclaimed reports?
SH_REPORTS.CanDeleteWhenUnclaimed = false

-- Notify admins when they connect of any unclaimed reports?
SH_REPORTS.NotifyAdminsOnConnect = true

-- Can players report "Other"?
-- Other is no player in particular; but players can make a report with Other if they want a sit or something.
SH_REPORTS.CanReportOther = true

-- Use ULX commands for teleporting? (allows returning etc.)
SH_REPORTS.UseULXCommands = true

-- Key binding to open the Make Report menu.
SH_REPORTS.ReportKey = KEY_F10

-- Key binding to open the Report List menu.
SH_REPORTS.ReportsKey = KEY_F11

-- Should players be asked for rating the admin after their report gets closed?
SH_REPORTS.AskRating = true

-- Should admins know whenever a player rates them?
SH_REPORTS.NotifyRating = false

-- Should players be teleported back to their position after their report gets closed?
SH_REPORTS.TeleportPlayersBack = true

-- How many pending reports to show on admin's screen?
SH_REPORTS.PendingReportsDispNumber = 3

-- Allows admins to claim reports without teleporting?
-- If true, the Goto and Bring commands will be hidden.
SH_REPORTS.ClaimNoTeleport = false

-- Use Steam Workshop for the custom content?
-- If false, custom content will be downloaded through FastDL.
SH_REPORTS.UseWorkshop = true

/**
* Command configuration
**/

-- Chat commands which can open the View Reports menu (for admins)
-- ! are automatically replaced by / and inputs are made lowercase for convenience.
SH_REPORTS.AdminCommands = {
	["/reports"] = true,
	["/reportlist"] = true,
	["!rl"] = true,
	["/rl"] = true
}

-- Chat commands which can open the Make Report menu (for players)
-- ! are automatically replaced by / and inputs are made lowercase for convenience.
SH_REPORTS.ReportCommands = {
	["/report"] = true,
	["/rep"] = true,
	["!report"] = true,
	["!rep"] = true
}

-- Enable quick reporting with @?
-- Typing "@this guy RDM'd me" would open the Make Report menu with the text as a comment.
-- Might conflict with add-ons relying on @ commands.
-- NOTE: Admins cannot use this feature.
SH_REPORTS.EnableQuickReport = true

/**
* Performance reports configuration
**/

-- How should performance reports be saved?
-- Possible options: sqlite, mysqloo
-- mysqloo requires gmsv_mysqloo to be installed on your server.
-- You can configure MySQL credentials in reports/lib_database.lua
SH_REPORTS.DatabaseMode = "sqlite"

-- What should be the frequency of performance reports?
-- Possible options: daily, weekly, monthly
SH_REPORTS.PerformanceFrequency = "weekly"

-- If the above option is weekly, on what day of the week
-- should new performance reports be created? (always at midnight)
-- 0: Sunday
-- 1: Monday
-- 2: Tuesday
-- 3: Wednesday
-- 4: Thursday
-- 5: Friday
-- 6: Saturday
SH_REPORTS.PerformanceWeekDay = 1

-- Should reports created by admins count for the performance reports and ratings?
SH_REPORTS.AdminReportsCount = false

/**
* Storage configuration
**/

-- Should reports closed by an admin be stored?
-- Useful if you want to see a past report, and what rating the admin got.
-- Possible options: none, sqlite, mysqloo
-- none disables this feature.
SH_REPORTS.StoreCompletedReports = "sqlite"

-- Should reports be purged after some time? In seconds.
-- Purges are done on map start to avoid performance loss.
-- Set to 0 to make stored reports never expire.
-- Beware! Too many reports may prevent you from seeing the history properly due to large amounts of data to send.
SH_REPORTS.StorageExpiryTime = 86400 * 7

/**
* Advanced configuration
* Edit at your own risk!
**/

SH_REPORTS.MaxCommentLength = 2048

SH_REPORTS.DateFormat = "%Y/%m/%d"

SH_REPORTS.TimeFormat = "%Y/%m/%d %H:%M:%S"

-- When making a report with the "RDM" reason
-- it will automatically select the player who last killed you.
-- If you modify the report reasons above make sure to modify those here as well for convenience.
SH_REPORTS.ReasonAutoTarget = {
	["RDM"] = "killer",
	["FreeArrest"] = "arrester",
}

/**
* Theme configuration
**/

-- Font to use for normal text throughout the interface.
SH_REPORTS.Font = "Circular Std Medium"

-- Font to use for bold text throughout the interface.
SH_REPORTS.FontBold = "Circular Std Bold"

-- Color sheet. Only modify if you know what you're doing
SH_REPORTS.Style = {
	header = Color(52, 152, 219, 255),
	bg = Color(52, 73, 94, 255),
	inbg = Color(44, 62, 80, 255),

	close_hover = Color(231, 76, 60, 255),
	hover = Color(255, 255, 255, 10, 255),
	hover2 = Color(255, 255, 255, 5, 255),

	text = Color(255, 255, 255, 255),
	text_down = Color(0, 0, 0),
	textentry = Color(44, 62, 80),
	menu = Color(127, 140, 141),

	success = Color(46, 204, 113),
	failure = Color(231, 76, 60),
	rating = Color(241, 196, 15),
}

/**
* Language configuration
**/

-- Various strings used throughout the add-on.
-- Available languages: english, french, german
-- To add your own language, see the reports/language folder
-- You may need to restart the map after changing the language!
SH_REPORTS.LanguageName = "english"