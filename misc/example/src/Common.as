package
{
	/**
	 *
	 * @author: Bindiry
	 * @date: 2014/11/20
	 */
	public class Common
	{
		public static const WIDTH:int = 960;
		public static const HEIGHT:int = 540;

		public static const PLAYER_TEMP_NAME:String = "player_1_1";

		public static function intRange(n1 : uint, n2 : uint) : uint {
			return Math.random() * (n2 - n1) + n1;
		}

		public static function numRange(n1 : Number, n2 : Number) : Number {
			if (n1 < 0 || n2 < 0) {
				throw new Error("参数错误：不可为负数。");
			}
			return Math.random() * (n2 - n1) + n1;
		}
	}
}
