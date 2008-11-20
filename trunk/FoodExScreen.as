import mx.transitions.Tween;
import mx.transitions.easing.None;

class FoodExScreen
{
	private var target:MovieClip;
	public var buttons:MovieClip;
	public var titlebar:MovieClip;

	public var xcoor:Number;
	public var ycoor:Number;
	
	public function FoodExScreen(target:MovieClip, x_coor:Number, y_coor:Number)
	{
		initFoodExScreen(target, x_coor, y_coor);
	}

	private function initFoodExScreen(target:MovieClip, x_coor:Number, y_coor:Number)
	{
		this.target = target;
		xcoor = x_coor;
		ycoor = y_coor;
	}
			
	public function setTitleBar(titleText:String)
	{
		titlebar.title.text = titleText;
	}

	public function setButtons(buttonText1:String, buttonText2:String)
	{
		buttons.text1.text = buttonText1;
		buttons.text2.text = buttonText2;
	}
}