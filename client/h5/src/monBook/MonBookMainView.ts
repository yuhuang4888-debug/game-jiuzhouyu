import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { WordManager } from "../common/WordManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { SecretTreasureMainViewIndex } from "../commonModel/LungModel";
import { MainFunc } from "../commonModel/MainUIModel";
import { MonBookModel } from "../commonModel/MonBookModel";
import { EnumPushGiftType, PushGiftModel } from "../commonModel/PushGiftModel";
import { GiftPushIcon } from "../mainUI/GiftPushIcon";
import { PlatformManager } from "../PlatformManager";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { PlayBigEffect, RefBoxVLayout, RefGridLayout, Util } from "../util/Util";
import { MonBookItem } from "./MonBookItem";
import { MonBookSubItem } from "./MonBookSubItem";
import { MonBookTabItem } from "./MonBookTabItem";



export enum MonBookType {
	PIC,
	PIC_GROUP,
}
window["MonBookType"] = MonBookType
export class MonBookMainView extends BaseItem1 {

	LoadSuccess
	InitEvent
	SetMonBookItemList
	SwitchFunc
	SetPropertyInfo
	SetAllPropertyInfo
	GetPropertyList

	UpdateMonBookMessage
	SetCurrProp
	SetCurrAddProp
	GetRedTabIndex
	GetRedBookIndex
	_fight_show: FightingShowSmallItem
	book_power_show: FightingShowSmallItem
	now_show_book_list
	tab_loop_mgr: LoopScrowViewMgr
	loop_mgr: LoopScrowViewMgr

	select_index  //图鉴选中index
	UpdateMessageBox
	RefuseNeedGoodsAndCont
	PlayAnimation
	item_count = 0
	all_item_count = 0
	is_frist_open = true
	UpdateGmRed
	SetCostItem
	_type

	private giftItem: GiftPushIcon;
	public constructor(parent) {
		super(parent)
		let model = MonBookModel.GetInstance(),
			local_Util = Util,
			local_GlobalEventSystem = GlobalEventSystem,
			local_EventName = EventName,
			local_MonBookModel = MonBookModel,
			local_laya = Laya,
			local_Number = Number,
			local_JSON = JSON,
			goods_model = GoodsModel.GetInstance(),
			local_WordManager = WordManager,
			need_refresh_data_,
			now_index_,//图鉴类型选中index
			default_index_,
			curr_value_list_,
			state_,
			data_,
			need_goods_,
			up_lv_id_,
			delay_fire_obj_,
			_attr_str_list_,
			delay_id
		this.base_file = "monBook"
		this.layout_file = "MonBookMainView"
		need_refresh_data_ = false
		default_index_ = 0
		this.load_callback = ()=> {
			if (PlatformManager.IsEyouEnPlatform()||PlatformManager.IsEyouThPlatform()) {
				this._Group6.x = 407
				let hbox :Laya.HBox = this._lb_name_lv.parent as Laya.HBox
				if(hbox){
					hbox.pos(415,19)
				}
				this.lv_text.fontSize=20
				this._Group6.pos(377,46)
				this._Group5.pos(90,14)
			}
			this.LoadSuccess()
			this.InitEvent()

			this.UpdateGmRed()//更新共鸣红点
		}
		this.preload_server_config = {
			"config_mon_pic_group": false,
			"config_mon_pic_type": false
		}

		//第一次添加到舞台的时候调用
		this.createChildren = () => {
			this.story_obj_list = this.story_obj_list || {
			}
			super.createChildren()
		}

		this.DeleteMe = () => {

			if (this._list_card_content && this._list_card_content.scrollBar && this._list_card_content.scrollBar.changeHandler) {
				this._list_card_content.scrollBar.changeHandler.recover()
				this._list_card_content.scrollBar.changeHandler = null
			}


			if (need_goods_) {
				need_goods_.DeleteMe()
				need_goods_ = null
			}
			if (delay_fire_obj_) {
				clearTimeout(delay_fire_obj_)
				delay_fire_obj_ = null
			}
			model.open = false
			model.is_first_create = true
			if (this._fight_show) {
				this._fight_show.DeleteMe()
				this._fight_show = null
			}
			if (this.book_power_show) {
				this.book_power_show.DeleteMe()
				this.book_power_show = null
			}
			if (delay_id) {
				clearTimeout(delay_id)
				delay_id = null
			}
			if (this.tab_loop_mgr) {
				this.tab_loop_mgr.DeleteMe()
				this.tab_loop_mgr = null
			}
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			if (this.giftItem) {
				this.giftItem.DeleteMe();
				this.giftItem = null;
			}
			super.DeleteMe()
		}

		this.LoadSuccess = () => {
			this._Scroller2.vScrollBar.visible = false
			this._gp_tab_con.scrollBar.visible = false
			// this._list_card_content.scrollBar.visible = false
			// ResManager.GetInstance().SetTexture(this, this._img_bg_1, "resource/game/monBook/texture/uitjg_003.jpg", null, this, true)
			if (!this._fight_show) {
				this._fight_show = new FightingShowSmallItem(this._fight_con)
				this._fight_show.Load()
				this._fight_show.ExcuteCallback(() => {
				})
			}
			if (!this.book_power_show) {
				this.book_power_show = new FightingShowSmallItem(this.book_fight_con)
				this.book_power_show.Load()
				this.book_power_show.ExcuteCallback(() => {
				})
			}
			let config_mon_pic_type = ResManager.GetInstance().GetGameConfigFromCache(this, "config_mon_pic_type", false)
			let name_list = Util.DeepCopy(model.GetTabNameList(config_mon_pic_type))
			for (let k in name_list) {
				var v = name_list[k]
				v.is_group = false
			}


			if (!this.tab_loop_mgr) {
				this.tab_loop_mgr = new LoopScrowViewMgr()
				this.tab_loop_mgr.SetData(this._gp_tab_con, MonBookTabItem, name_list, LoopScrCon.Horizontal, 1, (_index?) => {
					now_index_ = _index
					this._list_card_content.selectedIndex = -1 //for render again
					this.SetMonBookItemList(now_index_ + 1, true)
					this._img_group_red.visible = model.IsShowMonGroupRedDot()
				}, this.GetRedTabIndex(name_list))
			} else {
				this.tab_loop_mgr.replaceAll(name_list)
			}
			this.SetAllPropertyInfo()
			this.ShowGiftIcon();


		}


		//滚到第一个有红点的标志  如果都没有红点，返回0
		this.GetRedTabIndex = (name_list) => {

			for (let i = 0; i < name_list.length; i++) {
				let mon_book_list = model.GetMonBookList(i + 1, true)
				for (let j = 0; j < mon_book_list.length; j++) {
					let is_red = model.MonBookItemRedDot(mon_book_list[j].type, mon_book_list[j].id)
					if (is_red) {
						return i
					}
				}
			}
			return 0
		}

		this.InitEvent = () => {
			// if (radio_btn_list_[0]) {
			// 	radio_btn_list_[0].group.addEventListener(Laya.UIEvent.CHANGE, this.SwitchFunc, this)
			// }

			this.BindEvent(PushGiftModel.GetInstance(), PushGiftModel.UPDATE_ICON, (giftId: number) => {
				this.ShowGiftIcon();
			})

			local_Util.AddClickEvent(this._img_group, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MonBookGroupView", now_index_)
			}, this, true)

			local_Util.AddClickEvent(this._img_look_attr, () => {
				let config_mon_pic_group = ResManager.GetInstance().GetGameConfigFromCache(this, "config_mon_pic_group", false)
				let config_mon_pic_type = ResManager.GetInstance().GetGameConfigFromCache(this, "config_mon_pic_type", false)

				let list = model.GetAllPropertyList(config_mon_pic_group, config_mon_pic_type)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_PROPERTY_TIPS_VIEW, list, "属性列表")
			}, this, true)

			local_Util.AddClickEvent(this._gp_level_up, () => {
				if (!data_) return
				switch (state_) {
					case 1://激活
						model.Fire(local_MonBookModel.SCMD_REQUEST, 44202, data_.id)
						break
					case 2://升级
						model.Fire(local_MonBookModel.SCMD_REQUEST, 44203, data_.id)
						break;
					case 3:
						Message.show("已满级～")
						break;
				}
			}, this, true)

			local_Util.AddClickEvent(this.decompose_gp, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MonBookDecomposeView")
			}, this, true)

			let LevelSuccess = (type) => {
				this.SetAllPropertyInfo()
				let current_index = now_index_ + 1
				if (current_index == type) {
					this.SetMonBookItemList(type, false)
				}
			}
			this.BindEvent(model, local_MonBookModel.LEVEL_SUCCESS, LevelSuccess)


			let show_effect = (id: number, index: number) => {
				PlayBigEffect(index ? 'ui_shengjitexiao' : 'ui_ZiTi_Jihuo');
			}
			this.BindEvent(model, local_MonBookModel.PLAY_EFFECT, show_effect)


			this.BindEvent(model, local_MonBookModel.REFRESH_TAB_DOT, (index, type) => {
				this.UpdateGmRed(index,type)
			})


			this.BindEvent(model, local_MonBookModel.UPDATE_DECOMPOSE_VIEW, (is_decompose = false) => {
				let is_show
				if (model.can_decompose_list && model.can_decompose_list.length > 0)
					is_show = true
				else
					is_show = false
				this._decompose_red_img.visible = is_show
				if (is_decompose) {
					this.UpdateMessageBox()
				}
			})

			this.BindEvent(goods_model, GoodsModel.GOODS_DECOMPOSE_SUCCESS, () => {
				if (delay_fire_obj_) {
					clearTimeout(delay_fire_obj_)
					delay_fire_obj_ = null
				}
				delay_fire_obj_ = setTimeout(() => {
					model.ClearColorList()
					model.UpdateDecomposeItemList()
					model.Fire(local_MonBookModel.UPDATE_DECOMPOSE_VIEW, true)
					model.UpdateTabDot()
				}, 1000)
			})
			let goods_change_fun = (_type) => {
				if (_type && _type == MainFunc.Treasure) {
					this.UpdateMessageBox()
				}
			}
			this.BindEvent(GlobalEventSystem, EventName.REFRESH_FUNCTION_ICON_RED_DOT, goods_change_fun)
			model.Fire(local_MonBookModel.SCMD_REQUEST, 44205)

			this.BindEvent(model, MonBookModel.PLAY_ITEM_ANIMATION, () => {
				if (!this.is_frist_open) return
				this.item_count++
				if (this.item_count >= this.all_item_count) {
					setTimeout(() => {
						if(this.use_delete_method) return
						this.is_frist_open = false
						this._list_card_content.alpha = 1
						this._list_card_content.scrollTo(this.select_index)
						console.warn("test@load cpm")
						this.PlayAnimation()
					}, 50);

				}

			})

			this.BindEvent(model, local_MonBookModel.REFRESH_BOOK_INFO, (type) => {
				this.SetAllPropertyInfo();
			});

			this.BindEvent(model, local_MonBookModel.REFRESH_NEXT_POWER, (pic_id: number) => {
				let cur_vo = this.now_show_book_list[this.select_index]
				if (!cur_vo) return
				if(cur_vo.id == pic_id){
					this.SetPropertyInfo(cur_vo.type, cur_vo.id)
				}
			})
		}



		this.SetMonBookItemList = (type, is_roll?) => {
			this.now_show_book_list = model.GetMonBookList(type, true)
			if (!this.now_show_book_list)
				return

			if (this._list_card_content && this._list_card_content.selectedIndex && this._list_card_content.selectedIndex == -1) {
				this.select_index = this.GetRedBookIndex(this.now_show_book_list)
			}

			if (!this.loop_mgr) {

				this._list_card_content.alpha = 0

				let len = this.now_show_book_list.length
				this.all_item_count = len >= 16 ? 16 : len
				this.item_count = 0
				this.is_frist_open = true


				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._list_card_content, MonBookItem, this.now_show_book_list, LoopScrCon.Vertical, 1, (index) => {
					this.select_index = index
					this.UpdateMessageBox()
				}, this.select_index)
				this._list_card_content.vScrollBarSkin = ""
				this._list_card_content.scrollBar.changeHandler = Laya.Handler.create(this, this.OnListRoomChange, null, false)
			} else {

				this.loop_mgr.replaceAll(this.now_show_book_list)
				this.loop_mgr.SetSelectIndex(this.select_index)
				if (is_roll) this._list_card_content.scrollTo(this.select_index)
				if (this._list_card_content && this._list_card_content.scrollBar) {
					this.OnListRoomChange(this._list_card_content.scrollBar.value)
				}
			}
		}


		//滚到第一个有红点的标志  如果都没有红点，返回0
		this.GetRedBookIndex = (mon_book_list) => {
			for (let i = 0; i < mon_book_list.length; i++) {
				let is_red = model.MonBookItemRedDot(mon_book_list[i].type, mon_book_list[i].id)
				if (is_red) {
					return i
				}
			}
			return 0
		}

		this.UpdateMessageBox = () => {
			let cur_vo = this.now_show_book_list[this.select_index]
			if (!cur_vo) return
			this.UpdateMonBookMessage(cur_vo)
		}

		this.SwitchFunc = (evt: Laya.UIEvent) => {
			model.open = false
			model.is_first_create = true
		}

		this.SetPropertyInfo = (type, pic_id) => {  
			let data = model.GetBookDataByType(type);
			if (!data) {
				return;
			}
			let pic = data.pic_dict[pic_id];
			if (pic) {
				this.book_power_show.Updatefighting(pic.cur_power);
				if (pic.next_power == 0) {
					this.book_power_show.IsCenter(true, false);
				} else {
					this.book_power_show.UpdatefightingUp(pic.next_power - pic.cur_power);
					this.book_power_show.SetPowerOffset(this.book_power_show.display_obj.width / 4);
				}
			}else{
				let next_power = model.GetActBookPower(pic_id);
				if(!next_power){
					model.Fire(local_MonBookModel.SCMD_REQUEST, 44207, data_.id)
					return
				}
				this.book_power_show.Updatefighting(next_power);
				this.book_power_show.UpdatefightingUp(0);
			}
		}

		this.SetAllPropertyInfo = () => {
			this._fight_show.Updatefighting(model.GetAllBookPower());
		}

		this.GetPropertyList = (data) => {
			let dict = {}
			let cfg, list, prop_id, prop_value

			let pic_list = data.pic_list
			let pic_lv_cfg = model.GetMonPicLvCfg()
			if (pic_lv_cfg) {
				for (let key in pic_list) {
					let data = pic_list[key]
					cfg = pic_lv_cfg[data.pic_id + "@" + data.lv]
					if (cfg) {
						list = local_JSON.parse(cfg.attr)
						for (let key1 in list) {
							let data1 = list[key1]
							prop_id = local_Number(data1[0])
							prop_value = local_Number(data1[1])
							if (dict[prop_id])
								dict[prop_id] = dict[prop_id] + prop_value
							else
								dict[prop_id] = prop_value
						}
					}
				}
			}

			list = []
			for (let key in dict) {
				let data = dict[key]
				list.push({ "0": key, "1": data })
			}
			return list
		}



		this.UpdateMonBookMessage = (data) => {
			if (data) {
				data_ = data
				let max_lv = model.GetBookMaxLevel(data.id)
				let curr_lv = model.GetBookLevel(data.type, data.id)

				let goods_vo = goods_model.GetGoodsBasicByTypeId(data_.id)
				let color_num = data.quality == 6 ? 7 : data.quality
				let color_str = ColorUtil.GetColorDark(color_num)
				this.lv_text.text = `Lv.${curr_lv}`
				if (PlatformManager.IsEyouEnPlatform()) {
					this._lb_name_lv.width = 300
					this._lb_name_lv.style.fontSize = 20
					this._lb_name_lv.style.bold = true
				}else{
				this._lb_name_lv.width = 220
				this._lb_name_lv.style.fontSize = 22
				this._lb_name_lv.style.bold = true
				}
				this._lb_name_lv.innerHTML = local_Util.StrToHTML(`<font color=${color_str}>${(goods_vo.goods_name).trim()}</font>`)


				local_Util.SetImageGray(this._Image11, false)
				this._gp_level_up.mouseEnabled = true
				if (!curr_lv) {
					state_ = 1
					this._lb_level_up.text = "激活"
				}
				else if (curr_lv && curr_lv == max_lv) {
					state_ = 3
					local_Util.SetImageGray(this._Image11, true)
					this._lb_level_up.text = "已满级"
					this._gp_level_up.mouseEnabled = false
				}
				else {
					state_ = 2
					this._lb_level_up.text = "升级"
				}

				//更新属性
				this.SetCurrProp(data_.id, curr_lv)
				this.SetCurrAddProp(data_.id, curr_lv)
				this.SetPropertyInfo(data.type, data.id)

				if (_attr_str_list_.length > 0) {
					this._lb_attr.style.width = 220
					this._lb_attr.style.fontSize = 20
					this._lb_attr.style.leading = 10
					this._lb_attr.innerHTML = local_Util.StrToHTML(_attr_str_list_.join('<br/>'))
				}
				else {
					this._lb_attr.innerHTML = ""
				}

				this.RefuseNeedGoodsAndCont(data_)
			}


		}

		this.SetCurrProp = (pic_id, curr_lv) => {
			let max_lv = model.GetBookMaxLevel(pic_id)
			let real_lv = curr_lv == 0 ? 1 : curr_lv
			let pic_lv_cfg = model.GetMonPicLvCfg()
			let config = pic_lv_cfg ? pic_lv_cfg[pic_id + "@" + real_lv] : undefined
			if (!config)
				return

			curr_value_list_ = {}

			let str, value
			_attr_str_list_ = []
			let list = local_JSON.parse(config.attr)
			if (list && list.length > 0) {
				for (let data of list) {
					if (curr_lv == 0) {
						value = 0
						curr_value_list_[data[0]] = 0
					}
					else {
						value = local_WordManager.ConvertToPercentValue(local_Number(data[0]), local_Number(data[1]))
						curr_value_list_[data[0]] = local_Number(data[1])
					}
					str = `${local_Util.HtmlColorTxt(local_WordManager.GetProperties(data[0]), "'#663915'")}：${local_Util.HtmlColorTxt(value, "'#d15e00'")} `
					_attr_str_list_.push(str)
				}
			}
		}

		this.SetCurrAddProp = (pic_id, curr_lv) => {
			let max_lv = model.GetBookMaxLevel(pic_id)
			if (curr_lv >= max_lv) {
				return
			}

			curr_value_list_

			let real_lv = curr_lv + 1
			let pic_lv_cfg = model.GetMonPicLvCfg()
			let config = pic_lv_cfg ? pic_lv_cfg[pic_id + "@" + real_lv] : undefined
			if (!config)
				return

			let str, value
			let str_list = []
			let list = local_JSON.parse(config.attr)
			if (list && list.length > 0) {
				for (let i in list) {
					let v = list[i]
					value = `+${local_WordManager.ConvertToPercentValue(local_Number(v[0]), local_Number(v[1]) - (curr_value_list_[v[0]] || 0))}`
					_attr_str_list_[i] += local_Util.HtmlColorTxt(value, "'#0a953e'")
				}
			}
		}

		/**更新物品信息 */
		this.RefuseNeedGoodsAndCont = (cur_vo) => {

			//创建
			if (!need_goods_) {
				need_goods_ = new BaseAwardItem(this._item_gp);
				need_goods_.Load()
				need_goods_.SetItemSize(70, 70)
			}

			if (state_ == 3) {
				this.need_cont_lb.style.width = 150
				this.need_cont_lb.style.fontSize = 20
				this.need_cont_lb.innerHTML = "已满级"
				this.need_cont_lb.style.width = 150
				this._level_up_img.visible = false
				let cur_lv = model.GetBookLevel(cur_vo.type, cur_vo.id)
				this.SetCostItem(cur_vo.id,cur_lv,state_)
			} else {
				let next_lv = model.GetBookLevel(cur_vo.type, cur_vo.id) + 1
				this.SetCostItem(cur_vo.id,next_lv,state_)
			}
		}

		this.SetCostItem=(id,lv,state)=>{
			let mon_pic_lv = model.GetMonPicLvCfg()
			let config = mon_pic_lv ? mon_pic_lv[id + "@" + lv] : undefined
			if (!config)
				return

			
			let list = JSON.parse(config.cost)
			let type_id = 0
			let count = 0
			if (list && list.length) {
				type_id = Number(list[0][1])
				count = Number(list[0][2])
				need_goods_.SetData(type_id)
				let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
				let have_num = goods_model.GetBagGoodsNum(type_id)
				this._need_name_lb.text = goods_vo.goods_name
				let str
				if (have_num >= count) {
					str = `<font color='#0a953e'>${have_num}</font>/${count}`
					this._level_up_img.visible = true&&state!=3
				}
				else {
					this._level_up_img.visible = false&&state!=3
					str = `<font color='#ff4f50'>${have_num}</font>/${count}`
				}


				this.need_cont_lb.style.width = 150
				this.need_cont_lb.style.fontSize = 20
				this.need_cont_lb.innerHTML = local_Util.StrToHTML(str)
			}
		}

		this.PlayAnimation = () => {
			if (!this.loop_mgr || !this.loop_mgr.hasInit) return
			if (!this._list_card_content) return
			let box = this._list_card_content.getChildAt(0)
			if (!box) return
			let cell_list = []
			for (let i = 0; i < box.numChildren; i++) {
				let cell = <MonBookItem>box.getChildAt(i)
				if (cell) table.insert(cell_list, cell)
			}
			let sort_fun = (a: MonBookItem, b: MonBookItem) => {
				return a.y < b.y
			}
			table.sort(cell_list, sort_fun)

			for (let i = 0; i < cell_list.length; i++) {
				let cell = cell_list[i]
				let row = Math.ceil((i + 1) / 4)
				cell.PlayAnimation2(row)
			}
		}

		this.UpdateGmRed = (index?, type?) => {
			let is_show
			if (!index) {
				is_show = model.IsShowMonRedDot()
				model.Fire(local_MonBookModel.REFUSE_TAB_RED, type, model.IsShowCurrTabDot(type), false)
			}
			else {
				is_show = model.IsShowMonGroupRedDot()
				this._img_group_red.visible = is_show
			}
		}
	}

	private OnListRoomChange(value) {
		let num = 12
		if (this._arrow_buttom && this._arrow_top) {
			if (this.now_show_book_list && Util.TableSize(this.now_show_book_list) > 0) {
				this._arrow_top.visible = this.now_show_book_list.length > num && value >= (MonBookItem.HEIGT_UI / 2)
				this._arrow_buttom.visible = this.now_show_book_list.length > num && (value < (this._list_card_content.scrollBar.max - MonBookItem.HEIGT_UI / 2))
			} else {
				this._arrow_top.visible = this._arrow_buttom.visible = false
			}
		}
	}
	private ShowGiftIcon() {
		let bool: boolean = Boolean(PushGiftModel.GetInstance().GetGiftList(EnumPushGiftType.eTuPu));
		if (bool) {
			if (!this.giftItem) {
				this.giftItem = new GiftPushIcon(this.giftIcon);
				this.giftItem.Load();
			}
			this.giftItem.ExcuteCallback(() => {
				this.giftItem.SetDate(PushGiftModel.ICON_TYPE, EnumPushGiftType.eTuPu, 0);
			});

		}
		this.giftIcon.visible = bool;

		if (bool) {
			this._img_group.y = 10;
			this.giftIcon.y = 100;
		} else {
			this._img_group.y = 60;
		}
	}

	_Group1: Laya.Box
	_img_bg: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_list_card_content: Laya.List
	_Label1: Laya.Label
	_arrow_buttom: Laya.Image
	_arrow_top: Laya.Image
	_gp_effect: Laya.Box
	_Group3: Laya.HBox
	_fight_con: Laya.HBox
	_Group2: Laya.Box
	_img_look_attr: Laya.Image
	_Group7: Laya.Box
	_img_bg_1: Laya.Image
	_Image6: Laya.Image
	iconBox: Laya.Box
	_img_group: Laya.Image
	_img_group_red: Laya.Image
	giftIcon: Laya.Box
	lv_text: Laya.Label
	_lb_name_lv: Laya.HTMLDivElement
	_Group4: Laya.Box
	_Image9: Laya.Image
	label1: Laya.Label
	decompose_gp: Laya.Box
	_Image10: Laya.Image
	_Label2: Laya.Label
	_decompose_red_img: Laya.Image
	_gp_level_up: Laya.Box
	_Image11: Laya.Image
	_lb_level_up: Laya.Label
	_level_up_img: Laya.Image
	_Group6: Laya.Box
	_item_gp: Laya.Box
	_Group5: Laya.Box
	_need_name_lb: Laya.Label
	need_cont_lb: Laya.HTMLDivElement
	_Scroller2: Laya.Panel
	_lb_attr: Laya.HTMLDivElement
	_gp_tab_con: Laya.List
	book_fight_con: Laya.HBox
	public GetComponents() {
		[
			this._Group1,
			this._img_bg,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image4,
			this._list_card_content,
			this._Label1,
			this._arrow_buttom,
			this._arrow_top,
			this._gp_effect,
			this._Group3,
			this._fight_con,
			this._Group2,
			this._img_look_attr,
			this._Group7,
			this._img_bg_1,
			this._Image6,
			this.iconBox,
			this._img_group,
			this._img_group_red,
			this.giftIcon,
			this.lv_text,
			this._lb_name_lv,
			this._Group4,
			this._Image9,
			this.label1,
			this.decompose_gp,
			this._Image10,
			this._Label2,
			this._decompose_red_img,
			this._gp_level_up,
			this._Image11,
			this._lb_level_up,
			this._level_up_img,
			this._Group6,
			this._item_gp,
			this._Group5,
			this._need_name_lb,
			this.need_cont_lb,
			this._Scroller2,
			this._lb_attr,
			this._gp_tab_con,
			this.book_fight_con
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_img_bg",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Image4",
				"_list_card_content",
				"_Label1",
				"_arrow_buttom",
				"_arrow_top",
				"_gp_effect",
				"_Group3",
				"_fight_con",
				"_Group2",
				"_img_look_attr",
				"_Group7",
				"_img_bg_1",
				"_Image6",
				"iconBox",
				"_img_group",
				"_img_group_red",
				"giftIcon",
				"lv_text",
				"_lb_name_lv",
				"_Group4",
				"_Image9",
				"label1",
				"decompose_gp",
				"_Image10",
				"_Label2",
				"_decompose_red_img",
				"_gp_level_up",
				"_Image11",
				"_lb_level_up",
				"_level_up_img",
				"_Group6",
				"_item_gp",
				"_Group5",
				"_need_name_lb",
				"need_cont_lb",
				"_Scroller2",
				"_lb_attr",
				"_gp_tab_con",
				"book_fight_con",
			])
	}
}
window["MonBookMainView"] = MonBookMainView