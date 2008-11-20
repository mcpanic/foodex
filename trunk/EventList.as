import mx.transitions.Tween;
import mx.transitions.easing.None;

// TODO: selector & scroll movement
//       pass selected event data to EventDetail class

class EventList extends FoodExScreen
{
	private var screen_new:MovieClip;
	private var screen_created:MovieClip;
	private var screen_accepted:MovieClip;
	private var screen_declined:MovieClip;
	
	private var arrNew:Array;
	private var arrCreated:Array;
	private var arrAccepted:Array;
	private var arrDeclined:Array;
	
	private var focus:Number;	// 1:New / 2:Created / 3:Accepted / 4:Declined
	
	private var selectedNewEvent:Number;
	private var selectedCreatedEvent:Number;
	private var selectedAcceptedEvent:Number;
	private var selectedDeclinedEvent:Number;

	private var selectorNewPosition:Number;
	private var selectorCreatedPosition:Number;
	private var selectorAcceptedPosition:Number;
	private var selectorDeclinedPosition:Number;

	private var isLoading:Boolean;

	public static var SelectorPosMax:Number = 4;

	public function EventList(target:MovieClip, x_coor:Number, y_coor:Number, titleText:String, buttonText1:String, buttonText2:String)
	{
		initFoodExScreen(target, x_coor, y_coor);
		attachScreen();
		this.setTitleBar(titleText);
		this.setButtons(buttonText1, buttonText2);
		
		arrNew = new Array();
		arrCreated = new Array();
		arrAccepted = new Array();
		arrDeclined = new Array();

		isLoading = false;
		getEvents();
		setFocus(1);
	}
	
	private function attachScreen()
	{
		// contents specific to this class
		var middlescreen:MovieClip = this.target.managescreen.attachMovie("BlankScreen", "screen_list", this.target.managescreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+50)});
		screen_new = this.target.managescreen.attachMovie("M_New", "list_new", this.target.managescreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+50)});
		screen_created = this.target.managescreen.attachMovie("M_Created", "list_created", this.target.managescreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+50)});
		screen_accepted = this.target.managescreen.attachMovie("M_Accepted", "list_accepted", this.target.managescreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+50)});
		screen_declined = this.target.managescreen.attachMovie("M_Declined", "list_declined", this.target.managescreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+50)});

		// common contents - specify unique names for each component
		titlebar = this.target.managescreen.attachMovie("FoodExTitle", "title_manage", this.target.managescreen.getNextHighestDepth(), {_x:xcoor, _y:ycoor});
		buttons = this.target.managescreen.attachMovie("FoodExButton", "buttons_list", this.target.managescreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+290)});

		// button color
		with (this.target.managescreen.buttons_list)
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
	public function removeScreen()
	{
		titlebar.removeMovieClip();
		buttons.removeMovieClip();
		this.target.managescreen.screen_list.removeMovieClip();
		screen_new.removeMovieClip();
		screen_created.removeMovieClip();
		screen_accepted.removeMovieClip();
		screen_declined.removeMovieClip();
	}
	public function getIsLoading()
	{
		return isLoading;
	}
	private function openLoadingAlert()
	{
		isLoading = true;
		var popup_loading:MovieClip = this.target.managescreen.attachMovie("Loading", "popup_loading", this.target.managescreen.getNextHighestDepth(), {_x:40, _y:140});
	}
	private function closeLoadingAlert()
	{
		this.target.managescreen.popup_loading.removeMovieClip();
		isLoading = false;
	}
	
	public function isAnEventSelected():Boolean
	{
		if (focus == 1)
			return (arrNew.length == 0)? false:true;
		else if (focus == 2)
			return (arrCreated.length == 0)? false:true;
		else if (focus == 3)
			return (arrAccepted.length == 0)? false:true;
		else
			return (arrDeclined.length == 0)? false:true;
	}
	
	public function getSelectedEvent():EventData
	{
		if (focus == 1)
			return arrNew[selectedNewEvent];
		else if (focus == 2)
			return arrCreated[selectedCreatedEvent];
		else if (focus == 3)
			return arrAccepted[selectedAcceptedEvent];
		else
			return arrDeclined[selectedDeclinedEvent];
	}

	public function increaseFocus()
	{
		if (focus < 4)
			setFocus(focus + 1);
		else
			setFocus(1);
	}
	public function decreaseFocus()
	{
		if (focus > 1)
			setFocus(focus - 1);
		else
			setFocus(4);
	}
	public function setFocus(newFocus:Number)
	{
		focus = newFocus;
		
		switch (focus)
		{
			case 1:
				screen_new._visible = true;
				screen_created._visible = false;
				screen_accepted._visible = false;
				screen_declined._visible = false;
				break;
			case 2:
				screen_new._visible = false;
				screen_created._visible = true;
				screen_accepted._visible = false;
				screen_declined._visible = false;
				break;
			case 3:
				screen_new._visible = false;
				screen_created._visible = false;
				screen_accepted._visible = true;
				screen_declined._visible = false;
				break;
			case 4:
				screen_new._visible = false;
				screen_created._visible = false;
				screen_accepted._visible = false;
				screen_declined._visible = true;
				break;
		}
	}


	public function scrollUpList()
	{
		switch (focus)
		{
			case 1:
				scrollUpList_New();
				break;
			case 2:
				scrollUpList_Created();
				break;
			case 3:
				scrollUpList_Accepted();
				break;
			case 4:
				scrollUpList_Declined();
				break;
		}
	}
	public function scrollDownList()
	{
		switch (focus)
		{
			case 1:
				scrollDownList_New();
				break;
			case 2:
				scrollDownList_Created();
				break;
			case 3:
				scrollDownList_Accepted();
				break;
			case 4:
				scrollDownList_Declined();
				break;
		}
	}
	private function scrollUpList_New()
	{
		if (selectedNewEvent > 0)
		{
			selectedNewEvent = selectedNewEvent - 1;
			if (selectorNewPosition <= 0)
			{
				selectorNewPosition = 0;
				screen_new.selector_new._y = 15 + selectorNewPosition*45;
				var end_y:Number = 15 + (selectorNewPosition-selectedNewEvent)*45;
				new Tween(screen_new.background, "_y", None.easeIn, screen_new.background._y, end_y, .2, true);
				end_y = 15-(selectorNewPosition-selectedNewEvent)*(screen_new.scrollbar_new._height/(SelectorPosMax+1));
				new Tween(screen_new.scrollbar_new, "_y", None.easeIn, screen_new.scrollbar_new._y, end_y, .2, true);
			}
			else
			{
				selectorNewPosition = selectorNewPosition - 1;
				var end_y:Number = 15 + selectorNewPosition*45;
				new Tween(screen_new.selector_new, "_y", None.easeIn, screen_new.selector_new._y, end_y, .2, true);
			}
		}
	}	
	private function scrollDownList_New()
	{
		if (selectedNewEvent < (arrNew.length - 1))
		{
			selectedNewEvent = selectedNewEvent + 1;
			if (selectorNewPosition >= SelectorPosMax)
			{
				selectorNewPosition = SelectorPosMax;
				screen_new.selector_new._y = 15 + selectorNewPosition*45;
				var end_y:Number = 15 + (selectorNewPosition-selectedNewEvent)*45;
				new Tween(screen_new.background, "_y", None.easeIn, screen_new.background._y, end_y, .2, true);
				end_y = 15-(selectorNewPosition-selectedNewEvent)*(screen_new.scrollbar_new._height/(SelectorPosMax+1));
				new Tween(screen_new.scrollbar_new, "_y", None.easeIn, screen_new.scrollbar_new._y, end_y, .2, true);
			}
			else
			{
				selectorNewPosition = selectorNewPosition + 1;
				var end_y:Number = 15 + selectorNewPosition*45;
				new Tween(screen_new.selector_new, "_y", None.easeIn, screen_new.selector_new._y, end_y, .2, true);
			}
		}
	}	
	private function scrollUpList_Created()
	{
		if (selectedCreatedEvent > 0)
		{
			selectedCreatedEvent = selectedCreatedEvent - 1;
			if (selectorCreatedPosition <= 0)
			{
				selectorCreatedPosition = 0;
				screen_created.selector_created._y = 15 + selectorCreatedPosition*45;
				var end_y:Number = 15 + (selectorCreatedPosition-selectedCreatedEvent)*45;
				new Tween(screen_created.background, "_y", None.easeIn, screen_created.background._y, end_y, .2, true);
				end_y = 15-(selectorCreatedPosition-selectedCreatedEvent)*(screen_created.scrollbar_created._height/(SelectorPosMax+1));
				new Tween(screen_created.scrollbar_created, "_y", None.easeIn, screen_created.scrollbar_created._y, end_y, .2, true);
			}
			else
			{
				selectorCreatedPosition = selectorCreatedPosition - 1;
				var end_y:Number = 15 + selectorCreatedPosition*45;
				new Tween(screen_created.selector_created, "_y", None.easeIn, screen_created.selector_created._y, end_y, .2, true);
			}
		}
	}	
	private function scrollDownList_Created()
	{
		if (selectedCreatedEvent < (arrCreated.length - 1))
		{
			selectedCreatedEvent = selectedCreatedEvent + 1;
			if (selectorCreatedPosition >= SelectorPosMax)
			{
				selectorCreatedPosition = SelectorPosMax;
				screen_created.selector_created._y = 15 + selectorCreatedPosition*45;
				var end_y:Number = 15 + (selectorCreatedPosition-selectedCreatedEvent)*45;
				new Tween(screen_created.background, "_y", None.easeIn, screen_created.background._y, end_y, .2, true);
				end_y = 15-(selectorCreatedPosition-selectedCreatedEvent)*(screen_created.scrollbar_created._height/(SelectorPosMax+1));
				new Tween(screen_created.scrollbar_created, "_y", None.easeIn, screen_created.scrollbar_created._y, end_y, .2, true);
			}
			else
			{
				selectorCreatedPosition = selectorCreatedPosition + 1;
				var end_y:Number = 15 + selectorCreatedPosition*45;
				new Tween(screen_created.selector_created, "_y", None.easeIn, screen_created.selector_created._y, end_y, .2, true);
			}
		}
	}	
	private function scrollUpList_Accepted()
	{
		if (selectedAcceptedEvent > 0)
		{
			selectedAcceptedEvent = selectedAcceptedEvent - 1;
			if (selectorAcceptedPosition <= 0)
			{
				selectorAcceptedPosition = 0;
				screen_accepted.selector_accepted._y = 15 + selectorAcceptedPosition*45;
				var end_y:Number = 15 + (selectorAcceptedPosition-selectedAcceptedEvent)*45;
				new Tween(screen_accepted.background, "_y", None.easeIn, screen_accepted.background._y, end_y, .2, true);
				end_y = 15-(selectorAcceptedPosition-selectedAcceptedEvent)*(screen_accepted.scrollbar_accepted._height/(SelectorPosMax+1));
				new Tween(screen_accepted.scrollbar_accepted, "_y", None.easeIn, screen_accepted.scrollbar_accepted._y, end_y, .2, true);
			}
			else
			{
				selectorAcceptedPosition = selectorAcceptedPosition - 1;
				var end_y:Number = 15 + selectorAcceptedPosition*45;
				new Tween(screen_accepted.selector_accepted, "_y", None.easeIn, screen_accepted.selector_accepted._y, end_y, .2, true);
			}
		}
	}	
	private function scrollDownList_Accepted()
	{
		if (selectedAcceptedEvent < (arrAccepted.length - 1))
		{
			selectedAcceptedEvent = selectedAcceptedEvent + 1;
			if (selectorAcceptedPosition >= SelectorPosMax)
			{
				selectorAcceptedPosition = SelectorPosMax;
				screen_accepted.selector_accepted._y = 15 + selectorAcceptedPosition*45;
				var end_y:Number = 15 + (selectorAcceptedPosition-selectedAcceptedEvent)*45;
				new Tween(screen_accepted.background, "_y", None.easeIn, screen_accepted.background._y, end_y, .2, true);
				end_y = 15-(selectorAcceptedPosition-selectedAcceptedEvent)*(screen_accepted.scrollbar_accepted._height/(SelectorPosMax+1));
				new Tween(screen_accepted.scrollbar_accepted, "_y", None.easeIn, screen_accepted.scrollbar_accepted._y, end_y, .2, true);
			}
			else
			{
				selectorAcceptedPosition = selectorAcceptedPosition + 1;
				var end_y:Number = 15 + selectorAcceptedPosition*45;
				new Tween(screen_accepted.selector_accepted, "_y", None.easeIn, screen_accepted.selector_accepted._y, end_y, .2, true);
			}
		}
	}	
	private function scrollUpList_Declined()
	{
		if (selectedDeclinedEvent > 0)
		{
			selectedDeclinedEvent = selectedDeclinedEvent - 1;
			if (selectorDeclinedPosition <= 0)
			{
				selectorDeclinedPosition = 0;
				screen_declined.selector_declined._y = 15 + selectorDeclinedPosition*45;
				var end_y:Number = 15 + (selectorDeclinedPosition-selectedDeclinedEvent)*45;
				new Tween(screen_declined.background, "_y", None.easeIn, screen_declined.background._y, end_y, .2, true);
				end_y = 15-(selectorDeclinedPosition-selectedDeclinedEvent)*(screen_declined.scrollbar_declined._height/(SelectorPosMax+1));
				new Tween(screen_declined.scrollbar_declined, "_y", None.easeIn, screen_declined.scrollbar_declined._y, end_y, .2, true);
			}
			else
			{
				selectorDeclinedPosition = selectorDeclinedPosition - 1;
				var end_y:Number = 15 + selectorDeclinedPosition*45;
				new Tween(screen_declined.selector_declined, "_y", None.easeIn, screen_declined.selector_declined._y, end_y, .2, true);
			}
		}
	}	
	private function scrollDownList_Declined()
	{
		if (selectedDeclinedEvent < (arrDeclined.length - 1))
		{
			selectedDeclinedEvent = selectedDeclinedEvent + 1;
			if (selectorDeclinedPosition >= SelectorPosMax)
			{
				selectorDeclinedPosition = SelectorPosMax;
				screen_declined.selector_declined._y = 15 + selectorDeclinedPosition*45;
				var end_y:Number = 15 + (selectorDeclinedPosition-selectedDeclinedEvent)*45;
				new Tween(screen_declined.background, "_y", None.easeIn, screen_declined.background._y, end_y, .2, true);
				end_y = 15-(selectorDeclinedPosition-selectedDeclinedEvent)*(screen_declined.scrollbar_declined._height/(SelectorPosMax+1));
				new Tween(screen_declined.scrollbar_declined, "_y", None.easeIn, screen_declined.scrollbar_declined._y, end_y, .2, true);
			}
			else
			{
				selectorDeclinedPosition = selectorDeclinedPosition + 1;
				var end_y:Number = 15 + selectorDeclinedPosition*45;
				new Tween(screen_declined.selector_declined, "_y", None.easeIn, screen_declined.selector_declined._y, end_y, .2, true);
			}
		}
	}	
	
	private function eventXMLOnLoad(success:Boolean, inputXML:XML):Void 
	{
		//trace("XML: " + inputXML);
		if (success) 
		{	
			if (inputXML.firstChild.attributes.EVENTID)
			{
				// Save this value to some place for later use
			}
			if (inputXML.firstChild.attributes.RESPONSETYPE != FoodExDef.PacketType.MYEVENT)
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
					if (dataNode.nodeName == "EVENTINFO")
					{	
						evt.setEventID(dataNode.attributes.eventid);
						//evt.setEventStatus(dataNode.attributes.eventstatus);
						//trace("STATUS: " + evt.getEventStatus());
					}
					else if (dataNode.nodeName == "TITLEDATA")
					{	
						evt.setTitleString(dataNode.attributes.eventtitle);
						evt.setMessageString(dataNode.attributes.eventmessage);
					}
					else if (dataNode.nodeName == "WHENDATA")
					{	
						var dateTimeString:String = dataNode.attributes.datetime;
						//YYYY-MM-DD HH:MM:SS"
						evt.setDateTimeString(dateTimeString.substr(0,4), dateTimeString.substr(5,2), dateTimeString.substr(8,2), 
										dateTimeString.substr(11,2), dateTimeString.substr(14,2));																															  
						//trace("DATETIME: " + evt.getDateString());
					}
					else if (dataNode.nodeName == "WHEREDATA")
					{	
						evt.setPlaceName(dataNode.attributes.placename);
						evt.setPhoneNumber(dataNode.attributes.phonenumber);
						evt.setAddress(dataNode.attributes.address);	
						evt.setLatitude(Number(dataNode.attributes.gpsx));				
						evt.setLongitude(Number(dataNode.attributes.gpsy));						
						trace(dataNode.attributes.gpsx + " " + dataNode.attributes.gpsy);
					}
					else if (dataNode.nodeName == "WHODATA")
					{	
						var eventWhoList:Array = new Array();						
						var personNode:XMLNode = dataNode.firstChild;
						//trace (personNode);
						for (var numtosend:Number = 0; numtosend < Number(dataNode.attributes.numtosend); numtosend++)
						{								

							//trace("NUMBER: " + personNode.attributes.number);
							// get my status on this event.
							//TODO: Compare with my default number!
							if (personNode.attributes.number == FoodExDef.UserPhoneNumber)
							{
								myStatus = personNode.attributes.status;
								evt.setEventStatus(myStatus);
							}
							//["Alvis",			"111-111-1111",	-1,		1, 0],
							eventWhoList.push([personNode.attributes.name, personNode.attributes.number, personNode.attributes.distance, personNode.attributes.status, 0]);
							personNode = personNode.nextSibling;
						} 
						evt.setContacts(eventWhoList);
					}						
				}					
				//trace ("MyStatus: " + myStatus);		
				//trace ("node: " + eventNode);
				if (myStatus == FoodExDef.PersonStatus.PENDING)	// Pending - new
					arrNew.push(evt);
				else if (myStatus == FoodExDef.PersonStatus.CREATED)	// Creator
					arrCreated.push(evt);
				else if (myStatus == FoodExDef.PersonStatus.ACCEPTED)	// Accepted
					arrAccepted.push(evt);
				else if (myStatus == FoodExDef.PersonStatus.DECLINED)	// Declined
					arrDeclined.push(evt);

				delete evt;							
				trace (arrNew.length +" "+ arrCreated.length +" "+ arrAccepted.length + " " + arrDeclined.length);
				}
			// Now load the data into the screen.	
			fillEvents();
			
		} else {
			trace("an error occurred.");
		}
		
		closeLoadingAlert();
	}
		
	private function getEvents()
	{
		openLoadingAlert();

		var owner:EventList = this;
		
		// ignore XML white space
		XML.prototype.ignoreWhite = true;
		// Construct an XML object to hold the server's reply
		var getEventsReplyXML:XML = new XML();
		// this function triggers when an XML packet is received from the server.		
		getEventsReplyXML.onLoad = function(success:Boolean) {
			//inputXML = this;
			//trace(inputXML);
			owner.eventXMLOnLoad(success, this);
		}
	
		var getEventsXML:XML = new XML();
		getEventsXML.contentType = "application/xml";
		var topElement:XMLNode = getEventsXML.createElement("EVENT");
		getEventsXML.appendChild(topElement);
		
		// create XML formatted data to send to the server
		
		// 1. event info - event meta data
		var eventElement:XMLNode = getEventsXML.createElement("EVENTINFO");
		eventElement.attributes.requesttype = 	FoodExDef.PacketType.MYEVENT;
		topElement.appendChild(eventElement);
		
		// 5. sender info
		eventElement = getEventsXML.createElement("SENDERDATA");
		eventElement.attributes.name = 			FoodExDef.UserName;		
		eventElement.attributes.number = 		FoodExDef.UserPhoneNumber;	
		eventElement.attributes.gpsx = 			FoodExDef.UserGPSX;
		eventElement.attributes.gpsy = 			FoodExDef.UserGPSY;
		topElement.appendChild(eventElement);			

		// send the XML formatted data to the server
		trace(getEventsXML);
		getEventsXML.sendAndLoad(FoodExDef.SeverAddress, getEventsReplyXML, "POST");

	}

	private function fillEvents()
	{
		// Attach events to the lists
		// New
		if (arrNew.length == 0)
		{
			var event_info:MovieClip = screen_new.background.attachMovie("EventInfo", "new_0", screen_new.background.getNextHighestDepth(), {_x:0, _y:0});
			event_info.txtTitle.text = "No new event";
			event_info.txtWhen.text = "";
			event_info.txtWhere.text = "";
		}
		else
		{
			for (var i:Number = 0; i < arrNew.length; i++)
			{
				var moviename:String = "new_" + i.toString();
				var event_info:MovieClip = screen_new.background.attachMovie("EventInfo", moviename, screen_new.background.getNextHighestDepth(), {_x:0, _y:i*45});
				event_info.txtTitle.text = arrNew[i].getTitleString();
				event_info.txtWhen.text = arrNew[i].getDateString();	// TODO: convert it to today, tomorrow, ...
				event_info.txtWhere.text = arrNew[i].getPlaceName();
			}
		}
		// event selector
		var selector_new:MovieClip  = screen_new.attachMovie("EventSelector", "selector_new", screen_new.getNextHighestDepth(), {_x:0, _y:15});
		selectorNewPosition = 0;
		selectedNewEvent = 0;
		if (arrNew.length == 0)
			selector_new._alpha = 0;
		else
			selector_new._alpha = 100;
		// scroll bar
		var scrollbar_new:MovieClip  = screen_new.attachMovie("ScrollBar", "scrollbar_new", screen_new.getNextHighestDepth(), {_x:235, _y:15});
		scrollbar_new._height = (arrNew.length <= SelectorPosMax+1)? 225 : 225 * (SelectorPosMax+1) / arrNew.length;
		scrollbar_new._y = 15;

		// Created
		if (arrCreated.length == 0)
		{
			var event_info:MovieClip = screen_created.background.attachMovie("EventInfo", "created_0", screen_created.background.getNextHighestDepth(), {_x:0, _y:0});
			event_info.txtTitle.text = "No created event";
			event_info.txtWhen.text = "";
			event_info.txtWhere.text = "";
		}
		else
		{
			for (var i:Number = 0; i < arrCreated.length; i++)
			{
				var moviename:String = "created_" + i.toString();
				var event_info:MovieClip = screen_created.background.attachMovie("EventInfo", moviename, screen_created.background.getNextHighestDepth(), {_x:0, _y:i*45});
				event_info.txtTitle.text = arrCreated[i].getTitleString();
				event_info.txtWhen.text = arrCreated[i].getDateString();	// TODO: convert it to today, tomorrow, ...
				event_info.txtWhere.text = arrCreated[i].getPlaceName();
			}
		}
		// event selector
		var selector_created:MovieClip  = screen_created.attachMovie("EventSelector", "selector_created", screen_created.getNextHighestDepth(), {_x:0, _y:15});
		selectorCreatedPosition = 0;
		selectedCreatedEvent = 0;
		if (arrCreated.length == 0)
			selector_created._alpha = 0;
		else
			selector_created._alpha = 100;
		// scroll bar
		var scrollbar_created:MovieClip  = screen_created.attachMovie("ScrollBar", "scrollbar_created", screen_created.getNextHighestDepth(), {_x:235, _y:15});
		scrollbar_created._height = (arrCreated.length <= SelectorPosMax+1)? 225 : 225 * (SelectorPosMax+1) / arrCreated.length;
		scrollbar_created._y = 15;

		// Accepted
		if (arrAccepted.length == 0)
		{
			var event_info:MovieClip = screen_accepted.background.attachMovie("EventInfo", "accepted_0", screen_accepted.background.getNextHighestDepth(), {_x:0, _y:0});
			event_info.txtTitle.text = "No accepted event";
			event_info.txtWhen.text = "";
			event_info.txtWhere.text = "";
		}
		else
		{
			for (var i:Number = 0; i < arrAccepted.length; i++)
			{
				var moviename:String = "accepted_" + i.toString();
				var event_info:MovieClip = screen_accepted.background.attachMovie("EventInfo", moviename, screen_accepted.background.getNextHighestDepth(), {_x:0, _y:i*45});
				event_info.txtTitle.text = arrAccepted[i].getTitleString();
				event_info.txtWhen.text = arrAccepted[i].getDateString();	// TODO: convert it to today, tomorrow, ...
				event_info.txtWhere.text = arrAccepted[i].getPlaceName();
			}
		}
		// event selector
		var selector_accpeted:MovieClip = screen_accepted.attachMovie("EventSelector", "selector_accepted", screen_accepted.getNextHighestDepth(), {_x:0, _y:15});
		selectorAcceptedPosition = 0;
		selectedAcceptedEvent = 0;
		if (arrAccepted.length == 0)
			selector_accpeted._alpha = 0;
		else
			selector_accpeted._alpha = 100;
		// scroll bar
		var scrollbar_accepted:MovieClip  = screen_accepted.attachMovie("ScrollBar", "scrollbar_accepted", screen_accepted.getNextHighestDepth(), {_x:235, _y:15});
		scrollbar_accepted._height = (arrAccepted.length <= SelectorPosMax+1)? 225 : 225 * (SelectorPosMax+1) / arrAccepted.length;
		scrollbar_accepted._y = 15;

		// Declined
		if (arrDeclined.length == 0)
		{
			var event_info:MovieClip = screen_declined.background.attachMovie("EventInfo", "declined_0", screen_declined.background.getNextHighestDepth(), {_x:0, _y:0});
			event_info.txtTitle.text = "No declined event";
			event_info.txtWhen.text = "";
			event_info.txtWhere.text = "";
		}
		else
		{
			for (var i:Number = 0; i < arrDeclined.length; i++)
			{
				var moviename:String = "declined_" + i.toString();
				var event_info:MovieClip = screen_declined.background.attachMovie("EventInfo", moviename, screen_declined.background.getNextHighestDepth(), {_x:0, _y:i*45});
				event_info.txtTitle.text = arrDeclined[i].getTitleString();
				event_info.txtWhen.text = arrDeclined[i].getDateString();	// TODO: convert it to today, tomorrow, ...
				event_info.txtWhere.text = arrDeclined[i].getPlaceName();
			}
		}
		// event selector
		var selector_declined:MovieClip  = screen_declined.attachMovie("EventSelector", "selector_declined", screen_declined.getNextHighestDepth(), {_x:0, _y:15});
		selectorDeclinedPosition = 0;
		selectedDeclinedEvent = 0;
		if (arrDeclined.length == 0)
			selector_declined._alpha = 0;
		else
			selector_declined._alpha = 100;
		// scroll bar
		var scrollbar_declined:MovieClip  = screen_declined.attachMovie("ScrollBar", "scrollbar_declined", screen_declined.getNextHighestDepth(), {_x:235, _y:15});
		scrollbar_declined._height = (arrDeclined.length <= SelectorPosMax+1)? 225 : 225 * (SelectorPosMax+1) / arrDeclined.length;
		scrollbar_declined._y = 15;
	}
	
}