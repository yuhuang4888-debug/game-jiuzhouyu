import { BaseItem1 } from "../common/BaseItem1"
import { NotEnougnDiamond, Util } from "../util/Util"
import { Message } from "../sysInfo/SysInfoController"
import { Alert, Alert_Type } from "../alert/Alert"
import { RoleManager } from "../commonModel/RoleManager"
import { SYTweenLite } from "../util/SYTweenLite"
import { WordManager } from "../common/WordManager"
import { ResManager } from "../common/ResManager"
import { ColorUtil } from "../util/ColorUtil"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"

export class EquipWashPropItem extends BaseItem1 {
	//Emp_gp_btn_close
	//Emp_gp_lock
	//Image
	//_img_033
	//canprop
	cost_num
	cost_source
	cur_equip_info
	equip_type
	index
	model
	needrefresh
	open_cost
	range
	refresh_id
	timeout_list
	tween_id
	waitid
	// pos = [0, 75, 155, 230]

	public constructor(parent?) {
		super(parent)
		this.base_file = "equip"
		this.layout_file = "EquipWashPropItem"
		this.preload_server_config = {
			"config_equip_wash_unlock_lv": false
		}

		this.model = EquipModel.GetInstance()
		this.timeout_list = []

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public LoadSuccess() {
		/*
		if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			let csf = this._lb_lock.GetComponent("ContentSizeFitter")
			csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			SetSizeDeltaX(this._lb_lock,50)
			SetAnchoredPosition(this._lb_lock,342,-2)
			this._lb_lock.size  = 12
			this._lb_lock.lineSpacing = 0.7
			this.diamond_label.size  = 18
			this.diamond_right_label.size  = 18
		}
		*/
		//this.canprop = this.prop_label.GetComponent("Canvas")
		if (this.needrefresh) {
			this.needrefresh = false
			this.SetData(this.cur_equip_info, this.index)
		}
		//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_034, GameResPath.GetIcon("equip", "uixl_007"), true)
		//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_033, GameResPath.GetIcon("equip", "uixl_007a"), true)
	}

	public InitEvent() {
		Util.AddClickEvent(this._gp_btn_close, () => {
			let role_lv = RoleManager.GetInstance().GetMainRoleVo().level
			if (!this.cur_equip_info) {
				Message.show("未穿戴装备")
				return
			}
			let pos_info = this.model.GetWashUnlockLvInfo(this.cur_equip_info.equip_type)
			if (!pos_info) {
				return
			}
			if (role_lv < pos_info["unlock_lv"]) {
				Message.show("等级不足")
				return
			}
			let request_proto = () => {
				EquipModel.GetInstance().Fire(EquipEvent.REQUEST_PROTO, 15212, "cc", this.equip_type, this.index + 1)
			}

			let jump_recharge = () => {
				NotEnougnDiamond()
			}

			if (this.cur_equip_info.wash_attr.length == 0 || this.cur_equip_info.wash_attr[this.index - 1]) {
				if (!this.open_cost) {
					request_proto()
					return
				}
				let money_num = this.open_cost["0"] == 1 ? (RoleManager.GetInstance().GetMainRoleVo().jin) : (RoleManager.GetInstance().GetMainRoleVo().jinLock)
				if (money_num < this.cost_num && this.open_cost["0"] != 1) {
					let jin = Number(this.open_cost[2]) - money_num
					let ok_callback = () => {
						if (this.cost_num > money_num + RoleManager.GetInstance().mainRoleInfo.jin) {
							jump_recharge()
						} else {
							request_proto()
						}
					}

					Alert.Show("当前绑玉不足，是否消耗" + jin + "勾玉代替", Alert_Type.Two, ok_callback)
					Alert.SetIsCharge(true)
				} else {
					let ok_callback = () => {
						if (money_num < this.cost_num) {
							jump_recharge()
							return
						} else {
							request_proto()
						}
					}
					Alert.Show("是否消耗" + this.cost_num, Alert_Type.Three, ok_callback, null, null, null, null, null, null, null, true, null, "绑定勾玉开启洗炼槽")
				}
			} else {
				Message.show("请按顺序开启洗炼槽")
			}
		}, this, true)

		Util.AddClickEvent(this._gp_lock, () => {
			if (this.equip_type == null) {
				return
			}
			if ((this.model.wash_lock_dic && this.model.wash_lock_dic[this.equip_type]) && this.model.wash_lock_dic[this.equip_type][this.index]) {
				delete this.model.wash_lock_dic[this.equip_type][this.index]
				Message.show("槽位解锁")
			} else {
				this.model.wash_lock_dic = (this.model.wash_lock_dic && (this.model.wash_lock_dic) || ({}))
				this.model.wash_lock_dic[this.equip_type] = (this.model.wash_lock_dic[this.equip_type] && (this.model.wash_lock_dic[this.equip_type]) || ({}))
				this.model.wash_lock_dic[this.equip_type][this.index] = true
				Message.show("槽位锁定")
			}
			this.model.Fire(EquipEvent.LOCK_WASH_PROP)
		}, this, true)

		let UpdateCallBack = (attr_list?) => {

			
	
			for (let index in attr_list) {
				if (attr_list[index].index == this.index + 1) {
					this.ClearTimer()
					this.tween_id = SYTweenLite.to(this, this.canprop, SYTweenLite.UiAnimationType.ALPHA, 0, 0.2, () => {
						this.waitid = setTimeout(() => {
							if (!this.use_delete_method) {
								this.RefreshPropLabel()
								this.tween_id = SYTweenLite.to(this, this.canprop, SYTweenLite.UiAnimationType.ALPHA, 1, 0.2)
							}
						}, 0.1)
					})
			

					// this.refresh_id = setTimeout(() => {
					// 	this.RefreshPropLabel()
					// }, 0.25)
				}
			}
		}
		this.BindEvent(this.model, EquipEvent.PLAY_PROP_EFFECT, UpdateCallBack)

		let lock_wash_prop = () => {
			this.RrefreshLockImage()
		}
		this.BindEvent(this.model, EquipEvent.LOCK_WASH_PROP, lock_wash_prop)
	}

	public getColorLimit(range_cfg?, index?, limit?) {
		let _limit = 0
		if ((range_cfg && range_cfg.attr_color) && range_cfg.attr_white) {
			if (0 == index) {
				_limit = range_cfg.attr_white[0][limit]
			} else if (1 == index) {
				_limit = range_cfg.attr_green[0][1][limit]
			} else if (2 == index) {
				_limit = range_cfg.attr_blue[0][1][limit]
			} else if (3 == index) {
				_limit = range_cfg.attr_purple[0][1][limit]
			} else if (4 == index) {
				_limit = range_cfg.attr_orange[0][1][limit]
			} else if (5 == index) {
				_limit = range_cfg.attr_red[0][1][limit]
			}
		}
		return _limit
	}

	public RrefreshLockImage() {
		if (this.equip_type == null) {
			return
		}
		let cur_lock_dic = this.model.wash_lock_dic[this.equip_type] || {}
		this.lock_img.visible = cur_lock_dic[this.index] ? true : false
		//this.unlock_img.visible = !(Util.TableSize(cur_lock_dic) + 1 == this.cur_equip_info.wash_attr.length) || this.lock_img.visible
		this._gp_lock.visible = !(Util.TableSize(cur_lock_dic) + 1 == this.cur_equip_info.wash_attr.length) || this.lock_img.visible
		//this._lb_lock.visible = this.lock_img.visible || this.unlock_img.visible
		this._lb_lock.visible = this._gp_lock.visible
		//this.Image.visible = this._lb_lock.visible
		this._lb_lock.text = this.lock_img.visible ? "锁定" : "未锁"
		//this._lb_lock.color = this.lock_img.visible ? "#fff16a" : "#cfcfcf"
		/*
		if (!this.lock_img.visible && !this.unlock_img.visible) {
			this.Emp_gp_lock.raycastTarget = false
		} else {
			this.Emp_gp_lock.raycastTarget = true
		}
		*/
	}

	public RefreshPropLabel() {
		if (!this.cur_equip_info) {
			return
		}
		let prop = this.cur_equip_info.wash_attr[this.index]
		if (!prop) {
			return
		}
		let cur_attr = WordManager.GetProperties(prop.attr_id) + (" + ") + WordManager.ConvertToPercentValue(prop.attr_id, prop.attr_val)
		let pos = this.equip_type + "@" + this.cur_equip_info.division + "@" + prop.attr_id
		let cfs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_wash_attr", false)
		let range_cfg = this.model.GetWashAttrInfo(pos, cfs)
		if (range_cfg) {
			let min_limit = this.getColorLimit(range_cfg, 1, 0)
			let max_limit = this.getColorLimit(range_cfg, 5, 1)
			this.range = [min_limit, max_limit]
		} else {
			this.range = [0, 1]
		}
		this.prop_label.color = ColorUtil.GetColorDark(prop.color, false)
		this.prop_label.text = cur_attr
		this.RefProgress(prop.attr_val, this.range)
	}

	public RefProgress(value?, range?) {
		let min = range[0]
		let max = range[1]
		if (this._img_pregross && max) {
			let percent = (value - min) / (max - min)
			percent = percent < 0.01 ? 0.01 : percent
			this._img_pregross.width = percent * 210
		}
	}

	public SetData(cur_equip_info?, index?) {
		if (!cur_equip_info) {
			return
		}
		this.cur_equip_info = cur_equip_info
		if (index >= 0) {
			this.index = index
		}
		if (!this.is_loaded) {
			this.needrefresh = true
			return
		}
		// this.display_obj.y = this.pos[this.index]
		//this.ClearUIEffect(this._gp_effect)
		this.ClearTimeout()

		let show = (cur_equip_info.wash_attr && cur_equip_info.wash_attr[this.index]) ? true : false
		this.open_group.visible = show
		this.close_group.visible = !show
		this._gp_btn_close.visible = !show

		//this.Emp_gp_btn_close.raycastTarget = this.close_group.visible
		let img_str = !show ? "xl_005" : "xl_004"
		ResManager.GetInstance().SetImageSprite(this, this._img_034, "equip", img_str)
		this._img_034.height = !show ? 55 : 46

		this.red_dot.visible = false

		this.equip_type = cur_equip_info.equip_type
		if (this.close_group.visible) {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_wash_unlock_lv", false)
			if (!cfg) {
				return
			}
			let cur_cfg = cfg[this.equip_type]
			if (!cur_cfg) {
				return
			}
			let unlock_cost = cur_cfg.unlock_cost
			if (typeof (unlock_cost) == "string") {
				unlock_cost = JSON.parse(unlock_cost)
				//Config.Equipwashunlocklv[this.equip_type].unlock_cost = unlock_cost
			}
			this.open_cost = unlock_cost[this.index] && unlock_cost[this.index][1][0]
			this.diamond_img.visible = !this.open_cost ? false : true
			this.cost_source = !this.open_cost ? ("") : ((this.open_cost[0] == "1" ? "com_diamond" : "com_bind_diamond"))
			this.cost_num = !this.open_cost ? ("免费") : (Number(this.open_cost[2]))
			if (this.cost_source == "") {
				this.diamond_img.visible = false
			} else {
				this.diamond_img.visible = true
				ResManager.GetInstance().SetImageSprite(this, this.diamond_img, "common_asset", this.cost_source)
			}
			this.diamond_label.text = this.cost_num
			this.diamond_img.width = this.diamond_img.visible ? 40 : 0.1
			this.red_dot.visible = !this.diamond_img.visible
		} else {
			this.RrefreshLockImage()
			this.RefreshPropLabel()
		}
	}

	public ClearTimeout() {
		if (this.refresh_id) {
			clearTimeout(this.refresh_id)
			this.refresh_id = null
		}
	}

	public ClearTimer() {
		if (this.tween_id) {
			SYTweenLite.Stop(this.tween_id)
			this.tween_id = null
		}
		if (this.waitid) {
			clearTimeout(this.waitid)
			this.waitid = null
		}
	}

	public DeleteMe() {
		this.ClearTimer()
		this.ClearTimeout()
		super.DeleteMe()
	}


_img_034:Laya.Image
open_group:Laya.Box
_gp_lock:Laya.Box
unlock_img:Laya.Image
lock_img:Laya.Image
_lb_lock:Laya.Label
canprop:Laya.Box
prop_label:Laya.Label
_Image1:Laya.Image
_img_pregross:Laya.Image
_gp_btn_close:Laya.Box
close_group:Laya.HBox
diamond_label:Laya.Label
diamond_img:Laya.Image
diamond_right_label:Laya.Label
red_dot:Laya.Image
_gp_effect:Laya.Box
public GetComponents() {
[
this._img_034,
this.open_group,
this._gp_lock,
this.unlock_img,
this.lock_img,
this._lb_lock,
this.canprop,
this.prop_label,
this._Image1,
this._img_pregross,
this._gp_btn_close,
this.close_group,
this.diamond_label,
this.diamond_img,
this.diamond_right_label,
this.red_dot,
this._gp_effect,
]
 = this.GetChildrenByNames([

"_img_034",
"open_group",
"_gp_lock",
"unlock_img",
"lock_img",
"_lb_lock",
"canprop",
"prop_label",
"_Image1",
"_img_pregross",
"_gp_btn_close",
"close_group",
"diamond_label",
"diamond_img",
"diamond_right_label",
"red_dot",
"_gp_effect",
])
}
}
 window["EquipWashPropItem"]= EquipWashPropItem