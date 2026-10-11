import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { StarEquipModel } from "../commonModel/StarEquipModel"

export class StarEquipUpMasterView extends BaseView1 {
	EmpcancelBtn
	EmpenterBtn
	InitView
	Open
	data

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipUpMasterView"
		this.layer_value = Enum_UILayer.Activity
		//let local_util = Util
		this.is_center = true
		this.use_background = true
		this.show_open_movie = true
		this.click_bg_toClose = true

		this.load_callback = () => {
			this.lb1.style.fontSize = 20
			this.lb1.style.color = "#663915"
			this.lb1.style.wordWrap = false
			
			this.lb2.style.fontSize = 20
			this.lb2.style.color = "#663915"
			this.lb2.style.wordWrap = false

			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.cancelBtn, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.enterBtn, () => {
				StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipMasterView")
				this.Close()
			}, this, true)

			this.InitView()
		}

		this.Open = (...new_args) => {
			this.data = new_args[0]
			this.InitView()
			super.Open()
		}

		this.InitView = () => {
			if (this.data && this.is_loaded) {
				this.lb1.innerHTML = Util.StrToHTML("您穿戴的装备达到累计<font color='#d15e00'>" + this.data[0] + "条星级卓越属性</font>")
				this.lb2.innerHTML = Util.StrToHTML("可以提升<font color='#519c00'>星级大师至" + this.data[1] + "级</font>")
				this.starLb.text = StarEquipModel.GetInstance().totalStar
				
				this.CallLater(()=>{
					this.lb2.event("resize")
				})
			}
		}
	}

	_Image1: Laya.Image
	_Image3: Laya.Image
	closeBtn: Laya.Image
	_Image2: Laya.Image
	cancelBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	enterBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay1: Laya.Label
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_lb_title: Laya.Label
	_gp_star: Laya.HBox
	starLb: Laya.Label
	_img_satr: Laya.Image
	_gp_tips: Laya.VBox
	lb1: Laya.HTMLDivElement
	lb2: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._Image1,
			this._Image3,
			this.closeBtn,
			this._Image2,
			this.cancelBtn,
			this._Image111,
			this.labelDisplay,
			this.enterBtn,
			this._Image11,
			this.labelDisplay1,
			this._Image5,
			this._Image6,
			this._Image7,
			this._lb_title,
			this._gp_star,
			this.starLb,
			this._img_satr,
			this._gp_tips,
			this.lb1,
			this.lb2,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image3",
				"closeBtn",
				"_Image2",
				"cancelBtn",
				"_Image111",
				"labelDisplay",
				"enterBtn",
				"_Image11",
				"labelDisplay1",
				"_Image5",
				"_Image6",
				"_Image7",
				"_lb_title",
				"_gp_star",
				"starLb",
				"_img_satr",
				"_gp_tips",
				"lb1",
				"lb2",
			])
	}
}
window["StarEquipUpMasterView"] = StarEquipUpMasterView