import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"

export class DungeonPartnerFightKillInfoItem extends BaseItem1 {

	data
	need_refresh_data

	model: DungeonPartnerModel
	public constructor(parent) {
		super(parent)

		this.base_file = "dungeonPartner"
		this.layout_file = "DungeonPartnerFightKillInfoItem"
		this.model = DungeonPartnerModel.GetInstance()
		this.is_delay_callback = false

		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {

		this._html_desc.style.color = "#663915"
		this._html_desc.style.fontSize = 20
		this._html_desc.style.wordWrap = false

		this.InitEvent()
		if (this.need_refresh_data) {
			this.SetData(this.data)
			this.need_refresh_data = null
		}
	}

	public InitEvent() {


	}

	//data: {mon_id, cur_num, all_num}
	public SetData(data?) {

		this.data = data
		if (this.is_loaded) {
			this.UpdateItem()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateItem() {
		let data = this.data
		let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, data.mon_id, false)
		this._html_desc.innerHTML = `击杀<font color='#2791ff'> ${mon_cfg.name} (${data.cur_num}/${data.all_num})</font>`
		this.CallLater(()=>{
			this._html_desc.x = (this.display_obj.width - this._html_desc.width) / 2
		})
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	_html_desc: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._html_desc,
		]
			= this.GetChildrenByNames([

				"_html_desc",
			])
	}
}

window["DungeonPartnerFightKillInfoItem"] = DungeonPartnerFightKillInfoItem
