import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { ArenaModel } from "../commonModel/ArenaModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"

export class ArenaRankRewardItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_img_box: Laya.Image
	_Group1: Laya.Box
	_Image1: Laya.Image
	_img_now_tips: Laya.Image
	_state_img: Laya.Image
	_receive_gp: Laya.Box
	_receive_img: Laya.Image
	_Image2: Laya.Image
	_Label1: Laya.Label
	_lb_rank: Laya.Label
	_Scroller1: Laya.Box
	_Viewport: Laya.Image
	_gp_award_con: Laya.HBox
	VHS_Scroller1
	create_index
	is_delay_callback
	item_list
	model
	my_rank
	need_refresh_data
	rank
	type
	vo

	public static width = 521
	public static height = 116

	public constructor(parent?) {
		super()


		this.base_file = "arena"
		this.layout_file = "ArenaRankRewardItem"
		this.model = ArenaModel.GetInstance()
		this.need_refresh_data = false
		this.my_rank = null
		this.is_delay_callback = false
		this.vo = null
		this.rank = null
		this.item_list = null
		this.type = null
		this.create_index = null
		this.WIDTH=521
		this.HEIGT=116
		// this.load_callback = () => {

		// 	this.InitEvent()
		// }
		this.Load()
	}

	public load_callback() {

		//this.VHS_Scroller1.parentScroll = this.parent_wnd.GetComponentInParent(typeof(UnityEngine.UI.ScrollRect))

		let receive_func = () => {
			this.model.Fire(ArenaModel.REQUEST_CCMD_EVENT, 28017, this.create_index)
		}
		Util.AddClickEvent(this._receive_gp, receive_func, this, true)

		this.BindVar(this.model, "page_info", (event_name?, value?, old_value?) => {
			this.UpdateView()
		}
		)
	}

	public dataChanged() {
		if(!super.dataChanged()) return
		let data = this.data
		this.rank = data.rank
		this.my_rank = data.my_rank
		this.vo = data.vo
		this.type = data.type
		this.create_index = data.create_index

		this.UpdateView()

	}

	public UpdateView() {

		if (!this.rank) {
			return
		}
		if (this.type == "rank_reward") {
			let box_url = this.GetBoxImgUrl()
			// ResManager.GetInstance().SetImageSprite(this, this._img_box, "arena_asset", box_url, true)
			if (this.my_rank) {
				let state = this.my_rank >= this.vo.min && this.my_rank <= this.vo.max
				this._img_now_tips.visible = state
				let url = state && "uijj_017b" || "uijj_017"
				if(state){
				ResManager.GetInstance().SetTexture(this.base_item, this._img_bg, GameResPath.GetIcon( "arena", url))
				}else{
					ResManager.GetInstance().SetImageSpriteTrans(this.base_item, this._img_bg, GameResPath.GetIcon( "arena", url))
				}
			}

			if (this.vo.max == this.vo.min) {
				this._lb_rank.text = this.vo.max
			} else {
				this._lb_rank.text = this.vo.min + (" - ") + this.vo.max
			}
			let list = JSON.parse(this.vo.reward)
			if (!this.item_list) {
				this.item_list = []
			}
			for (let index in list) {
				var vo = list[index]
				let item = this.item_list[index]
				if (!item) {
					item = new BaseAwardItem(this._gp_award_con, null, "Activity")
					// item.SetMaskId(1)
					item.Load()
					table.insert(this.item_list, item)
					item.ExcuteCallback(()=>{
						item.SetItemSize(87,87)
					})
				}
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, vo[2], lock)
				}
			}
		} else if (this.type == "breach_reward") {
			this._img_now_tips.visible = false
			let box_url = this.GetBoxImgUrl()
			// ResManager.GetInstance().SetImageSprite(this, this._img_box, "arena_asset", box_url, true)
			ResManager.GetInstance().SetImageSprite(this.base_item, this._img_bg,"arena", "uijj_017")
			//ResManager.GetInstance().SetTexture(this.base_item, this._img_bg,GameResPath.GetIcon("arena", "uijj_017") )
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this._lb_rank.text = "Reach No." + this.rank
			// } else if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
			// 	this._lb_rank.text = "Capai Rank " + this.rank
			// } else {
	
	if(PlatformManager.IsEyouEnPlatform()){
					this._lb_rank.text = "Reach No." + this.rank
				}else{
						this._lb_rank.text = "达到第" + this.rank + "名"
				}
			// }
			this._lb_rank.fontSize = 18
			let index_num = Number(this.rank)
			if (!this.item_list) {
				this.item_list = []
			}
			let list = JSON.parse(this.vo.reward)
			for (let index in list) {
				var vo = list[index]
				let item = this.item_list[index]
				if (!item) {
					item = new BaseAwardItem(this._gp_award_con, null, "Activity")
					// item.SetMaskId(1)
					item.Load()
					table.insert(this.item_list, item)
					item.ExcuteCallback(()=>{
						item.SetItemSize(87,87)
					})
				}
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, vo[2], lock)
				}
			}
			let after_received = this.model.GetReceivedAfterList()
			if (after_received && this.my_rank) {
				if (after_received.length == 0) {
					if (index_num < this.my_rank || this.my_rank == 0) {
						ResManager.GetInstance().SetImageSprite(this, this._state_img, "arena_asset", "uikfhd_002", true)
						// this._state_img.scale(0.75,0.75)// = Vector3(0.75, 0.75, 0.75)
						this._state_img.visible = true
						this._receive_gp.visible = false
					} else {
						this._receive_gp.visible = true
						this._state_img.visible = false
					}
				} else {
					for (let i = 0; i <= after_received.length-1; i++) {
						if (this.create_index == after_received[i].break_id) {
							ResManager.GetInstance().SetImageSprite(this, this._state_img, "arena_asset", "uijj_021", true)
							// this._state_img.scale(1,1)// = Vector3(1, 1, 1)
							this._state_img.visible = true
							this._receive_gp.visible = false
							break
						}
						if (index_num < this.my_rank && i == after_received.length-1) {
							ResManager.GetInstance().SetImageSprite(this, this._state_img, "arena_asset", "uikfhd_002", true)
							this._state_img.visible = true
							// this._state_img.scale(0.75,0.75)// = Vector3(0.75, 0.75, 0.75)
							this._receive_gp.visible = false
							break
						}
						this._receive_gp.visible = true
						this._state_img.visible = false
					}

				}
			}
		}
	}

	public GetBoxImgUrl() {

		let _url = ""

		let key = Number(this.create_index)
		if (key == 1) {
			_url = "uijj_009e"
		} else if (key == 2) {
			_url = "uijj_009d"
		} else if (key == 3) {
			_url = "uijj_009c"
		} else if (key == 4) {
			_url = "uijj_009b"
		} else {
			_url = "uijj_009a"
		}

		return _url
	}

	public DeleteMe() {
		if (this.item_list) {
			for (let _tmpi in this.item_list) {
				var vo = this.item_list[_tmpi]
				vo.DeleteMe()
			}
			this.item_list = null
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._img_bg,
			this._img_box,
			this._Group1,
			this._Image1,
			this._img_now_tips,
			this._state_img,
			this._receive_gp,
			this._receive_img,
			this._Image2,
			this._Label1,
			this._lb_rank,
			this._Scroller1,
			this._Viewport,
			this._gp_award_con,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_box",
				"_Group1",
				"_Image1",
				"_img_now_tips",
				"_state_img",
				"_receive_gp",
				"_receive_img",
				"_Image2",
				"_Label1",
				"_lb_rank",
				"_Scroller1",
				"_Viewport",
				"_gp_award_con",
			])
	}
}
window["ArenaRankRewardItem"]=ArenaRankRewardItem