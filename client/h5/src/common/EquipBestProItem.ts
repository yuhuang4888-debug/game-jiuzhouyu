import { Util } from "../util/Util"
import { BaseItem1 } from "./BaseItem1"
import { WordManager } from "./WordManager"
import { ColorUtil } from "../util/ColorUtil"
import { RoleManager } from "../commonModel/RoleManager"
export class EquipBestProItem extends BaseItem1 {
	public star: Laya.Image;
	public pro: Laya.HTMLDivElement;

	is_delay_callback
	is_preview
	needRefresh
	pro_pos_x
	data

	public static Height = 24;
	public constructor(parent?) {
		super(parent)


		this.pro_pos_x = 0;

		this.base_file = "common"
		this.layout_file = "EquipBestProItem"
		this.is_delay_callback = false
		this.load_callback = () => {
			this.pro.width = 346.5
			this.pro.style.fontSize = 20
			this.pro.style.color = "#ffffff"

			this.LoadSuccess()
			this.InitEvents()
		}


	}

	public LoadSuccess() {

		//this.pro_pos_x = this.pro.x
	}

	public InitEvents() {

		if (this.needRefresh) {
			this.SetData(this.data, this.is_preview)
		}
	}

	public SetData(data?, is_preview?) {


		this.data = data
		this.is_preview = is_preview
		if (this.is_loaded) {
			if (this.is_preview) {
				this.star.visible = false
				let pro = WordManager.GetProperties(this.data[1][1])
				// let color = ColorUtil.GetColorLight(this.data[1][0])
				let color = ColorUtil.GetColorDark(this.data[1][0])
				let value = 0
				if (WordManager.IsGrowthProType(Number(this.data[1][1]))) {
					value = WordManager.ConvertToPercentValue(this.data[1][1], this.data[1][4])
				} else {
					value = WordManager.ConvertToPercentValue(this.data[1][1], this.data[1][2])
				}
				let index = Number(pro.indexOf('{0}'))
				if (index && index >= 0) {
					pro = pro.replace("{0}", this.data[1][3])
				}
				let str = "<font color=" + color + ">[推荐] " + pro + (" +") + value + "</font>"
				this.pro.innerHTML = Util.StrToHTML(str)
			} else {
				this.star.visible = false
				let pro = WordManager.GetProperties(this.data.attr_id)
				let color = ColorUtil.GetColorLight(this.data.color)
				let value = WordManager.ConvertToPercentValue(this.data.attr_id, this.data.attr_val)
				if (this.data.type_id == 1) {
					let level = RoleManager.GetInstance().mainRoleInfo.level
					value = this.data.plus_unit
					pro = pro.replace("{0}", this.data.plus_interval) //pro:gsub("{0}", this.data.plus_interval)
				}
				let str = "<font color=" + color + ">" + pro + (" +") + value + "</font>"
				this.pro.innerHTML = Util.StrToHTML(str)
			}
		} else {
			this.needRefresh = true
		}
	}

	public GetComponents() {
		[
			this.star,
			this.pro
		] = this.GetChildrenByNames([
			"star",
			"pro"
		])
	}

}
window["EquipBestProItem"] = EquipBestProItem