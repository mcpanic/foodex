import mx.transitions.Tween;
import mx.transitions.easing.None;

class FoodExScreen
{
	private var target:MovieClip;
	private var button1:MovieClip;
	private var button2:MovieClip;
	private var titlebar:MovieClip;
	private var middlescreen:MovieClip;
	
	public function FoodExScreen(target:MovieClip, color1:Number, color2:Number)
	{
		this.target = target;
		this.target.createEmptyMovieClip("screen", 5);
		
		setTitleBar();
		setButtons(color1, color2);
		setMiddleScreen();

		Key.addListener(this);
		initIndicators();
	}
	
	private function setTitleBar()
	{
		titlebar = this.target.screen.attachMovie("FoodExTitle", "title", this.target.screen.getNextHighestDepth(), {_x:0, _y:0});
		titlebar.title.text = "Welcome to FoodEx";
	}

	private function setButtons(color1:Number, color2:Number)
	{
		button1 = this.target.screen.attachMovie("FoodExButton", "button_1", this.target.screen.getNextHighestDepth(), {_x:0, _y:290});
		button1.title.text = "";
		with (this.target.screen.button_1)
		{
			colors = [0xFFFFFF, color1];
			fillType = "linear"
			alphas = [100, 100];
			ratios = [0, 0xFF];
			matrix = {matrixType:"box", x:0, y:0, w:120, h:30, r:(90/180)*Math.PI};
			beginGradientFill(fillType, colors, alphas, ratios, matrix);
			moveTo(0, 0);
			lineTo(0, 30);
			lineTo(120, 30);
			lineTo(120, 0);
			lineTo(0, 0);
			endFill();
		}

		button2 = this.target.screen.attachMovie("FoodExButton", "button_2", this.target.screen.getNextHighestDepth(), {_x:120, _y:290});
		button2.title.text = "Quit";
		with (this.target.screen.button_2)
		{
			colors = [0xFFFFFF, color2];
			fillType = "linear"
			alphas = [100, 100];
			ratios = [0, 0xFF];
			matrix = {matrixType:"box", x:0, y:0, w:120, h:30, r:(90/180)*Math.PI};
			beginGradientFill(fillType, colors, alphas, ratios, matrix);
			moveTo(0, 0);
			lineTo(0, 30);
			lineTo(120, 30);
			lineTo(120, 0);
			lineTo(0, 0);
			endFill();
		}
	}

	private function setMiddleScreen()
	{
		middlescreen = this.target.screen.attachMovie("XScreen", "mid_screen", this.target.screen.getNextHighestDepth(), {_x:0, _y:50});
		var up:MovieClip = this.target.screen.attachMovie("MainScreen_Up", "up_screen", this.target.screen.getNextHighestDepth(), {_x:75, _y:60});
		var left:MovieClip = this.target.screen.attachMovie("MainScreen_Left", "left_screen", this.target.screen.getNextHighestDepth(), {_x:5, _y:110});
		var right:MovieClip = this.target.screen.attachMovie("MainScreen_Right", "right_screen", this.target.screen.getNextHighestDepth(), {_x:160, _y:140});
		var down:MovieClip = this.target.screen.attachMovie("MainScreen_Down", "down_screen", this.target.screen.getNextHighestDepth(), {_x:65, _y:230});
	}
	
	private function initIndicators()
	{
		button1.highlight._alpha = 0;
		button2.highlight._alpha = 0;
		middlescreen.Tri_Up.highlight_tri._alpha = 0;
		middlescreen.Tri_Left.highlight_tri._alpha = 0;
		middlescreen.Tri_Right.highlight_tri._alpha = 0;
		middlescreen.Tri_Down.highlight_tri._alpha = 0;
	}
	
	public function onKeyDown()
	{
		trace("keycode: " + Key.getCode());
		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				break;
			case ExtendedKey.SOFT2:
				fscommand2("Quit");
				break;
			case Key.UP:
				gotoAndStop("Create");
				Key.removeListener(this);
				break;
			case Key.LEFT:
				flashIndicator(middlescreen.Tri_Left.highlight_tri);
				break;
			case Key.RIGHT:
				flashIndicator(middlescreen.Tri_Right.highlight_tri);
				break;
			case Key.DOWN:
				break;
		}
	}

	private function flashIndicator(toFlash:MovieClip)
	{
		new Tween(toFlash, "_alpha", None.easeIn, 100, 0, .7, true);
	}
}