import { DemonDefine } from "../commonModel/DemonDefine"
import { DsgtModel } from "../commonModel/DsgtModel"
import { FashionModel } from "../commonModel/FashionModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MarketEvent, MarketModel } from "../commonModel/MarketModel"
import { RoleManager } from "../commonModel/RoleManager"
import { RuneModel } from "../commonModel/RuneModel"
import { SkillManager } from "../skill/SkillManager"
import { SkillVo } from "../skill/SkillVo"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { Util, Trim, SetAnchoredPositionY, GetSizeDeltaY, SetSizeDeltaY, SetLocalScale, SetAnchoredPosition, SetSizeDelta, GetSizeDeltaX, SetAnchoredPositionX, GlobalTimerQuest, RefBoxChildsLayout, RefGridLayout, SetHtmlStyle, SetHtmlCenter, RefBoxVLayout } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { BaseView1 } from "./BaseView1"
import { CommonManager } from "./CommonManager"
import { Config } from "./Config"
import { EventName } from "./EventName"
import { FightingShowSmallItem } from "./FightingShowSmallItem"
import { Enum_UILayer } from "./LayerManager"
import { OpenFun } from "./OpenFun"
import { ResManager } from "./ResManager"
import { table } from "./table"
import { UI_MODEL_TYPE } from "./UIModelClass3D"
import { WordManager } from "./WordManager"
import { SpecialCharKey } from "./SpecialCharKey"
export class IllusionTips extends BaseView1 {
	public static Btn = {
		Sell: 0,
		Use: 1,
		UpShelf: 2,
		OutShelf: 3
	}

	x
	closeObj
	_Image111
	dsgt_tween
	rune_tween
	fight_num: FightingShowSmallItem
	show_btn_list

	SetModelShow
	InitEvent
	LoadSuccess
	SetData
	SetTipsHeight
	SourceClickFunc
	SetExpireTime
	OpenCallback
	init_scroll_height = 0

	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "IllusionTips"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.is_delay_callback = false
		this.show_open_movie = true

		let model = GoodsModel.GetInstance(),
			dsgt_model = DsgtModel.GetInstance(),
			common_mgr = CommonManager.GetInstance(),
			local_OpenFun = OpenFun,
			preload_client_config = Config,
			local_GlobalEventSystem = GlobalEventSystem,
			local_EventName = EventName,
			local_GoodsModel = GoodsModel,
			erlang_Parser = ErlangParser.GetInstance(),
			local_WordManager = WordManager,
			local_TimeUtil = TimeUtil,
			market_model = MarketModel.GetInstance(),
			_type_id = null,
			_pos_x = null,
			_pos_y = null,
			_goods_vo = null,
			_ConfigIllusionModel = null,
			_show_model = null,
			_overdue_time = 0,
			_basic = null,
			_btn_list

		this.preload_client_config = {
			"ConfigIllusionModel": false
		}

		this.preload_server_config = {
			"config_rune_skill": false,
		}

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()

		}

		this.open_callback = () => {
			this.OpenCallback()
		}

		this.close_callback = () => { }
		this.destroy_callback = () => {
			if (_show_model) {
				_show_model.DeleteMe()
				_show_model = null
			}
			if (this.fight_num) {
				this.fight_num.DeleteMe()
				this.fight_num = null
			}

			this.ClearUIEffect(this._gp_dsgt_effect)
			this.closeObj = null

			this.source_txt.off(Laya.Event.LINK, this, this.SourceClickFunc)
			local_GlobalEventSystem.Fire(local_EventName.CLOSE_TIPS_VIEW)
			_ConfigIllusionModel = null
			if (this.dsgt_tween) {
				SYTweenLite.Stop(this.dsgt_tween)
				this.dsgt_tween = null
			}
			if (this.rune_tween) {
				SYTweenLite.Stop(this.rune_tween)
				this.rune_tween = null
			}
			ResManager.GetInstance().ClearRoleMode(this.hashCode)
		}

		this.LoadSuccess = () => {
			this.init_scroll_height = this.detail_scroller.height
			SetHtmlStyle(this.intro,{c:"#663915",f:20,w:this.detail_scroller.width-15})
			SetHtmlStyle(this.source_txt,{c:"#d15e00",f:21,w:300,ww:false,lh:28})
			this.detail_scroller.vScrollBar.visible = false
			SetHtmlStyle(this.overdueText, { c: "#ff4f50", f: 20, ww: false, w: 384 })
			_ConfigIllusionModel = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigIllusionModel", true)


			_btn_list = [
				this.sellBtn,
				this.useBtn,
				this.upShelfBtn,
				this.outShelfBtn
			]
		}

		this.InitEvent = () => {
			let jump_open = () => {
				if (_basic) {
					if (_basic.type == 38 && _basic.subtype == 6) {
						dsgt_model.Fire(DsgtModel.DSGT_OPEN_VIEW, "DsgtWindowView", _type_id)
					} else if (_basic.type == 68) {
						let cfg = preload_client_config.PRELOAD_CLIENT_CONFIG.ClientItemUse[_type_id]
						if ((cfg && cfg.FuncId) && common_mgr.CheckFuncOpenState("BabyMainView", true)) {
							local_OpenFun.OpenFunHandler(122, 2, cfg.FuncId[1])
						}
					} else if (_basic.type == 73 && _basic.subtype == 2) {
						local_OpenFun.OpenFunHandler(147)
					} else if (_basic.type == 83 && _basic.subtype == 1) {
						local_OpenFun.OpenFunHandler(240)
					} else {
						let illusion_fun = () => {
							let cfg = preload_client_config.PRELOAD_CLIENT_CONFIG.ClientItemUse[_type_id]
							if (cfg && cfg.FuncId) {
								local_OpenFun.OpenFunHandler(121, cfg.FuncId[1], cfg.FuncId[2])
							}
						}

						if ((((((_basic.type == 16 && _basic.subtype == 3 || _basic.type == 17 && _basic.subtype == 3) || _basic.type == 18 && _basic.subtype == 3) || _basic.type == 19 && _basic.subtype == 3) || _basic.type == 21 && _basic.subtype == 3) || _basic.type == 22 && _basic.subtype == 3) || _basic.type == 69 && _basic.subtype == 1) {
							illusion_fun()
						} else if ((_basic.type == 20 && _basic.subtype == 3) || (_basic.type == 25 && _basic.subtype == 3)) {
							illusion_fun()
						} else if (_basic.type == 12 && _basic.subtype != 0) {
							let index = FashionModel.GetInstance().type_to_tab_index[_basic.subtype]
							if (index != 0 && !index) {
								index = 0
							}
							local_OpenFun.OpenFunHandler(107, index, _type_id)
						}
					}
				}
				this.Close()
			}

			Util.AddClickEvent(this.useBtn, jump_open, this, true)

			let sellBtnFun = () => {
				if (_goods_vo) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "SellView", _goods_vo)
					this.Close()
				}
			}

			Util.AddClickEvent(this.sellBtn, sellBtnFun, this, true)
			this.BindEvent(model, local_GoodsModel.EXPECT_POWER, (scmd?) => {
				if (scmd && _type_id == scmd.goods_type_id) {
					this.top_fight_gp.visible = scmd.expect_power > 0;
					this.fight_num.Updatefighting(scmd.expect_power)
				}
			}
			)

			this.source_txt.on(Laya.Event.LINK, this, this.SourceClickFunc)

			let upShelfBtn_fun = () => {
				if (!_goods_vo) {
					return
				}
				if (!model.GetGoodsVoByGoodsId(_goods_vo.goods_id)) {
					Message.show("物品不存在")
					market_model.Fire(MarketEvent.NEED_UPDATE_BAG)
				} else {
					market_model.Fire(MarketEvent.OPEN_VIEW, "MarketSellCtrlView", _goods_vo)
				}
				this.Close()
			}

			Util.AddClickEvent(this.upShelfBtn, upShelfBtn_fun, this, true)


			let outShelfBtn_fun = () => {
				if (!_goods_vo) {
					return
				}
				let goods_vo = _goods_vo
				market_model.Fire(MarketEvent.REQUEST_PROTO, 15108, "clii", 1, goods_vo.id, goods_vo.type_id, goods_vo.goods_num)
				this.Close()
			}

			Util.AddClickEvent(this.outShelfBtn, outShelfBtn_fun, this, true)
		}

		this.SetData = (type_id?, x?, y?, goods_vo?, show_btn_list?) => {
			_type_id = type_id
			_goods_vo = goods_vo
			_pos_x = x
			_pos_y = y
			this.show_btn_list = show_btn_list
			if (x != null && y != null) {
				this.is_center = false
			} else {
				this.is_center = true
			}
		}

		this.OpenCallback = async () => {
			this.skill_gp.visible = false
			if (!_type_id || this.use_delete_method) {
				return
			} else {
				let basic = model.GetGoodsBasicByTypeId(_type_id)
				this.top_fight_gp.visible = true
				if (basic.type == 74) {
					this.top_fight_gp.visible = false
				}
				_basic = basic
				if (!basic) {
					return
				}
				if (_pos_x != null && _pos_y != null) {
					// this.display_obj.x = _pos_x
					// this.display_obj.y = _pos_y
				}

				if(!this.fight_num){
					this.fight_num = new FightingShowSmallItem(this.top_fight_gp)
					this.fight_num.Load()
				}
			
				let name_str = Trim(basic.goods_name)

				// console.error(basic)
				let color = null
				if(basic.type_id == 26260005 || basic.type_id == 26270005){
					color = basic.color + 2
				}else{
					color = basic.color
				}
				let bg_name = `ui_tips_pzbg_${color}`
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("common4", bg_name))

				// let run_pro = null
				this.runeBox.visible = basic.type == 26;
				let unlock: string = '';
				if (basic.type == 26) { // 御魂
					// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("common4", "uitips_001"))
					// ResManager.GetInstance().SetImageSprite(this, this.dsgt_bg, "dsgt", "ui_role_60")
					// this.bg.sizeGrid = "373,20,20,20";
					// this.bg.width = 400;
					// this.bg.centerX = 0;
					// this.dsgt_bg.visible = true

					// let goods_id = (_goods_vo && (_goods_vo.goods_id) || (null))
					// if (_goods_vo && _goods_vo.comPre) {
					// 	run_pro = RuneModel.GetInstance().GetTipsAwakeStr(basic.subtype, basic.color, _goods_vo.awake_list)
					// } else {
					// 	run_pro = RuneModel.GetInstance().GetTipShowProBySubtype(basic.subtype, basic.color, goods_id)
					// }

					let showColor = (basic.subtype == 26 || basic.subtype == 27) && basic.color == 5 ? 6 : basic.color;
					ResManager.GetInstance().SetImageSprite(this, this.runeTitleImg, "rune", "color_" + showColor)
					ResManager.GetInstance().SetOutsideImageSprite(this, this.runeBgImg, "resource/game/runeCard/icon_kpbg_0" + showColor + ".png")
					ResManager.GetInstance().SetOutsideImageSprite(this, this.runeBg1Img, "resource/game/runeCard/icon_kp_0" + showColor + ".png")
					ResManager.GetInstance().SetOutsideImageSprite(this, this.runeCardImg, "resource/game/runeCard/" + basic.type_id + ".png")
					this.runeLevel.text = " Lv." + basic.level;
					if (!this.rune_tween) {
						this.rune_tween = SYTweenLite.to(this, this.runeBox, SYTweenLite.UiAnimationType.POSY, this.runeBox.y + 15, 2.2, null, SYTweenFunc.PINGPONG, -1)
					}

					let config_rune_all_show = await ResManager.GetInstance().LoadGameConfig(this, "config_rune_all_show", false)
					unlock = RuneModel.GetInstance().GetUnLockStr(basic.type_id, config_rune_all_show);
					unlock = `<br><font color='#60aeff'>${unlock}</font>`;
					this.intro.style.width = this.detail_scroller.width-15;
				}
				if (basic.type == 38 && basic.subtype == 6) {
					this.display_obj.visible = false
					// ResManager.GetInstance().SetImageSpriteTrans(this, this.bg, GameResPath.GetIcon("common4", "uity_016a"))
					// this.bg.sizeGrid = "20,20,20,20"
					// this.bg.width = 400
					// this.bg.centerX = 0
					// ResManager.GetInstance().SetImageSprite(this, this.dsgt_bg, "dsgt", "ui_role_60")
					// this.dsgt_bg.visible = true
					// this.name_bg.y = 0
					this.intro.style.fontSize = 20
					// this.detail_scroller.y = 420
					// this.label2.text = "称号来源"
					Laya.timer.frameOnce(1, this, () => {
						if (this.use_delete_method) return
						this.intro.x = 20
						this.display_obj.visible = true
					})
				}
				if (basic.type == 76) {
					// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("common4", "uitips_001"))
					// this.bg.sizeGrid = "373,20,20,20"
					// this.bg.width = 400
					// this.bg.centerX = 0
					// SetAnchoredPositionY(this.name_bg, 33)
					this.intro.x = 20
					name_str = Trim(basic.goods_name)
					if (basic.type == 76) {
						model.Fire(local_GoodsModel.REQUEST_CCMD_EVENT, 15089, "i", _type_id)
					}
				} else if (basic.type == 20) {
					if (_ConfigIllusionModel[_type_id]) {
						name_str = _ConfigIllusionModel[_type_id].name[RoleManager.GetInstance().GetMainRoleVo().career]
					}
					model.Fire(local_GoodsModel.REQUEST_CCMD_EVENT, 15089, "i", _type_id)
				} else {
					model.Fire(local_GoodsModel.REQUEST_CCMD_EVENT, 15089, "i", _type_id)
				}
				if (basic.type == 38 && basic.subtype == 6) {
					// this.name_bg.height = 48
					if (basic.color == 1) {
						// this.name_bg.skin = GameResPath.GetIcon("dsgt", "ui_role_" + 2)
					} else if (basic.color == 6) {
						// this.name_bg.skin = GameResPath.GetIcon("dsgt", "ui_role_" + 5)
					} else {
						// this.name_bg.skin = GameResPath.GetIcon("dsgt", "ui_role_" + basic.color)
					}
				} else if (basic.type == 26 && (basic.subtype == 26 || basic.subtype == 27)) {
					let showBgColor = basic.color == 5 ? 7 : basic.color;
					// this.name_bg.skin = GameResPath.GetIcon("common", "ts_title_bg" + showBgColor)
				} else {
					// this.name_bg.skin = GameResPath.GetIcon("common", "ts_title_bg" + basic.color)
				}
				this.goods_name.text = name_str
				let intro = Trim(basic.intro) != "" && Trim(basic.intro) || ""
				let attr = basic.type == 26 ? RuneModel.GetInstance().GetRuneAttr(basic.subtype, basic.level, basic.color) : erlang_Parser.Parse(basic.base_attrlist)
				// if (basic.type == 38 && basic.subtype == 6) {
				// 	//勋章碎片属性换行处理
				// 	let r1: RegExp = /<\/font>/g
				// 	let r2 = "</font><br/>"
				// 	intro = intro.replace(r1, r2)
				// }
				if (attr.length > 0) {
					let attCfg = preload_client_config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr
					let sortFunc = (a?, b?) => {

						let a_value = Number(a[0])
						let b_value = Number(b[0])

						let acfg = attCfg[Number(a[0])]
						let is_a_kind = acfg && acfg.kind && acfg.kind == 2
						let bcfg = attCfg[Number(b[0])]
						let is_b_kind = bcfg && bcfg.kind && bcfg.kind == 2
						if (is_a_kind) {
							a_value += 1000
						}

						if (is_b_kind) {
							b_value += 1000
						}
						return a_value < b_value
					}

					let color = "#0a953e"
					table.sort(attr, sortFunc);

					// 按照品质排序
					attr.sort((a, b) => {
						let cfgA = attCfg[Number(a[0])];
						let cfgB = attCfg[Number(b[0])];
						if (cfgA && cfgB) {
							return cfgB.kind - cfgA.kind;
						}
						return 0;
					});

					for (let _tmpi in attr) {
						var vo = attr[_tmpi]
						let cfg = attCfg[Number(vo[0])]
						if (cfg && cfg.kind == 2) {

							color = ColorUtil.GetColorDark(basic.color, false)
							intro = intro + "<br><font color='" + color + "'>" + local_WordManager.GetProperties(vo[0]) + "+" + "</font>" + "<font color='" + color + "'>" + local_WordManager.ConvertToPercentValue(vo[0], vo[1]) + "</font>"
						} else {
							color = "#d15e00"
							intro = intro + "<br><font color='#663915'>" + local_WordManager.GetProperties(vo[0]) + "：" + "</font>" + "<font color='" + color + "'>" + local_WordManager.ConvertToPercentValue(vo[0], vo[1]) + "</font>"
						}
					}
				}

				if (basic.type == 26) {
					let config_rune_skill = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_skill", false);
					let skillCfg = config_rune_skill[`${basic.subtype}`];
					ResManager.GetInstance().SetOutsideImageSprite(this,this._img_skill_bg,GameResPath.GetIconOtherPath("common4","uirw_043c"),false)
					if (skillCfg) {
						this.skill_gp.visible = true;
						let skillId: number = skillCfg.skill_id;
						let skillVo_: SkillVo = SkillManager.GetInstance().getSkill(skillId);
						if (skillVo_) {
							let sp_skill_info = skillVo_.getLevelVo(1)
							if (sp_skill_info) {
								let _skill_desc = "";
								let desc: string = String(sp_skill_info.desc).replace(SpecialCharKey.IllusionTips2, SpecialCharKey.IllusionTips1)
								if (window["ChatModel"]) {
									desc = window["ChatModel"].GetInstance().FormatColorTag(desc, false);
								}
								_skill_desc = `<br><font color='#663915'>${desc}</font>`
								this.skill_intro.style.fontSize = 20
								this.skill_intro.width = 285
								this.skill_intro.style.leading = 6
								this.skill_intro.style.color = "#663915"
								this.skill_intro.height = this._img_skill_bg.height
								this.skill_intro.innerHTML = Util.StrToHTML(_skill_desc);
								
								this.skill_intro.y = (this.gp_sp_skill.height-this.skill_intro.contextHeight)/2
								ResManager.GetInstance().SetOutsideImageSprite(this, this._img_sp_skillIIcon, GameResPath.GetSkillIconPath(sp_skill_info.icon))
							}
						}

					}
				}
				this.intro.style.leading = 10;
				this.intro.innerHTML = basic.type == 26 ? intro + unlock : Util.StrToHTML(intro);
				let show_source = erlang_Parser.Parse(Trim(basic.getway_url))
				let ShowSource = show_source.length > 0
				this.sourceGp.visible = ShowSource
				let Str = ""
				let ClientSourceCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "GoodsSourceConfig", true)
				if (ClientSourceCfg) {
					for (let _tmpi in show_source) {
						var vo = show_source[_tmpi]
						let curCfg = ClientSourceCfg[Number(vo[0])]
						if (curCfg) {
							let hasOpen = vo[1] == "1" && common_mgr.CheckFuncOpenState(curCfg.view, true)
							let color = hasOpen && "#d15e00" || "#8b8b8a"
							if(hasOpen){
								Str = Str + "<font  color='" + color + "'><a href='" + vo[0] + "@" + vo[1] + "'>" + curCfg.name + "</a></font>"
							}else{
								Str = Str + "<font  color='" + color + "'>" + curCfg.name + "</font>"
							}
						
							
							if(Number(_tmpi)%3==2){
								Str += "<br>"
							}else{
								Str += "&nbsp;&nbsp;"
							}
						}
					}

					this.source_txt.visible = ShowSource
					this.source_txt.innerHTML = Util.StrToHTML(Str)
					if(this.source_txt.contextHeight>this.source_label.height){
						this.sourceGp.height=this.source_txt.contextHeight+5
					}else{
						this.sourceGp.height=this.source_label.height
					}
				}
				let show_use_ways = Trim(basic.getway) != ""
				this.line2.visible = show_use_ways
				this.ways.visible = show_use_ways
				this.ways.text = show_use_ways ? Trim(basic.getway) : ""
				this.SetExpireTime()
				this.SetModelShow()


				//刷新detail_scroller的高度
				RefBoxVLayout(this.detail_box,10,true,true)
				if(this.detail_box.height>=this.init_scroll_height){
					this.detail_scroller.height=this.init_scroll_height
				}else{
					this.detail_scroller.height=this.detail_box.height
				}

			}


			if (this.show_btn_list && this.show_btn_list.length > 0) {
				for (let i of this.show_btn_list) {
					_btn_list[i].visible = true
				}

				this.btn_group.visible=true
				RefGridLayout(this.btn_group, {
					column: 2,
					h_gap: 24,
					v_gap: 5,
					item_w: 142,
					item_h: 52
				})
			}else{
				this.btn_group.visible=false
			}


			


			this.SetTipsHeight()
		}

		this.SetModelShow = () => {
			if (!_type_id || !_ConfigIllusionModel) {
				return
			}
			let model_cfg = _ConfigIllusionModel[_type_id]
			if (_show_model) {
				_show_model.DeleteMe()
			}
			if (model_cfg) {
				this._gp_dsgt.mouseEnabled = false
				this.roleCon.mouseEnabled = true
				let action_list = null
				let pos = null
				let scale = null
				let rotate = null

				let model_res = 0
				let role_vo = RoleManager.GetInstance().mainRoleInfo
				let key = role_vo.sex

				let head_model_id, head_clothe_id
				let fashion_model_id, fashion_texture
				let weapon_res, weapon_clothe_id

				if(model_cfg.use_career_key){
					key = role_vo.career
				}

				model_res = Number(model_cfg.model_res[key])
				fashion_model_id = model_res
				fashion_texture = model_cfg.color || 0
				
				if (model_cfg.action_list) {
					action_list = model_cfg.action_list[key]
				}
				if (model_cfg.pos) {
					pos = model_cfg.pos[key]
				}
				if (model_cfg.scale) {
					scale = typeof (model_cfg.scale) == "number" && model_cfg.scale || model_cfg.scale[key]
				}
				if (model_cfg.rotate) {
					rotate = model_cfg.rotate
				}
				if (model_cfg.model_type == UI_MODEL_TYPE.ROLE) { 
					let basic = model.GetGoodsBasicByTypeId(model_cfg.type_id)
					if (basic.type == FashionModel.FashionGoodsType) {
						if(basic.subtype == FashionModel.FashionType.Head){
							head_model_id = model_res
							head_clothe_id = model_cfg.color || 0

							let [model_id, texture_id] = Util.GetRoleClotheId(role_vo)
							model_res = model_id
							fashion_model_id = model_id
							fashion_texture = texture_id
						}
						else{
							[head_model_id, head_clothe_id] = Util.GetRoleHeadId(role_vo)
						}
					} else {
						[head_model_id, head_clothe_id] = Util.GetRoleHeadId(role_vo)
					}

					let data = {
						career: role_vo.career,
						sex: role_vo.sex,
						type: UI_MODEL_TYPE.MAINROLE,
						action_name_list: action_list,
						rotate: rotate,
						layer_value: this.layer_value,
						scale: scale || 0.75,
						position: (pos && new Vector3(pos.x, pos.y, 0) || new Vector3(0, 1, 0)),
						layout_file: this.layout_file,
					
						clothe_res_id: model_res,
						fashion_model_id: fashion_model_id,
						texture_id: fashion_texture,
						head_wear_id: head_model_id,
						head_clothe_id: head_clothe_id,
					}
					ResManager.GetInstance().SetRoleModel(this, this.roleCon, data)
				} else {
					let type = model_cfg.model_type
					let wing_id
					if (model_cfg.model_type == UI_MODEL_TYPE.HORSE) {
					} else if (model_cfg.model_type == UI_MODEL_TYPE.WING) {
					} else if (model_cfg.model_type == UI_MODEL_TYPE.SPRITE) {
					} else if (model_cfg.model_type == UI_MODEL_TYPE.WEAPON) {
						weapon_res = model_cfg.model_res[RoleManager.GetInstance().GetMainRoleVo().career]
						model_res = weapon_res
						pos = model_cfg.pos[RoleManager.GetInstance().GetMainRoleVo().career]
					} else if (model_cfg.model_type == UI_MODEL_TYPE.ARTIFACT) {
					} else if (model_cfg.model_type == UI_MODEL_TYPE.GOD) {
						weapon_res = model_res
					}
					let data = {
						type: type,
						layer_value: this.layer_value,
						scale: scale || 0.75,
						position: pos && new Vector3(pos.x, pos.y, 0) || new Vector3(0, 1, 0),
						clothe_res_id: model_res,
						weapon_res_id: weapon_res,
						wing_id: wing_id,
						rotate: rotate,
						action_name_list: action_list
					}
					ResManager.GetInstance().SetRoleModel(this, this.roleCon, data)
				}
			} else {
				this._gp_dsgt.mouseEnabled = true//= this._gp_dsgt.touchChildren = true
				this.roleCon.mouseEnabled = false
				let basic = model.GetGoodsBasicByTypeId(_type_id)

				if ((basic && basic.type == 38) && basic.subtype == 6) {
					let cfg = DsgtModel.GetInstance().GetDsgtCfgByActiveGoods(_type_id)
					if (cfg) {
						let attr = cfg.attr_list
						let fight = Util.CalAttrPower(attr, false)
						this.fight_num.Updatefighting(fight)
						let location = null
						let target = null
						if (cfg.type == 1) {
							if (cfg.id == 305031) {
								this.AddUIEffect(Trim(cfg.resource_id), this._gp_dsgt_effect, null, 4, true)
								this._gp_dsgt_effect.y = -15
								location = this._gp_dsgt_effect.y
								target = this._gp_dsgt_effect
							} else {
								this.AddUIEffect(Trim(cfg.resource_id), this._gp_dsgt_effect, null, 8, true)
								this._gp_dsgt_effect.y = -15
								location = this._gp_dsgt_effect.y
								target = this._gp_dsgt_effect
							}
						} else if (cfg.type == 3) {
							ResManager.GetInstance().SetOutsideImageSprite(this, this._img_dsgt, "resource/game/dsgtIcon/" + cfg.resource_id + ".png", true, () => {
								this._img_dsgt.centerX = 0
							})
							this._img_dsgt.y = 80
							SetLocalScale(this._img_dsgt, 1.5, 1.5, 1)
							location = this._img_dsgt.y
							target = this._img_dsgt

						}
						if (target && location != null) {
							if (!this.dsgt_tween) {
								this.dsgt_tween = SYTweenLite.to(this, target, SYTweenLite.UiAnimationType.POSY, location + 15, 2.2, null, SYTweenFunc.PINGPONG, -1)
							}
						}

						this.intro.x = 20
					}
				} else if (basic && basic.type == 76) {
					ResManager.GetInstance().LoadGameConfig(ResManager.GetInstance(), "ClientTitleTipsModel", true, undefined, (cfgs) => {
						let ClientTitleTipsModel = cfgs
						let res_name = ClientTitleTipsModel[_type_id].resource_id
						let scale = Number(ClientTitleTipsModel[_type_id].scale)
						if (res_name) {
							let pos = _type_id <= 7601005 ? { x: -1, y: 0 } : { x: 0, y: 0 }
							this.AddUIEffect(res_name, this._gp_dsgt_effect, pos, scale, true)
						}
					});
				}

			}
		}

		this.SetTipsHeight = () => {


			//计算高度
			let contents= [this.detail_scroller,this.sourceGp,this.btn_group]
			let base_y = contents[0].y
			let record_y = base_y
			let last_height = contents[0].height //上一个组件的高度 记录
			let gap = 15
			let is_foreach =false
			for(let i = 1;i<contents.length;i++){
				if(!contents[i].visible)continue
				is_foreach =true
				let new_y = record_y + last_height + gap
				contents[i].y = new_y
				record_y =new_y 
				last_height = contents[i].height
			}

			let img_bg_height = !is_foreach?record_y + last_height +gap:record_y + last_height 
			this._img_bg.height = img_bg_height
			this.display_obj.height = img_bg_height
		}

		this.SourceClickFunc = (e) => {
			let ClientSourceCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "GoodsSourceConfig", true)
			if (ClientSourceCfg && e) {
				let argsList = e.split(`@`)
				let CurCfg = argsList[1] == "1" && ClientSourceCfg[Number(argsList[0])]
				if (CurCfg) {
					if (common_mgr.CheckFuncOpenState(CurCfg.view)) {
						let click_delay = GlobalTimerQuest.AddDelayQuest(() => {
							GlobalEventSystem.Fire(EventName.TOOLTIPS_JUMP)
							this.Close()
							if ((typeof (CurCfg.id) == "number" && (CurCfg.id == 60 || CurCfg.id >= 140 && CurCfg.id <= 145))) {
								local_OpenFun.OpenFunHandler(CurCfg.id, null, _type_id)
							} else {
								local_OpenFun.OpenFunHandler(CurCfg.id)
							}
						}, 0.1)

					}
				}
			}
		}

		this.SetExpireTime = () => {
			let basic = model.GetGoodsBasicByTypeId(_type_id)
			if (!basic) {
				return
			}
			this.overdueText.visible = false
			this.overdueText.innerHTML = ""
			if ((_goods_vo && _goods_vo.expire_time > 0 || _overdue_time > 0) || basic.expire_time > 0) {
				this.overdueText.visible = true
				let time_desc = ""
				if (_goods_vo && _goods_vo.expire_time > 0) {
					if (local_TimeUtil.getServerTime() > _goods_vo.expire_time) {
						time_desc = "已过期"
					} else {
						time_desc = "<font color='#FFF200'>过期时间：" + local_TimeUtil.timeConversion(_goods_vo.expire_time, "yyyy/mm/dd hh.MM:ss") + "</font>"
					}
				} else if (_overdue_time != 0) {
					time_desc = "限时：" + local_TimeUtil.timeConversion(_overdue_time, "yyyy/mm/dd hh.MM:ss")
				} else if (basic.expire_time != 0) {
					if (basic.expire_time.indexOf("-") >= 0) {
						time_desc = "限时：<font color='#639c12'>" + basic.expire_time + "</font>"
					} else {
						let time = basic.expire_time
						if (basic.expire_type == 1) {
							time_desc = `限时：${this.TransTime(time)}`
						} else {
							if (time > 1200000000) {
								time_desc = "过期时间：" + local_TimeUtil.timeConversion(time, "yyyy/mm/dd hh.MM:ss")
							} else {
								time_desc = "限时：" + local_TimeUtil.convertTimeColor(time, "yyyy/mm/dd hh.MM:ss")
							}
						}
					}
				}
				this.overdueText.innerHTML = Util.StrToHTML(time_desc)
				this.overdueText.style.bold = true
				// SetAnchoredPosition(this.overdueText, this.overdueText.x, 330)
				SetHtmlCenter(this.overdueText, { x: 0, w: 384 })

			}
		}
	}


	public TransTime(second) {
		let D = Math.floor(second / 60 / 60 / 24);
		let h = Math.floor(second / 60 / 60) % 24;
		let m = Math.floor(second / 60) % 60;
		let s = second % 60;

		if (D > 0){
			if(h>0){
				return `${D}天${h}时`;
			}else{
				return `${D}天`;
			}
		}
		
		else if (h > 0){
			if(m>0){
				return `${h}小时${m}分`;
			}else{
				return `${h}小时`;
			}
		}
		
		else{
			if(s>0){
				return `${m}分${s}秒`;
			}else{
				return `${m}分`;
			}
		}
	}


_img_bg:Laya.Image
goods_name:Laya.Label
runeBox:Laya.Box
runeBgImg:Laya.Image
runeCardImg:Laya.Image
runeBg1Img:Laya.Image
runeTitleImg:Laya.Image
runeLevel:Laya.Label
_gp_dsgt:Laya.Box
_img_dsgt:Laya.Image
_gp_dsgt_effect:Laya.Box
roleCon:Laya.Box
top_fight_gp:Laya.Box
detail_scroller:Laya.Panel
detail_box:Laya.Box
_Group1:Laya.Box
intro:Laya.HTMLDivElement
skill_gp:Laya.Box
_Group2:Laya.Box
gp_sp_skill:Laya.Box
_img_skill_bg:Laya.Image
_img_sp_skillIIcon:Laya.Image
skill_intro:Laya.HTMLDivElement
line2:Laya.Box
ways:Laya.Label
sourceGp:Laya.Box
source_label:Laya.Label
source_txt:Laya.HTMLDivElement
btn_group:Laya.Box
sellBtn:Laya.Box
useBtn:Laya.Box
upShelfBtn:Laya.Box
outShelfBtn:Laya.Box
overdueText:Laya.HTMLDivElement
public GetComponents() {
[
this._img_bg,
this.goods_name,
this.runeBox,
this.runeBgImg,
this.runeCardImg,
this.runeBg1Img,
this.runeTitleImg,
this.runeLevel,
this._gp_dsgt,
this._img_dsgt,
this._gp_dsgt_effect,
this.roleCon,
this.top_fight_gp,
this.detail_scroller,
this.detail_box,
this._Group1,
this.intro,
this.skill_gp,
this._Group2,
this.gp_sp_skill,
this._img_skill_bg,
this._img_sp_skillIIcon,
this.skill_intro,
this.line2,
this.ways,
this.sourceGp,
this.source_label,
this.source_txt,
this.btn_group,
this.sellBtn,
this.useBtn,
this.upShelfBtn,
this.outShelfBtn,
this.overdueText,
]
 = this.GetChildrenByNames([

"_img_bg",
"goods_name",
"runeBox",
"runeBgImg",
"runeCardImg",
"runeBg1Img",
"runeTitleImg",
"runeLevel",
"_gp_dsgt",
"_img_dsgt",
"_gp_dsgt_effect",
"roleCon",
"top_fight_gp",
"detail_scroller",
"detail_box",
"_Group1",
"intro",
"skill_gp",
"_Group2",
"gp_sp_skill",
"_img_skill_bg",
"_img_sp_skillIIcon",
"skill_intro",
"line2",
"ways",
"sourceGp",
"source_label",
"source_txt",
"btn_group",
"sellBtn",
"useBtn",
"upShelfBtn",
"outShelfBtn",
"overdueText",
])
}
}
 window["IllusionTips"]= IllusionTips