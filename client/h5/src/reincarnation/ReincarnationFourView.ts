import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ReincarnationModel } from "../commonModel/ReincarnationModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPosition } from "../util/Util"
import { ReincarnationFourItem } from "./ReincarnationFourItem"

export class ReincarnationFourView extends BaseItem1 {
	InitEvent
	InitView
	LoadSuccess
	LocalDeleteMe
	public constructor(parent?, turn?) {
		super(parent)

		this.base_file = "reincarnation"
		this.layout_file = "RebirthBottomView"
		let local_reinmodel = ReincarnationModel.GetInstance()
		let local_resMgr = RoleManager.GetInstance().GetMainRoleVo()
		let local_goodsmodel = GoodsModel.GetInstance()
		let point_cfg_ = null
		let item_list_ = null
		let awaken_cfg_ = null
		let cur_index_ = null
		let goods_type_id_ = null
		let exp_change_bind_ = null
		let goods_number_bind_ = null
		let show_turn_ = 4
		if (turn) {
			show_turn_ = turn
		}

		this.preload_server_config = {
			"config_awakening_cell_cfg": false
		}
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.LoadSuccess = () => {
			// this.item_group.hScrollBar.visible = false
			this.point_group.visible = true
			// this.line_img = new Laya.Image()
			// this.item_group.addChild(this.line_img)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.line_img, GameResPath.GetIcon("reincarnation", "uizs_012"), true)
			SetAnchoredPosition(this.line_img, 40, 70)
			let rein_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientReincarnationPos", true)
			awaken_cfg_ = local_reinmodel.GetReinAwakenPointList(show_turn_)
			point_cfg_ = rein_cfg[show_turn_]
			if (rein_cfg && awaken_cfg_) {
				this.InitView()
			}
		}

		this.InitEvent = () => {
			if (cur_index_ && !goods_type_id_) {
				let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_awakening_cell_cfg", false)
				if (cfg) {
					let cost_attr = JSON.parse(cfg[cur_index_].priority_consume)
					goods_type_id_ = cost_attr[0][1]
				}
			}
			let ExpChange = () => {
				if (cur_index_ && item_list_) {
					let red_dot = local_reinmodel.CellCanAwake(cur_index_)
					item_list_[cur_index_].SetRedDot(red_dot)
				}
			}

			exp_change_bind_ = local_resMgr.BindOne("exp", ExpChange)

			let OngoodsChange = (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				if (cur_index_ && item_list_) {
					for (let _tmpi in goods_list) {
						var vo = goods_list[_tmpi]
						if (vo.type_id == goods_type_id_) {
							let red_dot = local_reinmodel.CellCanAwake(cur_index_)
							item_list_[cur_index_].SetRedDot(red_dot)
						}
					}
				}
			}

			goods_number_bind_ = local_goodsmodel.Bind(GoodsModel.UPDATE_GOODS_NUM, OngoodsChange)
		}

		this.InitView = () => {
			if (!this.is_loaded) {
				return
			}
			this.left_btn.visible = false
			this.right_btn.visible = false
			this.point_group.visible = false
			cur_index_ = null
			if (point_cfg_) {
				if (this["setNameFunc"] ) {
					this["setNameFunc"]("天命纪元")
				}
				let pos_cfg = point_cfg_.pos
				let list = local_reinmodel.GetTurnTaskList(show_turn_)
				list = list[1]
				if (pos_cfg) {
					let point_data_list = awaken_cfg_[1]
					let count = 1
					if (!item_list_) {
						item_list_ = []
					}
					for (let point_index in point_data_list) {
						let item = item_list_[point_data_list[point_index].id]
						if (!item) {
							item = new ReincarnationFourItem(this.content_box)
							item.Load()
							item_list_[point_data_list[point_index].id] = item
						}

						let pos = pos_cfg[count]
						if (pos) {
							item.SetPosition(pos_cfg[count].x, pos_cfg[count].y)
							// SetAnchoredPosition(item, pos_cfg[count].x, pos_cfg[count].y)
						}
						if (count > point_cfg_.count) {
							count = 1
						} else {
							count = count + 1
						}
						item.SetData(point_data_list[point_index], 4)
						let state = local_reinmodel.GetPointIdState(show_turn_, 1, point_data_list[point_index].id)
						if (state == 1) {
							cur_index_ = point_data_list[point_index].id
						}
						item.SetState(state)
					}
				}
			}
			if (!cur_index_) {
				if (exp_change_bind_) {
					local_resMgr.UnBind(exp_change_bind_)
					exp_change_bind_ = null
				}
				if (goods_number_bind_) {
					local_goodsmodel.UnBind(goods_number_bind_)
					goods_number_bind_ = null
				}
			}
		}

		this.LocalDeleteMe = () => {
			if (exp_change_bind_) {
				local_resMgr.UnBind(exp_change_bind_)
				exp_change_bind_ = null
			}
			if (goods_number_bind_) {
				local_goodsmodel.UnBind(goods_number_bind_)
				goods_number_bind_ = null
			}
			for (let index in item_list_) {
				let item = item_list_[index]
				if (item) {
					item.DeleteMe()
					item_list_[index] = null
				}
			}
			item_list_ = null
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}



	item_group: Laya.Panel
	left_btn: Laya.Box
	btn_img: Laya.Image
	right_btn: Laya.Box
	btn_img1: Laya.Image
	line_img: Laya.Image
	point_group: Laya.HBox
	content_box: Laya.Box
	public GetComponents() {
		[
			this.item_group,
			this.left_btn,
			this.btn_img,
			this.right_btn,
			this.btn_img1,
			this.line_img,
			this.point_group,
			this.content_box,
		]
			= this.GetChildrenByNames([

				"item_group",
				"left_btn",
				"btn_img",
				"right_btn",
				"btn_img1",
				"line_img",
				"point_group",
				"content_box"
			])
	}
}
window["ReincarnationFourView"] = ReincarnationFourView