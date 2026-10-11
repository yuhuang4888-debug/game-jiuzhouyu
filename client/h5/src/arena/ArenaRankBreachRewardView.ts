import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { ArenaModel } from "../commonModel/ArenaModel"
import { SetAnchoredPositionY } from "../util/Util"
import { ArenaRankRewardItem } from "./ArenaRankRewardItem"

export class ArenaRankBreachRewardView extends BaseItem1 {
	_Image1: Laya.Image
	_Label1: Laya.Label
	_Scroller1: Laya.List
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
		this.layout_file = "ArenaRankBreachRewardView"
		this.layer_value = Enum_UILayer.Activity
		this.model = ArenaModel.GetInstance()
		this.item_list = null
		this.time_event_id = null
		this.type = null
		this.data_list = []

		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._Label1.size  = 18
			// }
			// this.RegisterMask(this._Viewport)
			this.InitView()
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
			this.type = "breach_reward"
			let my_rank = this.model.GetMyRank()
			let my_history_rank = this.model.GetMyHistoryHighRank()
			if (!my_rank || my_rank == 0) {
				my_rank = Number(this.model.GetCfgKeyValue(4)) + 1
			}
			ResManager.GetInstance().LoadGameConfig(this,"config_jjc_reward_break",false,undefined,(cfg)=>{
				//let cfg = ArenaModel.GetInstance().configjjc //ResManager.GetInstance().GetGameConfigFromCache(this, "Jjcrewardbreak", false)
			let now_index = 0
			let max_index = 0
			let create_index = 1
			if (cfg) {
				let item = null
				for (let key in cfg) {
					
					let vo = cfg[key]
					let rank = cfg[key].rank
					if (my_rank >= vo.rank) {
						now_index = Number(key)
					}
					let item_data = {
						rank: rank,
						my_rank: my_history_rank,
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
				let index=-5
				let after_received = this.model.GetReceivedAfterList()
				// for (let key1 in after_received) {
					for (let key in this.data_list) {
						if(!after_received[0] || this.data_list[key].create_index>=after_received[0].break_id)  break
						if(my_rank<=this.data_list[key].rank){
							index=Number(key)
						}
					}
				// }
				if(index==-5){
					this._Scroller1.scrollTo(100)
				}else{
					this._Scroller1.scrollTo(index-3)
				}
				
				
			}
			let max_height = max_index * 116 - 70
			let centor_height = 240
			let scroll_height = 593

			// let max_scrollV = max_height - scroll_height
			// let v = (now_index - 1) * 116 - centor_height
			// if (v < 0) {
			// 	v = 0
			// }
			// if (v > max_scrollV || now_index == 0) {
			// 	v = max_scrollV
			// }
			// if(v){
			// 	this._Scroller1.scrollBar.value=v	
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
			this._Label1,
			this._Scroller1,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Label1",
				"_Scroller1",
			])
		this._Scroller1.scrollBar.visible=false
	}
}
window["ArenaRankBreachRewardView"]=ArenaRankBreachRewardView