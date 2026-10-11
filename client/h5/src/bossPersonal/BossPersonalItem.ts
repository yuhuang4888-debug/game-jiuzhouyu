import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { ColorUtil } from "../util/ColorUtil"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { PlatformManager } from "../PlatformManager"

export class BossPersonalItem extends BaseItemRenderer {
	WIDTH = 140
	HEIGT = 276

	res_mgr
	need_refresh = false
	cfg_ui_content

	public constructor() {
		super()
		this.base_file = "bossPersonal"
		this.layout_file = "BossPersonalItem"

		this.res_mgr = ResManager.GetInstance()
		this.load_callback = () => {
			this.cfg_ui_content = this.res_mgr.GetGameConfigFromCache(this.base_item, "config_dungeon_ui_content", false)

			if (PlatformManager.IsEyouEnPlatform()) {
				this._Group2.y = 122
				this._Group2.centerX = 1
				this._Group2.space = 0
				this._Group2.width = 120
				this._lb_bossName.pos(5.5,0)
				this._lb_bossName.width = 120
				this._lb_bossName.wordWrap = true
				this._lb_bossName.leading = 0.1
				this._lb_bossName.align = "center"
			}
			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public dataChanged() {
		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}
		if (!this.data) {
			return
		}

		let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_ui_content.name, this.data.dun_id, false, this.cfg_ui_content)
		let boss_id = c["value1"]
		let boss_info = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, boss_id, false)
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bossHead, GameResPath.GetMonsterHeadPath(boss_info.icon))
		this._lb_bossName.text = boss_info.name
		this._lb_level.text = "Lv." + boss_info.lv
		let order1 = c["value2"]
		let order2 = c["value3"]
		let str = ""
		if (order1 > 0) {
			str = str + order1
		}
		if (order2 > 0) {
			str = str + "," + order2
		}
		if (str == "") {
			this._lb_order.visible = false
		} else {
			this._lb_order.visible = true
			if(PlatformManager.IsEyouEnPlatform()){
				this._lb_order.text = `G${str}`
			} else {
				this._lb_order.text = `${str}阶`
			}
	
		}
		let red = false
		if (this.data.rec_data) {
			for (let i in this.data.rec_data) {
				let vo = this.data.rec_data[i]
				if (vo.key == 10 && vo.val == 0) {
					red = true
					break
				}
			}
		}
		let role_lv = RoleManager.GetInstance().GetMainRoleVo().level
		//let data = this.data
		if (!this.data.level || role_lv >= Number(this.data.level)) {
			this._lb_bossName.color = ColorUtil.TryParseHtmlString("#663915")
			this._lb_level.color = ColorUtil.TryParseHtmlString("#663915")
		} else {
			red = false
			this._lb_bossName.color = ColorUtil.TryParseHtmlString("#ff4f50")
			this._lb_level.color = ColorUtil.TryParseHtmlString("#ff4f50")
		}
		this._img_select.visible = this.selected
		this._img_red.visible = red
		this._img_first.visible = red
		//LayoutRebuilder(this._Group2)
	}

	_Group3: Laya.Box
	_Group1: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_img_bossHead: Laya.Image
	_img_select: Laya.Image
	_Group2: Laya.VBox
	_lb_bossName: Laya.Label
	_lb_level: Laya.Label
	_img_order: Laya.Image
	_lb_order: Laya.Label
	_img_red: Laya.Image
	_img_first: Laya.Image
	public GetComponents() {
		[
			this._Group3,
			this._Group1,
			this._Image1,
			this._Image2,
			this._img_bossHead,
			this._img_select,
			this._Group2,
			this._lb_bossName,
			this._lb_level,
			this._img_order,
			this._lb_order,
			this._img_red,
			this._img_first,
		]
			= this.GetChildrenByNames([

				"_Group3",
				"_Group1",
				"_Image1",
				"_Image2",
				"_img_bossHead",
				"_img_select",
				"_Group2",
				"_lb_bossName",
				"_lb_level",
				"_img_order",
				"_lb_order",
				"_img_red",
				"_img_first",
			])
	}
}
window["BossPersonalItem"] = BossPersonalItem