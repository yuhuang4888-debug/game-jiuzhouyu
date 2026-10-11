import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BagModel } from "../commonModel/BagModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { OneKeyTabItem } from "./OneKeyTabItem"
import { OneKeyUseItem } from "./OneKeyUseItem"

export class OneKeyUseView extends BaseView1 {
	

	InitEvent
	Clear
	InitView

	loop_mgr: LoopScrowViewMgr
	model:BagModel
	goodsModel:GoodsModel
	tab_item_list
	
	public constructor() {
		super()

		this.base_file = "bag"
		this.layout_file = "OneKeyUseView"
		this.model = BagModel.GetInstance();
		this.goodsModel = GoodsModel.GetInstance();
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.show_open_movie = true
		this.is_center = true
		this.click_bg_toClose = true
		this.destroy_imm = false

		let local_GoodsModel = GoodsModel
		this.load_callback = () => {

			this.InitEvent()
			this.InitView()
			ResManager.GetInstance().SetOutsideImageSprite(this,this._Image5,GameResPath.GetIcon("common2","com_line_5"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("common", "uisy_023"))
		}

		this.open_callback = () => {
		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.InitEvent = () => {
			this.BindEvent(this.goodsModel, local_GoodsModel.UPDATE_GOODS_NUM, () => {
				if (this.use_delete_method) {
					return
				}
				let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods", false)
				let list = this.model.GetOneKeyUseList(cfgs, true)
				this.loop_mgr.replaceAll(list)
				this.nothingLb.visible = list.length == 0
			}
			)

			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.useBtn, () => {
				for (let key in this.model.use_select_dic) {
					let goodsVo = this.goodsModel.GetGoodsVoByGoodsId(key)
					if (goodsVo) {
						this.goodsModel.Fire(local_GoodsModel.USE_BAG_GOODS, goodsVo.goods_id, goodsVo.goods_num)
					}
				}
				if (Util.TableSize(this.model.use_select_dic) == 0) {
					Message.show("当前无可一键使用的道具")
				}
			}, this, true)
			
		}

		this.InitView = () => {
			let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods", false)
			let list = this.model.GetOneKeyUseList(cfgs, true)
			if (list.length == 0) {
				this.nothingLb.visible = true
			} else {
				this.nothingLb.visible = false
			}

			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._Scroller2, OneKeyUseItem, list, LoopScrCon.Vertical, 6)
			} else {
				this.loop_mgr.replaceAll(list)
			}

			this.tab_item_list = []
			for (let _tmpi in this.model.typeList) {
				let vo = this.model.typeList[_tmpi]
				let tabItem = new OneKeyTabItem(this.Content1)
				tabItem.Load()
				tabItem.ExcuteCallback(() => {
					tabItem.SetData(vo)
				})
				table.insert(this.tab_item_list, tabItem)
			}
		}

		this.Clear = () => {
			if (this.tab_item_list) {
				for (let _tmpi in this.tab_item_list) {
					let vo = this.tab_item_list[_tmpi]
					vo.DeleteMe()
				}
				this.tab_item_list = null
			}
			this.model.use_select_dic.length = 0
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}
	}

	_img_bg: Laya.Image
	closeBtn: Laya.Image
	_Image3: Laya.Image
	_Label1: Laya.Label
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Scroller1: Laya.Panel
	Content1: Laya.HBox
	_Scroller2: Laya.List
	nothingLb: Laya.Label
	useBtn: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this.closeBtn,
			this._Image3,
			this._Label1,
			this._Image4,
			this._Image5,
			this._Scroller1,
			this.Content1,
			this._Scroller2,
			this.nothingLb,
			this.useBtn,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"closeBtn",
				"_Image3",
				"_Label1",
				"_Image4",
				"_Image5",
				"_Scroller1",
				"Content1",
				"_Scroller2",
				"nothingLb",
				"useBtn",
			])
	}
}
window["OneKeyUseView"] = OneKeyUseView