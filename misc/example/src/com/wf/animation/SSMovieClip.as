package com.wf.animation
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * 动作帧图像类
	 * 用于将位图序列中的一块矩形区域（一个动作帧）以指定的速度绘制在此类的图像上
	 * 
	 * @author Bindiry
	 * @date: 2014/11/21
	 */
	public class SSMovieClip extends Sprite
	{
		private var _frameList:Vector.<SSFrame>;
		private var _loop:Boolean;
		private var _playing:Boolean;
		private var _currentFrame:uint;
		private var _totalFrames:uint;
		private var _frameRate:Number;
		private var _frameTimer:Number;
		private var _bitmapContent:Bitmap;
		private var _offset:Point;

		/**
		 * 初始化
		 * @param pFrameList 动画的帧列表
		 * @param pFrameRate 动画的帧速率
		 * @param pOffset 偏移值
		 */
		public function SSMovieClip(pFrameList:Vector.<SSFrame>=null, pFrameRate:uint=12, pOffset:Point=null)
		{
			super();

			mouseEnabled = mouseChildren = false;

			_frameList = pFrameList;
			_frameRate = (pFrameRate > 0) ? (1.0 / pFrameRate) : 0;
			_offset = pOffset != null ? pOffset : new Point(0, 0);

			_totalFrames = _frameList ? _frameList.length : 0;
			_loop = true;
			_playing = _totalFrames > 1;
			_frameTimer = 0;
			_currentFrame = 0;
			_bitmapContent = new Bitmap();
			addChild(_bitmapContent);

			if (_frameList)
			{
				renderFrame();
			}
		}
		
		/** 更新动画，根据帧速率来绘制帧，此方法用于在 ENTER_FRAME 中调用 */
		public function updateAnimation(pTime:Number):void
		{
			if (!_playing || pTime < 0.0) return;

			if (_frameRate > 0)
			{
				_frameTimer += pTime;
				while(_frameTimer > _frameRate)
				{
					_frameTimer -= _frameRate;
					advanceFrame();
				}
			}
		}
		
		/** 更新当前帧数和帧索引值 */
		private function advanceFrame():void
		{
			if (_currentFrame >= totalFrames - 1)
			{
				if (_loop)
					_currentFrame = 0;
				else
					_playing = false;
			}
			else
			{
				++_currentFrame;
			}
			renderFrame();
		}

		private function renderFrame():void
		{
			var frame:SSFrame = _frameList[_currentFrame];
			_bitmapContent.bitmapData = frame.bitmapData;
			_bitmapContent.x = frame.framePoint.x + _offset.x;
			_bitmapContent.y = frame.framePoint.y + _offset.y;
		}
		
		/** 开始播放动作 */
		public function play():void
		{
			_currentFrame = 0;
			_frameTimer = 0;
			_playing = _totalFrames > 1;
		}

		/** 从指定帧开始播放 */
		public function gotoAndPlay(pFrameIndex:int):void
		{
			_currentFrame = pFrameIndex;
			renderFrame();
			_playing = true;
		}
		
		/** 停止播放动作 */
		public function stop():void
		{
			_playing = false;
		}

		/** 停止到指定帧 */
		public function gotoAndStop(pFrameIndex:int):void
		{
			_currentFrame = pFrameIndex;
			renderFrame();
			_playing = false;
		}

		public function set frameList(pValue:Vector.<SSFrame>):void
		{
			_frameList = pValue;
			_totalFrames = _frameList.length;
			_frameTimer = 0;
			_currentFrame = 0;
			renderFrame();
		}
		
		/** 获取当前帧数 */
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		/** 设置当前帧数以及帧索引 */
		public function set currentFrame(value:int):void
		{
			_currentFrame = value;
			renderFrame();
		}

		/** 获取当前动画总帧数 */
		public function get totalFrames():int
		{
			return _totalFrames;
		}

		/** 设置动画帧速 */
		public function set frameRate(pValue:uint):void
		{
			_frameRate = (pValue > 0) ? (1.0 / pValue) : 0;
			_frameTimer = 0;
		}

		/** 设置偏移值 */
		public function set offset(pValue:Point):void
		{
			_offset = pValue;
		}

		/** 设置动画是否循环播放（默认为true） */
		public function set loop(value:Boolean):void
		{
			_loop = value;
		}

		/** 返回是否在播放 */
		public function get playing():Boolean
		{
			return _playing;
		}

		/** 清理帧图像数据 */
		public function destroy():void
		{
			// 这里没有dispose掉bitmapData，留给SSManager统一dispose
			if (_bitmapContent) _bitmapContent = null;
		}
	}
}