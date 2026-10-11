import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { Enum_UILayer } from "../common/LayerManager"
import { RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OutWardBaseModel, enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { RefGridLayout, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { OutWardUpStarItem } from "./OutWardUpStarItem"
import { upStarPropItem } from "./upStarPropItem"

export class OutwardStarView extends BaseView1 {
	SelectItem
	CreateModel
	ClearModel
	DesFunc
	InitView
	InitEvent
	MyOpen
	attr_box
	fight_item
	/**打开界面的时候 判断是否请求更新过战力 */
	req_list={}
	public constructor() {
		super()
		this.base_file = "pet"
		this.layout_file = "OutwardStarView"
		this.layer_value = Enum_UILayer.Activity

		let local_outwardModel = OutWardBaseModel
		let local_outwardModelIns = local_outwardModel.GetInstance()
		let local_redMgr = RedDotManager.GetInstance()
		let local_roleVo = RoleManager.GetInstance().GetMainRoleVo()
		let local_resMgr = ResManager.GetInstance()
		let local_json = JSON

		let typeId_,
			selectedId_,
			oldItem_,
			illuItemList_ = {},
			starList_ = [],
			shadowList = [],
			propItemList_ = [],
			costItem_,
			costId_,
			defaultSelect_,
			outward_model_,
			model_id_ = null
		this.attr_box = {
			h_gap: 10,
			v_gap: 5,
			column: 2,
			item_w: 285,
			item_h: 35,
		}
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.destroy_imm = true

		this.preload_client_config = {
			"ClientOutWardPos": false
		}

		this.load_callback = () => {
			this.InitEvent()
		}

		this.destroy_callback = () => {
			this.DesFunc()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.MyOpen = (...parms) => {
			if (parms) {
				typeId_ = parms[0]
				defaultSelect_ = parms[1]
			}
			super.Open()
		}

		this.InitEvent = () => {
			this.fight_item = new FightingShowSmallItem(this._gp_fight)
			this.fight_item.Load()
			this.fight_item.IsCenter(true, false)


			for (let i = 0; i < 5; i++) {
				starList_[i] = this.starGp.getChildAt(i)
				shadowList[i] = this.shadowGp.getChildAt(i)
			}

			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.upBtn, () => {
				if (typeId_ && selectedId_) {
					local_outwardModelIns.Fire(local_outwardModel.REQUEST_PROTO, 16020, "ci", typeId_, selectedId_)
				}
			}, this, true)

			this.BindEvent(local_outwardModelIns, local_outwardModel.SELECT_ILLU_STAR_ITEM, (id?) => {
				this.SelectItem(id)
			})

			this.BindEvent(local_outwardModelIns, local_outwardModel.UPSTAR_SUCCESS, (scmd?) => {
				if (selectedId_ == scmd.id && typeId_ == scmd.type_id) {
					// this.AddUIEffect("UI_1102_shengxingchenggong", this.effectGp)
					this.SelectItem(scmd.id)
				}
			})

			this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_OUTWARD_FIGURE_DATA, (data?) => {
				if (data.type_id == typeId_ && selectedId_) {
					let info = local_outwardModelIns.outward_figure_list[typeId_][selectedId_]
					if (info) {
						if (this.fight_item) {
							this.fight_item.Updatefighting(info.star_combat);
							if (info.next_star_power == 0) {
								this.fight_item.UpdatefightingUp(0);
								this.fight_item.IsCenter(true, false);
							} else {
								this.fight_item.UpdatefightingUp(info.next_star_power - info.star_combat);
								this.fight_item.SetPowerOffset(this.fight_item.display_obj.width / 4);
							}
						}
					}
				}
			})

			this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_ILLUSION_RED, () => {
				if (selectedId_) {
					this.reddot.visible = local_redMgr.CheckRedStatus(local_outwardModelIns.GetRedType(typeId_), selectedId_)
				}
			})

			this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_STAR_FIGHT, (scmd?) => {
				if (scmd.id == selectedId_ && scmd.type_id == typeId_) {
					if (this.fight_item) {
						this.fight_item.Updatefighting(scmd.power)
						if (scmd.next_star_power == 0) {
							this.fight_item.UpdatefightingUp(0);
							this.fight_item.IsCenter(true, false);
						} else {
							this.fight_item.UpdatefightingUp(scmd.next_star_power - scmd.power);
							this.fight_item.SetPowerOffset(this.fight_item.display_obj.width / 4);
						}
					}
				}
			})

			local_resMgr.SetTexture(this, this.bg2, GameResPath.GetIconJpg("pet", "zqsx_005"))
		}

		this.InitView = () => {


			// curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// this.RegisterMask(this.illuGp)
			if (!typeId_ || !this.is_loaded) {
				return
			}

			this.req_list={}

			let career = local_roleVo.career
			let activeList = local_outwardModelIns.outward_illu_data_list[typeId_]
			let list = {}
			if (activeList) {
				for (let vo of activeList.figure_list) {
					list[vo.id] = vo
				}
			}
			let active = []
			let unactive = []
			for (let index in local_outwardModelIns.outward_illusion_cfg) {
				if (local_outwardModelIns.outward_illusion_cfg[index].type_id == typeId_) {
					let illu_info = local_outwardModelIns.outward_illusion_cfg[index]
					if (illu_info.career == 0 || illu_info.career == career) {
						if (list[illu_info.id]) {
							table.insert(active, illu_info)
						} else {
							table.insert(unactive, illu_info)
						}
					}
				}
			}
			let v = 0
			let find = false
			let sortFunc = (a?, b?) => {
				return a.id < b.id
			}
			if (!Util.IsTableEmpty(active)) {
				table.sort(active, sortFunc)
			}
			if (!Util.IsTableEmpty(unactive)) {
				table.sort(unactive, sortFunc)
			}
			active = active.concat(unactive)
			for (let illu_info of active) {
				let item = illuItemList_[illu_info.id]
				if (!item) {
					item = new OutWardUpStarItem(this.illuGp)
					item.Load()
					illuItemList_[illu_info.id] = item
				}
				if (!find) {
					v = v + 160
				}
				if (!defaultSelect_) {
					defaultSelect_ = illu_info.id
				} else if (defaultSelect_ == illu_info.id) {
					find = true
				}
				item.ExcuteCallback(() => {
					item.SetData(typeId_, list[illu_info.id] || { "id": illu_info.id })
				})
			}
			this.SelectItem(defaultSelect_ || 1)
			if (v > 640) {
				this.scroller.hScrollBar.height = v - 640
			}

			let source
			if (typeId_ == 1) {
				source = "uizqsx_001"
			} else if (typeId_ == 2) {
				source = "uizqsx_001b"
			} else if (typeId_ == 7) {
				source = "uizqsx_001a"
			}
			if (source) {
				// this.title.source = `pet_json.${source}`
				ResManager.GetInstance().SetImageSpriteTrans(this, this.title, GameResPath.GetIcon("pet", source))
			}

			// local_resMgr.SetTexture(this, this.bg1, GameResPath.GetIcon("pet", "uisy_023")

			// this.AddUIEffect("UI_1104", this.fight_bg, undefined, undefined, true)
		}

		this.SelectItem = (id?) => {
			if (oldItem_) {
				oldItem_.ExcuteCallback(() => {
					oldItem_.SetSelect(false)
				})
			}
			this.reddot.visible = local_redMgr.CheckRedStatus(local_outwardModelIns.GetRedType(typeId_), id)
			let item = illuItemList_[id]
			if (item) {
				item.ExcuteCallback(() => {
					item.SetSelect(true)
				})
				let illuCfg = local_outwardModelIns.outward_illusion_cfg[`${typeId_}@${id}@${local_roleVo.sex}`]
				if (illuCfg) {
					this.nameLb.text = illuCfg.name
					this.CreateModel(illuCfg.ride_figure)
				}
				let list = local_outwardModelIns.outward_illu_data_list[typeId_]
				let vo
				for (let illuData of list.figure_list) {
					if (id == illuData.id) {
						vo = illuData
						break
					}
				}
				let starCfg = local_outwardModelIns.upStarCfg[`${typeId_}@${id}@${vo.star}`]
				if (starCfg) {
					let nextCfg = local_outwardModelIns.upStarCfg[`${typeId_}@${id}@${vo.star + 1}`]
					let curAttr = local_json.parse(starCfg.attr)
					let nextAttr
					if (nextCfg) {
						nextAttr = local_json.parse(nextCfg.attr)
						if (curAttr.length == 0) {
							for (let vo of nextAttr) {
								curAttr.push([vo[0], 0])
							}
						}
					} else {
						nextAttr = {}
					}

					for (let i = curAttr.length - 1; i < propItemList_.length; i++) {
						let propItem: upStarPropItem = propItemList_[i];
						propItem.SetVisible(false);
					}

					for (let i = 0; i < curAttr.length; i++) {
						let propItem: upStarPropItem = propItemList_[i];
						if (!propItem) {
							propItem = new upStarPropItem(this.propGp)
							propItem.Load()
							propItemList_[i] = propItem
						}
						propItem.SetVisible(true);
						propItem.ExcuteCallback(() => {
							propItem.SetData(curAttr[i], nextAttr[i])
							RefGridLayout(this.propGp, this.attr_box, false)
						})
					}
					let type_list = local_outwardModelIns.outward_figure_list[typeId_]
					let info = type_list && type_list[id]
					if (info && info.star_combat != 0) {
						if(this.req_list[id]){
						this.fight_item.Updatefighting(info.star_combat);
						if (info.next_star_power == 0) {
							this.fight_item.UpdatefightingUp(0);
							this.fight_item.IsCenter(true, false);
						} else {
							this.fight_item.UpdatefightingUp(info.next_star_power - info.star_combat);
							this.fight_item.SetPowerOffset(this.fight_item.display_obj.width / 4);
							}
						}else{
							this.req_list[id]=1
							local_outwardModelIns.Fire(local_outwardModel.REQUEST_PROTO, 16007, "ci", typeId_, id)
						}
					} else {
						local_outwardModelIns.Fire(local_outwardModel.REQUEST_PROTO, 16027, "cc", typeId_, id)
					}
					this.needLb.width = 100
					let is_max = false
					let cost = local_json.parse(starCfg.cost)
					if (cost.length > 0) {
						this.matGp.visible = true
						this._lb_xiaohao.visible = true
						if (!costItem_) {
							costItem_ = new BaseAwardItem(this.matGp)
							costItem_.Load()
							costItem_.SetItemSize(70, 70)
						}
						costItem_.ExcuteCallback(() => {
							costItem_.SetData(cost[0][1])
						})
						costId_ = cost[0][1]
						let goodsNum = GoodsModel.GetInstance().GetTypeGoodsNum(cost[0][1])
						let color = "#0a953e"
						if (goodsNum < Number(cost[0][2])) {
							color = "#ff4f50"
						}
						this.needLb.innerHTML = Util.StrToHTML("<font color='" + color + "'>" + goodsNum + "</font>/" + cost[0][2])
						costItem_.visible = true
						Util.SetImageGray(this.upBtn, false)
						this.upLabel.text = "升星"
						this.upLabel.strokeColor = "#CC7652"
					} else {
						if (costItem_) {
							costItem_.visible = false
						}
						this.matGp.visible = false
						this._lb_xiaohao.visible = false
						this.needLb.innerHTML = ""
						this.upLabel.text = "已满级"
						this.upLabel.strokeColor = "#909090"
						Util.SetImageGray(this.upBtn, true)
						is_max = true
					}
					let i = 0
					do {

						i = i + 1
					} while ((i < 5))

					for (let i = 0; i < 5; i++) {
						let star_res
						let star_shaow
						let star_stage = Math.floor((vo.star - 1) / 5)
						star_stage = star_stage < 0 ? 0 : star_stage
						let star_num = vo.star - star_stage * 5
						if (star_stage == 1) {
							star_res = "pet_moon"
							star_shaow = "pet_moon_shaow"
						} else if (star_stage == 2) {
							star_res = "pet_son"
							star_shaow = "pet_son_shadow"
						} else {
							star_res = "pet_star"
							star_shaow = "pet_star_shadow"
						}
						starList_[i].visible = i < star_num
						shadowList[i].skin = GameResPath.GetPetPath(`${star_shaow}`) //`pet_json.${star_shaow}_png`
						starList_[i].skin = GameResPath.GetPetPath(`${star_res}`)// `pet_json.${star_res}_png`
					}
				}
			}
			oldItem_ = item
			selectedId_ = id
		}

		this.CreateModel = (figureId?) => {
			if (!figureId) {
				return
			}
			if (!model_id_ || model_id_ != figureId) {
				model_id_ = figureId
			} else {
				return
			}
			this.ClearModel()
			let pre_x = ""
			let default_str = ""
			let modelType = 1
			if (typeId_ == enum_OutWardType.Horse) {
				modelType = UI_MODEL_TYPE.HORSE
				pre_x = "h"
				default_str = "default_horse"
			} else if (typeId_ == enum_OutWardType.Wings) {
				modelType = UI_MODEL_TYPE.WING
				pre_x = "w"
				default_str = "default_wing"
			} else if (typeId_ == enum_OutWardType.Partner) {
				modelType = UI_MODEL_TYPE.SPRITE
				pre_x = "s"
				default_str = "default_sprite"
			} else if (typeId_ == enum_OutWardType.HolyDevice) {
				modelType = UI_MODEL_TYPE.WEAPON
				pre_x = "d"
				default_str = "default_weapon"
			} else if (typeId_ == enum_OutWardType.Artifact) {
				modelType = UI_MODEL_TYPE.ARTIFACT
				pre_x = "a"
				default_str = "default_artifact"
			}
			let action_list = null
			let action_key = typeId_ + "@1"
			let client_pos_cfg_ = local_resMgr.GetGameConfigFromCache(this, "ClientOutWardPos", true)
			let action_config = local_outwardModelIns.outward_action_cfg
			if (action_config && action_config[action_key]) {
				action_list = action_config[action_key].action_list
			}
			let model_res = figureId
			let pos_cfg = client_pos_cfg_[`${pre_x}_${model_res}`]
			if (!pos_cfg) {
				pos_cfg = client_pos_cfg_[default_str]
			}
			let temp_pos = { x: pos_cfg.position.x, y: pos_cfg.position.y }
			temp_pos.x = pos_cfg.x_offset ? pos_cfg.position.x + pos_cfg.x_offset : pos_cfg.position.x
			let data = {
				clothe_res_id: model_res,
				type: modelType,
				can_rotate: true,
				layer_value: this.layer_value,
				scale: pos_cfg && pos_cfg.scale,
				position: temp_pos,//&& pos_cfg.position,
				rotate: pos_cfg && pos_cfg.rotate,
				texture_size: new Vector2(567, 415),
				action_name_list: action_list,
				action_delta: true
				// custom_sorting_order = curr_sorting_order,
				// load_call_back = func,
			}
			if (data) {
				ResManager.GetInstance().SetRoleModel(this, this.modelGp, data)
			}
		}

		this.ClearModel = () => {
			if (!outward_model_) {
				return
			}
			outward_model_.DeleteMe()
			outward_model_ = null
		}

		this.DesFunc = () => {
			this.req_list={}
			this.ClearModel()

			if (this.fight_item) {
				this.fight_item.DeleteMe()
				this.fight_item = null
			}


			if (costItem_) {
				costItem_.DeleteMe()
				costItem_ = null
			}
			if (propItemList_) {
				for (let vo of propItemList_) {
					vo.DeleteMe()
					vo = null
				}
				propItemList_ = []
			}
			if (illuItemList_) {
				for (let key in illuItemList_) {
					illuItemList_[key].DeleteMe()
					delete illuItemList_[key]
				}
				illuItemList_ = {}
			}
			this.ClearUIEffect(this.effectGp)
			oldItem_ = null
			typeId_ = null
			model_id_ = null
		}
	}

	public Open(...parms) {
		this.MyOpen(...parms)
	}


	bg1: Laya.Image
	bg2: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	title: Laya.Image
	_Image5: Laya.Image
	_lb_shuxing: Laya.Label
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	matGp: Laya.Box
	_Scroller1: Laya.Panel
	propGp: Laya.Box
	scroller: Laya.Panel
	illuGp: Laya.HBox
	needLb: Laya.HTMLDivElement
	_lb_xiaohao: Laya.Label
	nameLb: Laya.Label
	modelGp: Laya.Box
	closeBtn: Laya.Image
	shadowGp: Laya.HBox
	_Image9: Laya.Image
	_Image10: Laya.Image
	_Image11: Laya.Image
	_Image12: Laya.Image
	_Image13: Laya.Image
	starGp: Laya.HBox
	_Image14: Laya.Image
	_Image15: Laya.Image
	_Image16: Laya.Image
	_Image17: Laya.Image
	_Image18: Laya.Image
	_gp_fight: Laya.Box
	effectGp: Laya.Box
	upBtn: Laya.Box
	upImg: Laya.Image
	upLabel: Laya.Label
	reddot: Laya.Image
	public GetComponents() {
		[
			this.bg1,
			this.bg2,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image4,
			this.title,
			this._Image5,
			this._lb_shuxing,
			this._Image6,
			this._Image7,
			this._Image8,
			this.matGp,
			this._Scroller1,
			this.propGp,
			this.scroller,
			this.illuGp,
			this.needLb,
			this._lb_xiaohao,
			this.nameLb,
			this.modelGp,
			this.closeBtn,
			this.shadowGp,
			this._Image9,
			this._Image10,
			this._Image11,
			this._Image12,
			this._Image13,
			this.starGp,
			this._Image14,
			this._Image15,
			this._Image16,
			this._Image17,
			this._Image18,
			this._gp_fight,
			this.effectGp,
			this.upBtn,
			this.upImg,
			this.upLabel,
			this.reddot,
		]
			= this.GetChildrenByNames([

				"bg1",
				"bg2",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Image4",
				"title",
				"_Image5",
				"_lb_shuxing",
				"_Image6",
				"_Image7",
				"_Image8",
				"matGp",
				"_Scroller1",
				"propGp",
				"scroller",
				"illuGp",
				"needLb",
				"_lb_xiaohao",
				"nameLb",
				"modelGp",
				"closeBtn",
				"shadowGp",
				"_Image9",
				"_Image10",
				"_Image11",
				"_Image12",
				"_Image13",
				"starGp",
				"_Image14",
				"_Image15",
				"_Image16",
				"_Image17",
				"_Image18",
				"_gp_fight",
				"effectGp",
				"upBtn",
				"upImg",
				"upLabel",
				"reddot",
			])
		this.needLb.style.fontSize = 20
		this.needLb.style.color = "#d15e00"
		this._Scroller1.vScrollBar.visible = false
		this.scroller.hScrollBar.visible = false
	}
}
window["OutwardStarView"] = OutwardStarView