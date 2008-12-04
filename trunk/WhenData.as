class WhenData
{
	private var dateTime:Date;

	public function WhenData()
	{
		dateTime = new Date();
	}
	
	public function getDateTime():Date
	{
		return dateTime;
	}
	public function getTimeInMilliSec():Number
	{
		return dateTime.getTime();
	}
	public function getDateString():String
	{
		var hour24:Number = dateTime.getHours();
		var ampm:String = (hour24<12) ? "AM" : "PM";
		var hour12:Number = hour24%12;
		if (hour12 == 0)
		{
			hour12 = 12;
		}
		var strHour = (hour12>9)? hour12.toString() : "0" + hour12.toString();
		var strMinute = (dateTime.getMinutes()>9)? dateTime.getMinutes().toString() : "0" + dateTime.getMinutes().toString();
		
		var strYear = dateTime.getFullYear().toString();
		var month = dateTime.getMonth()+1;
		var strMonth = (month>9)? month.toString() : "0" + month.toString();
		var date = dateTime.getDate();
		var strDate = (date>9)? date.toString() : "0" + date.toString();
//		return dateTime.getLocaleShortDate() + "\n" + strHour + ":" + strMinute + ampm;
		return strMonth + "/" + strDate + "/" + strYear + "\n" + strHour + ":" + strMinute + ampm;
	}
	
	public function setDate(year:Number, month:Number, day:Number)
	{
		dateTime.setFullYear(year, month, day);
	}
	public function setTime(hour:Number, minute:Number)
	{
		dateTime.setHours(hour, minute);
	}
	
	public function setNextMealTime()
	{
		var now:Date = new Date();
		var hour:Number = now.getHours();
		if (hour < 12)		// lunch
		{
			dateTime.setHours(12, 0, 0, 0);
			dateTime.setFullYear(now.getFullYear(), now.getMonth(), now.getDate());
		}
		else if (hour < 18)	// dinner
		{
			dateTime.setHours(18, 0, 0, 0);
			dateTime.setFullYear(now.getFullYear(), now.getMonth(), now.getDate());
		}
		else				// tomorrow lunch
		{
			dateTime.setHours(12, 0, 0, 0);
			var tomorrow = new Date(now.getTime() + 1000*60*60*24);
			dateTime.setFullYear(tomorrow.getFullYear(), tomorrow.getMonth(), tomorrow.getDate());
		}
	}
};