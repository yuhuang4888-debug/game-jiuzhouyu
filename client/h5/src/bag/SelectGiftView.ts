import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { BagModel } from "../commonModel/BagModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"
import { SelectGiftItem } from "./SelectGiftItem"

export class SelectGiftView extends BaseView1 {
	total_count
	model
	destroy_imm
	// preload_server_config
	Scritem_scroller
	item_group
	Local_Open
	Empok_btn
	show_open_movie
	is_center
	item_list
	open_callback
	select_list
	LoadSuccess
	// gift_cfg
	click_bg_toClose
	CloseCallBack
	InitEvent
	close_callback
	use_background
	goods_vo
	InitView

	public constructor() {
		super()
		this.base_file = "bag"
		this.layout_file = "SelectGiftView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.show_open_movie = true
		this.click_bg_toClose = true
		this.is_center = true
		this.destroy_imm = true

		this.total_count = 0
		this.item_list = []
		this.select_list = []
		this.model = BagModel.GetInstance()
		let local_Message = Message

		this.load_callback = () => {
			this.item_scroller.vScrollBar.visible = false
			this.LoadSuccess()
			//lua_resM:SetOutsideImageSprite(this, this._Image2, "client/assets/icon/common/uisy_017.png",true)
			//lua_resM:SetOutsideImageSprite(this,this._Image2,"client/assets/common/texture/uisy_017.png",true)
		}

		this.open_callback = () => { }

		this.close_callback = () => {
			this.CloseCallBack()
		}

		// this.preload_server_config = { "config_optional_gift": false }
		this.LoadSuccess = () => {

			// this.gift_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_optional_gift", false)
			// if (this.gift_cfg) {
				this.InitView()
				this.InitEvent()
				GlobalEventSystem.Fire(EventName.SETTING_INPUT_FOCUS);
			// }
		}

		this.Local_Open = (goods_vo?) => {

			this.goods_vo = goods_vo
			if (goods_vo) {
				this.total_count = this.goods_vo.goods_num
			}
			super.Open()
			this.InitView()
		}

		this.InitView = () => {
			if (!this.goods_vo || !this.is_loaded) {
				return
			}
			let cur_cfg = GoodsModel.GetInstance().getOpGiftVoByTypeIdAndCareer(this.goods_vo.type_id, 0)//this.gift_cfg[this.goods_vo.type_id + "@0"]
			if (!cur_cfg) {
				cur_cfg = GoodsModel.GetInstance().getOpGiftVoByTypeIdAndCareer(this.goods_vo.type_id, RoleManager.GetInstance().GetMainRoleCareer())//this.gift_cfg[this.goods_vo.type_id + "@" + RoleManager.GetInstance().GetMainRoleCareer()]
				if (!cur_cfg) {
					return
				}
			}
			let gift = JSON.parse(cur_cfg.list)
			for (let i = 0; i < gift.length; i++) {
				let item = this.item_list[i]
				if (!item) {
					item = new SelectGiftItem(this.Content)
					item.Load()
					this.item_list[i] = item
				}
				let call_back = (index?, change?, item?, pos?) => {
					let num = this.select_list[index]
					if (!num) {
						num = 0
					}
					if (change == "max") {
						change = this.total_count
					}
					if (change == "zixuan") {
						let max_num = this.total_count + num
						let num_change_fun = (value?) => {
							let now_num = this.select_list[index] || 0
							let tmp_ = this.total_count + now_num - value
							if (tmp_ >= 0) {
								this.total_count = this.total_count + now_num - value
								this.select_list[index] = value
								if (item) {
									item.SetNum(value)
								}
							}
						}
						GlobalEventSystem.Fire(EventName.OPEN_CALCULATOR_VIEW, max_num, num_change_fun, pos, null, null, true)
						return
					}
					change = Number(change)
					if (change > this.total_count) {
						local_Message.show("超过最大数量")
						return
					}
					let new_count = num + change
					if (new_count < 0) {
						local_Message.show("超过最小数量")
						return
					}
					if (new_count <= 0) {
						new_count = 0
						this.select_list[index] = null
					}
					this.select_list[index] = new_count
					this.total_count = this.total_count - change
					if (item) {
						item.SetNum(new_count)
					}
				}

				//item.includeInLayout = true
				item.SetVisible(true)
				//item:ExcuteCallback(() => {

				//}
				//)
				let bool = this.goods_vo.type_id == 32060119
				item.SetData(gift[i], call_back, i + 1, bool)
			}
			for (let i = gift.length; i < this.item_list.length; i++) {
				let item = this.item_list[i]
				if (item) {
					item.SetVisible(false)
				}
			}
			this.Content.height = gift.length * 146

			this.num_text.text = "剩余数量:" + this.goods_vo.goods_num
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.ok_btn, () => {
				if ((this.goods_vo && this.select_list) && Util.TableSize(this.select_list)) {
					GoodsModel.GetInstance().Fire(GoodsModel.RECEIVED_OPTIONAL_GIFT, this.goods_vo.goods_id, this.select_list)
					this.Close()
				} else {
					local_Message.show("请先选择一个要兑换的物品")
				}
			}
				, this, true)
			Util.AddClickEvent(this.close_btn, () => {
				this.Close()
			}
				, this, true)
		}

		this.CloseCallBack = () => {
			for (let key in this.item_list) {
				if (this.item_list[key]) {
					this.item_list[key].DeleteMe()
					this.item_list[key] = null
				}
			}
			this.item_list = []
			this.select_list = []
		}
	}

	public Open(goods_vo?) {
		this.Local_Open(goods_vo)
	}

	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_lb_title: Laya.Label
	ok_btn: Laya.Box
	_Image4: Laya.Image
	labelDisplay: Laya.Label
	close_btn: Laya.Image
	num_text: Laya.Label
	item_scroller: Laya.Panel
	Content: Laya.VBox
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._lb_title,
			this.ok_btn,
			this._Image4,
			this.labelDisplay,
			this.close_btn,
			this.num_text,
			this.item_scroller,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"_lb_title",
				"ok_btn",
				"_Image4",
				"labelDisplay",
				"close_btn",
				"num_text",
				"item_scroller",
				"Content",
			])
	}
}
window["SelectGiftView"] = SelectGiftView