import mx.transitions.Tween;
import mx.transitions.easing.None;

class FoodExMain extends MovieClip
{
	private var target:MovieClip;
	
	private var screen_center:MainScreen;
	
	public function FoodExMain(target:MovieClip)
	{
		this.target = target;
		this.target.createEmptyMovieClip("mainscreen", 5);
		
		screen_center = new MainScreen(this.target, 0, 0, "Welcome to FoodEx", "", "Quit");
		Key.addListener(this);
	}
	
	public function onKeyDown()
	{
		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				break;
			case ExtendedKey.SOFT2:
				fscommand2("Quit");
				break;
			case Key.UP:			
				this.target.gotoAndStop("Create");
				Key.removeListener(this);
				break;
			case Key.LEFT:
				this.target.gotoAndStop("Manage");
				Key.removeListener(this);
				break;
			case Key.RIGHT:
				this.target.gotoAndStop("Credit");
				Key.removeListener(this);
				break;
			case Key.DOWN:
				break;
		}
	}
	
	

			
}