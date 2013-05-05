/**
 * @author milkmidi
 */
package {
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.GeolocationEvent;
	import flash.events.IOErrorEvent;
	import flash.events.StatusEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.sensors.Geolocation;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

		
	public class mapClass extends Sprite	{
		// 顯示訊息
		private var _msgTF		:TextField;		
		// 定位
		private var _location	:Geolocation;		
		// 顯示 GoogleMap 
		private var _myWebView	:StageWebView;		
		// 載入單張的 GoogleMap 圖檔
		private var _loader		:Loader;
		private var locString	:String
		
		private var urlReq:URLRequest=new URLRequest();
		public function mapClass() {
			
			
			if(stage)
			{ 
				init()  
			}else
			{
				addEventListener(Event.ADDED_TO_STAGE,init);
			}
			
		}		
		
		
		public function init(e:Event=null):void{
			
//			stage.align =  "tl";
//			stage.scaleMode = "noScale";
			// 載入單張 GoogleMap 圖片用
			_loader = new Loader();			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onMapResponseHandler);					
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);								
			/*
			顯示用的文字
			建立物件同時加到場景上, 可以這樣寫
			var _msgTF = new TextField();
			addChild( _msgTF );
			
			縮寫
			addChild( _msgTF = new TextField );			
			在 ActionScript3.0 , 如果建構函式沒有要帶參數的話
			後面的小刮號可以省略
			*/			
			addChild( _msgTF = new TextField );						
			_msgTF.defaultTextFormat = new TextFormat( null , 22 );
			_msgTF.multiline = true;
//			_msgTF.text= "Hello Geolocation"
			_msgTF.autoSize = TextFieldAutoSize.LEFT;			
			_msgTF.mouseEnabled = false;
			
			// 判斷裝置是否支援
			if (Geolocation.isSupported){
				// 建立 Geolocation 物件				
				_location = new Geolocation();
//				showMessage("Geolocation supported. isMuted:" + _location.muted);	
				
				// 偵聽當 GPS 更新事件
				_location.addEventListener(GeolocationEvent.UPDATE, onGeoUpdateHandler);
				
				// 判斷裝置是否開啟 GPS 功能
				if (!_location.muted)	{				
					
					// 偵聽使用者是否開啟 GPS 事件
					_location.addEventListener(StatusEvent.STATUS, onGeoStatusHandler);					
					// 更新的時間間隔，以毫秒為單位。
					_location.setRequestedUpdateInterval(3000);						
				}
				else {
					showMessage("請開啟您的 GPS");
				}
			}
			else {
				showMessage("您的裝置不支援 Geolocation" );
			}
			
		}
		
		
		private function onGeoStatusHandler(e:StatusEvent):void {
//			showMessage("Geolocation isMuted:" + _location.muted);			
		}			
		// 把所有的資訊取出
		private function onGeoUpdateHandler(e:GeolocationEvent):void {			
			/*_msgTF.text = "Geolocation" +
			  "\n  latitude 緯度: " + e.latitude + "\u00B0" +
			  "\n  longitude 經度: " + e.longitude + "\u00B0" +
			  "\n  horizontalAccuracy 垂直精確度: " + e.horizontalAccuracy + " m" +
			  "\n  verticalAccuracy 水平精確度: " + e.verticalAccuracy + " m" +
			  "\n  speed 速度: " + e.speed + " m/s" +
			  "\n  altitude 高度: " + e.altitude + " m" +
			  "\n  timestamp 經過的亳秒數: " + e.timestamp + " ms"*/;			
			
			var lat:Number = e.latitude;
			var lng:Number = e.longitude;			
			
			// 測試用的台北車站經緯度
			//lat = 25.047924;
			//lng = 121.51708099999996;
			//
			// 依經緯度所在位置, 載入單張 GoogleMap 圖片
			loadSingleGoogleMapImage( lat , lng );
			  
			// 依經緯度所在位置, 顯示在 GoogleMap 上
			//loadGoogleMapByStageWebView( lat , lng );
			
			// 依經緯度所在位置, 找出目前大略的地址
			getAddress( lat, lng );			
		}			
		/**
		 * 參考文件
		 * https://developers.google.com/maps/documentation/staticmaps/?hl=zh-tw
		 * @param	lat
		 * @param	lng
		 */			  
		private function loadSingleGoogleMapImage(lat:Number, lng:Number):void {
			// 載入單張的 GoogleMap 地圖
			// 顯示 markers 
			var markers		:String = "&markers=color:blue|label:M|" + lat + ", " + lng;
			// 載入的圖片放大 2 倍
			var scale		:int = 2;
			// 載入的圖片大小, 本來要取裝置一寬與一半的高, 因為 scale 設成 2
			// 所以大小就再除以 2
			var size		:String =int(1632/2) + "x" + int(816/2);
				//int(stage.stageWidth/2) + "x" + int(stage.stageHeight/2); 
				//int(stage.stageWidth  / scale) + "x" + int(stage.stageHeight / (scale * 2));
			var API_console_key:String="AIzaSyAGnpXz3ZxRwEnrYYSg7Xk2NiJ9Lh2Dgp4"
				
			locString = "http://maps.google.com/maps/api/staticmap?center=" 
				+ lat + ", " + lng 
				+ "&zoom=14&size=" + size + "&scale="+scale 
				+ markers+"&sensor=true&language=zh-tw&key="+API_console_key;
			urlReq.url=locString
			_loader.load(urlReq)
		}
		
		
		//Loader 載入單張 GoogleMap 圖片成功的處理函式
		private function onMapResponseHandler(e:Event):void {
			
//			_loader.x=150
//			_loader.y=100
				
			_loader.alpha=.3
			addChild( _loader );
			//_loader.y = stage.stageHeight >> 1;
		}		
		
			
		// 呼叫 GoogleMap API, 把經緯度傳進去, 就會回傳大略的地址, 回傳的格式為 JSON
		private function getAddress(lat:Number , lng:Number):void {		
			var url:String = "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + lat + "," + lng + "&sensor=false&language=zh-tw";
			// 使用 URLLoader 載入
			var ldr:URLLoader = new URLLoader();
			ldr.load( new URLRequest( url ));
			// 偵聽完成事件
			ldr.addEventListener(Event.COMPLETE , onLoaderCompleteHandler);
			ldr.addEventListener(IOErrorEvent.IO_ERROR , onErrorHandler);
			
		}		
		private function onErrorHandler(e:IOErrorEvent):void {
			showMessage(e.toString());
			trace(e.toString())
		}		
		private function onLoaderCompleteHandler(e:Event):void {
			var json:Object = JSON.parse( e.currentTarget.data );
			if (json.status == "OK") {				
//				showMessage("您所在的地址是：\n" + json.results[0].formatted_address);								
			}else {
//				showMessage( json.status );
			}		
		}		
		// 將訊息輸出到文字上	
		private function showMessage(msg:String):void{
			_msgTF.appendText( '\n'+msg);			
		}	
	} 
} 