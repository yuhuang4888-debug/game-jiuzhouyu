import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrowViewMgr,LoopScrCon } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { PetEquipType, PetEquipWholeType } from "../commonModel/PetEquipDefine";
import { PetEquipModel } from "../commonModel/PetEquipModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { PetEquipMasterItem } from "./PetEquipMasterItem";
import { PetEquipNextMasterItem } from "./PetEquipNextMasterItem";

export class PetEquipMasterView extends BaseView1 {
	bg: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_lb_title: Laya.Label
	_lb_stren: Laya.Label
	_Group1: Laya.Box
	group_cur: Laya.Box
	_Image3: Laya.Image
	cur_tip: Laya.Label
	cur_title: Laya.Label
	// _Scroller1: Laya.Panel
	cur_list: Laya.List
	group_next: Laya.Box
	_Image4: Laya.Image
	_Label1: Laya.Label
	next_title: Laya.Label
	// _Scroller2: Laya.Panel
	next_list: Laya.List
	click:Laya.Image
	_stren_box:Laya.Box

	protected _wtype: PetEquipWholeType;

	protected _str_1 = "强化大师";
	protected _str_2 = "当前全身强化等级";
	protected _str_3 = "总等级";

	Local_Open
	LoadSuccess
	UpdateView
	GetWholeData
	cur_list_loop_mgr
	next_list_loop_mgr
	public constructor() {
		super()

		let model = PetEquipModel.GetInstance(),
			_type_: PetEquipType,
			cur_item_list_ = [],
			next_item_list_ = [],
			cur_data_list_ = [],
			next_data_list_ = [],
			cur_collect_,
			next_collect_

		this.base_file = "petEquip"
		this.layout_file = "PetEquipMasterView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.background_alpha = 0.5
		this.use_background = true
		this.click_bg_toClose = true
		this.is_load_res = false

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.Local_Open = (...parms) => {
			[_type_] = parms
			super.Open()
		}

		this.DeleteMe = () => {
			this.display_obj.height = 607
			super.DeleteMe()
		}

		this.Close = () => {
			this.DeleteMe()
			super.Close()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image2, GameResPath.GetIcon("common2", "uity_016f"))
			// ResManager.GetInstance().SetTexture(this, this._Image3, GameResPath.GetIcon("common2", "uity_016j"))
			// ResManager.GetInstance().SetTexture(this, this._Image4, GameResPath.GetIcon("common2", "uity_016j"))
			this._lb_title.text = this._str_1
			this.UpdateView()
		}

		this.UpdateView = () => {
			let [cur_cfg, next_cfg] = this.GetWholeData()
			let lv = model.GetAllLv(_type_, this._wtype)
			this._lb_stren.text = `${this._str_2}：${lv}`

			if (cur_cfg) {	
				cur_data_list_ = JSON.parse(cur_cfg.attr_list)
				// cur_collect_ = new Array(cur_data_list_)
				// this.cur_list.dataSource = cur_data_list_
				// this.cur_list.itemRender = PetEquipMasterItem
				if(!this.cur_list_loop_mgr){
					this.cur_list_loop_mgr=new LoopScrowViewMgr()
					this.cur_list_loop_mgr.SetData(this.cur_list,PetEquipMasterItem,cur_data_list_,LoopScrCon.Vertical)
				}else{
					this.cur_list_loop_mgr.replaceAll(cur_data_list_)
				}
				this.cur_title.text = `${this._str_3}：${cur_cfg.need_lv}`
				this.group_next.y=240
				this._stren_box.y=541
			}else{
				this.group_next.y=0
				this._stren_box.y=300
			}
			if (next_cfg) {
				next_data_list_ = JSON.parse(next_cfg.attr_list)
				// next_collect_ = new Array(next_data_list_)
				// this.next_list.dataSource = next_data_list_
				// this.next_list.itemRender = PetEquipNextMasterItem
				if(!this.next_list_loop_mgr){
					this.next_list_loop_mgr=new LoopScrowViewMgr()
					this.next_list_loop_mgr.SetData(this.next_list,PetEquipMasterItem,next_data_list_,LoopScrCon.Vertical)
				}else{
					this.next_list_loop_mgr.replaceAll(next_data_list_)
				}
				this.next_title.text = `${this._str_3}：${next_cfg.need_lv}`
			}
			let offsetY = !next_cfg || !cur_cfg ? -230 : 0
			this.display_obj.height += offsetY
			this.bg.height += offsetY

			this.group_cur.visible  = !!cur_cfg
			this.group_next.visible  = !!next_cfg

			this.cur_tip.text = !next_cfg ? "已满阶" : "当前效果"
		}

		this.GetWholeData = () => {
			return model.GetWholeDataTwo(_type_, this._wtype)
		}

	}

	public InitEvent(){
		Util.AddClickEvent(this.click,this.Close,this)
	}
	public Open(...parms) {

		this.Local_Open(...parms)
	}


	public GetComponents() {
		[
			this.bg,
			this._Image1,
			this._Image2,
			this._lb_title,
			this._lb_stren,
			this._Group1,
			this.group_cur,
			this._Image3,
			this.cur_tip,
			this.cur_title,
			this.cur_list,
			this.group_next,
			this._Image4,
			this._Label1,
			this.next_title,
			this.next_list,
			this.click,
			this._stren_box
		]
			= this.GetChildrenByNames([

				"bg",
				"_Image1",
				"_Image2",
				"_lb_title",
				"_lb_stren",
				"_Group1",
				"group_cur",
				"_Image3",
				"cur_tip",
				"cur_title",
				"cur_list",
				"group_next",
				"_Image4",
				"_Label1",
				"next_title",
				"next_list",
				"click",
				"_stren_box"
			])
		this.cur_list.scrollBar.visible=false
		this.next_list.scrollBar.visible=false
	}
}
window["PetEquipMasterView"]=PetEquipMasterView