import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { SetAnchoredPosition, Util } from "../util/Util"
import { TSCrackScrambleItem } from "./TSCrackScrambleItem"
import { TSCrackTabItem } from "./TSCrackTabItem"

export class TSCrackScrambleView extends BaseView1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_img_close: Laya.Image
	_Image4: Laya.Image
	_list_tab_con: Laya.HBox
	Content: Laya.List
	Scr_Scroller1
	array_item
	array_tab
	default_index
	item_loop_mgr
	now_index
	tab_item_list
	tab_name_list
	ts_crack_model
	_iid






	public constructor() {
		super()


		this.base_file = "tsCrack"

		this.layout_file = "TSCrackScrambleView"

		this.layer_value = Enum_UILayer.Activity

		this.destroy_imm = true

		this.is_center = true

		this.use_background = true

		this.click_bg_toClose = true

		this.show_open_movie = true

		this.change_scene_close = true

		this.ts_crack_model = TSCrackModel.GetInstance()



		this.tab_name_list = [[1, "世界大妖"], [3, "勾玉"]]

		this.tab_item_list = null



		this.array_tab = null





		this.default_index = 0

		this.preload_server_config = {
			"config_chrono_rift_act": false
		}
		this.preload_client_config = {
			"ConfigTSCrack": false
		}

		this.load_callback = () => {

			this.LoadSuccess()

		}



		this.destroy_callback = () => {

			if (this.tab_item_list) {

				for (let _ in this.tab_item_list) {
					var obj = this.tab_item_list[_]

					obj.DeleteMe()

				}

				this.tab_item_list = false

			}



			if (this.item_loop_mgr) {

				this.item_loop_mgr.DeleteMe()

				this.item_loop_mgr = false

			}

			this.now_index = false

		}

	}



	public LoadSuccess() {








		// this.array_tab = eui. new ArrayCollection()

		// this._list_tab_con.dataProvider = this.array_tab

		// this._list_tab_con.itemRenderer = TSCrackTabItem





		// this.array_item = eui. new ArrayCollection()

		// this._list_item_con.dataProvider = this.array_item

		// this._list_item_con.itemRenderer = TSCrackScrambleItem





		this.InitTab()

		this.SwitchTab(this.default_index)



		this.InitEvent()

		this.ts_crack_model.Fire(TSCrackModel.REQUEST_PROTO, 20404)

	}



	public InitTab() {


		//let chrono_rift_castle_kv_cfg = Config.Chronoriftcastlekv

		if (!this.tab_item_list) {

			this.tab_item_list = []

		}

		// for (let _tmpi in this.tab_name_list) {
		//var vo = this.tab_name_list[_tmpi]

		// 	table.insert(this.tab_item_list, {name=vo[1], red_state=false})

		// }



		for (let index in this.tab_name_list) {


			let name = this.tab_name_list[index][1]

			let item = this.tab_item_list[index]

			if (item == null) {

				item = new TSCrackTabItem(this._list_tab_con)

				this.tab_item_list[index] = item

				item.Load()

			}

			item.SetData({

				id: this._iid,

				name: name,

				index: index

			})

		}



	}



	public InitEvent() {




		Util.AddClickEvent(this._img_close, () => {

			this.Close()

		}, this, true)



		this.BindEvent(this.ts_crack_model, TSCrackModel.CLICK_TAB, (id?, index?) => {

			if (this._iid == id) {

				this.SwitchTab(index)

			}

		})



		this.BindEvent(this.ts_crack_model, TSCrackModel.UPDATE_SCRAMBLE_VALUE, () => {

			this.UpdateView()

		})



	}



	public SwitchTab(index?) {


		if (this.now_index == index) {

			return

		}



		let item = this.tab_item_list[this.now_index]

		if (item) {

			item.SetSelectState(false)

		}



		item = this.tab_item_list[index]

		if (item) {

			item.SetSelectState(true)

		}



		//SetAnchoredPosition(this.Content, 0, 0)



		this.now_index = index

		this.UpdateView()

	}



	public UpdateView() {


		let chrono_rift_act_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_chrono_rift_act", false)

		let ConfigTSCrack = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigTSCrack", true)

		let act_cfg = ConfigTSCrack && ConfigTSCrack["act"]

		let type = this.tab_name_list[this.now_index][0]

		let list = []

		if (chrono_rift_act_cfg) {

			let data = null

			for (let key in chrono_rift_act_cfg) {


				data = chrono_rift_act_cfg[key]

				let cfg = act_cfg[data.mod + "@" + data.sub_mod]

				if ((cfg && data.type == type) && this.ActOpenState(data.mod)) {

					table.insert(list, {

						id: data.id,

						doc: data.doc,

						mod: data.mod,

						sub_mod: data.sub_mod,

						type: data.type,

						count: this.ts_crack_model.GetScrambleValue(data.mod + "@" + data.sub_mod),

						value: data.value,

						max_value: data.max_value,

						open_id: cfg.open_id

					})

				}

			}

		}



		if (this.item_loop_mgr) {

			this.item_loop_mgr.replaceAll(list)

		} else {
			this.item_loop_mgr = new LoopScrowViewMgr()

			this.item_loop_mgr.SetData(this.Content, TSCrackScrambleItem, list, LoopScrCon.Vertical)

		}

		// this.array_item.replaceAll(list)

	}



	public ActOpenState(mod?) {


		return true

	}



	public Open(...new_args) {


		let parms = new_args

		if (parms && parms[0]) {

			this.default_index = parms[0]

		}

		super.Open()

	}




	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._img_close,
			this._Image4,
			this._list_tab_con,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"_img_close",
				"_Image4",
				"_list_tab_con",
				"Content",
			])
	}
}
window["TSCrackScrambleView"] = TSCrackScrambleView