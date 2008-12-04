import mx.transitions.Tween;
import mx.transitions.easing.None;

class CreateWhen extends FoodExScreen
{
	private var readonly:Boolean;

	private var focus:Number;			// date(1), hour(2), minute(3), am/pm(4)
	private var selectedDate:Number;	// 0(today) ~ 4(4 days from today)
	private var selectedHour:Number;	// 0(01) ~ 11(12)
	private var selectedMinute:Number;	// 0(00) ~ 5(50)
	private var selectedAMPM:Number;	// 0(AM) or 1(PM)
	
	private var hourSelector:MovieClip;
	private var minuteSelector:MovieClip;
	private var ampmSelector:MovieClip;
	
	public static var DateText:Array = ["Today", "Tomorrow", "2 days from today", "3 days from today", "4 days from today"];
	
	private var DateSelection:MovieClip;
	
	public function CreateWhen(target:MovieClip, x_coor:Number, y_coor:Number, titleText:String, buttonText1:String, buttonText2:String, ro:Boolean)
	{
		initFoodExScreen(target, x_coor, y_coor);
		attachScreen();
		this.setTitleBar(titleText);
		this.setButtons(buttonText1, buttonText2);
		
		readonly = ro;
		this.target.createscreen.image_when.focus_arrow._visible = !readonly;
		this.target.createscreen.image_when.inst._visible = !readonly;
		
		setFocus(1);
	}
	
	private function attachScreen()
	{
		// contents specific to this class
		var middlescreen:MovieClip = this.target.createscreen.attachMovie("BlankScreen", "screen_when", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+50)});
		hourSelector = this.target.createscreen.attachMovie("HourSelector", "hour_selector", this.target.createscreen.getNextHighestDepth(), {_x:(xcoor+40), _y:(ycoor+190)});
		minuteSelector = this.target.createscreen.attachMovie("MinuteSelector", "minute_selector", this.target.createscreen.getNextHighestDepth(), {_x:(xcoor+100), _y:(ycoor+190)});
		ampmSelector = this.target.createscreen.attachMovie("AMPMSelector", "ampm_selector", this.target.createscreen.getNextHighestDepth(), {_x:(xcoor+160), _y:(ycoor+190)});
		var screenImage:MovieClip = this.target.createscreen.attachMovie("C_When", "image_when", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+50)});
		
		// common contents - specify unique names for each component
		titlebar = this.target.createscreen.attachMovie("FoodExTitle", "title_when", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:ycoor});
		buttons = this.target.createscreen.attachMovie("FoodExButton", "buttons_when", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+290)});

		// button color
		with (this.target.createscreen.buttons_when)
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
	
	public function getDateDiff():Number
	{
		return selectedDate;
	}
	public function getHour():Number
	{
		var hour:Number = (selectedHour + 1) % 12;		// 0~11
		if (selectedAMPM == 1)
			hour = hour + 12;					// 1~24
		return hour;
	}
	public function getMinute():Number
	{
		return selectedMinute*10;
	}
	
	public function setFocus(newFocus:Number)
	{
		focus = newFocus;
		switch (focus)
		{
			case 1:		// Date
				this.target.createscreen.image_when.focus_arrow._x = 100;
				this.target.createscreen.image_when.focus_arrow._y = 26;
				break;
			case 2:		// Hour
				this.target.createscreen.image_when.focus_arrow._x = 45;
				this.target.createscreen.image_when.focus_arrow._y = 116;
				break;
			case 3:		// Minute
				this.target.createscreen.image_when.focus_arrow._x = 105;
				this.target.createscreen.image_when.focus_arrow._y = 116;
				break;
			case 4:		// AM/PM
				this.target.createscreen.image_when.focus_arrow._x = 165;
				this.target.createscreen.image_when.focus_arrow._y = 116;
				break;
		}
	}
	public function setSelectedDateTime(dateTime:Date)
	{
		var today:Date = new Date();
		today.setHours(0, 0, 0, 0);
		var dayDiff:Number = int((dateTime.getTime() - today.getTime())/(24*60*60*1000));

		// date
		selectedDate = dayDiff;
		this.target.createscreen.image_when.txtDate.text = DateText[dayDiff];
		
		// time
		selectedAMPM = (dateTime.getHours()<12)? 0:1;
		selectedHour = dateTime.getHours()%12 - 1;
		if (selectedHour == -1)
			selectedHour = 11;
		selectedMinute = int(dateTime.getMinutes() / 10);
		this.target.createscreen.hour_selector._y = ycoor + 190 - selectedHour*25;
		this.target.createscreen.minute_selector._y = ycoor + 190 - selectedMinute*25;
		this.target.createscreen.ampm_selector._y = ycoor + 190 - selectedAMPM*25;

	}
	
	public function handleUP()
	{
		if (readonly == true)
			return;

		switch (focus)
		{
			case 1:		// Date
				increaseDate();
				break;
			case 2:		// Hour
				increaseHour();
				break;
			case 3:		// Minute
				increaseMinute();
				break;
			case 4:		// AM/PM
				toggleAMPM();
				break;
		}
	}
	public function handleDOWN()
	{
		if (readonly == true)
			return;

		switch (focus)
		{
			case 1:		// Date
				decreaseDate();
				break;
			case 2:		// Hour
				decreaseHour();
				break;
			case 3:		// Minute
				decreaseMinute();
				break;
			case 4:		// AM/PM
				toggleAMPM();
				break;
		}
	}
	
	public function handleENTER()
	{
		if (readonly == true)
			return;

		// move focus
		if (focus < 4)
			setFocus(focus + 1);
		else
			setFocus(1);
	}
	public function handleLEFT()
	{
		if (readonly == true)
			return;

		// move focus
		if (focus > 1)
			setFocus(focus - 1);
		else
			setFocus(4);
	}
	public function handleRIGHT()
	{
		if (readonly == true)
			return;

		// move focus
		if (focus < 4)
			setFocus(focus + 1);
		else
			setFocus(1);
	}
	
	private function increaseDate()
	{
		if (selectedDate < 4)
			selectedDate = selectedDate + 1;
		else
			selectedDate = 0;
		this.target.createscreen.image_when.txtDate.text = DateText[selectedDate];
	}
	private function decreaseDate()
	{
		if (selectedDate > 0)
			selectedDate = selectedDate - 1;
		else
			selectedDate = 4;
		this.target.createscreen.image_when.txtDate.text = DateText[selectedDate];
	}
	private function increaseHour()
	{
		if (selectedHour < 11)
			selectedHour = selectedHour + 1;
		else
			selectedHour = 0;
		var end_y:Number = ycoor + 190 - selectedHour*25;
		new Tween(this.target.createscreen.hour_selector, "_y", None.easeIn, this.target.createscreen.hour_selector._y, end_y, .2, true);
	}
	private function decreaseHour()
	{
		if (selectedHour > 0)
			selectedHour = selectedHour - 1;
		else
			selectedHour = 11;
		var end_y:Number = ycoor + 190 - selectedHour*25;
		new Tween(this.target.createscreen.hour_selector, "_y", None.easeIn, this.target.createscreen.hour_selector._y, end_y, .2, true);
	}
	private function increaseMinute()
	{
		if (selectedMinute < 5)
			selectedMinute = selectedMinute + 1;
		else
			selectedMinute = 0;
		var end_y:Number = ycoor + 190 - selectedMinute*25;
		new Tween(this.target.createscreen.minute_selector, "_y", None.easeIn, this.target.createscreen.minute_selector._y, end_y, .2, true);
	}
	private function decreaseMinute()
	{
		if (selectedMinute > 0)
			selectedMinute = selectedMinute - 1;
		else
			selectedMinute = 5;
		var end_y:Number = ycoor + 190 - selectedMinute*25;
		new Tween(this.target.createscreen.minute_selector, "_y", None.easeIn, this.target.createscreen.minute_selector._y, end_y, .2, true);
	}
	private function toggleAMPM()
	{
		selectedAMPM = (selectedAMPM + 1) % 2;
		var end_y:Number = ycoor + 190 - selectedAMPM*25;
		new Tween(this.target.createscreen.ampm_selector, "_y", None.easeIn, this.target.createscreen.ampm_selector._y, end_y, .2, true);
	}
}