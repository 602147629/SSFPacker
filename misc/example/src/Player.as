package
{
	import com.greensock.TweenLite;
	import com.wf.animation.SSFrame;
	import com.wf.animation.SSFrame;
	import com.wf.animation.SSManager;
	import com.wf.animation.SSMovieClip;
	import com.wf.animation.SSTimer;

	import flash.geom.Point;

	/**
	 *
	 * @author: Bindiry
	 * @date: 2014/11/20
	 */
	public class Player extends SSMovieClip
	{
		public function Player()
		{
			var frameList:Vector.<SSFrame> = SSManager.getInstance().getFrames(Common.PLAYER_TEMP_NAME, '0/');
			super(frameList, Common.intRange(10, 50), new Point(-99, -115));
			tween();
		}

		private function tween():void
		{
			var targetPoint:Point = new Point(Common.intRange(0, Common.WIDTH), Common.intRange(0, Common.HEIGHT));
			TweenLite.to(this, Common.numRange(2.8, 5.5), {
				onStart: onStart,
				onStartParams: [targetPoint],
				x: targetPoint.x,
				y: targetPoint.y,
				onComplete: onComplete
			} );
		}

		private function onStart(pTargetPoint:Point):void
		{
			var r:Number = Math.atan2(pTargetPoint.y - this.y, pTargetPoint.x - this.x);
			var angle:Number = r * 180 / Math.PI + 180;
			var direction:int = Math.floor( ( ( angle + 22.5 ) % 360 ) / 45 );

			this.frameList = SSManager.getInstance().getFrames(Common.PLAYER_TEMP_NAME, direction.toString() + "/");
		}

		private function onComplete():void
		{
			tween();
		}

		public function update():void
		{
			this.updateAnimation(SSTimer.elapsedTime)
		}
	}
}
