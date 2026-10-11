import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { WordManager } from "../common/WordManager"
import { GuardModel } from "../commonModel/GuardModel"
import { StoryModel } from "../commonModel/StoryModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { GuardAttrItem } from "./GuardAttrItem"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { DUN_TYPE } from "../commonModel/BaseDungeonModel"

export class GuardExperienceView extends BaseView1 {
	not_show_attr_main_msg
	not_show_main_msg

	model
	goods_model
	role_mgr
	res_mgr

	info = null
	guard_type = null
	is_active = null
	is_request = null
	cur_activate_info = null

	time
	timer = null
	goods_item = null
	attr_items = []
	guard_model = null
	cfg_kv

	public constructor() {
		super()
		this.base_file = "guard"
		this.layout_file = "GuardExperienceView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_lastView_close = true
		this.destroy_imm = true
		this.preload_server_config = {
			"config_magic_circle": false,
			"config_magic_circle_key_value": false
		}

		this.model = GuardModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.not_show_main_msg = true
		this.not_show_attr_main_msg = true

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.model.experice_view_open = true
			this.InitView()
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	private Remove() {
		this.model.experice_view_open = false
		if (this.time) {
			clearTimeout(this.time)
			this.time = null
		}
		if (this.guard_type == 1 && !this.is_request) {
			this.model.Fire(GuardModel.REQUEST_SCMD, 21602, "ccc", this.guard_type, 1, 0)
		}

		if (this.attr_items) {
			for (let i in this.attr_items) {
				let vo = this.attr_items[i]
				vo.DeleteMe()
			}
			this.attr_items = []
		}
		if(this._gp_activate){
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._gp_activate)
		}
	}

	private LoadSuccess() {
		this.cfg_kv = this.res_mgr.GetGameConfigFromCache(this, "config_magic_circle_key_value", false)
		//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_042, GameResPath.GetIcon("guard", "uimfz_034"), true)
		//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_040, GameResPath.GetIcon("guard", "uimfz_040"), true)
		//lua_resM:SetOutsideImageSprite(this, this._img_041, GameResPath.GetIcon("guard","uimsfz_041"))
		//this:AddUIEffect('ui_badge_glow', this._gp_effect, null, null, true)
		this.res_mgr.SetOutsideImageSprite(this, this.img_bg, GameResPath.GetIcon("guard", "ui_guard_01"))
		GlobalEventSystem.Fire(EventName.SELECT_STORY_TARGET, StoryModel.StoryTargetName.SingleDungeon, false)
		let config = this.res_mgr.GetGameConfigFromCache(this, "config_magic_circle", false)
		if (config) {
			this.info = config["0@" + this.guard_type]
		}

		let main_line_vo = this.task_model.GetMainLineTaskVo()
		if (main_line_vo && (101130 <= main_line_vo.task_id || main_line_vo.task_id <= 101150)) {
			let step_cfg = null

			step_cfg = { direction: 8, text: "增加<font color='#0a9f42'>50%</font>的<font color='#0a9f42'>经验获得</font>哦，<br>快领取体验吧~","effect_scaleX": 0.65,"effect_scaleY": 0.9 }

			if (step_cfg) {
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._gp_activate, this.layer_value, null, 20, false, false, step_cfg, true)
			}
		}

	}

	private InitEvent() {
		Util.AddClickEvent(this._gp_activate, () => {
			if (this.guard_type == 1) {
				this.is_request = true
				this.model.Fire(GuardModel.REQUEST_SCMD, 21602, "ccc", this.guard_type, 1, 0)
			} else {
				this.model.Fire(GuardModel.OPEN_VIEW, this.guard_type)
			}
			this.Close()
		}, this, true)
	}

	private InitView() {
		//this.AddUIEffect('ui_1115', this.layer_value, this._gp_effect, null, null, true)
		if (!this.info) {
			return
		}

		this.lb_name.text = this.info.name
		this._gp_activate.visible = true
		let source = (this.guard_type == 1 && ("ui_guard_03") || ("ui_guard_04"))
		this.res_mgr.SetImageSprite(this, this.img_title, "guard", source)

		//let label = this._gp_activate.getChildAt(1)
		//label.text = (guard_type == 1 && ("立即体验") || ("立即激活"))

		this.click_bg_toClose = this.guard_type == 1 ? false : true
		this.lb_hit.visible = this.guard_type == 1 ? false : true
		this.ShowAttr()
		this.ShowGuardModel()
	}

	private ShowGuardModel() {
		let cfg_kv = this.cfg_kv
		if (!cfg_kv) {
			return
		}
		let id = (this.guard_type == 1 && (cfg_kv.high_magic_circle_id.value) || (cfg_kv.low_magic_circle_id.value))
		let y = 3
		let scale = 1.5
		//let y = (this.guard_type == 1 && (-400) || (-300))
		let data = {
			res_id: id,
			clothe_res_id: id,
			type: UI_MODEL_TYPE.GUARD,
			can_rotate: true,
			layer_value: this.layer_value,
			scale : scale,
			position: new Vector2(0, y),
			//rotate = pos_cfg.rotate,
			texture_size: new Vector2(300, 400),
			//action_name_list = action_list,
		}
		this.res_mgr.SetRoleModel(this, this.gp_model, data)
	}

	private ShowAttr() {
		if (!this.info) {
			return
		}
		let attr = JSON.parse(this.info.attr)
		let num = 0
		for (let i in attr) {
			let value = Number(attr[i][1]) / 100
			if (Number(attr[i][0]) == 202) {
				this.res_mgr.SetImageSprite(this, this.img_attr, "guard_asset", "uimfz_027")
				this.res_mgr.SetImageSprite(this, this.img_attrNum, "guard_asset", "uimfz_" + value, true)
			} else if (Number(attr[i][0]) == 10) {
				this.res_mgr.SetImageSprite(this, this.img_attr, "guard_asset", "uimfz_036")
				this.res_mgr.SetImageSprite(this, this.img_attrNum, "guard_asset", "uimfz_" + value, true)
			} else {
				let name = WordManager.GetProperties(attr[i][0])
				let value = WordManager.ConvertToPercentValue(attr[i][0], attr[i][1])

				let item = this.attr_items[i]
				if (!item) {
					item = new GuardAttrItem(this.gp_attr)
					item.Load()
					this.attr_items[i] = item
				}
				item.SetData([name, value])
			}
		}
		//LayoutRebuilder(this._gp_attr)
		//if (! this.time ) {
		//this.time = setTimeout(() => {
		//if (this.use_delete_method ) { return }
		//if (this.time ) {
		//clearTimeout(this.time)
		//this.time = null
		//}
		//if (this._gp_attr.numChildren > 1 ) {
		//
		for (let i = 1; i <= this.gp_attr.numChildren; i += 1) {
			//let label = this._gp_attr.GetChild(i-1)
			//LayoutRebuilder(label)
			//}
			//LayoutRebuilder(this._gp_attr)
			//}
			//},0.5)
			//}
		}
	}

	public SetGuardType(type?) {
		this.guard_type = type
	}

	btn_close: Laya.Image
	img_bg: Laya.Image
	img_title: Laya.Image
	img_nameBg: Laya.Image
	lb_name: Laya.Label
	img_line: Laya.Image
	gp_attr: Laya.VBox
	img_attr: Laya.Image
	img_attrNum: Laya.Image
	lb_hit: Laya.Label
	gp_effect: Laya.Box
	gp_model: Laya.Box
	_gp_good_info: Laya.Box
	_gp_goods: Laya.Box
	_lb_goods_name: Laya.HTMLDivElement
	_lb_goods_num: Laya.HTMLDivElement
	_lb_time: Laya.Label
	_gp_btn: Laya.Box
	_Image4: Laya.Image
	_lb_btn: Laya.Label
	_img_red: Laya.Image
	_gp_activate_info: Laya.Box
	_lb_timeDown: Laya.Label
	_gp_btn_show: Laya.Box
	_img_show_btn: Laya.Image
	_lb_show_btn: Laya.Label
	_gp_activate: Laya.Box
	_Image5: Laya.Image
	_Label1: Laya.Label
	public GetComponents() {
		[
			this.btn_close,
			this.img_bg,
			this.img_title,
			this.img_nameBg,
			this.lb_name,
			this.img_line,
			this.gp_attr,
			this.img_attr,
			this.img_attrNum,
			this.lb_hit,
			this.gp_effect,
			this.gp_model,
			this._gp_good_info,
			this._gp_goods,
			this._lb_goods_name,
			this._lb_goods_num,
			this._lb_time,
			this._gp_btn,
			this._Image4,
			this._lb_btn,
			this._img_red,
			this._gp_activate_info,
			this._lb_timeDown,
			this._gp_btn_show,
			this._img_show_btn,
			this._lb_show_btn,
			this._gp_activate,
			this._Image5,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"btn_close",
				"img_bg",
				"img_title",
				"img_nameBg",
				"lb_name",
				"img_line",
				"gp_attr",
				"img_attr",
				"img_attrNum",
				"lb_hit",
				"gp_effect",
				"gp_model",
				"_gp_good_info",
				"_gp_goods",
				"_lb_goods_name",
				"_lb_goods_num",
				"_lb_time",
				"_gp_btn",
				"_Image4",
				"_lb_btn",
				"_img_red",
				"_gp_activate_info",
				"_lb_timeDown",
				"_gp_btn_show",
				"_img_show_btn",
				"_lb_show_btn",
				"_gp_activate",
				"_Image5",
				"_Label1",
			])
	}
}
window["GuardExperienceView"] = GuardExperienceView