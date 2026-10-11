import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class DiamondFightBetRecordView extends BaseView1 {

	item_list
	tips1
	tips_icon1


	model: DiamondFightModel
	res_mgr: ResManager
	public constructor() {
		super()

		this.base_file = "diamondFight"
		this.layout_file = "DiamondFightBetRecordView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.use_background = true
		this.change_scene_close = true
		this.show_open_movie = true
		this.is_center = true

		this.model = DiamondFightModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.preload_server_config = {
			"config_career": false,
			"config_drumwar_choose": false,
			"config_drumwar_lv_to_zone": false
		}


		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	public Remove() {

		if (this.item_list) {
			for (let _tmpi in this.item_list) {
				var obj = this.item_list[_tmpi]
				obj.DeleteMe()
			}
			this.item_list = false
		}
	}

	public LoadSuccess() {

		//resource/game/diamondFight/texture/ui_content_bg2.png
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("diamondFight", "ui_content_bg2"))


		this._panel_item.vScrollBarSkin = ""
		this.InitEvent()
		this.UpdateView()
		this.model.Fire(DiamondFightModel.REQUEST_SCMD, 13721)
	}

	public InitEvent() {

		this.BindVar(this.model, "record_info", () => {
			this.UpdateView()
		})

		Util.AddClickEvent(
			this._img_close, () => {
				this.Close()
			}, this, true)
	}

	public UpdateView() {

		let config_drumwar_lv_to_zone = this.res_mgr.GetGameConfigFromCache(this, "config_drumwar_lv_to_zone", false)
		let zone = this.model.zone || DiamondFightModel.GetZoneByLv(null, config_drumwar_lv_to_zone)
		let info = this.model.record_info

		// 测试
		// let info = this.GetTestData()
		// let zone = 3

		if (!zone || !info) {
			return
		}
		let record_list = info[zone]
		let list = []
		if (record_list) {
			for (let _tmpi in record_list) {
				var vo = record_list[_tmpi]
				if (vo.winner != 0) {
					table.insert(list, vo)
				}
			}
		}
		if (list.length > 0) {
			this._lb_none.visible = false
			if (!this.item_list) {
				this.item_list = []
			}
			let i = list.length
			if (i < this.item_list.length) {
				do {
					this.item_list[i].SetVisible(false)
					i = i + 1
				} while ((i < this.item_list.length)
				)
			}
			let item = null

			let DiamondFightBetRecordItem = window["DiamondFightBetRecordItem"]
			if (DiamondFightBetRecordItem) {
				let vo
				for (let key in list) {
					vo = list[key]
					item = this.item_list[key]
					if (!item) {
						item = new DiamondFightBetRecordItem(this._panel_item)
						this.item_list[key] = item
						item.Load()
						item.SetPosition(0, 197 * Number(key))
					}
					item.SetData(vo)
					item.SetVisible(true)
				}
			}
		} else {
			if (!this.item_list) {
				this.item_list = []
			}
			let i = 0
			if (i < this.item_list.length) {
				do {
					this.item_list[i].SetVisible(false)
					i = i + 1
				} while ((i < this.item_list.length)
				)
			}
			this._lb_none.visible = true
		}
	}

	public GetTestData() {

		return {
			[3]: [{
				zone: 3,
				action: 9,
				suprid: 4,
				guess_type: 2,
				reward_st: 0,
				winner: 4,
				arid: 3,
				asid: 1,
				asnum: 0,
				aname: "锤子3",
				alv: 3,
				asex: 2,
				acareer: 2,
				apic: "",
				apicver: 0,
				apower: 3,
				brid: 4,
				bsid: 1,
				bsnum: 0,
				bname: "锤子4",
				blv: 4,
				bsex: 1,
				bcareer: 1,
				bpic: "",
				bpicver: 0,
				bpower: 4
			},
			{
				zone: 3,
				action: 10,
				suprid: 5,
				guess_type: 2,
				reward_st: 0,
				winner: 6,
				arid: 6,
				asid: 1,
				asnum: 0,
				aname: "锤子6",
				alv: 6,
				asex: 2,
				acareer: 2,
				apic: "",
				apicver: 0,
				apower: 6,
				brid: 5,
				bsid: 1,
				bsnum: 0,
				bname: "锤子5",
				blv: 5,
				bsex: 1,
				bcareer: 1,
				bpic: "",
				bpicver: 0,
				bpower: 5
			},
			{
				zone: 3,
				action: 11,
				suprid: 6,
				guess_type: 1,
				reward_st: 0,
				winner: 6,
				arid: 4,
				asid: 1,
				asnum: 0,
				aname: "锤子4",
				alv: 4,
				asex: 2,
				acareer: 2,
				apic: "",
				apicver: 0,
				apower: 4,
				brid: 6,
				bsid: 1,
				bsnum: 0,
				bname: "锤子6",
				blv: 6,
				bsex: 1,
				bcareer: 1,
				bpic: "",
				bpicver: 0,
				bpower: 6
			},
			{
				zone: 3,
				action: 12,
				suprid: 8,
				guess_type: 2,
				reward_st: 1,
				winner: 8,
				arid: 3,
				asid: 1,
				asnum: 0,
				aname: "锤子3",
				alv: 3,
				asex: 2,
				acareer: 2,
				apic: "",
				apicver: 0,
				apower: 3,
				brid: 8,
				bsid: 1,
				bsnum: 0,
				bname: "锤子8",
				blv: 8,
				bsex: 1,
				bcareer: 1,
				bpic: "",
				bpicver: 0,
				bpower: 8
			}]
		}

	}
	_img_bg: Laya.Image
	_lb_title: Laya.Label
	_img_close: Laya.Image
	_img_bg2: Laya.Image
	_lb_none: Laya.Label
	_panel_item: Laya.Panel
	public GetComponents() {
		[
			this._img_bg,
			this._lb_title,
			this._img_close,
			this._img_bg2,
			this._lb_none,
			this._panel_item,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_title",
				"_img_close",
				"_img_bg2",
				"_lb_none",
				"_panel_item",
			])
	}

}
window["DiamondFightBetRecordView"] = DiamondFightBetRecordView
