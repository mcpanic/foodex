import mx.transitions.Tween;
import mx.transitions.easing.None;

class CreateTitle extends FoodExScreen
{
	private var isSelecting:Boolean;
	private var selectedTitle:Number;
	public static var TitleText:Array = ["", "Let's get together!", "Lunch today?", "Dinner tonight?", "Drink, drink, drink...", "Aren't you hungry?"];

	public function CreateTitle(target:MovieClip, x_coor:Number, y_coor:Number, titleText:String, buttonText1:String, buttonText2:String, readonly:Boolean, isCreating:Boolean)
	{
		initFoodExScreen(target, x_coor, y_coor);
		attachScreen();
		this.setTitleBar(titleText);
		this.setButtons(buttonText1, buttonText2);

		this.target.createscreen.image_title.txtTitle.tabEnabled = isCreating;
		this.target.createscreen.image_title.txtMessage.tabEnabled = !readonly;

		isSelecting = false;
		selectedTitle = 0;

		if (isCreating)
			showTitleSelector();
	}
	
	private function attachScreen()
	{
		// common contents - specify unique names for each component
		titlebar = this.target.createscreen.attachMovie("FoodExTitle", "title_title", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:ycoor});
		buttons = this.target.createscreen.attachMovie("FoodExButton", "buttons_title", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+290)});

		// contents specific to this class
		var middlescreen:MovieClip = this.target.createscreen.attachMovie("BlankScreen", "screen_title", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+50)});
		var screenImage:MovieClip = this.target.createscreen.attachMovie("C_Title", "image_title", this.target.createscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+60)});

		// button color
		with (this.target.createscreen.buttons_title)
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

	private function showTitleSelector()
	{
		isSelecting = true;
		this.target.createscreen.image_title.txtTitle.type = "dynamic";
		this.target.createscreen.image_title.txtMessage.type = "dynamic";
		
		var titleList:MovieClip = this.target.createscreen.image_title.attachMovie("TitleList", "title_list", this.target.createscreen.image_title.getNextHighestDepth(), {_x:50, _y:0});
		selectedTitle = 1;
	}
	
	public function handleUP()
	{
		if (isSelecting)
			selectorUp();
	}
	public function handleDOWN()
	{
		if (isSelecting)
			selectorDown();
	}
	public function handleENTER()
	{
		if (isSelecting)
			selectTitle();
	}
	private function selectorUp()
	{
		if (selectedTitle > 0)
		{
			selectedTitle = selectedTitle - 1;
			var end_y:Number = 5 + selectedTitle*20;
			new Tween(this.target.createscreen.image_title.title_list.selector, "_y", None.easeIn, this.target.createscreen.image_title.title_list.selector._y, end_y, .2, true);
		}
	}
	private function selectorDown()
	{
		if (selectedTitle < 5)
		{
			selectedTitle = selectedTitle + 1;
			var end_y:Number = 5 + selectedTitle*20;
			new Tween(this.target.createscreen.image_title.title_list.selector, "_y", None.easeIn, this.target.createscreen.image_title.title_list.selector._y, end_y, .2, true);
		}
	}
	private function selectTitle()
	{
		isSelecting = false;
		this.target.createscreen.image_title.txtTitle.text = TitleText[selectedTitle];
		this.target.createscreen.image_title.txtTitle.type = "input";
		this.target.createscreen.image_title.title_list.removeMovieClip();
		this.target.createscreen.image_title.txtMessage.type = "input";
	}
}