package com.wf.animation
{
	import flash.utils.Dictionary;

	/**
	 * SSF 文件管理器
	 * @author: Bindiry
	 * @date: 2014/11/18
	 */
	public class SSManager
	{
		private static var _instance:SSManager;

		private var _inited:Boolean = false;
		private var _dataListDict:Dictionary;
		private var _dataListArray:Vector.<SSData>;

		private var _dataLength:int;
		private var _dataDecodeCount:int;
		private var _decodeCallback:Function;

		public function SSManager()
		{
			if (_instance)
			{
				throw new Error("SSManager is a singleton. Use getInstance instead.");
			}
			_instance = this;
		}

		public static function getInstance():SSManager
		{
			if (!_instance)
			{
				_instance = new SSManager();
			}
			return _instance;
		}

		public function init():void
		{
			if (_inited) return;

			_dataListDict = new Dictionary();
			_dataListArray = new Vector.<SSData>();

			_dataLength = 0;
			_dataDecodeCount = 0;

			_inited = true;
		}

		public function addData(pName:String, pData:SSData):void
		{
			_dataListDict[pName] = pData;
			_dataListArray.push(pData);
		}

		public function getData(pName:String):SSData
		{
			return _dataListDict[pName];
		}

		/**
		 * 根据SSF数据文件名及帧名称前缀获取多个已排序的帧数据
		 * @param pDataName SSF数据文件名
		 * @param pFrameNamePrefix 帧名称前缀
		 */
		public function getFrames(pDataName:String, pFrameNamePrefix:String):Vector.<SSFrame>
		{
			var ssfData:SSData = _dataListDict[pDataName];
			return ssfData.getFrames(pFrameNamePrefix);
		}

		/**
		 * 解码全部动画数据中的位图
		 * @param pCallback 解码完成后的回调
		 */
		public function decodeAllData(pCallback:Function=null):void
		{
			_decodeCallback = pCallback;
			_dataLength = _dataListArray.length;
			for each (var file:SSData in _dataListArray)
			{
				file.decode(fileDecodeComplete);
			}
		}

		private function fileDecodeComplete():void
		{
			_dataDecodeCount++;
			if (_dataDecodeCount >= _dataLength)
			{
				if (_decodeCallback != null)
				{
					_decodeCallback();
				}
			}
		}

		public function destroy():void
		{
			_dataListArray.length = 0;
			var ssfFile:SSData;
			for (var key:String in _dataListDict)
			{
				ssfFile = _dataListDict[key];
				delete _dataListDict[key];
				ssfFile.destroy();
			}
			_dataListDict = null;
			if (_decodeCallback != null) _decodeCallback = null;

			_inited = false;
			_instance = null;
		}
	}
}
