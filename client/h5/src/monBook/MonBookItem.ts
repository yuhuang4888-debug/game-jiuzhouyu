import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MonBookModel } from "../commonModel/MonBookModel"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { AtlasUrl, Util } from "../util/Util"

export class MonBookItem extends BaseItemRenderer {
	public WIDTH = 160
	public HEIGT = 204
	public static HEIGT_UI = 204

	private goods_id = 0
	private cost_count = 0
	model: MonBookModel
	select_index = null
	bar_width = 103
	tween_ids
	time_out_id
	is_frist_load
	public constructor() {
		super()
		this.base_file = "monBook"
		this.layout_file = "MonBookItem"
		this.is_frist_load=true
		this.model = MonBookModel.GetInstance()
		this.Load()
	}

	public load_callback() {
		if (PlatformManager.IsEyouEnPlatform()) {
			this._lb_name.fontSize = 16
			this._lb_name.wordWrap =true
			this._lb_name.leading = 0.1
			this._lb_name.valign = "middle"
		}


		/*this.BindEvent(this.model, MonBookModel.UPDATE_MONBOOK_ITEM, () => {
			let book_data = this.data
			let is_red = this._img_red.visible
			this.model.Fire(MonBookModel.UPDATE_MONBOOK_MESSAGE, book_data, this.goods_id, this.cost_count, is_red)
		})*/

		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, (goods_list) => {
			if (this.use_delete_method) return
			for (let info of goods_list) {
				if (this.goods_id && this.goods_id == info.type_id) {
					this.UpdateProgress()
					break
				}
			}
		})

		this.BindEvent(this.model, MonBookModel.PLAY_EFFECT, (pic_id) => {
			if (!this.use_delete_method && this.data && this.data.id && this.data.id == pic_id) {
				this.base_item.AddUIEffect("UI_1404", this._gp_effect, null, 8, null, null, null, null, null, null, null, null, false)
			}
		})



		// Util.AddClickEvent(this._gp_item, () => {
		// 	let book_data = this.data
		// 	// if (this.data && this.data.id == 53020001 && FunctionOpenModel.GetInstance().IsInShowingStory(FuncOpenId.MonBook)) {

		// 	// } else {
		// 	if (this.data.id == this.model.select_id) return
		// 	this.model.is_first_create = this.data.id
		// 	this.selete_img.visible = true
		// 	let is_red = this._img_red.visible
		// 	this.model.Fire(MonBookModel.UPDATE_MONBOOK_MESSAGE, book_data, this.goods_id, this.cost_count, is_red)
		// 	// }

		// }, this, true)
	}

	public createChildren(): void {
		super.createChildren()
	}


	public PlayAnimation2(row) {
		if (!this.is_loaded) {
			this.select_index = row
			return
		}

		if (!this.tween_ids) {
			this.tween_ids = []
		}
		this.ClearTweens()
		let move_time = 250
		let time = 100 * (row - 1)
		this._gp_item.x = 661 + 87
		this.time_out_id = setTimeout(() => {
			Laya.Tween.to(this._gp_item, { x: 87 }, move_time, Laya.Ease.cubicOut, Laya.Handler.create(this, () => {
				if (this._gp_item)
					Laya.Tween.clearAll(this._gp_item)
			}))


		}, time);

	}

	public ClearTweens() {

		if (this._gp_item)
			Laya.Tween.clearAll(this._gp_item)

		if (this.time_out_id) {
			clearTimeout(this.time_out_id)
			this.time_out_id = null
		}
		if (this.tween_ids && this.tween_ids.length > 0) {
			for (let i = 0; i < this.tween_ids.length; i++) {
				SYTweenLite.Stop(this.tween_ids[i])
			}
			this.tween_ids = []
		}

	}

	protected dataChanged(): void {
		if (super.dataChanged()) {

			if(this.is_frist_load){
				this.is_frist_load=false
				MonBookModel.GetInstance().Fire(MonBookModel.PLAY_ITEM_ANIMATION)
			}
		
			this.selete_img.visible = false
			//this._img_bg.skin = AtlasUrl("monBook", `monBook_00${(this.data.quality + 3)}`)
			this.color_type.skin = AtlasUrl("monBook", `color_${this.data.quality}`)
			//this.color_bg.skin = AtlasUrl("monBook", `card_bg_${this.data.quality}`)

			ResManager.GetInstance().SetTexture(this.base_item, this._img_bg, GameResPath.GetMonBookImgPath(`monBook_00${(this.data.quality + 3)}`))
			ResManager.GetInstance().SetTexture(this.base_item, this.color_bg, GameResPath.GetMonBookImgPath(`card_bg_${this.data.quality}`))
			ResManager.GetInstance().SetTexture(this.base_item, this._img_res, GameResPath.GetMonBookImgPath(this.data.resource_id))

			let curr_lv = this.model.GetBookLevel(this.data.type, this.data.id)

			Util.SetImageGray(this._img_res, curr_lv == 0)
			this.unacitivated_img.visible = curr_lv == 0 ? true : false

			if (curr_lv == 0) {
				this._lb_name.strokeColor = MonBookModel.GetInstance().GetLevelColor(-1)
			}
			else {
				this._lb_name.strokeColor = MonBookModel.GetInstance().GetLevelColor(this.data.quality)
			}

			let max_lv = this.model.GetBookMaxLevel(this.data.id)

			let real_lv = curr_lv + 1
			if (real_lv >= max_lv)
				real_lv = max_lv

			let mon_pic_lv = this.model.GetMonPicLvCfg()
			let config = mon_pic_lv ? mon_pic_lv[this.data.id + "@" + real_lv] : undefined
			if (!config)
				return

			let list = JSON.parse(config.cost)
			if (list && list.length) {
				let type = Number(list[0][0])
				let type_id = Number(list[0][1])
				let count = Number(list[0][2])
				let mon_book_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.id)
				this._lb_name.text = mon_book_vo.goods_name
				this.goods_id = type_id
				this.cost_count = count
				this.UpdateProgress()


			}

			this.selete_img.visible = this.selected


			if (this.select_index && this.select_index >= 0) {
				this.select_index = null
				this.PlayAnimation2(this.select_index)
			}
		}
	}

	public UpdateProgress() {
		let curr_lv = this.model.GetBookLevel(this.data.type, this.data.id)
		let max_lv = this.model.GetBookMaxLevel(this.data.id)
		let own_count = GoodsModel.GetInstance().GetTypeGoodsNum(this.goods_id)

		if (curr_lv >= max_lv) {
			this._lb_desc.text = "已满级"
			this._img_red.visible = false
		}
		else {
			this._lb_desc.text = `Lv.${curr_lv}`
			this._img_red.visible = (own_count / this.cost_count) >= 1
		}
	}

	public DeleteMe() {
		this.ClearTweens()
		super.DeleteMe()
	}


	_gp_item: Laya.Box
	color_bg: Laya.Image
	_gp_effect: Laya.Box
	_img_res: Laya.Image
	_img_bg: Laya.Image
	_lb_name: Laya.Label
	_lb_desc: Laya.Label
	selete_img: Laya.Image
	_img_red: Laya.Image
	unacitivated_img: Laya.Image
	color_type: Laya.Image
	public GetComponents() {
		[
			this._gp_item,
			this.color_bg,
			this._gp_effect,
			this._img_res,
			this._img_bg,
			this._lb_name,
			this._lb_desc,
			this.selete_img,
			this._img_red,
			this.unacitivated_img,
			this.color_type,
		]
			= this.GetChildrenByNames([

				"_gp_item",
				"color_bg",
				"_gp_effect",
				"_img_res",
				"_img_bg",
				"_lb_name",
				"_lb_desc",
				"selete_img",
				"_img_red",
				"unacitivated_img",
				"color_type",
			])
	}
}
window["MonBookItem"] = MonBookItem