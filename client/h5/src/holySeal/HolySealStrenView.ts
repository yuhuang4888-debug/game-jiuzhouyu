import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { WordManager } from "../common/WordManager"
import { EquipEvent } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { ShopModel } from "../commonModel/ShopModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { RefBoxChildsLayout, SetHtmlStyle, Util } from "../util/Util"
import { HolySealStrenEquipItem } from "./HolySealStrenEquipItem"
import { HolySealView } from "./HolySealView"

export class HolySealStrenView extends BaseView1 {
	//eui
	private _img_selcet: Laya.Image

	LoadSuccess
	InitEvent
	InitView
	GetDefaultIndex
	InitEquip
	UpdateEquip
	ClickFunc
	SwitchItem
	Remove
	UpdateView
	SetAttr2Label
	UpdateCost
	UpdateStren

	AddStrenEffect
	GetEffectBox
	effect_box_list = []
	InitEffectBox
	start_pos = {}
	cur_money_type
	ClickAuto
	private aotoing: boolean = false;
	private upType: number = -1;
	public constructor() {
		super()
		this.base_file = "holySeal"
		this.layout_file = "HolySealStrenView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		let model = HolySealModel.GetInstance(),
			res_mgr = ResManager.GetInstance(),
			local_Util = Util,
			goods_model = GoodsModel.GetInstance(),
			local_HolySealModel = HolySealModel,
			local_TimeUtil = TimeUtil,


			// equip_pos_ = [
			// 	{ x: 501, y: 123 },
			// 	{ x: 375, y: 27 },
			// 	{ x: 229, y: 34 },
			// 	{ x: 112, y: 146 },
			// 	{ x: 93, y: 292 },
			// 	{ x: 188, y: 427 },
			// 	{ x: 384, y: 185 },
			// 	{ x: 257, y: 310 },
			// 	{ x: 385, y: 435 },
			// 	{ x: 512, y: 314 },
			// 	{ x: 384, y: 314 },
			// ],
			equip_list_,
			default_type_ = 1,
			now_index_,
			basic_,
			cost_count_ = 0

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.destroy_callback = () => {
			this.Remove()
		}

		this.close_callback = () => {
			this.aotoing = false;
		}

		this.preload_server_config = {
			"config_seal_strong": false,
			"config_seal_kv": false,
			"GoodsSubtype": false
		}
		this.LoadSuccess = () => {

			ResManager.GetInstance().SetTexture(this, this._img_bg3, GameResPath.GetIcon("holySeal", "ui_seal_bg1"))
			ResManager.GetInstance().SetTexture(this, this._img_bg4, GameResPath.GetIcon("holySeal", "ui_seal_01"))

			if (PlatformManager.IsEyouEnPlatform()) {
				this._lb_none.width = 480;
				this._lb_none.wordWrap = true;
				// this._lb_desc.width = 440;
				// this._lb_desc.wordWrap = true;
			}

			SetHtmlStyle(this._lb_cost, { c: "#93847D", f: 24, w: 400, ww: false })

			this._lb_now_attr.style.fontSize = 22
			this._lb_now_attr.style.color = "#93847D"
			this._lb_now_attr.style.leading = 16

			this._lb_next_attr.style.fontSize = 22
			this._lb_next_attr.style.color = "#93847D"
			this._lb_next_attr.style.leading = 16


			this._img_selcet = new Laya.Image()
			ResManager.GetInstance().SetImageSprite(this, this._img_selcet, "common", "com_selectbg5")
			// this._img_selcet.centerX = this._img_selcet.centerY = 0
			let config_seal_kv = res_mgr.GetGameConfigFromCache(this, "config_seal_kv", false)

			this.cur_money_type = model.GetkeyValue(2, config_seal_kv)
			res_mgr.SetTexture(this, this._img_cost_icon, GameResPath.GetGoodsIconPath(this.cur_money_type))

			this.InitEffectBox()


			this.InitView()
			this.InitEvent()
		}

		this.InitEvent = () => {



			// Util.AddClickEvent(this.box_cost, ()=>{
			// 	if(this.cur_money_type){
			// 		let arr=ShopModel.GetInstance().MoneyIsEnough(this.cur_money_type)
			// 		UIToolTipMgr.GetInstance().DefaultAppendTips(this.cur_money_type,arr[2]);
			// 	}

			// }, this,false);

			local_Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)


			local_Util.AddClickEvent(this._gp_stren, () => {
				if (this.aotoing) {
					Message.show("自动强化中");
				}

				let sub_type = HolySealView.GetEquipTypeByPos(now_index_)
				let data = model.GetWearEquipByPos(sub_type)
				if (data) {
					this.upType = 0;
					this.start_pos = { x: this._gp_stren.x + this._gp_stren.width / 2, y: this._gp_stren.y + this._gp_stren.height / 2 }
					model.Fire(local_HolySealModel.REQUEST_CCMD_EVENT, 65402, sub_type, 0)
				}
				else {
					Message.show("请先穿戴影装")
				}
			}, this, true)

			local_Util.AddClickEvent(this._gp_auto, () => {

				if (!this._img_stren_red.visible) {

					//获取到一个新的可合成的强化位置
					let sel_index = this.GetDefaultIndex()
					let cost_count = undefined

					let sub_type = HolySealView.GetEquipTypeByPos(sel_index)
					let data = model.GetWearEquipByPos(sub_type)
					if (data) {
						let config_seal_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seal_equip", false)
						let equip_data = model.GetHolySealData(data.type_id, config_seal_equip)
						let max_stren = equip_data.strong
						let stren_lv = model.GetHolySealStrenDate(sub_type)

						if (stren_lv + 1 > max_stren) {
							cost_count = undefined
						}
						else {
							let seal_strong_cfgs = res_mgr.GetGameConfigFromCache(this, "config_seal_strong", false)
							let next_stren_cfg = model.GetHolySealStrenCfg(sub_type, stren_lv + 1, seal_strong_cfgs)
							let cost = next_stren_cfg.cost
							let value = 0
							if (cost != "[]") {
								cost = JSON.parse(cost)
								value = cost && cost[0] && cost[0][2]
							}
							cost_count = value
						}
					}

					if(cost_count!=undefined){
						let have = goods_model.GetSpecialScore(local_HolySealModel.MONEY_TYPE)
						if (have >= cost_count) {
							this.SwitchItem(sel_index)
							this.ClickAuto()
						}else{
							Message.show("货币不足")
						}
					}else{
						Message.show("货币不足")
					}
					
					return 
				}


				this.ClickAuto()

			}, this, true)


			this.BindEvent(goods_model, GoodsModel.UPDATE_SPECIAL_SCORE, (vo) => {
				if (vo.currency_id == local_HolySealModel.MONEY_TYPE) {
					this.UpdateCost()
				}
			})

			let next_time
			this.BindEvent(model, local_HolySealModel.STREN_SUCCESS, (pos_id) => {
				let sub_type = HolySealView.GetEquipTypeByPos(now_index_)
				if (pos_id == sub_type) {
					this.UpdateStren(true)
					// if (!next_time || next_time < local_TimeUtil.getServerTime()) {
					// 	next_time = local_TimeUtil.getServerTime() + 1
					// 	this.AddUIEffect("ui_qianghuachenggong", this._gp_effect)
					// }

					//播放特效
					if (!this.start_pos) {
						this.start_pos = { x: this._gp_stren.x + this._gp_stren.width / 2, y: this._gp_stren.y + this._gp_stren.height / 2 }
					}
					this.AddStrenEffect(now_index_, this.start_pos)
				}

				if (this.aotoing && this.upType == 1) {
					let minIndex: number = this.GetDefaultIndex();
					if (minIndex != now_index_) {
						this.SwitchItem(this.GetDefaultIndex());
						sub_type = HolySealView.GetEquipTypeByPos(minIndex)
					}
					if (this._img_stren_red.visible) {
						Laya.timer.once(100, this, () => {
							model.Fire(local_HolySealModel.REQUEST_CCMD_EVENT, 65402, sub_type, 0)
						})
					} else {
						this.setState();
					}
				} else {
					this.setState();
				}
			})
		}



		this.ClickAuto = () => {
			let sub_type = HolySealView.GetEquipTypeByPos(now_index_)
			let data = model.GetWearEquipByPos(sub_type)
			if (data) {
				this.upType = 1;
				if (this.aotoing) {
					this.aotoing = false;
					this.setBtn();
				} else {
					this.aotoing = true;
					this.setBtn();
					let minIndex: number = this.GetDefaultIndex();
					if (minIndex != now_index_) {
						this.SwitchItem(this.GetDefaultIndex());
						sub_type = HolySealView.GetEquipTypeByPos(minIndex)
					}

					this.start_pos = { x: this._gp_auto.x + this._gp_auto.width / 2, y: this._gp_auto.y + this._gp_auto.height / 2 }
					model.Fire(local_HolySealModel.REQUEST_CCMD_EVENT, 65402, sub_type, 0)
				}
			} else {
				Message.show("请先穿戴影装")
			}
		}


		this.InitView = () => {
			this.InitEquip()
			this.UpdateEquip()
			this.SwitchItem(this.GetDefaultIndex())
		}

		//默认打开强化等级最低的
		this.GetDefaultIndex = () => {
			let stren_data = model.stren_data
			let min_sub_type
			let min_lv = 99999
			for (let pos in stren_data) {
				let equip_data = model.GetWearEquipByPos(pos)
				if (!equip_data) {
					continue
				}

				let lv = stren_data[pos]
				if (!lv) {
					min_sub_type = pos
					break
				}
				let config_seal_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seal_equip", false)
				let holy_data = model.GetHolySealData(equip_data.type_id, config_seal_equip)
				let max_lv = holy_data.strong
				if (min_lv > lv && max_lv > lv + 1) {
					min_lv = lv
					min_sub_type = pos
				}
			}

			if (min_sub_type == undefined) {
				min_sub_type = default_type_
			}


			let sub_type, index = 1
			for (let i = 1; i <= local_HolySealModel.EQUIP_COUNT; i++) {
				sub_type = HolySealView.GetEquipTypeByPos(i)
				if (sub_type == min_sub_type) {
					index = i
					break
				}
			}

			return index
		}

		this.InitEquip = () => {
			if (!equip_list_)
				equip_list_ = {}
			let item: HolySealStrenEquipItem
			for (let i = 1; i <= local_HolySealModel.EQUIP_COUNT; i++) {
				item = new HolySealStrenEquipItem(this._gp_equips)
				equip_list_[i] = item
				let pos = this.GetPos(i - 1)
				item.SetPosition(pos.x, pos.y)
				item.SetClickCallBackAndPos(this.ClickFunc, i)
				item.Load()
			}

		}

		this.UpdateEquip = () => {
			let list = goods_model.wear_holy_seal_list
			let equip, sub_type
			for (let i = 1; i <= local_HolySealModel.EQUIP_COUNT; i++) {
				sub_type = HolySealView.GetEquipTypeByPos(i)
				equip = list[sub_type - 1]
				if (!equip) {
					equip = {
						equip_type: sub_type,
						type_id: 0
					}
				}
				equip_list_[i].SetData(equip)
			}
		}

		this.ClickFunc = (pos) => {
			this.SwitchItem(pos)
		}

		this.SwitchItem = (index) => {
			if (now_index_ == index) {
				return
			}

			let item: HolySealStrenEquipItem = equip_list_[now_index_]
			if (item) {
				item.SetSelcetImg(undefined)
			}

			item = equip_list_[index]
			if (item) {
				item.SetSelcetImg(this._img_selcet)
			}

			now_index_ = index

			this.UpdateView()
		}

		this.Remove = () => {

			for (let i in this.effect_box_list) {
				let item = this.effect_box_list[i]
				item.destroy()
			}
			this.effect_box_list = []


			if (equip_list_) {
				for (let pos in equip_list_) {
					let obj = equip_list_[pos]
					if (obj)
						obj.DeleteMe()
				}
				equip_list_ = undefined
			}
			now_index_ = undefined
			cost_count_ = 0
		}

		this.UpdateView = () => {
			let sub_type = HolySealView.GetEquipTypeByPos(now_index_)
			let data = model.GetWearEquipByPos(sub_type)
			if (data) {

				this._gp_con.visible = this._img_bg2.visible = this._lb_name.visible = true
				this._lb_none.visible = false

				let basic = goods_model.GetGoodsBasicByTypeId(data.type_id)
				this._lb_name.text = basic.goods_name
				// this._lb_name.color = ColorUtil.GetColorDark(basic.color, false)

				this.UpdateStren()
			}
			else {
				this._lb_none.visible = true
				this._gp_con.visible = this._img_bg2.visible = this._lb_name.visible = false
			}
		}

		this.SetAttr2Label = (attr_list, label: Laya.HTMLDivElement, value_color) => {
			let str = ""
			attr_list.forEach((val, idx, array) => {
				str += `${WordManager.GetProperties(val[0])}:${Util.HtmlColorTxt(val[1], value_color)}<br/>`
			})
			label.innerHTML = str
			label.style.width = 400
		}


		this.UpdateCost = () => {
			let have = goods_model.GetSpecialScore(local_HolySealModel.MONEY_TYPE)
			let color = have < cost_count_ ? "'#ff4f50'" : "'#93847D'"
			if (cost_count_ != undefined) {
				this._lb_cost.innerHTML = `消耗：${local_Util.HtmlColorTxt(have, color)}/${cost_count_}`
				this._img_stren_red.visible = have >= cost_count_;
				this._img_auto_red.visible = !this.aotoing && have >= cost_count_;

				RefBoxChildsLayout(this.box_cost, 5, null, true, "center")
			}
			else {
				this._img_stren_red.visible = this._img_auto_red.visible = false
			}
		}

		this.UpdateStren = (stren_success = false) => {
			let sub_type = HolySealView.GetEquipTypeByPos(now_index_)
			let data = model.GetWearEquipByPos(sub_type)
			if (data) {
				let config_seal_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seal_equip", false)

				let equip_data = model.GetHolySealData(data.type_id, config_seal_equip)

				let max_stren = equip_data.strong

				let stren_lv = model.GetHolySealStrenDate(sub_type)
				let GoodsSubtype = ResManager.GetInstance().GetGameConfigFromCache(this, "GoodsSubtype", false)
				this._lb_stren_lv.text = `${stren_lv}级${model.GetEquipTypeName(sub_type, GoodsSubtype)}`

				let seal_strong_cfgs = res_mgr.GetGameConfigFromCache(this, "config_seal_strong", false)

				let now_stren_cfg = model.GetHolySealStrenCfg(sub_type, stren_lv, seal_strong_cfgs)

				let add_attr = JSON.parse(now_stren_cfg.add_attr)
				this.SetAttr2Label(add_attr, this._lb_now_attr, "'#4a3a32'")

				if (stren_lv + 1 > max_stren) {
					this.box_cost.visible = this._lb_next_attr.visible = false
					this._img_max.visible = true
					cost_count_ = undefined
					this.UpdateCost()
					if (stren_success) {
						this.SwitchItem(this.GetDefaultIndex())
					}
				}
				else {
					this._img_max.visible = false
					this.box_cost.visible = this._lb_next_attr.visible = true

					let seal_strong_cfgs = res_mgr.GetGameConfigFromCache(this, "config_seal_strong", false)
					let next_stren_cfg = model.GetHolySealStrenCfg(sub_type, stren_lv + 1, seal_strong_cfgs)
					let cost = next_stren_cfg.cost
					let value = 0
					if (cost != "[]") {
						cost = JSON.parse(cost)
						value = cost && cost[0] && cost[0][2]
					}
					cost_count_ = value

					this.UpdateCost()
					let add_attr = JSON.parse(next_stren_cfg.add_attr)
					this.SetAttr2Label(add_attr, this._lb_next_attr, "'#639c12'")
				}
			}
		}


		this.AddStrenEffect = (index, start_pos) => {
			if (this.use_delete_method) {
				return
			}
			let anim_time = 0.45
			let anim_time2 = 0.1

			let real_pos = this.GetPos(index - 1)

			let right = real_pos.x > start_pos.x ? true : false
			let scale_x = right ? -1 : 1

			let space = 50
			let end_x = real_pos.x + space
			let end_y = real_pos.y + space

			// // 旋转角度计算
			let tan = Math.abs(start_pos.y - end_y) / Math.abs(end_x - start_pos.x)
			let rotate = 90 - Math.atan(tan) * 180 / Math.PI
			let end_rota = right ? rotate : -rotate

			let new_obj = false
			let effect_box = this.GetEffectBox()
			if (!effect_box) {
				new_obj = true
				effect_box = new Laya.Box()
				effect_box.width = this.display_obj.width
				effect_box.height = this.display_obj.height
				effect_box.anchorX = 0.5
				effect_box.anchorY = 0.5
				this.display_obj.addChild(effect_box)
				this.effect_box_list.push(effect_box)
			}
			effect_box.x = start_pos.x
			effect_box.y = start_pos.y
			effect_box.alpha = 0
			effect_box.rotation = end_rota
			// effect_box.scaleX = scale_x
			effect_box.scaleY = 0
			effect_box.visible = true

			let play_anim = () => {
				// SYTweenLite.to(this, effect_box, SYTweenLite.UiAnimationType.ROTATION, end_rota, anim_time2)
				SYTweenLite.to(this, effect_box, SYTweenLite.UiAnimationType.ALPHA, 1, anim_time2)
				SYTweenLite.to(this, effect_box, SYTweenLite.UiAnimationType.SCALE, { x: scale_x, y: 1 }, anim_time2)
				SYTweenLite.to(this, effect_box, SYTweenLite.UiAnimationType.POS, { x: end_x, y: end_y }, anim_time, () => {
					effect_box.visible = false
					model.Fire(HolySealModel.PLAY_END_EFFECT, index)
				})
			}
			if (new_obj) {
				this.AddUIEffect("TuoW", effect_box, null, { x: 1, y: -1, z: 1 }, true, null, null, () => {
					play_anim()
				}, null, null, null, null, false)
			} else {
				play_anim()
			}
		}


		this.GetEffectBox = () => {
			for (let i in this.effect_box_list) {
				let item = this.effect_box_list[i]
				if (item && !item.visible) {
					return item
				}
			}
		}


		this.InitEffectBox = () => {
			let count = 10
			for (let i = 0; i < count; i++) {
				let effect_box = new Laya.Box()
				effect_box.width = this.display_obj.width
				effect_box.height = this.display_obj.height
				effect_box.anchorX = 0.5
				effect_box.anchorY = 0.5
				this.display_obj.addChild(effect_box)
				this.effect_box_list.push(effect_box)
				effect_box.visible = false
				this.AddUIEffect("TuoW", effect_box, null, { x: 1, y: -1, z: 1 }, true, null, null, null, null, null, null, null, false)
			}
		}
	}

	private setState() {
		Laya.timer.clearAll(this);
		this.aotoing = false;
		this.upType = -1;
		this.setBtn()
	}

	private setBtn() {
		if (this.aotoing) {
			this._Label2.strokeColor = '#3e9298';
			this._Label2.text = '停止自动';
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image18, GameResPath.GetIcon("common", "com_rect_btn2"))
		} else {
			this._Label2.text = '自动强化';
			this._Label2.strokeColor = '#cc6038';
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image18, GameResPath.GetIcon("common", "com_rect_btn1"))
		}
		this.UpdateCost();
	}

	GetPos(index?) {
		return ([
			//外圈 右到左
			{ x: 441, y: 173 },
			{ x: 310, y: 97 },
			{ x: 161, y: 124 },
			{ x: 63, y: 240 },
			{ x: 63, y: 391 },
			{ x: 161, y: 508 },
			//内圈 上左下右
			{ x: 336, y: 258 },
			{ x: 218, y: 380 },
			{ x: 336, y: 500 },
			{ x: 456, y: 380 },
			//中间

			{ x: 336, y: 380 }])[index]
	}


	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_img_bg5: Laya.Image
	_img_bg6: Laya.Image
	_img_bg7: Laya.Image
	_lb_title: Laya.Label
	_lb_name: Laya.Label
	_lb_none: Laya.Label
	_gp_con: Laya.Box
	_Image15: Laya.Image
	_Group2: Laya.Box
	_lb_now_attr: Laya.HTMLDivElement
	_Image16: Laya.Image
	_lb_next_attr: Laya.HTMLDivElement
	_lb_stren_lv: Laya.Label
	_img_max: Laya.Image
	box_cost: Laya.Box
	_img_cost_icon: Laya.Image
	_lb_cost: Laya.HTMLDivElement
	_gp_stren: Laya.Box
	_Image17: Laya.Image
	_Label1: Laya.Label
	_img_stren_red: Laya.Image
	_gp_auto: Laya.Box
	_Image18: Laya.Image
	_Label2: Laya.Label
	_img_auto_red: Laya.Image
	_Image19: Laya.Image
	_Label3: Laya.Label
	_gp_equips: Laya.Box
	_gp_effect: Laya.Box
	_img_close: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._img_bg4,
			this._img_bg5,
			this._img_bg6,
			this._img_bg7,
			this._lb_title,
			this._lb_name,
			this._lb_none,
			this._gp_con,
			this._Image15,
			this._Group2,
			this._lb_now_attr,
			this._Image16,
			this._lb_next_attr,
			this._lb_stren_lv,
			this._img_max,
			this.box_cost,
			this._img_cost_icon,
			this._lb_cost,
			this._gp_stren,
			this._Image17,
			this._Label1,
			this._img_stren_red,
			this._gp_auto,
			this._Image18,
			this._Label2,
			this._img_auto_red,
			this._Image19,
			this._Label3,
			this._gp_equips,
			this._gp_effect,
			this._img_close,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_img_bg4",
				"_img_bg5",
				"_img_bg6",
				"_img_bg7",
				"_lb_title",
				"_lb_name",
				"_lb_none",
				"_gp_con",
				"_Image15",
				"_Group2",
				"_lb_now_attr",
				"_Image16",
				"_lb_next_attr",
				"_lb_stren_lv",
				"_img_max",
				"box_cost",
				"_img_cost_icon",
				"_lb_cost",
				"_gp_stren",
				"_Image17",
				"_Label1",
				"_img_stren_red",
				"_gp_auto",
				"_Image18",
				"_Label2",
				"_img_auto_red",
				"_Image19",
				"_Label3",
				"_gp_equips",
				"_gp_effect",
				"_img_close",
			])
	}
}
window["HolySealStrenView"] = HolySealStrenView