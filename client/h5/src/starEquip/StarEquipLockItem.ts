import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ColorUtil } from "../util/ColorUtil"
import { chcModel } from "../commonModel/chcModel"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { ResManager } from "../common/ResManager"

export class StarEquipLockItem extends BaseItemRenderer {
	WIDTH = 390
	HEIGT = 30
	need_refresh = false
	cfg_starequip

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipLockItem"

		this.BindEvent(chcModel.GetInstance(), chcModel.UPDATE_INFO, (type?) => {
			if (type == chcModel.CHCTYPE.EVO || type == chcModel.CHCTYPE.STREN) {
				this.dataChanged()
			}
		})

		this.load_callback = () => {
			this.cfg_starequip = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "ClientStarEquip", true)

			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public dataChanged() {
		if (!this.data) {
			return
		}
		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}
		//let pageCfg = Config.ClientStarEquip
		let pageCfg = this.cfg_starequip
		if (pageCfg) {
			let tabList = pageCfg.tabList
			let [lock, num] = StarEquipModel.GetInstance().GetPageCondition(this.data)
			let str = ""
			if (this.data[0] == "constellation_num") {
				str = "穿戴" + num + "/" + this.data[3] + "件" + tabList[Number(this.data[1]) - 1].name + "套装部件"
			} else if (this.data[0] == "evolution_lv") {
				str = tabList[Number(this.data[1]) - 1].name + "装备总进化等级达到" + num + "/" + this.data[2] + "级"
			} else if (this.data[0] == "strength_lv") {
				str = tabList[Number(this.data[1]) - 1].name + "装备总强化等级达到" + num + "/" + this.data[2] + "级"
			}
			let color = lock && "#b3ff48" || "#ff4f50"
			this.lockLb.text = str
			this.lockLb.color = ColorUtil.TryParseHtmlString(color)
			this.select.visible = lock
			this.unselect.visible = !lock
		}
	}

	lockLb: Laya.Label
	unselect: Laya.Image
	select: Laya.Image
	public GetComponents() {
		[
			this.lockLb,
			this.unselect,
			this.select,
		]
			= this.GetChildrenByNames([
				"lockLb",
				"unselect",
				"select",
			])
	}
}
window["StarEquipLockItem"] = StarEquipLockItem