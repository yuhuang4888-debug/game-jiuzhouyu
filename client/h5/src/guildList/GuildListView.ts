
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { GuildEvent, GuildModel } from "../commonModel/GuildModel"
import { MainFunc } from "../commonModel/MainUIModel"
import { TaskModel } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SetLocalScale, Util } from "../util/Util"
import { GuildListItem } from "./GuildListItem"
import { GuildListTopItem } from "./GuildListTopItem"
import { BaseWindowComponent } from "../common/BaseWindowComponent"

export class GuildListView extends BaseView1 {
	Clear
	CreateDsgtItems
	CreatArrow
	InitEvent
	LoadSuccess
	UpdateView
	destroy_callback
	destroy_imm
	is_center
	loop_mgr
	top_list
	use_background

	public constructor() {
		super()


		this.base_file = "guildList"
		this.layout_file = "GuildListView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose=true
		this.is_center = true
		let _model = GuildModel.GetInstance()
		let local_GuildEvent = GuildEvent
		let local_GuildModel = GuildModel
		let local_Util = Util
		this.preload_server_config = { "config_dsgt": false }
		let _ac_top_ = null
		let _ac_item_ = null
		let _data_list_ = null
		let _dsgt_list_ = [306001, 306002, 306003]
		let _dsgt_scales_ = [1.5, 1.3, 1.2]
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg2, GameResPath.GetIcon("guildList", "uigong_001"))
			this.InitEvent()
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.Clear = () => {
			// if (!_model.apply_red_mark) {
			// 	_model.apply_red_mark = true
			// 	_model.Fire(local_GuildEvent.UPDATE_BASE_RED_STATUS)
			// 	GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild)
			// }
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			if (this.top_list) {
				for (let _ in this.top_list) {
					var v = this.top_list[_]
					v.DeleteMe()
					v = null
				}
				this.top_list = null
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_build, () => {
				if (local_GuildModel.IsHasGuild()) {
					Message.show("您当前已有所属结社")
					return
				}
				_model.Fire(local_GuildEvent.OPEN_VIEW, "GuildBuildView")
			}
				, this, true)
			Util.AddClickEvent(this._btn_apply, () => {
				if (local_GuildModel.IsHasGuild()) {
					Message.show("您当前已有所属结社")
					return
				}
				_model.Fire(local_GuildEvent.REQUEST_PROTO, 40003)
				let task = TaskModel.GetInstance().GetMainLineTaskVo()
				if (task && task.task_id == 101080) {
					this.Close()
				}
			}
				, this, true)
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

			this.BindEvent(_model, local_GuildEvent.UPDATE_JION_LIST, (list?) => {
				_data_list_ = list
				this.UpdateView(list)
			}
			)
		}

		this.LoadSuccess = () => {
			if (this.task_model.MainTaskIsJoinGuildTaskType()) {
				let main_line_vo = this.task_model.GetMainLineTaskVo()
				if (main_line_vo && !this.task_model.IsAllStepFinish(main_line_vo.task_id)) {
					this.task_model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30008)
				}
			}

			_model.Fire(local_GuildEvent.REQUEST_PROTO, 40001, "shh", "", 999, 1)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("guildList", "uigong_014"))

			this.CreateDsgtItems()
		}

		this.UpdateView = (list?) => {

			table.sort(list, (a?, b?) => {
				return b.combat_power < a.combat_power
			})

			//let top_list = list.splice(0, 3)
			//let i = top_list.length
			//do {
			//table.insert(top_list, null)
			//i=i+1
			//} while ((i < 3))

			//_ac_top_.source = top_list

			if (!this.top_list) {
				this.top_list = []
			}
			for (let i = 0; i < 3; i++) {
				let item = this.top_list[i]
				if (!item) {
					item = new GuildListTopItem(this._dg_top)
					item.Load()
					this.top_list[i] = item
				}
				item.SetData(list[i])
			}
			let task = TaskModel.GetInstance().GetMainLineTaskVo()
			if (task && task.task_id == 101080)
				this.CreatArrow(list)
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, GuildListItem, list, LoopScrCon.Vertical)
			} else {
				this.loop_mgr.replaceAll(list)
			}
		}
		this.CreatArrow = (list) => {
			if (list && Util.TableSize(list) > 0) {
				let setp_cfg = { direction: 2, text: "向所有结社发出申请吧！", effect_scaleX: 0.65, effect_scaleY: 0.9 }
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._btn_apply, "Activity", null, null, null, null, setp_cfg)
			}
			else {
				let step = { "direction": 6, "text": "现在没有可以申请的结社，请稍后再来～", effect_scaleX: 0.3, effect_scaleY: 1 }
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._btn_close, "Activity", null, null, null, null, step, true)
			}
		}

		this.CreateDsgtItems = () => {

			let i = 0
			let _cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dsgt", false)
			do {

				let dsgt = _cfg[_dsgt_list_[i]]
				if (dsgt) {
					if (dsgt.type == 1) {
						this["dsgt" + i].width = 720
						this["dsgt" + i].height = 1280
						this["dsgt" + i].mouseThrough = true
						this["dsgt" + i].mouseEnabled = false

						this.ClearUIEffect(this["dsgt" + i])
						this.AddUIEffect(dsgt.resource_id, this["dsgt" + i])
						//this.AddUIEffect2(dsgt.resource_id, this["transdsgt" + i], null, {x=1.5, y=1.5}, true)//{x=this["dsgt" + i].width / 2, y=this["dsgt" + i].height / 2}
					} else {

						let img = new Laya.Image()
						this["dsgt" + i].addChild(img)
						img.centerX = img.centerY = 0
						let url = GameResPath.GetDesignImage(dsgt.resource_id)
						ResManager.GetInstance().SetOutsideImageSprite(this, img, url, true)
					}
				}
				i = i + 1
			} while ((i < 3))

		}


	}

	public DeleteMe() {
		let i = 0
		do {
			// [ts2lua]this下标访问可能不正确
			if (this["dsgt" + i]) {
				// [ts2lua]this下标访问可能不正确
				this.ClearUIEffect(this["dsgt" + i])
			}
			i = i + 1
		} while ((i < 3))
		super.DeleteMe()
	}



	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	dsgt0: Laya.Box
	dsgt1: Laya.Box
	dsgt2: Laya.Box
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image8: Laya.Image
	_Image9: Laya.Image
	_Image10: Laya.Image
	_Image11: Laya.Image
	_Image12: Laya.Image
	_Image13: Laya.Image
	_Image14: Laya.Image
	_btn_close: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_Label3: Laya.Label
	_Label4: Laya.Label
	_btn_build: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_btn_apply: Laya.Box
	_Image111: Laya.Image
	labelDisplay1: Laya.Label
	Content: Laya.List
	_dg_top: Laya.HBox
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this.dsgt0,
			this.dsgt1,
			this.dsgt2,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image8,
			this._Image9,
			this._Image10,
			this._Image11,
			this._Image12,
			this._Image13,
			this._Image14,
			this._btn_close,
			this._Label1,
			this._Label2,
			this._Label3,
			this._Label4,
			this._btn_build,
			this._Image1,
			this.labelDisplay,
			this._btn_apply,
			this._Image111,
			this.labelDisplay1,
			this.Content,
			this._dg_top,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"dsgt0",
				"dsgt1",
				"dsgt2",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image8",
				"_Image9",
				"_Image10",
				"_Image11",
				"_Image12",
				"_Image13",
				"_Image14",
				"_btn_close",
				"_Label1",
				"_Label2",
				"_Label3",
				"_Label4",
				"_btn_build",
				"_Image1",
				"labelDisplay",
				"_btn_apply",
				"_Image111",
				"labelDisplay1",
				"Content",
				"_dg_top",
			])
	}
}
window["GuildListView"] = GuildListView