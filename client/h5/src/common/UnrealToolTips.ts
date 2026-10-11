import { GoodsModel } from "../commonModel/GoodsModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { HtmlColorTxt, RefBoxVLayout, RefGridLayout, SetHtmlStyle, Util } from "../util/Util"
import { BaseView1 } from "./BaseView1"
import { EquipBestProItem } from "./EquipBestProItem"
import { EquipmentItem } from "./EquipmentItem"
import { EventName } from "./EventName"
import { Enum_UILayer } from "./LayerManager"
import { ResManager } from "./ResManager"
import { WordManager } from "./WordManager"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { GameResPath } from "../util/GameResPath"

export class UnrealToolTips extends BaseView1 {

	protected pos_x: number = 0
	protected pos_y: number = 0
	protected btn_list: Array<Laya.Box>

	private static BtnWidth = 131
	private static BtnHeight = 52
	public static Btn = {
		close: 0
	}
	LoadSuccess
	InitEvent
	SetData
	InitView
	GetBaseAndStrenProStr
	SetBestPro
	RefreshBtnState
	SetTipsHeight
	init_scroll_height
	public constructor() {
		super();

		let local_Util = Util,
			model = UnrealModel.GetInstance(),
			local_UnrealModel = UnrealModel,
			goods_model = GoodsModel.GetInstance(),
			res_mgr = ResManager.GetInstance(),
			erlang_parser = ErlangParser.GetInstance(),
			local_WordManager = WordManager,
			_role_id: number = 0,
			_type_id: number = 0,
			_goods_vo: any = null,
			_is_show_btn: boolean = false,
			_dynamic: any = null,		//动态数据
			_goods_icon: EquipmentItem,
			_show_btn_list: Array<number>,
			_best_pro_item_list: Array<any>,
			_x_cache,
			_y_cache,
			_decompose_id,
			_attr_cfg

		this.base_file = "common";
		this.layout_file = "UnrealToolTips";
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true;
		this.use_background = true;
		this.click_bg_toClose = true;
		this.show_open_movie = true
		this.is_center = true

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
		this.open_callback = () => {
			this.InitView();
		}
		this.close_callback = () => {

		}
		this.destroy_callback = () => {
			if (_goods_icon) {
				_goods_icon.DeleteMe();
				_goods_icon = null;
			}
			for (let obj of _best_pro_item_list) {
				obj.DeleteMe()
			}
			_best_pro_item_list = null
		}
		this.preload_server_config = {
			"config_decoration_attr": false,
			"config_decoration_level_max": false,
			"config_decoration_level": false

		}
		this.LoadSuccess = () => {
			this.content_scroll.vScrollBarSkin = ""
			this.init_scroll_height = this.content_scroll.height
			_best_pro_item_list = []
		}
		this.InitEvent = () => {
			local_Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this.replaceBtn, () => {
				if (!_goods_vo) return
				model.Fire(local_UnrealModel.REQUEST_CCMD_EVENT, 14901, _goods_vo.goods_id)
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this.dismantleBtn, () => {
				if (!_goods_vo) return
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "UnrealDismantleView", _goods_vo)
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this.UninstallBtn, () => {
				if (!_goods_vo) return
				// model.Fire(UnrealModel.REQUEST_CCMD_EVENT, 14902, _goods_vo.goods_id)
				CompositeModel.GetInstance().Fire(CompositeEvent.UNINSTALL_UNREAL, _goods_vo.goods_id)
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this.UninstallBtn2, () => {
				if (!_goods_vo) return
				model.Fire(UnrealModel.REQUEST_CCMD_EVENT, 14902, _goods_vo.goods_id)
				// CompositeModel.GetInstance().Fire(CompositeEvent.UNINSTALL_UNREAL, _goods_vo.goods_id)
				this.Close()
			}, this, true)


			this.BindEvent(model, local_UnrealModel.DECOMPOSE_PREVIEW, (goods_id) => {
				if (_decompose_id == goods_id) {
					let data = model.GetDecomposePreviewData()
					let list = data.equip_extra_attr
					if (list.length > 0) {
						this.best_conta.visible = true
						// this.best_conta.includeInLayout = true
						let item
						for (let i = 0; i < list.length; i++) {
							item = _best_pro_item_list[i]
							if (!item) {
								item = new EquipBestProItem(this.best_pro_conta)
								_best_pro_item_list[i] = item
								item.Load()
							}
							item.visible = true
							item.SetData(list[i], false)
						}
						for (let i = list.length; i < _best_pro_item_list.length; i++) {
							_best_pro_item_list[i].visible = false
						}

						this.best_conta.height = list.length * (EquipBestProItem.Height) + ((list.length - 1) * this.best_pro_conta.space) + this.best_pro_conta.y 
					} else {
						this.best_conta.visible = false
						// this.best_conta.includeInLayout = false
					}
					this.score.style.color = "#783528"
					this.score.style.fontSize = 20
					this.score.width = 209
					this.score.innerHTML = local_Util.StrToHTML(`装备评分：<font color='#4a3a32'>${data.overall_rating}</font>`);
				}
			})
		}

		/**
		 * @param  {number} type_id 物品类型
		 * @param  {number} x?		界面x坐标
		 * @param  {number} y?		界面y坐标
		 * @param  {any} goods_vo?	物品数据
		 * @param  {number} role_id?	人物id
		 * @param  {Array<number>} show_btn_list?	显示部分按钮(传按钮所在深度)
		 * @param  {number} deompose_id?	分解id
		 */
		this.SetData = (type_id: number, goods_vo?: any, role_id?: number, show_btn_list?: Array<number>, decompose_id?) => {

			_type_id = type_id;
			_role_id = role_id;
			_show_btn_list = show_btn_list ? show_btn_list : [0];
			let main_role_id = RoleManager.GetInstance().GetMainRoleId();
			_decompose_id = decompose_id
			this.is_center = true
			if (role_id && (role_id != main_role_id)) {
				_is_show_btn = false;
				_goods_vo = goods_vo;
				_dynamic = _goods_vo;
			}
			else {
				_is_show_btn = goods_vo != null ? (model.GetWearEquipInfo(goods_vo.goods_id) != null) : false;
				_goods_vo = goods_vo || goods_model.GetGoodsBasicByTypeId(type_id);
			}
		}

		this.InitView = () => {

			if (_goods_vo == null) {
				return console.log("物品config里面没有配置");
			}
			let goods_vo = _goods_vo

			let basic = goods_model.GetGoodsBasicByTypeId(_type_id);
			if (basic == null) {
				return
			}

			let bg_name = `ui_tips_pz_${basic.color}`
			ResManager.GetInstance().SetImageSprite(this, this._img_title_bg, "common4", bg_name)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._line, GameResPath.GetIcon("common", "com_line_71"))


			if (_x_cache != undefined && _y_cache != undefined) {
				this.display_obj.x = _x_cache
				this.display_obj.y = _y_cache
			}


			if (!_goods_icon) {
				_goods_icon = new EquipmentItem(this.icon);
				_goods_icon.Load();
				_goods_icon.SetItemSize(92, 92)
				_goods_icon.ChangeCountVisible(false);
			}
			_goods_icon.SetData(goods_vo.type_id, 1);
			_goods_icon.SetShowTips(false)

			let color_str = ColorUtil.GetColorDark(basic.color, false)

			// this._gp_tips.visible = this._gp_tips.includeInLayout = basic.color > 3
			this._gp_tips.visible = basic.color > 3
			if (this._gp_tips.visible == false) {
				this._gp_tips.removeSelf()
			}

			// this._gp_tips0.visible = this._gp_tips0.includeInLayout = basic.color < 4
			this._gp_tips0.visible = basic.color < 4
			if (this._gp_tips0.visible == false) {
				this._gp_tips0.removeSelf()
			}

			this.equip_name.text = local_Util.StrToHTML(`${(basic.goods_name).trim()}`)
			let decoration_attr_cfg = res_mgr.GetGameConfigFromCache(this, "config_decoration_attr", false)
			let attr_cfg = model.GetUnrealData(basic.type_id, decoration_attr_cfg)
			let score = 0
			let max_cfg
			if (attr_cfg) {
				_attr_cfg = attr_cfg
				// score = attr_cfg.base_rating
				score = model.GetBaseRatingScore(attr_cfg.color_attr, attr_cfg.stage) + Util.CalAttrPower(basic.base_attrlist, false, true)
				let max_key = `${goods_vo.equip_type}@${attr_cfg.stage}@${goods_vo.color}`
				let decoration_level_max_cfg = res_mgr.GetGameConfigFromCache(this, "config_decoration_level_max", false)
				max_cfg = model.GetUnrealStrenMax(max_key, decoration_level_max_cfg)
			}

			let limit_level = 0
			if (max_cfg) {
				limit_level = max_cfg.limit_level
			}

			let stren_cfg
			let stren_list = []


			let sorce_desc = "装备评分"
			if (goods_vo.goods_id) {
				score = goods_vo.rating
				if (model.GetWearEquipInfo(goods_vo.goods_id)) {
					sorce_desc = "综合评分"
					score = goods_vo.overall_rating
					let stren_data = model.GetStrenData(goods_vo.cell), stren = stren_data ? stren_data.level : 0
					if (stren) {
						if (limit_level <= stren)
							stren = max_cfg && max_cfg.limit_level || 0
						_goods_icon.SetStrengthen(stren)

						let stren_key = basic.equip_type + "@" + stren
						let decoration_level_cfg = res_mgr.GetGameConfigFromCache(this, "config_decoration_level", false)
						stren_cfg = model.GetUnrealStrenValue(stren_key, decoration_level_cfg)
						if (stren_cfg) {
							stren_list = JSON.parse(stren_cfg.attr)
						}
					}

				}
			}

			this.score.style.color = "#ffffff"
			this.score.style.fontSize = 22
			this.score.width = 300
			this.score.innerHTML = local_Util.StrToHTML(`${sorce_desc}：<font color='#ffe222'>${score}</font>`);


			SetHtmlStyle(this.basePro, { c: "#663915", f: 20, ww: false, w: 320 ,lh:25})
			SetHtmlStyle(this._html_stren, { c: "#663915", f: 20, ww: false, w: 190 ,lh:25})
			let arr = this.GetBaseAndStrenProStr(erlang_parser.Parse(basic.base_attrlist), stren_list)
			this.basePro.innerHTML = local_Util.StrToHTML(arr[0])
			this._html_stren.innerHTML = local_Util.StrToHTML(arr[1])

			this.base_pro_conta.height = this.basePro.y + this.basePro.contextHeight

			let lv = basic.level > 370 ? `神创${basic.level - 370}` : basic.level
			this.level.style.color = "#ffffff"
			this.level.style.fontSize = 22
			this.level.width = 300
			this.level.innerHTML = local_Util.StrToHTML(`等级需求：<font color='#ffe222'>${lv}</font>`);

			this.can_stren.text = limit_level ? "可强化" : "不可强化"

			let pos_name = model.GetEquipPosName(basic.equip_type)
			this.pos.text = `${pos_name}`

			this.RefreshBtnState()



			//设置极品属性
			if (_decompose_id) {
				model.Fire(local_UnrealModel.REQUEST_CCMD_EVENT, 14907, _decompose_id)
			}
			else {
				this.SetBestPro()
			}




			//刷新detail_scroller的高度
			RefBoxVLayout(this.detail_box, 10, true, true)
			if (this.detail_box.height >= this.init_scroll_height) {
				this.content_scroll.height = this.init_scroll_height
			} else {
				this.content_scroll.height = this.detail_box.height
			}



			//设置整体高度
			this.SetTipsHeight()
		}


		this.SetTipsHeight = () => {


			//计算高度
			let contents = [this.content_scroll, this._box_pos, this.btn_conta]
			let record_y = contents[0].y
			let last_height = contents[0].height //上一个组件的高度 记录
			let gap = 15

			let is_foreach =false
			for (let i = 1; i < contents.length; i++) {
				if (!contents[i].visible) continue
				let new_y = record_y + last_height + gap
				is_foreach =true
				contents[i].y = new_y
				record_y = new_y
				last_height = contents[i].height
			}

			let img_bg_height = !is_foreach?record_y + last_height + 10+gap:record_y + last_height + 10
			this._img_bg.height = img_bg_height
			this.display_obj.height = img_bg_height
		}

		//基础和强化属性
		this.GetBaseAndStrenProStr = (base_attrlist, stren_list) => {
			let str = "";
			let str_stren = "";
			let pro
			if (base_attrlist && Array.isArray(base_attrlist)) {
				base_attrlist.forEach((val, idx, array) => {
					let sstr
					if (stren_list && Array.isArray(stren_list)) {
						for (let i = 0; i < stren_list.length; i++) {
							pro = stren_list[i]
							if (pro && pro[0] == val[0] && pro[1] > 0) {
								sstr = `${HtmlColorTxt(`强化+${pro[1]}`, Enum_ColorUtil_Dark.GREEN)}`
								break
							}
						}
					}
					if ((idx + 1) != base_attrlist.length) {
						str = str + local_WordManager.GetProperties(val[0]) + "：<font color='#d15e00'>" + val[1] + "</font>" + "<br/>";

						if(sstr){
							str_stren = str_stren + sstr + "<br/>"
						}else{
							str_stren = str_stren  + "<br/>"
						}
						
					}
					else {
						str = str + local_WordManager.GetProperties(val[0]) + "：<font color='#d15e00'>" + val[1] + "</font>";

						if(sstr){
							str_stren = str_stren + sstr
						}else{
							str_stren = str_stren  + "<br/>"
						}
					
					}
				});
			}
			return [str, str_stren]
		}


		//极品属性
		this.SetBestPro = () => {
			let list = []
			let is_preview = false
			if (_goods_vo) {
				if (_goods_vo.equip_extra_attr) {
					list = _goods_vo.equip_extra_attr
				} else {
					list = _attr_cfg ? erlang_parser.Parse(_attr_cfg.recommend_attr) : []
					is_preview = true
				}
			}
			if (list && list.length > 0 && is_preview) {
				this.best.text = `极品属性(随机生成若干条极品属性)`
			}
			if (list.length > 0) {
				this.best_conta.visible = true
				// this.best_conta.includeInLayout = true
				let item
				for (let i = 0; i < list.length; i++) {
					item = _best_pro_item_list[i]
					if (!item) {
						item = new EquipBestProItem(this.best_pro_conta)
						_best_pro_item_list[i] = item
						item.Load()
					}
					item.visible = true
					item.SetData(list[i], is_preview)
				}
				for (let i = list.length; i < _best_pro_item_list.length; i++) {
					_best_pro_item_list[i].visible = false
				}

				this.best_conta.height = list.length * (EquipBestProItem.Height) + ((list.length - 1) * this.best_pro_conta.space) + this.best_pro_conta.y 

			} else {
				this.best_conta.visible = false
				// this.best_conta.includeInLayout = false
			}
		}

		//按钮
		this.RefreshBtnState = () => {
			let btn
			for (let i = 0; i < this.btn_conta.numChildren; i++) {
				let show = _show_btn_list.indexOf(i) != -1
				btn = this.btn_conta.getChildAt(i)
				if (btn) {
					btn.visible = show
					// btn.includeInLayout = show
				}
			}
			this.btn_conta.height = _show_btn_list.length > 2 ? 120 : 60

			RefGridLayout(this.btn_conta, {
				column: 2,
				h_gap: 6,
				v_gap: 6,
				item_w: 131,
				item_h: 52
			}, true)
		}
	}


	_img_bg: Laya.Image
	_img_title_bg: Laya.Image
	icon: Laya.Box
	equip_name: Laya.Label
	score: Laya.HTMLDivElement
	level: Laya.HTMLDivElement
	content_scroll: Laya.Panel
	detail_box: Laya.Box
	base_pro_conta: Laya.Box
	base: Laya.Label
	basePro: Laya.HTMLDivElement
	_html_stren: Laya.HTMLDivElement
	best_conta: Laya.Box
	best: Laya.Label
	best_pro_conta: Laya.VBox
	_gp_tips: Laya.Box
	_Label1: Laya.Label
	_Label2: Laya.Label
	_gp_tips0: Laya.Box
	line115: Laya.Image
	_Label3: Laya.Label
	_Label4: Laya.Label
	_box_pos: Laya.Box
	_line: Laya.Image
	can_stren: Laya.Label
	lb: Laya.Label
	pos: Laya.Label
	btn_conta: Laya.Box
	closeBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	dismantleBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay2: Laya.Label
	replaceBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay3: Laya.Label
	UninstallBtn: Laya.Box
	_Image1111: Laya.Image
	labelDisplay4: Laya.Label
	UninstallBtn2: Laya.Box
	_Image11111: Laya.Image
	labelDisplay5: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_title_bg,
			this.icon,
			this.equip_name,
			this.score,
			this.level,
			this.content_scroll,
			this.detail_box,
			this.base_pro_conta,
			this.base,
			this.basePro,
			this._html_stren,
			this.best_conta,
			this.best,
			this.best_pro_conta,
			this._gp_tips,
			this._Label1,
			this._Label2,
			this._gp_tips0,
			this.line115,
			this._Label3,
			this._Label4,
			this._box_pos,
			this._line,
			this.can_stren,
			this.lb,
			this.pos,
			this.btn_conta,
			this.closeBtn,
			this._Image1,
			this.labelDisplay1,
			this.dismantleBtn,
			this._Image11,
			this.labelDisplay2,
			this.replaceBtn,
			this._Image111,
			this.labelDisplay3,
			this.UninstallBtn,
			this._Image1111,
			this.labelDisplay4,
			this.UninstallBtn2,
			this._Image11111,
			this.labelDisplay5,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title_bg",
				"icon",
				"equip_name",
				"score",
				"level",
				"content_scroll",
				"detail_box",
				"base_pro_conta",
				"base",
				"basePro",
				"_html_stren",
				"best_conta",
				"best",
				"best_pro_conta",
				"_gp_tips",
				"_Label1",
				"_Label2",
				"_gp_tips0",
				"line115",
				"_Label3",
				"_Label4",
				"_box_pos",
				"_line",
				"can_stren",
				"lb",
				"pos",
				"btn_conta",
				"closeBtn",
				"_Image1",
				"labelDisplay1",
				"dismantleBtn",
				"_Image11",
				"labelDisplay2",
				"replaceBtn",
				"_Image111",
				"labelDisplay3",
				"UninstallBtn",
				"_Image1111",
				"labelDisplay4",
				"UninstallBtn2",
				"_Image11111",
				"labelDisplay5",
			])
	}
}
window["UnrealToolTips"] = UnrealToolTips