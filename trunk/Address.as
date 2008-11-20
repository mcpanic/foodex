class Address
{
	public var _city:String;
	public var _state:String;
	public var _street:String;
	
	public function Address()
	{
	}
	
	public function copy(address:Address)
	{
		this._city = address._city;
		this._state = address._state;
		this._street = address._street;
	}
	
	public function toString():String 
	{
		return _street + "\n" + _city + ", " + _state;
	}
}