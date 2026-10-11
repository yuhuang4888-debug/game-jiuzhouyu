import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { Util } from "../util/Util"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { SceneManager } from "../scene/SceneManager"
import { MainUIFightModeItem } from "./MainUIFightModeItem"
import { TimeUtil } from "../util/TimeUtil"
import { MainUIModel } from "../commonModel/MainUIModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { PkStatusModel } from "../commonModel/PkStatusModel"
// TypeScript file
export class MainUIFightModeView extends BaseView1 {
	mode_item_list
	pk_status
	time_event_id
	peace_cd_is_playing
	pk_state_to_index

	constructor() {
		super()
		this.base_file = "mainUI"
		this.layout_file = "MainUIFightModeView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.background_alpha = 0
		this.destroy_imm = true
		// this.show_open_movie = true

		this.load_callback = function () {
			this.LoadSuccess()
		}

		this.close_callback = function () {
			this.Remove()
		}
	}

	private InitEvent() {
		
		this.BindEvent(PkStatusModel.GetInstance(), PkStatusModel.CHANGE_SUCCESS,(event_name, pk_status) => {
			Message.show("切换成功")
			this.Close()
		})

		this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "peace_cd_time", (event_name, peace_cd_time) => {
			this.peace_cd_is_playing = true
			this.StartTime(peace_cd_time)
		})

		this.BindEvent(GlobalEventSystem, EventName.STATE_RESET_SIZE,(width, height)=>{
			this.UpdatePos()
		})
	}

	LoadSuccess() {

		this.InitEvent()
		// let liu_hai_height = Util.GetLiuhaiHeight()
		// if (liu_hai_height) {
		// 	this.display_obj.y = 102 + liu_hai_height
		// }
		// else {
			this.display_obj.y = 102 + Util.GetLiuhaiHeight()
		// }
		// this.horizontalCenter = 150

		this.UpdatePos()

		if (!this.mode_item_list)
			this.mode_item_list = []
		if (!this.pk_state_to_index)
			this.pk_state_to_index = {}


		let click_func = (index) => {
			if (this.peace_cd_is_playing) {
				Message.show("冷却中")
			}
			else {
				PkStatusModel.GetInstance().Fire(PkStatusModel.CHANGE_PK_STATUS, index)
			}
		}

		let scene_info = SceneManager.GetInstance().GetSceneInfo()
		let cond = scene_info && JSON.parse(scene_info.requirement)
		let list
		if (cond) {
			for (let key in cond) {
				let value = cond[key]
				if (value && value.type == "pkstate_list") {
					list = value.attr
				}
			}
		}
		// list = [0,1,2,3,4]
		if (!list)
			list = []
		let len = list.length
		for (let i = len; i < this.mode_item_list.length; i++) {
			this.mode_item_list.visible = false
		}
		this.display_obj.height = len * 43 + 44
		// this._Scroller1.height = len * 43
		for (let index in list) {
			let item = this.mode_item_list[index]
			let pk_state = list[index]
			if (!item) {
				item = new MainUIFightModeItem(this._gp_item)
				this.mode_item_list.push(item)
				item.Load()
				item.SetPosition(0,(Number(index) - 1) * 43)
			}
			item.SetData(PkStatusModel.FightModeInfo[pk_state], click_func)
			this.pk_state_to_index[pk_state] = index
		}
		this.SetPkState(RoleManager.GetInstance().GetMainRoleVo().pk_status)
	}

	UpdatePos(){
		this.display_obj.x = LayerManager.GetInstance().stageWidth / 2 - 720 /2 + 90
	}
	
	private SetPkState(pk_status) {
		if (this.pk_status == pk_status)
			return
		if (!this.pk_state_to_index)
			return
		let old_index = this.pk_state_to_index[this.pk_status]
		let old = this.mode_item_list[old_index]
		if (old) {
			old.SetSelect(false)
		}
		let now_index = this.pk_state_to_index[pk_status]
		let now = this.mode_item_list[now_index]
		if (now) {
			now.SetSelect(true)
		}
		this.pk_status = pk_status
	}

	public Remove() {
		if (this.mode_item_list) {
			for (let obj of this.mode_item_list) {
				obj.DeleteMe()
			}
			this.mode_item_list = null
		}
		this.CancelTime()
		this.pk_state_to_index = null
		this.peace_cd_is_playing = false
		this.pk_status = null
	}
	private StartTime(time) {
		this.CancelTime()
		this._end_time = time + TimeUtil.getServerTime()
		this.time_event_id = true
		Laya.timer.frameLoop(1, this, this.OnTime)
		this.OnTime()
	}

	private _end_time
	public OnTime = () => {
		let left_time = this._end_time - TimeUtil.getServerTime()
		if (left_time < 0) {
			this.peace_cd_is_playing = false
			this.Close()
			return
		}
	}

	private CancelTime() {
		if (this.time_event_id) {
			Laya.timer.clear(this, this.OnTime)
			// this.time_event_id.stop()
			// this.time_event_id.removeEventListener(Laya.TimerEvent.TIMER, this.OnTime, this)
			this.time_event_id = undefined
		}
	}

	image1: Laya.Image
	image2: Laya.Image
	label1: Laya.Label
	_gp_item: Laya.VBox
	public GetComponents() {
		[
			this.image1,
			this.image2,
			this.label1,
			this._gp_item,
		]
			= this.GetChildrenByNames([

				"image1",
				"image2",
				"label1",
				"_gp_item",
			])
	}
}
window["MainUIFightModeView"] = MainUIFightModeView