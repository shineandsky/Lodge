package controller
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.utils.Singleton;

	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;

	import spark.components.Group;

	import events.ODataEvent;

	import model.Const;
	import model.MenuVO;
	import model.content.ContentVO;
	import model.users.UserVO;

	public class MC extends Singleton
	{
		public static const MANAGEMENT_ADMIN:String="MANAGEMENT_ADMIN";
		public static const NEW_BOOK:String="NEW_BOOK";
		public static const NEW_VIDEO:String="NEW_VIDEO";
		public static const MAIN_VIEW:String="MAIN_VIEW";

		public static const SHOW_POINTS:String="SHOW_POINTS";
		public static const HIDE_ALL:String="HIDE_POINTS";
		public static const SHOW_PROPERTIES_PANEL:String="SHOW_PROPERTIES_PANEL";

		[Bindable]
		public var pointsAC:ArrayCollection;

		[Bindable]
		public var eventsAC:ArrayCollection;

		public var contentVO:ContentVO;

		public var jpegWraper:Object;

		public function MC()
		{
			viewDic=new Dictionary();
		}

		public static function get i():MC
		{
			return Singleton.getInstance(MC);
		}

		public function get isBook():Boolean
		{
			return contentVO.type == Const.BOOK_TYPE;
		}

		public var admin:UserVO;
		public var menu:NativeMenu;
		public var app:NativeApplication;
		private var mainView:Lodge;
		private var viewDic:Dictionary;

		public function init(app:NativeApplication, view:Lodge):void
		{
			this.app=app;
			mainView=view;
			menu=NativeApplication.supportsMenu ? app.menu : app.activeWindow.menu;
		}

		public function initLoggedInMenu():void
		{
			var menus:Array=menu.items;
			var ni:NativeMenuItem=menus[menus.length - 1];
			ni.submenu.addItemAt(getNativeMenuItem(new MenuVO('管理员管理', 'u', MANAGEMENT_ADMIN)), 0);
			ni.submenu.addItemAt(getNativeMenuItem(new MenuVO('隐藏列表和面板', 'h', '', HIDE_ALL)), 0);
			ni.submenu.addItemAt(getNativeMenuItem(new MenuVO('显示/隐藏热点列表', '1', '', SHOW_POINTS)), 0);
			ni.submenu.addItemAt(getNativeMenuItem(new MenuVO('显示/隐藏属性面板', '2', '', SHOW_PROPERTIES_PANEL)), 0);
			ni=menus[0];
			ni.submenu.addItemAt(getNativeMenuItem(new MenuVO('新建书籍互动内容', 'b', NEW_BOOK)), 0);
			ni.submenu.addItemAt(getNativeMenuItem(new MenuVO('新建影片互动内容', 'v', NEW_VIDEO)), 0);
		}

		public function addView(view:String):void
		{
			if (viewDic[view])
			{
				switchView(view);
				return;
			}
			var g:Group;
			switch (view)
			{
				case MAIN_VIEW:
//					g=new MainView();
					break;
				case NEW_BOOK:
//					g=new BookView();
					break;
			}
			g.width=mainView.width;
			g.height=mainView.height;
			mainView.addElement(g);
			viewDic[view]=g;
			trace('Added View: ', view);
		}

		private var currentView:Group;
		public var assetsPath:String;

		public function switchView(view:String):void
		{
			var g:Group=viewDic[view];
			g.width=mainView.width;
			g.height=mainView.height;
			if (view != MAIN_VIEW)
			{

			}
			else
			{
				if (!g.x)
				{
					g.visible=true;
					g.alpha=0;
					TweenLite.to(g, 0.5, {alpha: 1});
				}
				else
				{
					TweenLite.to(g, 0.5, {x: 0, ease: Cubic.easeOut});
				}
			}
		}

		protected function itemSelectHandler(event:Event):void
		{
			var ni:NativeMenuItem=event.target as NativeMenuItem;
			var vo:MenuVO=ni.data as MenuVO;
			if (vo.view)
				viewDic[vo.view] ? switchView(vo.view) : addView(vo.view);
			else
				dispatchEvent(new ODataEvent(vo.command));
		}

		private function getNativeMenuItem(vo:MenuVO):NativeMenuItem
		{
			var nm:NativeMenuItem=new NativeMenuItem(vo.label);
			nm.data=vo;
			nm.addEventListener(Event.SELECT, itemSelectHandler);
			nm.keyEquivalent=vo.key;
			nm.keyEquivalentModifiers=[Keyboard.CONTROL];
			return nm;
		}

		public function resize():void
		{
			for (var key:String in viewDic)
			{
				var g:Group=viewDic[key];
				g.width=mainView.width;
				g.height=mainView.height;
			}
		}
	}
}
