import { Alert, Alert_Type } from "../alert/Alert";
import { GodBeastEvent, GodBeastModel } from "../commonModel/GodBeastModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { RefGridLayout, Util } from "../util/Util";
import { CompositeModel } from "../commonModel/CompositeModel";
import { BaseView1 } from "../common/BaseView1";
import { EquipBestProItem } from "../common/EquipBestProItem";
import { EquipmentItem } from "../common/EquipmentItem";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { RedDotManager, ModuleType } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { WordManager } from "../common/WordManager";

export class PlayerMessageBeatTips extends BaseView1 {

	private static BtnWidth = 149;
	private static BtnHeight = 53;

	LoadSuccess
	InitEvent
	ResConfig
	SetData
	InitView
	GetBaseAndStrenProStr
	SetBestPro
	RefreshBtnState
	CheckReddot
	CheckStrRed
	public constructor() {
		super();
		this.base_file = "common";
		this.layout_file = "BeastToolTips";
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true;
		this.use_background = true;
		this.click_bg_toClose = true;
		this.is_center = true

		let local_Util = Util,
			local_GlobalEventSystem = GlobalEventSystem,
			open_view_event = EventName.OPEN_VIEW,
			_model = GodBeastModel.GetInstance(),
			local_Alert = Alert,
			local_Alert_Type = Alert_Type,
			request_proto_event = GodBeastEvent.REQUEST_PROTO,
			local_GodBeastEvent = GodBeastEvent,
			res_mgr = ResManager.GetInstance(),
			local_Message = Message,
			goods_model = GoodsModel.GetInstance(),
			local_JSON = JSON,
			local_WordManager = WordManager,
			red_dot_mgr = RedDotManager.GetInstance(),
			local_ModuleType = ModuleType,
			_role_id: number = 0,
			_type_id: number = 0,
			pos_x: number = 0,
			pos_y: number = 0,
			_goods_vo: any = null,
			is_show_btn: boolean = false,
			dynamic: any = null,			//动态数据
			goods_icon: EquipmentItem,
			btn_list: Array<Laya.Box>,
			_show_btn_list: Array<number>,

			cfg_finish = false,
			stren_cfg,
			equip_attr,
			need_refresh = false,
			used_open_func = false,
			best_pro_item_list: Array<any>,
			x_cache,
			y_cache


		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvent()
		}
		this.open_callback = function () {
			this.used_open_func = true;
			if (need_refresh) {
				this.InitView();
			}
		}
		this.close_callback = function () {

		}
		this.destroy_callback = function () {
			if (goods_icon) {
				goods_icon.DeleteMe();
				goods_icon = null;
			}
			for (let obj of best_pro_item_list) {
				obj.DeleteMe()
			}
			best_pro_item_list = null
			equip_attr = null
			stren_cfg = null
		}
		// this.ResConfig()
		this.preload_server_config = {
			"config_eudemons_equip_attr": false,
			"config_eudemons_strength": false
		}

		this.LoadSuccess = () => {
			this.content_scroll.vScrollBar.visible = false;

			// ResManager.GetInstance().SetOutsideImageSprite(this, this.img1, GameResPath.GetIcon("common2", "uity_016c"))

			best_pro_item_list = []
			this.ResConfig()
		}
		this.InitEvent = () => {
			let close_fun = () => {
				this.Close();
			}
			local_Util.AddClickEvent(this.closeBtn, close_fun, this, true);

			local_Util.AddClickEvent(this.replaceBtn, () => {
				if (!_goods_vo) return
				let id = _model._select_beast_id
				if (!id) return
				local_GlobalEventSystem.Fire(open_view_event, "GodBeastSelectView", id, _goods_vo.cell)
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this.setBtn, () => {
				if (!_goods_vo) return
				let id = _model._select_beast_id
				if (!id) return
				let info = _model.GetBeastInfoOne(id)
				for (let vo of info.equip_list) {
					if (vo.pos == _goods_vo.equip_type) {
						local_Alert.Show(`是否将旧蜃妖装备的熟练度经验无损转移至新的蜃妖装备？`, local_Alert_Type.Two, () => {
							_model.Fire(request_proto_event, 17303, "lic", _goods_vo.goods_id, id, 1)
						}, (bool) => {
							if (!bool) {
								_model.Fire(request_proto_event, 17303, "lic", _goods_vo.goods_id, id, 0)
							}
						}, "确认", "取消")
						this.Close()
						return
					}
				}
				_model.Fire(request_proto_event, 17303, "lic", _goods_vo.goods_id, id, 0)
				this.Close()
			}, this, true)

			let disboardBtn_fun = () => {
				if (!_goods_vo) return
				let id = _model._select_beast_id
				if (!id) return
				let info = _model.GetBeastInfoOne(id)
				if (info && info.state == 2) {
					local_Alert.Show("拆除当前装备将会取消该蜃妖的助战状态，是否继续", local_Alert_Type.Two, () => {
						_model.Fire(request_proto_event, 17304, "ic", id, _goods_vo.equip_type)
						this.Close()
					}, undefined, "确定", "取消")
				} else {
					_model.Fire(request_proto_event, 17304, "ic", id, _goods_vo.equip_type)
					this.Close()
				}
			}
			local_Util.AddClickEvent(this.disboardBtn, disboardBtn_fun, this, true);

			local_Util.AddClickEvent(this.inBtn, () => {
				if (!_goods_vo) {
					return
				}
				if (_goods_vo.color >= 6) {
					local_Message.show(`当前装备无法铸造`)
					return
				}
				if (_goods_vo.color == 5) {
					let eudemons_equip_attr_cfg = res_mgr.GetGameConfigFromCache(this, "config_eudemons_equip_attr", false)
					let data = _model.GetEquipData(_goods_vo.type_id, eudemons_equip_attr_cfg)
					if (data || data.star >= 2) {
						local_Message.show(`当前装备无法铸造`)
						return
					}
				}
				_model.Fire(local_GodBeastEvent.SELECT_COM_EQUIP, _goods_vo.goods_id, 1)
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this.outBtn, () => {
				if (!_goods_vo) {
					return
				}
				_model.Fire(local_GodBeastEvent.SELECT_COM_EQUIP, _goods_vo.goods_id, 0)
				CompositeModel.GetInstance().Fire(CompositeModel.UNINSTALL_EQUIP, _goods_vo.goods_id)
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this.strBtn, () => {
				if (_goods_vo) {
					local_GlobalEventSystem.Fire(open_view_event, "GodBeastStrView", _goods_vo.goods_id)
				}
				this.Close()
			}, this)

		}

		this.ResConfig = () => {
			stren_cfg = res_mgr.GetGameConfigFromCache(this, "config_eudemons_strength", false)
			equip_attr = res_mgr.GetGameConfigFromCache(this, "config_eudemons_equip_attr", false)

			cfg_finish = true
			// if (this.is_loaded) {
			// 	this.InitView()
			// }
		}

		/**
		 * @param  {number} type_id 物品类型
		 * @param  {number} x?		界面x坐标
		 * @param  {number} y?		界面y坐标
		 * @param  {any} goods_vo?	物品数据
		 * @param  {number} role_id?	人物id
		 * @param  {Array<number>} show_btn_list?	显示部分按钮(传按钮所在深度)
		 */
		this.SetData = (type_id: number, x?: number, y?: number, goods_vo?: any, role_id?: number, show_btn_list?: Array<number>) => {
			_type_id = type_id;
			_role_id = role_id;
			_show_btn_list = show_btn_list ? show_btn_list : [0];
			let main_role_id = RoleManager.GetInstance().GetMainRoleId();
			x_cache = x
			y_cache = y
			if (x != undefined && y != undefined) {
				this.is_center = false
			} else {
				this.is_center = true
			}
			if (role_id && (role_id != main_role_id)) {
				is_show_btn = false;
				_goods_vo = goods_vo;
				dynamic = _goods_vo;
				need_refresh = true
			}
			else {
				is_show_btn = goods_vo != null ? (_model.GetWearEquipInfo(goods_vo.goods_id) != null) : false;
				_goods_vo = goods_vo || goods_model.GetGoodsBasicByTypeId(type_id);
				if (_goods_vo) {
					need_refresh = true
				}
			}

		}
		
		this.InitView = () => {
			if (!cfg_finish || need_refresh == false) {
				return
			}
			if (_goods_vo == null) {
				return console.log("物品config里面没有配置");
			}
			let basic = goods_model.GetGoodsBasicByTypeId(_type_id);
			if (basic == null) {
				return;
			}
			if (x_cache != undefined && y_cache != undefined) {
				this.display_obj.x = x_cache
				this.display_obj.y = y_cache
			}

			if (!goods_icon) {
				goods_icon = new EquipmentItem(this.icon);
				goods_icon.Load();
				goods_icon.SetItemSize(92, 92)
				goods_icon.ChangeCountVisible(false);
			}
			goods_icon.SetData(_goods_vo.goods_id, 1);
			goods_icon.SetShowTips(false)
			// if (_goods_vo.goods_id && GoodsModel.GetInstance().GetEquipById(_goods_vo.goods_id)) {
			// 	goods_icon.SetStrengthen(_goods_vo.stren, true)
			// } else {
			// 	goods_icon.SetStrengthen(_goods_vo.stren)
			// }

			let color_str = ColorUtil.GetColorDark(basic.color, false)
			this.equip_name.color = color_str
			this.equip_name.text = local_Util.StrToHTML(`${(basic.goods_name).trim()}`);
			let score = _goods_vo.equip_score;
			if (!_goods_vo.goods_id) {
				score = equip_attr[_goods_vo.type_id] ? equip_attr[_goods_vo.type_id].base_rating : 0
			}
			this.score.style.color = "#783528"
			this.score.style.fontSize = 20
			this.score.width = 210
			this.score.innerHTML = local_Util.StrToHTML(`装备评分：<font color='#d15e00'>${score}</font>`);

			this.total_score.style.color = "#783528"
			this.total_score.style.fontSize = 20
			this.total_score.width = 210
			let total = _goods_vo.score || _goods_vo.overall_rating || score
			this.total_score.innerHTML = local_Util.StrToHTML(`综合评分：<font color='#d15e00'>${total}</font>`);

			let stren_lv = _goods_vo.stren ? _goods_vo.stren : 0;
			let cfg = stren_cfg[basic.equip_type + "@" + stren_lv]
			let stren_list = cfg ? local_JSON.parse(cfg.attr) : []

			this.basePro.style.color = "#5a1c20"
			this.basePro.style.fontSize = 20
			this.basePro.width = 310
			this.basePro.innerHTML = local_Util.StrToHTML(this.GetBaseAndStrenProStr(ErlangParser.GetInstance().Parse(basic.base_attrlist), stren_list))
			this.basePro.height = this.basePro.contextHeight;
			this.line1.y = this.basePro.y + this.basePro.height + 12;
			this.base_pro_conta.height = this.line1.height + this.line1.y + 4

			this.desc.style.fontSize = 20
			this.desc.style.color = "#5a1c20"
			this.desc.style.leading = 8

			this.desc.width = 297

			this.desc.innerHTML = basic.intro
			this.line3.y = this.desc.y + this.desc.contextHeight + 15
			this.desc_conta.height = this.line3.y + this.line3.height + 4

			let pos = _model.GetEquipPosName(_goods_vo.equip_type)
			this.pos.style.color = "#93847d"
			this.pos.style.fontSize = 20
			this.pos.width = 260
			this.pos.innerHTML = local_Util.StrToHTML(`部位：<font color='#4a3a32'>${pos}</font>`);
			// this.pos.text = `部位：${pos}`

			// let wear = GodBeastModel.GetInstance().GetWearEquipInfo(_goods_vo.goods_id)
			// this.replaceBtn.visible = !wear
			// this.replaceBtn.includeInLayout = !wear
			// this.disboardBtn.visible = !!wear
			// this.disboardBtn.includeInLayout = !!wear

			this.SetBestPro()
			this.RefreshBtnState()
		}

		//基础和强化属性
		this.GetBaseAndStrenProStr = (base_attrlist, stren_list): string => {
			let str = "";
			let stren_str
			let pro
			if (base_attrlist && Array.isArray(base_attrlist)) {
				base_attrlist.forEach((val, idx, array) => {
					stren_str = ""
					if (stren_list && Array.isArray(stren_list)) {
						for (let i = 0; i < stren_list.length; i++) {
							pro = stren_list[i]
							if (pro && pro[0] == val[0] && pro[1] > 0) {
								stren_str = ` <font color='#0a953e'>(强化+${pro[1]})</font>`
								break
							}
						}
					}
					if ((idx + 1) != base_attrlist.length) {
						str = str + local_WordManager.GetProperties(val[0]) + ":<font color='#d15e00'>" + val[1] + "</font>" + stren_str + "<br/>";
					}
					else {
						str = str + local_WordManager.GetProperties(val[0]) + ":<font color='#d15e00'>" + val[1] + "</font>" + stren_str;
					}
				});
			}
			return str;
		}

		//极品属性
		this.SetBestPro = () => {
			let list = []
			let is_preview = false
			if (_goods_vo) {
				if (_goods_vo.equip_extra_attr) {
					list = _goods_vo.equip_extra_attr
				} else {
					let cfg = equip_attr[_goods_vo.type_id]
					list = cfg ? local_JSON.parse(cfg.recommend_attr) : []
					is_preview = true
				}
			}
			if (list && list.length > 0) {
				if (is_preview) {
					this.best.text = `极品属性(随机生成${list.length}条极品属性)`
				}
			}
			if (list.length > 0) {
				this.best_conta.visible = true
				// this.best_conta.includeInLayout = true
				let item
				for (let i = 0; i < list.length; i++) {
					item = best_pro_item_list[i]
					if (!item) {
						item = new EquipBestProItem(this.best_pro_conta)
						best_pro_item_list[i] = item
						item.Load()
					}
					item.visible = true
					item.SetData(list[i], is_preview)
				}
				for (let i = list.length; i < best_pro_item_list.length; i++) {
					best_pro_item_list[i].visible = false
				}
				this.line2.y = list.length * (EquipBestProItem.Height) + ((list.length - 1) * 2) + this.best_pro_conta.y + 12
				this.best_conta.height = this.line2.y + this.line2.height + 4
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

			if (this.replaceBtn.visible && _show_btn_list.length == 2) {
				this.replaceRed.visible = this.CheckReddot()
			}
			if (this.strBtn.visible && _show_btn_list.length == 2) {
				this._reddot.visible = this.CheckStrRed()
			}

			RefGridLayout(this.btn_conta, {
				column: 2,
				h_gap: 6,
				v_gap: 6,
				item_w: 131,
				item_h: 52
			}, true)

		}

		this.CheckReddot = () => {
			let beast_id = _model._select_beast_id
			if (!beast_id) return false
			let id = beast_id * 10000 + _goods_vo.equip_type
			return red_dot_mgr.CheckAnyRedStatus(local_ModuleType.BEAST_REPLACE, id)
		}

		this.CheckStrRed = () => {
			if (_goods_vo) {
				return red_dot_mgr.CheckAnyRedStatus(local_ModuleType.BEAST_STREN, _goods_vo.goods_id)
			}
		}
	}

	equip_conta: Laya.Box
	bg: Laya.Image
	icon: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	equip_name: Laya.Label
	score: Laya.HTMLDivElement
	total_score: Laya.HTMLDivElement
	content_scroll: Laya.Panel
	_Group1: Laya.VBox
	base_pro_conta: Laya.VBox
	base: Laya.Label
	line112: Laya.Image
	basePro: Laya.HTMLDivElement
	line1: Laya.Image
	best_conta: Laya.VBox
	best: Laya.Label
	line111: Laya.Image
	best_pro_conta: Laya.VBox
	line2: Laya.Image
	desc_conta: Laya.VBox
	_Label1: Laya.Label
	line11: Laya.Image
	desc: Laya.HTMLDivElement
	line3: Laya.Image
	img1: Laya.Image
	pos: Laya.HTMLDivElement
	btn_conta: Laya.Box
	closeBtn: Laya.Box
	_Image0: Laya.Image
	labelDisplay1: Laya.Label
	disboardBtn: Laya.Box
	_Image01: Laya.Image
	labelDisplay2: Laya.Label
	setBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay3: Laya.Label
	replaceBtn: Laya.Box
	_Image3: Laya.Image
	replaceRed: Laya.Image
	_Label2: Laya.Label
	inBtn: Laya.Box
	_Image1111: Laya.Image
	labelDisplay4: Laya.Label
	outBtn: Laya.Box
	_Image11111: Laya.Image
	labelDisplay5: Laya.Label
	strBtn: Laya.Box
	_Image4: Laya.Image
	_reddot: Laya.Image
	_Label3: Laya.Label
	public GetComponents() {
		[
			this.equip_conta,
			this.bg,
			this.icon,
			this._Image1,
			this._Image2,
			this.equip_name,
			this.score,
			this.total_score,
			this.content_scroll,
			this._Group1,
			this.base_pro_conta,
			this.base,
			this.line112,
			this.basePro,
			this.line1,
			this.best_conta,
			this.best,
			this.line111,
			this.best_pro_conta,
			this.line2,
			this.desc_conta,
			this._Label1,
			this.line11,
			this.desc,
			this.line3,
			this.img1,
			this.pos,
			this.btn_conta,
			this.closeBtn,
			this._Image0,
			this.labelDisplay1,
			this.disboardBtn,
			this._Image01,
			this.labelDisplay2,
			this.setBtn,
			this._Image111,
			this.labelDisplay3,
			this.replaceBtn,
			this._Image3,
			this.replaceRed,
			this._Label2,
			this.inBtn,
			this._Image1111,
			this.labelDisplay4,
			this.outBtn,
			this._Image11111,
			this.labelDisplay5,
			this.strBtn,
			this._Image4,
			this._reddot,
			this._Label3,
		]
			= this.GetChildrenByNames([

				"equip_conta",
				"bg",
				"icon",
				"_Image1",
				"_Image2",
				"equip_name",
				"score",
				"total_score",
				"content_scroll",
				"_Group1",
				"base_pro_conta",
				"base",
				"line112",
				"basePro",
				"line1",
				"best_conta",
				"best",
				"line111",
				"best_pro_conta",
				"line2",
				"desc_conta",
				"_Label1",
				"line11",
				"desc",
				"line3",
				"img1",
				"pos",
				"btn_conta",
				"closeBtn",
				"_Image0",
				"labelDisplay1",
				"disboardBtn",
				"_Image01",
				"labelDisplay2",
				"setBtn",
				"_Image111",
				"labelDisplay3",
				"replaceBtn",
				"_Image3",
				"replaceRed",
				"_Label2",
				"inBtn",
				"_Image1111",
				"labelDisplay4",
				"outBtn",
				"_Image11111",
				"labelDisplay5",
				"strBtn",
				"_Image4",
				"_reddot",
				"_Label3",
			])
	}
}

window["PlayerMessageBeatTips"] = PlayerMessageBeatTips