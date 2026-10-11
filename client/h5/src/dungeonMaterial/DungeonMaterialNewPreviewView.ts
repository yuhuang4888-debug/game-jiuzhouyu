
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { Config } from "../common/Config"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { RoleManager } from "../commonModel/RoleManager"
import { HtmlColorTxt, SetHtmlCenter, SetHtmlStyle, TransformLevel, Util } from "../util/Util"
import { VipModel } from "../commonModel/VipModel"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { WeekCardModel } from "../commonModel/WeekCardModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"


export class DungeonMaterialNewPreviewView extends BaseView1 {

	InitEvent
	LoadSuccess

	SetReward
	UpdateView
	AddImage

	dungeon_data_ = null
	dungeon_model: BaseDungeonModel
	resmgr: ResManager
	dun_data
	reward_item_list_


	public constructor(parent?) {
		super()
		this.base_file = "dungeonMaterial"
		this.layout_file = "DungeonMaterialNewPreviewView"
		this.layer_value =  Enum_UILayer.UI
		this.use_background=true
		this.is_center=true
		this.change_scene_close=true
		this.dungeon_data_ = null
		this.dungeon_model = BaseDungeonModel.GetInstance()
		this.resmgr = ResManager.GetInstance()
		this.destroy_imm=true
		this.click_bg_toClose=true
		this.dun_data = null
		this.load_callback = () => {
			this._scroll_reward.hScrollBarSkin = ""
			SetHtmlStyle(this._text_fight, { c: "#663915", f: 22, w: 254, ww: false })
			this.InitEvent()

			this.dataChanged()
		}


		this.InitEvent = () => {
			Util.AddClickEvent(this._img_close, ()=>{
				this.Close()
			}, this, true)
		}


		this.AddImage = (i, item, dun_type) => {
			if (dun_type == 18 && i == 1)
				return
			if (item) {
				let img = new Laya.Image()
				ResManager.GetInstance().SetImageSprite(this, img, "dungeonMaterial", "uifnpj_012ew", true)
				item.display_obj.addChild(img)
				img.scaleX = img.scaleY = 1.3
				img.x = 0
				img.y = 0

			}
		}


		this.SetReward = () => {
			let goods_model = GoodsModel.GetInstance()
			let reward_list = []
			if (this.dun_data.reward) {
				reward_list = JSON.parse(this.dun_data.reward)||[]
			}
			if (!this.reward_item_list_) {
				this.reward_item_list_ = []
			}

			for (let i = 0; i < this.reward_item_list_.length; i++) {
				this.reward_item_list_[i].SetVisible(false)
			}

			let size = 89
			for (let p=0;p<reward_list.length;p++) {

				let vo = reward_list[p]
				let item: BaseAwardItem = this.reward_item_list_[p]
				if (!item) {
					item = new BaseAwardItem(this.Content)
					this.reward_item_list_[p] = item
					item.SetItemSize(size, size)
					item.Load()
				}
				item.ExcuteCallback(() => {
					if (WeekCardModel.GetInstance().GetWeekCardData().is_activity == 1)
						this.AddImage(p, item, this.dun_data.type)
				})
				let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
				let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, vo[2], lock)
					item.SetVisible(true)
				}
			}

			if(reward_list.length>3){
				this.Content.x=0
			}else{
				this.Content.x=(this._scroll_reward.width-reward_list.length*size)/2
			}
			
		}

		
		this.close_callback=()=>{
			if (this.reward_item_list_) {
				for (let i = 0; i < this.reward_item_list_.length; i++) {
					this.reward_item_list_[i].DeleteMe()
					this.reward_item_list_[i] = null
				}
				this.reward_item_list_ = null
			}
		}

	}

	// { dun_type: dun_type, index: material_type_dic_[dun_type] }
	public dataChanged() {
		if(!this.dun_data)return
		let roleManager = RoleManager.GetInstance()

		//开启等级
		this._text_fight.innerHTML=`${TransformLevel(Number(this.dun_data.level))}级`


		//当前难度
		let dun_name: String = this.dun_data.name
		let name2 = dun_name.slice(dun_name.indexOf("(") + 1, dun_name.length - 1)
		this._text_3.text = name2 
		this._text_3.color = this.dungeon_model.GetTextColor(this.dun_data.dun_id,false,false)


		//设置奖励
		this.SetReward()

	}

	
	public Open(...new_args) {

		this.dun_data = new_args[0]
		super.Open()
	}


	public DeleteMe() {
		super.DeleteMe()
	}


_bg:Laya.Image
_img_h_bg:Laya.Image
_img_close:Laya.Image
_text_1:Laya.Text
_text_2:Laya.Text
_text_3:Laya.Text
_text_fight:Laya.HTMLDivElement
_text_4:Laya.Text
_scroll_reward:Laya.Panel
Content:Laya.HBox
public GetComponents() {
[
this._bg,
this._img_h_bg,
this._img_close,
this._text_1,
this._text_2,
this._text_3,
this._text_fight,
this._text_4,
this._scroll_reward,
this.Content,
]
 = this.GetChildrenByNames([

"_bg",
"_img_h_bg",
"_img_close",
"_text_1",
"_text_2",
"_text_3",
"_text_fight",
"_text_4",
"_scroll_reward",
"Content",
])
}
}
 window["DungeonMaterialNewPreviewView"]= DungeonMaterialNewPreviewView