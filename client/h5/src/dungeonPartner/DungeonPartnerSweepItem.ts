import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { VipModel } from "../commonModel/VipModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { NotEnougnDiamond, Util } from "../util/Util"

export class DungeonPartnerSweepItem extends BaseItemRenderer {

	public WIDTH = 608 //86 + 13
	public HEIGT = 120

	item
	data
	item_list = []
	model: DungeonPartnerModel
	res_mgr: ResManager

	public constructor() {
		super()
		this.base_file = "dungeonPartner"
		this.layout_file = "DungeonPartnerSweepItem"
		this.model = DungeonPartnerModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {
		this._panel_item.hScrollBarSkin = ""
		this.InitEvent()
		// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("dungeonPartner", "uitc_007"))
		// this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61105, this.index)
		
	}

	public InitEvent() {
		let onClickBtnHandler = (e:Laya.Event) => {
			if (e.target == this._box_sweep) {
				let ok_func = () => {
					this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61109, this.index + 1)
				}

				let roleMgr = RoleManager.GetInstance()
				let cur_sweep_time = this.model.sweep_count //扫荡次数与章节无关
				let total_time = VipModel.GetInstance().GetVipPrivilegeValue(BaseDungeonModel.MODULE_ID, 2000037, 99, RoleManager.GetInstance().GetMainRoleVo().vip_flag)
				let left_time = Math.max(total_time - cur_sweep_time, 0)
				if (left_time <= 0) {
					Message.show("扫荡次数不足")
					return
				}
				let config_dungeon_special_cfg = this.res_mgr.GetGameConfigFromCache(this.base_item, "config_dungeon_special_cfg", false)
				let dun_partner_sweep_cost = JSON.parse(config_dungeon_special_cfg["37@dun_partner_sweep_cost"].value)
				let cost = dun_partner_sweep_cost[cur_sweep_time][1]
				if (cost.length > 0) {
					let goods_price = Number(cost[0][2])
					let money_enough = roleMgr.mainRoleInfo.jinLock + roleMgr.mainRoleInfo.jin >= goods_price
					// let gap = goods_price - roleMgr.mainRoleInfo.jinLock
					let check_jinlock_func = () => {
						if (roleMgr.mainRoleInfo.jinLock < goods_price) {
							let str = "<font color='#ff4f50'>当前绑玉数量不足，是否消耗勾玉代替？</font>"
							Alert.Show(str, Alert_Type.Two, ok_func, null, "确定", "取消")
							Alert.SetIsCharge(true)
						} else {
							ok_func()
						}
					}
					if (money_enough) {
						if (!this.model.sweep_show_alert) {
							let str = "是否消耗<font color='#639c12'>" + goods_price + "绑玉</font>进行扫荡"
							Alert.Show(str, Alert_Type.AlertTypeCheckBox, check_jinlock_func, null, "确定", "取消", null, false, (bool?) => {
								this.model.sweep_show_alert = bool
							}, "本次登录不再提示")
						} else {
							check_jinlock_func()
						}
					} else {
						let str = "您的勾玉不足" + goods_price + "，是否前往充值"
						NotEnougnDiamond(str)
					}
				} else {
					ok_func()
				}
			}
		}
		Util.AddClickEvent(this._box_sweep, onClickBtnHandler, this, true)

		this.BindEvent(this.model, DungeonPartnerModel.UPDATE_PARTNER_VIEW, (scmd61105?) => {
			if (scmd61105.level == this.index + 1) {
				this.UpdateProgress(scmd61105)
			}
		})
	}

	protected dataChanged() {
		if (super.dataChanged()) {
			this._lb_title.text = `第${this.index + 1}层`
			this.UpdateProgress(this.model.GetViewInfo(this.index + 1))
		}
	}

	public UpdateProgress(scmd61105?) {

		let cur_score = 0
		for (let i = 0; i < scmd61105.dun_list.length; i++) {
			let v = scmd61105.dun_list[i]
			cur_score = cur_score + v.score
		}
		let percent = cur_score / 27 * 100
		this._lb_progress.text = Math.floor(percent) + "%"

		this._box_sweep.gray = 0 == cur_score

		this._box_sweep.mouseEnabled = 0 != cur_score

		let sweep_reward = ErlangParser.GetInstance().Parse(this.data.sweep_reward)
		let goods_model = GoodsModel.GetInstance()
		let getItemData = (v) => {
			let [type_id, lock] = goods_model.GetMappingTypeId(v[0], v[1])
			let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
			if (0 == percent) { //策划说进度0显示未进度100%的奖励
				return [goods_vo.type_id, v[2], lock]
			} else {
				return [goods_vo.type_id, Math.floor(v[2] * cur_score / 27), lock]
			}
		}

		


		let item, v
		for (let i = 0; i < sweep_reward.length; i++) {
			v = sweep_reward[i]
			item = this.item_list[i]
			if(!item){
				item = new EquipmentItem(this._panel_item)
				item.Load()
				item.SetItemSize(52, 52)
				item.SetFontSize(30)
				this.item_list[i] = item
			}
			let data = getItemData(v)
			item.SetData(data[0], data[1], data[2])
			// if (0 == item.goods_num) {
			// 	item.SetVisible(false)
			// } else {
			// 	item.SetVisible(true)
			// }
			item.SetPosition(i * 57, 0)
		}


		if(!this.item){
			this.item = new EquipmentItem(this._box_item)
			this.item.Load()
			this.item.SetItemSize(84, 84)
			this.item.SetFontSize(30)
		}
		let first_reward = table.remove(sweep_reward, 1)[0]
		let data = getItemData(first_reward)
		this.item.SetData(data[0], data[1], data[2])
	}

	public DeleteMe() {
		for (let i = 0; i < this.item_list.length; i++) {
			let v = this.item_list[i]
			v.DeleteMe()
		}
		this.item_list.length = 0

		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_lb_title: Laya.Label
	_lb_desc: Laya.Label
	_lb_progress: Laya.Label
	_box_item: Laya.Box
	_panel_item: Laya.Panel
	_box_sweep: Laya.Box
	_img_sweep: Laya.Image
	_lb_sweep: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._lb_title,
			this._lb_desc,
			this._lb_progress,
			this._box_item,
			this._panel_item,
			this._box_sweep,
			this._img_sweep,
			this._lb_sweep,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_lb_title",
				"_lb_desc",
				"_lb_progress",
				"_box_item",
				"_panel_item",
				"_box_sweep",
				"_img_sweep",
				"_lb_sweep",
			])
	}
}
window["DungeonPartnerSweepItem"] = DungeonPartnerSweepItem
