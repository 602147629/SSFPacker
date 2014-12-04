package com.wf.animation
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * 动画帧数据
	 * @author: Bindiry
	 * @date: 2014/11/21
	 */
	public class SSFrame
	{
		private var _bitmapData:BitmapData;
		private var _framePoint:Point;

		public function SSFrame(pBitmapData:BitmapData, pFramePoint:Point)
		{
			_bitmapData = pBitmapData;
			_framePoint = pFramePoint;
		}

		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		public function get framePoint():Point
		{
			return _framePoint;
		}
	}
}
