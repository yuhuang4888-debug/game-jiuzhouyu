import { BaseItem1 } from "../common/BaseItem1";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { DemonModel } from "../commonModel/DemonModel";
import { DemonTalentItem } from "../demon/DemonTalentItem";
import { SkillVo } from "../skill/SkillVo";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";


export class PlayerMessageDemonTalentItem extends BaseItem1 {
	item_bg: Laya.Image
	_icon_mask: Laya.Image
	_icon: Laya.Image
	_add: Laya.Image
	_lock: Laya.Box
	Image: Laya.Image
	Image1: Laya.Image
	_red: Laya.Image
	_tips: Laya.Image
	_lv: Laya.Label


	demon_id
	demon_model: DemonModel
	has_activated
	has_learned
	is_goods_data
	need_refresh_data
	show_red
	slot
	unlock_cond
	unlock_state
	res_mgr
	data  //培养数据
	info //基本信息
	scalex
    scaley
	public constructor(parent?) {
		super(parent)

		this.base_file = "demon"
		this.layout_file = "DemonTalentItem2"
		this.demon_model = DemonModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.is_goods_data = false
		this.show_red = false

		this.load_callback = () => {
			this.display_obj.scaleX = 0.8
            this.display_obj.scaleY = 0.8
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public LoadSuccess() {

		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	public SetData(data?, demon_id?,info?) {
		this.demon_id = demon_id
		this.data = data
		this.info = info
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this.item_bg, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "PlayerMessageDemonTalentSelectView", this.info,this.data.slot,this.data.sk_id,[this.data]);
		}, false)
	}

	public UpdateView() {

		let skill_vo = new SkillVo(this.data.sk_id)
		this.res_mgr.SetTexture(this, this._icon, GameResPath.GetSkillIconPath(skill_vo.GetIcon()))

		let demons_skill_add_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_skill_add", false)
		let skill_cfg = demons_skill_add_cfgs[this.data.sk_id]
		this._tips.skin = GameResPath.GetIcon("demon", `uism_068${DemonTalentItem.Level2Str[skill_cfg.quality - 1]}`)

		this._lv.text = "l" + this.data.sk_lv
		this._lv.visible = false
		this._add.visible = false
		this._icon.visible = true
		this._tips.visible = true

	}

	public GetComponents() {
		[
			this.item_bg,
			this._icon_mask,
			this._icon,
			this._add,
			this._lock,
			this.Image,
			this.Image1,
			this._red,
			this._tips,
			this._lv,
		]
			= this.GetChildrenByNames([

				"item_bg",
				"_icon_mask",
				"_icon",
				"_add",
				"_lock",
				"Image",
				"Image1",
				"_red",
				"_tips",
				"_lv",
			])
	}
}
window["PlayerMessageDemonTalentItem"] = PlayerMessageDemonTalentItem