import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { MedalModel } from "../commonModel/MedalModel"
import { PlatformManager } from "../PlatformManager"

export class TitleItem extends BaseItemRenderer {
	model
	title_id
	cur_model
	public WIDTH = 151
	public HEIGT = 182
	public constructor(parent) {
		super()


		this.model = MedalModel.GetInstance();
		this.base_file = "title"
		this.layout_file = "TitleItem"
		this.Load()

		this.load_callback = () => {
			this.cur_model = ""
			this.BindEvent(this.model, MedalModel.SELECT_TITLE, (title_id?) => {
				if (this.title_id == title_id) {
					this.select_img.visible = true
				} else {
					this.select_img.visible = false
				}
			}
			)
		}

	}

	public dataChanged() {


		if (!super.dataChanged()) {
			return
		}

		this.stage_img.visible = false
		this.select_img.visible = false
		this.star_gp.visible = true
		this.title_id = this.data.id
		let config_title_cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"config_title_cfg",false)
		let cfg = config_title_cfg && config_title_cfg[this.title_id + "@" + this.data.level]
		if (cfg && cfg.show_id && cfg.show_id != 0) {
			let scale = 5
			let res =  this.model.GetTitleEffetName(cfg.show_id)
			if(res!=this.cur_model){
				this.base_item.ClearUIEffect(this.title_gp)
				this.cur_model=res
				this.base_item.AddUIEffect(res, this.title_gp, null, scale, true)
			}
			
		}
		if (this.selected) {
			this.model.Fire(MedalModel.CLICK_TITLE_ITEM, this.title_id)
		}
		let star_num = this.data.level
		let i = 1
		do {
			ResManager.GetInstance().SetImageSprite(this, this["star_img_" + i], "title", "com_star_2")
			i = i + 1
		} while ((i <= 5))
		if (star_num > 0) {
			let i = 1
			do {
				ResManager.GetInstance().SetImageSprite(this, this["star_img_" + i], "title", "com_star_1a")
				i = i + 1
			} while ((i <= star_num))
		}
		if (this.data.is_equip == 0) {
			this.star_gp.visible = false
			this.stage_img.visible = true
			ResManager.GetInstance().SetImageSprite(this, this.stage_img, "title", "uidttx_014", true)
		}
		this.SetItemName()
		this.SetRed()
		this.select_img.visible = this.selected
	}


	public SetItemName() {

		let config_title_cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"config_title_cfg",false)
		for (let key in config_title_cfg) {

			let cfg = config_title_cfg[key]
			if (cfg.id == this.title_id) {
				this.name_lb.text = cfg.name
				break
			}
		}
	}

	public SetRed() {

		let red_list = this.model.title_red_list
		if (red_list[this.title_id]) {
			this.red_img.visible = true
		} else {
			this.red_img.visible = false
		}
	}

	public DeleteMe() {
		this.cur_model=""
		this.base_item.ClearUIEffect(this.title_gp)
		super.DeleteMe()
	}



	_Image1: Laya.Image
	star_gp: Laya.HBox
	star_img_1: Laya.Image
	star_img_2: Laya.Image
	star_img_3: Laya.Image
	star_img_4: Laya.Image
	star_img_5: Laya.Image
	select_img: Laya.Image
	_Group1: Laya.Box
	name_lb: Laya.Label
	_title_img: Laya.Image
	red_img: Laya.Image
	title_gp: Laya.Box
	stage_img: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this.star_gp,
			this.star_img_1,
			this.star_img_2,
			this.star_img_3,
			this.star_img_4,
			this.star_img_5,
			this.select_img,
			this._Group1,
			this.name_lb,
			this._title_img,
			this.red_img,
			this.title_gp,
			this.stage_img,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"star_gp",
				"star_img_1",
				"star_img_2",
				"star_img_3",
				"star_img_4",
				"star_img_5",
				"select_img",
				"_Group1",
				"name_lb",
				"_title_img",
				"red_img",
				"title_gp",
				"stage_img",
			])
	}
}
window["TitleItem"] = TitleItem