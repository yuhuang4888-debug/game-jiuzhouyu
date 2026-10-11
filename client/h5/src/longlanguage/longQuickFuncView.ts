import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { ColorType } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { longlangModel } from "../commonModel/longlangModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { CompositeModel } from "../commonModel/CompositeModel"
import { CompositeEvent } from "../commonModel/CompositeModel"

export class longQuickFuncView extends BaseView1 {
	CloseFunc
	GetImg
	InitView
	Open
	needGp

	public constructor() {
		super()
		this.base_file = "longlanguage"
		this.layout_file = "longQuickFuncView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.click_bg_toClose = true
		this.use_background = true
		this.destroy_imm = true
		this.show_open_movie = true

		let local_erlang = ErlangParser.GetInstance()
		let local_goodsModelIns = GoodsModel.GetInstance()
		let model = longlangModel.GetInstance()
		let item1_ = null
		let item2_ = null
		let matList_ = []
		let type_ = null
		let data_ = null
		let now_compose_data_ = null

		this.load_callback = () => {
			this._lb_cost.style.fontSize = 22
			this._lb_cost.style.color = "#663915"
			this._lb_cost.style.wordWrap = false
			if (data_) {
				this.InitView()
			}
		}

		this.open_callback = () => {
		}

		this.close_callback = () => {
			this.CloseFunc()
		}

		this.InitView = () => {
			let id = (type_ == 0 && (model.UpStageCfg[String(data_.type_id)]) || (model.UpColorCfg[String(data_.type_id)]))
			let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, id, false)
			let equipCfg = Config.PRELOAD_SERVER_CONFIG.config_draconic_equip
			if (cfg) {
				let curData = equipCfg[data_.type_id]
				let Info1 = this.GetImg(data_.color)
				ResManager.GetInstance().SetImageSprite(this, this.lvImg0, "longlanguage", "uisjts_0" + Info1[0])
				this.lvLb0.text = curData.stage + "阶"
				let targetCfg = cfg
				now_compose_data_ = {
					id: targetCfg.id,
					subtype: targetCfg.subtype,
					regular_mat: local_erlang.Parse(targetCfg.regular_mat),
					irregular_mat: local_erlang.Parse(targetCfg.irregular_mat),
					goods: local_erlang.Parse(targetCfg.goods),
					hole_list: local_erlang.Parse(targetCfg.hole_list),
					ratio: local_erlang.Parse(targetCfg.ratio)
				}
				let regular_mat_cfg = now_compose_data_.regular_mat
				let regular_mat_dic = []
				for (let key in regular_mat_cfg) {
					let value = regular_mat_cfg[key]
					let vo = value[0]
					if (!regular_mat_dic[vo[1]]) {
						regular_mat_dic[vo[1]] = Number(vo[2])
					} else {
						regular_mat_dic[vo[1]] = regular_mat_dic[vo[1]] + Number(vo[2])
					}
				}
				now_compose_data_.regular_mat = regular_mat_dic
				let targetBasic = null
				if (targetCfg) {
					let goods = now_compose_data_.goods
					targetBasic = local_goodsModelIns.GetGoodsBasicByTypeId(goods[0] && goods[0][1])
				}
				if (targetBasic) {
					let nextData = equipCfg[targetBasic.type_id]
					let Info2 = this.GetImg(targetBasic.color)
					ResManager.GetInstance().SetImageSprite(this, this.lvImg1, "longlanguage", "uisjts_0" + Info2[0])
					this.lvLb1.text = nextData.stage + "阶"
					if (!item2_) {
						item2_ = new EquipmentItem(this.itemGp1)
						item2_.Load()
						item2_.SetItemSize(100, 100)
					}
					item2_.SetData(targetBasic.type_id)
				}
				if (!item1_) {
					item1_ = new EquipmentItem(this.itemGp0)
					item1_.Load()
					item1_.SetItemSize(100, 100)
				}
				item1_.SetData(data_.type_id)
				let mat = local_erlang.Parse(targetCfg.regular_mat)
				let index = 0
				let i = mat.length == 1 ? 0 : 1
				do {
					let matInfo = mat[i][0]
					let item = matList_[index]
					if (!item) {
						item = new EquipmentItem(this._cost_item)
						item.Load()
						item.SetItemSize(90, 90)
						matList_[index] = item
					}
					if (mat.length == 1) {
						matInfo[2] = matInfo[2] - 1
					}
					let [type_id, bind] = local_goodsModelIns.GetMappingTypeId(matInfo[0], matInfo[1])
					// let goodsbasic = local_goodsModelIns.GetGoodsBasicByTypeId(type_id)
					item.SetData(type_id)
					item.ExcuteCallback(() => {
						let myhave = local_goodsModelIns.GetTypeGoodsNum(type_id)
						if (type_id == curData.id) {
							myhave = myhave - 1
						}
						let color = myhave >= Number(matInfo[2]) ? "#0a953e" : "#ff4f50"
						this._lb_cost.innerHTML = "材料消耗：<font color='" + color + "'>" + myhave + "</font>/" + matInfo[2]
						this._gp_cost.callLater(()=>{
							if(this.use_delete_method) return
							this._gp_cost.event(Laya.Event.RESIZE)
						})
						//item.ForceSetNumberInFlow(Util.StrToHTML("<font color='" + color + "'>" + myhave + "</font>/" + matInfo[2]))
					}
					)
					i = i + 1; index = index + 1
				} while ((i < mat.length))
			}

			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.enterBtn, () => {
				if (!now_compose_data_) {
					return
				}
				let rule_id = now_compose_data_.id
				let regular_list = []
				let regular_mat = now_compose_data_.regular_mat
				let isBind = false
				let use = false
				let selectList = []
				for (let type_id in regular_mat) {
					let count = regular_mat[type_id]
					let contin
					if (Number(type_id) == data_.type_id && !use) {
						table.insert(regular_list, data_.goods_id)
						count = count - 1
						selectList[data_.goods_id] = true
						if (count <= 0) {
							contin = true
						}
					}
					if (!contin) {
						let goods_list = local_goodsModelIns.GetTypeGoods(Number(type_id))
						if (goods_list) {
							for (let index in goods_list) {
								let goods_vo = goods_list[index]
								if (!selectList[goods_vo.goods_id]) {
									let i = 0
									do {
										table.insert(regular_list, goods_vo.goods_id)
										count = count - 1
										if (count <= 0) {
											break
										}
										i = i + 1
									} while ((i < goods_vo.goods_num))
									if (count <= 0) {
										break
									}
									if (goods_vo.bind) {
										isBind = true
									}
								}
							}
						}
					}
				}
				let irregular_list = []
				let okFunc = () => {
					CompositeModel.GetInstance().Fire(CompositeEvent.REQUEST_PROTO, rule_id, regular_list, irregular_list)
					if (type_ == 0) {
						model.comId = rule_id
					}
				}

				okFunc()
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this.cancelBtn, () => {
				this.Close()
			}
				, this, true)
			if (type_ == longlangModel.upStage) {
				this.tips.text = "粉色品质以下装备可进行升阶操作\n升阶需消耗以下材料，是否继续进行操作？"
				this._lb_title.text = "升阶提示"
			} else {
				this.tips.text = "当前装备晋升至下一品质\n需要消耗以下材料,是否继续进行操作?"
				this._lb_title.text = "品质提升"
			}
		}

		this.Open = (...new_args) => {
			let parms = new_args
			if (parms) {
				data_ = parms[0]
				type_ = parms[1]
				if (this.is_loaded) {
					this.InitView()
				}
			}
			super.Open()
		}

		this.CloseFunc = () => {
			if (item1_) {
				item1_.DeleteMe()
				item1_ = null
			}
			if (item2_) {
				item2_.DeleteMe()
				item2_ = null
			}
			if (matList_) {
				for (let _tmpi in matList_) {
					let vo = matList_[_tmpi]
					vo.DeleteMe()
				}
				matList_ = []
			}
			data_ = null
		}

		this.GetImg = (color?) => {
			let cStr = null
			let tStr = "#6193ca"
			let local_colorType = ColorType
			if (local_colorType.PURPLE == color) {
				cStr = "07"
				tStr = "#9f71d2"
			} else if (local_colorType.ORANGE == color) {
				cStr = "05"
				tStr = "#e37e35"
			} else if (local_colorType.RED == color) {
				cStr = "09"
				tStr = "#ed674b"
			} else if (local_colorType.PINK == color) {
				cStr = "04"
				tStr = "#e85070"
			} else if (local_colorType.GREEN == color) {
				cStr = "06"
				tStr = "#2cbd1d"
			} else if ("default" == color) {
				cStr = "08"
				tStr = "#6193ca"
			}
			return [cStr, tStr]
		}
	}

	bg: Laya.Image
	bg2: Laya.Image
	_img_title: Laya.Image
	_lb_title: Laya.Label
	_img_close: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	lvImg0: Laya.Image
	lvImg1: Laya.Image
	tips: Laya.Label
	itemGp0: Laya.Box
	itemGp1: Laya.Box
	lvLb0: Laya.Label
	lvLb1: Laya.Label
	cancelBtn: Laya.Box
	_Image211: Laya.Image
	_Label11: Laya.Label
	enterBtn: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	_gp_cost: Laya.HBox
	_cost_item: Laya.Box
	_lb_cost: Laya.HTMLDivElement
	public GetComponents() {
		[
			this.bg,
			this.bg2,
			this._img_title,
			this._lb_title,
			this._img_close,
			this._Image4,
			this._Image5,
			this._Image6,
			this.lvImg0,
			this.lvImg1,
			this.tips,
			this.itemGp0,
			this.itemGp1,
			this.lvLb0,
			this.lvLb1,
			this.cancelBtn,
			this._Image211,
			this._Label11,
			this.enterBtn,
			this._Image2,
			this._Label1,
			this._gp_cost,
			this._cost_item,
			this._lb_cost,
		]
			= this.GetChildrenByNames([

				"bg",
				"bg2",
				"_img_title",
				"_lb_title",
				"_img_close",
				"_Image4",
				"_Image5",
				"_Image6",
				"lvImg0",
				"lvImg1",
				"tips",
				"itemGp0",
				"itemGp1",
				"lvLb0",
				"lvLb1",
				"cancelBtn",
				"_Image211",
				"_Label11",
				"enterBtn",
				"_Image2",
				"_Label1",
				"_gp_cost",
				"_cost_item",
				"_lb_cost",
			])
	}
}
window["longQuickFuncView"] = longQuickFuncView