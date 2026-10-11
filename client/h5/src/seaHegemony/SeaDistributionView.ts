import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class SeaDistributionView extends BaseView1 {
	InitView
	model
	public constructor() {
		super()


		this.base_file = "seaHegemony"
		this.layout_file = "SeaDistributionView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		let local_util = Util
		let local_model = SeaHegemonyModel
		let local_modelIns = local_model.GetInstance()
		this.load_callback = () => {
			this.InitView()
		}

		this.destroy_callback = () => {
			local_modelIns.disSelectId = null
			local_modelIns.disServerId = null
		}

		this.InitView = () => {

			//先屏蔽
			// Util.AddClickEvent(this.btnGp, () => {
			// 	if (this.data) {
			// 		this.model.disSelectId = this.data.role_id
			// 		this.model.disServerId = this.data.server_id
			// 		this.SetSelect()
			// 		this.model.Fire(SeaHegemonyModel.SELECT_DIS, this.data.role_id)
			// 	}
			// }
			// 	, this, true)
			// this.BindEvent(this.model, SeaHegemonyModel.SELECT_DIS, (id?) => {
			// 	if (this.data && id != this.data) {
			// 		this.SetSelect()
			// 	}
			// }
			// )


			// let data = local_modelIns.seaSoldierData.job_list
			// // let itemArr = eui.new ArrayCollection(data)
			// // this.dataGp.itemRenderer = SeaDistributionItem
			// // this.dataGp.dataProvider = itemArr
			// Util.AddClickEvent(this.cancelBtn, () => {
			// 	this.Close()
			// }
			// 	, this, true)
			// Util.AddClickEvent(this.disBtn, () => {
			// 	let id = local_modelIns.disSelectId
			// 	if (id && this.count) {
			// 		local_modelIns.Fire(local_model.REQUEST_PROTO, 18616, "ilc", local_modelIns.disServerId, id, this.count)
			// 	}
			// }
			// 	, this, true)
			// Util.AddClickEvent(this.closeBtn, () => {
			// 	this.Close()
			// }
			// 	, this, true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("common", "uisy_023"))
		}


	}



	public dataChanged() {
		//先屏蔽
		// if (super.dataChanged()) {
		// 	this.nameLb.text = "S" + this.data.server_num + "." + this.data.role_name
		// 	this.scoreLb.text = 0
		// 	this.positionLb.text = this.model.GetPositionName(this.data.self_level)
		// 	this.fightLb.text = this.data.power
		// 	this.SetSelect()
		// }
	}

	public SetSelect() {
		//先屏蔽
		// let select = this.model.disSelectId == this.data.role_id
		// this.selectImg.visible = select
		// this.unSelectImg.visible = !select
	}


	bg: Laya.Image
	closeBtn: Laya.Image
	_Image1111: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.VBox
	_Label1: Laya.Label
	_Label2: Laya.Label
	_Label3: Laya.Label
	_Label4: Laya.Label
	_Label5: Laya.Label
	cancelBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	disBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	_Image9: Laya.Image
	_Image10: Laya.Image
	_Image11: Laya.Image
	_Image12: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.closeBtn,
			this._Image1111,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Image8,
			this._Scroller1,
			this.Content,
			this._Label1,
			this._Label2,
			this._Label3,
			this._Label4,
			this._Label5,
			this.cancelBtn,
			this._Image1,
			this.labelDisplay1,
			this.disBtn,
			this._Image111,
			this.labelDisplay,
			this._Image9,
			this._Image10,
			this._Image11,
			this._Image12,
		]
			= this.GetChildrenByNames([

				"bg",
				"closeBtn",
				"_Image1111",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Image8",
				"_Scroller1",
				"Content",
				"_Label1",
				"_Label2",
				"_Label3",
				"_Label4",
				"_Label5",
				"cancelBtn",
				"_Image1",
				"labelDisplay1",
				"disBtn",
				"_Image111",
				"labelDisplay",
				"_Image9",
				"_Image10",
				"_Image11",
				"_Image12",
			])
	}
}
window["SeaDistributionView"] = SeaDistributionView