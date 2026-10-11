import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"
import { RefBoxChildsLayout, RefBoxVLayout, RefGridLayout, Util } from "../util/Util"
import { BaseView1 } from "./BaseView1"
import { Enum_UILayer } from "./LayerManager"
import { ResManager } from "./ResManager"
import { RewardPreItem } from "./RewardPreItem"

export class RewardPreView extends BaseView1 {

	public item_scale
	public no_name = false

	Local_Open
	Clear
	OpenCallback
	SetItemList
	LoadSuccess
	InitEvent

	public constructor() {
		super()

		this.no_name = false;
		let _item_list = []
		let _reward_list = null
		this.base_file = "common"
		this.layout_file = "RewardPreView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = false
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.is_center = true
		let local_Math = Math
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			// this.RegisterMask(this._group_item)
			this.OpenCallback()
		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetImageSprite(this, this.title_img,"common", "uildzdz_008a")
			//ResManager.GetInstance().SetTexture(this, this.title_img, GameResPath.GetIcon("common", "uildzdz_008a"))
			this._Scroller1.vScrollBarSkin = ""
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}
				, this, true, null, null, null, null, true)
		}

		this.Local_Open = (parms?) => {
			_reward_list = parms
			super.Open()
		}

		this.Clear = () => {
			for (let key in _item_list) {
				_item_list[key].DeleteMe()
			}
			_item_list = []
		}

		this.OpenCallback = () => {
			this.SetItemList(_reward_list)
		}





		this.SetItemList = (reward_list?) => {




			let count_num = 0
			let list_len = reward_list.length


			//布局数据
			let layout_data = {
				column: 4,  //每行个数
				h_gap: 0,   //间距水平
				v_gap: 0,	//间距垂直
				item_w: 127,
				item_h: this.no_name?100:127,  //有名字和没名字的高度不一样
				frist_item_space:8
			}



			//计算容器高
			let cell_h = layout_data.item_h
			let cell_v_gap = layout_data.v_gap
			let row = local_Math.ceil(list_len /layout_data.column)
			let total_h = row * cell_h + (row - 1) * cell_v_gap
			this.Content.height = total_h+10

			let scroll_h
			let max_row=6 //最大6行，不然超框
			if(row>max_row){
				scroll_h = this.Content.y + (max_row * cell_h + (max_row - 1) * cell_v_gap)
			}else{
				scroll_h = this.Content.y + total_h
			}

			this._Scroller1.height = scroll_h
			this.bg_img_1.height = scroll_h + 6
			this._Image1.height = scroll_h + 110
			this._box.height =scroll_h + 110

			//所有子元素加载完后调用，调整布局
			let func = () => {
				count_num++
				if (count_num >= list_len) {
					//排布
					if (list_len <= layout_data.column) {
						let h_gap=10
						RefBoxChildsLayout(this.Content, h_gap, layout_data.item_w, true)
					} else {
						RefGridLayout(this.Content, layout_data)
					}
				}
			}

			//隐藏
			let i = 0
			for (i = 0; i < _item_list.length; i++) {
				_item_list[i].SetVisible(false)
			}

			//设置数据
			for (let i = 0; i < list_len; i++) {
				let info = reward_list[i]
				let item = _item_list[i]
				if (!item) {
					item = new RewardPreItem(this.Content)
					_item_list[i] = item
				}
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(info[0], info[1])
				item.SetData(type_id, info[2], this.no_name)
				item.SetVisible(true);
				if (this.item_scale) {
					item.SetScaleX(this.item_scale)
					item.SetScaleY(this.item_scale)
				}
				item.Load()

				item.ExcuteCallback(() => {
					func()
				})
			}



			// ///Vbox嵌套Hbox实现网格布局 row为HBox的数目
			// let row:number=Math.ceil(reward_list.length/4)
			// //最后一行的item有几个
			// let lastColumn=reward_list.length%4
			// for (let i = 0; i < row; i++) {
			// 	let hBox:Laya.HBox=new Laya.HBox()
			// 	let hBox1: Laya.HBox = new Laya.HBox()
			// 	hBox1.autoSize = true
			// 	hBox1.centerX = 0
			// 	this.Content.addChild(hBox)
			// 	hBox.addChild(hBox1)
			// 	hBox.height=130;
			// 	hBox.width=530
			// 	if(i==row-1){
			// 		///如果是最后一行
			// 		for(let j=0;j<lastColumn;j++){
			// 			let info = reward_list[i*4+j]
			// 			let item = _item_list[i*4+j]
			// 			if (!item) {
			// 				item = new RewardPreItem(hBox1)
			// 				_item_list[i*4+j] = item
			// 			}
			// 			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(info[0], info[1])
			// 			item.SetData(type_id, info[2], this.no_name)
			// 			item.SetVisible(true);
			// 			if (this.item_scale){
			// 				item.SetScaleX(this.item_scale)
			// 				item.SetScaleY(this.item_scale)
			// 			}
			// 			item.Load()
			// 		}
			// 		hBox.x=0;
			// 		break;
			// 	}
			// 	for(let j=0;j<4;j++){
			// 		let info = reward_list[i*4+j]
			// 		let item = _item_list[i*4+j]
			// 		if (!item) {
			// 			item = new RewardPreItem(hBox1)
			// 			_item_list[i*4+j] = item
			// 		}
			// 		let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(info[0], info[1])
			// 		item.SetData(type_id, info[2], this.no_name)
			// 		item.SetVisible(true);
			// 		if (this.item_scale){
			// 			item.SetScaleX(this.item_scale)
			// 			item.SetScaleY(this.item_scale)
			// 		}
			// 		item.Load()
			// 	}
			// 	hBox.x=0
			// }


			// for (let i = reward_list.length; i < _item_list.length; i++) {
			//     _item_list[i].SetVisible(false);
			// }
			///以下代码测试用
			// for (let i = 0; i < 3; i++) {
			// 	let hBox:Laya.HBox=new Laya.HBox()
			// 	this.Content.addChild(hBox)
			// 	hBox.height=130;
			// 	hBox.width=530
			// 	for(let j=0;j<4;j++){
			// 		let item = _item_list[i*4+j]
			// 		if (!item) {
			// 			item = new RewardPreItem(hBox)
			// 			item.Load()
			// 			_item_list[i*4+j] = item
			// 		}
			// 		item.SetData(31, 100, this.no_name)
			// 		item.visible = true
			// 		if (this.item_scale){
			// 			item.scaleX = item.scaleY = this.item_scale
			// 		}
			// 	}
			// 	hBox.x=0
			// }
		}


	}

	public Open(parms?) {

		this.Local_Open(parms)
	}



	_box: Laya.Box
	_Image1: Laya.Image
	_Group1: Laya.Box
	_Image2: Laya.Image
	title_img: Laya.Image
	bg_img_1: Laya.Image
	_btn_close: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.Box
	public GetComponents() {
		[
			this._box,
			this._Image1,
			this._Group1,
			this._Image2,
			this.title_img,
			this.bg_img_1,
			this._btn_close,
			this._Scroller1,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_box",
				"_Image1",
				"_Group1",
				"_Image2",
				"title_img",
				"bg_img_1",
				"_btn_close",
				"_Scroller1",
				"Content",
			])
	}
}
window["RewardPreView"] = RewardPreView