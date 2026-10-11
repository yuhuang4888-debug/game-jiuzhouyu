import { BaseItem1 } from "../common/BaseItem1"
import { CloseMode } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetLocalPosition, SetLocalPositionX, Util } from "../util/Util"
import { DungeonPartnerItem } from "./DungeonPartnerItem"
import { Config } from "../common/Config"

import "./DungeonPartnerSweepView"
import "./DungeonPartnerStarView"
import "./DungeonPartnerStageRewardView"
import "./DungeonPartnerVsView"
import "./DungeonPartnerFirstKillView"
import { ErlangParser } from "../util/ErlangParser"

export class DungeonPartnerView extends BaseItem1 {

	total_score
	cfg_chapter
	total_page
	res_mgr: ResManager
	model: DungeonPartnerModel
	goods_model: GoodsModel

	item_list = []
	sweep_item_list: Array<EquipmentItem> = []
	tween_list = []

	item_pos
	public constructor(parent) {
		super(parent)

		this.base_file = "dungeonPartner"
		this.layout_file = "DungeonPartnerView"
		this.layer_value = Enum_UILayer.UI


		this.model = DungeonPartnerModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.goods_model = GoodsModel.GetInstance()

		this.item_pos = [
			{ x: 38, y: 272 },
			{ x: 212, y: 368 },
			{ x: 369, y: 528 },
			{ x: 214, y: 571 },
			{ x: 25, y: 573 },
			{ x: 216, y: 740 },
			{ x: 436, y: 693 },
			{ x: 602, y: 546 },
			{ x: 431, y: 311 },
		]

		this.load_callback = () => {

			// for (let i = 1; i <= 9; i++){
			// 	this["transpos_" + i] = this.GetChild("group_pos/pos_" + i)
			// }
			// for (let i = 1; i <= 3; i++){
			// 	this["transreward" + i] = this.GetChild("img_xingji/reward" + i)
			// 	this["objimg_red" + i] = this.GetChild("img_xingji/reward" + i .. "/img_red" + i).gameObject
			// }

			this.LoadSuccess()
		}
	}

	public DeleteMe() {
		for (let i = 0; i < this.tween_list.length; i++) {
			let v = this.tween_list[i]
			SYTweenLite.Stop(v)
		}
		this.tween_list = []

		for (let i = 0; i < this.item_list.length; i++) {
			let v = this.item_list[i]
			if(v){
				v.DeleteMe()
			}
		}
		this.item_list.length = 0
		if (this.sweep_item_list && this.sweep_item_list.length > 0) {
			for (let i = 0; i < this.sweep_item_list.length; i++) {
				this.sweep_item_list[i].DeleteMe()
			}
			this.sweep_item_list=[]
		}
		this.cfg_chapter = null
		this.total_page = null
		super.DeleteMe()
	}

	public LoadSuccess() {

		this.cfg_chapter = Config.PRELOAD_SERVER_CONFIG.config_partner_dun_chapter

		this.total_page = Util.TableSize(this.cfg_chapter)
		this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61105, this.model.GetPage())

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_line, GameResPath.GetIcon("dungeonPartner", "ui_copy_42"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_line2, GameResPath.GetIcon("dungeonPartner", "ui_copy_42"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_line3, GameResPath.GetIcon("dungeonPartner", "ui_copy_42"))
		this.InitEvent()

		// this.sv_sweep_reward.hScrollBarSkin = ""

	}

	public InitEvent() {

		let onClickBtnHandler = (e: Laya.Event) => {
			if (e.target == this._box_left) {
				if (this.model.GetPage() > 1) {
					this.model.SetPage(this.model.GetPage() - 1)
					this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61105, this.model.GetPage())
				}
			} else if (e.target == this._box_right) {
				if (this.model.GetPage() < this.total_page) {
					this.model.SetPage(this.model.GetPage() + 1)
					this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61105, this.model.GetPage())
				}
			} else if (e.target == this._img_star) {
				let pos = Laya.Point.create()
				this._img_star.localToGlobal(pos)
				pos.x += this._img_star.width
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonPartnerStarView", this.model.GetPage(), this.total_score, pos)
			} else if (e.target == this._box_sweep) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonPartnerSweepView")
			}
		}
		Util.AddClickEvent(this._box_left, onClickBtnHandler, this, true)
		Util.AddClickEvent(this._box_right, onClickBtnHandler, this, true)
		Util.AddClickEvent(this._img_star, onClickBtnHandler, this, true)
		Util.AddClickEvent(this._box_sweep, onClickBtnHandler, this, true)

		this.BindEvent(this.model, DungeonPartnerModel.UPDATE_PARTNER_VIEW, (scmd61105?) => {
			if (this.model.GetPage() == scmd61105.level) {
				this.UpdateView(scmd61105)
			}
		})

		this.BindEvent(this.model, DungeonPartnerModel.UPDATE_PARTNER_RED_POINT, () => {
			this.RefreshRedPoint()
		})

		this.BindEvent(this.model, DungeonPartnerModel.UPDATE_PARTNER_VIEW_STAGE_REWARD, (scmd61106?) => {
			this.RefreshRedPoint()
		})

		

		this._img_move.on(Laya.Event.MOUSE_DOWN, this, this.MouseDown)
		this._img_move.on(Laya.Event.MOUSE_MOVE, this, this.MouseMove)
		this._img_move.on(Laya.Event.MOUSE_UP, this, this.MouseUp)
		this._img_move.on(Laya.Event.MOUSE_OUT, this, this.MouseUp)
	}

	click_down_x
	is_down
	public MouseDown(e: Event) {
		this.click_down_x = Laya.stage.mouseX
		this.is_down = true
	}

	public MouseMove(e: Event) {
		if (!this.is_down) return
		let detal_x = Laya.stage.mouseX - this.click_down_x
		let page = this.model.GetPage()
		if ((1 == page && detal_x > 0) || (this.total_page == page && detal_x < 0)) {
			return
		}
		SetLocalPositionX(this._box_center_item, detal_x)
		SetLocalPositionX(this._box_left_item, detal_x - 720)
		SetLocalPositionX(this._box_right_item, detal_x + 720)
	}

	public MouseUp(e: Event) {
		if (!this.is_down) return
		this.is_down = false
		let detal_x = Laya.stage.mouseX - this.click_down_x
		let page = this.model.GetPage()
		if ((1 == page && detal_x > 0) || (this.total_page == page && detal_x < 0)) {
			return
		}
		// console.log("========", detal_x)
		let time = 0.2
		if (detal_x >= 360) { //上一页
			table.insert(this.tween_list, SYTweenLite.to(this, this._box_center_item, SYTweenLite.UiAnimationType.POSX, 720, time))
			table.insert(this.tween_list, SYTweenLite.to(this, this._box_left_item, SYTweenLite.UiAnimationType.POSX, 0, time))
			table.insert(this.tween_list, SYTweenLite.to(this, this._box_right_item, SYTweenLite.UiAnimationType.POSX, 720 + 720, time, () => {
				this.model.SetPage(page - 1)
				this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61105, page - 1)
			}))
		} else if (detal_x <= -360) { //下一页
			table.insert(this.tween_list, SYTweenLite.to(this, this._box_center_item, SYTweenLite.UiAnimationType.POSX, -720, time))
			table.insert(this.tween_list, SYTweenLite.to(this, this._box_left_item, SYTweenLite.UiAnimationType.POSX, -720 - 720, time))
			table.insert(this.tween_list, SYTweenLite.to(this, this._box_right_item, SYTweenLite.UiAnimationType.POSX, 0, time, () => {
				this.model.SetPage(page + 1)
				this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61105, page + 1)
			}))
		} else {
			table.insert(this.tween_list, SYTweenLite.to(this, this._box_center_item, SYTweenLite.UiAnimationType.POSX, 0, time))
			table.insert(this.tween_list, SYTweenLite.to(this, this._box_left_item, SYTweenLite.UiAnimationType.POSX, -720, time))
			table.insert(this.tween_list, SYTweenLite.to(this, this._box_right_item, SYTweenLite.UiAnimationType.POSX, 720, time))
		}
	}


	public UpdateView(data?) {

		if (!this.is_loaded) {
			return
		}
		this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61106, this.model.GetPage())
		this._box_left.visible = this.model.GetPage() != 1
		this._box_right.visible = this.model.GetPage() != this.total_page
		this._lb_desc.text = this.cfg_chapter[data.level].doc.trim()
		this.total_score = 0
		let vs_state_index, item, v, pos
		for (let i = 0; i < data.dun_list.length; i++) {
			v = data.dun_list[i]
			//找出第一个分数为0的，设置为挑战状态
			if (!vs_state_index && 0 == v.score) {
				vs_state_index = i
			}

			item = this.item_list[i]
			if (!item) {
				item = new DungeonPartnerItem(this._box_center_item)
				item.Load()
				this.item_list[i] = item
			}
			item.SetData(i + 1, v, vs_state_index)
			pos = this.item_pos[i]
			item.SetPosition(pos.x, pos.y)
			this.total_score = this.total_score + v.score
		}

		// this.img_progress.fillAmount = this.total_score / 27

		//扫荡最高奖励
		let sweep_reward = ErlangParser.GetInstance().Parse(this.cfg_chapter[data.level].sweep_reward)
		for (let i = 0; i < sweep_reward.length; i++) {
			v = sweep_reward[i]
			item = this.sweep_item_list[i]
			if (!item) {
				item = new EquipmentItem(this._panel_sweep_reward)
				item.Load()
				this.sweep_item_list[i] = item
				item.SetItemSize(85, 85)
			}
			let [type_id, lock] = this.goods_model.GetMappingTypeId(v[0], v[1])
			let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
			if (goods_vo) {
				item.SetData(goods_vo.type_id, v[2], lock)
			}
			item.SetPosition(99 * i, 0)
			item.SetVisible(true)
		}
		
		for (let i = 0; i < this.tween_list.length; i++) {
			SYTweenLite.Stop(this.tween_list[i])
		}
		this.tween_list.length = 0

		SetLocalPosition(this._box_center_item, 0, 0)
		SetLocalPosition(this._box_left_item, -720, 0)
		SetLocalPosition(this._box_right_item, 720, 0)
		this.CreateLeftPageItems()
		this.CreateRightPageItems()
	}

	public CreateLeftPageItems() {
		let page = this.model.GetPage() - 1
		let data = this.model.GetViewInfo(page)
		if (data) {
			let item, v, item_index, pos
			for (let i = 0; i < data.dun_list.length; i++) {
				v = data.dun_list[i]
				item_index = i + 9
				item = this.item_list[item_index]
				if (!item) {
					item = new DungeonPartnerItem(this._box_left_item)
					item.Load()
					this.item_list[item_index] = item
				}
				item.SetData(i + 1, v, null, page)
				pos = this.item_pos[i]
				item.SetPosition(pos.x, pos.y)
			}
		}
	}

	public CreateRightPageItems() {

		let page = this.model.GetPage() + 1
		let data = this.model.GetViewInfo(page)
		if (data) {
			let item, v, item_index, pos
			for (let i = 0; i < data.dun_list.length; i++) {
				v = data.dun_list[i]
				item_index = i + 18
				item = this.item_list[item_index]
				if (!item) {
					item = new DungeonPartnerItem(this._box_right_item)
					item.Load()
					this.item_list[item_index] = item
				}
				item.SetData(i + 1, v, null, page)
				pos = this.item_pos[i]
				item.SetPosition(pos.x, pos.y)
			}
		}
	}

	public RefreshRedPoint() {

		this._img_sweep_red.visible = this.model.HasRedPointFlag(DungeonPartnerModel.RED_POINT_TYPE.SWEEP)
		this._img_star_red.visible = this.model.IsStageRewardRedPoint(this.model.GetPage())


		let find = false
		for (let i = 1; i < this.model.GetPage(); i++) {
			if (this.model.IsStageRewardRedPoint(i) || this.model.CheckPageChallengeRedPoint(i) || this.model.CheckPageFirstBloodRedPoint(i)) {
				find = true
				break
			}
		}
		this._img_left_red.visible = find

		find = false
		for (let i = this.model.GetPage() + 1; i <= this.total_page; i++) {
			if (this.model.IsStageRewardRedPoint(i) || this.model.CheckPageChallengeRedPoint(i) || this.model.CheckPageFirstBloodRedPoint(i)) {
				find = true
				break
			}
		}
		this._img_right_red.visible = find
	}

	_img_bg: Laya.Image
	_lb_desc: Laya.Label
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_lb_desc2: Laya.Label
	_panel_item: Laya.Panel
	_box_center_item: Laya.Box
	_img_move: Laya.Box
	_img_line: Laya.Image
	_box_left_item: Laya.Box
	_img_line2: Laya.Image
	_box_right_item: Laya.Box
	_img_line3: Laya.Image
	_img_star: Laya.Image
	_img_star_red: Laya.Image
	_box_sweep: Laya.Image
	_lb_sweep: Laya.Label
	_img_sweep_red: Laya.Image
	_box_left: Laya.Image
	_img_left_red: Laya.Image
	_box_right: Laya.Image
	_img_right_red: Laya.Image
	_panel_sweep_reward: Laya.Panel
	public GetComponents() {
		[
			this._img_bg,
			this._lb_desc,
			this._img_bg2,
			this._img_bg3,
			this._lb_desc2,
			this._panel_item,
			this._box_center_item,
			this._img_move,
			this._img_line,
			this._box_left_item,
			this._img_line2,
			this._box_right_item,
			this._img_line3,
			this._img_star,
			this._img_star_red,
			this._box_sweep,
			this._lb_sweep,
			this._img_sweep_red,
			this._box_left,
			this._img_left_red,
			this._box_right,
			this._img_right_red,
			this._panel_sweep_reward,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_desc",
				"_img_bg2",
				"_img_bg3",
				"_lb_desc2",
				"_panel_item",
				"_box_center_item",
				"_img_move",
				"_img_line",
				"_box_left_item",
				"_img_line2",
				"_box_right_item",
				"_img_line3",
				"_img_star",
				"_img_star_red",
				"_box_sweep",
				"_lb_sweep",
				"_img_sweep_red",
				"_box_left",
				"_img_left_red",
				"_box_right",
				"_img_right_red",
				"_panel_sweep_reward",
			])
	}
}
window["DungeonPartnerView"] = DungeonPartnerView