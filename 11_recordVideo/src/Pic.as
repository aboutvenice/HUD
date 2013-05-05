package
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;

	public class Pic extends Sprite
	{
		public var ball:obj_pic
		public var arrow:obj_arrow
		public  var scaleRate:Number //不同的DPI螢幕所產生的大小比例
		public  var diffDis:int=50;  //螢幕中心位置的差距
		public var dis:int=100

		public function Pic()
		{

//			trace("Math.max(1,Capabilities.screenDPI/160)= "+Math.max(1,Capabilities.screenDPI/160))
			scaleRate=Math.max(1,Capabilities.screenDPI/160)


			if (stage)
			{
				init()
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}

		}



		public function init(e:Event=null):void
		{
			
			
			
			
			
			for (var i:int=0; i < 8; i++)
			{
				
				ball=new obj_pic()
				ball.txt.text=String(i)
				ball.x=((stage.stageWidth/2)+i*dis)-diffDis
				ball.y=5
				ball.scaleX=ball.scaleY=scaleRate	
				
				if(i==0)
				{
					ball.x=stage.stageWidth/2-diffDis
					ball.txt.text="media"
				}
				else if(i==1)
				{
					ball.txt.text="map"
				}
				else if(i==2)
				{
					ball.txt.text="search"	
				}
				else if(i==3)
				{
					ball.txt.text="google it"
				}
				
				addChild(ball)


			}

		}
	}
}
