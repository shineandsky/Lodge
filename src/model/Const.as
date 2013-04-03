package model
{

	public class Const
	{
		public static const MOVIE_C:String="1";
		public static const BOOK_C:String="2";
		public static const MOIVE_M:String="3";
		public static const BOOK_M:String="4";
		public static const ALL_C:String="5";
		public static const ALL_M:String="6";

		public static const MOVIE_TYPE:String="1";
		public static const BOOK_TYPE:String="2";

		public function Const()
		{
		}

		public static function get privilesg():Array
		{
			return [{label: '创建影片互动内容', value: MOVIE_C}, {label: '管理影片互动内容', value: MOIVE_M}, {label: '创建书籍互动内容',
					value: BOOK_C}, {label: '管理书籍互动内容', value: BOOK_M}, {label: '创建所有内容', value: ALL_C},
				{label: "管理所有内容", value: ALL_M}];
		}

		public static function get contentTypes():Array
		{
			return [{label: '影片互动内容', value: MOVIE_TYPE}, {label: '书籍互动内容', value: BOOK_TYPE}];
		}
	}
}
