import mx.transitions.Tween;
import mx.transitions.easing.None;

class EventDetail extends MovieClip
{
	private var target:MovieClip;
	
	public var eventItem:EventData;
	
	private var screen_center:CreateCenter;	// ID: 55
	private var screen_up:CreateTitle;		// ID: 56
	private var screen_left:CreateWhen;		// ID: 45
	private var screen_right:CreateWho;		// ID: 65
	private var screen_down:CreateWhere;	// ID: 54

	private var selected_screen:Number;		// Selected screen

	private var isConfirmMode:Boolean;
	private var isAlertMode:Boolean;

	public function EventDetail(target:MovieClip, item:EventData)
	{
		this.target = target;
		this.target.createEmptyMovieClip("createscreen", 5);
		eventItem = item;

		// Screen properties
		selected_screen = 55;	// default to center

		// Screens
		if (eventItem.isReadOnly())
		{
			screen_center = new CreateCenter(this.target, 0, 0, "Event Detail", (eventItem.getEventStatus()==1)? "Answer":"", "Back");
			screen_up = new CreateTitle(this.target, 0, -320, "Title and Message", "", "Back", true);
			screen_left = new CreateWhen(this.target, -240, 0, "Date and Time", "", "Back", true);
			screen_right = new CreateWho(this.target, 240, 0, "Who's coming?", "", "Back", true, 2);
			screen_down = new CreateWhere(this.target, 0, 320, "Location", "", "Back");
			initWhere(true);
		}
		else
		{
			screen_center = new CreateCenter(this.target, 0, 0, "Event Detail", "Manage", "Back");
			screen_up = new CreateTitle(this.target, 0, -320, "Title and Message", "Update", "Back", false);
			screen_left = new CreateWhen(this.target, -240, 0, "Date and Time", "Update", "Back", false);
			screen_right = new CreateWho(this.target, 240, 0, "Who's coming?", "Remind", "Back", false, 2);
			screen_down = new CreateWhere(this.target, 0, 320, "Location", "Update", "Back");
			initWhere(false);
		}

		// Data
		showEventData(eventItem);

		isConfirmMode = false;
		isAlertMode = false;
	}
	
	public function getSelectedScreen():Number
	{
		return selected_screen;
	}
	public function isReadOnly():Boolean
	{
		return eventItem.isReadOnly();
	}
	public function getEventStatus():Number
	{
		return eventItem.getEventStatus();
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
		this.target.createscreen.image_center.whoText.text = eventItem.getNumWhoAccepted().toString() + "/" + eventItem.getNumAllGuests().toString();
		
		//where
		this.target.createscreen.image_where.nameText.text = eventItem.getPlaceName();
		this.target.createscreen.image_where.phoneText.text = eventItem.getPhoneNumber();
		this.target.createscreen.image_where.addressText.text = eventItem.getAddress();
	}

	public function onKeyDown()
	{
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

	private function handleEvent_center()
	{
		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				break;
			case ExtendedKey.SOFT2:
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
				screen_right.showGuestList(eventItem);
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
				if (eventItem.isReadOnly() == false)
				{
					updateTitleData();
					showEventData();
					selected_screen = selected_screen - 1;	// go down to 'center'
					move_y();
				}
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
				if (eventItem.isReadOnly() == false)
				{
					updateWhenData();
					screen_left.setFocus(1);
					showEventData();
					selected_screen = selected_screen - 10;	// go to 'center'
					move_x();
				}
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

		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				if (eventItem.isReadOnly() == false)
					openConfirm();
				break;
			case ExtendedKey.SOFT2:
				showEventData();
				selected_screen = selected_screen + 10;	// go to 'center'
				move_x();
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
				// Store location
				if (eventItem.isReadOnly() == false)
				{
//					screen_down.saveSelectedData();
//					updateWhereData();
//					showEventData();
//					// go to 'center'
//					selected_screen = selected_screen + 1;
//					move_y();
					if(screen_down.getMode() == CreateWhere.INFO_MODE)
					{ // Info mode 
						if(screen_down.hasSelectedAddress() && !screen_down._changeSelect)
						{// show list
							screen_down.setMode(CreateWhere.SELECT_MODE);
							screen_down._changeSelect = true;
						}
						else
						{// save and exit
							// Store location
							screen_down.saveSelectedData();
							screen_down._changeSelect = false;
							updateWhereData();
							showEventData();
							// go to 'center'
							selected_screen = selected_screen + 1;
							move_y();
						}
					}
					else
					{ // Select mode - Change to Info mode.
						screen_down.setSelectedAddress();
						screen_down.setMode(CreateWhere.INFO_MODE);
					}
				}
				break;
			case ExtendedKey.SOFT2:
				screen_down._changeSelect = false;
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
				screen_down.handleENTER();
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
	
	private function onKeyDown_ConfirmMode()
	{
		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				closeConfirm();
				if (eventItem.isReadOnly() == false)
					sendReminder();
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
		isConfirmMode = true;
	
		var popup_confirm:MovieClip = this.target.createscreen.attachMovie("Popup_Confirm", "popup_confirm", this.target.createscreen.getNextHighestDepth(), {_x:10+240, _y:110});
		popup_confirm.txtQuestion.text = "Do you want to send a reminder to those who accepted or did not answer yet?";
		popup_confirm.txtAnswer1.text = "YES";
		popup_confirm.txtAnswer2.text = "NO";
		popup_confirm._alpha = 80;
	}
	private function openAlert(msg:String)
	{
		isAlertMode = true;
	
		var popup_alert:MovieClip = this.target.createscreen.attachMovie("Popup_Alert", "popup_alert", this.target.createscreen.getNextHighestDepth(), {_x:10+240, _y:110});
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

	private function sendReminder()
	{
		/*
			TODO: send to server
		*/
		openAlert("Reminder message was sent.");
	}

	private function initWhere(ro:Boolean)
	{
		screen_down.setReadOnly(ro);
		screen_down.enableInfoPane(false);
		screen_down.setWhereData(eventItem.getWhereData());
		screen_down.setMode(CreateWhere.INFO_MODE);
		
		if(!ro)
		{
			screen_down.updateList();
		}
	}
}