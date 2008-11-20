import mx.transitions.Tween;
import mx.transitions.easing.None;

class CreateScreen extends MovieClip
{
	private var target:MovieClip;
	
	private var eventItem:EventData;
	
	private var screen_center:CreateCenter;	// ID: 55
	private var screen_up:CreateTitle;		// ID: 56
	private var screen_left:CreateWhen;		// ID: 45
	private var screen_right:CreateWho;		// ID: 65
	private var screen_down:CreateWhere;	// ID: 54

	private var selected_screen:Number;		// Selected screen
	
	private var isConfirmMode:Boolean;
	private var isAlertMode:Boolean;
	private var isLoading:Boolean;

	
	public function CreateScreen(target:MovieClip)
	{
		this.target = target;
		this.target.createEmptyMovieClip("createscreen", 5);

		// Screen properties
		selected_screen = 55;	// default to center

		// Screens
		screen_center = new CreateCenter(this.target, 0, 0, "Create an Event", "Send", "Back");
		screen_up = new CreateTitle(this.target, 0, -320, "Title and Message", "OK", "Cancel", false);
		screen_left = new CreateWhen(this.target, -240, 0, "Date and Time", "OK", "Cancel", false);
		screen_right = new CreateWho(this.target, 240, 0, "Who's coming?", "OK", "Cancel", false, 1);
		screen_down = new CreateWhere(this.target, 0, 320, "Location", "OK", "Cancel");
		
		// Data
		initEventData();
		showEventData();
		
		Key.addListener(this);
		
		isConfirmMode = false;
		isAlertMode = false;
		isLoading = false;
	}
	
	private function initEventData()
	{
		eventItem = new EventData();
		eventItem.setDefaults();
				
		// Do any initializations here, if needed
		//closeLoadingAlert();
		getContactsList();
	}
	
	/*
	 * Updates all screens with the current event data.
	 */
	private function showEventData()
	{
		// center
		this.target.createscreen.image_center.titleText.text = eventItem.getTitleString();
		this.target.createscreen.image_center.whenText.text = eventItem.getDateString();
		this.target.createscreen.image_center.whereText.text = eventItem.getPlaceName();
		
		// title & message
		this.target.createscreen.image_title.txtTitle.text = eventItem.getTitleString();
		this.target.createscreen.image_title.txtMessage.text = eventItem.getMessageString();
		
		// when
		screen_left.setSelectedDateTime(eventItem.getDateTime());
		
		// who
		this.target.createscreen.image_center.whoText.text = eventItem.getNumToSend().toString();
		
		//where
		this.target.createscreen.image_where.nameText.text = eventItem.getPlaceName();
		this.target.createscreen.image_where.phoneText.text = eventItem.getPhoneNumber();
		this.target.createscreen.image_where.addressText.text = eventItem.getAddress();
	}

	public function onKeyDown()
	{
		if (isConfirmMode)
		{
			onKeyDown_ConfirmMode();
			return;
		}
		else if (isAlertMode)
		{
			onKeyDown_AlertMode();
			return;
		}
		else if (isLoading)
		{
			return;
		}

		switch (selected_screen)
		{
			case 55:	// center
				handleEvent_center();
				break;
			case 56:	// up
				handleEvent_up();
				break;
			case 65:	// left
				handleEvent_left();
				break;
			case 45:	// right
				handleEvent_right();
				break;
			case 54:	// down
				handleEvent_down();
				break;
		}
	}
	
	private function onKeyDown_ConfirmMode()
	{
		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				closeConfirm();
				send_event();
				break;
			case ExtendedKey.SOFT2:
				closeConfirm();
				break;
			case Key.UP:
				break;
			case Key.LEFT:
				break;
			case Key.RIGHT:
				break;
			case Key.DOWN:
				break;
			case Key.ENTER:
				break;
		}
	}
	private function onKeyDown_AlertMode()
	{
		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				closeAlert();
				break;
			case ExtendedKey.SOFT2:
				closeAlert();
				break;
			case Key.UP:
				break;
			case Key.LEFT:
				break;
			case Key.RIGHT:
				break;
			case Key.DOWN:
				break;
			case Key.ENTER:
				closeAlert();
				break;
		}
	}
	private function openConfirm()
	{
		if (eventItem.getNumToSend() < 1)
		{
			openAlert("No one selected.");
			return;
		}

		isConfirmMode = true;
	
		var popup_confirm:MovieClip = this.target.createscreen.attachMovie("Popup_Confirm", "popup_confirm", this.target.createscreen.getNextHighestDepth(), {_x:10, _y:110});
		popup_confirm.txtQuestion.text = "Do you want to send invitiation message to " + eventItem.getNumToSend().toString() + ((eventItem.getNumToSend()==1)? " person?":" people?");
		popup_confirm.txtAnswer1.text = "YES";
		popup_confirm.txtAnswer2.text = "NO";
		popup_confirm._alpha = 80;
	}
	private function openAlert(msg:String)
	{
		isAlertMode = true;
	
		var popup_alert:MovieClip = this.target.createscreen.attachMovie("Popup_Alert", "popup_alert", this.target.createscreen.getNextHighestDepth(), {_x:10, _y:110});
		popup_alert.txtMessage.text = msg;
		popup_alert._alpha = 80;
	}
	private function closeConfirm()
	{
		this.target.createscreen.popup_confirm.removeMovieClip();
		isConfirmMode = false;
	}
	private function closeAlert()
	{
		this.target.createscreen.popup_alert.removeMovieClip();
		isAlertMode = false;
	}
	private function openLoadingAlert()
	{
		isLoading = true;
		var popup_loading:MovieClip = this.target.createscreen.attachMovie("Loading", "popup_loading", this.target.createscreen.getNextHighestDepth(), {_x:40, _y:140});
	}
	private function closeLoadingAlert()
	{
		this.target.createscreen.popup_loading.removeMovieClip();
		isLoading = false;
	}

	private function send_event()
	{
		
		// ignore XML white space
		XML.prototype.ignoreWhite = true;
		// Construct an XML object to hold the server's reply
		var createReplyXML:XML = new XML();
		// this function triggers when an XML packet is received from the server.		
		createReplyXML.onLoad = function(success:Boolean) {
			if (success) {
				trace("RESPONSE: " + this);
				if (this.firstChild.attributes.EVENTID)
				{
					// Save this value to some place for later use
				}
				if (this.firstChild.attributes.RESPONSETYPE != FoodExDef.PacketType.CREATE)
				{
					trace("Error in response type!");
				}
				switch (this.firstChild.attributes.STATUS) {
				case 'OK' :;
					trace("OK returned");
					break;
				case 'FAILURE' :
					trace("FAILURE returned");
					break;
				default :
					// this should never happen
					trace("Unexpected value received for STATUS.");
				}
			} else {
				trace("an error occurred.");
			}
		};
		
		// this function triggers when the login_btn is clicked
			var createXML:XML = new XML();
			createXML.contentType = "application/xml";
			var topElement:XMLNode = createXML.createElement("EVENT");
			createXML.appendChild(topElement);
			
			// create XML formatted data to send to the server
			
			// 1. event info - event meta data
			var eventElement:XMLNode = createXML.createElement("EVENTINFO");
			eventElement.attributes.requesttype = 	FoodExDef.PacketType.CREATE;		// 1: New Event	
//			eventElement.attributes.eventid = 		0;	// New event ID default to 0, automatically assigned by the server
			topElement.appendChild(eventElement);
			
			// 2. title & message
			eventElement = createXML.createElement("TITLEDATA");
			eventElement.attributes.eventtitle = 	eventItem.getTitleString();
			eventElement.attributes.eventmessage = 	eventItem.getMessageString();
			topElement.appendChild(eventElement);			
			
			// 3. when
			eventElement = createXML.createElement("WHENDATA");		
			// set it to match MySQL Datetime format: YYYY-MM-DD HH:MM:SS
			var str_datetime:String = new String();
			str_datetime = (eventItem.getDateTime().getYear()+1900).toString() + "-" + (eventItem.getDateTime().getMonth()+1).toString() + "-" + eventItem.getDateTime().getDate().toString() 
						+ " " + eventItem.getDateTime().getHours().toString() + ":" + eventItem.getDateTime().getMinutes().toString() + ":" + eventItem.getDateTime().getSeconds().toString();		
			eventElement.attributes.datetime = 		str_datetime;	
			trace (eventItem.getDateTime().toString());
			//eventElement.attributes.time = 		eventItem.getTimeString();
			topElement.appendChild(eventElement);			
			
			// 4. where
			eventElement = createXML.createElement("WHEREDATA");			
			eventElement.attributes.placename = 	eventItem.getPlaceName();
			eventElement.attributes.phonenumber = 	eventItem.getPhoneNumber();
			eventElement.attributes.address = 		eventItem.getAddress();
			topElement.appendChild(eventElement);		
			
			// 5. who
			eventElement = createXML.createElement("WHODATA");		
			eventElement.attributes.numtosend = 	eventItem.getNumToSend().toString();
			topElement.appendChild(eventElement);
			var checkedList:Array = eventItem.getCheckedList();
			for (var i:Number = 0; i < eventItem.getNumToSend(); i++)
			{
				var personElement:XMLNode = createXML.createElement("PERSON");
				personElement.attributes.name = 	checkedList[i][0];
				personElement.attributes.number = 	checkedList[i][1];
				personElement.attributes.distance = 	checkedList[i][2];
				personElement.attributes.status = 	checkedList[i][3];
				//personElement.attributes.checked = 	checkedList[i][0];				
				eventElement.appendChild(personElement);
			}
			
			// 5. sender info
			eventElement = createXML.createElement("SENDERDATA");
			eventElement.attributes.name = 			FoodExDef.UserName;		
			eventElement.attributes.number = 		FoodExDef.UserPhoneNumber;	
			eventElement.attributes.gpsx = 			FoodExDef.UserGPSX;
			eventElement.attributes.gpsy = 			FoodExDef.UserGPSY;
			topElement.appendChild(eventElement);			

			// send the XML formatted data to the server
			trace(createXML);
			createXML.sendAndLoad(FoodExDef.SeverAddress, createReplyXML, "POST");
			
			
			if (System.capabilities.hasSMS)
			{
				var eventSMS:String = eventItem.getTitleString() + eventItem.getMessageString() + eventItem.getPlaceName() + eventItem.getDateTime().toString();
				// TODO: Getting the phone number of the currently selected person
				getURL("sms:" + "6501111111;6502222222" + "?body=" + eventSMS);
			}
			else
				trace("Can't send SMS.  System.capabilities.hasSMS == false.");			
			
			openAlert("Message was sent to " + eventItem.getNumToSend().toString() + ((eventItem.getNumToSend()==1)? " person!":" people!"));
	}
	
	private function radiusListXMLOnLoad(success:Boolean, inputXML:XML):Void 
	{
		trace("XML: " + inputXML);
		delete eventItem.getWhoData().arrContacts;
		eventItem.getWhoData().arrContacts = new Array();
		if (success) 
		{	
			if (inputXML.firstChild.attributes.EVENTID)
			{
				// Save this value to some place for later use
			}
			if (inputXML.firstChild.attributes.RESPONSETYPE != FoodExDef.PacketType.RADIUSLIST)
			{
				trace("Error in response type!");
			}
			switch (inputXML.firstChild.attributes.STATUS) {
			case 'OK' :
				trace("OK returned");
				break;
			case 'FAILURE' :
				trace("FAILURE returned");
				break;
			default :
				// this should never happen
				trace("Unexpected value received for STATUS.");
			}
			
			for (var eventNode:XMLNode = inputXML.firstChild.firstChild; eventNode != null; eventNode = eventNode.nextSibling) 
			{
				var evt:EventData = new EventData();		

				var myStatus:Number;					
				//trace("NODE:  " + eventNode);
				//trace(eventNode);
				for (var dataNode:XMLNode = eventNode.firstChild; dataNode != null; dataNode = dataNode.nextSibling) 
				{
					if (dataNode.nodeName == "WHODATA")
					{	
						var personNode:XMLNode = dataNode.firstChild;
						//trace (personNode);
						for (var numtosend:Number = 0; numtosend < Number(dataNode.attributes.numtosend); numtosend++)
						{							
							//["Alvis",			"111-111-1111",	-1,		1, 0],
							eventItem.getWhoData().arrContacts.push([personNode.attributes.name, personNode.attributes.number, Number(personNode.attributes.distance), FoodExDef.PersonStatus.PENDING, 0]);
							personNode = personNode.nextSibling;
						} 
					}						
				}					
			}

			for (var i:Number=0; i<eventItem.getWhoData().arrContacts.length; i++)
				trace(eventItem.getWhoData().arrContacts[i][0] +","+ eventItem.getWhoData().arrContacts[i][1]+","+ eventItem.getWhoData().arrContacts[i][2]+","+ eventItem.getWhoData().arrContacts[i][3]+","+ eventItem.getWhoData().arrContacts[i][4]);
		}
		else
		{
			trace("an error occurred.");
		}
		
		closeLoadingAlert();
	}		
	
	public function getContactsList()
	{
		openLoadingAlert();

		var owner:CreateScreen = this;
		
		// ignore XML white space
		XML.prototype.ignoreWhite = true;
		// Construct an XML object to hold the server's reply
		var radiusListReplyXML:XML = new XML();
		// this function triggers when an XML packet is received from the server.		
		radiusListReplyXML.onLoad = function(success:Boolean) {
			owner.radiusListXMLOnLoad(success, this);
		}
	
		var radiusListXML:XML = new XML();
		radiusListXML.contentType = "application/xml";
		var topElement:XMLNode = radiusListXML.createElement("EVENT");
		radiusListXML.appendChild(topElement);
		
		// create XML formatted data to send to the server
		
		// 1. event info - event meta data
		var eventElement:XMLNode = radiusListXML.createElement("EVENTINFO");
		eventElement.attributes.requesttype = 	FoodExDef.PacketType.RADIUSLIST;
		topElement.appendChild(eventElement);
		
		// 5. sender info
		eventElement = radiusListXML.createElement("SENDERDATA");
		eventElement.attributes.name = 			FoodExDef.UserName;		
		eventElement.attributes.number = 		FoodExDef.UserPhoneNumber;	
		eventElement.attributes.gpsx = 			FoodExDef.UserGPSX;
		eventElement.attributes.gpsy = 			FoodExDef.UserGPSY;
		topElement.appendChild(eventElement);			

		// send the XML formatted data to the server
		trace(radiusListXML);
		radiusListXML.sendAndLoad(FoodExDef.SeverAddress, radiusListReplyXML, "POST");
	}
		
	private function handleEvent_center()
	{
		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				openConfirm();
				//this.target.gotoAndStop("Home");
				//Key.removeListener(this);
				break;
			case ExtendedKey.SOFT2:
				this.target.gotoAndStop("Home");
				Key.removeListener(this);
				break;
			case Key.UP:
				selected_screen = selected_screen + 1;
				move_y();
				break;
			case Key.LEFT:
				selected_screen = selected_screen + 10;
				move_x();
				break;
			case Key.RIGHT:
				selected_screen = selected_screen - 10;
				screen_right.initScreen();
				move_x();
				break;
			case Key.DOWN:
				selected_screen = selected_screen - 1;
				screen_down.initScreen();
				move_y();
				break;
		}
	}

	
	private function handleEvent_up()	// CreateTitle
	{
		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				updateTitleData();
				showEventData();
				selected_screen = selected_screen - 1;	// go down to 'center'
				move_y();
				break;
			case ExtendedKey.SOFT2:
				showEventData();
				selected_screen = selected_screen - 1;	// go down to 'center'
				move_y();
				break;
		}
	}
	
	private function handleEvent_left()	//CreateWhen
	{
		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				updateWhenData();
				screen_left.setFocus(1);
				showEventData();
				selected_screen = selected_screen - 10;	// go to 'center'
				move_x();
				break;
			case ExtendedKey.SOFT2:
				showEventData();
				screen_left.setFocus(1);
				selected_screen = selected_screen - 10;	// go to 'center'
				move_x();
				break;
			case Key.UP:
				screen_left.handleUP();
				break;
			case Key.DOWN:
				screen_left.handleDOWN();
				break;
			case Key.LEFT:
				screen_left.handleLEFT();
				break;
			case Key.RIGHT:
				screen_left.handleRIGHT();
				break;
			case Key.ENTER:
				screen_left.handleENTER();
				break;
		}
	}

	private function handleEvent_right() //CreateWho
	{
		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				if (screen_right.getFocus() == 1)
				{
					screen_right.handleENTER(eventItem);
				}
				else
				{
					updateWhoData();
					showEventData();
					selected_screen = selected_screen + 10;	// go to 'center'
					move_x();
				}
				break;
			case ExtendedKey.SOFT2:
				if (screen_right.getFocus() == 2)
				{
					screen_right.initScreen();
				}
				else
				{
					showEventData();
					selected_screen = selected_screen + 10;	// go to 'center'
					move_x();
				}
				break;
			case Key.UP:
				screen_right.handleUP();
				break;
			case Key.DOWN:
				screen_right.handleDOWN();
				break;
			case Key.ENTER:
				screen_right.handleENTER(eventItem);
				break;
		}
	}

	private function handleEvent_down() //CreateWhere
	{
		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				if(screen_down.getMode() == CreateWhere.INFO_MODE)
				{
					// Store location
					screen_down.saveSelectedData();
					updateWhereData();
					showEventData();
					// go to 'center'
					selected_screen = selected_screen + 1;
					move_y();
				}
				else
				{
					screen_down.setSelectedAddress();
					screen_down.setMode(CreateWhere.INFO_MODE);
				}
				break;
			case ExtendedKey.SOFT2:
				showEventData();
				// go to 'center'
				selected_screen = selected_screen + 1;
				move_y();
				break;
			case Key.UP:
				screen_down.handleUP();
				break;
			case Key.DOWN:
				screen_down.handleDOWN();
				break;
			case Key.LEFT:
				screen_down.handleLEFT();
				break;
			case Key.RIGHT:
				screen_down.handleRIGHT();
				break;
			case Key.ENTER:
//				if(screen_down.getMode() == CreateWhere.INFO_MODE)
//				{
//					// Store location
//					updateWhereData();
//					showEventData();
//					// go to 'center'
//					selected_screen = selected_screen + 1;
//					move_y();
//				}
//				else
//				{
					screen_down.handleENTER();
//				}
				break;
		}
	}
	
	private function updateTitleData()
	{
		eventItem.setTitleString(this.target.createscreen.image_title.txtTitle.text);
		eventItem.setMessageString(this.target.createscreen.image_title.txtMessage.text);
	}
	
	private function updateWhenData()
	{
		var theDate:Date = new Date();
		theDate.setTime(theDate.getTime() + screen_left.getDateDiff()*24*60*60*1000);
		eventItem.setDateTime(theDate.getFullYear(), theDate.getMonth(), theDate.getDate(), screen_left.getHour(), screen_left.getMinute());
	}
	private function updateWhoData()
	{
		eventItem.setChecked(screen_right.getChecked());
	}
	
	//Saves the where data.
	public function	updateWhereData()
	{
		eventItem.setPlaceName(screen_down.getPlaceName());
		eventItem.setPhoneNumber(screen_down.getPhoneNumber());
		eventItem.setAddress(screen_down.getAddress());
	}

	private function move_x()
	{
		var end_x = 240*(int(selected_screen/10) - 5);
		new Tween(this.target.createscreen, "_x", None.easeIn, this.target.createscreen._x, end_x, .4, true);
	}
	
	private function move_y()
	{
		var end_y = 320*(selected_screen%10 - 5);
		new Tween(this.target.createscreen, "_y", None.easeIn, this.target.createscreen._y, end_y, .4, true);
	}
}