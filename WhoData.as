import flyer.Flyer;

class WhoData
{
	// contact list
	public var arrContacts:Array;


	public function WhoData()
	{
		arrContacts = new Array();
		//fillContactsList();
	}
	
	public function setWhoArray(who:Array)
	{
		arrContacts = who;
	}
	
	public function setChecked(arrChecked:Array)
	{
		for (var i:Number = 0; i < arrChecked.length; i++)

			arrContacts[i][4] = arrChecked[i];
	}
	
	public function getNumChecked():Number
	{
		return getCheckedList().length;
	}
	public function getCheckedList():Array
	{
		var checkedList:Array = new Array();
		for (var i:Number = 0; i < arrContacts.length; i++)
		{
			if (arrContacts[i][4] == 1)
				checkedList.push(arrContacts[i]);
		}
		return checkedList;
	}
	
	
	public function getNumContacts(radius:Number):Number
	{
		// sort by distance and name
		arrContacts.sort(orderByDistance);
		
		if (radius < 0)
			return arrContacts.length;
		else
		{
			var arrReturn:Array = new Array;
			var i:Number = 0;
			while ((arrContacts[i][2] <= radius) && (arrContacts[i][2] >= 0))
				i = i + 1;
		}
		return i;
	}
	public function getNumWhoAccpeted():Number
	{
		var ret:Number = 0;
		for (var i:Number = 0; i < arrContacts.length; i++)
		{
			if (arrContacts[i][3] == FoodExDef.PersonStatus.ACCEPTED)
				ret = ret + 1;
			else if (arrContacts[i][3] == FoodExDef.PersonStatus.CREATED)
				ret = ret + 1;
		}
		return ret;
	}
	public function getContacts(radius:Number):Array
	{
		// sort by distance and name
		arrContacts.sort(orderByDistance);
		
		if (radius < 0)
			return arrContacts;
		else
		{
			var arrReturn:Array = new Array;
			var i:Number = 0;
			while ((arrContacts[i][2] <= radius) && (arrContacts[i][2] >= 0))
			{
				arrReturn.push(arrContacts[i]);
				i = i + 1;
			}
		}
		return arrReturn;
	}
	private function orderByDistance(a:Array, b:Array):Number
	{
		// unknown distance
		if (a[2] < 0)
		{
			if (b[2] >=0)
				return 1;
			else	// both are unknown -> sort by name
			{
				if (a[0] < b[0])
					return -1;
				else if (a[0] > b[0])
					return 1;
				else
					return 0;
			}
		}
		else if (b[2] < 0)
			return -1;

		// both are known
		if (a[2] < b[2])
			return -1;
		else if (a[2] > b[2])
			return 1;
		else	// sort by name
		{
			if (a[0] < b[0])
				return -1;
			else if (a[0] > b[0])
				return 1;
			else
				return 0;
		}
	}
	private function orderByName(a:Array, b:Array):Number
	{
		if (a[0] < b[0])
			return -1;
		else if (a[0] > b[0])
			return 1;
		else
			return 0;
	}

	

	public function fillContactsList()
	{
		var flyerConn_fl:Flyer = new Flyer('127.0.0.1', 9100);
		/* ***********************************************************
				Flyer Actions
		************************************************************** */
		var handler_obj:Object = new Object();
		handler_obj.onFlyerConnect = function(evt_obj:Object):Void {
			//preloader_mc._visible = false;
			if(evt_obj.status) {
				trace ("Getting contacts.");
				flyerConn_fl.getContacts();
			} else {
				trace ("Connection failed.");
			}
		}
		
		handler_obj.onContactsData = function(evt_obj:Object):Void {
			var contacts_array = evt_obj.data.split("|");
			for(var i:Number = 0; i<contacts_array.length; i++)
				arrContacts.push(contacts_array[i]);
//			contacts_array.pop(); // Remove the last element

			trace ("Entries:" + contacts_array.length);
		}
		
		handler_obj.onFlyerClose = function(evt_obj:Object):Void {
			trace ("onFlyerClose");
		}

		flyerConn_fl.addEventListener("onFlyerConnect", handler_obj);
		flyerConn_fl.addEventListener("onFlyerClose", handler_obj);
		flyerConn_fl.addEventListener("onContactsData", handler_obj);
		
		flyerConn_fl.connect();
		trace ("Connecting to Python.");

		

		// TODO: IT SHOULD BE FILLED USING THE DATA FROM SERVER AND CONTACT LIST
		arrContacts.push(["Alvis",			"111-111-1111",	-1,		3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Ben",			"121-131-1154",	-1,		3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Bokynug >_<",	"551-431-1512",	0.3,	3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Boris",			"441-156-1345",	6.7,	3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Chris",			"131-131-1541",	99.9,	3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Christine",		"111-241-1341",	5.1,	3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["David",			"161-111-1546",	-1,		3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Dooly",			"181-111-1147",	-1,		3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Edward",			"119-111-1541",	10.1,	3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Esther",			"211-111-1641",	0.6,	3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Eugine",			"757-111-1747",	1.1,	3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Eunice",			"444-111-1123",	1.2,	3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["George",			"878-111-5555",	4.4,	3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Hyunjung Park",	"363-111-1666",	8.6,	3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Jung Woo Choe",	"134-111-1777",	-1,		3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["My father",		"111-111-9999",	9.0,	3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["My mother",		"111-141-0000",	4.3,	3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Phil",			"111-771-1134",	-1,		3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Sarah",			"111-891-1343",	-1,		3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]
		arrContacts.push(["Tom",			"111-113-1117", 15.4,	3, 0]);			// [name, phone number, distance, coming(1:coming / 2:not coming / 3: unknown), ckecked]

	}
};