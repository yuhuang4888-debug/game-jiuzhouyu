import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { table } from "../common/table"
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { MainUIChatItem } from "./MainUIChatItem"
import { MainUIModel } from "../commonModel/MainUIModel"
import { SettingModel } from "../commonModel/SettingModel"
import { FriendModel } from "../commonModel/FriendModel"
import { ChatModel, ChatModelEvent, CHAT_TYPE } from "../commonModel/ChatModel"
import { PlatformManager } from "../PlatformManager"
import { MarketEvent, MarketModel } from "../commonModel/MarketModel"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { CommonManager } from "../common/CommonManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Config } from "../common/Config"
import { GameResPath } from "../util/GameResPath"
import { ShopModel } from "../commonModel/ShopModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
export class MainUIChatView extends BaseView1 {

	static MAX_SHOW_ITEM_NUM = 30
	static red_index = {
		friend: 1,
		mail: 2,
		market: 3,
		shop:4
	}

	chat_model: ChatModel

	left_item_list = []
	right_item_list = []

	platform_mgr
	public constructor() {
		super()
		this.base_file = "mainUI"
		this.layout_file = "MainUIChatView"
		this.layer_value = Enum_UILayer.Main
		this.is_delay_callback = false
		this.need_loading_view = false
		this.destroy_imm = false
		this.platform_mgr = PlatformManager.GetInstance()
		this.chat_model = ChatModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
			this._img_friend_red.visible = MainUIModel.GetInstance().friend_red
			this.display_obj.drawCallOptimize = true
		}
	}

	public LoadSuccess() {

		this.display_obj.centerX = 0
		this.display_obj.bottom = 0

		this.InitEvent()
		this.InitView()
		this.InitChat()
		this.InitSys()

		// this.UpdateMarketOpenState()
		// this.UpdateMarketIcon()
		// this.UpdateMarketRedState()
		// this.UpdateShopRedState()
	}

	public InitEvent() {
		this.BindEvent(GlobalEventSystem, EventName.GAME_START, () => {
			for (let i = 0; i < this.left_item_list.length; i++) {
				var item = this.left_item_list[i]
				if (item && !Util.IsNull(item.display_obj)) {
					item.DeleteMe()
				}
			}
			this.left_item_list = []
			for (let i = 0; i < this.right_item_list.length; i++) {
				var item = this.right_item_list[i]
				if (item && !Util.IsNull(item.display_obj)) {
					item.DeleteMe()
				}
			}
			this.right_item_list = []
			ChatModel.GetInstance().WelcomeChat()
		})

		// this.BindEvent(MarketModel.GetInstance(), MarketEvent.UPDATE_ICON, () => {
		// 	this.UpdateMarketIcon()
		// })


		// this.BindEvent(RoleManager.GetInstance().GetMainRoleVo(), EventName.CHANGE_LEVEL, (level?) => {
		// 		let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition
		// 		let person_vip_cfg = cfg["MarketBaseView"]
		// 		if (person_vip_cfg && person_vip_cfg.open_lv == level) {
		// 			this.UpdateMarketOpenState()
		// 		}
		// 	}
		// )

		Util.AddClickEvent(this._box_setting, () => {
			SettingModel.GetInstance().Fire(SettingModel.SETTING_OPEN_VIEW, "SettingView")
		}, this, true)

		Util.AddClickEvent(this._box_friend, () => {
			let friend_red = FriendModel.GetInstance().GetfriendRedDot()
			let mail_red = FriendModel.GetInstance().GetemailRedDot()
			let index = (friend_red || (!friend_red && !mail_red)) && 0 || 1
			GlobalEventSystem.Fire(EventName.OPEN_FRIEND_VIEW, { index: index })
		}, this, true)



		// Util.AddClickEvent(this._box_market, () => {
		// 	MarketModel.GetInstance().Fire(MarketEvent.OPEN_VIEW, 'MarketBaseView')
		// }, this, true)

		// Util.AddClickEvent(this._box_shop, () => {
		// 	GlobalEventSystem.Fire(EventName.OPEN_SHOP_MAIN_VIEW)
		// }, this, true)

		this.BindEvent(MainUIModel.GetInstance(), MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, (index?, red_state?) => {
			if (index == MainUIChatView.red_index.friend) {
				this._img_friend_red.visible = red_state
				// } else if (index == MainUIChatView.red_index.mail) {
				// 	this.email_red.visible = red_state
			} 
			// else if (index == MainUIChatView.red_index.market) {
			// 	this.UpdateMarketRedState()
			// } else if (index == MainUIChatView.red_index.shop) {
			// 	this.UpdateShopRedState()
			// }
		})
		this.BindEvent(MainUIModel.GetInstance(),MainUIModel.UPDATE_MAINUI_CHAT_VIEW,()=>{
			this._box_chat_con.refresh()
			this._box_sys_con.refresh()
		})

		this.BindEvent(this.chat_model, ChatModelEvent.CLEAR_ROLE_DATA, () => {
			this.InitChat()
		})

		this.BindEvent(this.chat_model, ChatModelEvent.CLICK_MAIN_ITEM, () => {
			this.toStopScroll();
		})
	}
	//停止滚动，防止出现打开界面后看到视图滑动
	private toStopScroll(){
		this._panel_chat.vScrollBar.stopScroll();
		this._panel_sys.vScrollBar.stopScroll();
	}

	public InitView() {
		let down_pos = new Vector2()
		let touchScroller = (target: Laya.Event) => {
			if(!target) return;
			if(target.type == "mousedown"){
				down_pos.x = target.stageX
				down_pos.y = target.stageY
			}else if(target.type == "mouseup"){
				if(down_pos.x != target.stageX || down_pos.y != target.stageY) return
				let channel = CHAT_TYPE.WORLD
				if (ChatModel.GetInstance().selectchannel != 10) {
					channel = ChatModel.GetInstance().selectchannel
				}
				if (target.currentTarget == this._panel_sys) {
					channel = CHAT_TYPE.SYSTEM
				}
				GlobalEventSystem.Fire(EventName.OPEN_CHAT_VIEW, channel)
				this.toStopScroll();
			}
		}

		let update = (channel?, chat?, is_del?) => {
			if (channel == CHAT_TYPE.SYSTEM) {
				this.UpdateSys(chat, is_del)
				// this.InitSys()
			} else {
				this.UpdateChat(chat, is_del)
			}
		}

		this.BindEvent(this.chat_model, ChatModelEvent.CHAT_MSG_CHANGE, update)
		this.BindEvent(this.chat_model, ChatModelEvent.CHAT_CACHE_UPDATE, () => {
			this.InitChat()
		}
		)

		let touchBoxCon = (e: Laya.Event) =>{
			e.stopPropagation()
		}
		this._box_chat_con.on(Laya.Event.MOUSE_UP, this, touchBoxCon);
		this._box_sys_con.on(Laya.Event.MOUSE_UP, this, touchBoxCon);

		this._box_chat_con.on(Laya.Event.RESIZE, this, () => {
			// this._panel_chat.vScrollBar.value = this._box_chat_con.displayHeight;
			// let bar: Laya.ScrollBar = this._panel_chat.vScrollBar;
			let h: number = this._box_chat_con.displayHeight + 5;
			this._panel_chat.vScrollBar.setScroll(0, h, h);
		});

		this._panel_sys.on(Laya.Event.MOUSE_DOWN, this, touchScroller);
		this._panel_sys.on(Laya.Event.MOUSE_UP, this, touchScroller);

		this._panel_chat.on(Laya.Event.MOUSE_DOWN, this, touchScroller);
		this._panel_chat.on(Laya.Event.MOUSE_UP, this, touchScroller);

		this._box_sys_con.on(Laya.Event.RESIZE, this, () => {
			let bar: Laya.ScrollBar = this._panel_sys.vScrollBar;
			let h: number = this._box_sys_con.displayHeight + 5;
			this._panel_sys.vScrollBar.setScroll(bar.min, h, h);
			// this._panel_sys.vScrollBar.value = this._box_sys_con.displayHeight + 5;
			// Laya.timer.once(50, this, () => {
			// 	this._panel_sys.vScrollBar.value = this._box_sys_con.displayHeight + 5;
			// })
			// this._panel_sys.vScrollBar.setScroll(bar.min, bar.max, bar.max);

		});
	}

	public InitChat() {
		if (this.is_loaded && this.chat_model) {
			let data = this.chat_model.allChat()
			let left_msg_list = []
			if (this.left_item_list && this.left_item_list.length > 0) {
				for (let i = 0; i < this.left_item_list.length; i++) {
					var item = this.left_item_list[i]
					if (item && !Util.IsNull(item.display_obj)) {
						item.DeleteMe()
					}
				}
			}
			this.left_item_list = []
			// 
			// for (let i = data.length-1; i >= 0; i -= 1) {
			for (let i = 0; i <= data.length; i++) {
				let msg = data[i]
				if (left_msg_list.length < MainUIChatView.MAX_SHOW_ITEM_NUM) {
					table.insert(left_msg_list, msg)
				}
			}
			for (let i = 0; i < left_msg_list.length; i++) {
				var msg = left_msg_list[i]
				let temp_msg = msg.msg.toString()
				let _str = ""
				let faceList: Array<string>, titlebgList: Array<string>
				[faceList, titlebgList] = ChatModel.GetInstance().getChatFace(msg);
				if (faceList && faceList.length > 0) {
					for (let i: number = 0; i < faceList.length; i++) {
						let face: string = faceList[i];
						let faceId: string = face.replace(/<f_/gi, "");
						faceId = faceId.replace(/>/gi, "");
						if (Number(faceId) > ChatModel.GetInstance().faceMax() || Number(faceId < ChatModel.GetInstance()._faceMin)) {//不合法表情id
							_str = face.replace(/<f_/gi, "/\<f_")
							_str = _str.replace(/>/gi, "/\>")
							temp_msg = temp_msg.replace(face, _str)
						}
						// _str+=face

					}
				}
				msg.msg = temp_msg// _str == "" ? msg.msg : _str
				this.left_item_list[i] = new MainUIChatItem(this._box_chat_con)
				this.left_item_list[i].Load()
				this.left_item_list[i].SetData(msg, i == left_msg_list.length)
			}
		}
	}

	public UpdateChat(vo?, is_del?) {
		if (this.is_loaded) {

			let data_arr = this.chat_model.allChat()
			let temp_arr = []
			if (data_arr.length >= MainUIChatView.MAX_SHOW_ITEM_NUM) {
				temp_arr = data_arr.slice(-MainUIChatView.MAX_SHOW_ITEM_NUM)
			} else {
				temp_arr = data_arr
			}
			for (let i = 0; i < temp_arr.length; i++) {
				let item = this.left_item_list[i]
				let msg = temp_arr[i]
				if (!item) {
					item = new MainUIChatItem(this._box_chat_con)
					this.left_item_list[i] = item
					item.Load()
				}
				item.SetData(msg, true)
			}
			//##下面的方法 和大聊天框展示的内容不同步
			//如果更新的数据是已加载的数据，直接更新item
			// let item = this.FindItemWithVo(this.left_item_list, vo)
			// if (item) {
			// 	item.SetData(vo, true)
			// 	return
			// }
			
			// let item
			// if (this.left_item_list.length >= MainUIChatView.MAX_SHOW_ITEM_NUM) {
			// 	item = table.remove(this.left_item_list, 0)[0]
			// 	if(item){
			// 		table.insert(this.left_item_list, item)
			// 		if(this._box_chat_con.numChildren > 0){
			// 			this._box_chat_con.removeChildAt(0)
			// 			this._box_chat_con.addChild(item.display_obj)
			// 		}
			// 	}else
			// 	{
			// 		return
			// 	}
			// } else {
			// 	let index = this.left_item_list.length
			// 	this.left_item_list[index] = new MainUIChatItem(this._box_chat_con)
			// 	item = this.left_item_list[index]
			// 	item.Load()
			// }

			// item.SetData(vo, true)
		}

		Laya.timer.once(50, this, () => {
			this._panel_chat.vScrollBar.stopScroll();
			let value = this._panel_chat.contentHeight >= this._panel_chat.height ? this._panel_chat.contentHeight - this._panel_chat.height : 0;
			this._panel_chat.vScrollBar.value = value 
		})
	}

	public InitSys() {
		if (this.is_loaded && this.chat_model) {
			let data = this.chat_model.sysChat()
			let right_msg_list = []
			for (let i = 0; i < data.length; i++) {
				let msg = data[i]
				if (right_msg_list.length < MainUIChatView.MAX_SHOW_ITEM_NUM) {
					table.insert(right_msg_list, msg)
				}
			}
			for (let i = 0; i < right_msg_list.length; i++) {
				var msg = right_msg_list[i]
				this.right_item_list[i] = new MainUIChatItem(this._box_sys_con)
				this.right_item_list[i].Load()
				this.right_item_list[i].SetData(msg, i == right_msg_list.length)
			}
		}
	}

	public UpdateSys(vo?, is_del?) {

		//如果更新的数据是已加载的数据，直接更新item
		let item
		if (this.right_item_list.length >= MainUIChatView.MAX_SHOW_ITEM_NUM) {
			item = table.remove(this.right_item_list, 0)[0]
			if(item){
				table.insert(this.right_item_list, item)
				if(this._box_sys_con.numChildren > 0){
					this._box_sys_con.removeChildAt(0)
					this._box_sys_con.addChild(item.display_obj)
				}
			} else {
				return
			}
		} else {
			let index = this.right_item_list.length
			this.right_item_list[index] = new MainUIChatItem(this._box_sys_con)
			item = this.right_item_list[index]
			item.Load()
		}
		item.SetData(vo, true)

		Laya.timer.once(50, this, () => {
			this._panel_sys.vScrollBar.stopScroll();
			let value = this._panel_sys.contentHeight >= this._panel_sys.height ? this._panel_sys.contentHeight - this._panel_sys.height : 0;
			this._panel_sys.vScrollBar.value = value
		})
	}


	public FindItemWithVo(list?, vo?) {

		//如果更新的数据是已加载的数据，直接更新item
		for (let key in list) {
			var item = list[key]
			if (item.data == vo) {
				return item
			}
		}
		return null
	}

	public KeepScrollBottom() {
		// if (!Util.IsNull(this)) {
		// 	// UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this.sys_list)
		// 	// UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this.chat_list)
		// 	this.left_scroll_rect.verticalNormalizedPosition = 0
		// 	this.right_scroll_rect.verticalNormalizedPosition = 0
		// }
	}

	// /**
	//  * 更新市场图标 跨服/本服
	//  */
	// public UpdateMarketIcon(){
	// 	if(MarketModel.GetInstance().kf_open){
	// 		this._img_market.skin = GameResPath.GetIcon("mainUI", "mainui_market_icon")
	// 	}
	// 	else{
	// 		this._img_market.skin = GameResPath.GetIcon("mainUI", "mainui_market_icon")
	// 	}
		
	// }

	// /**
	//  * 更新市场图标开启状态
	//  */
	// public UpdateMarketOpenState(){
	// 	let open = CommonManager.GetInstance().CheckFuncOpenState("MarketBaseView", true)
	// 	if(open){
	// 		this._box_market.visible = open
	// 	}
	// }

	// /**
	//  * 更新市场图标红点
	//  */
	// public UpdateMarketRedState(){
	// 	this._img_market_red.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.AUCTON, 1);
	// }


	// public UpdateShopRedState(){
	// 	let shop_model = ShopModel.GetInstance()
	// 	let daly_first_login  = CustomActivityModel.GetInstance().GetDayFirstLoginStatus()
	// 	let day_red = ((shop_model.limit_red_status || shop_model.Honer_red_status) && daly_first_login)
	// 		|| shop_model.diamond_red_status
	// 		//shop_model.vie_red_stutus
	// 	this._img_shop_red.visible =  day_red
	// }



_img_bg:Laya.Image
_img_bg2:Laya.Image
_img_bg3:Laya.Image
_panel_chat:Laya.Panel
_box_chat_con:Laya.VBox
_panel_sys:Laya.Panel
_box_sys_con:Laya.VBox
_box_setting:Laya.Box
_img_setting:Laya.Image
_box_friend:Laya.Box
_img_friend:Laya.Image
_img_friend_red:Laya.Image
public GetComponents() {
[
this._img_bg,
this._img_bg2,
this._img_bg3,
this._panel_chat,
this._box_chat_con,
this._panel_sys,
this._box_sys_con,
this._box_setting,
this._img_setting,
this._box_friend,
this._img_friend,
this._img_friend_red,
]
 = this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_panel_chat",
				"_box_chat_con",
				"_panel_sys",
				"_box_sys_con",
				"_box_setting",
				"_img_setting",
				"_box_friend",
				"_img_friend",
				"_img_friend_red",
			])
		this._panel_chat.vScrollBar.visible = false;
		this._panel_sys.vScrollBar.visible = false;
	}
}
 window["MainUIChatView"]= MainUIChatView