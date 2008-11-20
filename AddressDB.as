class AddressDB
{
	// Singleton instance
	private static var INSTANCE:AddressDB = null;
	
	private var _addressList:Array;
	
	private function AddressDB()
	{
		_addressList = new Array();
		
		createList();
	}
	
	public static function getInstance():AddressDB
	{
		if(INSTANCE == null) INSTANCE = new AddressDB();
		
		return INSTANCE;
	}
	
	private function createList()
	{
		// 1.
		var where = new WhereData();
		where._placeName = "The Cafe";
		where._phoneNo = "650-725-9512";
		where._address = "326 Galvez Street\nStanford, CA 94305";
		where._longitude = 37.4343029;
		where._latitude = -122.1633;
		
		_addressList.push(where);
		
		// 2.
		where = new WhereData();
		where._placeName = "The Axe & Palm";
		where._phoneNo = "650-498-7160";
		where._address = "520 Lasuen Mall\nStanford, CA 94305";
		where._latitude = 37.436706;
		where._longitude = -122.1657982;
		
		_addressList.push(where);
		
		// 3.
		where = new WhereData();
		where._placeName = "The 750";
		where._phoneNo = "650-724-9260";
		where._address = "750 Escondido Road\nStanford, CA 94305";
		where._latitude = 37.4240837;
		where._longitude = -122.1596175;
		
		_addressList.push(where);
		
		// 4.
		where = new WhereData();
		where._placeName = "Olives@Bldg. 160";
		where._phoneNo = "650-724-3160";
		where._address = "450 Serra Mall\nStanford, CA 94305";
		where._latitude = 37.4288868;
		where._longitude = -122.1691945;
		
		_addressList.push(where);
		
		// 5.
		where = new WhereData();
		where._placeName = "Stern Dining";
		where._phoneNo = "650-725-1506";
		where._address = "618 Escondido Road\nStanford, CA 94305";
		where._latitude = 37.4249511;
		where._longitude = -122.1637143;
		
		_addressList.push(where);
		
		// 6.
		where = new WhereData();
		where._placeName = "Wilbur Dining";
		where._phoneNo = "650-725-1500";
		where._address = "658 Escondido Road\nStanford, CA 94305";
		where._latitude = 37.4249229;
		where._longitude = -122.163586;
		
		_addressList.push(where);
		
		// 7.
		where = new WhereData();
		where._placeName = "Subway(Tressider Union)";
		where._phoneNo = "650-725-3963";
		where._address = "459 Lagunita Drive\nStanford, CA 94305";
		where._latitude = 37.4236074;
		where._longitude = -122.1720026;
		
		_addressList.push(where);
		
		// 8.
		where = new WhereData();
		where._placeName = "Nexus";
		where._phoneNo = "650-324-3447";
		where._address = "318 Campus Drive\nStanford, CA 94305";
		where._latitude = 37.4323371;
		where._longitude = -122.17356;
		
		_addressList.push(where);
		
		// 9.
		where = new WhereData();
		where._placeName = "Bytes Cafe";
		where._phoneNo = "650-736-0456";
		where._address = "350 Serra Mall\nStanford, CA 94305";
		where._latitude = 37.4296615;
		where._longitude = -122.1729139;
		
		_addressList.push(where);
		
		// 10.
		where = new WhereData();
		where._placeName = "Ciao!";
		where._phoneNo = "650-723-8721";
		where._address = "488 Escondido Mall\nStanford, CA 94305";
		where._latitude = 37.4264977;
		where._longitude = -122.1709997;
		
		_addressList.push(where);
		
		// 11.
		where = new WhereData();
		where._placeName = "Village Cheese House";
		where._phoneNo = "650-326-9251";
		where._address = "855 El Camino Real\n Palo Alto, CA 94301";
		where._latitude = 37.43938;
		where._longitude = -122.158804;
		
		_addressList.push(where);
		
		// 12.
		where = new WhereData();
		where._placeName = "Palo Alto Creamery Fountain & Grill";
		where._phoneNo = "650-327-3141";
		where._address = "Stanford Shopping Center\n Palo Alto, CA 94301";
		where._latitude = 37.441667;
		where._longitude = -122.171381;
		
		_addressList.push(where);
		
		// 13.
		where = new WhereData();
		where._placeName = "Gelato Classico";
		where._phoneNo = "650-327-1317";
		where._address = "435 Emerson St\nPalo Alto, CA 94301";
		where._latitude = 37.4451308;
		where._longitude = -122.1634778;
		
		_addressList.push(where);
		
		// 14.
		where = new WhereData();
		where._placeName = "Caffe del Doge";
		where._phoneNo = "650-323-3600";
		where._address = "419 University Ave\nPalo Alto, CA 94301";
		where._latitude = 37.447493;
		where._longitude = -122.160393;
		
		_addressList.push(where);
		
		// 15.
		where = new WhereData();
		where._placeName = "Izzy's Brooklyn Bagels";
		where._phoneNo = "650-329-0700";
		where._address = "477 S California Ave\nPalo Alto, CA 94306";
		where._latitude = 37.4253498;
		where._longitude = -122.1455484;
		
		_addressList.push(where);
		
		// 16.
		where = new WhereData();
		where._placeName = "House of Bagels";
		where._phoneNo = "650-322-5189";
		where._address = "526 University Ave\nPalo Alto, CA 94301";
		where._latitude = 37.4487244;
		where._longitude = -122.1587882;
		
		_addressList.push(where);
		
		// 17.
		where = new WhereData();
		where._placeName = "Prolific Oven";
		where._phoneNo = "650-326-8485";
		where._address = "550 Waverley St\nPalo Alto, CA";
		where._latitude = 37.4466909;
		where._longitude = -122.1596568;
		
		_addressList.push(where);
		
		// 18.
		where = new WhereData();
		where._placeName = "Douce France";
		where._phoneNo = "650-322-3601";
		where._address = "855 El Camino Real\nPalo Alto, CA 94301";
		where._latitude = 37.43938;
		where._longitude = -122.158804;
		
		_addressList.push(where);
		
		// 19.
		where = new WhereData();
		where._placeName = "Palo Alto Creamery";
		where._phoneNo = "650323-3131";
		where._address = "566 Emerson St\nPalo Alto, CA 94301";
		where._latitude = 37.4440489;
		where._longitude = -122.161761;
		
		_addressList.push(where);
		
		// 20.
		where = new WhereData();
		where._placeName = "Cafe Epi";
		where._phoneNo = "650-328-4888";
		where._address = "405 University Ave\nPalo Alto, CA";
		where._latitude = 37.447395;
		where._longitude = -122.160496;
		
		_addressList.push(where);
	}
	
	public function addPlace(place:WhereData)
	{
		_addressList.push(place);
	}
	
	public function getWhereData(index:Number):WhereData
	{
		if(index >= _addressList.length)
		{
			throw new Error("[AddressDB] - getAddress(): index out of bound");
		}
		
		return _addressList[index];
	}
	
	public function getClosestPlaces(lat:Number, long:Number, count:Number):Array
	{
		//verify count
		var c:Number = count < _addressList.length ? count:_addressList.length;
		
		// get closest places
		var len:Number = _addressList.length;
		var distArray:Array = new Array(len);
		var d:Number = 0;
		
		// get distances
		for(var i:Number = 0; i < len; i++)
		{
			distArray[i] = getDistance(lat, long, _addressList[i].getLatitude(), _addressList[i].getLongitude())
		}
		
		var indexArray:Array = distArray.sort(Array.RETURNINDEXEDARRAY);
		
		// fill array
		var addrArray:Array = new Array(c);
		for(var i:Number = 0; i < c; i++)
		{
			addrArray[i] = _addressList[indexArray[i]];
		}
		
		return addrArray;
	}
	
	public function getDistance(lat1:Number, long1:Number, lat2:Number, long2:Number):Number
	{
		var scale:Number = 100; // to prevent decimation
		var dLat:Number = scale*(lat1-lat2);
		var dLong:Number = scale*(long1-long2);
		return (dLat*dLat+dLong*dLong);
	}
}