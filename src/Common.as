package
{
	import flash.data.EncryptedLocalStore;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**  
	 * @author: Bindiry   
	 * @date: 2014-11-14 下午6:20:11  
	 */
	public class Common
	{
		public static const SSF_EXTNAME:String = ".ssf";
		public static const PNG_EXTNAME:String = ".png";
		public static const XML_EXTNAME:String = ".xml";
		
		public static const LOCAL_STORE_KEY:String = "ssfpacker_export_path";
		
		public static var exportPath:String;
		
		public static function getExtName(pPath:String):String
		{
			return pPath.substring(pPath.lastIndexOf("."));
		}
		
		public static function setLocalStore(pKey:String, pData:String):void
		{
			var byte:ByteArray = new ByteArray();
			byte.writeUTFBytes(pData);
			EncryptedLocalStore.setItem(pKey, byte);
		}
		
		public static function getLocalStore(pKey:String):String
		{
			var result:String;
			var byte:ByteArray = EncryptedLocalStore.getItem(pKey);
			if (byte)
			{
				result = byte.readUTFBytes(byte.length);
			}
			return result;
		}
		
		/**
		 * 打开文件字节流的简便方法,返回打开的字节流数据，若失败，返回null.
		 * @param path 要打开的文件路径
		 */
		public static function openAsByteArray(path:String):ByteArray
		{
			path = escapeUrl(path);
			var fs:FileStream = open(path);
			if(!fs)
				return null;
			fs.position = 0;
			var bytes:ByteArray = new ByteArray();
			fs.readBytes(bytes);
			fs.close();
			return bytes;
		}
		
		/**
		 * 转换url中的反斜杠为斜杠
		 */
		public static function escapeUrl(url:String):String
		{
			return Boolean(!url)?"":url.split("\\").join("/");
		}
		
		/**
		 * 打开文件的简便方法,返回打开的FileStream对象，若打开失败，返回null。
		 * @param path 要打开的文件路径
		 */		
		public static function open(path:String):FileStream
		{
			path = escapeUrl(path);
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			var fs:FileStream = new FileStream;
			try
			{
				fs.open(file,FileMode.READ);
			}
			catch(e:Error)
			{
				return null;
			}
			return fs;
		}
		
		/**
		 * 打开保存文件对话框，并保存数据。
		 * @param data
		 * @param onSelect 回调函数：onSelect(file:File)
		 * @param title 对话框标题
		 */		
		public static function browseAndSave(data:Object,defaultPath:String=null,title:String="保存文件"):void
		{
			defaultPath = escapeUrl(defaultPath);
			var file:File
			if(defaultPath!=null)
				file = File.applicationDirectory.resolvePath(defaultPath);
			else
				file = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void{
				save(file.nativePath,data);
			});
			file.browseForSave(title);
		}
		
		/**
		 * 保存数据到指定文件，返回是否保存成功
		 * @param path 文件完整路径名
		 * @param data 要保存的数据
		 */		
		public static function save(path:String,data:Object):Boolean
		{
			path = escapeUrl(path);
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			if(file.exists)
			{//如果存在，先删除，防止出现文件名大小写不能覆盖的问题
				deletePath(file.nativePath);
			}
			if(file.isDirectory)
				return false;
			var fs:FileStream = new FileStream;
			try
			{
				fs.open(file,FileMode.WRITE);
				if(data is ByteArray)
				{
					fs.writeBytes(data as ByteArray);
				}
				else if(data is String)
				{
					fs.writeUTFBytes(data as String);
				}
				else
				{
					fs.writeObject(data);
				}
			}
			catch(e:Error)
			{
				fs.close();
				return false;
			}
			fs.close();
			return true;
		}
		
		/**
		 * 删除文件或目录，返回是否删除成功
		 * @param path 要删除的文件源路径
		 * @param moveToTrash 是否只是移动到回收站，默认false，直接删除。
		 */		
		public static function deletePath(path:String,moveToTrash:Boolean = false):Boolean
		{
			path = escapeUrl(path);
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			if(moveToTrash)
			{
				try
				{
					file.moveToTrash();
				}
				catch(e:Error)
				{
					return false;
				}
			}
			else
			{
				if(file.isDirectory)
				{
					try
					{
						file.deleteDirectory(true);
					}
					catch(e:Error)
					{
						return false;
					}
				}
				else
				{
					try
					{
						file.deleteFile();
					}
					catch(e:Error)
					{
						return false;
					}
				}
			}
			return true;
		}
		
	}
}