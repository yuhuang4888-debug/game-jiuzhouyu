import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { table } from "../common/table"
import { DepositModel } from "../commonModel/DepositModel"
import { Util } from "../util/Util"
import { DepositRecordItem } from "./DepositRecordItem"

export class DepositRecordView extends BaseView1 {

	loop_mgr
	model

	public constructor() {
		super()
		this.base_file = "deposit"
		this.layout_file = "DepositRecordView"
		this.layer_value = Enum_UILayer.UI
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.model = DepositModel.GetInstance()
		this.preload_server_config = {
			"config_activity_onhook_module": false,
			"config_ac":false
		}
		this.load_callback = () => {
			this.Content.scrollBar.visible = false
			this.InitEvent()
			this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19206)
		}

		this.destroy_callback = () => {
			this.Clear()
		}
	}

	public InitEvent() {
		var onClickBtnHandler = (target) => {
			let btn = target.currentTarget
			if (btn == this.close) {
				this.Close()
			}
		}
		Util.AddClickEvent(this.close, onClickBtnHandler, this, true)

		this.BindEvent(this.model, DepositModel.UPDATE_RECORD_LIST, (record_data?) => {
			this.UpdateView(record_data)
		})
	}

	public UpdateView(record_data?) {
		let list = Util.DeepCopy(record_data.record_list)
		table.sort(list, (a?, b?) => {
			return a.time > b.time
		})
		if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this.Content, DepositRecordItem, list, this.sv)
		} else {
			this.loop_mgr.replaceAll(list)
		}
		this.none_conta.visible = list.length <= 0
		// this.loop_mgr.SetData(this.Content, DepositRecordItem, {1, 2}, this.sv)
	}

	public Clear() {
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
	}

	bg: Laya.Image
	img4: Laya.Image
	sv: Laya.Panel
	Content: Laya.List
	close: Laya.Image
	img2: Laya.Image
	img3: Laya.Image
	Text: Laya.Label
	none_conta: Laya.Box
	tips: Laya.Label
	tips_icon: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.img4,
			this.sv,
			this.Content,
			this.close,
			this.img2,
			this.img3,
			this.Text,
			this.none_conta,
			this.tips,
			this.tips_icon,
		]
			= this.GetChildrenByNames([

				"bg",
				"img4",
				"sv",
				"Content",
				"close",
				"img2",
				"img3",
				"Text",
				"none_conta",
				"tips",
				"tips_icon",
			])
	}
}
window["DepositRecordView"] = DepositRecordView