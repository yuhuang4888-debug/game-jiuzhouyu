import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { TopVipSkillDetailItem } from "./TopVipSkillDetailItem"

export class TopVipSkillDetailView extends BaseView1 {
	_Image1: Laya.Image
	_Group1: Laya.Box
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.VBox
	close_img: Laya.Image
	InitEvent
	InitView
	LoadSuccess
	Scr_Scroller1
	click_bg_toClose
	close_callback
	destroy_imm
	is_center
	not_show_item_use
	open_callback
	show_open_movie
	skill_item_gp
	use_background

	public constructor() {
		super()


		this.base_file = "topVip"
		this.layout_file = "TopVipSkillDetailView"
		this.is_center = true
		this.use_background = true
		this.destroy_imm = true
		this.not_show_item_use = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.layer_value = Enum_UILayer.Activity
		let item_list_ = null
		this.preload_server_config={
			"config_supreme_vip_skill":false
		}
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {

		}

		this.close_callback = () => {
			if (item_list_ && item_list_.length > 0) {
				for (let _tmpi in item_list_) {
					var obj = item_list_[_tmpi]
					obj.DeleteMe()
				}
				item_list_ = []
			}
		}

		this.LoadSuccess = () => {
			this.InitView()
		}

		this.InitView = () => {
			if (!item_list_) {
				item_list_ = []
			}
			let config_supreme_vip_skill = ResManager.GetInstance().GetGameConfigFromCache(this, "config_supreme_vip_skill", false)
			let skill_num = 0
			let skill_index = 0
			//for (let key in config_supreme_vip_skill) {

			//// [ts2lua]config_supreme_vip_skill下标访问可能不正确
			//let cfg = config_supreme_vip_skill[key]
			//let key_arr = Split(key,"@",1)
			//let key_index = Number(key_arr[0])
			//if (key_index != skill_index ) {
			//skill_index = key_index
			//skill_num=skill_num+1
			//}
			//}

			while (config_supreme_vip_skill[String(skill_index) + "@8"]) {
				skill_num = skill_num + 1
				skill_index = skill_index + 1
			}
			let num = skill_num
			let i = 0
			do {
				let item = item_list_[i]
				if (!item) {
					item = new TopVipSkillDetailItem(this.Content)
					item.Load()
					table.insert(item_list_, item)
				}
				item.Setdata(i)
				i = i + 1
			} while ((i < skill_num))
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.close_img, () => {
				this.Close()
			}
				, this, true)
		}


	}



	public GetComponents() {
		[
			this._Image1,
			this._Group1,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Scroller1,
			this.Content,
			this.close_img,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Group1",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Scroller1",
				"Content",
				"close_img",
			])
		this._Scroller1.vScrollBar.visible=false
	}
}
window["TopVipSkillDetailView"]=TopVipSkillDetailView