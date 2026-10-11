import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { ArenaModel } from "../commonModel/ArenaModel"
import { SetAnchoredPosition, SetAnchoredPositionY } from "../util/Util"
import { ArenaRankRewardItem } from "./ArenaRankRewardItem"

export class ArenaRankRewardView extends BaseItem1 {
	_Image1: Laya.Image
	_Scroller1: Laya.List
	_Group1: Laya.HBox
	_Label1: Laya.Label
	_lb_my_rank: Laya.Label
	_Label2: Laya.Label
	InitView
	Local_DeleteMe
	Scr_Scroller1
	_Viewport
	data_list
	item_list
	model
	open_callback
	time_event_id
	type

	public constructor(parent?) {
		super(parent)


		this.base_file = "arena"
		this.layout_file = "ArenaRankRewardView"
		this.layer_value = Enum_UILayer.Activity
		this.model = ArenaModel.GetInstance()
		this.item_list = null
		this.time_event_id = null
		this.type = null
		this.data_list = []

		this.load_callback = () => {

			// this.RegisterMask(this._Viewport)
			this.InitView()
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._Label2.size  = 18
			// 	SetAnchoredPosition(this._Label2,-13,-43)
			// }
		}

		this.open_callback = () => {
		}

		this.Local_DeleteMe = () => {
			if (this.item_list) {
				this.item_list.DeleteMe()
				this.item_list = null
			}
		}

		this.InitView = () => {
			this.type = "rank_reward"
			let my_rank = this.model.GetMyRank()
			this._lb_my_rank.text = String(my_rank > 0 && my_rank || "未上榜")
			// LayoutRebuilder(this._Group1)
			if (!my_rank || my_rank == 0) {
				my_rank = Number(this.model.GetCfgKeyValue(4)) + 1
			}
			//let cfg = ArenaModel.GetInstance().config_jjc_config//ResManager.GetInstance().GetGameConfigFromCache(this, "Jjcrankreward", false)
			ResManager.GetInstance().LoadGameConfig(this,"config_jjc_rank_reward",false,undefined,(cfg)=>{
				let now_index = 0
				let max_index = 0
				let create_index = 1
				if (cfg) {
					let item = null
					for(let key in cfg){
						let vo = cfg[key]
						if (my_rank <= vo.max && my_rank >= vo.min) {
							now_index = Number(key)
						}
	
						let item_data = {
							rank: key,
							my_rank: my_rank,
							vo: vo,
							type: this.type,
							create_index: create_index
						}
						table.insert(this.data_list, item_data)
	
						max_index = max_index + 1
						create_index = create_index + 1
					}
					if(!this.item_list){
						this.item_list = new LoopScrowViewMgr()
						this.item_list.SetData(this._Scroller1, ArenaRankRewardItem, this.data_list, LoopScrCon.Vertical, 1)
					}else{
						this.item_list.replaceAll(this.data_list)
					}
	
				}
				let index=-5
				for (let key in this.data_list) {
					let state = my_rank >= this.data_list[key].vo.min && my_rank <= this.data_list[key].vo.max
					if(state){
						index=Number(key)
						break
					}
				}
				this._Scroller1.scrollTo(index)
				// let max_height = max_index * 116 - 70
				// let centor_height = 240
				// let scroll_height = 593
	
				// let max_scrollV = max_height - scroll_height
				// let v = (now_index - 1) * 116 - centor_height
				// if (v < 0) {
				// 	v = 0
				// }
				// if (v > max_scrollV || now_index == 0) {
				// 	v = max_scrollV
				// }
				// SetAnchoredPositionY(this._gp_item_con, v)
				// this.item_list.WrapContent()
			})
		}
	}

	public DeleteMe() {
		this.Local_DeleteMe()
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._Image1,
			this._Scroller1,
			this._Group1,
			this._Label1,
			this._lb_my_rank,
			this._Label2,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Scroller1",
				"_Group1",
				"_Label1",
				"_lb_my_rank",
				"_Label2",
			])
		this._Scroller1.scrollBar.visible=false
	}
}
window["ArenaRankRewardView"]=ArenaRankRewardView