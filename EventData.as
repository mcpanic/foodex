class EventData
{
	private var eventID:Number;
	
	private var titleData:TitleData;
	private var whenData:WhenData;
	private var whereData:WhereData;
	private var whoData:WhoData;
	
	private var eventStatus:Number;		// 1:New(+Pending) 2:Created 3:Accepted 4:Declined
	
	public function EventData()
	{	
		eventID = 1;	// temporaroly set to be 1
		eventStatus = 2;	// default: created

		titleData = new TitleData();
		whenData = new WhenData();
		whereData = new WhereData();
		whoData = new WhoData();
	}


	public function getEventStatus():Number
	{
		return eventStatus;
	}
	public function setEventStatus(es:Number)
	{
		eventStatus = es;
	}
	
	public function setDefaults()
	{
		// title
		titleData.setTitle("Let's get together!");
		
		// when
		whenData.setNextMealTime();
		
		// where
		setDefaultWhereData();
	}
	
	public function setEventData(id:Number, st:Number, ti:String, msg:String, yr:Number, mm:Number, dd:Number, hr:Number, mi:Number, loc:String, who:Array)
	{
		eventID = id;
		eventStatus = st;
		titleData.setTitle(ti);
		titleData.setMessage(msg);
		setDateTime(yr, mm, dd, hr, mi);
		whereData.setPlaceName(loc);
		whoData.setWhoArray(who);
	}
	
	public function toString():String
	{
		return "This is an EventData object";	// TODO
	}
	
	public function isReadOnly():Boolean
	{
		if (eventStatus == 2)	// created
			return false;
		else
			return true;
	}

	public function getEventID():Number
	{
		return eventID;
	}	
	public function setEventID(ID:Number)
	{
		eventID = ID;
	}	
	public function getTitleData():TitleData
	{
		return titleData;
	}
	
	public function getWhenData():WhenData
	{
		return whenData;		
	}
	
	public function getWhereData():WhereData
	{
		return whereData;
	}
	
	public function getWhoData():WhoData
	{
		return whoData;
	}
	
	/* Title/Message */
	public function getTitleString():String
	{
		return titleData.getTitle();
	}
	
	public function getMessageString():String
	{
		return titleData.getMessage();
	}
	
	public function setTitleString(title:String)
	{
		titleData.setTitle(title);
	}
	
	public function setMessageString(message:String)
	{
		titleData.setMessage(message);
	}
	
	/* When */
	public function getTimeInMilliSec():Number
	{
		return whenData.getTimeInMilliSec();
	}
	
	public function getDateTime():Date
	{
		return whenData.getDateTime();
	}
	
	public function getDateString():String
	{
		return whenData.getDateString();
	}
	
	public function setDateTime(year:Number, month:Number, day:Number, hour:Number, minute:Number)
	{
		whenData.setDate(year, month, day);
		whenData.setTime(hour, minute);
	}
	public function setDateTimeString(year:String, month:String, day:String, hour:String, minute:String)
	{
		whenData.setDate(Number(year), Number(month)-1, Number(day));
		whenData.setTime(Number(hour), Number(minute));
	}
		
	/* Where */
	private function setDefaultWhereData()
	{
		// get GPS position
		// Hewlitt 37.4296915,-122.1730594
		
		// set closest place if possible
		var wd:WhereData = AddressDB.getInstance().getClosestPlaces(37.4296915, -122.1730594, 1)[0];
		
		whereData.copy(wd);
	}
	
	public function getPlaceName():String
	{
		return whereData.getPlaceName();
	}
	
	public function setPlaceName(placeName:String)
	{
		whereData.setPlaceName(placeName);
	}
	
	public function getPhoneNumber():String
	{
		return whereData.getPhoneNumber();
	}
	
	public function setPhoneNumber(phoneNo:String)
	{
		whereData.setPhoneNumber(phoneNo);
	}
	
	public function setAddress(address:String)
	{
		whereData.setAddress(address);
	}
	
	public function getAddress():String
	{
		return whereData.getAddress();
	}

	public function getLongitude():Number
	{	
		return whereData.getLongitude();
	}
	public function getLatitude():Number
	{		
		return whereData.getLatitude();
	}
	public function setLongitude(gpsx:Number)
	{	
		whereData.setLongitude(gpsx);
	}
	public function setLatitude(gpsy:Number)
	{		
		whereData.setLatitude(gpsy);
	}
	
	/* Who */
	public function getContacts(radius:Number):Array
	{
		return whoData.getContacts(radius);
	}
	public function setContacts(arr:Array)
	{
		whoData.setWhoArray(arr);
	}
	public function getNumAllGuests():Number
	{
		return whoData.getNumContacts(-1);
	}
	public function getNumWhoAccepted():Number
	{
		return whoData.getNumWhoAccpeted();
	}
	public function getNumToSend():Number
	{
		return whoData.getNumChecked();
	}
	public function setChecked(arrChecked:Array)
	{
		whoData.setChecked(arrChecked);
	}
	public function getCheckedList():Array
	{
		return whoData.getCheckedList();
	}
};