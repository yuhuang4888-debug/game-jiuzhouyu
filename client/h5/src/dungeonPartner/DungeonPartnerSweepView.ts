import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { VipModel } from "../commonModel/VipModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { DungeonPartnerSweepItem } from "./DungeonPartnerSweepItem"

export class DungeonPartnerSweepView extends BaseView1 {

	model: DungeonPartnerModel
	data
	loop_mgr: LoopScrowViewMgr
	need_refresh_data
	res_mgr: ResManager
	public constructor() {
		super()

		this.base_file = "dungeonPartner"
		this.layout_file = "DungeonPartnerSweepView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.model = DungeonPartnerModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.preload_server_config = {
			"config_dungeon_special_cfg": false,
			"config_partner_dun_chapter": false
		}

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Clear()
		}
	}

	public LoadSuccess() {
		this._html_left.style.color = "#663915"
		this._html_left.style.fontSize = 22
		this._html_left.style.wordWrap = false

		this._html_cost.style.color = "#663915"
		this._html_cost.style.fontSize = 22
		this._html_cost.style.wordWrap = false

		this.InitEvent()
		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = null
		}
	}

	public InitEvent() {

		this.BindEvent(this.model, DungeonPartnerModel.UPDATE_PARTNER_VIEW, (scmd61105?) => {
			this.UpdateView()
		})

		Util.AddClickEvent(this._img_close,()=>{
			this.Close()
		},this, true)
	}

	public Open(data?) {

		this.data = data
		this.UpdateView()
		super.Open()
	}

	public UpdateView() {

		if (!this.is_loaded) {
			this.need_refresh_data = true
			return
		}

		let cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_partner_dun_chapter", false)

		let list = []

		let data
		for(let i in cfgs){
			data = cfgs[i]
			list.push(data)
		}
		if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this._list_item, DungeonPartnerSweepItem, list, LoopScrCon.Vertical)
		} else {
			this.loop_mgr.replaceAll(list)
		}

		let total_time = VipModel.GetInstance().GetVipPrivilegeValue(BaseDungeonModel.MODULE_ID, 2000037, 99, RoleManager.GetInstance().GetMainRoleVo().vip_flag)
		let cur_sweep_time = this.model.sweep_count //扫荡次数与章节无关

		this._html_left.innerHTML = `今日剩余扫荡次数：<font color='#0a953e'> ${Math.max(total_time - cur_sweep_time, 0)}/${total_time}</font>`

		let config_dungeon_special_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_dungeon_special_cfg", false)
		let dun_partner_sweep_cost = JSON.parse(config_dungeon_special_cfg["37@dun_partner_sweep_cost"].value)
		let cost = dun_partner_sweep_cost[cur_sweep_time][1]
		if (cost.length > 0) {
			this._html_cost.innerHTML = `本次扫荡消耗：<font color='#0a953e'> ${cost[0][2]}</font>`
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(cost[0][0], cost[0][1])
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_cost, GameResPath.GetGoodsIconPath(goods_vo.goods_icon))
			this._img_cost.visible = true
		} else {
			this._html_cost.innerHTML = Util.StrToHTML("本次扫荡消耗：<font color='#0a953e'>免费</font>")
			this._img_cost.visible = false
		}
	}

	public Clear() {
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
	}


	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_lb_title: Laya.Label
	_html_left: Laya.HTMLDivElement
	_html_cost: Laya.HTMLDivElement
	_img_cost: Laya.Image
	_img_tip: Laya.Image
	_lb_tip: Laya.Label
	_list_item: Laya.List
	_img_close: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._lb_title,
			this._html_left,
			this._html_cost,
			this._img_cost,
			this._img_tip,
			this._lb_tip,
			this._list_item,
			this._img_close,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_lb_title",
				"_html_left",
				"_html_cost",
				"_img_cost",
				"_img_tip",
				"_lb_tip",
				"_list_item",
				"_img_close",
			])
	}
}
window["DungeonPartnerSweepView"] = DungeonPartnerSweepView
