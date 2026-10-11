import { BaseView1 } from "../common/BaseView1"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { Enum_UILayer } from "../common/LayerManager"
import { Util, HtmlColorTxt } from "../util/Util"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { KfHolyAreaCampItem } from "./KfHolyAreaCampItem"
export class KfHolyAreaCampView extends BaseView1 {
	_Image1: Laya.Image
	_img_close: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	Content: Laya.List
	Scr_Scroller1
	_Scroller1
	change_scene_close
	click_bg_toClose
	destroy_callback
	destroy_imm
	item_list
	model
	record_loop_mgr
	show_open_movie
	use_background





	public constructor() {
		super()


		this.base_file = "kfHolyArea"

		this.layout_file = "KfHolyAreaCampView"

		this.layer_value = Enum_UILayer.UI

		this.show_open_movie = true

		this.destroy_imm = true

		this.change_scene_close = true

		this.use_background = true

		this.click_bg_toClose = true



		this.model = KfHolyAreaModel.GetInstance()

		this.load_callback = () => {

			this.LoadSuccess()

		}



		this.destroy_callback = () => {

			//this.Remove()

		}



	}



	public LoadSuccess() {






		this.UpdateView()

		this.InitEvent()

	}



	public InitEvent() {


		Util.AddClickEvent(this._img_close, () => {

			this.Close()

		}

			, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

	}



	public UpdateView() {


		let map_data = this.model.map_data

		let dic = []

		let list = []

		if (map_data) {

			for (let _tmpi in map_data.server_ids) {
				var vo = map_data.server_ids[_tmpi]

				if (!dic[vo.camp]) {

					dic[vo.camp] = []

				}

				table.insert(dic[vo.camp], vo)

			}

			for (let camp in dic) {


				table.insert(list, { camp: camp, list: dic[camp] })

			}

			this.item_list = list

			if (this.record_loop_mgr) {

				this.record_loop_mgr.replaceAll(this.item_list)

			} else {
				this.record_loop_mgr = new LoopScrowViewMgr()

				this.record_loop_mgr.SetData(this.Content, KfHolyAreaCampItem, this.item_list, this._Scroller1, 1)

			}

		}

	}




	public GetComponents() {
		[
			this._Image1,
			this._img_close,
			this._Image2,
			this._Image3,
			this._Image4,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_close",
				"_Image2",
				"_Image3",
				"_Image4",
				"Content",
			])
	}
}
window["KfHolyAreaCampView"] = KfHolyAreaCampView