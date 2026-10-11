import { BaseItem1 } from "../common/BaseItem1";
import { ResManager } from "../common/ResManager";
import { DemonModel } from "../commonModel/DemonModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

/**妖灵自带的技能 */
export class DemonTalentItem extends BaseItem1 {
	item_bg: Laya.Image
	_img_add: Laya.Image
	_icon: Laya.Image
	_lb_lv: Laya.Label
	_img: Laya.Image
	_img_activate: Laya.Image
	_img_level: Laya.Image
	_lb_num: Laya.HTMLDivElement


	demon_data
	demon_model: DemonModel
	is_goods_data
	need_refresh_data
	show_red
	slot
	type_id
	lb_number
	public static Level2Str = ["a", "b", "c", "d", "e"]

	public constructor(parent?) {
		super(parent)
		this.base_file = "demon"
		this.layout_file = "DemonTalentItem"
		this.demon_model = DemonModel.GetInstance()
		this.is_goods_data = false
		this.show_red = false
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	// public DeleteMe() {
	// }

	public SetData(demon_data?, slot?, type_id?) {
		this.demon_data = demon_data
		this.slot = slot
		this.type_id = type_id
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}
	public UpdateView() {
		let goods_basic = null
		let skill_id = null
		let quality = null
		let skill_lv = 0
		let cfg
		let demons_skill_add_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_demons_skill_add", false)
		if (!this.type_id) {
			let talent_data = this.demon_data.GetTalentData(this.slot)
			if (talent_data) {
				skill_id = talent_data.sk_id
				cfg = demons_skill_add_cfgs[skill_id]
			}
		} else {
			cfg = this.demon_model.GetTalentCfgByTypeId(this.type_id, demons_skill_add_cfgs)
		}

		if (cfg) {
			goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(cfg.goods_id)
			quality = cfg.quality
			skill_id = cfg.skill_id
		}

		this._icon.visible = goods_basic != null
		this.item_bg.visible = goods_basic != null

		if (this._icon.visible && skill_id) {
			ResManager.GetInstance().SetTexture(this, this._icon, GameResPath.GetSkillIconPath(skill_id))
			// this.item_bg.skin =GameResPath.GetIcon("common",`com_goods_plate_${goods_basic.color}`)// `common_json.com_goods_plate_${goods_basic.color}_png`	
		}

		this._img_add.visible = !goods_basic
		this._img_activate.visible =false// quality != null
		this._img_level.visible = quality != null
		this._img.visible = this._img_activate.visible

		if (quality) {
			this._img_level.skin =GameResPath.GetIcon("demon",`uism_068${DemonTalentItem.Level2Str[quality - 1]}`) //`demon_json.uism_068${DemonTalentItem.Level2Str[quality - 1]}_png`
		}
		this._lb_num.width=100
		this._lb_num.innerHTML =""
		if (this.lb_number) {
			this._lb_num.innerHTML = Util.StrToHTML(this.lb_number)
		}
	}

	public ShowNum(str?) {
		this.lb_number=str
		if (this._lb_num ) {
			this._lb_num.width=100
			this._lb_num.innerHTML=""
			if( this.lb_number == undefined) return
			this._lb_num.innerHTML = Util.StrToHTML(str)
		}
	}

	public ResetItem() {
		this._icon.visible = false
		this.item_bg.visible = true
		this._img.visible = false
		this._lb_lv.visible = false
		this._icon.visible = false
		this._img_activate.visible = false
		this._img_level.visible = false
		this._img_add.visible = true
	}

	public GetComponents() {
		[
			this.item_bg,
			this._img_add,
			this._icon,
			this._lb_lv,
			this._img,
			this._img_activate,
			this._img_level,
			this._lb_num,
		]
			= this.GetChildrenByNames([

				"item_bg",
				"_img_add",
				"_icon",
				"_lb_lv",
				"_img",
				"_img_activate",
				"_img_level",
				"_lb_num",
			])
		this._lb_num.style.fontSize=18
		this._lb_num.style.color="#ffffff"
	}
}
window["DemonTalentItem"] = DemonTalentItem