import { BaseItem1 } from "../common/BaseItem1"
import { Util, SetAnchoredPositionY, SetSizeDelta, SetAnchoredPosition, SetLocalScale } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { StarEquipModel } from "../commonModel/StarEquipModel"

export class StarEquipMasterIcon extends BaseItem1 {	
	data
	effectId
	index

	public constructor(parent?) {
		super(parent)
		this.base_file = "starEquip"
		this.layout_file = "StarEquipMasterIcon"

		this.load_callback = () => {
			Util.AddClickEvent(this.gp_con, () => {
				if (this.data) {
					StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipMasterTip", this.data)
				}
			}, this, true)

			this.BindEvent(StarEquipModel.GetInstance(), StarEquipModel.MASTR_UP, () => {
				if (this.data && this.data.star == StarEquipModel.GetInstance().activeStar) {
					//this:AddUIEffect("ui_starmaster_glowboom", this.gpb)
				}
			})
		}
	}

	public SetData(data?, index?) {
		this.data = data
		this.index = index
		let totalStar = StarEquipModel.GetInstance().totalStar
		let activedStar = StarEquipModel.GetInstance().activeStar
		let maxActiveStar = StarEquipModel.GetInstance().oldMaxStar
		this.effectId = null
		//let changePos = false
		let isSkill = data.icon != 0
		ResManager.GetInstance().SetImageSprite(this, this.bg, "starEquip_asset", isSkill && "uixzsy_046" || "uixzsy_042", true)
		SetAnchoredPositionY(this.starGp, isSkill ? 86 : 66)
		//SetSizeDelta(this.icon, 75, 75)
		this.ClearUIEffect(this.gp)
		this.ClearUIEffect(this.gpb)
		this.redDot.visible = false
		if (data.star == activedStar + 1 && totalStar > activedStar) {
			//let scale = isSkill && 1 || 0.5
			this.redDot.visible = true
			if (isSkill) {
				SetAnchoredPosition(this.redDot, 72, 0)
			} else {
				SetAnchoredPosition(this.redDot, 60, 10)
			}
		} else if (data.star <= activedStar) {
			//let effectStr = isSkill && "ui_starmaster_iconglow1" || "ui_starmaster_iconglow2"
			//this:AddUIEffect(effectStr, this.gp, null, null, true)

			// if (isSkill) {
			// 	this.AddUIEffect("ui_constellation_star_2", Enum_UILayer.Activity, this.gpb, null, null, true, { mask_id = 1 })
			// } else {
			// 	this.AddUIEffect("ui_constellation_star_1", Enum_UILayer.Activity, this.gp, null, null, true, { mask_id = 1 })
			// }
		}
		this.InvalidImg.visible = isSkill && data.star > activedStar && data.star <= StarEquipModel.GetInstance().oldMaxStar
		//SetLocalScale(this.InvalidImg, isSkill && 2 || 1)
		//let banRes = "uixzsy_047"
		let iconRes = "uixzsy_044"	// 已激活状态
		let icon_show = true
		if (data.star == maxActiveStar + 1 && maxActiveStar == activedStar) {
			iconRes = "uixzsy_045"	// 可激活
			//SetSizeDelta(this.icon, 59, 59)
			//changePos = true
		} else if (data.star > maxActiveStar) {
			// 不可激活
			icon_show = false
			//iconRes = "uixzsy_045"	
			//banRes = "uixzsy_047b"
			//SetSizeDelta(this.icon, 59, 59)
		}
		this.lb.text = data.star
		if (data.icon != 0) {
			this.skillIcon.visible = true
			this.icon.visible = false
			ResManager.GetInstance().SetOutsideImageSprite(this, this.skillIcon, GameResPath.GetSkillIconPath(data.icon))

			// if (data.star > activedStar) {
			// 	let mat = new Material(ShaderTools.gray_mat)
			// 	this.CirskillIcon.material = mat
			// } else {
			// 	this.CirskillIcon.material = null
			// }
			//SetImageGray(this.CirskillIcon, data.star > activedStar)
			//Util.SetCircleMask(this.skillIcon, null, null, 40)
			this.skillIcon.gray = data.star > activedStar
		} else {
			this.skillIcon.visible = false
			this.icon.visible = icon_show
			if (icon_show){
				ResManager.GetInstance().SetImageSprite(this, this.icon, "starEquip", iconRes)
			}
		}
		//ResManager.GetInstance().SetImageSprite(this, this.ban, "starEquip", banRes)
	}

	gp_con: Laya.Box
	gp: Laya.Box
	bg: Laya.Image
	icon: Laya.Image
	skillIcon: Laya.Image
	gpb: Laya.Box
	starGp: Laya.Box
	ban: Laya.Image
	star: Laya.Image
	lb: Laya.Label
	InvalidImg: Laya.Image
	redDot: Laya.Image
	public GetComponents() {
		[
			this.gp_con,
			this.gp,
			this.bg,
			this.icon,
			this.skillIcon,
			this.gpb,
			this.starGp,
			this.ban,
			this.star,
			this.lb,
			this.InvalidImg,
			this.redDot,
		]
			= this.GetChildrenByNames([

				"gp_con",
				"gp",
				"bg",
				"icon",
				"skillIcon",
				"gpb",
				"starGp",
				"ban",
				"star",
				"lb",
				"InvalidImg",
				"redDot",
			])
	}
}
window["StarEquipMasterIcon"] = StarEquipMasterIcon