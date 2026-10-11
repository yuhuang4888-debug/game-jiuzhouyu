import { Alert, Alert_Type } from "../alert/Alert"
import { Config } from "../common/Config"
import { EquipToolTips } from "../common/EquipToolTips"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { BagModel } from "../commonModel/BagModel"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MarketEvent, MarketModel } from "../commonModel/MarketModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalTimerQuest, Util } from "../util/Util"

export class EquipToolTipItem extends EquipToolTips {
	is_first
	use_background
	click_bg_toClose
	timer_id
	is_center
	destroy_imm
	closeflag
	background_alpha
	data_callbacks: Array<Function> = new Array<Function>();

	public constructor() {
		super()


		this.closeflag = false;
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.background_alpha = 0
		this.is_center = false

		this.load_callback = () => {
			this.is_first = true
			// ResManager.GetInstance().LoadFont(this, "equip_grade", this.grade, 20)
			this.LoadSuccess()
			this.InitEvent()

			if (this.data_callbacks.length > 0) {
				for (let callback of this.data_callbacks) {
					callback();
				}
				this.data_callbacks.length = 0;
			}

		}


	}

	public Close() {

		this.ClearTimer()
		this.closeflag = true
		BagModel.GetInstance().Fire(BagModel.CLOSE_CONTRAST)
		super.Close()
	}

	public customFunction() {

		if (this.is_first) {
			this.is_first = false
			return
		}
		//Laya.Tween.get(this.equip_conta):to({scaleX=1.1, scaleY=1.1}, 100, Laya.Ease.circIn).to({scaleX=1, scaleY=1}, 100, Laya.Ease.circOut)

		//this.timer_id = setTimeout(() => {
		//Laya.Tween.removeTweens(this.equip_conta)
		//}
		//, this, 200)
		//this.closeflag = false
	}

	public InitEvent() {
		let goods_model = GoodsModel.GetInstance();
		let market_model = MarketModel.GetInstance();
		let close_fun = () => {
			this.Close()
		}

		Util.AddClickEvent(this.closeBtn, close_fun, this, true)
		Util.AddClickEvent(this.replaceBtn, () => {
			if (!this.goods_vo) {
				return
			}
			let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods", false)
			let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, this.goods_vo.type_id, false, cfgs)
			let career = RoleManager.GetInstance().GetMainRoleVo().career
			if (cfg.career_id != 0 && cfg.career_id != career) {
				Message.show("装备职业类型不符合")
				return
			}
			let wear_info = EquipModel.GetInstance().GetWearEquipInfo(this.goods_vo.equip_type)
			if (wear_info && wear_info.goods_id == this.goods_vo.goods_id) {
				Message.show("无法替换当前已穿戴的装备")
				return
			}
			GoodsModel.GetInstance().CheckEquipNum(1, 0, () => {
				let showAlert
				if (wear_info) {
					let suitCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_pos2suittype")
					if (suitCfg) {
						if (suitCfg.type == 1) {
							let curLv = EquipModel.GetInstance().GetCurSuitLv(this.goods_vo.equip_type)
							if (curLv > 0) {
								if (wear_info.stage == this.goods_vo.stage) {
									showAlert = !EquipModel.GetInstance().EquipSuitCanUp(this.goods_vo, false, true)
								} else {
									showAlert = true
								}
							}
						} else {
							let cursLv = EquipModel.GetInstance().GetCurSuitsLv(this.goods_vo.equip_type)
							if (cursLv > 0) {
								showAlert = !EquipModel.GetInstance().JewelSuitCanUp(this.goods_vo, false, true)
							}
						}
					}
				}

				let func = () => {
					EquipModel.GetInstance().Fire(EquipEvent.REQUEST_PROTO, 15201, "l", this.goods_vo.goods_id)
					this.Close()
				}

				if (showAlert) {
					// Alert.Show("当前装备无法继承共鸣，是否拆解共鸣并继续穿戴？", Alert_Type.Two, func)
					func();
				} else {
					func()
				}

			}
			)
		}
			, this, true)

		let upShelfBtn_fun = () => {
			if (!this.goods_vo) {
				return
			}
			let goods_vo = this.goods_vo
			if (goods_vo["bind"]) {
				Message.show("绑定装备无法上架~")
				return
			}
			if (!goods_model.GetGoodsVoByGoodsId(goods_vo.goods_id)) {
				Message.show("物品不存在")
				market_model.Fire(MarketEvent.NEED_UPDATE_BAG)
			} else {
				market_model.Fire(MarketEvent.OPEN_VIEW, "MarketSellCtrlView", this.goods_vo)
			}
			this.Close()
		}

		Util.AddClickEvent(this.upShelfBtn, upShelfBtn_fun, this, true)


		this.BindEvent(BagModel.GetInstance(), BagModel.CLOSE_CONTRAST, () => {
			if (!this.closeflag) {
				this.Close()
			}
		}
		)
	}

	public ClearTimer() {

		if (this.timer_id) {
			clearTimeout(this.timer_id)
			this.timer_id = null
		}
	}

	public ExcuteCallback(callback) {
		if (this.is_loaded) {
			callback();
		}
		else {
			this.data_callbacks.push(callback);
		}
	}

}
window["EquipToolTipItem"] = EquipToolTipItem