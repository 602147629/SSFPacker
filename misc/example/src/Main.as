package
{
	import com.wf.animation.SSData;
	import com.wf.animation.SSManager;
	import com.wf.animation.SSTimer;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;

	[SWF(width="960", height="540", backgroundColor="#333333")]
	public class Main extends Sprite
	{
		[Embed(source="../assets/player.ssf", mimeType="application/octet-stream")]
		private var SSFClass0:Class;

		private var _playerList:Vector.<Player>;

		public function Main()
		{
			if (stage)
			{
				addedToStageHandler();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			}
		}

		private function addedToStageHandler(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			stage.frameRate = 60;

			SSTimer.init();

			_playerList = new Vector.<Player>();

			addEventListener(Event.ENTER_FRAME, enterFrameHandler);

			SSManager.getInstance().init();

			var ssfData:ByteArray = new SSFClass0();
			var ssfFile:SSData = new SSData(ssfData);
			SSManager.getInstance().addData(Common.PLAYER_TEMP_NAME, ssfFile);

			SSManager.getInstance().decodeAllData(function():void {

				// 加载并解压完成
				var player:Player;
				for (var i:int = 0; i < 22; i++)
				{
					player = new Player();
					player.x = 150;
					player.y = 150;
					addChild(player);
					_playerList.push(player);
				}

			});

		}

		private function enterFrameHandler(e:Event):void
		{
			SSTimer.update();
			if (_playerList)
			{
				for each (var player:Player in _playerList)
					player.update();
			}
		}
	}
}
