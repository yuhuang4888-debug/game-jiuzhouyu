import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { EquipModel, EquipEvent, EquipDefine } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"
import { EquipJewelBagItem } from "./EquipJewelBagItem"

export class EquipJewelBagView extends BaseView1 {
	ChickItem
	Clear
	Emp_btn_off
	Emp_btn_up
	GetBagList
	InitEvent
	LoadSuccess
	Local_Open
	Scr_Scroller1
	UpdateItem
	UpdateView

	loop_mgr

	public constructor() {
		super()
		this.base_file = "jewel"
		this.layout_file = "EquipJewelBagView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true

		let _model = EquipModel.GetInstance()
		let res_mgr = ResManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()

		let jewel_data_ = null
		let dynamic_ = null
		let cur_select_pos_ = null

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.Local_Open = (parms?) => {
			jewel_data_ = parms[0]
			dynamic_ = parms[1]
			cur_select_pos_ = parms[2]
			super.Open()
		}

		this.Clear = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}

		this.LoadSuccess = () => {
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_up, () => {

				let [type_id_dic, goods_id_dic] = _model.GetRedDic(true);
				let jewel_lv_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_lv;
				let cur_cfg = jewel_lv_cfg[jewel_data_.type_id];
				if(cur_cfg && type_id_dic[jewel_data_.type_id]){
					_model.Fire(EquipEvent.REQUEST_PROTO, 15215, "ccc", dynamic_.equip_type, cur_select_pos_, 0)
				}else{
					Message.show("暂无可合成宝石")
				}
	
			}
				, this, true)
			Util.AddClickEvent(this._btn_off, () => {
				if (!dynamic_) {
					return
				}
				if (!cur_select_pos_) {
					return
				}
				_model.Fire(EquipEvent.REQUEST_PROTO, 15209, "cc", dynamic_.equip_type, cur_select_pos_)
			}
				, this, true)
			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true)
			this.BindEvent(_model, EquipEvent.SET_JEWEL, (info?) => {
				jewel_data_ = info
				this.UpdateView()
			}
			)
			this.BindEvent(_model, EquipEvent.OFF_JEWEL, (info?) => {
				jewel_data_ = null
				this.UpdateView()
			}
			)
			this.BindEvent(_model, EquipEvent.UPGRADE_JEWEL, (info?) => {
				jewel_data_ = info
				this.UpdateView()
			})
		}

		//this.ChickItem = (item?) => {
		//let data = item.data
		//if (data._is_show ) {
		////GlobalEventSystem:Fire(EventName.OPEN_SHOP_MAIN_VIEW)
		//OpenFun.OpenFunHandler(60)
		//this:Close()
		//} else if (data.goods_id ) {
		//if (dynamic_ && cur_select_pos_ ) {
		//_model:Fire(EquipEvent.REQUEST_PROTO, 15208, "ccl", dynamic_.equip_type, cur_select_pos_, data.goods_id)
		//}
		//}
		//}

		this.UpdateView = () => {
			this.UpdateItem()
			if (jewel_data_) {
				let [type_id_dic, goods_id_dic] = _model.GetRedDic(true);
				let jewel_lv_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_lv;
				let cur_cfg = jewel_lv_cfg[jewel_data_.type_id];
				let has_next = !cur_cfg || cur_cfg.next_lv_stone != 0;
				this._btn_up.visible = has_next;
				this._btn_off.visible = true;
				this._btn_off.x = has_next ? 41 : 140;
				this._reddot.visible = cur_cfg && type_id_dic[jewel_data_.type_id];
			} else {
				this._btn_up.visible = false
				this._btn_off.visible = false
				this._reddot.visible = false
			}
		}

		this.UpdateItem = () => {
			let list = this.GetBagList()
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._Scroller1, EquipJewelBagItem, list, LoopScrCon.Vertical)
			} else {
				this.loop_mgr.replaceAll(list)
			}
		}

		this.GetBagList = () => {
			let type_id = (jewel_data_ && (jewel_data_.type_id) || (null))
			let equip_stone_inlay_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_inlay", false)
			let jewel_lv_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_lv", false)
			let list: any[] = _model.GetBagJewelsByType(dynamic_.equip_type, equip_stone_inlay_cfg, jewel_lv_cfg, type_id)
			if (list.length < 1) {
				let basic = goods_model.GetGoodsBasicByTypeId(type_id)
				let tdata = EquipDefine.JEWEL_TYPE_DIC[basic.subtype]
				let data = { type_id: tdata.id, name: tdata.name, _is_show: true }
				table.insert(list, 1, data)
			} else {
				for (let k = 0; k < list.length; k++) {
					var info = list[k]
					info.equip_type = dynamic_.equip_type
					info.select_pos = cur_select_pos_
				}
			}
			if (jewel_data_) {
				let data = _model.CopySCMD(jewel_data_)
				goods_model.SetBaseInfo(data)
				data.goods_num = 0
				data._is_equip = true
				list.unshift(data)
			}
			//宝石直升丹效果
			let up_one_goods = GoodsModel.GetInstance().GetTypeGoodsNum(EquipDefine.JEWEL_UP_GOODS)
			let cfg
			if (type_id) {
				cfg = jewel_lv_cfg[type_id]
			}
			if (up_one_goods > 0 && cfg && cfg.lv < 9) {
				let data = { type_id: EquipDefine.JEWEL_UP_GOODS, equip_type: dynamic_.equip_type, select_pos: cur_select_pos_, is_up_one: true, show_tips: cfg && cfg.lv < 6 }
				goods_model.SetBaseInfo(data)
				table.insert(list, data)
			}
			return list
		}
	}

	public Open(...new_args) {
		let parms = new_args
		this.Local_Open(parms)
	}

	_Image11: Laya.Image
	_Image2: Laya.Image
	_Label1: Laya.Label
	_Image3: Laya.Image
	_btn_up: Laya.Image
	lb_up: Laya.Label
	_reddot: Laya.Image
	_btn_off: Laya.Image
	lb_off: Laya.Label
	_Scroller1: Laya.List
	_Group2: Laya.HBox
	_Image4: Laya.Image
	_Label2: Laya.Label
	closeBtn: Laya.Image
	public GetComponents() {
		[
			this._Image11,
			this._Image2,
			this._Label1,
			this._Image3,
			this._btn_up,
			this.lb_up,
			this._reddot,
			this._btn_off,
			this.lb_off,
			this._Scroller1,
			this._Group2,
			this._Image4,
			this._Label2,
			this.closeBtn,
		]
			= this.GetChildrenByNames([
				"_Image11",
				"_Image2",
				"_Label1",
				"_Image3",
				"_btn_up",
				"lb_up",
				"_reddot",
				"_btn_off",
				"lb_off",
				"_Scroller1",
				"_Group2",
				"_Image4",
				"_Label2",
				"closeBtn",
			])
	}
}
window["EquipJewelBagView"] = EquipJewelBagView