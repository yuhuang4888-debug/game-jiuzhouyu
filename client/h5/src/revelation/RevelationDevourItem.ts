import { Revelation1EquipItem } from "./Revelation1EquipItem"
import { Util } from "../util/Util"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { RevelationEvent } from "../commonModel/RevelationModel"

export class RevelationDevourItem extends Revelation1EquipItem {
	red_mgr
	Emp_gp_con
	selectCache

	public constructor(parent?) {
		super(parent)
		this.base_file = "revelation"
		this.layout_file = "RevelationDevourItem"
		
		this.red_mgr = RedDotManager.GetInstance()
	}

	public InitEvent() {
		Util.AddClickEvent(this._gp_con, () => {
			this.selectImg.visible = true
			if (this.data) {
				this.model.Fire(RevelationEvent.SELECT_DEVOUR_ITEM, this.data.equip_type)
			}
		}, this, true)

		this.BindEvent(this.model, RevelationEvent.UPDATE_DEVOUR_RED, () => {
			this.reddot.visible = this.red_mgr.CheckRedStatus(ModuleType.REVE_DEVOUR_RED, this.data.equip_type) || 
				this.red_mgr.CheckRedStatus(ModuleType.REVE_DEVOUR_RED, this.data.equip_type + 10)
		})

		this.BindEvent(this.model, RevelationEvent.EQUIP_LV_UP_SUCCESS, (scmd?) => {
			if (this.data && this.data.equip_type == scmd.pos) {
				this.UpdateView()
			}
		})

		this.selectImg.visible = this.selectCache
	}

	public SetSelect(bool?) {
		if (this.is_loaded) {
			this.selectImg.visible = bool
		} else {
			this.selectCache = bool
		}
	}

	//function RevelationDevourItem.SetData(data)
	//super.SetData(data)
	//}

	public UpdateView() {
		if (super.UpdateView(true)) {
			this.reddot.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.REVE_DEVOUR_RED, this.data.equip_type) || RedDotManager.GetInstance().CheckRedStatus(ModuleType.REVE_DEVOUR_RED, this.data.equip_type + 10)
			if (this.data.preview) {
				Util.SetImageGray(this._img_icon, true)
				this.ClearUIEffect(this.effectGp)
				this.lvLb.text = ""
			} else {
				Util.SetImageGray(this._img_icon, false)
				let devourInfo = this.model.equipData.gathering
				//this.AddUIEffect("UI_1302a", "Activity", this.effectGp, null, null, true)
				//this.CoverEffect(this.star_group, "Activity")
				//this.CoverEffect(this.lvLb, "Activity")
				//this.CoverEffect(this.reddot, "Activity")
				if (devourInfo && devourInfo.length > 0) {
					for (let _tmpi in devourInfo) {
						var vo = devourInfo[_tmpi]
						if (vo.pos == this.data.equip_type) {
							this.lvLb.text = "+" + vo.lv
							break
						}
					}
				}
			}
		}
		return true
	}

	_gp_con: Laya.Box
	_img_bg: Laya.Image
	_img_icon: Laya.Image
	effectGp: Laya.Box
	star_group: Laya.Box
	star_0: Laya.Image
	star_1: Laya.Image
	star_2: Laya.Image
	star_3: Laya.Image
	selectImg: Laya.Image
	lvLb: Laya.Label
	reddot: Laya.Image
	public GetComponents() {
		[
			this._gp_con,
			this._img_bg,
			this._img_icon,
			this.effectGp,
			this.star_group,
			this.star_0,
			this.star_1,
			this.star_2,
			this.star_3,
			this.selectImg,
			this.lvLb,
			this.reddot,
		]
			= this.GetChildrenByNames([
				"_gp_con",
				"_img_bg",
				"_img_icon",
				"effectGp",
				"star_group",
				"star_0",
				"star_1",
				"star_2",
				"star_3",
				"selectImg",
				"lvLb",
				"reddot",
			])
	}
}
window["RevelationDevourItem"] = RevelationDevourItem