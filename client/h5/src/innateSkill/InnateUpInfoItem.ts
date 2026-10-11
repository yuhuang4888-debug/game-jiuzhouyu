import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import { SkillManager } from "../skill/SkillManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPositionX, Util } from "../util/Util"
import { InnateUpCondItem } from "./InnateUpCondItem"

export class InnateUpInfoItem extends BaseItem1 {
	top_bg: Laya.Image
	_Image11: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	lab_1: Laya.Label
	_img_limit: Laya.Image
	Emp_btn_up
	InitEvent
	InitView
	Local_DeleteMe
	SetData
	_Image1
	_btn_up
	_gp_up_cond
	_img_bg
	_img_icon
	_lb_cost
	_lb_no_cond
	_scroll_cond:Laya.Panel
	labelDisplay:Laya.Label
	outlabelDisplay

	public constructor(parent?) {
		super(parent)


		this.base_file = "innateSkill"
		this.layout_file = "InnateUpInfoItem"
		let model = SkillUIModel.GetInstance()
		let local_Message = Message
		let skill_id_ = null
		let less_point_ = null
		let condition_ = null
		let is_max_lv_ = false
		let cond_item_list_ = []
		let less_point_good_ = 6200001

		this.load_callback = () => {
			this.InitEvent()

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	SetAnchoredPositionX(this._gp_up_cond,-20)
			// }
		}

		this.InitEvent = () => {
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("innateSkill", "uitfjn_010"))
			Util.AddClickEvent(this._btn_up, () => {
				if (is_max_lv_) {
					local_Message.show("技能已满级")
					return
				}
				if (less_point_ <= 0) {
					local_Message.show("天赋点不足")
					return
				}
				let bool = true
				for (let key in condition_) {
					var cond = condition_[key]
					if (key == "turn") {
						break
					}
					let str = ""
					let skill_ui_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigSkillUI", true)
					if (!skill_ui_cfg) {
						return
					}
					let ui_cfg = skill_ui_cfg["innateSkill"]
					let info = model.GetInnateInfo()
					if (key == "point") {
						let _type = cond[1]
						let _point = cond[2]
						if (_type && _point) {
							if (ui_cfg[_type] && info) {
								let use_point = 0
								if (info.talent_skills) {
									for (let _tmpi in info.talent_skills) {
										var v = info.talent_skills[_tmpi]
										if (v.skill_type == _type) {
											use_point = v.point
											break
										}
									}
								}
								if (use_point < Number(_point)) {
									bool = false
									break
								}
							}
						}
					} else if (key == "pre_skill"
						|| key == "pre_skill2") {
						for (let k in cond) {
							var sub_cond = cond[k]
							let per_skill = model.GetInnateAllInfoByID(sub_cond[1])
							if (per_skill) {
								let lv = per_skill && per_skill.skill_lv || 0
								if (lv < Number(sub_cond[2])) {
									bool = false
									break
								}
							}
						}
					}

					if (!bool) {
						break
					}
				}

				if (bool) {
					SkillManager.GetInstance().Fire(SkillManager.REQUEST_CCMD_EVENT, 21011, skill_id_)
				} else {
					local_Message.show("条件不足")
				}
			}, this, true)

			this.BindEvent(model, SkillUIModel.SELECT_INNATE_ITEM, (skill_cfg?) => {
				if (skill_cfg) {
					skill_id_ = skill_cfg.id
					this.InitView()
				}
			}
			)

			Util.AddClickEvent(this._img_icon, () => {
				UIToolTipMgr.GetInstance().AppendGoodsTips(less_point_good_)
			}, this, true)
		}

		this.InitView = () => {
			condition_ = []
			is_max_lv_ = false
			this._lb_no_cond.visible=false
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(less_point_good_)
			if (basic) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(basic.goods_icon))
			}
			let info = model.GetInnateInfo()
			if (!info) {
				return
			}
			less_point_ = info.less_point
			// Laya.UIUtils.gray(this._Image1, !(less_point_ > 0))
			this._btn_up.gray= !(less_point_ > 0)
			let cfg = model.GetInnateAllInfoByID(skill_id_)
			if (!cfg) {
				return
			}
			let lv_data = JSON.parse(cfg.lv_data)
			if (!lv_data) {
				return
			}
			let _lv = cfg.skill_lv || 0
			if (_lv == lv_data.length) {
				is_max_lv_ = true
			}
			// Laya.UIUtils.gray(this._Image1, is_max_lv_)
			this._Image1.gray= is_max_lv_
			this.labelDisplay.text = is_max_lv_ && "已满级" || "升级"
			this.labelDisplay.strokeColor= !is_max_lv_ ? "#c95b37" : "#787878"
			// this.outlabelDisplay.effectColor = is_max_lv_ && ColorUtilValue.GRAY || ColorUtilValue.ORANGE
			// this.Emp_btn_up.raycastTarget = !is_max_lv_
			let cost_bool = is_max_lv_ && false || true
			this._lb_cost.visible = cost_bool
			this._img_icon.visible = cost_bool
			if (cond_item_list_.length > 0) {
				for (let _tmpi in cond_item_list_) {
					var item = cond_item_list_[_tmpi]
					item.SetVisible(false)
				}
			}
			let next_info = lv_data[_lv]
			if (!next_info) {
				next_info=lv_data[_lv-1]
				// return
			}
			condition_ = next_info.condition
			if( typeof( condition_ )== "string"){
				condition_ = ErlangParser.GetInstance().Parse(condition_)
			}
			let pre_cond = []
			for (let cond_type in condition_) {
				let strList = condition_[cond_type]
				if (strList[0] == "pre_skill" || strList[0] == "pre_skill2") {
					// for (let _ = 0; _ < data.length; _++) {
					// 	var v = data[_]
					table.insert(pre_cond, ["pre_skill", strList[1], strList[2]])
					// }

				} else if (strList[0] == "point") {
					table.insert(pre_cond, ["point", strList[1], strList[2]])
				}
			}

			table.sort(pre_cond, (a?, b?) => {
				if (a[0] == b[0]) {
					return true
				} else if (a[0] == "pre_skill") {
					return true
				} else if (b[0] == "pre_skill") {
					return false
				}
			})

			let cond_num = pre_cond.length
			for (let index = 0; index < pre_cond.length; index++) {
				let  conf_vo = pre_cond[index]
				let item = cond_item_list_[index]
				if (!item) {
					item = new InnateUpCondItem(this._gp_up_cond)
					item.Load()
					table.insert(cond_item_list_, item)
				}
				item.ExcuteCallback(() => {
					item.SetData(conf_vo)
					item.SetVisible(true)
				}
				)
			}
			this._lb_no_cond.visible = !(cond_num > 0)
			this._scroll_cond.visible = cond_num > 0
		}

		this.SetData = (skill_id?) => {
			if (!skill_id) {
				return
			}
			skill_id_ = skill_id
			this.InitView()
		}

		this.Local_DeleteMe = () => {
			if (cond_item_list_.length > 0) {
				for (let _tmpi in cond_item_list_) {
					var item = cond_item_list_[_tmpi]
					item.DeleteMe()
				}
				cond_item_list_ = []
			}
		}

	}

	public DeleteMe() {
		this.Local_DeleteMe()
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._img_bg,
			this.top_bg,
			this._Image11,
			this._Image2,
			this._Image3,
			this.lab_1,
			this._btn_up,
			this._Image1,
			this.labelDisplay,
			this._img_icon,
			this._lb_cost,
			this._img_limit,
			this._lb_no_cond,
			this._scroll_cond,
			this._gp_up_cond,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"top_bg",
				"_Image11",
				"_Image2",
				"_Image3",
				"lab_1",
				"_btn_up",
				"_Image1",
				"labelDisplay",
				"_img_icon",
				"_lb_cost",
				"_img_limit",
				"_lb_no_cond",
				"_scroll_cond",
				"_gp_up_cond",
			])
		this._scroll_cond.vScrollBar.visible = false
	}
}
window["InnateUpInfoItem"] = InnateUpInfoItem