import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { FashionPartPos } from "../scene/SceneConfig"
import { SkillManager } from "../skill/SkillManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { Util, SetLocalPositionY, SetSizeDeltaY, PlayBigEffect } from "../util/Util"
import { InnateInfoItem } from "./InnateInfoItem"
import { InnateListItem } from "./InnateListItem"
import { InnateTypeItemRenderer } from "./InnateTypeItemRenderer"
import { InnateUpInfoItem } from "./InnateUpInfoItem"

export class InnateSkillView extends BaseItem1 {
	_Image2: Laya.Image
	_Image1: Laya.Image
	_Image3: Laya.Image
	_Label1: Laya.Label
	_Image4: Laya.Image
	_Image5: Laya.Image
	Emp_gp_ref
	InitEvent
	InitView
	LoadSuccess
	Local_DeleteMe
	RefContentSize
	RefListItem
	RefSelType
	RefSkillInfo
	RefSkillUpInfo
	RefreshView
	_Scroller1: Laya.Panel
	Scr_Scroller2
	SetSelectId
	_Scroller2: Laya.List
	_gp_effect: Laya.Box
	_gp_info
	_gp_ref
	_gp_skill
	_gp_up_level
	_img_002
	_lb_point: Laya.Label
	_ls_type: Laya.List
	_img_bg
	_img_bg2
	public constructor(parent?) {
		super(parent)


		this.base_file = "innateSkill"
		this.layout_file = "InnateSkillView"
		let model = SkillUIModel.GetInstance()
		let good_model = GoodsModel.GetInstance()
		let local_Alert = Alert
		let local_Alert_Type = Alert_Type
		let local_SkillUIModel = SkillUIModel
		let role_mgr = RoleManager.GetInstance()
		let list_ = []
		let info_ = null
		let select_type_ = null
		let select_skill_id_ = null
		let sourceArr_ = null
		let skill_list_item_ = null
		let skill_info_item_ = null
		let skill_upInfo_item_ = null
		let ref_good_ = 6200002
		let last_select_ = null
		this.is_delay_callback = true
		let content_size = [
			637,
			637,
			820
		]

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			model.UpdateInnateRed(true)
			//lua_resM:SetOutsideImageSprite(this, this._img_002, GameResPath.GetIcon("innateSkill","uitfjn_002"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, "resource/game/role/texture/uijn_001.jpg")
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_bg2, "resource/game/innateSkill/texture/ui_role_38.png")
			let skill_ui_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigSkillUI", true)
			if (!skill_ui_cfg) {
				return
			}
			let ui_cfg = skill_ui_cfg["innateSkill"]
			if (!ui_cfg) {
				return
			}
			for (let i in ui_cfg) {

				table.insert(list_, { type: i })
			}
			table.sort(list_, (a?, b?) => {
				return a.type < b.type
			})

			info_ = model.GetInnateInfo()
			if (info_ && info_.talent_skills) {
				this.InitEvent()
				this.InitView()
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._Image3, () => {
				let have_num = good_model.GetTypeGoodsNum(ref_good_)
				let basic = good_model.GetGoodsBasicByTypeId(ref_good_)
				if (!basic) {
					return
				}
				let color = ColorUtil.GetColorDark(basic.color)
				let ok_func = () => {
					SkillManager.GetInstance().Fire(SkillManager.REQUEST_CCMD_EVENT, 21012)
				}

				if (have_num > 0) {
					local_Alert.Show(Util.StrToHTML("是否确定使用<font color=" + color + ">" + basic.goods_name + "</font>对天赋进行重置"), local_Alert_Type.Two, ok_func)
				} else {
					let price_cfg = Config.PRELOAD_SERVER_CONFIG.config_goods_price[Number(ref_good_)]
					let gdata = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[Number(price_cfg.price_type)]
					if (price_cfg && gdata) {
						let name = GoodsModel.GetGoodsName(gdata.goods_id)
						local_Alert.Show(Util.StrToHTML("<font color=" + color + ">" + basic.goods_name + "</font>不足，是否确定<font color=\"#639c12\">" + price_cfg.price + "勾玉</font>购买<br/>(优先消耗绑玉)"), local_Alert_Type.Two, ok_func)
					}
				}
			}, this, true)

			this.BindEvent(model, local_SkillUIModel.UPDATE_INNATE_VIEW, (bool?) => {
				info_ = model.GetInnateInfo()
				let info = info_
				if (info_) {
					this.RefreshView()
				}
				if (bool) {
					// this._gp_effect.visible = true;
					// this.AddUIEffect("ui_shengjitexiao", this._gp_effect, { x: 0, y: 0 }, 7, false, 1, () => {
					// 	this._gp_effect.visible = false;
					// }, null, null, null, true)

					Laya.timer.frameOnce(3, this, () => {
						PlayBigEffect("ui_shengjitexiao")
					}, null, true)

				}
			}
			)

			this.BindEvent(model, local_SkillUIModel.SELECT_INNATE_ITEM, (skill_cfg?) => {
				select_skill_id_ = skill_cfg.id
			}
			)
		}

		this.RefSelType = (item?) => {
			// if (this._ls_type.selectedIndex == 5) {

			// }
			let skill_ui_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigSkillUI", true)
			if (!skill_ui_cfg) {
				return
			}
			let ui_cfg = skill_ui_cfg["innateSkill"]
			if (!ui_cfg) {
				return
			}
			let bool = true
			// let type = this._ls_type.selectedIndex + 5
			let type = sourceArr_.parent.selectedIndex + 5
			let limit_desc = null
			let limit_value = null
			for (let i in ui_cfg) {

				if (Number(i) == type) {
					if (ui_cfg[i]["open"]) {
						for (let k in ui_cfg[i]["open"]) {

							let value = null
							if (k == "is_open") {
								if (!ui_cfg[i]["open"][k]) {
									limit_desc = "该天赋系暂未开放，敬请期待"
									bool = false
									break
								}
							}
							if (k == "open_lv") {
								value = role_mgr.mainRoleInfo.level
								limit_value = ui_cfg[i]["open"][k]
								limit_desc = "人物达到" + limit_value + "级后开启"
							}
							if (k == "turn") {
								limit_value = ui_cfg[i]["open"][k]
								value = role_mgr.mainRoleInfo.turn
								limit_desc = "人物达到" + limit_value + "转后开启"
							}
							if (value && value < limit_value) {
								bool = false
							}
						}
					}
					break
				}
			}
			if (!bool) {
				Message.show(limit_desc)
				sourceArr_.SetSelectIndex(last_select_)
				return
			}
			// last_select_ = this._ls_type.selectedIndex
			last_select_ = sourceArr_.parent.selectedIndex
			// sourceArr_.replaceAll()
			// this._ls_type.selectedIndex = last_select_
			sourceArr_.SetSelectIndex(last_select_)
			this.SetSelectId()
			this.RefListItem()
			this.RefSkillInfo()
			this.RefSkillUpInfo()
			this.RefContentSize()
			// this._Scroller1.viewport.scrollV = 0
		}

		this.RefreshView = () => {
			this._lb_point.text = info_.less_point
			// sourceArr_.replaceAll()
			// this._ls_type.selectedIndex = last_select_
			sourceArr_.SetSelectIndex(last_select_)
			this.RefListItem()
			this.RefSkillInfo()
			this.RefSkillUpInfo()
		}

		this.InitView = () => {
			this._lb_point.text = info_.less_point
			//天赋种类
			sourceArr_ = new LoopScrowViewMgr()
			sourceArr_.SetData(this._Scroller2, InnateTypeItemRenderer, list_, LoopScrCon.Horizontal, 1, (item?) => {
				this.RefSelType(item)
			})
			// this._ls_type.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.RefSelType, this)
			sourceArr_.SetDefaultSize(null, 133)
			// this._ls_type.selectedIndex = 0
			sourceArr_.parent.selectedIndex = 0
			last_select_ = sourceArr_.parent.selectedIndex

			//选择ID
			this.SetSelectId()
			//天赋种类技能
			this.RefListItem()
			//技能信息
			this.RefSkillInfo()
			//升级信息
			this.RefSkillUpInfo()
			//设置ContentSize
			this.RefContentSize()
		}

		this.SetSelectId = () => {
			// let obj = list_[this._ls_type.selectedIndex]
			let obj = list_[sourceArr_.parent.selectedIndex]
			let type = obj && obj.type
			let skill_ui_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigSkillUI", true)
			if (!skill_ui_cfg) {
				return
			}
			let ui_cfg = skill_ui_cfg["innateSkill"]
			if (ui_cfg && ui_cfg[type]) {
				select_skill_id_ = model.GetInnateSkillIdByCfg(ui_cfg[type][1][0])
			}
		}

		this.RefSkillUpInfo = () => {
			if (!select_skill_id_) {
				return
			}
			if (!skill_upInfo_item_) {
				skill_upInfo_item_ = new InnateUpInfoItem(this._gp_up_level)
				skill_upInfo_item_.Load()
			}
			skill_upInfo_item_.ExcuteCallback(() => {
				skill_upInfo_item_.SetData(select_skill_id_)
			}
			)
		}

		this.RefSkillInfo = () => {
			if (!select_skill_id_) {
				return
			}
			if (!skill_info_item_) {
				skill_info_item_ = new InnateInfoItem(this._gp_info)
				skill_info_item_.Load()
			}
			skill_info_item_.ExcuteCallback(() => {
				skill_info_item_.SetData(select_skill_id_)
			}
			)
		}

		this.RefListItem = () => {
			// let obj = list_[this._ls_type.selectedIndex]
			let obj = list_[sourceArr_.parent.selectedIndex]
			let type = obj && obj.type
			if (this._Scroller1 && type != null) {
				if (!skill_list_item_) {
					skill_list_item_ = new InnateListItem(this._Scroller1)
					skill_list_item_.Load()
				}
				skill_list_item_.ExcuteCallback(() => {
					skill_list_item_.SetDate(type, select_skill_id_)
				}
				)
			}
		}

		this.RefContentSize = () => {
			SetLocalPositionY(this._gp_skill, 0)
			SetSizeDeltaY(this._gp_skill, content_size[last_select_])
		}

		this.Local_DeleteMe = () => {
			if (skill_list_item_) {
				skill_list_item_.DeleteMe()
				skill_list_item_ = null
			}
			if (skill_info_item_) {
				skill_info_item_.DeleteMe()
				skill_info_item_ = null
			}
			if (skill_upInfo_item_) {
				skill_upInfo_item_.DeleteMe()
				skill_upInfo_item_ = null
			}
			// this._ls_type.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.RefSelType, this)
			if (sourceArr_) {
				sourceArr_.DeleteMe()
				sourceArr_ = null
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
			this._img_bg2,
			this._img_002,
			this._Image2,
			this._gp_ref,
			this._Image1,
			this._Image3,
			this._Label1,
			this._lb_point,
			this._Scroller1,
			this._gp_skill,
			this._Scroller2,
			this._Image4,
			this._Image5,
			this._gp_up_level,
			this._gp_info,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_002",
				"_Image2",
				"_gp_ref",
				"_Image1",
				"_Image3",
				"_Label1",
				"_lb_point",
				"_Scroller1",
				"_gp_skill",
				"_Scroller2",
				"_Image4",
				"_Image5",
				"_gp_up_level",
				"_gp_info",
				"_gp_effect",
			])
		this._Scroller1.vScrollBar.visible = false
		// this._Scroller2.scrollBar.hide=false
	}
}
window["InnateSkillView"] = InnateSkillView