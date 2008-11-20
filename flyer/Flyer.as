/**
Flyer - Python Framework for Flash Lite developers.
Copyright (C) 2007  Felipe Andrade
Modified by Steve Marmon, Stanford University, Sept 2008

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

import mx.utils.Delegate;
import mx.events.EventDispatcher;

/**
  Flyer class
  Version 1.0.4
  Copyright (C) 2007  Felipe Andrade
  Modified by Steve Marmon on 10/03/2008
*/
class flyer.Flyer extends EventDispatcher {
	//GRAPHICS
	private static var TAKEPHOTO_GR:String = "takePhoto";
	private static var TAKESCREENSHOT_GR:String = "takeScreenshot";
	
	// SOUND
	private static var RECORD_SOUND:String = "recordSound";
	private static var PLAY_SOUND:String = "playSound";
	private static var STOP_SOUND:String = "stopSound";
	private static var SAY_SOUND:String = "sayText";
	
	// NETWORK (FTP, BLUETOOTH, ETC.)
	private static var SENDFILE_BLUETOOTH:String = "sendFileBT";
	private static var SHAREDATA_BLUETOOTH:String = "shareDataBT";
	
	// DATABASE
	private static var DEFAULT_DB:String = "getContacts";
	private static var CREATE_DB:String = "createDatabase";
	private static var CREATEFIELD_BD:String = "createField";
	private static var UPDATEFIELD_DB:String = "updateField";
	private static var DELFIELD_DB:String = "deleteField";
	private static var LIST_DB:String = "listDatabase";
	
	// FLASH OBJECTS (FLV, SWF, ETC.)
	private static var SWF_FLASH:String = "generateSWF";
	private static var FLV_FLASH:String = "generateFLV";
	
	// GPS
	private static var GET_GPS_COORDINATES:String = "getGPSCoordinates";
	
	private var host_str:String;
	private var port_num:Number;
	private var flyerSocket_xmls:XMLSocket;
	private var isConnected_bool:Boolean = false;
	
	/**
	  	Flyer(host_str:String, port_num:Number)
	  	@host_str: server host
		@port_num: port number (>1024 because the know well ports)
		
		Constructor
	*/
	public function Flyer(host_str:String, port_num:Number) {
		this.host_str = host_str;
		this.port_num = port_num;
		
		this.flyerSocket_xmls = new XMLSocket();
	}
	
	/**
	  	connect():Void	  			
		Connects to python local socket server
	*/
	public function connect():Void {		
		this.flyerSocket_xmls.connect(this.host_str, this.port_num);
		this.flyerSocket_xmls.onConnect = Delegate.create(this, onConnect);
		this.flyerSocket_xmls.onClose = Delegate.create(this, onClose);
	}
	
	public function onConnect(success_bool:Boolean):Void {
		setStatus(true);
		dispatchEvent({type: "onFlyerConnect", status:success_bool});
	}
	
	public function onPhotoData(data_str:String):Void {
		dispatchEvent({type: "onPhotoData", data:data_str});
	}
	
	public function onScreenshotData(data_str:String):Void {
		dispatchEvent({type: "onScreenshotData", data:data_str});
	}
	
	public function onBluetoothData(data_str:String):Void {
		dispatchEvent({type: "onBluetoothData", data:data_str});
	}
	
	public function onPlaySoundData(data_str:String):Void {
		dispatchEvent({type: "onPlaySoundData", data:data_str});
	}
	
	public function onRecordSoundData(data_str:String):Void {
		dispatchEvent({type: "onRecordSoundData", data:data_str});
	}
	
	public function onStopSoundData(data_str:String):Void {
		dispatchEvent({type: "onStopSoundData", data:data_str});
	}
	
	public function onSayData(data_str:String):Void {
		dispatchEvent({type: "onSayData", data:data_str});
	}
	
	public function onContactsData(data_str:String):Void {
		dispatchEvent({type: "onContactsData", data:data_str});
	}
	
	public function onCoordinatesData(data_str:String):Void {
		dispatchEvent({type: "onCoordinatesData", data:data_str});
	}
	
	/**
	  	onClose():Void	  	
	  	Invoked when the server is closed
	*/
	public function onClose():Void {
		setStatus(false);
		dispatchEvent({type: "onFlyerClose"})
	}
	
	/**
	  	takePhoto(filePath:String):Void
		@filePath_str: path to file
	  	Takes photo from device camera	  	
	*/
	public function takePhoto(filePath:String):Void {
		this.flyerSocket_xmls.send(Flyer.TAKEPHOTO_GR + "|" + filePath);
		this.flyerSocket_xmls.onData = Delegate.create(this, onPhotoData);
	}
	
	/**
		takeScreenshot(filePath_str:String):Void
		@filePath_str: path to file
	  	Takes screenshot from device screen	  	
	*/
	public function takeScreenshot(filePath_str:String):Void {
		this.flyerSocket_xmls.send(Flyer.TAKESCREENSHOT_GR + "|" + filePath_str);
		this.flyerSocket_xmls.onData = Delegate.create(this, onScreenshotData);
	}
	
	/**
		sendFileBT(filePath_str:String):Void
		@filePath_str: path to file
	  	Sends a file over a bluetooth connection	  	
	*/
	public function sendFileBT(filePath_str:String):Void {
		this.flyerSocket_xmls.send(Flyer.SENDFILE_BLUETOOTH + "|" + filePath_str);
		this.flyerSocket_xmls.onData = Delegate.create(this, onBluetoothData);		
	}
	
	/**
	  	playSound(filePath_str:String):Void
	  	@filePath_str: path to file
	  	Plays sound from the specified filepath	  
	*/
	public function playSound(filePath_str:String):Void {
		this.flyerSocket_xmls.send(Flyer.PLAY_SOUND + "|" + filePath_str);
		this.flyerSocket_xmls.onData = Delegate.create(this, onPlaySoundData);		
	}
	
	/**
		stopSound():Void
	  	Stops sound
	*/
	public function stopSound():Void {
		this.flyerSocket_xmls.send(Flyer.STOP_SOUND + "|undefined");
		this.flyerSocket_xmls.onData = Delegate.create(this, onStopSoundData);		
	}
	
	/**
		recordSound(filePath_str:String):Void
		@filePath_str: path to file 
	  	Records sound as WAV.  	
	*/
	public function recordSound(filePath_str:String):Void {
		this.flyerSocket_xmls.send(Flyer.RECORD_SOUND + "|" + filePath_str);
		this.flyerSocket_xmls.onData = Delegate.create(this, onRecordSoundData);		
	}
	
	/**
		sayText(sentence_str:String):Void
		@sentence: text to speech
	  	Convets text to speech	  	
	*/
	public function sayText(sentence_str:String):Void {
		this.flyerSocket_xmls.send(Flyer.SAY_SOUND + "|" + sentence_str);
		this.flyerSocket_xmls.onData = Delegate.create(this, onSayData);		
	}
	
	/**
	  	getContacts():Void
		Gets contacts from default database.	  
	*/
	public function getContacts():Void {
		this.flyerSocket_xmls.send(Flyer.DEFAULT_DB + "|undefined");
		this.flyerSocket_xmls.onData = Delegate.create(this, onContactsData);		
	}
	
	/**
	  	setStatus(status_bool:Boolean):Void
		@status: boolean value that indicates the status of application
		Sets status of application	  
	*/
	public function setStatus(status_bool:Boolean):Void {
		this.isConnected_bool = status_bool;
	}
	
	/**
	  	getStatus():Boolean		
		Gets status of application	  
	*/
	public function getStatus():Boolean {
		return this.isConnected_bool;
	}	
	
	/**
	  	getGPSCoordinates():String		
		Gets the GPS coordinates as a string in the format "Lat,Long" 
	*/
	public function getGPSCoordinates():Void {
		this.flyerSocket_xmls.send(Flyer.GET_GPS_COORDINATES + "|undefined");
		this.flyerSocket_xmls.onData = Delegate.create(this, onCoordinatesData);		
	}	
}