package
{
	import com.bit101.components.Label;
	import com.bit101.components.Slider;
	import com.gskinner.geom.ColorMatrix;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.CameraRoll;
	import flash.media.Video;
	import flash.ui.Mouse;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import caurina.transitions.Tweener;
	
	import net.hires.debug.Stats;
	
	import uk.co.soulwire.cv.MotionTracker;

//	import com.adobe.nativeExtensions.maps.overlays.Marker;


	/**
	 * MotionTrackerDemo
	 */
	//1136,640------460,300
//		[SWF(width="1136", height="640", backgroundColor="#FFFFFF", frameRate="31")]
//	[SWF(width="568", height="320", backgroundColor="#FFFFFF", frameRate="24")]
//	[SWF(width="1632", height="1224", backgroundColor="#FFFFFF", frameRate="31")]
	[SWF(width="1632", height="816", backgroundColor="#FFFFFF", frameRate="31")]
	
	public class Main extends Sprite
	{

		//	----------------------------------------------------------------
		//	PRIVAYE MEMBERS
		//	----------------------------------------------------------------

		private var _motionTracker:MotionTracker;

		private var _target:Shape;
		private var _bounds:Shape;
		private var _output:Bitmap;
		private var _source:Bitmap;
		private var _video:BitmapData;
		private var _matrix:ColorMatrix;

		private var _blurLabel:Label=new Label();
		private var _brightnessLabel:Label=new Label();
		private var _contrastLabel:Label=new Label();
		private var _minAreaLabel:Label=new Label();
		private var _maxAreaLabel:Label=new Label();

		private var _blurSlider:Slider=new Slider();
		private var _brightnessSlider:Slider=new Slider();
		private var _contrastSlider:Slider=new Slider();
		private var _minAreaSlider:Slider=new Slider();
		private var _maxAreaSlider:Slider=new Slider();
		//
		private var state:Stats=new Stats()
		private var pic:Pic=new Pic() //menu ball
		private var layerBut:Sprite=new Sprite(); //show below button
		private var arrow:obj_arrow=new obj_arrow();
		private var butRight:but_right=new but_right()
		private var butLeft:but_left=new but_left()
		private var butRightD:but_right=new but_right()
		private var butLeftD:but_left=new but_left()
		public var touchble:Boolean=true
		//
		private var layerUI:Sprite=new Sprite() //show blur bar
		private var layerMsg:Sprite=new Sprite() //show the messenge to user
		private var layerContent:Sprite=new Sprite()
		private var butShowUI:Sprite=new Sprite()
		private var tagShowUI:Boolean=true
		//
//		private var layerPhoto:Sprite=new Sprite()
		private var cameraRoll:CameraRoll = new CameraRoll();
		private var tagTakePhoto:Boolean=true
		private var tagShowMap:Boolean=true
//		private var timer:Timer=new Timer(2000,1)
//		private var msg_photo:obj_msg=new obj_msg()
		//
		private var vid:Video //<--------scene we see
		//
//		private var layerMap:Sprite=new Sprite()
//		private var msg_showMap:obj_msg=new obj_msg()

		private var functionPG:int=0
		public static var detectRate:int=4  //縮小的偵測範圍數
		//
		private var mode:String="mouse"
//		private var mode:String="touch"
		
		
		
		

		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		//	----------------------------------------------------------------
		//	PRIVATE METHODS
		//	----------------------------------------------------------------

		private function configureUI():void
		{
			var barHeight:int=120
			var scaleValue:int=3

			_blurSlider.minimum=0;
			_blurSlider.maximum=40;

			_brightnessSlider.minimum=-100;
			_brightnessSlider.maximum=100;

			_contrastSlider.minimum=-100;
			_contrastSlider.maximum=200;

			_minAreaSlider.minimum=0;
			_minAreaSlider.maximum=50;

			_minAreaSlider.minimum=0;
			_maxAreaSlider.maximum=100;
			//
			_blurSlider.x=_blurLabel.x=50;
			_blurSlider.y=200
			_blurLabel.y=_blurSlider.y - 15;
			_blurSlider.scaleX=scaleValue
			_blurSlider.scaleY=scaleValue

			_brightnessSlider.x=_brightnessLabel.x=_blurSlider.x
			_brightnessSlider.y=_blurSlider.y + 40
			_brightnessLabel.y=_brightnessSlider.y - 15;
			_brightnessSlider.scaleX=scaleValue
			_brightnessSlider.scaleY=scaleValue

			_contrastSlider.x=_contrastLabel.x=_blurSlider.width + 170*pic.scaleRate;
			_contrastSlider.y=_blurSlider.y;
			_contrastLabel.y=_contrastSlider.y - 15;
			_contrastSlider.scaleX=scaleValue
			_contrastSlider.scaleY=scaleValue

			_minAreaSlider.x=_minAreaLabel.x=_contrastSlider.x
			_minAreaSlider.y=_contrastSlider.y + 40
			_minAreaLabel.y=_minAreaSlider.y - 15;
			_minAreaSlider.scaleX=scaleValue
			_minAreaSlider.scaleY=scaleValue

			_maxAreaSlider.x=_maxAreaLabel.x=_minAreaSlider.x
			_maxAreaSlider.y=_minAreaSlider.y + 40
			_maxAreaLabel.y=_maxAreaSlider.y - 15;
			_maxAreaSlider.scaleX=scaleValue
			_maxAreaSlider.scaleY=scaleValue
			//
			layerUI.addChild(_blurSlider);
			layerUI.addChild(_blurLabel);

			layerUI.addChild(_brightnessSlider);
			layerUI.addChild(_brightnessLabel);

			layerUI.addChild(_contrastSlider);
			layerUI.addChild(_contrastLabel);

			layerUI.addChild(_minAreaSlider);
			layerUI.addChild(_minAreaLabel);

			layerUI.addChild(_maxAreaSlider);
			layerUI.addChild(_maxAreaLabel);
			//set default value
			_blurSlider.value=0
			_brightnessSlider.value=-2
			_contrastSlider.value=61
			_minAreaSlider.value=10
			_maxAreaSlider.value=50
			//
	
		}

		private function initTracking():void
		{
			var camW:int=1632 //stage.stageWidth
			var camH:int=camW/1.6 

			// Create the camera
			var cam:Camera=Camera.getCamera();
			cam.setMode(camW, camH, stage.frameRate);
			cam.setQuality(0,100)

			// Create a video <--------scene we see
			vid=new Video(camW, camH);
			vid.attachCamera(cam);
			vid.y=-102
			addChild(vid)  
			
			//small video for detect
			var vidS:Video=new Video(camW/detectRate, camH/detectRate);  
			vidS.attachCamera(cam);
//			vidS.y=-102
//			addChild(vidS)
			

			// Create the Motion Tracker
//			_motionTracker=new MotionTracker(vid);
			_motionTracker=new MotionTracker(vidS);

			// We flip the input as we want a mirror image
			_motionTracker.flipInput=false;

			/*** Create a few things to help us visualise what the MotionTracker is doing... ***/

			_matrix=new ColorMatrix();
			_matrix.brightness=_motionTracker.brightness;
			_matrix.contrast=_motionTracker.contrast;

			// Display the camera input with the same filters (minus the blur) as the MotionTracker is using  filter過的畫面
			_video=new BitmapData(camW, camH, false, 0);


			// A shape to represent the tracking point
			_target=new Shape();
			_target.graphics.lineStyle(0, 0xFFFFFF);
			_target.graphics.beginFill(0xFF0000)
			_target.graphics.drawCircle(0, 0, 30*int(pic.scaleRate));
			addChild(_target);

			// A box to represent the activity area
			_bounds=new Shape();
			addChild(_bounds);


			//------------------------------------------------------------
			//       show visual
			//------------------------------------------------------------
			state.scaleX=state.scaleY=pic.scaleRate*1.5
			state.x=stage.stageWidth-200
			state.y=stage.stageHeight/2+100
			addChild(state)
//			state.visible=false
//			addChild(layerPhoto)
//			addChild(layerMap)
			//
//			msg_photo.x=stage.stageWidth/2
//			msg_photo.y=stage.stageHeight-150
//			msg_photo.scaleX=msg_photo.scaleY=pic.scaleRate
//			msg_photo.visible=false
//			layerMsg.addChild(msg_photo)
			//
//			msg_photo.x=msg_photo.x
//			msg_photo.y=msg_photo.y
//			msg_photo.scaleX=msg_photo.scaleX
//			msg_photo.txt.text="map lauch"
//			msg_photo.visible=false
//			layerMsg.addChild(msg_showMap)
			
			//------------------------------------------------------------
			//       basic interface visual
			//------------------------------------------------------------
				
			pic.x=50
			pic.y=10
			addChild(pic)
			addChild(layerBut)

			butLeft.y=-butLeft.height/2
			butLeft.scaleX=butLeft.scaleY=pic.scaleRate	
			layerBut.addChild(butLeft)

			butRight.x=stage.stageWidth
			butRight.y=butLeft.y
			butRight.scaleX=butRight.scaleY=pic.scaleRate	
			layerBut.addChild(butRight)
			
			butLeftD.y=stage.stageHeight+butLeftD.height/2
			butLeftD.scaleX=butLeftD.scaleY=pic.scaleRate
			layerBut.addChild(butLeftD)
			
			butRightD.x=butRight.x
			butRightD.y=butLeftD.y
			butRightD.scaleX=butRightD.scaleY=pic.scaleRate	
			layerBut.addChild(butRightD)
			
			arrow.x=stage.stageWidth/2//-pic.diffDis
			arrow.y=-pic.diffDis*2.5
			arrow.scaleX=arrow.scaleY=pic.scaleRate		
			layerBut.addChild(arrow)
			//
			layerUI.visible=false
			layerUI.scaleX=layerUI.scaleY=pic.scaleRate
			addChild(layerUI)
			butShowUI.graphics.beginFill(0x0000FF)
			butShowUI.graphics.drawCircle(stage.stageWidth/2+150, stage.stageHeight - 20, 30*int(pic.scaleRate))
			addChild(butShowUI)
			//
			addChild(layerMsg)
			addChild(layerContent)


			//------------------------------------------------------------
			//       eventListener
			//------------------------------------------------------------

			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			//	
			cameraRoll.addEventListener(ErrorEvent.ERROR, onCrError);				
			cameraRoll.addEventListener(Event.COMPLETE, onCrComplete);
//			timer.addEventListener(TimerEvent.TIMER_COMPLETE,completeHandler)
			//
			butShowUI.addEventListener(MouseEvent.CLICK, showUIHandler)
				
			
			//	
			detectUI(cam, vidS)	
			
			
				
		}
		
		
//		protected function showUIHandler(event:TouchEvent):void
		protected function showUIHandler(event:MouseEvent):void
		{
			
			
			configureUI();

			if (tagShowUI == true)
			{
				layerUI.visible=false
				tagShowUI=false
//				state.visible=false
//				trace("true");
				
			}
			else if (tagShowUI == false)
			{
				layerUI.visible=true
				tagShowUI=true
//				state.visible=true
//				trace("false");
			}

		}

		private function detectUI(_cam:Camera, _vid:Video):void
		{

//			_source=new Bitmap(_video);
//			_source.x=10 + _vid.width;
//			_source.y=10;
//			_source.filters=[new ColorMatrixFilter(_matrix.toArray())];
//			_source.visible=true
//			layerUI.addChild(_source);


			// Show the image the MotionTracker is processing and using to track 黑白
			_output=new Bitmap(_motionTracker.trackingImage)
			_output.x=_vid.x
			_output.y=_vid.y
			_output.scaleX=_output.scaleY=1/pic.scaleRate  //除以二，偵測的黑白bitmap才會跟縮小過後的攝影機畫面一樣大 (layerUI有乘了pic.scaleRate)
			_output.alpha=.5
			_output.visible=true
			layerUI.addChild(_output);
			

			// Configure the UI
			_blurSlider.addEventListener(Event.CHANGE, onComponentChanged);
			_brightnessSlider.addEventListener(Event.CHANGE, onComponentChanged);
			_contrastSlider.addEventListener(Event.CHANGE, onComponentChanged);
			_minAreaSlider.addEventListener(Event.CHANGE, onComponentChanged);
			_maxAreaSlider.addEventListener(Event.CHANGE, onComponentChanged);

		}

		private function applyFilters():void
		{
			_blurLabel.text="Blur: " + Math.round(_blurSlider.value);
			_brightnessLabel.text="Brightness: " + Math.round(_brightnessSlider.value);
			_contrastLabel.text="Contrast: " + Math.round(_contrastSlider.value);
			_minAreaLabel.text="Min Area: " + Math.round(_minAreaSlider.value);
			_maxAreaLabel.text="Max Area: " + Math.round(_maxAreaSlider.value);

			_matrix.reset();
			_matrix.adjustContrast(_contrastSlider.value);
			_matrix.adjustBrightness(_brightnessSlider.value);
			_source.filters=[new ColorMatrixFilter(_matrix)];
		}
		
		

		//	----------------------------------------------------------------
		//	EVENT HANDLERS
		//	----------------------------------------------------------------

		private function onAddedToStage(event:Event):void
		{
//			Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT; 
//			stage.autoOrients=false
//			stage.setOrientation(StageOrientation.ROTATED_RIGHT)
			//
			initTracking();
			//applyFilters();

			
			
		}


		private function onEnterFrameHandler(event:Event):void
		{
			_bounds.graphics.clear();
			_target.visible=false

			// Tell the MotionTracker to update itself
			_motionTracker.track();

//			_video.draw(_motionTracker.input); // <--draw vidS
			_video.draw(vid);

			
			
				
			if (mode=="mouse") 
			{
				_target.x=stage.mouseX
				_target.y=stage.mouseY
				
				
			}
			else if (mode=="touch") 
			{
				// If there is enough movement (see the MotionTracker's minArea property) then continue
				if (!_motionTracker.hasMovement)
					return;
				
				// Draw the motion bounds so we can see what the MotionTracker is doing
				_bounds.graphics.lineStyle(0, 0xFFFFFF);
				var mappingAreaX:Number=mapping(_motionTracker.motionArea.x,0,408,0,stage.stageWidth+20)
				var mappingAreaY:Number=mapping(_motionTracker.motionArea.y,0,255,0,stage.stageHeight+20)
				_bounds.graphics.drawRect(mappingAreaX, mappingAreaY, _motionTracker.motionArea.width*detectRate, _motionTracker.motionArea.height*detectRate);
				//
				var mappingX:Number=mapping(_motionTracker.x,20,388,-20,stage.stageWidth+20)
				var mappingY:Number=mapping(_motionTracker.y,20,235,-20,stage.stageHeight+20)
				_target.x=mappingX
				_target.y=mappingY
					
			}
			
			//如果有符合最大與最小區域(motionTracker.as)就看得到紅球
			_target.visible=true

			var moveDis:int=pic.dis

			if ((_target.hitTestObject(butLeft)) && (touchble))
			{
				if(pic.x>=50+(-390*detectRate))
				{	
					touchble=false
					Tweener.addTween(pic, {x: pic.x - moveDis, time: 2, transition: "easingOut", onComplete: setTouchble,onCompleteParams:["left"]});
				}
			}
			else if (_target.hitTestObject(butRight) && (touchble))
			{
				if(pic.x<50)
				{
					touchble=false
					Tweener.addTween(pic, {x: pic.x + moveDis, time: 2, transition: "easingOut ", onComplete: setTouchble,onCompleteParams:["right"]});
				}
				
			}
			else if ((_target.hitTestObject(butLeftD)) && (touchble))
			{
				//	----------------------------------------------------------------
				//	LEFT BUTTON
				//	----------------------------------------------------------------	
				
				if (functionPG==0) 
				{
					//take photo
					touchble=false

					takePhotoHandler()

				}
				else if (functionPG==1) 
				{
					//call maps
					touchble=false

					createMap()
					
				}
				
				
			}
			else if (_target.hitTestObject(butRightD) && (touchble))
			{
				//	----------------------------------------------------------------
				//	RIGHT BUTTON
				//	----------------------------------------------------------------
				
				if (functionPG==0) 
				{
					//quit photo
					
				}
				else if (functionPG==1) 
				{
					//kill maps
					touchble=false
					//
					removeAllChildren(layerContent)	
					tagShowMap=true
					timerKiller(createMsg,layerMsg,10,1000,"close the map")
					//
//					touchble=true

					
				}
				
			}
			
		}
		
		
		
		private function setTouchble(_direction:String):void
		{
			touchble=true
//			trace("fin")
			
			if (_direction=="left") 
			{
				functionPG++
			}
			else if (_direction=="right") 
			{
				functionPG--
			}
			
//			trace("functionPG= "+functionPG)
			
		}

		
		private function takePhotoHandler():void
		{

			if (CameraRoll.supportsAddBitmapData)
			{
				if (tagTakePhoto) 
				{
					cameraRoll.addBitmapData(_video);	
					trace("take photo")
					//
					timerKiller(createMsg,layerMsg,10,800,"taking photo")
					//
					tagTakePhoto=false

				}
				
			}
			else
			{
				timerKiller(createMsg,layerMsg,10,1000,"not supported")
				trace("not supported.");
			}
			
		}
		
		
		protected function onCrComplete(event:Event):void
		{
			trace("photo saved");
			tagTakePhoto=true
			//
			timerKiller(createMsg,layerMsg,200,800,"photo saved")
			//
//			timer.start()
			timerKiller(createSmallPhoto,layerContent,10,1000,null)
			
		}
		
		
		protected function onCrError(event:Event):void
		{
			//for camera roll
			timerKiller(createMsg,layerMsg,10,1000,"photo ERROR!")
			trace("Main.onCrError(event)");
			
		}
		
		private function createSmallPhoto():void
		{
			//暫存畫面用，而不是一直跟隨draw到的最新畫面
			var tempData:BitmapData=new BitmapData(_video.width,_video.height) 
			tempData=_video.clone()
			//	
			var smallPhoto:Bitmap=new Bitmap(tempData)
			smallPhoto.scaleX=smallPhoto.scaleY=.2
			smallPhoto.x=stage.stageWidth/2-(smallPhoto.width/2)
			smallPhoto.y=stage.stageHeight-(smallPhoto.height/2)
			layerContent.addChild(smallPhoto)
			
		}

		
		private function createMap():void
		{

			if(tagShowMap)
			{	
				timerKiller(createMsg,layerMsg,10,1000,"show map")
				trace("creat map")
				//
				var obj_map:mapClass=new mapClass()
				obj_map.x=stage.stageWidth/2-(stage.stageWidth/3)-100
				obj_map.y=stage.stageHeight/2-(stage.stageHeight/2)

				layerContent.addChild(obj_map)
				//
				tagShowMap=false
					
//				trace("obj_map.x= "+obj_map.x)
//				trace("obj_map.y= "+obj_map.y)
//				trace("obj_map.width= "+obj_map.width)
//				trace("obj_map.height= "+obj_map.height)
			}
			else
			{
				timerKiller(createMsg,layerMsg,10,1000,"map existed")
//				trace("there's already a map")
			}
			
//			touchble=true


			
		}
		
		
		private function createMsg():void
		{
			
			var msg:obj_msg=new obj_msg()
			msg.x=stage.stageWidth/2
			msg.y=stage.stageHeight-150
			msg.scaleX=msg.scaleY=pic.scaleRate
			msg.txt.text=arguments[0]
			layerMsg.addChild(msg)
		}
		
	

		private function onComponentChanged(event:Event):void
		{
			switch (event.target)
			{
				case _blurSlider:

					_motionTracker.blur=_blurSlider.value;

					break;

				case _brightnessSlider:

					_motionTracker.brightness=_brightnessSlider.value;

					break;

				case _contrastSlider:

					_motionTracker.contrast=_contrastSlider.value;

					break;

				case _minAreaSlider:

					_motionTracker.minArea=_minAreaSlider.value;

					break;

				case _maxAreaSlider:

					_motionTracker.maxArea=_maxAreaSlider.value;


					break;
			}

			applyFilters();
		}
		
		private function timerKiller(_fn:Function,_targetLayer:Object, _time:int,_delay:int,_msg:String):void
		{
			
			var timer:Timer=new Timer(_time+_delay, 1) //set clean timer 
			if(_msg)
			{
				setTimeout(_fn,_time,_msg) //do the things function
			}
			else
			{
				setTimeout(_fn,_time) //do the things function
				
			}
			//
			timer.start()
			
			//clean function	
			var completeHandler:Function = function(event:TimerEvent):void
			{
				//kill self timer
				timer.stop()
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler)
				timer=null
				
				//clean specific layer
				while (_targetLayer.numChildren) {
					_targetLayer.removeChildAt(0);
				}
				
//				trace("_targetLayer.numChildren= "+_targetLayer.name+"   "+_targetLayer.numChildren)
				
				touchble=true

			}
			
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler)

			
		}
		
		public static function removeAllChildren ( target:DisplayObjectContainer ) : void
		{
			while( target.numChildren )
				target.removeChildAt( 0 );
		}
		
		public function mapping(v:Number, a:Number,b:Number,x:Number = 0,y:Number = 1):Number
		{ 
			return(v == a)?x:(v - a)*(y-x)/(b- a)+x;
		}

	}
}
