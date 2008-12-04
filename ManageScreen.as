import mx.transitions.Tween;
import mx.transitions.easing.None;

class ManageScreen extends MovieClip
{
	private var target:MovieClip;

	private var screen_list:EventList;
	private var screen_detail:EventDetail;

	private var screenMode:Number;		// 1:List, 2:EventDetail
	private var isAnswerMode:Boolean;
	private var isManageMode:Boolean;
	private var confirmMode:Number;		// 0:None, 1:Update, 2:Cancel, 3:Accept, 4:Decline
	private var isAlertMode:Boolean;

	private var selectedAnswer:Number;
	private var selectedManage:Number;
	
	public function ManageScreen(target:MovieClip)
	{
		this.target = target;
		this.target.createEmptyMovieClip("managescreen", 5);

		screenMode = 1;
		screen_list = new EventList(this.target, 0, 0, "Manage My Events", "Select", "Back");
		Key.addListener(this);
		
		isAnswerMode = false;
		isManageMode = false;
		confirmMode = 0;
		isAlertMode = false;
	}
	
	private function setMode(m:Number)
	{
		screenMode = m;
		
		if (screenMode == 1)
		{
			//screen_detail.removeScreen();
			this.target.createEmptyMovieClip("managescreen", 5);
			screen_list = new EventList(this.target, 0, 0, "Manage My Events", "Select", "Back");
			delete screen_detail;
		}
		else if (screenMode == 2)
		{
			screen_list.removeScreen();
			screen_detail = new EventDetail(this.target, screen_list.getSelectedEvent());
			delete screen_list;
		}
	}

	public function onKeyDown()
	{
		if (isAnswerMode)
			onKeyDown_AnswerMode();
		else if (isManageMode)
			onKeyDown_ManageMode();
		else if (confirmMode > 0)
			onKeyDown_ConfirmMode();
		else if (isAlertMode)
			onKeyDown_AlertMode();
		else if (screen_list.getIsLoading())
			return;
		else if (screenMode == 1)
			onKeyDown1();
		else if (screenMode == 2)
			onKeyDown2();
	}
	private function onKeyDown1()
	{
		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				if (screen_list.isAnEventSelected())
				{
					setMode(2);
				}
				break;
			case ExtendedKey.SOFT2:
				this.target.gotoAndStop("Home");
				Key.removeListener(this);
				break;
			case Key.LEFT:
				screen_list.decreaseFocus();
				break;
			case Key.RIGHT:
				screen_list.increaseFocus();
				break;
			case Key.UP:
				screen_list.scrollUpList();
				break;
			case Key.DOWN:
				screen_list.scrollDownList();
				break;
			case Key.ENTER:
				if (screen_list.isAnEventSelected())
				{
					setMode(2);
				}
				break;
		}
	}
	private function onKeyDown2()
	{
		if ((Key.getCode() == ExtendedKey.SOFT1) && (screen_detail.getSelectedScreen() == 55))
		{
			if (screen_detail.isReadOnly() == false)		// Created
			{
				openManage();
			}
			else if (screen_detail.getEventStatus() == FoodExDef.PersonStatus.PENDING)	// New
			{
				openAnswer();
			}
		}
		else if ((Key.getCode() == ExtendedKey.SOFT2) && (screen_detail.getSelectedScreen() == 55))
			setMode(1);
		else
			screen_detail.onKeyDown();
	}
	private function onKeyDown_AnswerMode()
	{
		switch (Key.getCode())
		{
			case Key.UP:
				answerSelector_up();
				break;
			case Key.DOWN:
				answerSelector_down();
				break;
			case Key.ENTER:
				answerSelect();
				break;
			case ExtendedKey.SOFT1:
				answerSelect();
				break;
			case ExtendedKey.SOFT2:
				selectedAnswer = 3;
				answerSelect();
				break;
		}
	}
	private function onKeyDown_ManageMode()
	{
		switch (Key.getCode())
		{
			case Key.UP:
				manageSelector_up();
				break;
			case Key.DOWN:
				manageSelector_down();
				break;
			case Key.ENTER:
				manageSelect();
				break;
			case ExtendedKey.SOFT1:
				manageSelect();
				break;
			case ExtendedKey.SOFT2:
				selectedManage = 3;
				manageSelect();
				break;
		}
	}

	private function openAnswer()
	{
		isAnswerMode = true;
		screen_detail.setButtonTexts("Select", "Close");
	
		var answer_menu:MovieClip = this.target.createscreen.attachMovie("SelectBox3", "answer_menu", this.target.createscreen.getNextHighestDepth(), {_x:0, _y:205});
		answer_menu.selector._y = 5;
		answer_menu.txt1.text = "Accept this invitation";
		answer_menu.txt2.text = "Decline this invitation";
		answer_menu.txt3.text = "Close";
		answer_menu._alpha = 80;
		selectedAnswer = 1;
	}
	private function answerSelector_up()
	{
		if (selectedAnswer > 1)
		{
			selectedAnswer = selectedAnswer - 1;
			var end_y:Number = -20 + selectedAnswer*25;
			new Tween(this.target.createscreen.answer_menu.selector, "_y", None.easeIn, this.target.createscreen.answer_menu.selector._y, end_y, .2, true);
		}
	}
	private function answerSelector_down()
	{
		if (selectedAnswer < 3)
		{
			selectedAnswer = selectedAnswer + 1;
			var end_y:Number = -20 + selectedAnswer*25;
			new Tween(this.target.createscreen.answer_menu.selector, "_y", None.easeIn, this.target.createscreen.answer_menu.selector._y, end_y, .2, true);
		}
	}
	private function answerSelect()
	{
		this.target.createscreen.answer_menu.removeMovieClip();
		isAnswerMode = false;
		screen_detail.setButtonTextsToDefault();
	
		if (selectedAnswer == 1)
			openConfirm(3);
		else if (selectedAnswer == 2)
			openConfirm(4);
	}
	
	private function openManage()
	{
		isManageMode = true;
		screen_detail.setButtonTexts("Select", "Close");
	
		var manage_menu:MovieClip = this.target.createscreen.attachMovie("SelectBox3", "manage_menu", this.target.createscreen.getNextHighestDepth(), {_x:0, _y:205});
		manage_menu.selector._y = 5;
		manage_menu.txt1.text = "Updata event info";
		manage_menu.txt2.text = "Cancel this event";
		manage_menu.txt3.text = "Close";
		manage_menu._alpha = 80;
		selectedManage = 1;
	}
	private function manageSelector_up()
	{
		if (selectedManage> 1)
		{
			selectedManage = selectedManage - 1;
			var end_y:Number = -20 + selectedManage*25;
			new Tween(this.target.createscreen.manage_menu.selector, "_y", None.easeIn, this.target.createscreen.manage_menu.selector._y, end_y, .2, true);
		}
	}
	private function manageSelector_down()
	{
		if (selectedManage < 3)
		{
			selectedManage = selectedManage + 1;
			var end_y:Number = -20 + selectedManage*25;
			new Tween(this.target.createscreen.manage_menu.selector, "_y", None.easeIn, this.target.createscreen.manage_menu.selector._y, end_y, .2, true);
		}
	}
	private function manageSelect()
	{
		this.target.createscreen.manage_menu.removeMovieClip();
		isManageMode = false;
		screen_detail.setButtonTextsToDefault("Manage", "Back");

		if (selectedManage == 1)
			openConfirm(1);
		else if (selectedManage == 2)
			openConfirm(2);
	}
	
	private function onKeyDown_ConfirmMode()
	{
		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				if (confirmMode == 1)
				{
					closeConfirm();
					manage(1);
				}
				else if (confirmMode == 2)
				{
					closeConfirm();
					manage(2);
				}
				else if (confirmMode == 3)
				{
					closeConfirm();
					answer(1);
				}
				else if (confirmMode == 4)
				{
					closeConfirm();
					answer(2);
				}
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
	private function openConfirm(cm:Number)
	{
		confirmMode = cm;
	
		var popup_confirm:MovieClip = this.target.createscreen.attachMovie("Popup_Confirm", "popup_confirm", this.target.createscreen.getNextHighestDepth(), {_x:10, _y:110});
		if (confirmMode == 1)
			popup_confirm.txtQuestion.text = "Do you want to update event information? Updated invitation will be sent to guests.";
		else if (confirmMode == 2)
			popup_confirm.txtQuestion.text = "Do you want to cancel this event? A cancel message will be sent to guests.";
		else if (confirmMode == 3)
			popup_confirm.txtQuestion.text = "Do you want to accept this invitation?";
		else if (confirmMode == 4)
			popup_confirm.txtQuestion.text = "Do you want to decline this invitation?";
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
		confirmMode = 0;
	}
	private function closeAlert()
	{
		this.target.createscreen.popup_alert.removeMovieClip();
		isAlertMode = false;
		setMode(1);
	}


	private function manageXMLOnLoad(success:Boolean, inputXML:XML, responseType:Number):Void 
	{
//trace("RESPONSE: " + this);		
		if (success) {
			
			if (inputXML.firstChild.attributes.EVENTID)
			{
				// Save this value to some place for later use
			}
			if (inputXML.firstChild.attributes.RESPONSETYPE != responseType)
			{
				trace("Error in response type!");
			}
			switch (inputXML.firstChild.attributes.STATUS) 
			{
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
		} else {
			trace("an error occurred.");
		}
		
	}
	

	private function answer(a:Number)
	{
		// Send ANSWER to server
		// a == 1 -> ACCEPT
		// a == 2 -> DECLINE
		// Corresponding event data = screen_detail.eventItem (which is set to be private)

		var owner:ManageScreen = this;
		
		// ignore XML white space
		XML.prototype.ignoreWhite = true;
		// Construct an XML object to hold the server's reply
		var answerReplyXML:XML = new XML();
		// this function triggers when an XML packet is received from the server.		
		answerReplyXML.onLoad = function(success:Boolean) {
			owner.manageXMLOnLoad(success, this, FoodExDef.PacketType.ANSWER);
		}
		// this function triggers when the login_btn is clicked
			var answerXML:XML = new XML();
			answerXML.contentType = "application/xml";
			var topElement:XMLNode = answerXML.createElement("EVENT");
			answerXML.appendChild(topElement);
			
			// create XML formatted data to send to the server
			
			// 1. event info - event meta data
			var eventElement:XMLNode = answerXML.createElement("EVENTINFO");
			eventElement.attributes.requesttype = 	FoodExDef.PacketType.ANSWER;
			eventElement.attributes.eventid = 		screen_detail.eventItem.getEventID();
			if (a == 1)	// ACCEPT
				eventElement.attributes.answertype = 	FoodExDef.PersonStatus.ACCEPTED;
			else if (a == 2) // DECLINE
				eventElement.attributes.answertype = 	FoodExDef.PersonStatus.DECLINED;
			else
				trace("Impossible choice: must be either accept/decline");
			topElement.appendChild(eventElement);
			
			// 5. sender info
			eventElement = answerXML.createElement("SENDERDATA");
			eventElement.attributes.name = 			FoodExDef.UserName;		
			eventElement.attributes.number = 		FoodExDef.UserPhoneNumber;	
			eventElement.attributes.gpsx = 			FoodExDef.UserGPSX;
			eventElement.attributes.gpsy = 			FoodExDef.UserGPSY;
			topElement.appendChild(eventElement);			

			// send the XML formatted data to the server
			trace("ANSWER: " + answerXML);
			answerXML.sendAndLoad(FoodExDef.SeverAddress, answerReplyXML, "POST");
		
		if (a == 1)
			openAlert("You accepted this invitation.");
		else if (a == 2)
			openAlert("You declined this invitation.");
	}

	private function modify()
	{
		var owner:ManageScreen = this;		
		// ignore XML white space
		XML.prototype.ignoreWhite = true;
		// Construct an XML object to hold the server's reply
		var modifyReplyXML:XML = new XML();
		// this function triggers when an XML packet is received from the server.		
		modifyReplyXML.onLoad = function(success:Boolean) {
			owner.manageXMLOnLoad(success, this, FoodExDef.PacketType.MODIFY);
		};
		
		// this function triggers when the login_btn is clicked
			var modifyXML:XML = new XML();
			modifyXML.contentType = "application/xml";
			var topElement:XMLNode = modifyXML.createElement("EVENT");
			modifyXML.appendChild(topElement);
			
			// create XML formatted data to send to the server
			
			// 1. event info - event meta data
			var eventElement:XMLNode = modifyXML.createElement("EVENTINFO");
			eventElement.attributes.requesttype = 	FoodExDef.PacketType.MODIFY;		// 5: Modify Event	
			eventElement.attributes.eventid = 		screen_detail.eventItem.getEventID();	// New event ID default to 0, automatically assigned by the server
			topElement.appendChild(eventElement);
			
			// 2. title & message
			eventElement = modifyXML.createElement("TITLEDATA");
			eventElement.attributes.eventtitle = 	screen_detail.eventItem.getTitleString();
			eventElement.attributes.eventmessage = 	screen_detail.eventItem.getMessageString();
			topElement.appendChild(eventElement);			
			
			// 3. when
			eventElement = modifyXML.createElement("WHENDATA");		
			// set it to match MySQL Datetime format: YYYY-MM-DD HH:MM:SS
			var str_datetime:String = new String();
			str_datetime = (screen_detail.eventItem.getDateTime().getYear()+1900).toString() + "-" + (screen_detail.eventItem.getDateTime().getMonth()+1).toString() + "-" + screen_detail.eventItem.getDateTime().getDate().toString() 
						+ " " + screen_detail.eventItem.getDateTime().getHours().toString() + ":" + screen_detail.eventItem.getDateTime().getMinutes().toString() + ":" + screen_detail.eventItem.getDateTime().getSeconds().toString();		
			eventElement.attributes.datetime = 		str_datetime;	
			trace (screen_detail.eventItem.getDateTime().toString());
			//eventElement.attributes.time = 		eventItem.getTimeString();
			topElement.appendChild(eventElement);			
			
			// 4. where
			eventElement = modifyXML.createElement("WHEREDATA");			
			eventElement.attributes.placename = 	screen_detail.eventItem.getPlaceName();
			eventElement.attributes.phonenumber = 	screen_detail.eventItem.getPhoneNumber();
			eventElement.attributes.address = 		screen_detail.eventItem.getAddress();
			topElement.appendChild(eventElement);		
			
			// 5. who
			eventElement = modifyXML.createElement("WHODATA");		
			eventElement.attributes.numtosend = 	screen_detail.eventItem.getNumToSend().toString();
			topElement.appendChild(eventElement);
			var checkedList:Array = screen_detail.eventItem.getCheckedList();
			for (var i:Number = 0; i < screen_detail.eventItem.getNumToSend(); i++)
			{
				var personElement:XMLNode = modifyXML.createElement("PERSON");
				personElement.attributes.name = 	checkedList[i][0];
				personElement.attributes.number = 	checkedList[i][1];
				personElement.attributes.distance = 	checkedList[i][2];
				personElement.attributes.status = 	checkedList[i][3];
				//personElement.attributes.checked = 	checkedList[i][0];				
				eventElement.appendChild(personElement);
			}
			
			// 5. sender info
			eventElement = modifyXML.createElement("SENDERDATA");
			eventElement.attributes.name = 			FoodExDef.UserName;		
			eventElement.attributes.number = 		FoodExDef.UserPhoneNumber;	
			eventElement.attributes.gpsx = 			FoodExDef.UserGPSX;
			eventElement.attributes.gpsy = 			FoodExDef.UserGPSY;

			topElement.appendChild(eventElement);			

			// send the XML formatted data to the server
			trace(modifyXML);
			modifyXML.sendAndLoad(FoodExDef.SeverAddress, modifyReplyXML, "POST");
			
			openAlert("Event information is updated.");
	}

	private function cancel()
	{
		var owner:ManageScreen = this;		
		// ignore XML white space
		XML.prototype.ignoreWhite = true;
		// Construct an XML object to hold the server's reply
		var cancelReplyXML:XML = new XML();
		// this function triggers when an XML packet is received from the server.		
		cancelReplyXML.onLoad = function(success:Boolean) {
			owner.manageXMLOnLoad(success, this, FoodExDef.PacketType.CANCEL);
		};
		
		// this function triggers when the login_btn is clicked
			var cancelXML:XML = new XML();
			cancelXML.contentType = "application/xml";
			var topElement:XMLNode = cancelXML.createElement("EVENT");
			cancelXML.appendChild(topElement);
			
			// create XML formatted data to send to the server
			
			// 1. event info - event meta data
			var eventElement:XMLNode = cancelXML.createElement("EVENTINFO");
			eventElement.attributes.requesttype = 	FoodExDef.PacketType.CANCEL;		// 5: Modify Event	
			eventElement.attributes.eventid = 		screen_detail.eventItem.getEventID();	// New event ID default to 0, automatically assigned by the server
			topElement.appendChild(eventElement);
			
			// 5. sender info
			eventElement = cancelXML.createElement("SENDERDATA");
			eventElement.attributes.name = 			FoodExDef.UserName;		
			eventElement.attributes.number = 		FoodExDef.UserPhoneNumber;	
			eventElement.attributes.gpsx = 			FoodExDef.UserGPSX;
			eventElement.attributes.gpsy = 			FoodExDef.UserGPSY;

			topElement.appendChild(eventElement);			

			// send the XML formatted data to the server
			trace(cancelXML);
			cancelXML.sendAndLoad(FoodExDef.SeverAddress, cancelReplyXML, "POST");		
		
			openAlert("This event is canceled.");
	}
	
	private function manage(a:Number)
	{
		// Send UPDATE or CANCEL to server
		if (a==1)
			modify();
		else if (a==2)
			cancel();

		// Corresponding event data = screen_detail.eventItem (which is set to be private)
	}

}