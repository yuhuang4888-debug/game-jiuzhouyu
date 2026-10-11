import { BaseView1, OpenMode } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildModel } from "../commonModel/GuildModel"
import { SetAnchoredPositionX, Util } from "../util/Util"
import { GuildIdolRuneSelItem } from "./GuildIdolRuneSelItem"

export class GuildIdolRuneSelView extends BaseView1 {
	Local_DeleteMe
	Scr_Scroller1
	click_bg_toClose
	destroy_imm
	is_center
	open_callback
	open_mode
	use_background

	public constructor() {
		super()

		this.base_file = "guildidol"
		this.layout_file = "GuildIdolRuneSelView"
		this.layer_value = Enum_UILayer.Activity
		this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.is_center = true
		this.click_bg_toClose = true
		this.use_background = true
		let _model = GuildModel.GetInstance()
		let ac = null
		let goods_model = GoodsModel.GetInstance()
		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouKrPlatform()) {
			// 	SetAnchoredPositionX(this._gp_null, -68)
			// }
			// this.RegisterMask(this._Viewport1)


			Util.AddClickEvent(this.close_img, () => {
				this.Close()
			}, this, true)
		}

		this.open_callback = () => {
			let data = goods_model.guildRuneList
			table.sort(data, (a?, b?) => {
				return a.type_id > b.type_id
			})
			if (!ac) {
				ac = new LoopScrowViewMgr(this.layer_value)
				ac.SetData(this._list, GuildIdolRuneSelItem, data, LoopScrCon.Vertical)
			} else {
				ac.replaceAll(data)
			}
			this._gp_null.visible =data? data.length <= 0:true
		}

		this.Local_DeleteMe = () => {
			if (ac) {
				ac.DeleteMe()
				ac = null
			}
		}


	}

	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}

	

_Image1:Laya.Image
_img_title_bg:Laya.Image
_lb_title:Laya.Label
_Image3:Laya.Image
_list:Laya.List
_gp_null:Laya.Box
_Image4:Laya.Image
_Label2:Laya.Label
close_img:Laya.Image
public GetComponents() {
[
this._Image1,
this._img_title_bg,
this._lb_title,
this._Image3,
this._list,
this._gp_null,
this._Image4,
this._Label2,
this.close_img,
]
 = this.GetChildrenByNames([

"_Image1",
"_img_title_bg",
"_lb_title",
"_Image3",
"_list",
"_gp_null",
"_Image4",
"_Label2",
"close_img",
])
}
}
 window["GuildIdolRuneSelView"]= GuildIdolRuneSelView