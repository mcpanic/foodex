class TitleData
{
	private var strTitle:String;
	private var strMessage:String;

	public function TitleData()
	{
		strTitle = "";
		strMessage = "";
	}
	
	public function getTitle():String
	{
		return strTitle;
	}
	public function getMessage():String
	{
		return strMessage;
	}
	
	public function setTitle(title:String)
	{
		this.strTitle = title;
	}
	public function setMessage(message:String)
	{
		this.strMessage = message;
	}
};