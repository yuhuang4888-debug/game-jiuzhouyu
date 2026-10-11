import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { SceneManager } from "../scene/SceneManager"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { Alert, Alert_Type } from "../alert/Alert"

export class BossRebornView extends BaseView1 {
	InitEvent
	InitView
	Open

	bossInfo
	costItem

	public constructor() {
		super()
		this.base_file = "suitboss"
		this.layout_file = "BossRebornView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.show_open_movie = true
		this.use_background = true
		this.background_alpha = 0

		let secret_boss_model = BossSceneManager.GetInstance()

		this.load_callback = () => {
			this._lb_tips.style.fontSize = 24
			this._lb_tips.style.color = "#663915"
			this._lb_tips.style.wordWrap = false
			this.InitView()
			this.InitEvent()
		}

		this.close_callback = () => {
			if (this.costItem) {
				this.costItem.DeleteMe()
				this.costItem = null
			}
		}
		this.InitView = () => {
			if (this.bossInfo && this.is_loaded) {
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_boss_type
				let rebornCost = BossModel.GetInstance().GetBossRebornCost(this.bossInfo.boss_type, cfg)
				if (!rebornCost) {
					this.Close()
					return
				}
				if (!this.costItem) {
					this.costItem = new BaseAwardItem(this._gp_cost)
					this.costItem.Load()
					this.costItem.SetItemSize(80, 80)
				}
				this.costItem.SetData(rebornCost[1])
				this.costItem.ExcuteCallback(() => {
					let myhave = GoodsModel.GetInstance().GetTypeGoodsNum(rebornCost[1])
					this.costItem.ForceSetNumber(myhave)
				}
				)
				let goodsBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(rebornCost[1])
				if (goodsBasic) {
					this._lb_tips.innerHTML = Util.StrToHTML("是否使用" + goodsBasic.goods_name + "复活<font color='#a376ff'>Lv." + this.bossInfo.lv + this.bossInfo.boss_name + "</font>")
					this.CallLater(() => {
						this._lb_tips.event(Laya.Event.RESIZE)
					})
					this._lb_cost.text = "消耗：" + goodsBasic.goods_name + "x" + rebornCost[2]
				}
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_cancel, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._btn_go, () => {
				if (!this.bossInfo) {
					return
				}
				let rebornFunc = () => {
					if (SceneManager.GetInstance().IsHolyBossScene()) {
						BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 47035, 10, this.bossInfo.boss_id)
					} else {
						BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 46041, this.bossInfo.boss_type, this.bossInfo.boss_id)
					}
				}

				if (secret_boss_model.JudgeTired(false)) {
					rebornFunc()
				} else {
					Alert.Show("<font color='#ff4f50'>当前体力值不足，无法对首领再造成伤害</font><br>是否确定继续使用", Alert_Type.Two, rebornFunc, null, null, null, null, null, null, null, true)
				}
				this.Close()
			}
				, this, true)
		}

		this.Open = (...new_args) => {
			let parms = new_args
			if (parms) {
				this.bossInfo = parms[0]
				this.InitView()
			}
			super.Open()
		}
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_gp_title: Laya.Image
	_lb_title: Laya.Label
	_btn_close: Laya.Image
	_btn_cancel: Laya.Image
	_lb_cancel: Laya.Label
	_btn_go: Laya.Image
	_lb_go: Laya.Label
	_gp_tips: Laya.HBox
	_lb_tips: Laya.HTMLDivElement
	_lb_cost: Laya.Label
	_gp_cost: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._gp_title,
			this._lb_title,
			this._btn_close,
			this._btn_cancel,
			this._lb_cancel,
			this._btn_go,
			this._lb_go,
			this._gp_tips,
			this._lb_tips,
			this._lb_cost,
			this._gp_cost,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_bg2",
				"_gp_title",
				"_lb_title",
				"_btn_close",
				"_btn_cancel",
				"_lb_cancel",
				"_btn_go",
				"_lb_go",
				"_gp_tips",
				"_lb_tips",
				"_lb_cost",
				"_gp_cost",
			])
	}
}
window["BossRebornView"] = BossRebornView