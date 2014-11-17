package
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	/**  
	 * @author: Bindiry   
	 * @date: 2014-11-14 下午6:08:10  
	 */
	public class SSFItem
	{
		private var _pngFile:File;
		private var _xmlFile:File;
		private var _outputPath:String;
		private var _fileName:String;
		/** 所在目录 */
		private var _folder:String;
		
		public function SSFItem(pFolder:String = null)
		{
			_pngFile = null;
			_xmlFile = null;
			_outputPath = "";
			_fileName = "";
			_folder = pFolder;
		}
		
		public function export():void
		{
			var imageData:ByteArray = Common.openAsByteArray(_pngFile.nativePath);
			var xmlData:ByteArray = Common.openAsByteArray(_xmlFile.nativePath);
			xmlData.compress();
			var itemData:ByteArray = new ByteArray();
			itemData.writeObject([imageData, xmlData]);
			var exportPath:String = "";
			if (_folder)
			{
				exportPath = Common.exportPath + "\\" + _folder.substring(_folder.lastIndexOf("\\") + 1) + "\\" + fileName;
			}
			else
			{
				exportPath = Common.exportPath  + "\\" + fileName;
			}
			Common.save(exportPath, itemData);
		}
		
		private function setOuputPath():void
		{
			if (_outputPath == "")
			{
				if (_pngFile)
				{
					_outputPath = _pngFile.nativePath.substr(0, _pngFile.nativePath.indexOf(".")) + Common.SSF_EXTNAME;
				}

				if (_xmlFile)
				{
					_outputPath = _xmlFile.nativePath.substr(0, _xmlFile.nativePath.indexOf(".")) + Common.SSF_EXTNAME;
				}
				_fileName = _outputPath.substring(_outputPath.lastIndexOf("\\") + 1);
			}
		}
		
		public function get isWhole():Boolean
		{
			return _pngFile != null && _xmlFile != null;
		}

		public function get pngFile():File
		{
			return _pngFile;
		}

		public function set pngFile(value:File):void
		{
			_pngFile = value;
			setOuputPath();
		}

		public function get xmlFile():File
		{
			return _xmlFile;
		}

		public function set xmlFile(value:File):void
		{
			_xmlFile = value;
			setOuputPath();
		}

		public function get outputPath():String
		{
			return _outputPath;
		}

		public function get fileName():String
		{
			return _fileName;
		}


	}
}