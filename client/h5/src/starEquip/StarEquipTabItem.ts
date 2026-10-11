import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { ColorUtil } from "../util/ColorUtil"
import { StarEquipModel } from "../commonModel/StarEquipModel"

export class StarEquipTabItem extends BaseItemRenderer {
	WIDTH = 142
	HEIGT = 59
	CheckRed
	Outlb
	model
	need_refresh = false

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipTabItem"
		this.model = StarEquipModel.GetInstance()

		this.load_callback = () => {
			this.BindEvent(this.model, StarEquipModel.REFRESH_RED, this.CheckRed)
			if(this.need_refresh){
				this.need_refresh = false
				this.dataChanged()
			}
		}

		this.CheckRed = () => {
			if (this.data) {
				let pageId = Number(this.data.page_id)
				let equipRedList = this.model.equipRedList[pageId]
				let red = false
				if (equipRedList) {
					for (let key in equipRedList) {
						if (equipRedList[key]) {
							red = true
							break
						}
					}
				}
				if (!red) {
					red = this.model.canUnlockPage == pageId
				}
				this.reddot.visible = red
			}
		}

		this.Load()
	}

	public dataChanged() {
		if (!this.data) {
			return
		}
		if(!this.is_loaded){
			this.need_refresh = true
			return
		}
		ResManager.GetInstance().SetImageSprite(this, this.icon, "starEquip", this.data.icon1, true)
		ResManager.GetInstance().SetImageSprite(this, this.icon0, "starEquip", this.data.icon0, true)
		this.lb.text = this.data.name
		this.icon0.visible = this.selected
		this.icon.visible = !this.selected
		ResManager.GetInstance().SetImageSprite(this, this.bg, "starEquip_asset", this.selected && "uixzsy_021" || "uixzsy_022", true)
		//this.lb.size = this.selected && 22 || 20
		this.lb.color = ColorUtil.TryParseHtmlString(this.selected && "#ffffff" || "#565a97")
		this.lb.strokeColor = ColorUtil.TryParseHtmlString(this.selected && "#ad455c" || "#bfbceb")
		//this.Outlb.effectColor = ColorUtil.TryParseHtmlString(this.selected && "#e0812d" || "#a0836c")
		this.CheckRed()
	}

	bg: Laya.Image
	icon: Laya.Image
	icon0: Laya.Image
	lb: Laya.Label
	reddot: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.icon,
			this.icon0,
			this.lb,
			this.reddot,
		]
			= this.GetChildrenByNames([
				"bg",
				"icon",
				"icon0",
				"lb",
				"reddot",
			])
	}
}
window["StarEquipTabItem"] = StarEquipTabItem