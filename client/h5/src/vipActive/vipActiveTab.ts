import { BaseItem1 } from "../common/BaseItem1"
import { SetSizeDeltaX, SetAnchoredPositionX, Util, SetAnchoredPositionY } from "../util/Util"

export class VipActiveTab extends BaseItem1 {
	_Group1: Laya.Box
	_con_select: Laya.Box
	_Image11: Laya.Image
	selectImg: Laya.Image
	_lbl_name1: Laya.Label
	_con_normal: Laya.Box
	_Image1: Laya.Image
	_lbl_name: Laya.Label
	_img_click:Laya.Image
	Out_lbl_name
	Out_lbl_name1
	on_click_func
	selected
	index
	public constructor(parent?) {
		super(parent)

		this.base_file = "vipActive"
		this.layout_file = "vipActiveTab"

		this.load_callback = () => {


			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this._lbl_name.size = 16
			// 	SetSizeDeltaX(this._lbl_name, 80)
			// 	SetAnchoredPositionX(this._lbl_name, 4)
			// 	this._lbl_name.verticalAlign = "top"
			// 	this._lbl_name.textAlign = "center"
			// 	this._lbl_name1.size = 16
			// 	SetSizeDeltaX(this._lbl_name1, 80)
			// 	SetAnchoredPositionX(this._lbl_name1, 4)
			// 	this._lbl_name1.verticalAlign = "top"
			// 	this._lbl_name1.textAlign = "center"
			// }
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
			// 	this._lbl_name1.size = 16
			// 	this._lbl_name.size = 16
			// }

			Util.AddClickEvent(this._img_click, () => {
				if (this.on_click_func) {
					this.on_click_func(this.index)
				}
			}
				, this, true)
			//this.selectImg.visible = this.selected == true 
		}
	}



	public SetOnClick(click_func?,index?) {
		this.index=index
		this.on_click_func = click_func
	}

	public SetSelected(selected?) {

		this.selected = selected
		if (this.is_loaded) {
			this._con_select.visible = this.selected == true
			this._con_normal.visible = this.selected != true
		}
	}

	public SetRes(res?) {

		//if (res && this.desImg ) {
		// this.desImg.source = "vipActive_asset." + res + ""
		//lua_resM:SetImageSprite(this, this.desImg, "vipactive_asset", res, true)
		//}
	}

	public SetName(name?) {

		name = name || ""
		if (this.is_loaded) {
			this._lbl_name.text = name
			this._lbl_name1.text = name
			if (name == "ชุดแดง\nเฉพาะ") {
				this._lbl_name.text = "ชุด\nแดง"
				this._lbl_name1.text = "ชุด\nแดง"
			}
			if (name == "แพ็ก\nรายวัน") {
				this._lbl_name.text = "แพ็กรายวัน"
				this._lbl_name1.text = "แพ็กรายวัน"
				this._lbl_name.fontSize = 16
				this._lbl_name1.fontSize = 16
				SetSizeDeltaX(this._lbl_name, 90)
				SetSizeDeltaX(this._lbl_name1, 90)
				SetAnchoredPositionY(this._lbl_name, -42.9)
				SetAnchoredPositionY(this._lbl_name1, -42.9)
			}
		}
	}


	public GetComponents() {
		[
			this._Group1,
			this._con_select,
			this._Image11,
			this.selectImg,
			this._lbl_name1,
			this._con_normal,
			this._Image1,
			this._lbl_name,
			this._img_click
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_con_select",
				"_Image11",
				"selectImg",
				"_lbl_name1",
				"_con_normal",
				"_Image1",
				"_lbl_name",
				"_img_click"
			])
	}
}
window["VipActiveTab"]=VipActiveTab