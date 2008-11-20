import mx.transitions.Tween;
import mx.transitions.easing.None;

class MainScreen extends FoodExScreen
{
	public function MainScreen(target:MovieClip, x_coor:Number, y_coor:Number, titleText:String, buttonText1:String, buttonText2:String)
	{
		initFoodExScreen(target, x_coor, y_coor);
		attachScreen();
		this.setTitleBar(titleText);
		this.setButtons(buttonText1, buttonText2);
	}
	
	private function attachScreen()
	{
		// common contents - specify unique names for each component
		titlebar = this.target.mainscreen.attachMovie("FoodExTitle", "title_main", this.target.mainscreen.getNextHighestDepth(), {_x:xcoor, _y:ycoor});
		buttons = this.target.mainscreen.attachMovie("FoodExButton", "buttons_center", this.target.mainscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+290)});

		// contents specific to this class
		var middlescreen:MovieClip = this.target.mainscreen.attachMovie("XScreen", "screen_center", this.target.mainscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+50)});
		var screenImage:MovieClip = this.target.mainscreen.attachMovie("Main_Screen", "image_center", this.target.mainscreen.getNextHighestDepth(), {_x:xcoor, _y:(ycoor+60)});

		// button color
		with (this.target.mainscreen.buttons_center)
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