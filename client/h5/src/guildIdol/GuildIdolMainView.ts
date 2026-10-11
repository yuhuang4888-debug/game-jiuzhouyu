import { BaseItem1 } from "../common/BaseItem1"
import { CommonManager } from "../common/CommonManager"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { table } from "../common/table"
import { GuildModel, GuildIdolTab, GuildEvent } from "../commonModel/GuildModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GuildIdolMainAct } from "./GuildIdolMainAct"
import { GuildIdolMainAwaken } from "./GuildIdolMainAwaken"
import { GuildIdolMainItem } from "./GuildIdolMainItem"
import { GuildIdolMainRune } from "./GuildIdolMainRune"
import { GuildIdolMainTab } from "./GuildIdolMainTab"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"

export class GuildIdolMainView extends BaseItem1 {
	InitEvent
	LoadSuccess
	Local_DeleteMe
	Scr_Scroller1
	Scr_Scroller2
	initTab
	initView
	intiItem
	itemTouch
	tabTouch

	public constructor(parent?) {
		super(parent)


		this.base_file = "guildidol"
		this.layout_file = "GuildIdolMainView"
		this.layer_value = Enum_UILayer.UI
		let _model = GuildModel.GetInstance()
		let _tab_ac:LoopScrowViewMgr = null
		let _item_ac:LoopScrowViewMgr = null
		let select_item_index = 0
		let view_dic = []
		let show_view = null
		this.preload_server_config = { "config_guild_prestige": false }

		this.load_callback = () => {

			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {

		}

		this.LoadSuccess = () => {
			this.initTab()
			this.intiItem()
			this.initView()
		}

		this.Local_DeleteMe = () => {
			if (_tab_ac) {
				_tab_ac.DeleteMe()
				_tab_ac = null
			}
			if (_item_ac) {
				_item_ac.DeleteMe()
				_item_ac = null
			}
			for (let key in view_dic) {

				let view = view_dic[key]
				if (view) {
					view.DeleteMe()
				}
			}
			view_dic = []
			_model.idol_select_tab = GuildIdolTab.ACT-1
			_model.select_item = 0
		}

		this.initTab = () => {
			let data = [GuildIdolTab.ACT, GuildIdolTab.AWAKEN]
			if (CommonManager.GetInstance().CheckFuncOpenState("GuildIdolMainRune")) {
				table.insert(data, GuildIdolTab.RUNE)
			}
			if (!_tab_ac) {
				_tab_ac = new LoopScrowViewMgr(this.layer_value)
				_tab_ac.SetData(this._tab_list, GuildIdolMainTab, data, LoopScrCon.Horizontal, 1, (index?) => {
				this.tabTouch(index)
				})
				_tab_ac.SetSelectIndex(_model.idol_select_tab)
			} else {
				_tab_ac.replaceAll(data)
			}
		}

		this.tabTouch = (index?) => {
			if (_model.idol_select_tab == index) {
				return
			}
			if (_model.getIdolLv(_model.select_item) <= 0) {
				this._item_list.selectedIndex = select_item_index
				Message.show("请先激活武魂")
				_tab_ac.SetSelectIndex(_model.idol_select_tab)
				return
			}
			_model.idol_select_tab = index
			this.initView()
		}

		this.intiItem = () => {
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god
			let data = []
			for (let key in cfg) {
				let element = cfg[key]
				table.insert(data, element)
			}
			if (!_item_ac) {
				_item_ac = new LoopScrowViewMgr(this.layer_value)
				_item_ac.SetData(this._item_list, GuildIdolMainItem, data, LoopScrCon.Horizontal, 1, (index?) => {
					this.itemTouch(data[index])
				})
				_model.select_item = data[0].god_id
				_item_ac.SetSelectIndex(select_item_index)
			} else {
				_item_ac.replaceAll(data)
			}
		}

		this.itemTouch = (data?) => {
			if (select_item_index == this._item_list.selectedIndex) {
				return
			}
			let con_list = JSON.parse(data.condition)
			//_model:checkGodCondition(item.data)
			if (con_list.length > 0) {
				for (let key in con_list) {

					let condition = con_list[key]
					if (condition[0] == "guild_title_lv") {
						let value = Number(condition[1])
						let guild_title_lv = _model.idol_view_info&&_model.idol_view_info.guild_title_lv||999999
						if (Number(guild_title_lv) < value) {
							let pre_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_guild_prestige", false)
							let cfg = pre_cfg[value]
							Message.show(`历史最高结社头衔达到${cfg.title_name}可解锁`)
							_item_ac.SetSelectIndex(select_item_index)
							return
						}
					}
					if (condition[0] == "role_lv") {
						let value = Number(condition[1])
						let role_lv = RoleManager.GetInstance().GetMainRoleVo().level
						if (role_lv < value) {
							Message.show("人物等级不足")
							_item_ac.SetSelectIndex(select_item_index)
							return
						}
					}
					if (condition[0] == "guild_lv") {
						let value = Number(condition[1])
						let guild_lv = _model.GetGuildLv()
						if (guild_lv < value) {
							Message.show("结社等级不足")
							_item_ac.SetSelectIndex(select_item_index)
							return
						}
					}
					if (condition[0] == "open_day") {
						let value = Number(condition[1])
						let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
						if (open_day < value) {
							Message.show("开服天数不足")
							_item_ac.SetSelectIndex(select_item_index)
							return
						}
					}
				}
			}
			select_item_index = this._item_list.selectedIndex
			_model.select_item = data.god_id
			let lv = _model.getIdolLv(_model.select_item)
			if (lv <= 0) {
				_model.idol_select_tab = GuildIdolTab.ACT-1
				_tab_ac.SetSelectIndex(_model.idol_select_tab)
			}
			this.initView()
		}

		this.initView = () => {
			if (show_view) {
				show_view.SetVisible(false)
			}

			let view = view_dic[_model.idol_select_tab]
			if (!view) {
				if (_model.idol_select_tab+1 == GuildIdolTab.ACT) {
					view = new GuildIdolMainAct(this._gp_view)
					view.Load()
					view_dic[_model.idol_select_tab] = view
				} else if (_model.idol_select_tab+1 == GuildIdolTab.AWAKEN) {
					view = new GuildIdolMainAwaken(this._gp_view)
					view.Load()
					view_dic[_model.idol_select_tab] = view
				} else if (_model.idol_select_tab+1 == GuildIdolTab.RUNE) {
					view = new GuildIdolMainRune(this._gp_view)
					view.Load()
					view_dic[_model.idol_select_tab] = view
				}
			}
			view.updateSelect(_model.select_item)
			view.SetVisible(true)
			show_view = view
			_model.Fire(GuildEvent.IDOL_TAB_ALL_RED_UPDATE)
		}


	}

	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}


	_gp_view: Laya.Box
	_tab_list: Laya.List
	_item_list: Laya.List
	public GetComponents() {
		[
			this._gp_view,
			this._tab_list,
			this._item_list,
		]
			= this.GetChildrenByNames([

				"_gp_view",
				"_tab_list",
				"_item_list",
			])
	}
}
window["GuildIdolMainView"] = GuildIdolMainView