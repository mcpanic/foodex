
class FoodExDef
{

//From dark to light
//http://kuler.adobe.com/#themeID/283538
// Colors
	public static var BaseColor1:Number = 0x252F33;
	public static var BaseColor2:Number = 0x415C4F;
	public static var BaseColor3:Number = 0x869C80;
	public static var BaseColor4:Number = 0x93C2CC;
	public static var BaseColor5:Number = 0xCEEAEE;
	public static var Black:Number = 0x000000;
	public static var White:Number = 0xFFFFFF;

// FoodEx server address
	public static var SeverAddress:String = "http://www.mcpanic.com/data/foodex.php";
	
// Packet & status constants
// Numbers should match with the server's values
	public static var PersonStatus:Object = {PENDING:1, CREATED:2, ACCEPTED:3, DECLINED:4};
	public static var EventStatus:Object = {ACTIVE:1, PASSED:2, CANCELED:3};
	public static var PacketType:Object = {CREATE:1, ANSWER:2, RADIUSLIST:3, MYEVENT:4, MODIFY:5, CANCEL:6, FORWARD:7, REMIND:8};
   
// User Information
// Default N95 user information
	public static var UserName:String = "James";
	public static var UserPhoneNumber:String = "650-111-1111";
	public static var UserGPSX:Number = 0.00;
	public static var UserGPSY:Number = 0.00;
}

