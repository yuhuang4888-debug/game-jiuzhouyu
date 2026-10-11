import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SceneManager } from "../scene/SceneManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { DungeonExpFightSceneItem } from "./DungeonExpFightSceneItem"
import { DungeonExpUseExpItem } from "./DungeonExpUseExpItem"

export class DungeonExpUseExpView extends BaseView1 {

	public static goods_list = [37020001, 37020002, 37020003, 37020004]
	public static show_get_url_list = [37020001, 37020002, 37020003]

	item_list
	guide_state
	goods_list

	goods_model: GoodsModel
	res_mgr: ResManager

	public constructor() {
		super()
		this.base_file = "dungeonExp"
		this.layout_file = "DungeonExpUseExpView"
		this.layer_value = Enum_UILayer.UI

		this.use_background = true
		this.click_bg_toClose = true
		this.change_scene_close = true
		this.background_alpha = 0
		this.is_center = true
		this.show_open_movie = true
		this.not_show_main_msg = true
		this.destroy_imm = false

		this.item_list = null
		this.guide_state = null
		this.goods_list = null

		this.goods_model = GoodsModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback=()=>{
			this.ReDisplayExpFinger()
		}
		this.destroy_callback = () => {
			this.Remove()
		}
	}
	private ReDisplayExpFinger(){
		// let dun_id = SceneManager.GetInstance().GetCurrDunId()
		// let info = BaseDungeonModel.GetInstance().DunSetInfo(dun_id)
		// if(!info)return
		// let coin_switch =info[4] && info[4].is_open
		// let diamond_switch=info[2] && info[2].is_open
		// if ((!coin_switch || coin_switch == 0) && (!diamond_switch ||diamond_switch == 0) && this.guide_state != DungeonExpFightSceneItem.GUIDE_STATE.DONE) {
		// 	BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, DungeonExpFightSceneItem.GUIDE_STATE.USE_EXP)
		// } 
		// else {
		// 	BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, DungeonExpFightSceneItem.GUIDE_STATE.DONE)
		// }
		BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, DungeonExpFightSceneItem.GUIDE_STATE.DONE)
	}


	InitView() {
		if (!this.item_list) {
			this.item_list = []
		}
		this.goods_list = []
		// this.res_mgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dungeonDragon", "uiboss_049"))

		for (let _tmpi in DungeonExpUseExpView.goods_list) {
			var goods_id = DungeonExpUseExpView.goods_list[_tmpi]
			let bool = true
			if (goods_id == 37020004 && this.goods_model.GetTypeGoodsNum(goods_id) == 0) {
				bool = false
			}
			if (goods_id == 37020003 && this.goods_model.GetTypeGoodsNum(goods_id) == 0) {
				bool = false
			}
			if (bool) {
				table.insert(this.goods_list, { goods_id: goods_id, count: this.goods_model.GetTypeGoodsNum(goods_id) })
			}
		}

		table.sort(this.goods_list, (a?, b?) => {
			return b.goods_id < a.goods_id
		}
		)

		if (this.item_list && this.goods_list.length < this.item_list.length) {
			let i = this.goods_list.length
			do {
				//this.item_list[i].includeInLayout = false
				this.item_list[i].SetVisible(false)
				i = i + 1
			} while ((i < this.item_list.length))
		}
		let GetBuffData = (goods_id?) => {
			let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods_effect", false)
			if (cfgs && cfgs[goods_id]) {
				let tbl = JSON.parse(cfgs[goods_id].effect_list)
				if (tbl[0][0] == "exp_mon") {
					return Number(tbl[0][1])
				}
			}
		}
		let num = 0
		for (let _tmpi in this.goods_model.goods_buff_list) {
			var v = this.goods_model.goods_buff_list[_tmpi]
			if (v.time > 0) {
				for (let _tmpi in DungeonExpUseExpView.goods_list) {
					var goods_id = DungeonExpUseExpView.goods_list[_tmpi]
					if (v.goods_id == goods_id) {
						num = GetBuffData(v.goods_id)
					}
				}
			}
		}
		let have_exp_buff = num > 0
		let add_guide
		if (this.goods_model.GetTypeGoodsNum(37020002) > 0 && !have_exp_buff)
			add_guide = 37020002
		if (this.goods_model.GetTypeGoodsNum(37020001) > 0 && this.goods_model.GetTypeGoodsNum(37020002) == 0 && !have_exp_buff)
			add_guide = 37020001
		for (let key in this.goods_list) {
			let vo = this.goods_list[key]
			let item = this.item_list[key]
			if (!item) {
				item = new DungeonExpUseExpItem(this._panel_item)
				this.item_list[key] = item
				item.Load()
			}

			if (add_guide && add_guide == vo.goods_id && vo.count > 0) {
				add_guide = 1
				item.SetDate(vo.goods_id, this.guide_state)
				this.guide_state = false
			} else {
				item.SetDate(vo.goods_id)
			}
			item.SetPosition(0, Number(key) * 147)
			item.SetVisible(true)
		}
		this.goods_model.Fire(GoodsModel.GET_GOODS_BUFF_LIST)
	}

	LoadSuccess() {
		this._panel_item.vScrollBarSkin = ""

		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

		this.BindEvent(this.goods_model, GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
			if (this.use_delete_method) {
				return
			}
			this.InitView()
		}
		)
	}

	Remove() {
		if (this.item_list) {
			for (let _tmpi in this.item_list) {
				var obj = this.item_list[_tmpi]
				obj.DeleteMe()
			}
		}
		this.item_list = null
	}

	public Open(...new_args) {
		let parms = new_args
		if (parms) {
			this.guide_state = parms[0]
		}
		super.Open()
	}
	_img_bg: Laya.Image
	_img_bg3: Laya.Image
	_lb_title: Laya.Label
	_img_bg2: Laya.Image
	_img_close: Laya.Image
	_panel_item: Laya.Panel
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg3,
			this._lb_title,
			this._img_bg2,
			this._img_close,
			this._panel_item,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg3",
				"_lb_title",
				"_img_bg2",
				"_img_close",
				"_panel_item",
			])
	}
}
window["DungeonExpUseExpView"] = DungeonExpUseExpView