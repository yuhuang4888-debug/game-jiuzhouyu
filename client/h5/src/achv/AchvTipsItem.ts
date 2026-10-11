import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { achvModel } from "../commonModel/achvModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class AchvTipsItem extends BaseItem1 {
bg
cfg
clickInfo
data
desLb
goBtn
itemList
labelDisplay
model
nameLb
preload_server_config
rewardGp
subId
tabId
_Scroller1:Laya.Panel
Content:Laya.HBox
_Image1:Laya.Image

public constructor(parent?){
super(parent) 
	
	this.model = achvModel.GetInstance();
	this.clickInfo = [];
	this.base_file = "achv"
	this.layout_file = "AchvTipsItem"
	this.layer_value = Enum_UILayer.Activity
	this.load_callback = () => {
		
		this.InitEvent()
		//this.SetUISortingOrder(this.gameObject)
		//this.AddUIZDepth()
		if (PlatformManager.IsEyouEnPlatform ) {
			this.desLb.size  = 18
		}
	}

	this.preload_server_config = {"config_achievement":false}
}

public InitEvent(){ 
	
	Util.AddClickEvent(this.goBtn,() => {
			if (this.data ) {
				if (RoleManager.GetInstance().GetMainRoleVo().level >= 150 ) {
					this.model.Fire(achvModel.REQUEST_PROTO, 40905, "i", this.data.id)
				}else{
					this.model.Fire(achvModel.OP_V, "AchvEnterView", 0, this.tabId, this.subId)
				}
			}
			this.SetVisible(false)
			this.DeleteMe()
		}
		, this, true)
	ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("achv","ui_notice_16"))
}

public SetData(data?){ 
	
	this.data = data
	if (this.data ) {
		let achievement_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_achievement", false)
		this.cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_achievement.name, this.data.id, false, achievement_cfg)
		if (this.cfg ) {
			// [ts2lua]this.model.AcCategoryCfg下标访问可能不正确
			let tabCfg = this.model.AcCategoryCfg[this.cfg.category]
			if (tabCfg ) {
				this.nameLb.text = tabCfg.name
				this.tabId = tabCfg.type
				this.subId = tabCfg.subtype
			}
			this.desLb.text = this.cfg.desc
			let diamondReward = ErlangParser.GetInstance().Parse(this.cfg.reward)
			let pointReward = [0, 40, this.cfg.star]
			if (diamondReward ) {
				table.unshift(diamondReward, pointReward)
			}else{
				diamondReward = pointReward
			}
			if (diamondReward ) {
				if (! this.itemList ) {
					this.itemList = []
				}
				for (let _tmpi in diamondReward) {
					var vo = diamondReward[_tmpi]
					// let goodsInfo = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
					// let goodsbasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goodsInfo[0])
					let [goods_id,lcok] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
					let goodsbasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id)
					let item =  new EquipmentItem(this.Content)
					item.Load()
					item.SetItemSize(77, 77)
					item.SetData(goodsbasic.type_id, vo[2])
					table.insert(this.itemList, item)
				}
			}
		}
	}
	if (RoleManager.GetInstance().GetMainRoleVo().level >= 150 ) {
		// this.goBtn.label = "领取"
		this.labelDisplay.text = "领取"
	}
}

public DeleteMe(){ 
	
	if (this.itemList ) {
		for (let _tmpi in this.itemList) {
			var vo = this.itemList[_tmpi]
			vo.DeleteMe()
		}
		this.itemList = null
	}
	super.DeleteMe()
}

	public GetComponents() {
		[
			this.bg,
			this.nameLb,
			this.desLb,
			this._Scroller1,
			this.Content,
			this.goBtn,
			this._Image1,
			this.labelDisplay,
		]
			= this.GetChildrenByNames([

				"bg",
				"nameLb",
				"desLb",
				"_Scroller1",
				"Content",
				"goBtn",
				"_Image1",
				"labelDisplay",
			])
	}
}
window["AchvTipsItem"] = AchvTipsItem