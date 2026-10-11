import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { GlobalTimerQuest, NotEnougnDiamond } from "../util/Util"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Alert, Alert_Type } from "../alert/Alert"
import { WordManager } from "../common/WordManager"
import { TimeUtil } from "../util/TimeUtil"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { ColorUtil } from "../util/ColorUtil"
import { Vector2 } from "../util/Vector2"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { GuardModel } from "../commonModel/GuardModel"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { GuardAttrItem } from "./GuardAttrItem"
import { TaskTipType } from "../commonModel/TaskModel"
import { DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { GameResPath } from "../util/GameResPath"
import { PlatformManager } from "../PlatformManager"

export class GuardMainView extends BaseView1 {
	not_show_attr_main_msg
	not_show_main_msg

	model
	goods_model
	role_mgr
	res_mgr

	info = null
	guard_type = null
	is_active = null
	cur_activate_info

	time
	timer = null
	attr_items = []
	goods_item = null
	guard_model = null
	cfg_kv

	public constructor() {
		super()
		this.base_file = "guard"
		this.layout_file = "GuardExperienceView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.is_lastView_close = false
		this.destroy_imm = true
		this.preload_server_config = {
			"config_magic_circle_key_value": false
		}

		this.model = GuardModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.not_show_main_msg = true
		this.not_show_attr_main_msg = true

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.InitView()
			this.InitEvent()
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	private Remove() {
		if (this.attr_items) {
			for (let i in this.attr_items) {
				let vo = this.attr_items[i]
				vo.DeleteMe()
			}
			this.attr_items = []
		}
		
		this.ClearModel()
		if (this.goods_item) {
			this.goods_item.DeleteMe()
			this.goods_item = null
		}

		this.ClearTimer()

		if (this.time) {
			clearTimeout(this.time)
			this.time = null
		}
		if(this._gp_btn_show){
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._gp_btn_show)
		}
	}

	private ClearTimer() {
		if (this.timer) {
			GlobalTimerQuest.CancelQuest(this.timer)
			this.timer = null
		}
	}

	private ClearModel() {
		if (this.guard_model) {
			this.guard_model.DeleteMe()
			this.guard_model = null
		}
	}

	private LoadSuccess() {
		this.cfg_kv = this.res_mgr.GetGameConfigFromCache(this, "config_magic_circle_key_value", false)
		this.res_mgr.SetOutsideImageSprite(this, this.img_bg, GameResPath.GetIcon("guard", "ui_guard_01"))

		if(PlatformManager.IsEyouPlatform()){
			this._lb_goods_name.style.fontSize = 20
			this._lb_goods_name.style.width = 200
		}else{
		this._lb_goods_name.width = 125
		this._lb_goods_name.style.fontSize = 24
		}
		this._lb_goods_name.style.color = "#663915"

		this._lb_goods_num.width = 125
		this._lb_goods_num.style.fontSize = 20
		this._lb_goods_num.style.color = "#ff4f50"

		let main_line_vo = this.task_model.GetMainLineTaskVo()
		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.FinDunType) && main_line_vo) {
			let step_cfg = null
			if (main_line_vo.id == DUN_TYPE.Exp) {
				//step_cfg = {direction : 8, text : "立即体验"}
			} else if (main_line_vo.id == DUN_TYPE.Boss_Guide_Two) {
				step_cfg = {direction : 8, text : "增加<font color='#FFFF00'>50%</font>的<font color='#FFFF00'>经验获得</font>哦，<br>快领取体验吧~","effect_scaleX": 0.65,"effect_scaleY": 0.9}
			}
			if (step_cfg) {
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._gp_btn_show, this.layer_value, null, null, false, false, step_cfg,true)
			}
		}
	}

	private InitEvent() {
		if (!this.info) {
			return
		}

		Util.AddClickEvent(this.btn_close, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this._gp_btn, () => {
			if (this.is_active) {
				Message.show("已激活该守护")
				return
			}
			let info_cost_asset = JSON.parse(this.info.cost)
			let basic = this.goods_model.GetGoodsBasicByTypeId(info_cost_asset[0][1][0][1])
			let have_num = this.goods_model.GetTypeGoodsNum(info_cost_asset[0][1][0][1])
			if (have_num < Number(info_cost_asset[0][1][0][2]) && basic && !Util.IsTableEmpty(info_cost_asset[1][1]) && !Util.IsTableEmpty(info_cost_asset[2][1])) {
				if (Number(info_cost_asset[1][1][0][2]) <= this.role_mgr.mainRoleInfo.jinLock) {
					let str = "激活需要消耗<font color='#0a953e'>" + info_cost_asset[1][1][0][2] + "</font>绑玉，是否激活？"
					let ok_callback = () => {
						this.model.Fire(GuardModel.REQUEST_SCMD, 21602, "ccc", this.guard_type, 0, 1)
					}
					Alert.Show(Util.StrToHTML(str), Alert_Type.Two, ok_callback)
				} else {
					let ok_callback = () => {
						if (Number(info_cost_asset[2][1][0][2]) > this.role_mgr.mainRoleInfo.jin) {
							NotEnougnDiamond()
							return
						}
						this.model.Fire(GuardModel.REQUEST_SCMD, 21602, "ccc", this.guard_type, 0, 2)
					}
					/*
					let str = ""
					if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
						str = "Ada kekurangan <font color=0x0a953e>" + info_cost_asset[1][1][0][2] + " berlian terikat</font>, gunakan <font color=0x0a953e>" + info_cost_asset[2][1][0][2] + "</font> berlian utk aktivasi?"
					} else {
						str = "绑钻不足<font color=0x0a953e>" + info_cost_asset[1][1][0][2] + "</font>,是否直接花费<font color=0x0a953e>" + info_cost_asset[2][1][0][2] + "</font>勾玉激活"
					}
					*/
					let str = "绑玉不足<font color='#0a953e'>" + info_cost_asset[1][1][0][2] + "</font>,是否直接花费<font color='#0a953e'>" + info_cost_asset[2][1][0][2] + "</font>勾玉激活？"
					Alert.Show(Util.StrToHTML(str), Alert_Type.Two, ok_callback)
					Alert.SetIsCharge(true)
				}
				return
			} else if (have_num >= Number(info_cost_asset[0][1][0][2])) {
				this.model.Fire(GuardModel.REQUEST_SCMD, 21602, "ccc", this.guard_type, 0, 0)
			}
		}, this, true)

		Util.AddClickEvent(this._gp_btn_show, () => {
			this.model.Fire(GuardModel.REQUEST_SCMD, 21605, "cc", this.guard_type, (this.cur_activate_info.show == 0 && (1) || (0)))
		}, this, true)

		this.BindEvent(this.model, GuardModel.UPDATA_VIEW, () => {
			this.UpdataActivateStatus()
			this.RefreshGoodsNum()
		})
	}

	private InitView() {
		let config = this.res_mgr.GetGameConfigFromCache(this, "config_magic_circle", false)
		if (!config) {
			return
		}

		let type = this.guard_type
		let info = config["0@" + type]
		this.info = info
		if (!info) {
			return
		}

		this.UpdataActivateStatus()
		/*
		this.AddUIEffect('ui_1115', this.layer_value, this._gp_effect, null, null, true)
		*/

		this.ClearTimer()

		//ResManager.GetInstance().SetImageSprite(this, this._img_name, "guard_asset", "uimfz_name" + type)
		this.lb_name.text = info.name
		this._lb_time.text = (info.last_day >= 365 * 2 && ("永久有效") || (info.last_day + "天有效期"))

		this.CreateGoods()
		this.ShowAttr()
		this.ShowGuardModel()
	}

	private ShowGuardModel() {
		let cfg_kv = this.cfg_kv
		if (!cfg_kv) {
			return
		}
		let type = this.guard_type
		let id = null
		let y = 3
		let scale = 1.5
		if (1 == type) {
			id = cfg_kv.high_magic_circle_id && cfg_kv.high_magic_circle_id.value
		} else if (2 == type) {
			id = cfg_kv.low_magic_circle_id && cfg_kv.low_magic_circle_id.value
		} else if (3 == type) {
			id = cfg_kv.naughty_devil_figure && cfg_kv.naughty_devil_figure.value
		} else if (4 == type) {
			id = cfg_kv.guardian_angel_figure && cfg_kv.guardian_angel_figure.value
		}
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
		let attr = JSON.parse(this.info.attr)
		//let num = 0
		for (let i in attr) {
			let value = Number(attr[i][1]) / 100
			if (Number(attr[i][0]) == 202) {
				this.res_mgr.SetImageSprite(this, this.img_attr, "guard_asset", "uimfz_027")
				this.res_mgr.SetImageSprite(this, this.img_attrNum, "guard_asset", "uimfz_" + value, true)
			} else if (Number(attr[i][0]) == 10) {
				this.res_mgr.SetImageSprite(this, this.img_attr, "guard_asset", "uimfz_025")
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
			//},0.3)
			//}
		}
	}

	private CreateGoods() {
		let info = this.info
		if (!info || !info.cost) {
			return
		}

		let info_cost_asset = JSON.parse(info.cost)
		let basic = this.goods_model.GetGoodsBasicByTypeId(info_cost_asset[0][1][0][1])
		this._lb_goods_name.innerHTML = Util.StrToHTML("<font color=" + ColorUtil.GetColorDark(basic.color) + ">" + basic.goods_name + "</font>")
		this.RefreshGoodsNum()

		if (!this.goods_item) {
			this.goods_item = new BaseAwardItem(this._gp_goods)
			this.goods_item.SetItemSize(70, 70)
			this.goods_item.Load()
		}
		this.goods_item.ExcuteCallback(() => {
			this.goods_item.SetData(info_cost_asset[0][1][0][1])
		})
	}

	private RefreshGoodsNum() {
		let info = this.info
		if (!info || !info.cost) {
			return
		}
		let info_cost_asset = JSON.parse(info.cost)
		let color = (this.goods_model.GetTypeGoodsNum(info_cost_asset[0][1][0][1]) >= Number(info_cost_asset[0][1][0][2]) && ("#0a953e") || ("#ff4f50"))
		let str = Util.StrToHTML("<font color='" + color + "'>" + this.goods_model.GetTypeGoodsNum(info_cost_asset[0][1][0][1]) + "/" + info_cost_asset[0][1][0][2] + "</font>")
		this._lb_goods_num.innerHTML = str
	}

	private UpdataActivateStatus() {
		this.is_active = false
		if (this.model.info) {
			for (let _tmpi in this.model.info) {
				var v = this.model.info[_tmpi]
				if (v.lv == this.guard_type && v.status == 1) {
					this.is_active = true
					this.cur_activate_info = v
					break
				}
			}
			this.ShowActivateInfo(this.is_active, this.cur_activate_info)
		}
	}

	private ShowActivateInfo(is_activa?, info?) {
		this._gp_good_info.visible = !is_activa
		this._gp_activate_info.visible = is_activa

		if (is_activa) {
			//场景中不显示守护了，隐藏按键
			this._gp_btn_show.visible = false
			//this._lb_show_btn.text = (cur_activate_info_.show == 0 && ( "显示" ) || ( "隐藏" ) )
			//this._lb_show_btn.GetComponent("Outline").effectColor = cur_activate_info_.show == 0 && Color(225/255,116/255,58/255,128/255) || Color(99/255,156/255,18/255,128/255)
			//lua_resM:SetImageSprite(this,this._img_show_btn,"common_asset",cur_activate_info_.show == 0 && "com_rect_btn12" || "com_rect_btn13")
			let info = this.info
			if (!info) {
				return
			}
			if (info.last_day >= 365 * 2) {
				this._lb_timeDown.text = "永久有效"
			} else {
				let timer_func = () => {
					if (!this.cur_activate_info) {
						this._lb_timeDown.text = ""
						return
					}
					let left_time = this.cur_activate_info.end_time - TimeUtil.getServerTime()
					if (left_time > 0) {
						this._lb_timeDown.text = "剩余：" + TimeUtil.timeConvert(left_time, "dd-hh/hh-mm/mm-ss")
					} else {
						this._gp_good_info.visible = true
						this._gp_activate_info.visible = false
						this._lb_timeDown.text = "剩余：0秒"
						this.model.Fire(GuardModel.REQUEST_SCMD, 21601)
					}
				}

				if (!this.timer) {
					this.timer = GlobalTimerQuest.AddPeriodQuest(timer_func, 1)
				}
				timer_func()
			}
		} else {
			this._img_red.visible = this.model.GetGuardRed(this.guard_type)
			if (this.timer) {
				this.ClearTimer()
			}
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
window["GuardMainView"] = GuardMainView