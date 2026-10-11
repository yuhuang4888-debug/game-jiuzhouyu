import { BaseView1 } from "../common/BaseView1"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
export class KfHolyAreaRebornTipsView extends BaseView1 {
	_img_bg: Laya.Image
	_lb_title: Laya.Label
	_Label1: Laya.Label
	_Label2: Laya.Label
	_gp_go: Laya.Box
	_Image1: Laya.Image
	_Label3: Laya.Label
	_Group1: Laya.Box
	tip_bg_img: Laya.Image
	tip_lb: Laya.HTMLDivElement
	_Image2: Laya.Image
	_Image3: Laya.Image
	background_alpha
	change_scene_close
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	model
	show_open_movie
	use_background


	public constructor() {
		super()

		this.base_file = "kfHolyArea"
		this.layout_file = "KfHolyAreaRebornTipsView"
		this.model = KfHolyAreaModel.GetInstance()
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.is_center = true
		this.destroy_imm = true
		this.change_scene_close = true
		this.use_background = true
		this.background_alpha = 0
		this.click_bg_toClose = true


		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.destroy_callback = () => { }
	}


	public LoadSuccess() {


		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("kfHolyArea", "uikfsy_033"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this.tip_bg_img, GameResPath.GetIcon("kfHolyArea", "uikfsy_034"))
		this.tip_lb.style.fontSize = 21
		this.tip_lb.style.valign = "center"
		this.tip_lb.style.color = "#4a3a32"
		this.tip_lb.width = 470

		let tip_str = "<font color='#4a3a32'>击杀异域大妖收集影装套装，大幅提升战力</font>" //\n<font color=0x639c12>参战人数越多产出拍卖品越丰厚，齐齐分钻石！</font>
		this.tip_lb.innerHTML = Util.StrToHTML(tip_str)
		this.InitEvent()
	}

	public InitEvent() {

		Util.AddClickEvent(this._gp_go, () => {
			this.model.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaEnterView")
			this.Close()
		}, this, true)
	}


	public GetComponents() {
		[
			this._img_bg,
			this._lb_title,
			this._Label1,
			this._Label2,
			this._gp_go,
			this._Image1,
			this._Label3,
			this._Group1,
			this.tip_bg_img,
			this.tip_lb,
			this._Image2,
			this._Image3,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_title",
				"_Label1",
				"_Label2",
				"_gp_go",
				"_Image1",
				"_Label3",
				"_Group1",
				"tip_bg_img",
				"tip_lb",
				"_Image2",
				"_Image3",
			])
	}
}
window["KfHolyAreaRebornTipsView"] = KfHolyAreaRebornTipsView