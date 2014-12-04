package com.wf.animation
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.LoaderContext;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * SSF文件数据
	 * @author: Bindiry
	 * @date: 2014/11/17
	 */
	public class SSData
	{
		private var _texture:BitmapData;
		private var _textureData:ByteArray;
		private var _config:XML;
		private var _decodeCallback:Function;
		private var _frameList:Dictionary;

		/**
		 * 初始化
		 * @param pData 包含位图序列表(png)和配置文件(xml)的数据
		 */
		public function SSData(pData:ByteArray)
		{
			pData.position = 0;
			var fileContent:Array = pData.readObject() as Array;
			_textureData = fileContent[0];
			var configData:ByteArray = fileContent[1];
			configData.uncompress();
			_config = new XML(configData.readUTFBytes(configData.length));
		}

		/**
		 * 根据名称前缀获取多个符合条件的排序的帧数据
		 * @param pNamePrefix 名称前缀
		 */
		public function getFrames(pNamePrefix:String):Vector.<SSFrame>
		{
			var result:Vector.<SSFrame> = new Vector.<SSFrame>();
			var keyList:Vector.<String> = new Vector.<String>();
			for (var key:String in _frameList)
			{
				if (key.indexOf(pNamePrefix) > -1)
				{
					keyList.push(key);
				}
			}
			keyList.sort(Array.CASEINSENSITIVE);
			for each (key in keyList)
			{
				result.push(_frameList[key]);
			}
			return result;
		}

		/** 解析动画数据 */
		private function parseAtlasData(atlasXml:XML):Dictionary
		{
			var result:Dictionary = new Dictionary();

			var name:String;
			var frame:SSFrame;
			var x:Number;
			var y:Number;
			var width:Number;
			var height:Number;
			var frameX:Number;
			var frameY:Number;
			var frameWidth:Number;
			var frameHeight:Number;
			var rect:Rectangle;
			var framePoint:Point;
			var bitmapData:BitmapData;

			for each (var subTexture:XML in atlasXml.SubTexture)
			{
				name = subTexture.attribute("name");
				x = parseFloat(subTexture.attribute("x"));
				y  = parseFloat(subTexture.attribute("y"));
				width = parseFloat(subTexture.attribute("width"));
				height = parseFloat(subTexture.attribute("height"));
				frameX = parseFloat(subTexture.attribute("frameX"));
				frameY = parseFloat(subTexture.attribute("frameY"));
				frameWidth = parseFloat(subTexture.attribute("frameWidth"));
				frameHeight = parseFloat(subTexture.attribute("frameHeight"));
				rect = new Rectangle(x,  y,  width,  height);
				framePoint = new Point(Math.abs(frameX), Math.abs(frameY));

				bitmapData = new BitmapData(width, height, true, 0);
				bitmapData.copyPixels(_texture, rect, new Point(0, 0));
				frame = new SSFrame(bitmapData, framePoint);
				result[name] = frame;
			}

			return result;
		}

		/** 解码位图数据 */
		public function decode(pCallback:Function):void
		{
			_decodeCallback = pCallback;
			var loader:Loader = new Loader();
			var loaderContext:LoaderContext = new LoaderContext();
			if(loaderContext.hasOwnProperty("imageDecodingPolicy"))//如果是FP11以上版本，开启异步位图解码
				loaderContext["imageDecodingPolicy"] = "onLoad";
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.loadBytes(_textureData, loaderContext);
		}

		private function onLoadComplete(e:Event):void
		{
			var loader:Loader = (e.target as LoaderInfo).loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_texture = (loader.content as Bitmap).bitmapData;
			_frameList = parseAtlasData(_config);
			if (_texture)
			{
				_texture.dispose();
				_texture = null;
			}
			if (_config)
			{
				System.disposeXML(_config);
				_config = null;
			}
			if (_textureData) _textureData = null;

			if (_decodeCallback != null)
			{
				_decodeCallback();
			}
		}

		public function destroy():void
		{
			if (_texture)
			{
				_texture.dispose();
				_texture = null;
			}

			if (_config)
			{
				System.disposeXML(_config);
				_config = null;
			}

			if (_decodeCallback != null)
			{
				_decodeCallback = null;
			}

			var bitmapData:BitmapData;
			for (var key:String in _frameList)
			{
				bitmapData = _frameList[key];
				delete _frameList[key];
				bitmapData.dispose();
			}
			_frameList = null;

		}
	}
}
