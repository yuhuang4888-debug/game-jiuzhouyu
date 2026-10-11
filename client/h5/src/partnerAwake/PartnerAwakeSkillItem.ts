import { BaseItem1 } from "../common/BaseItem1";
import { ResManager } from "../common/ResManager";
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel";
import { PartnerAwakeModel } from "../commonModel/PartnerAwakeModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class PartnerAwakeSkillItem extends BaseItem1 {
	root_con: Laya.Box
	bg: Laya.Image
	effect: Laya.Box
	skill_icon: Laya.Image
	special_tag: Laya.Image
	effect2: Laya.Box


	data
	index
	model
	needRefresh
	tween_id

	public constructor(parent?) {
		super(parent)

		this.base_file = "partnerAwake"
		this.layout_file = "PartnerAwakeSkillItem"
		this.model = PartnerAwakeModel.GetInstance()
		this.needRefresh = false
		this.data = null
		this.index = 1
		this.load_callback = () => {
			this.InitEvents()
		}
	}


	public InitEvents() {
		let click_fun = () => {
			OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "PetSkillView", this.data, 0)
		}
		Util.AddClickEvent(this.root_con, click_fun, this, true)

		if (this.needRefresh) {
			this.SetData(this.data, this.index)
			this.needRefresh = false
		}
	}

	public SetData(vo?, index?) {
		this.data = vo
		this.index = index
		if (this.is_loaded) {
			this.root_con.scaleX = this.root_con.scaleY = 0
			this.root_con.visible = true
			this.special_tag.visible = false
			ResManager.GetInstance().SetTexture(this, this.skill_icon, GameResPath.GetSkillIconPath(this.data))

			Laya.Tween.clearAll(this.root_con)
			let complete_fun = () => {
				/*
				this.AddUIEffect("UI_partner_skillicon_02", this.effect2, null, null, null)
				this.AddUIEffect("UI_partner_skillicon_01", this.effect, null, 1.2, true)
				*/
				this.special_tag.visible = this.index == 0
			}
			// Laya.Tween.get(this.root_con).to({ scaleX: 1, scaleY: 1 }, 700, Laya.Ease.backOut).call(complete_fun)
			Laya.Tween.to(this.root_con,{ scaleX: 1, scaleY: 1 },700,Laya.Ease.backOut,Laya.Handler.create(this,()=>{
				complete_fun()
			}))
		} else {
			this.needRefresh = true
		}
	}

	public DeleteMe() {
		Laya.Tween.clearAll(this.root_con)
		if (this.effect) {
			this.ClearUIEffect(this.effect)
		}
		if (this.effect2) {
			this.ClearUIEffect(this.effect2)
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this.root_con,
			this.bg,
			this.effect,
			this.skill_icon,
			this.special_tag,
			this.effect2,
		]
			= this.GetChildrenByNames([

				"root_con",
				"bg",
				"effect",
				"skill_icon",
				"special_tag",
				"effect2",
			])
	}
}
window["PartnerAwakeSkillItem"] = PartnerAwakeSkillItem