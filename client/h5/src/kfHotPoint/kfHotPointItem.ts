import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { TransformCurrency, Util } from "../util/Util"

export class kfHotPointItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_desc: Laya.Label
	_cond: Laya.HTMLDivElement
	_btn_go: Laya.Box
	labelDisplay: Laya.Label
	_img_icon: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_point: Laya.Label
	_draw: Laya.Image
	_img_1:Laya.Image
	Emp_btn_go
	OutlabelDisplay




	public static width = 167 + 6
	public static height = 206 + 3



	public constructor(parent) {
		super()
		this.base_file = "kfHotPoint"
		this.layout_file = "kfHotPointItem"
		this.WIDTH=173
		this.HEIGT=190
		// this.load_callback = () => {
		// 	this.LoadSuccess()

		// }
		this.Load()
	}



	public load_callback() {
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("kfHotPoint", "uikfhd_015"), true)
		// ResManager.GetInstance().SetTexture(this.base_item,this._img_1,GameResPath.GetIcon("kfHotPoint","ukfhd_015a1"))
		this.InitEvent()

	}



	public InitEvent() {
		Util.AddClickEvent(this._btn_go, () => {
			let info = this.data
			if (!info) {
				return
			}
			if (info.is_com == 0) {
				OpenFun.OpenFunHandler(info.jump_id)
			} else {
				Message.show("已完成")
			}
		}
			, this, true)
		Util.AddClickEvent(this._img_icon,()=>{
			let info = this.data
			if (!info) {
				return
			}
			if (info.is_com == 0) {
				OpenFun.OpenFunHandler(info.jump_id)
			} else {
				Message.show("已完成")
			}
		},this,true)

	}



	public dataChanged() {
		if (!super.dataChanged()) return
		let info = this.data
		if (!info) {
			return
		}
		this._desc.text = info.dec
		this._point.text = "+" + info.reward_point
		ResManager.GetInstance().SetImageSprite(this, this._img_icon, "kfHotPoint_asset", info.icon_type)
		let bool = info.is_com == 1
		let color = bool && "'#0a953e'" || "'#e31e2c'"
		if(info.condition_type == "recharge" ){
			this._cond.innerHTML = Util.StrToHTML("(<font color=" + color + ">" + TransformCurrency(info.pro_value) + "</font>/" + TransformCurrency(info.condi_val)+")")
		}else{
			this._cond.innerHTML = Util.StrToHTML("(<font color=" + color + ">" + info.pro_value + "</font>/" + info.condi_val+")")
		}
		this._cond.x=167/2-this._cond.contextWidth/2 +10
		this.labelDisplay.text = bool && "已完成" || "前往"
		if(bool){
			this.labelDisplay.visible=false
		}else{
			this.labelDisplay.visible=true
		}
		this._draw.visible = bool
	}

	public GetComponents() {
		[
			this._img_bg,
			this._desc,
			this._cond,
			this._btn_go,
			this.labelDisplay,
			this._img_icon,
			this._Image1,
			this._Image2,
			this._point,
			this._draw,
			this._img_1
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_desc",
				"_cond",
				"_btn_go",
				"labelDisplay",
				"_img_icon",
				"_Image1",
				"_Image2",
				"_point",
				"_draw",
				"_img_1"
			])
		this._cond.style.fontSize=18
		this._cond.style.color="#0a953e"
		this._cond.style.wordWrap=false
	}
}
window["kfHotPointItem"]=kfHotPointItem