
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { FightingShowBigItem } from "../common/FightingShowBigItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MedalModel } from "../commonModel/MedalModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { MedalStrengthenAttrItem } from "./MedalStrengthenAttrItem"
import { MedalStrengthenItem } from "./MedalStrengthenItem"

export class MedalStrengthenView extends BaseView1 {
	Delete
	InitEvent
	LoadSuccess
	_btn
	_btn_one
	_close
	_gp_attr
	_gp_effect
	_gp_fight
	_gp_item
	_img_bg
	_img_bottom_bg
	_img_medal
	_img_medal_icon
	_img_medal_question
	_img_red
	_lb_lv
	click_bg_toClose
	close_callback
	initAttr
	initItem
	levelUpEffect
	medalNullGroup
	upEffect
	updateOneKeyRed
	updatePower
	updateProgress
	use_background

	_Image11: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Scroller1: Laya.Panel
	_Scroller2: Laya.Panel
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	_Image8: Laya.Image
	//let MedalStrengthenViewl = MedalStrengthenView



	public constructor(){
		super() 
		
		
		this.base_file = "medal"
		this.layout_file = "MedalStrengthenView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		let _model = MedalModel.GetInstance()
		let _local_Util = Util
		let local_resMgr = ResManager.GetInstance()
		let attr_list = []
		let item_list = []
		let stren_lv = 1
		let _goods_model = GoodsModel.GetInstance()
		let cost_cfg = null
		let lv_cfg = null
		let fightingShowBigItem = null
		let tweenIdList = []
		this.load_callback = () => {
			
			this.InitEvent()
			this.LoadSuccess()
		}
		
		this.close_callback = () => {
			this.Delete()
		}
		
		this.InitEvent = () => {
			Util.AddClickEvent(this._close,() => {
					this.Close()
				}
				, this, true)
			Util.AddClickEvent(this._btn,() => {
					let next_cfg = lv_cfg[stren_lv + 1]
					if (! next_cfg ) {
						Message.show("强化等级已满")
						return
					}
					if (_model.medalStrSelItem ) {
						_model.SendCost(_model.medalStrSelItem._data.goods_id)
					}else{
						Message.show("未选中物品")
					}
				}
				, this, true)
			Util.AddClickEvent(this._btn_one,() => {
					let next_cfg = lv_cfg[stren_lv + 1]
					if (! next_cfg ) {
						Message.show("强化等级已满")
						return
					}
					if (! this._img_red.visible ) {
						Message.show("拥有材料不足以升到下一等级")
						return
					}
					_model.OneKeySendCost(cost_cfg, next_cfg)
				}
				, this, true)
			this.BindEvent(_model, MedalModel.MEDAL_STRENGTHEN_LEVEL_CHANGE,() => {
					stren_lv = _model.medalData.stren_lv
					this.initAttr()
					this.updatePower()
					this.levelUpEffect()
				}
			)
			this.BindEvent(_model, MedalModel.MEDAL_STRENGTHEN_RETURN,() => {
					this.initItem()
					this.upEffect()
					this.updateProgress()
				}
			)
			this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT,(mType?, rType?) => {
					if (mType == ModuleType.MEDAL_STRENGTHEN && rType == 1 ) {
						this.updateOneKeyRed()
					}
				}
			)
			this.BindEvent(_goods_model, GoodsModel.CHANGE_BAG_LIST,() => {
					if (! this.use_delete_method ) {
						this.initItem()
						this.updateOneKeyRed()
					}
				}
			)
		}
		
		this.LoadSuccess = () => {
			local_resMgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconJpg("medal","uixz_040"))
			local_resMgr.SetOutsideImageSprite(this, this._img_bottom_bg, GameResPath.GetIcon("medal","uixz_041"))
			local_resMgr.SetImageSpriteTrans(this, this._img_medal_icon, GameResPath.GetIcon("medal","uixunzhang_010"))
			local_resMgr.SetImageSpriteTrans(this, this._img_medal_question, GameResPath.GetIcon("medal","uixunzhang_008"))
			cost_cfg = local_resMgr.GetGameConfigFromCache(this, "Medalstrencost", false)
			lv_cfg = local_resMgr.GetGameConfigFromCache(this, "Medalstrenlv", false)
			let config_medal = local_resMgr.GetGameConfigFromCache(this, "Medal", false)
			let _conf = _model.medalConfig(config_medal)
			this.medalNullGroup.SetActive ( _conf.id == 1)
			this._img_medal.SetActive (_conf.id != 1)
			if (this._img_medal.visible  ) {
				local_resMgr.SetImageSprite(this, this._img_medal,"medal_asset",_conf.large_image_id)
			}
			
			fightingShowBigItem =  new FightingShowBigItem(this._gp_fight)
			fightingShowBigItem.Load()
			stren_lv = _model.medalData.stren_lv
			this.updatePower()
			this.initAttr()
			this.initItem()
			this.updateProgress()
			this.updateOneKeyRed()
		}
		
		this.updateOneKeyRed = () => {
			this._img_red.visible = _model.CheckRedStatus(ModuleType.MEDAL_STRENGTHEN, 1 )
		}
		
		this.updatePower = () => {
			let power = _model.medalData.power
			this._gp_fight.visible = power > 0 
			if ((		this._gp_fight.visible) ) {
				fightingShowBigItem.Updatefighting(power)
			}
		}
		
		this.updateProgress = () => {
			let next_cfg = lv_cfg[stren_lv + 1]
			if (next_cfg ) {
				this._lb_lv.text = "Lv." + stren_lv + "  " + _model.medalData.stren_exp + "/" + next_cfg.exp
			}else{
				this._lb_lv.text = "Lv." + stren_lv + "  MAX/MAX"
			}
		}
		
		this.initAttr = () => {
			let now_cfg = lv_cfg[stren_lv]
			let next_cfg = lv_cfg[stren_lv + 1]
			let data = _model.BlendAttrCfg(now_cfg, next_cfg)
			let index = 0
			for (let _tmpi in data) {
				var info = data[_tmpi]
				let item = attr_list[index+1]
				if (! item ) {
					item =  new MedalStrengthenAttrItem(this._gp_attr)
					item.Load()
					table.insert(attr_list, item)
				}
				item.setData(info)
				index=index+1
			}
			
			
			for (let j = attr_list.length; j >= index+1; j -= 1) {
				let item = attr_list[j]
				this._gp_attr.DestroyImmediate(item)
				item.DeleteMe()
				item = null
				table.remove(attr_list,j)
			}
			// LayoutRebuilder(this._gp_attr)
		}
		
		this.initItem = () => {
			let data = []
			for (let key in cost_cfg) {
				
				let cost_info = cost_cfg[key]
				if (_model.medalLevId() >= cost_info.medal_lv ) {
					table.insert(data, cost_info)
				}
			}
			table.sort(data,(a?, b?) => {
					return b.color - a.color >0
				})
			let index = 1
			for (let _tmpi in data) {
				var info = data[_tmpi]
				let item = item_list[index]
				if (! item ) {
					item =  new MedalStrengthenItem(this._gp_item)
					item.Load()
					table.insert(item_list, item )
				}
				item.setData(info)
				let count = _goods_model.GetTypeGoodsNum(info.goods_id)
				if (count > 0 ) {
					if (_model.medalStrSelItem && _model.medalStrSelItem._data.goods_id != info.goods_id ) {
						_model.medalStrSelItem.setSelect(false)
					}
					_model.medalStrSelItem = item
					item.setSelect(true)
				}else{
					if (_model.medalStrSelItem && _model.medalStrSelItem._data.goods_id == info.goods_id ) {
						_model.medalStrSelItem.setSelect(false)
						_model.medalStrSelItem = null
					}
				}
				index=index+1
			}
			
			
			for (let j = item_list.length; j >= index+1; j -= 1) {
				let item = item_list[j]
				this._gp_item.DestroyImmediate(item)
				item.DeleteMe()
				item = null
				table.remove(attr_list,j)
			}
			// LayoutRebuilder(this._gp_item)
		}
		
		this.upEffect = () => {
			for (let i in tweenIdList) {
				var v = tweenIdList[i]
				SYTweenLite.Stop(v)
			}
			tweenIdList = []
			
			var fun =()=> {
				let vec=new Vector3(1,1,1)
				let tweenId = SYTweenLite.to(this,this._lb_lv,SYTweenLite.UiAnimationType.SCALE,vec,0.2)
				table.insert(tweenIdList,tweenId)
			}
			let vec2=new Vector3(1.2,1.2,1.2)
			let tweenId = SYTweenLite.to(this,this._lb_lv,SYTweenLite.UiAnimationType.SCALE,vec2,0.2,fun)
			table.insert(tweenIdList,tweenId)
		}
		
		this.levelUpEffect = () => {
			//ResManager.GetInstance().ClearUIEffect(this._gp_effect)
			this.ClearUIEffect(this._gp_effect)
			//ResManager.GetInstance().SetUIEffect2(this,"ui_shengjichenggong_glow", this._gp_effect)
		}
		
		this.Delete = () => {
			for (let i in attr_list) {
				var attr = attr_list[i]
				attr.DeleteMe()
				attr=null
			}
			attr_list = []
			
			for (let i in item_list) {
				var item = item_list[i]
				item.DeleteMe()
				item=null
			}
			item_list = []
			
			for (let i in tweenIdList) {
				var v = tweenIdList[i]
				SYTweenLite.Stop(v)
			}
			tweenIdList = []
			//ResManager.GetInstance().ClearUIEffect(this._gp_effect)
			this.ClearUIEffect(this._gp_effect)
			_model.medalStrSelItem = null
			
			if (fightingShowBigItem!=null ) {
				fightingShowBigItem.DeleteMe()
			}
			fightingShowBigItem = null
		}
	}

	public GetComponents() {
		[
			this._Image11,
			this._close,
			this._Image2,
			this._Image3,
			this._img_bg,
			this._img_bottom_bg,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Scroller1,
			this._gp_attr,
			this._Scroller2,
			this._gp_item,
			this._btn,
			this._Image1,
			this.labelDisplay1,
			this._btn_one,
			this._Image111,
			this.labelDisplay,
			this._img_medal,
			this._Image8,
			this._lb_lv,
			this._gp_fight,
			this.medalNullGroup,
			this._img_medal_icon,
			this._img_medal_question,
			this._img_red,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"_Image11",
				"_close",
				"_Image2",
				"_Image3",
				"_img_bg",
				"_img_bottom_bg",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Scroller1",
				"_gp_attr",
				"_Scroller2",
				"_gp_item",
				"_btn",
				"_Image1",
				"labelDisplay1",
				"_btn_one",
				"_Image111",
				"labelDisplay",
				"_img_medal",
				"_Image8",
				"_lb_lv",
				"_gp_fight",
				"medalNullGroup",
				"_img_medal_icon",
				"_img_medal_question",
				"_img_red",
				"_gp_effect",
			])
	}
}
window["MedalStrengthenView"] = MedalStrengthenView