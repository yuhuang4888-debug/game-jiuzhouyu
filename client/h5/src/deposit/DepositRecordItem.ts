import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { DepositModel } from "../commonModel/DepositModel"
import { TimeUtil } from "../util/TimeUtil"
import { Util, Trim } from "../util/Util"

export class DepositRecordItem extends BaseItemRenderer {
	public WIDTH = 630
	public HEIGT = 70

	model

	public static width = 630
	public static height = 70

	public constructor() {
		super()
		this.base_file = "deposit"
		this.layout_file = "DepositRecordItem"
		this.model = DepositModel.GetInstance()
		this.Load()
	}

	public load_callback() {

		this.InitEvent()
	}

	public InitEvent() {


	}

	public dataChanged() {
		if (super.dataChanged()){
			// this.txt_content.text = "07-07 21.00    为您只能托管xxxx活动，托管时长xx分钟，消耗xx托管值，托管值不足自动终止托管"
			let data = this.data
			let ac_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_ac", false);
			let cfg = this.model.GetAcCfg(data.module_id, data.sub_module, ac_cfg)
			let module_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_activity_onhook_module", false);
			let deposit_cfg = this.model.GetDepositCfg(data.module_id, data.sub_module, module_cfg)
			let time = TimeUtil.timeConversion(data.time, "mm-dd hh.mm")
			let desc = data.cost_coin / deposit_cfg.cost_min
			this.txt_content.style.fontSize = 20
			this.txt_content.width = 595
			this.txt_content.style.color = "#663915"
			this.txt_content.style.leading = 8
			this.txt_content.innerHTML = `<font color='#639c12'>${time}</font> 为您智能托管<font color='#639c12'>${Trim(cfg.ac_name)}</font>活动，托管时长<font color='#639c12'>${desc}</font>分钟，消耗<font color='#639c12'>${data.cost_coin}</font>托管值`
			
		}

	}

	txt_content: Laya.HTMLDivElement
	public GetComponents() {
		[
			this.txt_content,
		]
			= this.GetChildrenByNames([

				"txt_content",
			])
	}
}
window["DepositRecordItem"] = DepositRecordItem