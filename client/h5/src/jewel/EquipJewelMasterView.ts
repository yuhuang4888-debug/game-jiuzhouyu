import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { EquipModel, EquipDefine, EquipEvent } from "../commonModel/EquipModel"
import { SetSizeDeltaY, Util } from "../util/Util"
import { EquipMasterItem } from "../equip/EquipMasterItem"
import { EquipNextMasterItem } from "../equip/EquipNextMasterItem"
import { Message } from "../sysInfo/SysInfoController"

export class EquipJewelMasterView extends BaseView1 {
	model
	cur_lv = 0
	next_lv = 1
	cur_loop_mgr
	next_loop_mgr
	cur_data_list
	next_data_list
	jewel_lv_cfg
	max_lv = false

	public constructor() {
		super()
		this.base_file = "jewel"
		this.layout_file = "EquipJewelMasterView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.background_alpha = 0.5
		this.use_background = true
		this.click_bg_toClose = true

		this.model = EquipModel.GetInstance()

		this.cur_data_list = []
		this.next_data_list = []

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	private Remove() {
		SetSizeDeltaY(this.display_obj, 607)
		if (this.cur_loop_mgr) {
			this.cur_loop_mgr.DeleteMe()
			this.cur_loop_mgr = null
		}

		if (this.next_loop_mgr) {
			this.next_loop_mgr.DeleteMe()
			this.next_loop_mgr = null
		}
	}

	private LoadSuccess() {
		this.jewel_lv_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_lv
		this.InitEvent()
		this.model.Fire(EquipEvent.REQUEST_PROTO, 15261)
	}

	private InitEvent() {
		Util.AddClickEvent(this.btn_close, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this.btn_active, () => {
			if (this.max_lv){
				return
			}
			if (this.cur_lv >= this.next_lv) {
				this.model.Fire(EquipEvent.REQUEST_PROTO, 15260, "c", 3)
			} else {
				Message.show("宝石总等级不足，无法激活")
			}
		}, this, true)

		this.BindEvent(this.model, EquipEvent.UPDATE_MASTER_VIEW, () => {
			this.UpdateView()
		})
	}

	private UpdateView() {
		this.cur_lv = this.model.GetAllJewelLv(this.jewel_lv_cfg)
		this.next_lv = this.model.GetMasterNextLv(3)
		this.btn_active.gray = this.cur_lv < this.next_lv
		this.img_redAc.visible = this.cur_lv >= this.next_lv
		if (this.next_lv != 0) {
			this.lb_stren2.color = this.cur_lv < this.next_lv ? "#ff4f50" : "#0a953e"
			this.lb_stren2.text = String(this.cur_lv)
			this.lb_stren3.text = "/" + this.next_lv
		} else {
			this.lb_stren2.text = ""
			this.lb_stren3.text = String(this.cur_lv)
		}

		let master_lv = this.model.GetMasterLv(3)
		let [cur_cfg, next_cfg] = this.model.GetWholeAwardCfg(EquipDefine.JEWEL_WHOLE_TYPE, master_lv)
		if (cur_cfg) {
			this.cur_data_list = JSON.parse(cur_cfg.attr_list)
			if (!this.cur_loop_mgr) {
				this.cur_loop_mgr = new LoopScrowViewMgr()
				this.cur_loop_mgr.SetData(this.Content1, EquipMasterItem, this.cur_data_list, LoopScrCon.Vertical)
			} else {
				this.cur_loop_mgr.replaceAll(this.cur_data_list)
			}
		}
		if (next_cfg) {
			this.next_data_list = JSON.parse(next_cfg.attr_list)
			if (!this.next_loop_mgr) {
				this.next_loop_mgr = new LoopScrowViewMgr()
				this.next_loop_mgr.SetData(this.Content, EquipNextMasterItem, this.next_data_list, LoopScrCon.Vertical)
			} else {
				this.next_loop_mgr.replaceAll(this.next_data_list)
			}
		}
		let offsetY = (!next_cfg || !cur_cfg) ? -230 : 0
		SetSizeDeltaY(this.display_obj, 607 + offsetY)
		this.btn_active.bottom = 15

		this.group_cur.visible = Boolean(cur_cfg)
		this.group_cur.height = Boolean(cur_cfg) ? 200 : -15	// 设置为负数重新计算布局
		this.group_next.visible = Boolean(next_cfg)
		this.group_next.height = Boolean(next_cfg) ? 200 : -15

		this.lb_cur.text = (!next_cfg && ("已满阶") || ("当前效果"))
		this.max_lv = !next_cfg
		if(this.max_lv){
			this.btn_active.gray = true
			this.img_redAc.visible = false
		}
	}

	img_bg: Laya.Image
	img_title: Laya.Image
	lb_title: Laya.Label
	gp_attr: Laya.VBox
	group_cur: Laya.Box
	_Image3: Laya.Image
	lb_cur: Laya.Label
	Content1: Laya.List
	group_next: Laya.Box
	_Image4: Laya.Image
	lb_next: Laya.Label
	Content: Laya.List
	btn_active: Laya.Image
	lb_active: Laya.Label
	img_redAc: Laya.Image
	btn_close: Laya.Image
	gp_stren: Laya.HBox
	lb_stren1: Laya.Label
	lb_stren2: Laya.Label
	lb_stren3: Laya.Label
	public GetComponents() {
		[
			this.img_bg,
			this.img_title,
			this.lb_title,
			this.gp_attr,
			this.group_cur,
			this._Image3,
			this.lb_cur,
			this.Content1,
			this.group_next,
			this._Image4,
			this.lb_next,
			this.Content,
			this.btn_active,
			this.lb_active,
			this.img_redAc,
			this.btn_close,
			this.gp_stren,
			this.lb_stren1,
			this.lb_stren2,
			this.lb_stren3,
		]
			= this.GetChildrenByNames([

				"img_bg",
				"img_title",
				"lb_title",
				"gp_attr",
				"group_cur",
				"_Image3",
				"lb_cur",
				"Content1",
				"group_next",
				"_Image4",
				"lb_next",
				"Content",
				"btn_active",
				"lb_active",
				"img_redAc",
				"btn_close",
				"gp_stren",
				"lb_stren1",
				"lb_stren2",
				"lb_stren3",
			])
	}
}
window["EquipJewelMasterView"] = EquipJewelMasterView