class FoodExCredit extends MovieClip
{
	private var target:MovieClip;
	
	private var screen_center:CreditScreen;
	
	public function FoodExCredit(target:MovieClip)
	{
		this.target = target;
		this.target.createEmptyMovieClip("creditscreen", 5);
		
		screen_center = new CreditScreen(this.target, 0, 0, "Credit", "", "Back");

		Key.addListener(this);
	}

	public function onKeyDown()
	{
		switch (Key.getCode())
		{
			case ExtendedKey.SOFT1:
				break;
			case ExtendedKey.SOFT2:
				this.target.gotoAndStop("Home");
				Key.removeListener(this);
				break;
			case Key.UP:
				break;
			case Key.LEFT:
				break;
			case Key.RIGHT:
				break;
			case Key.DOWN:
				break;
		}
	}
}