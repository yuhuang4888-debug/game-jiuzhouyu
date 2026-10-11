import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GuildActivityModel, GuildActEvent } from "../commonModel/GuildActivityModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class EveningBossTipsView extends BaseView1 {
	background_alpha
	change_scene_close
	click_bg_toClose
	destroy_imm
	is_center
	show_open_movie
	use_background


	public constructor() {
		super()

		this.base_file = "evening"
		this.layout_file = "EveningBossTipsView"
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

		this.close_callback = () => {

		}
	}

	public LoadSuccess() {

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg0, GameResPath.GetIcon("evening", "ui_ghsl_002"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg0, GameResPath.GetIcon("kfHolyArea", "uikfsy_034"), true)
		this.InitEvent()
	}

	public InitEvent() {

		Util.AddClickEvent(this._gp_go, () => {
			GuildActivityModel.GetInstance().Fire(GuildActEvent.REQUEST_PROTO, 40212)
			this.Close()
		}, this, true)

		Util.AddClickEvent(this._btn_close, () => {
			this.Close()
		}, this, true)

	}

	public DeleteMe() {
		super.DeleteMe()
	}


_img_bg:Laya.Image
_img_bg0:Laya.Image
_img_icon:Laya.Image
_gp_go:Laya.Box
_Image1:Laya.Image
labelDisplay1:Laya.Label
_Label3:Laya.Label
_img_jiejie_b:Laya.Image
_bg_title:Laya.Label
_btn_close:Laya.Image
public GetComponents() {
[
this._img_bg,
this._img_bg0,
this._img_icon,
this._gp_go,
this._Image1,
this.labelDisplay1,
this._Label3,
this._img_jiejie_b,
this._bg_title,
this._btn_close,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_bg0",
"_img_icon",
"_gp_go",
"_Image1",
"labelDisplay1",
"_Label3",
"_img_jiejie_b",
"_bg_title",
"_btn_close",
])
}
}
 window["EveningBossTipsView"]= EveningBossTipsView