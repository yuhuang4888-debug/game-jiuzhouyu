import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { SkillPassiveSubItem } from "./SkillPassiveSubItem"

export class SkillPassiveItem extends BaseItemRenderer {
	public WIDTH = 157
    public HEIGT = 190

	_img_1: Laya.Image
	_img_2: Laya.Image
	_Img_3: Laya.Image
	_gp_finger
	_img_icon
	_img_red
	_img_select
	_lb_lv
	_lb_name

	public static width = 177 - 19
	public static height = 200 + 6

	public constructor(parent) {
		super()
		this.base_file="role"
		this.layout_file="SkillPassiveItem"
		// this.skinName = "resource/game/role/exml/SkillPassiveItemExml.exml"

		// this.base_file = "role"
		// this.layout_file = "SkillPassiveItemExml"
		// this.load_callback = () => {

		// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 	this._lb_name.size  = 18
		// }

		// }
		this.Load()
	}

	public load_callback() {
		this.BindEvent(SkillUIModel.GetInstance(), SkillUIModel.UPDATE_RED_DOT, () => {
			this.dataChanged()
		}
		)
		// Util.AddClickEvent(this._img_icon,()=>{

		// },this,true)
	}

	public dataChanged() {
		if(super.dataChanged() && this.data){
			let icon = this.data.GetIcon && this.data.GetIcon()
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetSkillIconPath(icon != 0 && icon || this.data.id))//.id
			this._lb_lv.text = this.data.level.toString()
	
			let skill_name = this.data.getBasic("name")
			// if (this.data.id == BaseDungeonModel.MAIN_LINE_ADD_EXP_RADIO_SKILL_ID) {
			// 	skill_name = this.data.basic.name
			// }
			this._lb_name.text = skill_name
			let next_vo = this.data.getLevelVo(this.data.level + 1)
			if (next_vo) {
				let goods_info = next_vo.condition.goods
				let bool = goods_info && goods_info.length == 2
				if (bool) {
					let my_count = GoodsModel.GetInstance().GetTypeGoodsNum(goods_info[1])
					let count = Number(goods_info[2])
					this._img_red.visible = count <= my_count
				}
			} else {
				this._img_red.visible = false
			}
	
			this._img_select.visible = this.selected
	
			//StoryModel:GetInstance():DeleteFinger(this._gp_finger)
			if (this.data.id == SkillPassiveSubItem.guide_skill_id) {
				//StoryModel:GetInstance():CreateFinger(this, this._gp_finger, "UI", false, false, false, true, {text="快来看看刚才解锁的被动技能吧\n之后还有更多技能等你解锁~", direction=2})
			}
			this.scaleX = 0.8
			this.scaleY = 0.8
		}
	}

	public GetComponents() {
		[
			this._img_1,
			this._lb_name,
			this._img_2,
			this._img_icon,
			this._img_select,
			this._Img_3,
			this._lb_lv,
			this._img_red,
			this._gp_finger,
		]
			= this.GetChildrenByNames([

				"_img_1",
				"_lb_name",
				"_img_2",
				"_img_icon",
				"_img_select",
				"_Img_3",
				"_lb_lv",
				"_img_red",
				"_gp_finger",
			])
	}
}
window["SkillPassiveItem"] = SkillPassiveItem