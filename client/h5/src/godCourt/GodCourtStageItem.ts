import { GodCourtEquipItem } from "./GodCourtEquipItem"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { Message } from "../sysInfo/SysInfoController"

export class GodCourtStageItem extends GodCourtEquipItem {
	RedFunc
	local_ClickEvent

	public constructor(parent?) {
		super(parent)
		this.base_file = "godCourt"
		this.layout_file = "GodCourtStageItem"

		let local_godCourtModel = GodCourtModel
		let local_gcIns = local_godCourtModel.GetInstance()

		this.AddEvent = () => {
			this.BindEvent(local_gcIns, local_godCourtModel.SELECT_STAGE, (subtype?) => {
				if (this.data) {
					if (this.data.subtype == subtype || this.data.pos == subtype) {
						this.selectImg.visible = true
					} else {
						this.selectImg.visible = false
					}
				}
			})
		}

		this.local_ClickEvent = () => {
			if (this.data && this.data.equip_id != 0) {
				local_gcIns.Fire(local_godCourtModel.SELECT_STAGE, this.data.subtype || this.data.pos)
			} else {
				Message.show("请先穿戴纹章后再进行升阶")
			}
		}

		this.RedFunc = () => {
			if (this.data) {
				let pos = this.data.subtype || this.data.pos
				let list = local_gcIns.upStageRedList[this.data.godCourtId]
				if (list) {
					this.redImg.visible = list[pos]
				} else {
					this.redImg.visible = false
				}
			}
		}
	}

	clickGp: Laya.Box
	bg: Laya.Image
	_gp_effect: Laya.Box
	colorImg: Laya.Image
	icon: Laya.Image
	selectImg: Laya.Image
	stageLb: Laya.Label
	redImg: Laya.Image
	public GetComponents() {
		[
			this.clickGp,
			this.bg,
			this._gp_effect,
			this.colorImg,
			this.icon,
			this.selectImg,
			this.stageLb,
			this.redImg,
		]
			= this.GetChildrenByNames([
				"clickGp",
				"bg",
				"_gp_effect",
				"colorImg",
				"icon",
				"selectImg",
				"stageLb",
				"redImg",
			])
	}
}
window["GodCourtStageItem"] = GodCourtStageItem