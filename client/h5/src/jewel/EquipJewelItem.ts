import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
export class EquipJewelItem extends BaseItem1 {
	attr1
	attr2
	data
	dynamic
	img_add
	lv_cfg
	model: EquipModel
	pos
	redstatus
	unlock

	public constructor(parent?) {
		super(parent)
		this.dynamic = null
		this.lv_cfg = null
		this.data = null
		this.unlock = false
		this.redstatus = false
		this.model = EquipModel.GetInstance()
		this.base_file = "jewel"
		this.layout_file = "EquipJewelItem"
		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._Image1.height = 45
				this.tips.centerX = 0
				this.tips.y = 96
				this.tips.fontSize = 18
				this.tips.wordWrap = true
				this.tips.width = 127
				this.tips.height = 33
				this.tips.leading = 0.1
			}
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public LoadSuccess() {
	}

	public InitEvent() {
		Util.AddClickEvent(this._gp_click, () => {
			if (!this.unlock) {
				Message.show("槽位还没解锁")
				return
			}
			let equip_stone_inlay_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_stone_inlay", false)
			let jewel_lv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_stone_lv", false)
			let list = this.model.GetBagJewelsByType(this.dynamic.equip_type, equip_stone_inlay_cfg, jewel_lv_cfg)
			if (!this.data && list.length < 1) {
				Message.show("没有宝石可镶嵌")
				return
			}
			this.model.Fire(EquipEvent.OPEN_VIEW, "EquipJewelBagView", this.data, this.dynamic, this.pos)
		}, this)

		this.BindEvent(this.model, EquipEvent.SET_JEWEL, (info?) => {
			if (info.type_id == 0) {
				return
			}
			if (info.pos != this.pos) {
				return
			}
			if (!this.unlock) {
				return
			}

			this.playEffect();
			// ResManager.GetInstance().SetUIEffect2(this,"ui_inlay_glow", this._gp_eff, undefined, undefined, undefined, undefined, undefined, undefined, undefined, true)
		})

		this.BindEvent(this.model, EquipEvent.UPGRADE_JEWEL, (info?) => {
			if (info.pos == this.pos) {
				this.playEffect();
			}
		})
	}

	private playEffect() {
		this.ClearUIEffect(this._gp_eff)
		this._gp_eff.visible = true;
		this.AddUIEffect("QiangHua", this._gp_eff, { x: 0, y: 0 }, 7, false, 0.5, () => {
			this._gp_eff.visible = false;
		}, null, null, null, null, null, false);
	}

	public SetJewelPos(pos?) {
		this.pos = pos
	}

	public SetInfos(...new_args) {
		let infos = new_args
		this.dynamic = infos[0]
	}

	public SetCfgs(...new_args) {
		let cfgs = new_args
		this.lv_cfg = cfgs
	}

	public SetRedStatus(redstatus?) {
		this.redstatus = redstatus
	}

	public SetData(data?) {
		this.data = data
		this.unlock = true
		this.lock.visible = false
		this._add.visible = false
		this.icon.visible = true
		this.tips.text = Util.StrToHTML(GoodsModel.GetGoodsName(data.type_id))
		this.tips.color = "#5a1c20"
		let icon_id = GoodsModel.GetGoodsIcon(data.type_id)
		ResManager.GetInstance().SetOutsideImageSprite(this, this.icon, GameResPath.GetGoodsIconPath(icon_id))
		this.arrowImg.visible = this.unlock && this.redstatus; // 合成红点
		this.red_dot.visible = !this.arrowImg.visible && this.redstatus; // 有合成红点不显示
	}

	public GetAttrShowStr(attr_cfg?) {
		let name = WordManager.GetProperties(Number(attr_cfg[0]))
		return name + "+" + attr_cfg[1]
	}

	public SetLockEmptyStatus(unlock_cfg?, attr_cfg?) {
		this.data = null
		let cond = JSON.parse(unlock_cfg.condition)
		let unlock = cond.length < 1
		let str = "未镶嵌"
		if (!unlock) {
			let str_list = cond[0]
			let key = str_list[0]
			let value = str_list[1]
			if (key == "stage") {
				unlock = Number(value) <= attr_cfg.stage
				if (PlatformManager.IsEyouEnPlatform()) {
					str = !unlock && (`Grade ${value} to unlock`) || str
				}else{
					str = !unlock && (value + "阶开启") || str
				}
			} else if (key == "vip") {
				let vValue = Number(str_list[2])
				let card = VipModel.GetInstance().GetNobleCardState()
				let vip_flag = RoleManager.GetInstance().GetMainRoleVo().vip_flag
				unlock = vValue <= vip_flag && value <= card
				if (PlatformManager.IsEyouEnPlatform()) {
					str = !unlock ? (`VIP ${vValue} Unlock`) : str
				}else{
					str = !unlock ? ("VIP" + vValue + "解锁") : str
				}
			}
			this.tips.color = unlock ? "#5a1c20" : "#ff4f50"
		} else {
			this.tips.color = "#5a1c20"
		}
		this.red_dot.visible = false;
		this.arrowImg.visible = false;
		this.lock.visible = !unlock;
		this._add.visible = unlock;
		this.icon.visible = false;
		this.tips.text = Util.StrToHTML(str);
		this.unlock = unlock;
	}

	bg: Laya.Image
	icon: Laya.Image
	_add: Laya.Image
	lock: Laya.Image
	_Image1: Laya.Image
	tips: Laya.Label
	red_dot: Laya.Image
	arrowImg: Laya.Image
	_gp_eff: Laya.Box
	_gp_click: Laya.Box
	public GetComponents() {
		[
			this.bg,
			this.icon,
			this._add,
			this.lock,
			this._Image1,
			this.tips,
			this.red_dot,
			this.arrowImg,
			this._gp_eff,
			this._gp_click,
		]
			= this.GetChildrenByNames([

				"bg",
				"icon",
				"_add",
				"lock",
				"_Image1",
				"tips",
				"red_dot",
				"arrowImg",
				"_gp_eff",
				"_gp_click",
			])
	}
}
window["EquipJewelItem"] = EquipJewelItem