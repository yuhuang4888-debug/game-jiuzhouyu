import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GetSizeDeltaX, GetLocalPositionX, GetSizeDeltaY, GetLocalPositionY, SetLocalPositionX, SetLocalPositionY, HtmlColorTxt, GlobalTimerQuest, SetLocalPosition, SetHtmlStyle } from "../util/Util"
import { DungeonEquipDefine } from "./DungeonEquipDefine"
import { Config } from "../common/Config"
import { MainUIManager } from "../common/MainUIManager"
import { BossHelpRolePanel } from "../boss/BossHelpRolePanel"

export class DungeonEquipFightSceneItem extends BaseItem1 {
	CancelEquipTime
	CancelTime
	LoadSuccess
	Scr_Scroller1
	ShowAnimation
	StartEquipTime
	UpdateDesc
	UpdateTimeScoreData
	UpdateView

	diff_tween_id
	mainUI_model
	now_score
	reward_item_list_
	time_id
	time_id_
	tween_list
	_help_role_panel
	end_time
	public constructor(parent?) {
		super(parent)

		this.base_file = "dungeonEquip"
		this.layout_file = "DungeonEquipFightSceneItem"
		this.layer_value = Enum_UILayer.Main
		let base_model = BaseDungeonModel.GetInstance()

		let local_DungeonEquipDefine = DungeonEquipDefine
		let local_Config = Config
		let local_BaseDungeonModel = BaseDungeonModel
		let goods_model = GoodsModel.GetInstance()
		let mainUI_model = MainUIModel.GetInstance()
		let local_MainUIModel = MainUIModel
		let local_Util = Util
		let local_ColorUtil = ColorUtil
		this.time_id_ = null
		let data_ = null
		let total_count_ = null
		this.reward_item_list_ = null
		let time_func_ = null
		let difficult_int_x = null

		this.mainUI_model = mainUI_model
		this.tween_list = []
		this.preload_server_config = { "config_dungeon": false, "config_dungeon_ui_content": false }
		this.load_callback = () => {
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp, false, MainUIManager.MOVE_TYPE.Left)
            MainUIManager.GetInstance().AddMoveComponent(this, this._gp0, false, MainUIManager.MOVE_TYPE.Buttom)
            MainUIManager.GetInstance().AddMoveComponent(this, this._gp_help_role, false, MainUIManager.MOVE_TYPE.Right)
			SetHtmlStyle(this._lb_level_tips2,{c:"#ffffff",f:20,w:215,lh:30,ww:false})
			ResManager.GetInstance().SetOutsideImageSprite(this,this._Image44,GameResPath.GetIcon("dungeonEquip","ui_copy_14"))
			this._Scroller1.hScrollBarSkin = ""
			this.PreHtml()
			this.LoadSuccess()
			this.UpdateDesc()


			this._help_role_panel = new BossHelpRolePanel(this._gp_help_role)
			this._help_role_panel.Load()
			this._help_role_panel.SetVisible(false)
		}


		this.LoadSuccess = () => {


			difficult_int_x = GetLocalPositionX(this._gp_difficult)

			
			

			this._gp_difficult.visible = false
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image5, GameResPath.GetIcon("dungeonEquip", "uizbfb_043"), true)
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image6, GameResPath.GetIcon("dungeonEquip", "uizbfb_044a"), true)

			data_ = []
			let cur_dun_id = SceneManager.GetInstance().GetCurrDunId()
			let sp_name = local_DungeonEquipDefine.LevelTips[cur_dun_id]
			this._lb_title2.changeText(`寻装觅刃(${sp_name})`)
			//ResManager.GetInstance().SetImageSprite(this, this._img_dun_level, "dungeonEquip_asset", sp_name, true)
			//let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon", false)
			let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_dungeon.name, cur_dun_id, false)//,cfgs
			if (cfg) {
				total_count_ = cfg.wave_num
				this.BindEvent(
					base_model,
					local_BaseDungeonModel.NEXT_WAVE_TIME_INFO, (wave_num?, left_time?) => {
						data_.now_wave_num = wave_num
						this.UpdateDesc()
					}
				)
				this.BindEvent(
					base_model,
					local_BaseDungeonModel.NOW_TIME_SCORE_STATE, (scmd?) => {
						data_.time_score_data = scmd
						this.UpdateDesc()
						this.UpdateTimeScoreData()

					}
				)
				base_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61030)
				base_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61023, cur_dun_id)
			}
			let reward_list = []
			let dungeon_ui_content_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon_ui_content", false)
			if (!dungeon_ui_content_cfg) { return }
			let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_ui_content.name, cur_dun_id, false, dungeon_ui_content_cfg)
			if (c) {
				// [ts2lua]dungeon_ui_content_cfg下标访问可能不正确
				reward_list = JSON.parse(c.rewards)
				if (reward_list) {
					let main_role = RoleManager.GetInstance().GetMainRoleVo()
					let career = main_role.career

					let tmp_reward_list = null
					for (let key in reward_list) {
						var reward = reward_list[key]
						if (reward[0] && Number(reward[0]) == career) {
							tmp_reward_list = reward[1]
							break
						}
					}
					if (tmp_reward_list) {
						reward_list = tmp_reward_list
					}
				}
			}
			if (!this.reward_item_list_) {
				this.reward_item_list_ = []
			}
			for (let _ = 0; _ < this.reward_item_list_.length; _++) {
				var reward_item = this.reward_item_list_[_]
				reward_item.SetVisible(false)
			}
			let index = 0
			for (let key in reward_list) {

				// [ts2lua]reward_list下标访问可能不正确
				let vo = reward_list[key]
				let type_id, lock
				[type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
				let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					// [ts2lua]this.reward_item_list_下标访问可能不正确
					let item = this.reward_item_list_[index]
					if (!item) {
						item = new EquipmentItem(this.Content)
						// [ts2lua]this.reward_item_list_下标访问可能不正确
						this.reward_item_list_[index] = item
						item.SetItemSize(51, 51)
						item.SetUseMask(true)
						item.Load()
					}
					item.SetData(goods_vo.type_id, vo[2], lock)
					item.includeInLayout = true
					item.SetVisible(item.includeInLayout)
					index = index + 1
				}
			}



		}

		this.UpdateDesc = () => {

			let data = data_
			if ((data && data.now_wave_num) && data.time_score_data) {
				let color = "'#0a953e'"
				let desc = "当前波数:"
				desc = desc + HtmlColorTxt(data.now_wave_num + "/" + total_count_, color)
				desc = desc + "<br>首领难度:"
				let time_score_data = data.time_score_data
				// [ts2lua]local_DungeonEquipDefine.ScoreCfg下标访问可能不正确
				let level_cfg = local_DungeonEquipDefine.ScoreCfg[time_score_data.cur_score]
				if (level_cfg) {
					desc = desc + HtmlColorTxt(level_cfg.name, color)
					desc = desc + "<br>首领掉率:"
					desc = desc + HtmlColorTxt(level_cfg.drop + "%", color)
				}

				this.PreHtml2()
				this._lb_desc.innerHTML = Util.StrToHTML(desc)
			}
		}

		this.UpdateTimeScoreData = () => {
			let data = data_.time_score_data
			let is_set=false
			if (data) {
				let score = data.cur_score
				// [ts2lua]local_DungeonEquipDefine.ScoreCfg下标访问可能不正确
				let level_cfg = local_DungeonEquipDefine.ScoreCfg[score]
				if (level_cfg) {
					//this._img_drop.source = level_cfg.drop_source
					//ResManager.GetInstance().SetImageSprite(this, this._img_drop, "dungeonEquip_asset", level_cfg.drop_source, true)
					this._lb_drop_num.text=`${level_cfg.drop}%`
					ResManager.GetInstance().SetImageSprite(this, this._img_box, "dungeonEquip_asset",`uildzdz_b${score}`, true)
				}



				let func = () => {
					this._lb_level_tips2.visible=false
					this.end_time = data.change_time * 1000
					this.StartEquipTime(() => {
						let left_time = this.end_time - TimeUtil.getServerTimeMs()
						let tips = ""
						if (left_time < 0) {
							this._lb_level_tips2.visible=false
							this.CancelTime()
							this.CancelEquipTime()
							//score = score + 1
							data_.time_score_data.cur_score = data_.time_score_data.cur_score + 1
							score = data_.time_score_data.cur_score
							this.now_score = score

							if (data_.now_wave_num == total_count_) {
								tips = "当前评级：" + HtmlColorTxt(level_cfg.name, local_ColorUtil.GetColorLight(score - 1))
							} else {
								// [ts2lua]local_DungeonEquipDefine.ScoreCfg下标访问可能不正确
								this.UpdateDesc()
								this.ShowAnimation()
								let level_cfg = local_DungeonEquipDefine.ScoreCfg[score]
								if (level_cfg) {
									// tips = "当前评级："
									// tips = tips + HtmlColorTxt(level_cfg.name, local_ColorUtil.GetColorLight(score)) + "<br>"
									tips = "当前评级已降低至" + HtmlColorTxt(level_cfg.name, local_ColorUtil.GetColorLight(score))
									is_set=true
									let _level_cfg = local_DungeonEquipDefine.ScoreCfg[score]
									if (_level_cfg) {
										//this._img_drop.source = level_cfg.drop_source
										//ResManager.GetInstance().SetImageSprite(this, this._img_drop, "dungeonEquip_asset", _level_cfg.drop_source, true)
										this._lb_drop_num.text=`${_level_cfg.drop}%`
										ResManager.GetInstance().SetImageSprite(this, this._img_box, "dungeonEquip_asset",`uildzdz_b${score}`, true)
									}
									//	tips = tips + "(" + HtmlColorTxt(level_cfg.drop + "%", local_ColorUtil.GetColorLight(score)) + "掉落)"
								}
							}
						} else {
							let next_score = data.next_score
							let time_str = HtmlColorTxt(TimeUtil.timeConversionWithMillisecond(left_time, "mm:ss.ms"), "'#00fa64'")//local_ColorUtil.GetColorLight(ColorType.GREEN))

							// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
							// 	tips = "Selesaikan dalam " + tips + " sebelum rating diturunkan"	
							// }else{
							// 	tips = tips + "内消灭当前波次怪物可保级"
							// }
							let b_str="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
							tips = b_str+"内消灭当前波次怪物可保级"
							this._lb_level_tips2.visible=true
							this._lb_level_tips2.innerHTML=time_str
							//TimeUtil:timeConversionWithMillisecond(left_time,"mm:ss.ms")
							// [ts2lua]local_DungeonEquipDefine.ScoreCfg下标访问可能不正确
							//let next_level_cfg = local_DungeonEquipDefine.ScoreCfg[next_score]
							//if (next_level_cfg ) {
							//tips =
							//tips + ",首领\n难度提升至" ..
							//HtmlColorTxt(next_level_cfg.name, local_ColorUtil.GetColorLight(next_score)) ..
							//"(" + HtmlColorTxt(next_level_cfg.drop + "%", local_ColorUtil.GetColorLight(next_score)) + "掉落)"
							//}
						}

						this._lb_level_tips.innerHTML = Util.StrToHTML(tips)
						this._lb_level_tips.style.width = 215
						if(is_set){
							is_set=false
							this._lb_level_tips.y = (this._gp0.height - this._lb_level_tips.contextHeight) / 2
						}
					}
					)
				}


				let monster_list = Scene.GetInstance().FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, 10000, null, null, null)
				if ((!monster_list || monster_list.length <= 0) && this.now_score) {
					this.CancelTime()
					this.CancelEquipTime()
					this.PreHtml()
					this._lb_level_tips.innerHTML = "当前评级：" + HtmlColorTxt(level_cfg.name, local_ColorUtil.GetColorLight(score)) + "<br>当前评级已保级"
					this._lb_level_tips.y = (this._gp0.height  - this._lb_level_tips.contextHeight) / 2
					this.time_id = GlobalTimerQuest.AddPeriodQuest(() => {
						let monster_list_ = Scene.GetInstance().FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, 10000, null, null, null)
						if (monster_list_ && monster_list_.length > 0) {
							func()
							this._lb_level_tips2.visible=false
							this.CancelTime()
						}
					}, 0.04, -1)
				} else {
					func()
				}
				this.now_score = score
				this._lb_level_tips.y = (this._gp0.height  - this._lb_level_tips.contextHeight) / 2
			}
		}

		this.ShowAnimation = () => {
			let data = data_.time_score_data
			if (data && data.cur_score != 1) {
				let score = data.cur_score
				// [ts2lua]local_DungeonEquipDefine.ScoreCfg下标访问可能不正确
				let level_cfg = local_DungeonEquipDefine.ScoreCfg[score]
				if (level_cfg) {
					let sp_name = level_cfg.source
					ResManager.GetInstance().SetImageSprite(this, this._img_difficult_level, "dungeonEquip_asset", sp_name, true)
					// if (this.diff_tween_id  ) {
					//    SYTweenLite.Stop(this.diff_tween_id)
					//    this.diff_tween_id = null
					// }

					let ScreenWidth = LayerManager.GetInstance().stageWidth
					let start_x = difficult_int_x - ScreenWidth
					SetLocalPositionX(this._gp_difficult, start_x)
					this._gp_difficult.visible = true
					let tween_id = SYTweenLite.to(this, this._gp_difficult, SYTweenLite.UiAnimationType.POSX, difficult_int_x, local_MainUIModel.Move_Time_Interval, null, SYTweenFunc.EASE_IN_OUT)
					table.insert(this.tween_list, tween_id)
					GlobalTimerQuest.AddDelayQuest(() => {
						if (this.use_delete_method) return
						if (!this._gp_difficult) {
							return
						}
						tween_id = SYTweenLite.to(this, this._gp_difficult, SYTweenLite.UiAnimationType.POSX, difficult_int_x + ScreenWidth, local_MainUIModel.Move_Time_Interval, () => {
							if (this._gp_difficult) {
								this._gp_difficult.visible = false
							}
						}, SYTweenFunc.EASE_IN_OUT)
						table.insert(this.tween_list, tween_id)
					}, 1)
					//let offset = stageWidth / 2 + this._gp_difficult.width / 2
					//this._gp_difficult.horizontalCenter = -offset
					//local_laya.Tween.get(this._gp_difficult):to({horizontalCenter = 0}, 200, local_laya.Ease.circInOut):wait(1000):to({horizontalCenter = offset}, 200, local_laya.Ease.circInOut).call(
					//() => {
					//        if (this._gp_difficult ) {
					//            this._gp_difficult.visible = false 
					//        }
					//    }
					//)
				}
			}
		}

		this.UpdateView = () => {
		}

		this.StartEquipTime = (func?) => {
			this.CancelEquipTime()
			this.time_id_ = GlobalTimerQuest.AddPeriodQuest(func, 0.04, -1)
			func()
		}

		this.CancelEquipTime = () => {
			if (this.time_id_) {
				GlobalTimerQuest.CancelQuest(this.time_id_)
				this.time_id_ = null
			}
		}
		this.CancelTime = () => {
			if (this.time_id) {
				GlobalTimerQuest.CancelQuest(this.time_id)
				this.time_id = null
			}
		}


		SetLocalPosition(this.display_obj, 0, 0, 0)
	}

	ClearTime() {
		if (this.tween_list) {
			for (let _ in this.tween_list) {
				var tween_id = this.tween_list[_]
				SYTweenLite.Stop(tween_id)
			}
			this.tween_list = []
		}
	}

	public DeleteMe() {
		MainUIManager.GetInstance().RemoveMoveComponent(this)
		this.mainUI_model.Fire(MainUIModel.RESET_TEAM_POS)
		this.ClearTime()
		if (this.reward_item_list_) {
			for (let _tmpi in this.reward_item_list_) {
				var v = this.reward_item_list_[_tmpi]
				v.DeleteMe()
			}
			this.reward_item_list_ = null
		}
		if (this._help_role_panel && !this._help_role_panel.use_delete_method) {
			this._help_role_panel.DeleteMe()
			this._help_role_panel=null
		}
		this.CancelEquipTime()
		this.CancelTime()
		super.DeleteMe()
	}



	PreHtml() {
		SetHtmlStyle(this._lb_level_tips,{c:"#ffffff",f:20,w:215,lh:30})
	}

	PreHtml2() {
		SetHtmlStyle(this._lb_desc,{c:"#7b5250",f:18,w:150,lh:23})
	}



_gp:Laya.Box
_img_bg:Laya.Image
_Image4:Laya.Image
_Image2_title2:Laya.Image
_lb_title2:Laya.Label
_Image2:Laya.Image
_Image3:Laya.Image
_Label1:Laya.Label
_Label2:Laya.Label
_lb_desc:Laya.HTMLDivElement
_Scroller1:Laya.Panel
Content:Laya.HBox
_gp0:Laya.Box
_Image44:Laya.Image
_img_box_bg:Laya.Image
_img_box:Laya.Image
_Image444:Laya.Image
_lb_drop_num:Laya.Label
_lb_level_tips:Laya.HTMLDivElement
_lb_level_tips2:Laya.HTMLDivElement
_gp_difficult:Laya.Box
_Image5:Laya.Image
_Group2:Laya.HBox
_Image6:Laya.Image
_img_difficult_level:Laya.Image
_gp_help_role:Laya.Box
public GetComponents() {
[
this._gp,
this._img_bg,
this._Image4,
this._Image2_title2,
this._lb_title2,
this._Image2,
this._Image3,
this._Label1,
this._Label2,
this._lb_desc,
this._Scroller1,
this.Content,
this._gp0,
this._Image44,
this._img_box_bg,
this._img_box,
this._Image444,
this._lb_drop_num,
this._lb_level_tips,
this._lb_level_tips2,
this._gp_difficult,
this._Image5,
this._Group2,
this._Image6,
this._img_difficult_level,
this._gp_help_role,
]
 = this.GetChildrenByNames([

"_gp",
"_img_bg",
"_Image4",
"_Image2_title2",
"_lb_title2",
"_Image2",
"_Image3",
"_Label1",
"_Label2",
"_lb_desc",
"_Scroller1",
"Content",
"_gp0",
"_Image44",
"_img_box_bg",
"_img_box",
"_Image444",
"_lb_drop_num",
"_lb_level_tips",
"_lb_level_tips2",
"_gp_difficult",
"_Image5",
"_Group2",
"_Image6",
"_img_difficult_level",
"_gp_help_role",
])
}
}
 window["DungeonEquipFightSceneItem"]= DungeonEquipFightSceneItem