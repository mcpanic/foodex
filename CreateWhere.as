import mx.transitions.Tween;
import mx.transitions.easing.None;

class CreateWhere extends FoodExScreen
{		
	public static var SELECT_MODE:Number = 0;
	public static var INFO_MODE:Number = 1;
	private var _mode = SELECT_MODE;
	
	private var selectPane:MovieClip;
	private var infoPane:MovieClip;
	
	private var _readOnly:Boolean = false;
	
	private var button1:TextField;
	
	// select panel components
	private static var MAX_SELECT:Number = 5;
	
	private var selectBox:MovieClip;
	private var _selectNo = 1;
	private var _suggestArray:Array;
	private	var _addrArray:Array;
	private var _selectData:WhereData = null;
	
	// info panel components
	private var gc:GsmuCreator;
	private static var DEFAULT_ZOOM:Number = 15;
	private static var ZOOM_MAX:Number = 17;
	private static var ZOOM_MIN:Number = 10;
	
	private var mapImage:MovieClip;
	private var _editEnabled = false;
	private var _zoom:Number = 15;
	
	public var _changeSelect:Boolean = false;
	
	private var txtListener:Object;
	
	// Constructor
	public function CreateWhere(target:MovieClip, x_coor:Number, y_coor:Number, titleText:String, buttonText1:String, buttonText2:String)
	{
		initFoodExScreen(target, x_coor, y_coor);
		attachScreen();
		this.setTitleBar(titleText);
		this.setButtons(buttonText1, buttonText2);
		
		initComponents();
	}
	
	// Attach screens
	private function attachScreen()
	{
		// common contents - specify unique names for each component
		titlebar = this.target.createscreen.attachMovie("FoodExTitle", "title_where", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:ycoor});
		buttons = this.target.createscreen.attachMovie("FoodExButton", "buttons_where", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+290)});

		// contents specific to this class
		var middlescreen:MovieClip = this.target.createscreen.attachMovie("BlankScreen", "screen_where", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+50)});
		var screenImage:MovieClip = this.target.createscreen.attachMovie("C_Where", "image_where", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+60)});

		// button color
		with (this.target.createscreen.buttons_where)
		{
			colors = [0xFFFFFF, FoodExDef.BaseColor1];
			fillType = "linear"
			alphas = [100, 100];
			ratios = [0, 0xFF];
			matrix = {matrixType:"box", x:0, y:0, w:240, h:30, r:(90/180)*Math.PI};
			beginGradientFill(fillType, colors, alphas, ratios, matrix);
			moveTo(0, 0);
			lineTo(0, 30);
			lineTo(240, 30);
			lineTo(240, 0);
			lineTo(0, 0);
			endFill();
		}
	}
	
	// Initialize components
	private function initComponents()
	{		
		infoPane = this.target.createscreen.image_where._infoPane;
		selectPane = this.target.createscreen.image_where._selectPane;
		
		button1 = this.target.createscreen.buttons_where.text1;
		
		initSelectPaneComponents();
		
		infoPane._visible = false;
		gc = new GsmuCreator();
		
		//txtListener = new Object();
//		txtListener.onChanged = function() 
//		{
//			infoPane.addressText.text = "HiHiHi";
//		};
//
//		infoPane.nameText.addListener(txtListener);
	}
	
	// Initialize components in SelectPane
	private function initSelectPaneComponents()
	{
		selectBox = selectPane._selectBox;
		_suggestArray = new Array(MAX_SELECT);
		_suggestArray[0] = selectPane._suggest1TF;
		_suggestArray[1] = selectPane._suggest2TF;
		_suggestArray[2] = selectPane._suggest3TF;
		_suggestArray[3] = selectPane._suggest4TF;
		_suggestArray[4] = selectPane._suggest5TF;
	}
	
	// Initialize screen. Called when Where is selected. 
	public function initScreen()
	{
		// check if prev selected
		if(hasSelectedAddress())
		{
			setMode(INFO_MODE);
		}
		else
		{		
			updateList();
			
			if(_mode != SELECT_MODE)
			{
				setMode(SELECT_MODE);
			}
		}
	}
	
	public function setReadOnly(ro:Boolean)
	{
		_readOnly = ro;
	}
	
	// Returns the current mode
	public function getMode():Number
	{
		return _mode;
	}
	
	// Sets the mode
	public function setMode(m:Number)
	{
		if(m == INFO_MODE)
		{
			if(_readOnly)
			{
				this.target.createscreen.buttons_where.text1.text = "";
			}
			else
			{
				if(hasSelectedAddress() && !_changeSelect)
				{
					this.target.createscreen.buttons_where.text1.text = "Change";
				}
				else
				{
					this.target.createscreen.buttons_where.text1.text = "OK";
				}
			}
			selectPane._visible = false;
			infoPane._visible = true;
			
			_mode = INFO_MODE;
		}
		else
		{
			this.target.createscreen.buttons_where.text1.text = "OK";
			
			selectPane._visible = true;
			infoPane._visible = false;
			
			_mode = SELECT_MODE;
		}
	}
	
	// sets the where data.
	public function setWhereData(wd:WhereData)
	{
		_selectData = wd;
		if(wd != null) fillInfo(_selectData);
	}
	
	public function saveSelectedData()
	{
		_selectData = _addrArray[_selectNo-1];
	}
	
	public function hasSelectedAddress():Boolean
	{
		return _selectData != null;
	}
		
// Key handlers
	public function handleUP()
	{
		if(_mode == SELECT_MODE)
		{
			moveSelectorTo(_selectNo-1);
		}
		else
		{
			if(!_editEnabled)
			{ // zoom in
				zoomMap(_zoom+1);
			}
		}
	}
	
	public function handleDOWN()
	{
		if(_mode == SELECT_MODE)
		{
			moveSelectorTo(_selectNo+1);
		}
		else
		{
			if(!_editEnabled)
			{ // zoom out
				zoomMap(_zoom-1);
			}
		}
	}
	
	public function handleRIGHT()
	{
	}
	
	private function locationXMLOnLoad(success:Boolean, inputXML:XML):Void 
	{
		trace("XML: " + inputXML);
		if (success) 
		{	
		var latitude:Number;
		var longitude:Number;
		var arg:String = inputXML.toString();
		var temp_num1:Number = arg.indexOf(",");
		arg = arg.slice(temp_num1+1, arg.length);
		temp_num1 = arg.indexOf(",");
		arg = arg.slice(temp_num1+1, arg.length);
		temp_num1 = arg.indexOf(",");
		latitude = Number(arg.slice(0,temp_num1));
		longitude = Number(arg.slice(temp_num1+1, arg.length)); 
		trace("latitude:" + latitude);
		trace("longitude:" + longitude);
		updateMap(latitude, longitude);		
	//var nName:String = arg.slice(temp_num1, arg.length).split(",").join("");
	//trace("HIT: "+nummer+"||"+nName );

		
//			if (inputXML.firstChild.attributes.EVENTID)
//			{
//				// Save this value to some place for later use
//			}
//			if (inputXML.firstChild.attributes.RESPONSETYPE != FoodExDef.PacketType.RADIUSLIST)
//			{
//				trace("Error in response type!");
//			}
//			trace (inputXML.firstChild.attributes.LAT + "," + inputXML.firstChild.attributes.LNG);
//			switch (inputXML.firstChild.attributes.STATUS) {
//			case 'OK' :
//				trace("OK returned");
//				break;
//			case 'FAILURE' :
//				trace("FAILURE returned");
//				break;
//			default :
//				// this should never happen
//				trace("Unexpected value received for STATUS.");
//			}
	
		}
		else
		{
			trace("an error occurred.");
		}
		
	}		
	
	public function getLocation()
	{
		var owner:CreateWhere = this;
		
		// ignore XML white space
		XML.prototype.ignoreWhite = true;
		// Construct an XML object to hold the server's reply
		var locationReplyXML:XML = new XML();
		// this function triggers when an XML packet is received from the server.		
		locationReplyXML.onLoad = function(success:Boolean) {
			owner.locationXMLOnLoad(success, this);
		}
	
		var addressXML:XML = new XML();
		addressXML.contentType = "application/xml";

		trace(infoPane.addressText.text);
		if (infoPane.addressText.text != "")
		{
			var addressString:String = infoPane.addressText.text;
			addressString = addressString.split(" ").join("+");
			trace (addressString);

			var finalAddressString:String = "http://maps.google.com/maps/geo?q=" + addressString + "&output=csv&sensor=false&key=ABQIAAAA7BXkVswHspiZHMVABbxQ-BRdNqZsuGa3rxjIi4xkdxLp_lGPxxSOYld3AJk5XhFMURcll1mbR_TiPg";
			addressXML.sendAndLoad(finalAddressString, locationReplyXML, "POST");
		}
	}
	
	public function handleLEFT()
	{
		getLocation();
//		if(_mode != SELECT_MODE) setMode(SELECT_MODE);

	}
	
	public function handleENTER()
	{
		if(_readOnly) return; // do nothing
		
		if(_mode == SELECT_MODE)
		{
			setSelectedAddress();
			
			setMode(INFO_MODE);
		}
		else
		{
			if(_editEnabled)
			{
				// TODO: handle
			}
			else
			{
//				setMode(SELECT_MODE);
			}
		}
	}
	
	public function setSelectedAddress()
	{
		if(_selectNo == 0)
		{ // Manual Input
			_editEnabled = true;
		}
		else
		{ // Automated Input
			fillInfo(_addrArray[_selectNo-1]);
			_editEnabled = false;
		}
		
		enableInfoPane(_editEnabled);
	}
	
// select pane functions
	private function moveSelectorTo(nextSelectNo:Number)
	{
		// validate input
		if(nextSelectNo < 0 || nextSelectNo > MAX_SELECT) return;
		
		_selectNo = nextSelectNo;
		var startPos:Number = selectBox._y;
		var endPos:Number = 40 + _selectNo*25;
		new Tween(selectBox, "_y", None.easeIn, startPos, endPos, .2, true);
	}
	
	// updates the list
	public function updateList()
	{ 
		// get GPS position
		// Hewlett 37.4296915,-122.1730594
		// Gates 37.4295948,-122.1726007
		
		// find closest locations
		_addrArray = AddressDB.getInstance().getClosestPlaces(37.4295948,-122.1726007, MAX_SELECT);
		
		// create list
		var selectTF:TextField;
		for(var i:Number = 0; i < MAX_SELECT; i++)
		{
			selectTF = _suggestArray[i];
			selectTF.text = _addrArray[i].getPlaceName();
		}
	}
	
// info pane functions	
	// fills the values
	private function fillInfo(whereData:WhereData)
	{
		infoPane.nameText.text = whereData.getPlaceName();
		infoPane.phoneText.text = whereData.getPhoneNumber();
		infoPane.addressText.text = whereData.getAddress();
		updateMap(whereData.getLatitude(), whereData.getLongitude());
	}
	
	// enables info panel
	public function enableInfoPane(enable:Boolean)
	{
		_editEnabled = enable;
		
		infoPane.nameText.type = enable ? "input":"dynamic";
		infoPane.phoneText.type = enable ? "input":"dynamic";
		infoPane.addressText.type = enable ? "input":"dynamic";
		
		infoPane.mapImage._visible = !enable;
		infoPane._zoomIcon._visible = !enable;
		infoPane.loadClip._visible = !enable;
		infoPane.noMapLB._visible = enable;
	}
	
	public function getPlaceName():String
	{
		return infoPane.nameText.text;
	}
	
	public function getPhoneNumber():String
	{
		return infoPane.phoneText.text;
	}
	
	public function getAddress():String
	{
		return infoPane.addressText.text;
	}
	
	// updates the mape
	private function updateMap(lat:Number, long:Number)
	{
		_zoom = DEFAULT_ZOOM;
		
		gc.setMarkerLatLng(lat, long);
		gc.setZoom(_zoom);
		
		var mapUrl:String = gc.createURL();
		infoPane.mapImage.loadMovie(mapUrl);
	}
	
	// zooms the map
	private function zoomMap(zoom:Number)
	{
		// validate zoom
		if(zoom < ZOOM_MIN || zoom > ZOOM_MAX) return;
		_zoom = zoom;
		
		gc.setZoom(_zoom);
		
		var mapUrl:String = gc.createURL();
		infoPane.mapImage.loadMovie(mapUrl);
	}
}