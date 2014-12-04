
package com.wf.animation
{
	import flash.utils.getTimer;

	/**
	 * 动画计时器，需要将此类的 update 方法放入 ENTER_FRAME 事件中
	 * @author: Bindiry
	 * @date: 2014/11/20
	 */
	public class SSTimer
	{
		public static var elapsedTime:Number;
		private static var _lastFrameTimestamp:Number;

		public static function init():void
		{
			_lastFrameTimestamp = getTimer() / 1000.0;
			elapsedTime = 0;
		}

		public static function update():void
		{
			var now:Number = getTimer() / 1000.0;
			elapsedTime = now - _lastFrameTimestamp;
			_lastFrameTimestamp = now;
			if (elapsedTime > 1.0)
			{
				elapsedTime = 1.0;
			}
		}
	}
}
