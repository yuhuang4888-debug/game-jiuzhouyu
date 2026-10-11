import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { GameError } from "../util/GameError"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, SetAnchoredPosition, SetAnchoredPositionX, SetAnchoredPositionY, SetSizeDeltaX } from "../util/Util"
import { BossModel } from "../commonModel/BossModel"
import { EquipmentItem } from "../common/EquipmentItem"

export class BossFieldRewardItem extends BaseItem1 {

	effect
	time_id
	res_mgr: ResManager
	model: BossModel
	item_: EquipmentItem
	data
	need_refrsh
	public constructor(parent) {
		super(parent)
		this.base_file = "bossField"
		this.layout_file = "BossFieldRewardItem"
		this.res_mgr = ResManager.GetInstance()
		this.model = BossModel.GetInstance()
		this.need_refrsh = false
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this,this._img_tag,GameResPath.GetIconOtherPath("bossField","ui_chief_33"))//
			if (this.need_refrsh) {
				this.UpdateView()
			}
		}
	}

	public UpdateView() {
		if (!this.data) return
		if (!this.item_) {
			this.item_ = new EquipmentItem(this._box_reward)
			this.item_.SetUseMask(true)
			this.item_.Load()
			this.item_.SetItemSize(80, 80)
		}
		this.item_.SetData(this.data.type_id, this.data.count, this.data.lock)
		this._img_tag.visible = this.data.is_up == 1
	}

	public SetData(data) {
		this.data = data
		if (this.is_loaded) {
			this.need_refrsh = false
			this.UpdateView()
		} else {
			this.need_refrsh = true
		}
	}


	public DeleteMe() {
		if(this.item_){
			this.item_.DeleteMe()
			this.item_=null
		}
		super.DeleteMe()
	}


	_box_reward: Laya.Box
	_img_tag: Laya.Image
	public GetComponents() {
		[
			this._box_reward,
			this._img_tag,
		]
			= this.GetChildrenByNames([

				"_box_reward",
				"_img_tag",
			])
	}
}
window["BossFieldRewardItem"] = BossFieldRewardItem