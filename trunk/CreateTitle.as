import mx.transitions.Tween;
import mx.transitions.easing.None;

class CreateTitle extends FoodExScreen
{
	public function CreateTitle(target:MovieClip, x_coor:Number, y_coor:Number, titleText:String, buttonText1:String, buttonText2:String, readonly:Boolean)
	{
		initFoodExScreen(target, x_coor, y_coor);
		attachScreen();
		this.setTitleBar(titleText);
		this.setButtons(buttonText1, buttonText2);
		
		this.target.createscreen.image_title.txtTitle.tabEnabled = !readonly;
		this.target.createscreen.image_title.txtMessage.tabEnabled = !readonly;
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
}