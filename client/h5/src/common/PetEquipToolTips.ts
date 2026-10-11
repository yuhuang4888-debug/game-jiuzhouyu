import { GoodsModel } from "../commonModel/GoodsModel";
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel";
import { PetEquipEvent } from "../commonModel/PetEquipDefine";
import { PetEquipModel } from "../commonModel/PetEquipModel";
import { RoleManager } from "../commonModel/RoleManager";
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { Util, Trim, HtmlColorTxt, GetSizeDeltaY, SetSizeDeltaY } from "../util/Util";
import { BaseView1 } from "./BaseView1";
import { EquipmentItem } from "./EquipmentItem";
import { EventName } from "./EventName";
import { Enum_UILayer } from "./LayerManager";
import { ResManager } from "./ResManager";
import { LuaSoundManager } from "./SoundManager";
import { WithBtnHSlider } from "./WithBtnHSlider";
import { WordManager } from "./WordManager";

export class PetEquipToolTips extends BaseView1 {
	_img_bg: Laya.Image
	_gp_icon: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_lb_name: Laya.Label
	_lb_rating: Laya.HTMLDivElement
	_lb_level: Laya.HTMLDivElement
	_Scroller1: Laya.Panel
	Content: Laya.Box
	_Image3: Laya.Image
	_Label1: Laya.Label
	_lb_base_attr: Laya.HTMLDivElement
	_Group3: Laya.Box
	_Image4: Laya.Image
	_lb_career: Laya.HTMLDivElement
	_lb_pos: Laya.HTMLDivElement
	_gp_btns: Laya.Box
	_btn_close: Laya.Box
	_btn_close_img: Laya.Image
	_btn_close_lb: Laya.Label
	_btn_replace: Laya.Box
	_btn_replace_img: Laya.Image
	_reddot: Laya.Image
	_btn_replace_lb: Laya.Label
	_btn_equip: Laya.Box
	_btn_equip_img: Laya.Image
	_btn_equip_lb: Laya.Label


	private role_id: number = 0
	private type_id: number = 0
	private pos_x: number = 0
	private pos_y: number = 0
	private goods_vo: any = null
	private goods_icon: EquipmentItem
	// private btn_list: Array<eui.Button>
	private show_btn_list: Array<number>

	LoadSuccess
	InitEvent
	SetData
	InitView
	GetBaseAndStrenProStr
	RefreshBtnState
	public constructor() {
		super()

		let model = PetEquipModel.GetInstance(),
			local_Util = Util,
			goods_model = GoodsModel.GetInstance(),
			local_JSON = JSON,
			local_WordManager = WordManager

		this.base_file = "common"
		this.layout_file = "PetEquipToolTips"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.destroy_callback = () => {
			if (this.goods_icon) {
				this.goods_icon.DeleteMe()
				this.goods_icon = null
			}
		}

		this.preload_server_config = {
			"config_pet_equip_pos_lv": false
		}

		this.LoadSuccess = () => {
			this._lb_rating.style.fontSize = 24
			this._lb_rating.style.color = "#ffffff"
			this._lb_rating.style.wordWrap = false

			this._lb_level.style.fontSize = 24
			this._lb_level.style.color = "#ffffff"
			this._lb_level.style.wordWrap = false

			this._lb_base_attr.style.fontSize = 20
			this._lb_base_attr.style.color = "#663915"
			this._lb_base_attr.style.wordWrap = false

			this._lb_career.style.fontSize = 20
			this._lb_career.style.color = "#663915"
			this._lb_career.style.wordWrap = false
			this._lb_career.style.bold = true

			this._lb_pos.style.fontSize = 20
			this._lb_pos.style.color = "#663915"
			this._lb_pos.style.wordWrap = false
			this._lb_pos.style.bold = true

			this._Scroller1.vScrollBarSkin = ""

			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

			Util.AddClickEvent(this._btn_replace, () => {
				if (!this.goods_vo) {
					return
				}
				let good_data = model.GetGoodsData(this.goods_vo.type_id)
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "PetEquipBaseView", good_data.type_id, 0)
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_equip, () => {
				if (!this.goods_vo) {
					return
				}
				let good_data = model.GetGoodsData(this.goods_vo.type_id)
				model.Fire(PetEquipEvent.REQUEST_PROTO, 16015, "ccl", good_data.type_id, good_data.pos, this.goods_vo.goods_id)
				this.Close()
			}, this, true)
		}

		/**
		 * @param  {number} type_id 物品类型
		 * @param  {any} goods_vo?	物品数据
		 * @param  {number} role_id?	人物id
		 * @param  {Array<number>} show_btn_list?	显示部分按钮(传按钮所在深度)
		 */
		this.SetData = (type_id?, goods_vo?, role_id?, show_btn_list?) => {
			this.type_id = type_id
			this.role_id = role_id
			this.show_btn_list = show_btn_list ? show_btn_list : [0]
			let main_role_id = RoleManager.GetInstance().GetMainRoleId()

			this.goods_vo = goods_vo || goods_model.GetGoodsBasicByTypeId(type_id)
		}

		this.InitView = () => {
			if (!this.goods_vo) {
				return
			}

			let basic = goods_model.GetGoodsBasicByTypeId(this.type_id)
			if (basic == null) {
				return
			}

			if (!this.goods_icon) {
				this.goods_icon = new EquipmentItem(this._gp_icon)
				this.goods_icon.Load()
				this.goods_icon.SetItemSize(84, 84)
				this.goods_icon.ChangeCountVisible(false)
			}
			this.goods_icon.SetData(this.goods_vo.type_id, 0, this.goods_vo.is_lock, null, null, null, this.goods_vo.rating, this.goods_vo.equip_extra_attr, this.goods_vo.goods_id)
			this.goods_icon.SetShowTips(false)

			let good_data = model.GetGoodsData(Number(basic.type_id))
			if (!good_data) { return }
			let star = this.goods_vo.equipStar && this.goods_vo.equipStar > 0 && this.goods_vo.equipStar || good_data.star
			let stage = this.goods_vo.equipStage && this.goods_vo.equipStage > 0 && this.goods_vo.equipStage || good_data.stage
			let pos_lv = 0
			let type = good_data.type_id
			let edata = model.GetPetEquipData(type, this.goods_vo.goods_id)
			if (edata) {
				pos_lv = edata.pos_lv
				star = edata.star
				stage = edata.stage
			}
			let pet_equip_pos_lv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_pet_equip_pos_lv", false)
			let lv_data = model.GetLvData(type, good_data.pos, pos_lv, pet_equip_pos_lv_cfg)
			let star_data = model.GetStarData(type, good_data.pos, star)
			let stage_data = model.GetStageData(type, good_data.pos, stage)
			let star_attr = local_JSON.parse(star_data.attr_list)
			let stage_attr = local_JSON.parse(stage_data.attr_list)
			let lv_attr = local_JSON.parse(lv_data.attr_list)

			let goods_vo = this.goods_vo
			let attr_list = model.GetAttrListByTwo(star_attr, stage_attr)
			if (!goods_vo.goods_id) {
				let power = Util.CalAttrPower(attr_list, false)
				this._lb_rating.innerHTML = `装备评分：<font color=${Enum_ColorUtil_Dark.YELLOW}>${power}</font>`
			} else {
				let wear = model.GetWearEquipInfo(type, goods_vo.equip_type)
				if (wear && wear.goods_id == goods_vo.goods_id) {
					this._lb_rating.innerHTML = `综合评分：<font color=${Enum_ColorUtil_Dark.YELLOW}>${goods_vo.overall_rating}</font>`
				} else {
					this._lb_rating.innerHTML = `装备评分：<font color=${Enum_ColorUtil_Dark.YELLOW}>${goods_vo.rating}</font>`
				}
			}

			let color = stage_data ? stage_data.color : basic.color
			this._Image1.skin = GameResPath.GetIcon('common4', 'ui_tips_pz_' + color)

			this._lb_name.text = basic.goods_name
			
			//基础属性
			this._lb_base_attr.innerHTML = this.GetBaseAndStrenProStr(attr_list, lv_attr)

			let name = model.GetPosName(basic.type, basic.subtype)

			let html_color = "'#d15e00'"
			this._lb_career.innerHTML = `职业：<font color=${html_color}>通用</font>`
			this._lb_pos.innerHTML = `部位：<font color=${html_color}>${name}</font>`
			let lv = good_data.pet_stage_limit
			let odata = OutWardBaseModel.GetInstance().outward_data_list[good_data.type_id]
			let lv_str = (odata && odata.stage >= lv) ? local_Util.HtmlColorTxt(lv, Enum_ColorUtil_Dark.YELLOW) : local_Util.HtmlColorTxt(lv, Enum_ColorUtil_Dark.RED)
			let tName = model.PetEquipTypeName(basic.type)
			this._lb_level.innerHTML = `${tName}阶数：${lv_str}`

			this.RefreshBtnState()
			// this.validateNow()
			this.display_obj.height = this._gp_btns.height + this._gp_btns.y + 16

			let red_id = model.GetRedIDByType(good_data.type_id, 1)
			this._reddot.visible = this._btn_replace.visible && model.GetRedStatus(red_id, good_data.pos)

			// let height = this._lb_base_attr.y + this._lb_base_attr.height + 10 + 26
			// if(this.show_btn_list.length > 0){
			// 	height += 52 
			// }
			// this._img_bg.height = height
			// this.display_obj.height = height
		}

		//基础和强化属性
		this.GetBaseAndStrenProStr = (base_attrlist?, stren_list?) => {
			let str = ""
			let stren_str
			let pro
			if (base_attrlist && Array.isArray(base_attrlist)) {
				base_attrlist.forEach((val, idx, array) => {
					stren_str = ""
					if (stren_list && Array.isArray(stren_list)) {
						for (let i = 0; i < stren_list.length; i++) {
							pro = stren_list[i]
							if (pro && pro[0] == val[0] && pro[1] > 0) {
								stren_str = `&nbsp;<font color='#0a953e'>(强化+${pro[1]})</font>`
								break
							}
						}
					}
					if ((idx + 1) != base_attrlist.length) {
						str = str + local_WordManager.GetProperties(val[0]) + ":&nbsp;<font color='#d15e00'>" + val[1] + "</font>" + stren_str + "<br/>";
					}
					else {
						str = str + local_WordManager.GetProperties(val[0]) + ":&nbsp;<font color='#d15e00'>" + val[1] + "</font>" + stren_str;
					}
				})
			}
			return str
		}

		//按钮
		this.RefreshBtnState = () => {
			let btn
			for (let i = 0; i < this._gp_btns.numChildren; i++) {
				let show = this.show_btn_list.indexOf(i) != -1

				btn = this._gp_btns.getChildAt(i)
				if (btn) {
					btn.visible = show
					// btn.includeInLayout = show
				}
			}
			if (this._btn_replace.visible == false && this._btn_equip.visible == false) {
				this._btn_close.x = 100
			} else {
				this._btn_close.x = 0
			}
		}


	}


	public GetComponents() {
		[
			this._img_bg,
			this._gp_icon,
			this._Image1,
			this._Image2,
			this._lb_name,
			this._lb_rating,
			this._lb_level,
			this._Scroller1,
			this.Content,
			this._Image3,
			this._Label1,
			this._lb_base_attr,
			this._Group3,
			this._Image4,
			this._lb_career,
			this._lb_pos,
			this._gp_btns,
			this._btn_close,
			this._btn_close_img,
			this._btn_close_lb,
			this._btn_replace,
			this._btn_replace_img,
			this._reddot,
			this._btn_replace_lb,
			this._btn_equip,
			this._btn_equip_img,
			this._btn_equip_lb,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_icon",
				"_Image1",
				"_Image2",
				"_lb_name",
				"_lb_rating",
				"_lb_level",
				"_Scroller1",
				"Content",
				"_Image3",
				"_Label1",
				"_lb_base_attr",
				"_Group3",
				"_Image4",
				"_lb_career",
				"_lb_pos",
				"_gp_btns",
				"_btn_close",
				"_btn_close_img",
				"_btn_close_lb",
				"_btn_replace",
				"_btn_replace_img",
				"_reddot",
				"_btn_replace_lb",
				"_btn_equip",
				"_btn_equip_img",
				"_btn_equip_lb",
			])
	}
}
window["PetEquipToolTips"] = PetEquipToolTips