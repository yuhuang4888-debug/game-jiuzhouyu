import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { HtmlColorTxt, SetHtmlStyle, Util } from "../util/Util"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { OpenFun } from "../common/OpenFun"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { VipModel } from "../commonModel/VipModel"


export class ActivityRechargeShowItem extends BaseItemRenderer {

	public WIDTH = 556
	public HEIGT = 164
	InitEvent
	_model: CustomActivityModel
	_ac_item: LoopScrowViewMgr
	public constructor(parent) {
		super()

		this.base_file = "activityRechargeShow"
		this.layout_file = "ActivityRechargeShowItem"
		this._model = CustomActivityModel.GetInstance()

		this.load_callback = () => {
			this.InitEvent()
			SetHtmlStyle(this._lb_title, { c: "#663915", f: 20, ww: false, w: 550 })
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("activityRechargeShow", "ui_czhl_04"))
		}

		this.InitEvent=()=>{
			Util.AddClickEvent(this._btn, () => {
				if(!this.data)return
				if(this.data.base_type!=0){
					CustomActivityModel.GetInstance().JumpAct(this.data.base_type,this.data.show_id)
				}else{
					//base_type==0 走openfunc
					OpenFun.OpenFunHandler(this.data.show_id)
				}
				VipModel.GetInstance().Fire(VipModel.CLOSE_SOME_VIEW)
			}, this, true)
		}

		this.Load()
	}

	public DeleteMe() {
		if (this._ac_item) {
			this._ac_item.DeleteMe()
			this._ac_item = null
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if (!super.dataChanged()) return

		if (this.data["is_faker"]) {
			this._btn.visible=this._img_bg.visible = this._list_reward.visible = this._lb_title.visible = false
		} else {
			this._btn.visible=this._img_bg.visible = this._list_reward.visible = this._lb_title.visible = true
			let item_name = HtmlColorTxt(`【${this.data.item_name}】`, '"#fe1a1a"')
			this._lb_title.innerHTML = `${item_name}${this.data.desc}`
			this.UpdateItems(this.data.reward_list)
		}
	}


	public UpdateItems(list?) {
		if (!this._ac_item) {
			this._ac_item = new LoopScrowViewMgr()
			this._ac_item.SetData(this._list_reward, CommonRewardItem, list, LoopScrCon.Horizontal, 1)
		} else {
			this._ac_item.replaceAll(list)
		}
	}

_img_bg:Laya.Image
_list_reward:Laya.List
_lb_title:Laya.HTMLDivElement
_btn:Laya.Box
_Image1:Laya.Image
labelDisplay:Laya.Label
public GetComponents() {
[
this._img_bg,
this._list_reward,
this._lb_title,
this._btn,
this._Image1,
this.labelDisplay,
]
 = this.GetChildrenByNames([

"_img_bg",
"_list_reward",
"_lb_title",
"_btn",
"_Image1",
"labelDisplay",
])
}
}
 window["ActivityRechargeShowItem"]= ActivityRechargeShowItem