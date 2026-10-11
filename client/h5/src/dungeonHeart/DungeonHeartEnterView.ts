import { BaseView1 } from "../common/BaseView1"
import { LayerManager, Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { SkillVo } from "../skill/SkillVo"
import { GameResPath } from "../util/GameResPath"
import { Util, Trim, SetHtmlStyle, SetHtmlCenter, HtmlColorTxt } from "../util/Util"
import { Config } from "../common/Config"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"

export class DungeonHeartEnterView extends BaseView1 {
	InitEvent
	InitView
	item_list
	taskvo
	offset
	ui_scale
	action_name_list
	ShowBossModel


	public constructor() {
		super()

		let layer_mgr = LayerManager.GetInstance()
		let base_model = BaseDungeonModel.GetInstance()
		let local_GameResPath = GameResPath
		let local_Util = Util
		let skill_id_ = null
		let close_time_ = null
		let close_time_id_ = null
		this.base_file = "dungeonHeart"
		this.layout_file = "DungeonHeartEnterView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = false
		this.not_show_main_msg = true
		this.not_show_attr_main_msg = true
		this.preload_server_config =
		{
			"config_dungeon":false,
			"config_mon":false,
			"config_dungeon_ui_content":false
		}
		this.preload_client_config = { "ConfigDungeonClient": false }
		this.load_callback = () => {
			SetHtmlStyle(this.bossName, { c: "#ffffff", f: 22, ww: false, w: 500, st: 2, stc: "#5853a4" })
			SetHtmlStyle(this.monsterText, { c: "#ffffff", f: 20, ww: false, w: 555, lh: 25 })
			SetHtmlStyle(this.monsterText2, { c: "#ffffff", f: 20, ww: false, w: 555 })
			SetHtmlStyle(this.skillDes, { c: "#ffffff", f: 20, w: 406, lh: 25 })


			this._box_eff.width = 720
			this._box_eff.height = 1280
			this._box_eff.centerX = 0
			this._box_eff.centerY = 300
		}

		this.open_callback = () => {
			this.InitEvent()
			this.InitView()
		}

		this.destroy_callback = () => {
			ResManager.GetInstance().ClearRoleMode(this.hashCode)
		}

		this.InitView = () => {
			if (this.taskvo) {
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_learn_skill[this.taskvo.id]//Config.Dungeonlearnskill[this.taskvo.id]
				if (cfg) {
					let bossInfo //=
					//if (bossInfo ) {
					let need_power = 0

					let cfg1 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon", false)
					let cfg2 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon_ui_content", false)
					let cfg3 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_mon", false)

					let dunCfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, cfg.dun_id, false, cfg1)
					let dunInfo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_ui_content.name, cfg.dun_id, false, cfg2)
					if (dunInfo) {
						bossInfo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, dunInfo.value1, false, cfg3)
					}
					if (dunCfg) {
						need_power = dunCfg.recommend_power
					}
					if (bossInfo) {
						this.bossName.innerHTML = `Lv.${bossInfo.lv}&nbsp;${bossInfo.name}`
						// Util.StrToHTML("Lv." + bossInfo.lv + "<font color='#ff9015'>" + bossInfo.name + "</font>")
						SetHtmlCenter(this.bossName, { x: 112, w: 500 })

						let modelCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigDungeonClient", true).show_effect//Config.ConfigDungeonClient.show_effect
						let _modelCfg = modelCfg[10][bossInfo.id]
						this.offset = _modelCfg && _modelCfg.pos || { x: 0, y: 0 }
						this.ui_scale = _modelCfg && _modelCfg.scale || 1
						this.action_name_list = _modelCfg && _modelCfg.action_name_list || ["attack"]
						table.insert(this.action_name_list, "idle")
						this.ShowBossModel(bossInfo.icon, this.ui_scale, this.offset, this.action_name_list)
						this.monsterText.innerHTML = Util.StrToHTML("击败魂魔战场的<font color='#fffa6c'>" + bossInfo.name + "</font>吧")
						let role_power = RoleManager.GetInstance().GetMainRoleVo().fighting
						let color = role_power >= need_power && "'#00fa64'" || "'#ff4f50'"
						let p1=HtmlColorTxt(`${role_power}`,color)
						let p2=HtmlColorTxt(`${need_power}`, "'#fffa6c'")
						this.monsterText2.innerHTML = `推荐战力：${p1}/${p2}`
					}

					let skillList = JSON.parse(cfg.skill_list)
					let career = RoleManager.GetInstance().GetMainRoleCareer()
					if (skillList.length > 0) {
						for (let _ in skillList) {
							var v = skillList[_]
							if (Number(v[0]) == career) {
								let skillCfg = new SkillVo(v[1][0][0])
								if (skillCfg) {
									ResManager.GetInstance().SetOutsideImageSprite(this, this.skillIcon, GameResPath.GetSkillIconPath(skillCfg.GetIcon()))
									this.skillName.text = skillCfg.getName()
									this.skillDes.innerHTML = Trim(skillCfg.getDesc())
									this.skillDes.style.width = 406
								}
							}
						}
					}
					let res = cfg.dun_id % 100
					let path
					if (res < 10) {
						path = "I_0" + res
					}
					ResManager.GetInstance().SetImageSprite(this, this.nameNum, "dungeonHeart_asset", path, true)
				}
			}
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("dungeonHeart", "uihmzc_007"), true)
			this.AddUIEffect("ui_anniu_6",this._box_eff,{x:0,y:-1.35},1,true)
		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}
			Util.AddClickEvent(this.closeBtn, close_fun, this, true)

			let enterFunc = () => {
				if (this.taskvo) {
					base_model.Fire(BaseDungeonModel.SCMD_REQUEST, 61001, this.taskvo.id)
					this.Close()
				}
			}
			Util.AddClickEvent(this.enterBtn, enterFunc, this, true)
		}


		this.ShowBossModel = (model_id?, icon_scale?, offset?, action_name_list?) => {
			if (model_id == null) { return }

			let callBack = () => {
			}

			let nscale={}
			let data = {
				clothe_res_id: model_id,
				type: UI_MODEL_TYPE.MONSTER,
				layer_value: this.layer_value,
				scale: 0.8 * icon_scale.x,
				position: offset,
				load_call_back: callBack,
				action_name_list: action_name_list || ["attack", "idle"]
			}

			ResManager.GetInstance().SetRoleModel(this, this.bossCon, data)

		}

	}

	public Open(...new_args) {

		this.taskvo = new_args[0]
		super.Open()
	}


	public DeleteMe() {
		this.ClearUIEffect(this._box_eff)
		super.DeleteMe()
	}




bg:Laya.Image
bossCon:Laya.Box
closeBtn:Laya.Image
bossName:Laya.HTMLDivElement
enterBtn:Laya.Box
_Image1:Laya.Image
labelDisplay:Laya.Label
_box_eff:Laya.Box
_img_tbg:Laya.Image
skillBg:Laya.Image
skillIcon:Laya.Image
skillDes:Laya.HTMLDivElement
skillName:Laya.Label
monsterText:Laya.HTMLDivElement
monsterText2:Laya.HTMLDivElement
monsterText3:Laya.Label
Image:Laya.Image
nameNum:Laya.Image
public GetComponents() {
[
this.bg,
this.bossCon,
this.closeBtn,
this.bossName,
this.enterBtn,
this._Image1,
this.labelDisplay,
this._box_eff,
this._img_tbg,
this.skillBg,
this.skillIcon,
this.skillDes,
this.skillName,
this.monsterText,
this.monsterText2,
this.monsterText3,
this.Image,
this.nameNum,
]
 = this.GetChildrenByNames([

"bg",
"bossCon",
"closeBtn",
"bossName",
"enterBtn",
"_Image1",
"labelDisplay",
"_box_eff",
"_img_tbg",
"skillBg",
"skillIcon",
"skillDes",
"skillName",
"monsterText",
"monsterText2",
"monsterText3",
"Image",
"nameNum",
])
}
}
 window["DungeonHeartEnterView"]= DungeonHeartEnterView