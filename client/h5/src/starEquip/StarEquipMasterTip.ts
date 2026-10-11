import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Util, SetAnchoredPositionY } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { WordManager } from "../common/WordManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { StarEquipModel } from "../commonModel/StarEquipModel"

export class StarEquipMasterTip extends BaseView1 {
	CirskillIcon
	EmpactiveBtn
	InitView
	Open
	data
	cfg_equip_star

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipMasterTip"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.use_background = true
		this.background_alpha = 0
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.is_center = true
		let local_starModel = StarEquipModel
		let local_starModelIns = local_starModel.GetInstance()
		let local_wordMgr = WordManager

		this.load_callback = () => {
			this.cfg_equip_star = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_star", false)

			this.prop_scroller.vScrollBar.visible = false
			this.scroller1.vScrollBar.visible = false

			this.conditionLb.width = 325
			this.conditionLb.style.fontSize = 22
			this.conditionLb.style.color = "#783528"
			this.propLb0.width = 180
			this.propLb1.width = 180
			this.propLb0.style.fontSize = 22
			this.propLb1.style.fontSize = 22
			this.propLb0.style.color = "#4a3a32"
			this.propLb1.style.color = "#4a3a32"

			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.activeBtn, () => {
				if (this.data) {
					local_starModelIns.Fire(local_starModel.SEND_PROTO, 23206, "h", this.data.star)
					this.Close()
				}
			}, this, true)

			this.InitView()
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("common2", "uity_016j"), true)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this.img1, GameResPath.GetIcon("common2", "uity_016j"), true)
		}

		this.Open = (...new_args) => {
			this.data = new_args[0]
			if (this.is_loaded) {
				this.InitView()
			}
			super.Open()
		}

		this.InitView = () => {
			if (this.data && this.is_loaded) {
				//let type = 0
				let lastAttr = []
				let lastCfg = this.cfg_equip_star[this.data.id - 1]
				if (lastCfg) {
					lastCfg = JSON.parse(lastCfg.attr)
					for (let _tmpi in lastCfg) {
						let vo = lastCfg[_tmpi]
						lastAttr[vo[0]] = vo[1]
					}
				}
				let attrList = JSON.parse(this.data.attr)
				let j = attrList.length - 1
				if (j >= 0) {
					do {
						let vo = attrList[j]
						vo[1] = vo[1] - (lastAttr[vo[0]] || 0)
						if (vo[1] <= 0) {
							table.splice(attrList, j, 1)
						}
						j = j - 1
					} while ((j >= 0))
				}
				let str = ""
				if (this.data.icon != 0) {
					SetAnchoredPositionY(this.lb1, 265)
					SetAnchoredPositionY(this.img1, 259)
					SetAnchoredPositionY(this.scroller1, 306)
					//this.lb1.y = 265
					//this.1.y = 259
					//this.scroller1.y = 306
					this.prop_scroller.visible = false
					this.skillLb.visible = true
					this.skillIcon.visible = true
					this.skillImg.visible = true
					for (let _tmpi in attrList) {
						let vo = attrList[_tmpi]
						str = str + local_wordMgr.GetProperties(vo[0]) + (" + ") + local_wordMgr.ConvertToPercentValue(vo[0], vo[1])
					}
					this.skillLb.text = str
					ResManager.GetInstance().SetOutsideImageSprite(this, this.skillIcon, GameResPath.GetSkillIconPath(this.data.icon))
					//local_util:SetCircleMask(this.skillIcon, null, null, 40)
				} else {
					SetAnchoredPositionY(this.lb1, 226)
					SetAnchoredPositionY(this.img1, 219)
					SetAnchoredPositionY(this.scroller1, 276)
					//this.lb1.y = 226
					//this.1.y = 219
					//this.scroller1.y = 276
					this.prop_scroller.visible = true
					this.skillLb.visible = false
					this.skillIcon.visible = false
					this.skillImg.visible = false
					//this.prop_scroller.visible =   true
					//this.skillLb.visible =   false
					//this.skillIcon.visible =   this.skillLb.visible
					//this.skillImg.visible =   this.skillIcon.visible
					let str1 = ""
					let i = 0
					do {
						let vo = attrList[i]
						if (i % 2 == 0) {
							str = str + local_wordMgr.GetProperties(vo[0]) + "：<font color='#179846'>" + local_wordMgr.ConvertToPercentValue(vo[0], vo[1]) + "</font>"
						} else {
							str1 = str1 + local_wordMgr.GetProperties(vo[0]) + "：<font color='#179846'>" + local_wordMgr.ConvertToPercentValue(vo[0], vo[1]) + "</font>"
						}
						i = i + 1
					} while ((i < attrList.length))
					this.propLb0.innerHTML = str
					this.propLb0.width = 180
					this.propLb1.innerHTML = str1
					this.propLb1.width = 180
				}
				let actived = this.data.star <= local_starModelIns.activeStar
				let invalid = this.data.star > local_starModelIns.activeStar && this.data.star <= local_starModelIns.oldMaxStar
				let color = "#179846"
				if (actived) {
					this.activeBtn.visible = false
					this.activedImg.visible = true
					this.activeRed.visible = false
					this.inbalidLb.visible = false
				} else if (invalid) {
					this.activeBtn.visible = false
					this.activedImg.visible = false
					this.activeRed.visible = false
					this.inbalidLb.visible = true
				} else {
					this.inbalidLb.visible = false
					this.activeBtn.visible = true
					this.activedImg.visible = false
					let canActive = local_starModelIns.totalStar >= this.data.star
					Util.SetImageGray(this._Image11, !canActive)
					this.labelDisplay.text = canActive && "激活" || "条件不足"
					if (!canActive) {
						color = "#ff4f50"
					}
					this.activeRed.visible = this.data.star == local_starModelIns.activeStar + 1 && canActive
				}
				this.nameLb.text = "星座大师" + this.data.star + "级"
				this.conditionLb.innerHTML = Util.StrToHTML("穿戴装备累计<font color='" + color + "'>" + this.data.star + "条</font>星级卓越属性")
				this.conditionLb.width = 325
			}
		}
	}

	bg: Laya.Image
	closeBtn: Laya.Image
	_Image1: Laya.Image
	nameLb: Laya.Label
	_Image2: Laya.Image
	img1: Laya.Image
	activedImg: Laya.Image
	_Label1: Laya.Label
	lb1: Laya.Label
	activeBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_Image3: Laya.Image
	prop_scroller: Laya.Panel
	prop_group: Laya.Box
	propLb0: Laya.HTMLDivElement
	propLb1: Laya.HTMLDivElement
	scroller1: Laya.Panel
	Content: Laya.Box
	conditionLb: Laya.HTMLDivElement
	skillImg: Laya.Image
	skillIcon: Laya.Image
	skillLb: Laya.Label
	activeRed: Laya.Image
	inbalidLb: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this.closeBtn,
			this._Image1,
			this.nameLb,
			this._Image2,
			this.img1,
			this.activedImg,
			this._Label1,
			this.lb1,
			this.activeBtn,
			this._Image11,
			this.labelDisplay,
			this._Image3,
			this.prop_scroller,
			this.prop_group,
			this.propLb0,
			this.propLb1,
			this.scroller1,
			this.Content,
			this.conditionLb,
			this.skillImg,
			this.skillIcon,
			this.skillLb,
			this.activeRed,
			this.inbalidLb,
		]
			= this.GetChildrenByNames([
				"bg",
				"closeBtn",
				"_Image1",
				"nameLb",
				"_Image2",
				"img1",
				"activedImg",
				"_Label1",
				"lb1",
				"activeBtn",
				"_Image11",
				"labelDisplay",
				"_Image3",
				"prop_scroller",
				"prop_group",
				"propLb0",
				"propLb1",
				"scroller1",
				"Content",
				"conditionLb",
				"skillImg",
				"skillIcon",
				"skillLb",
				"activeRed",
				"inbalidLb",
			])
	}
}
window["StarEquipMasterTip"] = StarEquipMasterTip