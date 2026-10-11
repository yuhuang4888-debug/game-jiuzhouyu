import { BaseItem1 } from "../common/BaseItem1";
import { CommonRewardItem } from "../common/CommonRewardItem";
import { Config_Type } from "../common/Config";
import { EquipmentItem } from "../common/EquipmentItem";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { table } from "../common/table";
import { GoodsModel } from "../commonModel/GoodsModel";
import { ErlangParser } from "../util/ErlangParser";

export class DemonRotaryPreItem extends BaseItem1 {
	_Image1: Laya.Image
	_range: Laya.Label
	_Scroller1: Laya.List

	list_loop_mgr
	_reward
	item_list
	parent_mask_corners
	ac_item
	cfg_info
	type

	public constructor(parent) {
		super(parent)

		this.base_file = "demon"
		this.layout_file = "DemonRotaryPreItem"
		this.item_list = []
		this.load_callback=()=>{
			this.InitView(this.cfg_info,this.type)
		}
	}
	
	public InitView(cfg?, type?) {
		if(!this.is_loaded || this.cfg_info==undefined) return

		if(cfg.bless_value_1>=201){
			this._range.text = `${cfg.bless_value_1}及以上`
		}else{
			this._range.text = cfg.bless_value_1 + "~" + cfg.bless_value_2
		}
		
		let pool = type == 1 && cfg.reward_pool || cfg.high_reward_pool
		if (pool) {
			pool = JSON.parse(pool)
		}
		let new_add = cfg.shows_2
		if (new_add && new_add != "[]") {
			new_add = JSON.parse(new_add)
			new_add = new_add[type - 1] && new_add[type - 1][1]
		}
		let old_pool = []
		let new_pool = []
		for (let i in pool) {
			let v = pool[i]
			let is_old = true
			if (new_add && new_add != "[]") {
				for (let _tmpi in new_add) {
					let k = new_add[_tmpi]
					if (v[0] == k[0] && v[1] == k[1] && v[2] == k[2]) {
						is_old = false
						new_pool.push(v)
						break
					}
				}
			}
			if (is_old) {
				old_pool.push(v)
			}
		}

		/*
		let count = 0
		let createItem = (v?, is_new?) => {
			let item = this.item_list[count]
			if (!item) {
				item = new EquipmentItem(this.Content)
				item.Load()
				item.SetItemSize(85, 85)
				this.item_list.push(item)
			}
			item.ExcuteCallback(() => {
				let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(v[0], v[1])
				item.SetData(type, v[2], lock)
				if (is_new) {
					item.setTipsImg("uijlzp_023", "demon_asset")
				}
			})
			count = count + 1
		}
		*/
		let list = []
		if (new_pool.length > 0) {
			for (let i in new_pool) {
				let v = new_pool[i]
				// createItem(new_pool[i], true)
				list.push({
					size: 85,
					vo: {
						style: v[0],
						typeId: v[1],
						count: v[2]
					}
				})
			}
		}

		if (old_pool.length > 0) {
			for (let i in old_pool) {
				let v = old_pool[i]
				// createItem(old_pool[i], false)
				list.push({
					size: 85,
					vo: {
						style: v[0],
						typeId: v[1],
						count: v[2]
					}
				})
			}
		}

		if (!this.list_loop_mgr) {
			// this.ac_item = new Laya.ArrayCollection(list)
			// this.Content.dataProvider = this.ac_item
			// this.Content.itemRenderer = CommonRewardItem
			this.list_loop_mgr=new LoopScrowViewMgr()
			this.list_loop_mgr.SetData(this._Scroller1,CommonRewardItem,list,LoopScrCon.Horizontal)
		} else {
			// this.ac_item.source = list
			// this.ac_item.refresh()
			this.list_loop_mgr.replaceAll(list)
		}
	}

	public SetData(...parms) {
		if (parms[0] && parms[1]) {	
			this.cfg_info=parms[0]
			this.type=parms[1]
			this.InitView(parms[0], parms[1])
		}
	}

	public DeleteMe() {
		if (this.item_list.length > 0) {
			for (let item of this.item_list) {
				item.DeleteMe()
			}
			this.item_list.length = 0
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._Image1,
			this._range,
			this._Scroller1,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_range",
				"_Scroller1",
			])
		this._Scroller1.scrollBar.visible=false
	}
}
window["DemonRotaryPreItem"]=DemonRotaryPreItem