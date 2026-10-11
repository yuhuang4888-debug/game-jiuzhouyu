import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Util } from "../util/Util"
import { MoneyProviewItem } from "./MoneyProviewItem"
import { MoneyTreeItem } from "./MoneyTreeItem"

export class MoneyProview extends BaseView1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Group1: Laya.HBox
	_Image3: Laya.Image
	_Label1: Laya.Label
	_Image4: Laya.Image
	_scr_reward: Laya.Panel
	Content: Laya.VBox
	_img_close: Laya.Image
	_scrolle:Laya.List
	Destroy_Callback
	InitEvnet
	InitView
	SetData
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	mask
	show_open_movie
	use_background
	item_list
	public constructor() {
		super()


		this.base_file = "moneyTree"
		this.layout_file = "MoneyProview"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		// let item_list = []
		let reward_list = null
		this.load_callback = () => {

			// this.mask = this.GetChild("_scr_reward/_gp_reward").GetComponent("Image")
			// LayoutRebuilder(this._Group1)
			// this.RegisterMask(this.mask)
			this.InitEvnet()
			this.InitView()
		}

		this.destroy_callback = () => {
			this.Destroy_Callback()
		}

		this.InitEvnet = () => {
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}
				, this, true)
		}

		this.InitView = () => {
			if (!reward_list) {
				return
			}
			// for (let _tmpi in item_list) {
			// 	var item = item_list[_tmpi]
			// 	item.visible = false
			// }
			if(!this.item_list){
				this.item_list=new LoopScrowViewMgr()
				this.item_list.SetData(this._scrolle,MoneyProviewItem,reward_list,LoopScrCon.Vertical)
			}else{
				this.item_list.replaceAll(reward_list)
			}
			// for (let i in reward_list) {

			// 	let item = item_list[i]
			// 	if (!item) {
			// 		item = new EquipmentItem(this.Content, null, this.layer_value)
			// 		table.insert(item_list, item)
			// 		item.Load()
			// 		item.SetUseMask(true)
			// 	}
			// 	item.ExcuteCallback(() => {
			// 		item.visible = true
			// 		let [typeID, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward_list[i].reward[0].style, reward_list[i].reward[0].typeId)
			// 		item.SetData(typeID, reward_list[i].reward[0].count, lock)
			// 	}
			// 	)
			// }
		}

		this.SetData = (reward?) => {
			reward_list = reward
		}

		this.Destroy_Callback = () => {
			// for (let _tmpi in item_list) {
			// 	var item = item_list[_tmpi]
			// 	item.DeleteMe()
			// }
			// item_list = []
			if(this.item_list){
				this.item_list.DeleteMe()
			}
			this.item_list=null
		}

	}


	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Group1,
			this._Image3,
			this._Label1,
			this._Image4,
			this._scr_reward,
			this.Content,
			this._img_close,
			this._scrolle
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Group1",
				"_Image3",
				"_Label1",
				"_Image4",
				"_scr_reward",
				"Content",
				"_img_close",
				"_scrolle"
			])
		this._scrolle.scrollBar.visible=false
		this._scr_reward.vScrollBar.visible=false
	}
}
window["MoneyProview"]=MoneyProview