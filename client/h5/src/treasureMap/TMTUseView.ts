import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { TreasureMapModel } from "../commonModel/TreasureMapModel"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { GlobalTimerQuest, Util } from "../util/Util"

export class TMTUseView extends BaseView1 {
	DestroyCallback
	InitEvnet
	InitView
	OnTimer
	Open
	UseGoods
	destroy_callback
	destroy_imm

	public constructor() {
		super()


		this.base_file = "treasureMap"
		this.layout_file = "TMTUseView"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		let item = null
		let timer = null
		let time = 10
		let goods_vo = null
		let local_TreasureMapModel = TreasureMapModel
		this.load_callback = () => {
			this.display_obj.centerX = 150;
			this.display_obj.centerY = 150;
			this.InitEvnet()
			this.InitView()
		}

		this.destroy_callback = () => {
			this.DestroyCallback()
		}

		this.InitEvnet = () => {
			Util.AddClickEvent(this._btn_use, () => {
				this.UseGoods()
			}
				, this, true)
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}
				, this, true)
		}

		this.InitView = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconOtherPath("treasureMap", "uity_016bb"))
			if (goods_vo) {
				if (!item) {
					item = new BaseAwardItem(this._gp_item)
					item.Load()
				}
				item.ExcuteCallback(() => {
					item.SetData(goods_vo.type_id, goods_vo.goods_num)
				}
				)
				this._lb_name.text = goods_vo.goods_name;
				this._lb_name.color = ColorUtil.GetColorDark(goods_vo.color, false);
				if (!timer) {
					let timeFunc = () => {
						this.OnTimer()
					}
					timer = GlobalTimerQuest.AddPeriodQuest(timeFunc, 1, -1)
				}
				this.OnTimer()
			}
		}

		this.OnTimer = () => {
			if (time > 0) {
				this._lb_time.text = time + "秒后自动使用下一张"
				time = time - 1
			} else {
				this.UseGoods()
			}
			this.UseGoods = () => {
				if (SceneManager.GetInstance().IsFieldScene()) {
					if (goods_vo) {
						local_TreasureMapModel.GetInstance().Fire(local_TreasureMapModel.TM_USE_GOODS, goods_vo, false)
					}
				} else {
					Message.show("当前场景不能使用")
				}
				this.Close()
			}


		}

		this.DestroyCallback = () => {
			time = 10
			if (timer) {
				GlobalTimerQuest.CancelQuest(timer)
				timer = null
			}
			if (item) {
				item.DeleteMe()
				item = null
			}
		}

		this.Open = (...new_args) => {
			let parms = new_args
			goods_vo = parms[0]
			super.Open()
		}


	}


	_Image11: Laya.Image
	_Image2: Laya.Image
	_img_bg: Laya.Image
	_Label1: Laya.Label
	_gp_item: Laya.Box
	_Label2: Laya.Label
	_Image3: Laya.Image
	_lb_name: Laya.Label
	_lb_time: Laya.Label
	_btn_use: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_img_close: Laya.Image
	public GetComponents() {
		[
			this._Image11,
			this._Image2,
			this._img_bg,
			this._Label1,
			this._gp_item,
			this._Label2,
			this._Image3,
			this._lb_name,
			this._lb_time,
			this._btn_use,
			this._Image1,
			this.labelDisplay,
			this._img_close,
		]
			= this.GetChildrenByNames([

				"_Image11",
				"_Image2",
				"_img_bg",
				"_Label1",
				"_gp_item",
				"_Label2",
				"_Image3",
				"_lb_name",
				"_lb_time",
				"_btn_use",
				"_Image1",
				"labelDisplay",
				"_img_close",
			])
	}
}
window["TMTUseView"] = TMTUseView