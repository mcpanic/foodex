// This class creates a Google Static Map URL.
// Example URL)
// http://maps.google.com/staticmap?zoom=14&size=512x512&maptype=mobile\
// &markers=40.718217,-73.998284,redc&key=MAPS_API_KEY&sensor=true

class GsmuCreator
{
	private static var MAP_URL:String = "http://maps.google.com/staticmap?";
		
	// zoom
	private var _zoom:Number = 15;
	
	// size
	private var _imageWidth:Number = 220;
	private var _imageHeight:Number = 100;
	
	// format - jpg/gif/png8/png32
	private var _format:String = "jpg";
	
	// maptype - roadmap/mobile/satellite/terrain/hybrid
	private var _mapType:String = "mobile";
	
	// markers
	private var _markLatitude:Number;
	private var _markLongitude:Number;
//	private var markSize:String;
	private var _markColor:String = "red";
	private var _markChar:String = "a";
	
	// key
	private var _mapKey:String = "ABQIAAAAue8-nF4tKq-ju4QTbEV2uBT-_JH4T46TIh-gOzzPJE1GJzKhrBSAna9a0xiX7XBf2W4-aN0N-50bgw";
	
	public function GsmuCreator()
	{
	}
	
	public function setZoom(z:Number)
	{
		_zoom = z;
	}
	
	public function setImageSize(w:Number, h:Number)
	{
		_imageWidth = w;
		_imageHeight = h;
	}
	
	public function setMarkerLatLng(lat:Number, long:Number)
	{
		_markLatitude = lat;
		_markLongitude = long;
	}
	
	public function createURL():String
	{
		var urlString:String = MAP_URL;
		urlString += "zoom="+_zoom;
		urlString += "&size="+_imageWidth+"x"+_imageHeight;
		urlString += "&format="+_format;		
		urlString += "&maptype="+_mapType;
		urlString += "&markers="+_markLatitude+","+_markLongitude+","+_markColor+_markChar;		
		urlString += "&key="+_mapKey;
		urlString += "&sensor=true";

		return urlString;
	}
}