class WhereData
{
	private var _placeName:String;
	private var _phoneNo:String;
	private var _address:String;
	
	// GPS Data
	private var _longitude:Number; // x
	private var _latitude:Number; // y
	
	public function WhereData()
	{
	}
	
	public function copy(wd:WhereData)
	{
		_placeName = wd._placeName;
		_phoneNo = wd._phoneNo;
		_address = wd._address;
		_longitude = wd._longitude;
		_latitude = wd._latitude;
	}
	
	public function setPlaceName(placeName:String)
	{
		_placeName = placeName;
	}
	
	public function getPlaceName():String 
	{
		return _placeName;
	}
	
	public function setPhoneNumber(phoneNo:String)
	{
		_phoneNo = phoneNo;
	}
	
	public function getPhoneNumber():String 
	{
		return _phoneNo;
	}
	
	public function setAddress(address:String)
	{
		_address = address;
	}
	
	public function getAddress():String
	{
		return _address;
	}
	
	public function setPosition(longitude:Number, latitude:Number)
	{
		_longitude = longitude;
		_latitude = latitude;
	}
	
	public function getLongitude():Number
	{
		return _longitude;
	}
	
	public function getLatitude():Number
	{
		return _latitude;
	}
	public function setLongitude(longitude:Number)
	{
		_longitude = longitude;
	}
	
	public function setLatitude(latitude:Number)
	{
		_latitude = latitude;
	}	
};