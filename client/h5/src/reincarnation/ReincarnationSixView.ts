import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ReincarnationModel } from "../commonModel/ReincarnationModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util, SetSizeDeltaX, GetLocalPositionX, SetAnchoredPositionX } from "../util/Util"
import { ReincarnationPoint } from "./ReincarnationPoint"
import { ReincarnationSixItem } from "./ReincarnationSixItem"

export class ReincarnationSixView extends BaseItem1 {
	InitEvent
	InitView
	LoadSuccess
	LocalDeleteMe
	SelectIndex
	SetButton
	tween_id

	public constructor(parent?) {
		super(parent)


		this.base_file = "reincarnation"
		this.layout_file = "RebirthBottomView"
		let local_util = Util
		let local_reinModel = ReincarnationModel.GetInstance()
		let local_rolemainVo = RoleManager.GetInstance().GetMainRoleVo()
		let local_gmodel = GoodsModel.GetInstance()
		let cur_index_ = null
		let max_index_ = 0
		let point_cfg_ = null
		let awaken_cfg_ = null
		let page_ = null
		let page_count_ = null
		let turn_lv_ = null
		let default_index_ = null
		let item_list_ = null
		let point_list_ = null
		let group_w_ = 700
		let show_turn_ = 6
		let cur_awaken_index_ = null
		let goods_type_id_ = null
		let exp_change_bind_ = null
		let goods_number_bind_ = null
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.InitEvent = () => {
			let OnLeftBtnClick = () => {
				this.SelectIndex(cur_index_ - 1)
			}

			Util.AddClickEvent(this.left_btn, OnLeftBtnClick, this, true)
			let OnRightBtnClick = () => {
				this.SelectIndex(cur_index_ + 1)
			}

			Util.AddClickEvent(this.right_btn, OnRightBtnClick, this, true)
			let ExpChange = () => {
				if (cur_awaken_index_ && item_list_) {
					let red_dot = local_reinModel.CellCanAwake(cur_awaken_index_)
					item_list_[cur_awaken_index_].SetRedDot(red_dot)
				}
			}

			exp_change_bind_ = local_rolemainVo.BindOne("exp", ExpChange)
			let OngoodsChange = (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				if (cur_awaken_index_ && item_list_) {
					for (let _tmpi in goods_list) {
						var vo = goods_list[_tmpi]
						if (vo.type_id == goods_type_id_) {
							let red_dot = local_reinModel.CellCanAwake(cur_awaken_index_)
							item_list_[cur_awaken_index_].SetRedDot(red_dot)
						}
					}
				}
			}

			goods_number_bind_ = local_gmodel.Bind(GoodsModel.UPDATE_GOODS_NUM, OngoodsChange)
		}

		this.LoadSuccess = () => {
			this.line_img.visible = false
			// this.item_group.hScrollBar.visible = false
			let rein_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientReincarnationPos", true)
			// let rein_cfg = Config.ClientReincarnationPos //local_reinmodel.client_cfg
			awaken_cfg_ = local_reinModel.GetReinAwakenPointList(show_turn_)
			// [ts2lua]rein_cfg下标访问可能不正确
			point_cfg_ = rein_cfg[show_turn_]
			page_ = point_cfg_.page
			page_count_ = point_cfg_.count
			this.InitView()
			// [ts2lua]local_reinModel.turn_level_list下标访问可能不正确
			turn_lv_ = local_reinModel.turn_level_list[show_turn_]
			if (!goods_type_id_ && cur_awaken_index_) {
				let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_awakening_cell_cfg", false)
				// let cfg = Config.Awakeningcellcfg
				if (cfg) {
					// [ts2lua]cfg下标访问可能不正确
					let cost_attr = JSON.parse(cfg[cur_awaken_index_].priority_consume)
					goods_type_id_ = cost_attr[0][1]
				}
			}
		}

		this.InitView = () => {
			if (!point_cfg_) {
				return
			}
			default_index_ = 0
			max_index_ = 0
			cur_awaken_index_ = null
			SetSizeDeltaX(this.content_box, page_ * group_w_)
			let pos_cfg = point_cfg_.pos
			//let list = local_reinmodel.GetTurnTaskList(show_turn_)
			//list = list[1]
			if (pos_cfg) {
				let point_data_list = awaken_cfg_[1]
				let count = 0
				if (!item_list_) {
					item_list_ = []
				}
				for (let point_index in point_data_list) {
					let item = item_list_[point_data_list[point_index].id]
					count = count + 1
					if (count > point_cfg_.count) {
						count = 1
						max_index_ = max_index_ + 1
					}
					if (!item) {
						item = new ReincarnationSixItem(this.content_box)
						item.SetIndex(max_index_)
						item.Load()
						item_list_[point_data_list[point_index].id] = item
					}
					let pos = pos_cfg[count]
					if (pos) {
						item.SetPosition(pos_cfg[count].x + max_index_ * group_w_, pos_cfg[count].y)
					}
					item.SetData(point_data_list[point_index], 6)
					let state = local_reinModel.GetPointIdState(show_turn_, 1, point_data_list[point_index].id)
					if (state == 1) {
						default_index_ = max_index_
						cur_awaken_index_ = point_data_list[point_index].id
					}
					item.SetState(state)
				}
			}
			if (!cur_awaken_index_) {
				if (exp_change_bind_) {
					local_rolemainVo.UnBind(exp_change_bind_)
					exp_change_bind_ = null
				}
				if (goods_number_bind_) {
					local_gmodel.UnBind(goods_number_bind_)
					goods_number_bind_ = null
				}
				default_index_ = max_index_
			}
			this.point_group.visible = true
			if (!point_list_) {
				point_list_ = []
			}
			let i = 0
			if (i <= max_index_) {
				do {
					let point = point_list_[i]
					if (!point) {
						point = new ReincarnationPoint(this.point_group)
						point.Load()
						point_list_[i] = point
					}
					let index = i
					let SelectPoint = () => {
						this.SelectIndex(index)
					}

					point.SetClick(SelectPoint)
					i = i + 1
				} while ((i <= max_index_))
			}
			if (local_reinModel.IsFinishRein()) {
				this.SelectIndex(max_index_, true)
			} else {
				this.SelectIndex(default_index_, true)
			}
			this.SetButton()
		}

		this.SelectIndex = (index?, force?) => {
			if (((cur_index_ == index || index < 0) || index > max_index_) || !point_cfg_) {
				return
			}
			if (cur_awaken_index_ && (((index == 1 && cur_awaken_index_ <= 30) || (index == 2 && cur_awaken_index_ <= 35)) || (index == 3 && cur_awaken_index_ <= 40))) {
				Message.show("请先提交当前页转职材料")
				return
			}
			// [ts2lua]point_list_下标访问可能不正确
			let old_point = point_list_[cur_index_]
			if (old_point) {
				old_point.SetSelect(false)
			}
			cur_index_ = index
			if (this["setNameFunc"]) {
				// [ts2lua]point_cfg_.name下标访问可能不正确
				this["setNameFunc"](point_cfg_.name[index])
			}
			if (point_list_[index]) {
				point_list_[index].SetSelect(true)
			}
			this.SetButton()
			let move_x = -group_w_ * index
			if (GetLocalPositionX(this.content_box) == move_x) {
				return
			}
			if (force) {
				//local_laya.Tween.removeTweens(this.item_group)
				if (this.tween_id) {
					SYTweenLite.Stop(this.tween_id)
					this.tween_id = null
				}
				SetAnchoredPositionX(this.content_box, move_x)
				//this.item_group.x = move_x
			} else {
				if (this.tween_id) {
					SYTweenLite.Stop(this.tween_id)
					this.tween_id = null
				}
				this.tween_id = SYTweenLite.to(this, this.content_box, SYTweenLite.UiAnimationType.ANCHORED_POSX, move_x, 0.5)
				//local_laya.Tween.get(this.item_group).to({x=move_x}, 500, local_laya.Ease.circInOut)
			}
		}

		this.SetButton = () => {
			if (cur_index_ == 0) {
				this.left_btn.visible = false
			} else {
				this.left_btn.visible = true
			}
			if (cur_index_ == max_index_) {
				this.right_btn.visible = false
			} else {
				this.right_btn.visible = true
			}
		}

		this.LocalDeleteMe = () => {
			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
				this.tween_id = null
			}
			if (exp_change_bind_) {
				local_rolemainVo.UnBind(exp_change_bind_)
				exp_change_bind_ = null
			}
			if (goods_number_bind_) {
				local_gmodel.UnBind(goods_number_bind_)
				goods_number_bind_ = null
			}
			for (let index in item_list_) {

				// [ts2lua]item_list_下标访问可能不正确
				let item = item_list_[index]
				if (item) {
					item.DeleteMe()
					// [ts2lua]item_list_下标访问可能不正确
					item_list_[index] = null
				}
			}
			item_list_ = null
			for (let index in point_list_) {

				// [ts2lua]point_list_下标访问可能不正确
				let point = point_list_[index]
				if (point) {
					point.DeleteMe()
					// [ts2lua]point_list_下标访问可能不正确
					point_list_[index] = null
				}
			}
			point_list_ = null
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
window["ReincarnationSixView"] = ReincarnationSixView
