import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { BaseAwardItem } from "./BaseAwardItem"
import { BaseItem1 } from "./BaseItem1"
import { BaseItemRenderer } from "./BaseItemRenderer"
import { CongratulationRareView } from "./CongratulationRareView"
import { EquipmentItem } from "./EquipmentItem"
import { EventName } from "./EventName"
import { ResManager } from "./ResManager"
import { UIToolTipMgr } from "./UIToolTipMgr"

export class CongratulationObtainItemVo {
	/**this.data[0] type_id*/
	type_id: number
	/**this.data[1] 物品数量*/
	goods_num: number
	/**this.data[2] 是否锁定*/
	lock: number
	/**this.data goods_id*/
	goods_id: number
	/**this.data[4] 是否首次出现，首次出现会播放一段动画，list滚动重复出现就不播放动画*/
	is_first_show: boolean
	/**this.data[5] 计数用，从第N个开始播放往下滚的动画 */
	count: number
	/**this.data[6] 额外奖励 双倍==1  */
	double: number
	/**this.data[7] 周卡奖励 */
	is_zhouka: boolean
	/**this.data[8] 月卡奖励 */
	is_yueka: boolean
	/**this.data[9] 淡出动画持续时间 毫秒 */
	anim_time: number
	/**是否有传闻*/
	is_tv:number
}
window["CongratulationObtainItemVo"] = CongratulationObtainItemVo

// TypeScript file
export class CongratulationObtainItem extends BaseItemRenderer {
	public gp_item: Laya.Box
	public gp_effect: Laya.Box
	public gp_award: Laya.Box
	public award_item: EquipmentItem
	public _img_1: Laya.Image
	public is_show_animation
	public

	_img_zhouka //周卡
	_img_yueka  //月卡
	_img_double //额外
	constructor(parent?) {
		super()
		let self = this
		self.base_file = "common";
		self.layout_file = "CongratulationObtainItem";
		this.HEIGT = 120
		this.WIDTH = 115
		this.is_show_animation = true //是否播放动画和特效
		this._img_zhouka = null
		this._img_yueka = null
		this._img_double = null
		if(PlatformManager.IsEyouPlatform()){
			this.HEIGT = 140
		}

		this.Load()
	}
	public load_callback() {
		this.BindEvent(GlobalEventSystem, EventName.GET_GOODS_VIEW_STOP_ANIMATION, () => {
			this.is_show_animation = false
		})
	}

	public dataChanged() {
		if (!super.dataChanged()) return

		let data_vo: CongratulationObtainItemVo = this.data
		this.PlayAnima(data_vo)
		this.SetData(data_vo, 95)
	}
	
	// public PlayAnima(data_vo) {
	// 	if (this.is_show_animation) {
	// 		if (data_vo.is_first_show) {//15个之后，重新调整item的延时
	// 			let temp_num = data_vo.count
	// 			if (data_vo.count > 15) {
	// 				temp_num = data_vo.count % 5
	// 				if (temp_num == 0) {
	// 					temp_num = 5
	// 				}
	// 			}
	// 			Laya.timer.clearAll(this)
	// 			Laya.Tween.clearAll(this.gp_award)
	// 			Laya.timer.once(data_vo.anim_time * temp_num, this, () => {
	// 				if (this.use_delete_method) return
	// 				this.base_item.AddUIEffect("UI_partner_skillicon_02", this.gp_effect, null, 10, false, undefined, undefined, undefined, undefined, undefined, undefined, undefined, false)
	// 				Laya.timer.clearAll(this)
	// 			})
	// 			this.gp_award.scaleX = 0
	// 			this.gp_award.scaleY = 0
	// 			this.gp_award.alpha = 0
	// 			Laya.Tween.to(this.gp_award, { scaleX: 1, scaleY: 1, alpha: 1 }, data_vo.anim_time, null, Laya.Handler.create(this, () => {
	// 				Laya.Tween.clearAll(this.gp_award)
	// 				if(data_vo.is_tv == 1){
	// 					let view = new CongratulationRareView()
	// 					let reward = [data_vo.type_id,data_vo.goods_num]
	// 					view.SetData(reward, 2)
	// 					view.Open()
	// 				}
	// 				GlobalEventSystem.Fire(EventName.ADD_LIST_ITEM)
	// 			}), data_vo.anim_time * temp_num)
	// 			data_vo.is_first_show = false
	// 		}
	// 	}
	// }

	public PlayAnima(data_vo) {
		if (this.is_show_animation) {
			if (data_vo.is_first_show) {//15个之后，重新调整item的延时
				let temp_num = data_vo.count
				if (data_vo.count > 15) {
					temp_num = data_vo.count % 5
					if (temp_num == 0) {
						temp_num = 5
					}
				}
				
				Laya.timer.clearAll(this)
				Laya.Tween.clearAll(this.gp_award)
				Laya.timer.once(100, this, () => {
					if (this.use_delete_method) return
					this.base_item.ClearUIEffect(this.gp_effect)
					this.base_item.AddUIEffect("UI_partner_skillicon_02", this.gp_effect, null, 10, false, undefined, undefined, undefined, undefined, undefined, undefined, undefined, false)
					Laya.timer.clearAll(this)
				})
				this.gp_award.scaleX = 0
				this.gp_award.scaleY = 0
				this.gp_award.alpha = 0
				Laya.Tween.to(this.gp_award, { scaleX: 1, scaleY: 1, alpha: 1 }, 100, null, Laya.Handler.create(this, () => {
					Laya.Tween.clearAll(this.gp_award)
					if(data_vo.is_tv == 1){
						let view = new CongratulationRareView()
						let reward = [data_vo.type_id,data_vo.goods_num]
						view.SetData(reward, 1)
						view.Open()
					}else{
						GlobalEventSystem.Fire(EventName.ADD_LIST_ITEM)
					}
				}),50)
				data_vo.is_first_show = false
			}
		}
	}
	public AddIcon(data_vo){
		this.HideChilds()
		if (data_vo.double) {
			this.AddAdditionalImg()
		}
		if (data_vo.is_zhouka) {
			this.AddWeeklyCardImg()
		}
		if (data_vo.is_yueka) {
			this.AddMonthCardImg()
		}
	}

	public SetData(data_vo: CongratulationObtainItemVo, item_size?) {
		if (!this.award_item) {
			this.award_item = new EquipmentItem(this.gp_award)
			this.award_item.Load()
			this.award_item.ExcuteCallback(() => {
				this.AddIcon(data_vo)
			})
		}

		if(this.award_item.is_loaded){
			this.AddIcon(data_vo)
		}


		this.award_item.SetItemSize(item_size, item_size)
		this.award_item.SetData(data_vo.type_id, data_vo.goods_num, data_vo.lock, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, true)
		if (data_vo.goods_id) {
			let goodsVo = GoodsModel.GetInstance().GetGoodsVoByGoodsId(data_vo.goods_id)
			if (goodsVo) {
				/*
				this.award_item.SetClickCallBack(() => {
					if (goodsVo.type == 10) {
						UIToolTipMgr.GetInstance().AppendEquipTips(type_id, null, null, goodsVo, null, { 1})
					} else if (goodsVo.type == UnrealModel.goods_type) {
						UIToolTipMgr.GetInstance().AppendUnrealTips(type_id, goodsVo, null, { UnrealToolTips.Btn.close })
					} else if (goodsVo.type == HolySealModel.GOODS_TYPE) {
						UIToolTipMgr.GetInstance().AppendHolySealTips(type_id, null, null, { HolySealToolTips.Btn.close })
					} else if (goodsVo.type == 39) {
						UIToolTipMgr.GetInstance().AppendGodBeastTips(goodsVo.type_id, null, null, goodsVo)
					} else if (goodsVo.type == 65) {
						UIToolTipMgr.GetInstance().AddBabyEquipToolTips(goodsVo.type_id, null, null, goodsVo)
					} else if (goodsVo.type == GodBefallDefine.EQUIP_TYPE) {
						UIToolTipMgr.GetInstance().AppendGodEquipTips(goodsVo.type_id, goodsVo)
					} else if (goodsVo.type == RevelationModel.GOODS_TYPE) {
						UIToolTipMgr.GetInstance().AppendRevelationTooltips(goodsVo.type_id, goodsVo)
					} else if (goodsVo.type == longlangModel.GOODS_TYPE) {
						UIToolTipMgr.GetInstance().AppendLongLangToolTips(goodsVo.type_id, goodsVo, null, { LonglangToolTips.Btn.close })
					} else if (goodsVo.type == starEquipModel.GOODS_TYPE && goodsVo.subtype < 11) {
						UIToolTipMgr.GetInstance().AppendStarEquipToolTips(goodsVo.type_id, goodsVo, null, { StarEquipToolTip.Btn.close })
					} else if (goodsVo.type == GodCourtModel.GoodsType && goodsVo.subtype < 17) {
						UIToolTipMgr.GetInstance().AppendGodCourtTips(goodsVo.type_id, goodsVo, null, { GodCourtTooltip.Btn.close })
					} else {
						UIToolTipMgr.GetInstance().AppendGoodsTips(type_id, null, null, goodsVo, null, null, this)
					}
				}
				)
				if (goodsVo.type == 26 && goodsVo.sub_type != 99) {
					this.award_item.SetStrengthen(goodsVo.level)
				}
				if (goodsVo.type == 65) {
					this.award_item.SetSkillImg(goodsVo.skill_id > 0)
				}
				*/
			}
		}
	}

	public PlayAnimation(scale, time_add) {
		// if (!this.gp_award) return
		// // this.gp_award_tween=Laya.Tween.to(this.gp_award,{ scaleX: scale, scaleY: scale, alpha: 0 }, 0).wait(time_add / 3).to({ scaleX: 1, scaleY: 1, alpha: 1 }, time_add / 2).call(() => {

		// // })
		// this.base_item.AddUIEffect("UI_partner_skillicon_02", this.gp_effect, null, 10, false, undefined, undefined)
		// Laya.Tween.to(this.gp_award, { scaleX: scale, scaleY: scale, alpha: 0 }, 0).to(this.gp_award, { scaleX: 1, scaleY: 1, alpha: 1 }, time_add / 2, null, null, time_add / 3)
		// // egret.Tween.get(this.gp_award).to({ alpha: 0 }, 0).wait(time_add / 3).to({ alpha: 1 }, time_add / 2).call(() => {/* egret.Tween.removeTweens(this.gp_award)*/ })
	}

	public AddEffect(scale) {
		this.base_item.AddUIEffect("ui_exposure_glow", this.gp_effect, null, scale, false)

	}

	public SetAlpha(num) {
		// this.gp_award.alpha = num
	}
	public DeleteMe() {
		this.UnBindEvents()
		if (this.gp_award)
			Laya.Tween.clearAll(this.gp_award)

		if (this._img_zhouka) {
			this._img_zhouka.removeSelf()
			this._img_zhouka = null
		}

		if (this._img_double) {
			this._img_double.removeSelf()
			this._img_double = null
		}

		if (this._img_yueka) {
			this._img_yueka.removeSelf()
			this._img_yueka = null
		}
		if (this.award_item) {
			this.award_item.DeleteMe()
		}
		this.award_item = null
		super.DeleteMe()
	}

	//添加额外图标
	public AddAdditionalImg() {
		if (!this._img_double) {
			this._img_double = new Laya.Image()
			ResManager.GetInstance().SetImageSprite(this, this._img_double, "common", "common_4", true)
			this.award_item.ExcuteCallback(() => {
				this.award_item.click_group.addChild(this._img_double)
			})
			this._img_double.x = this._img_double.y = 7
			this._img_double.scaleX = this._img_double.scaleY = 1.3
		}
		this._img_double.visible = true
	}

	//添加周卡图标
	public AddWeeklyCardImg() {
		if (!this._img_zhouka) {
			this._img_zhouka = new Laya.Image()
			ResManager.GetInstance().SetImageSprite(this.base_item, this._img_zhouka, "common2", "zhouka")
			this.award_item.ExcuteCallback(() => {
				this.award_item.click_group.addChild(this._img_zhouka)
			})
			this._img_zhouka.x = 0
			this._img_zhouka.y = 0
			this._img_zhouka.scaleX = this._img_zhouka.scaleY = 1.5
		}
		this._img_zhouka.visible = true
	}


	/**隐藏额外、周卡、月卡标志 */
	public HideChilds() {
		if (this._img_zhouka) this._img_zhouka.visible = false
		if (this._img_double) this._img_double.visible = false
		if (this._img_yueka) this._img_yueka.visible = false
	}


	public AddMonthCardImg() {
		if (!this._img_yueka) {
			this._img_yueka = new Laya.Image()
			ResManager.GetInstance().SetImageSprite(this.base_item, this._img_yueka, "common2", "yueka")
			this.award_item.ExcuteCallback(() => {
				this.award_item.click_group.addChild(this._img_yueka)
			})
			this._img_yueka.x = 0
			this._img_yueka.y = 0
			this._img_yueka.scaleX = this._img_yueka.scaleY = 1.5
		}
		this._img_yueka.visible = false

	}


	public GetComponents() {
		[
			this.gp_item,
			this.gp_award,
			this.gp_effect,
			this._img_1
		]
			= this.GetChildrenByNames([

				"gp_item",
				"gp_award",
				"gp_effect",
				"_img_1"
			])
	}
}
window["CongratulationObtainItem"] = CongratulationObtainItem