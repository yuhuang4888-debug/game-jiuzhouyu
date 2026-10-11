import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MonBookModel } from "../commonModel/MonBookModel";
import { GameResPath } from "../util/GameResPath";
import { AtlasUrl, Util } from "../util/Util";

export class MonBookCardItem extends BaseItem1 {

	need_refresh_data
	model
	vo
	bar_width = 147
	public constructor(parent) {
		super(parent)
		this.base_file = "monBook"
		this.layout_file = "MonBookCardItem"
		this.need_refresh_data = false
		this.model = MonBookModel.GetInstance()

		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	private LoadSuccess() {
		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	private InitEvent() {

	}

	public SetData(vo) {
		this.vo = vo
		if (this.is_loaded) {
			this.UpdateView()
		}
		else
			this.need_refresh_data = true
	}

	private UpdateView() {
		if (this.vo) {
			let data = this.vo[0]
			let need_lv = this.vo[1]

			//this._img_bg.skin = AtlasUrl("monBook", `monBook_00${data.quality + 3}`)
			this.color_type.skin = AtlasUrl("monBook", `color_${data.quality}`)
			//this.color_bg.skin = AtlasUrl("monBook", `card_bg_${data.quality}`)
			ResManager.GetInstance().SetTexture(this, this._img_bg, GameResPath.GetMonBookImgPath(`monBook_00${(data.quality + 3)}`))
			ResManager.GetInstance().SetTexture(this, this.color_bg, GameResPath.GetMonBookImgPath(`card_bg_${data.quality}`))
			ResManager.GetInstance().SetTexture(this, this._img_res, GameResPath.GetMonBookImgPath(data.resource_id))


			this._lb_name.text = data.name.trim()

			let max_lv = this.model.GetBookMaxLevel(data.id)
			let curr_lv = this.model.GetBookLevel(data.type, data.id)

			Util.SetImageGray(this._img_res, curr_lv == 0)

			this._lb_name.strokeColor = MonBookModel.GetInstance().GetLevelColor(data.quality)

			this._lb_lv.text = `Lv.${curr_lv}`

			let real_lv = curr_lv + 1

			if (real_lv >= max_lv)
				real_lv = max_lv

			let cfg = this.model.GetMonPicLvCfg()
			let config = cfg[data.id + "@" + real_lv]

			if (!config)
				return

			let list = JSON.parse(config.cost)
			if (list && list.length) {
				let type = Number(list[0][0])
				let type_id = Number(list[0][1])
				let count = Number(list[0][2])
				let own = GoodsModel.GetInstance().GetTypeGoodsNum(type_id)
				if (curr_lv >= max_lv)
					this._lb_lv.text = "已满级"

			}
		}
	}
	color_bg: Laya.Image
	_img_res: Laya.Image
	_img_bg: Laya.Image
	_lb_name: Laya.Label
	_lb_lv: Laya.Label
	color_type: Laya.Image
	public GetComponents() {
		[
			this.color_bg,
			this._img_res,
			this._img_bg,
			this._lb_name,
			this._lb_lv,
			this.color_type,
		]
			= this.GetChildrenByNames([

				"color_bg",
				"_img_res",
				"_img_bg",
				"_lb_name",
				"_lb_lv",
				"color_type",
			])
	}
}
window["MonBookCardItem"] = MonBookCardItem