import mx.transitions.Tween;
import mx.transitions.easing.None;

class CreateWho extends FoodExScreen
{
	private var readonly:Boolean;
	private var whoMode:Number;			// 1: choose guests    2: see guest status

	private var focus:Number;				// distantFilter(1), contactList(2)
	private var selectedFilter:Number;		// 0(within 1 mile) ~ 4(all)
	private var selectedContact:Number;		// currently focused contact
	private var selectorPosition:Number;	// selector position
	private var contactDepth:Number;		// depth of the first contact
	
	private var arrContacts:Array;		// contacts shown in the list
	private var arrChecked:Array;		// Indices of those who are checked
	private var contactList:MovieClip;	// contact list

	public static var DistanceText:Array = ["within 1 mile", "within 2 miles", "within 5 miles", "within 10 miles", "all"];
	public static var DistanceNum:Array = [1, 2, 5, 10, -1];
	public static var SelectorPosMax:Number = 6;
	
	public function CreateWho(target:MovieClip, x_coor:Number, y_coor:Number, titleText:String, buttonText1:String, buttonText2:String, ro:Boolean, wm:Number)
	{
		initFoodExScreen(target, x_coor, y_coor);
		attachScreen();
		this.setTitleBar(titleText);
		this.setButtons(buttonText1, buttonText2);
		
		arrContacts = new Array();
		arrChecked = new Array();
		setFocus(1);
		selectedFilter = 0;
		selectedContact = 0;
		
		readonly = ro;
		whoMode = wm;
		
		
	}

	private function attachScreen()
	{
		// contents specific to this class
		var middlescreen:MovieClip = this.target.createscreen.attachMovie("BlankScreen", "screen_who", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+50)});
		contactList = this.target.createscreen.attachMovie("ContactList", "contact_list", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+115)});
		var screenImage:MovieClip = this.target.createscreen.attachMovie("C_Who", "image_who", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+50)});
		
		// common contents - specify unique names for each component
		titlebar = this.target.createscreen.attachMovie("FoodExTitle", "title_who", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:ycoor});
		buttons = this.target.createscreen.attachMovie("FoodExButton", "buttons_who", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+290)});

		// button color
		with (this.target.createscreen.buttons_who)
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
	
	public function setFocus(newFocus:Number)
	{
		focus = newFocus;
	}
	public function getFocus():Number
	{
		return focus;
	}
	
	public function getChecked():Array
	{
		return arrChecked;
	}
	
	public function handleUP()
	{
		switch (focus)
		{
			case 1:		// Distance Filter
				filterUp();
				break;
			case 2:		// Contact List
				if (arrContacts.length > 0)
					scrollUpList();
				break;				

		}
	}
	public function handleDOWN()
	{
		switch (focus)
		{
			case 1:		// Distance Filter
				filterDown();
				break;
			case 2:		// Contact List
				if (arrContacts.length > 0)
					scrollDownList();
				break;	
		}
	}
	
	public function handleENTER(eventItem:EventData)
	{
		if (whoMode == 2)
			return;

		if (focus == 1)		// Distance Filter
		{
			selectFilterOption(eventItem);
			setFocus(2);
		}
		else			// Contact List
		{
			if (arrContacts.length > 0)
				checkContact(selectedContact);
		}
	}
	
	private function filterDown()
	{
		if (selectedFilter < 4)
		{
			selectedFilter = selectedFilter + 1;
			var end_y:Number = 5 + selectedFilter*25;
			new Tween(this.target.createscreen.image_who.filter.selector, "_y", None.easeIn, this.target.createscreen.image_who.filter.selector._y, end_y, .2, true);
		}
	}
	private function filterUp()
	{
		if (selectedFilter > 0)
		{
			selectedFilter = selectedFilter - 1;
			var end_y:Number = 5 + selectedFilter*25;
			new Tween(this.target.createscreen.image_who.filter.selector, "_y", None.easeIn, this.target.createscreen.image_who.filter.selector._y, end_y, .2, true);
		}
	}
	private function initFilter()
	{
		selectedFilter = 0;
		this.target.createscreen.image_who.filter.selector._y = 5;
	}
	
	private function selectFilterOption(eventItem:EventData)
	{
		this.target.createscreen.image_who.txtOption.text = DistanceText[selectedFilter];
		new Tween(this.target.createscreen.image_who.filter, "_x", None.easeIn, this.target.createscreen.image_who.filter._x, 35+240, .4, true);
		fillContacts(eventItem);
	}
	
	private function fillContacts(eventItem:EventData)
	{
		arrContacts = eventItem.getContacts(DistanceNum[selectedFilter]);
for (var i:Number=0; i<arrContacts.length; i++)
				trace(arrContacts[i][0] +","+ arrContacts[i][1]+","+ arrContacts[i][2]+","+ arrContacts[i][3]+","+ arrContacts[i][4]);
		
		delete arrChecked;
		arrChecked = new Array();
		
		contactList.background._height = (arrContacts.length < 7)? 175 : arrContacts.length * 25;

		if (arrContacts.length == 0)
		{
			var contact:MovieClip = contactList.attachMovie("Contact", "contact_0", contactList.getNextHighestDepth(), {_x:0, _y:0});
			contact.txtName.text = "None";
			contact.txtDistance.text = "";
			contact.check._alpha = 0;
		}
		else
		{
			for (var i:Number = 0; i < arrContacts.length; i++)
			{
				var moviename:String = "contact_" + i.toString();
				var contact:MovieClip = contactList.attachMovie("Contact", moviename, contactList.getNextHighestDepth(), {_x:0, _y:i*25});
				contact.txtName.text = arrContacts[i][0];
				if (arrContacts[i][2] < 0)
					contact.txtDistance.text = "unknown";
				else
					contact.txtDistance.text = arrContacts[i][2].toString() + "mi.";
				if (arrContacts[i][4] == 0)
				{
					contact.check._alpha = 0;
					arrChecked.push(0);
				}
				else
				{
					contact.check._alpha = 100;
					arrChecked.push(1);
				}
			}
	
		}
		
		// contact selector
		if (arrContacts.length > 0)
		{
			var selector = this.target.createscreen.image_who.attachMovie("ContactSelector", "selector", this.target.createscreen.image_who.getNextHighestDepth(), {_x:0, _y:65});
			selectorPosition = 0;
			selectedContact = 0;
			contactDepth = contactList.contact_0.getDepth();
		}
		
		// scroll bar
		var scroll_bar = this.target.createscreen.image_who.attachMovie("ScrollBar", "scroll_bar", this.target.createscreen.image_who.getNextHighestDepth(), {_x:235, _y:65});
		this.target.createscreen.image_who.scroll_bar._height = (arrContacts.length <= SelectorPosMax+1)? 175 : 175 * (SelectorPosMax+1) / arrContacts.length;
		this.target.createscreen.image_who.scroll_bar._y = 65;
	}
	
	private function checkContact(index:Number)
	{
		var contact:MovieClip = contactList.getInstanceAtDepth(contactDepth + index);
		if (arrChecked[index] == 0)
		{
			contact.check._alpha = 100;
			arrChecked[index] = 1;
		}
		else
		{
			contact.check._alpha = 0;
			arrChecked[index] = 0;
		}
	}

	private function scrollUpList()
	{
		if (selectedContact > 0)
		{
			selectedContact = selectedContact - 1;
			if (selectorPosition <= 0)
			{
				selectorPosition = 0;
				this.target.createscreen.image_who.selector._y = 65 + selectorPosition*25;
				var end_y:Number = ycoor+115 + (selectorPosition-selectedContact)*25;
				new Tween(contactList, "_y", None.easeIn, contactList._y, end_y, .2, true);
				end_y = 65-(selectorPosition-selectedContact)*(this.target.createscreen.image_who.scroll_bar._height/7);
				new Tween(this.target.createscreen.image_who.scroll_bar, "_y", None.easeIn, this.target.createscreen.image_who.scroll_bar._y, end_y, .2, true);
			}
			else
			{
				selectorPosition = selectorPosition - 1;
				var end_y:Number = 65 + selectorPosition*25;
				new Tween(this.target.createscreen.image_who.selector, "_y", None.easeIn, this.target.createscreen.image_who.selector._y, end_y, .2, true);
			}
		}
	}	
	private function scrollDownList()
	{
		if (selectedContact < (arrContacts.length - 1))
		{
			selectedContact = selectedContact + 1;
			if (selectorPosition >= SelectorPosMax)
			{
				selectorPosition = SelectorPosMax;
				this.target.createscreen.image_who.selector._y = 65 + selectorPosition*25;
				var end_y:Number = ycoor + 115 + (selectorPosition-selectedContact)*25;
				new Tween(contactList, "_y", None.easeIn, contactList._y, end_y, .2, true);
				end_y = 65-(selectorPosition-selectedContact)*(this.target.createscreen.image_who.scroll_bar._height/7);
				new Tween(this.target.createscreen.image_who.scroll_bar, "_y", None.easeIn, this.target.createscreen.image_who.scroll_bar._y, end_y, .2, true);
			}
			else
			{
				selectorPosition = selectorPosition + 1;
				var end_y:Number = 65 + selectorPosition*25;
				new Tween(this.target.createscreen.image_who.selector, "_y", None.easeIn, this.target.createscreen.image_who.selector._y, end_y, .2, true);
			}
		}
	}
	
	public function initScreen()
	{
		this.target.createscreen.image_who.filter._x = 35;	// show pop-up for filter option
		setFocus(1);
		
		var depth:Number = contactList.getDepth();
		this.target.createscreen.contact_list.removeMovieClip();
		contactList = this.target.createscreen.attachMovie("ContactList", "contact_list", depth, {_x:xcoor, _y:(ycoor+115)});
		this.target.createscreen.image_who.selector.removeMovieClip();
		this.target.createscreen.image_who.scroll_bar.removeMovieClip();
		
		initFilter();
	}
	
	public function showGuestList(eventItem:EventData)
	{
		setFocus(2);
		this.target.createscreen.image_who.txtOption.text = "Guest list";
		this.target.createscreen.image_who.filter._x = 35+240;
		fillGuestList(eventItem);
	}
	private function fillGuestList(eventItem:EventData)
	{
		arrContacts = eventItem.getContacts(-1);
		delete arrChecked;
		arrChecked = new Array();
		
		contactList.background._height = (arrContacts.length < 7)? 175 : arrContacts.length * 25;

		trace(eventItem);
		trace(arrContacts);
		if (arrContacts.length == 0)
		{
			var contact:MovieClip = contactList.attachMovie("Contact", "contact_0", contactList.getNextHighestDepth(), {_x:0, _y:0});
			contact.txtName.text = "None";
			contact.txtDistance.text = "";
			contact.check._alpha = 0;
		}
		else
		{
			for (var i:Number = 0; i < arrContacts.length; i++)
			{
				var moviename:String = "contact_" + i.toString();
				var contact:MovieClip = contactList.attachMovie("Contact", moviename, contactList.getNextHighestDepth(), {_x:0, _y:i*25});
				contact.txtName.text = arrContacts[i][0];
				contact.txtDistance._width = contact.txtDistance._width + 25;
				if (arrContacts[i][3] == 1)
				{
					var tf:TextFormat = contact.txtDistance.getTextFormat();
					tf.bold = true;
					contact.txtDistance.setTextFormat(tf);
					tf = contact.txtName.getTextFormat();
					tf.bold = true;
					contact.txtName.setTextFormat(tf);
					contact.txtDistance.text = "will come";
					contact.txtDistance.textColor = 0x0000FF;
				}
				else if (arrContacts[i][3] == 2)
				{
					contact.txtDistance.text = "can't come";
					contact.txtDistance.textColor = 0xFF0000;
				}
				else
				{
					contact.txtDistance.text = "didn't answer";
					contact.txtDistance.textColor = 0x000000;
				}
				contact.check._alpha = 0;
			}
	
		}
		
		// contact selector
		if (arrContacts.length > 0)
		{
			var selector = this.target.createscreen.image_who.attachMovie("ContactSelector", "selector", this.target.createscreen.image_who.getNextHighestDepth(), {_x:0, _y:65});
			selectorPosition = 0;
			selectedContact = 0;
			contactDepth = contactList.contact_0.getDepth();
		}
		
		// scroll bar
		var scroll_bar = this.target.createscreen.image_who.attachMovie("ScrollBar", "scroll_bar", this.target.createscreen.image_who.getNextHighestDepth(), {_x:235, _y:65});
		this.target.createscreen.image_who.scroll_bar._height = (arrContacts.length <= SelectorPosMax+1)? 175 : 175 * (SelectorPosMax+1) / arrContacts.length;
		this.target.createscreen.image_who.scroll_bar._y = 65;
	}
	

};
