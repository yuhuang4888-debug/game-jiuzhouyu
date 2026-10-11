import { BaseView1 } from "./BaseView1"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GlobalTimerQuest, Util } from "../util/Util"
import { BaseAwardItem } from "./BaseAwardItem"
import { Enum_UILayer } from "./LayerManager"
import { table } from "./table"
import { Mathf } from "../util/Mathf"

export class GoodsExpiredView extends BaseView1 {
	CancelTimer
	CloseFunc
	InitEvent
	InitView
	Local_Open
	SetOkText
	award_list
	close_time
	goodsData
	timer_id

	/**界面类型 */
	private viewType: number;
	private tipsStr: string;

	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "GoodsExpiredView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.destroy_imm = true
		this.append_to_ctl_queue = true;

		this.award_list = []
		this.close_time = 15
		let goods_model = GoodsModel.GetInstance()
		let request_proto = GoodsModel.REQUEST_CCMD_EVENT

		this.load_callback = () => {
			this.goods_scroller.hScrollBarSkin = ""
			if (this.goodsData) {
				this.InitView()
				this.InitEvent()
			}
		}

		this.close_callback = () => {
			this.CloseFunc()
		}

		this.Local_Open = (goodsData, tipsStr?: string, type?: number) => {
			this.goodsData = goodsData
			this.viewType = type;
			this.tipsStr = tipsStr;
			if (this.is_loaded) {
				this.InitView()
				this.InitEvent()
			}
		}

		this.InitView = () => {
			// this.ok_btn,
			// this.close_btn,
			// this.cancelbtn
			// = GetChildGameObjects(this.form, {
			// 		"ok_btn",
			// 		"close_btn",
			// 		"cancelbtn"
			// 	})
			// this.goods_group,
			// this.goods_mask,
			// this._Image4
			// = GetChildTransforms(this.form, {
			// 		"goods_scroller/goods_group/Content",
			// 		"goods_scroller/goods_group",
			// 		"_Group1/_Image4"
			// 	})
			// this.ok_btn_text = this.GetChild("ok_btn/labelDisplay").GetComponent("Text")
			this.contentText.text = this.tipsStr || '阴阳师，您有以下物品过期了，是否回收？';
			if (!this.goodsData) {
				return
			}
			// this.RegisterMask(this.goods_mask.GetComponent("Image"))
			let goods = (this.goodsData.goods_list || this.goodsData);
			for (let _tmpi in goods) {
				let vo = goods[_tmpi]
				let goodsbasic = goods_model.GetGoodsBasicByTypeId(vo.type_id)
				if (goodsbasic) {
					let item = new BaseAwardItem(this.Content)
					item.SetUseMask(true)
					item.Load()
					item.SetData(goodsbasic.type_id, vo.goods_num)
					item.SetItemSize(100, 100)
					table.insert(this.award_list, item)
				}
			}
			let items_width = this.award_list.length * 100 + (this.award_list.length - 1) * 20
			this.goods_scroller.width = Mathf.Min(items_width, 500)
			if (items_width > 500) {
				this.goods_scroller.elasticEnabled = true
			}
			this.CancelTimer()
			this.timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
				this.SetOkText()
			}, 1, -1)
			this._lb_ok.text = "确定(" + this.close_time + ")"

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	SetSizeDelta(this._Image4,120,28)
			// 	SetAnchoredPosition(this._Image4,213,-13)
			// }
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._close_btn, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._cancel_btn, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._ok_btn, () => {
				if (this.viewType) {
					this.goodsData.sort((a, b) => {
						return b.color - a.color;
					});
					for (const item of this.goodsData) {
						goods_model.Fire(request_proto, 15050, "li", item.goods_id, item.goods_num);
					}
				} else {
					goods_model.Fire(request_proto, 15027, "c", 2)
				}
				this.Close()
			}
				, this, true)
		}

		this.CancelTimer = () => {
			if (this.timer_id) {
				GlobalTimerQuest.CancelQuest(this.timer_id)
				this.timer_id = null
			}
		}

		this.SetOkText = () => {
			this.close_time = this.close_time - 1
			if (this.close_time < 0) {
				if (this.viewType) {
					this.goodsData.sort((a, b) => {
						return b.color - a.color;
					});
					for (const item of this.goodsData) {
						goods_model.Fire(request_proto, 15050, "li", item.goods_id, item.goods_num);
					}
				} else {
					goods_model.Fire(request_proto, 15027, "c", 2)
				}
				this.Close()
			} else {
				this._lb_ok.text = "确定(" + this.close_time + ")"
			}
		}

		this.CloseFunc = () => {
			this.CancelTimer()
			if (this.award_list) {
				for (let _tmpi in this.award_list) {
					let vo = this.award_list[_tmpi]
					if (vo) {
						vo.DeleteMe()
					}
				}
				this.award_list = []
			}
		}
	}

	public Open(goodsData?, str?: string, type?: number) {
		this.Local_Open(goodsData, str, type)
		super.Open()
	}

	bg: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_lb_title: Laya.Label
	contentText: Laya.Label
	goods_scroller: Laya.Panel
	Content: Laya.HBox
	_close_btn: Laya.Image
	_cancel_btn: Laya.Box
	_img_cancel: Laya.Image
	_lb_cancel: Laya.Label
	_ok_btn: Laya.Box
	_img_ok: Laya.Image
	_lb_ok: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this._Image1,
			this._Image2,
			this._lb_title,
			this.contentText,
			this.goods_scroller,
			this.Content,
			this._close_btn,
			this._cancel_btn,
			this._img_cancel,
			this._lb_cancel,
			this._ok_btn,
			this._img_ok,
			this._lb_ok,
		]
			= this.GetChildrenByNames([

				"bg",
				"_Image1",
				"_Image2",
				"_lb_title",
				"contentText",
				"goods_scroller",
				"Content",
				"_close_btn",
				"_cancel_btn",
				"_img_cancel",
				"_lb_cancel",
				"_ok_btn",
				"_img_ok",
				"_lb_ok",
			])
	}
}
window["GoodsExpiredView"] = GoodsExpiredView