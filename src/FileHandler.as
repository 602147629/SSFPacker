package
{
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	
	import spark.components.DataGrid;
	import spark.components.List;

	/**  
	 * @author: Bindiry   
	 * @date: 2014-11-14 下午6:03:08  
	 */
	public class FileHandler
	{
		/** 单例对象实例 */
		protected static var _instance:FileHandler;
		
		private var _ssfItemList:Dictionary;
		private var _FileList:List;
		private var _arrFileList:ArrayList;
		
		public function FileHandler()
		{
			if (_instance != null)
				throw new Error("实例只能有一个");
		}
		
		/** 获取单例实例 */
		public static function getInstance():FileHandler
		{
			if (_instance == null)
				_instance = new FileHandler();
			
			return _instance;
		}
		
		public function init(pFileList:List):void
		{
			_ssfItemList = new Dictionary();
			_arrFileList = new ArrayList();
			_FileList = pFileList;
			_FileList.labelField = "field";
		}
		
		/** 处理拖拽文件  */
		public function onDrop(pFiles:Array):void
		{
			for each (var file:File in pFiles)
			{
				// 如果是文件
				if (!file.isDirectory)
				{
					createSSFItem(file);
				}
				else
				{
					var folderList:Array = file.getDirectoryListing();
					for each(var tmpFile:File in folderList)
					{
						createSSFItem(tmpFile, file.nativePath);
					}
				}
			}
			
			for each (var ssfItem:SSFItem in _ssfItemList)
			{
				if (ssfItem.isWhole)
					_arrFileList.addItem({field: ssfItem.outputPath, name: ssfItem.fileName, data: ssfItem});
			}
			_arrFileList.source.sortOn("name");
			_FileList.dataProvider = _arrFileList;
		}
		
		public function export():void
		{
			if (_arrFileList.length <= 0)
			{
				Alert.show("没有文件可导出");
			}
			else if (!Common.exportPath)
			{
				Alert.show("请选择导出路径");
			}
			else
			{
				var len:int = _arrFileList.length;
				for (var i:int = 0; i < len; i++)
				{
					var ssfItem:SSFItem = _arrFileList.getItemAt(i).data as SSFItem;
					ssfItem.export();
				}
				// 清空文件列表
				_arrFileList.removeAll();
				_ssfItemList = new Dictionary();
				_FileList.dataProvider = _arrFileList;
				Alert.show("导出完成");
			}
		}
		
		private function createSSFItem(pFile:File, pFolder:String=null):void
		{
			// 检查目前列表存在的Item
			var ssfItem:SSFItem = getSSFItemFromList(pFile.nativePath, pFolder);
			
			if (Common.getExtName(pFile.nativePath) == Common.PNG_EXTNAME)
				ssfItem.pngFile = pFile;
			
			if (Common.getExtName(pFile.nativePath) == Common.XML_EXTNAME)
				ssfItem.xmlFile = pFile;
			
			_ssfItemList[ssfItem.outputPath] = ssfItem;
		}
		
		private function getSSFItemFromList(pNativePath:String, pFolder:String=null):SSFItem
		{
			var result:SSFItem;
			var outputPath:String = pNativePath.substr(0, pNativePath.indexOf(".")) + Common.SSF_EXTNAME;
			if (_ssfItemList[outputPath])
			{
				result = _ssfItemList[outputPath];
			}
			else
			{
				result = new SSFItem(pFolder);
			}
			return result;
		}
	}
}