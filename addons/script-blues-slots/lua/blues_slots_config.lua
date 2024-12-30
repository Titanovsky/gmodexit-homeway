//IM AM NOT RESPONSIBLE IF THIS RUINS YOUR SERVERS ECONOMY.
//BE SURE TO TEST IT AND MAKE SURE THAT YOU ARE HAPPY WITH THE ODDS OF WINNING
//BEFORE USING IT ON YOUR SERVER!

//ALSO PLEASE PLEASE AFTER CONFIGURING THIS, DO NOT USE PERMA PROP ADDONS TO MAKE THE MACHINES PERMANENT
//AS THIS WILL LIKELY BREAK IT. INSTEAD JUST PLACE THE MACHINES WHERE YOU WANT THEM AND TYP !saveslots
//This will make them permanent, and it saves per map.

//MAKE SURE YOU HAVE ADDED THE WORKSHOP TO YOUR SERVER OR
//IT WILL NOT WORK!!
//http://steamcommunity.com/sharedfiles/filedetails/?id=843596994

WOL_CONFIG = {}

//This is the time in seconds that no one can use the machine after someone spins it
//What this means is if you spin the machine, no one else can use it for at least 30 seconds after you finished using it
//Its usefull to stop people from stealing other peoples machines.
//You can set it to zero but I strongly recommend leaving this at this time.
WOL_CONFIG.antiTheftTime = 10

//This is the price to increase the jackpot amount per spin.
//You can set this to 0 to disable increacing it but I recommend you do
//to keep excitment in players.
WOL_CONFIG.jackpotIncreasePerSpin = 100

//This is the minimal amount the jackpot can reset to
//The jackpot gets reset after someone wins it and it then set to a random number
//between the minimum and maximum jackpot numbers. 
//Set them both to zero if you want to jackpot to start at 0
WOL_CONFIG.jackpotResetMin = 50000
WOL_CONFIG.jackpotResetMax = 100000 //2 mill is reasonable consider the rarity the jackpot should be.

//The amount it charges the user to per spin (It does not charge for the bonus spins as they are free)
WOL_CONFIG.pricePerSpin = 1000 

//This is the icon used before displaying money, you can change this but its recomened to keep its leghnth to 1.
//You can use anything like "P" for point shop or these common one ($, €, £)
WOL_CONFIG.currencyIcon = "$"

//This is the chances of each item appearing on the reel
//I tried my best to balance these but of course feel free to change them.
//The chance has to be a whole number and is calculated by "tickets"
//To work out the chance of S
WOL_ITEM_CHANCE[1] = 1   //Bonus (WARNING, MAKING THIS TO HIGH WILL CRUSH YOUR ECONOMY AS PEOPLE CAN SPIN FOR THE JACKPOT MANY TIMES)
WOL_ITEM_CHANCE[2] = 30  //Respberry
WOL_ITEM_CHANCE[3] = 30  //Coins
WOL_ITEM_CHANCE[4] = 10  //Diamond
WOL_ITEM_CHANCE[5] = 30  //Bar Two
WOL_ITEM_CHANCE[6] = 45  //Bar One
WOL_ITEM_CHANCE[7] = 55  //Seven
WOL_ITEM_CHANCE[8] = 75  //Nothing

//These are the payouts for each wining combination.

WOL_CONFIG.winning = {}

//Getting three bonus in a row (This includes 3 bonus spins too)
WOL_CONFIG.winning.threeBonus = 10000

//Getting two bonus in a any position(This includes 3 bonus spins too)
WOL_CONFIG.winning.twoBonus = 5000

//Getting one bonus in a any position(This includes 3 bonus spins too)
WOL_CONFIG.winning.oneBonus = 1000

//Getting threE raspberrys in a row.
WOL_CONFIG.winning.threeRaspberry = 500

//Getting three coins in a row
WOL_CONFIG.winning.threeCoins = 5000

//Getting two coins in a row
WOL_CONFIG.winning.twoCoins = 1000

//Getting three diamonds in a row
WOL_CONFIG.winning.threeDiamonds = 10000 

//Getting two diamons in any place
WOL_CONFIG.winning.twoDiamonds = 2500

//Getting one diamond in any place
WOL_CONFIG.winning.oneDiamonds = 1000  

//Getting three BAR2's in a row
WOL_CONFIG.winning.threeBar2 = 500

//Getting three BAR'S in a row
WOL_CONFIG.winning.threeBar = 500

//Getting three 7's in a row
WOL_CONFIG.winning.threeSeven = 1500

//These are the items on the bonus wheel, DO NOT ADD OR REMOVE ANY
//Only change the numbers.
WOL_AddBonusItem(100)
WOL_AddBonusItem(200)
WOL_AddBonusItem(400)
WOL_AddBonusItem(1000)
WOL_AddBonusItem(2500)
WOL_AddBonusItem(5000)
WOL_AddBonusItem(7500)
WOL_AddBonusItem(10000)
WOL_AddBonusItem(15000)
WOL_AddBonusItem(20000)
WOL_AddBonusItem(30000)
WOL_AddBonusItem(40000)
WOL_AddBonusItem(60000)
WOL_AddBonusItem(75000)
WOL_AddBonusItem(100000)
WOL_AddBonusItem(150000)
WOL_AddBonusItem(175000)
WOL_AddBonusItem(200000)
WOL_AddBonusItem(300000)

//This is a list of ranks that can save machine places, using !saveslots
WOL_CONFIG.allowedRanks = {
	"superadmin",
	"owner"
}


//ADVANCED

//If you want to change the currency it uses then you can do so with these two functions.
//The first checks if the player has enough money and the second one takes the money and the third one gives the money
//You can change what is inside of these functions incase you want to switch it to pointshop or a custom gamemode currency.

//Return try if yes, false if no
WOL_CONFIG.onCheckIfCanAfford = function(ply, amount)
	return ply:canAfford(amount)
end

//Take what ever currency you are using from the player
WOL_CONFIG.onPlayerTakeMoney = function(ply, amount)
	ply:addMoney(amount * -1) //Convert it to a negative number as thats how darkrp works.
end

//Add the money to the players bank for what ever currency you use.
WOL_CONFIG.onPlayerAddMoney = function(ply, amount)
	ply:addMoney(amount)
end

//Lastly I guess thanks for the purchase, it helps me so much! I hope you enjoy your addon!