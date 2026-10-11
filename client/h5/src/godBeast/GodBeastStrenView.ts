// import { Alert, Alert_Type } from "../alert/Alert";
import { BaseItem1 } from "../common/BaseItem1";
// import { DownDropBtn } from "../common/DownDropBtn";
// import { EquipmentItem } from "../common/EquipmentItem";
// import { ResManager } from "../common/ResManager";
// import { UIToolTipMgr } from "../common/UIToolTipMgr";
// import { WordManager } from "../common/WordManager";
// import { GodBeastDefine, GodBeastEvent, GodBeastModel } from "../commonModel/GodBeastModel";
// import { GoodsModel } from "../commonModel/GoodsModel";
// import { Message } from "../sysInfo/SysInfoController";
// import { Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil";
// import { Util } from "../util/Util";
// import { GodBeastStrenSelectItem } from "./GodBeastStrenSelectItem";

export class GodBeastStrenView extends BaseItem1 {

    // InitEvent
    // InitView
    // ClickColor
    // InitCheckBox
    // ClearCheckBox
    // ClickDouble
    // SendProtoStren
    // OpenTips
    // ClickAll
    // UpdateView
    // UpdateBagItems
    // UpdateEquipItems
    // UpdateShowItems
    // UpdateShowData
    // GetAttrList
    // UpdateAttrs
    // UpdateProgress
    // ProgressAction
    // GetCostGoodsIdList
    // GetExpBySelectGoods
    // SendPreview
    // GetDoubleCost
    // public constructor(parent) {
    //     super(parent)

    //     let _model = GodBeastModel.GetInstance(),
    //         res_mgr = ResManager.GetInstance(),
    //         local_Util = Util,
    //         local_GodBeastEvent = GodBeastEvent,
    //         local_Message = Message,
    //         local_egret = egret,
    //         local_JSON = JSON,
    //         goods_model = GoodsModel.GetInstance(),
    //         local_Number = Number,
    //         local_Enum_ColorUtil_Dark = Enum_ColorUtil_Dark,
    //         local_GodBeastModel = GodBeastModel,
    //         ui_tool_tip_mgr = UIToolTipMgr.GetInstance(),
    //         _attr_list_: Array<eui.Label>,
    //         _ac_item_: eui.ArrayCollection,
    //         _ac_list_: eui.ArrayCollection,
    //         _item_cur_: EquipmentItem,
    //         _item_next_: EquipmentItem,
    //         _cur_info_,
    //         _cur_goods_dic_,
    //         _cur_cond_,
    //         _is_double_ = false,
    //         _pro_max_width_ = 424,
    //         eudemons_strength_cfg_

    //     this.base_file = "godBeast"
    //     this.layout_file = "GodBeastStrenView"

    //     this.load_callback = function () {
    //         this.InitEvent()
    //         this.InitView()
    //         this.UpdateView()
    //     }
    //     this.preload_server_config = {
    //         "config_eudemons_cfg": false,
    //         "config_eudemons_equip_attr": false,
    //         "config_eudemons_strength": false
    //     }
    //     this.preload_client_config = {
    //         "ConfigGodBeast": false
    //     }

    //     this.DeleteMe = () => {
    //         if (_item_cur_) {
    //             _item_cur_.DeleteMe()
    //             _item_cur_ = undefined
    //         }
    //         if (_item_next_) {
    //             _item_next_.DeleteMe()
    //             _item_next_ = undefined
    //         }

    //         eudemons_strength_cfg_ = null
    //         this.ClearCheckBox()
    //         super.DeleteMe()
    //     }


    //     this.InitEvent = () => {

    //         eudemons_strength_cfg_ = res_mgr.GetGameConfigFromCache(this, "config_eudemons_strength", false)
    //         local_Util.AddClickEvent(this._btn_ok, () => {
    //             if (_is_double_) {
    //                 this.OpenTips()
    //             } else {
    //                 this.SendProtoStren()
    //             }
    //         }, this, true)

    //         this.BindEvent(_model, local_GodBeastEvent.SELECT_STREN_MTRL_ITEM, (data, add) => {
    //             if (add) _cur_goods_dic_[data.goods_id] = data
    //             else delete _cur_goods_dic_[data.goods_id]
    //             this.SendPreview()
    //         })

    //         this.BindEvent(_model, local_GodBeastEvent.SELECT_STREN_ITEM, (data) => {
    //             _cur_info_ = data
    //             this.UpdateShowData()
    //             this.SendPreview()
    //         })

    //         this.BindEvent(_model, local_GodBeastEvent.STREN_SUCCESS, () => {
    //             _cur_goods_dic_ = {}
    //             this.UpdateView()
    //             this.UpdateShowData()
    //             this.UpdateProgress()
    //         })

    //         this.BindEvent(_model, local_GodBeastEvent.STREN_UPGRADE, () => {
    //             this.AddUIEffect("ui_shengjichenggong_glow", this._group_eff)
    //         })

    //         this.BindVar(_model, "_beast_info", () => {
    //             if (_cur_info_) {
    //                 _cur_info_ = _model.GetWearEquipInfo(_cur_info_.goods_id)
    //             }
    //             this.UpdateView()
    //             this.UpdateShowData()
    //             this.UpdateProgress()
    //         })

    //         this.BindEvent(_model, local_GodBeastEvent.RECTIVE_STREN_PREVIEW, (scmd) => {
    //             if (_cur_info_ && _cur_info_.goods_id != scmd.goods_id) return
    //             // let wear = _model.GetWearEquipInfo(scmd.goods_id)
    //             let info = _cur_info_
    //             let pre_data = _model.GetStrenData(info.equip_type, scmd.stren, eudemons_strength_cfg_)
    //             let pn_data = _model.GetStrenData(info.equip_type, scmd.stren + 1, eudemons_strength_cfg_)
    //             if (!pn_data && scmd.stren > 0) {
    //                 local_Message.show("升级经验已达最大上限值")
    //             }
    //             let stren = scmd.stren == info.stren ? scmd.stren + 1 : scmd.stren
    //             let attr_list = this.GetAttrList(info, stren)
    //             this.UpdateAttrs(attr_list)
    //             let cn_data = _model.GetStrenData(info.equip_type, info.stren + 1, eudemons_strength_cfg_)

    //             let exp_str = scmd.exp > 0 ? local_Util.HtmlColorTxt(`+${scmd.exp}`, Enum_ColorUtil_Light.GREEN) : ""
    //             this._lb_progress.textFlow = local_Util.StrToHTML(`${info.exp}${exp_str}/${cn_data.exp}`)
    //             let ratio = Math.min((info.exp + scmd.exp) / cn_data.exp, 1)
    //             this._img_progress.width = ratio * _pro_max_width_

    //             if (scmd.stren <= 0) {
    //                 scmd.stren = 1
    //                 pre_data = _model.GetStrenData(info.equip_type, scmd.stren, eudemons_strength_cfg_)
    //             }
    //             if (_item_next_ && pre_data) {
    //                 _item_next_.SetStrengthen(scmd.stren)
    //             }
    //         })
    //     }

    //     this.InitView = () => {
    //         _cur_goods_dic_ = {}
    //         _attr_list_ = Array<eui.Label>()

    //         _ac_item_ = new eui.ArrayCollection()
    //         this._group_item.dataProvider = _ac_item_
    //         this._group_item.itemRenderer = GodBeastStrenSelectItem

    //         _ac_list_ = new eui.ArrayCollection()
    //         this._list.dataProvider = _ac_list_
    //         this._list.itemRenderer = GodBeastStrenView

    //         let config = res_mgr.GetGameConfigFromCache(this, "ConfigGodBeast", true)
    //         let color_cfg = _model.GetDonwDropData("drop_stren_cfg", config)
    //         this._dd_color.Init(color_cfg, this.ClickColor, "全部", "content", undefined, 3, undefined, false)
    //         this.UpdateBagItems(99)

    //         this.InitCheckBox()
    //     }

    //     this.ClickColor = (index, data) => {
    //         _cur_goods_dic_ = {}
    //         this._cb_all.selected = false
    //         _cur_cond_ = data.cond
    //         this.UpdateBagItems(data.cond)
    //         this.UpdateShowData()
    //     }

    //     this.InitCheckBox = () => {
    //         this._cb_all.addEventListener(local_egret.Event.CHANGE, this.ClickAll, this)
    //         this._cb_double.addEventListener(local_egret.Event.CHANGE, this.ClickDouble, this)
    //     }

    //     this.ClearCheckBox = () => {
    //         this._cb_all.removeEventListener(local_egret.Event.CHANGE, this.ClickAll, this)
    //         this._cb_double.removeEventListener(local_egret.Event.CHANGE, this.ClickDouble, this)
    //     }

    //     this.ClickDouble = (evt: egret.Event) => {
    //         let checkbox: eui.CheckBox = evt.target
    //         _is_double_ = checkbox.selected
    //         if (local_Util.TableSize(_cur_goods_dic_) > 0) {
    //             this.SendPreview()
    //         }
    //     }

    //     this.SendProtoStren = () => {
    //         if (!_cur_info_) return
    //         let id = _cur_info_.goods_id
    //         let is_double = _is_double_ ? 1 : 0
    //         let list = this.GetCostGoodsIdList()
    //         if (list.length < 1) { local_Message.show("没有选中强化材料"); return; }
    //         _model.Fire(local_GodBeastEvent.BEAST_EQUIP_STREN, id, is_double, list)
    //     }

    //     this.OpenTips = () => {
    //         let list = this.GetCostGoodsIdList()
    //         if (list.length < 1) { local_Message.show("没有选中强化材料"); return; }
    //         let config = res_mgr.GetGameConfigFromCache(this, "config_eudemons_cfg", false)
    //         let cost = this.GetDoubleCost(config)
    //         cost = local_JSON.parse(cost)[0]
    //         let own = goods_model.GetRoleSpecGoodsNum(local_Number(cost[0]), local_Number(cost[1]))
    //         let [type_id] = goods_model.GetMappingTypeId(cost[0], cost[1])
    //         let name = GoodsModel.GetGoodsName(type_id)
    //         let add_exp = this.GetExpBySelectGoods()
    //         cost = Math.ceil(add_exp / 200 * local_Number(cost[2]))
    //         let str1 = local_Util.HtmlColorTxt(`${cost}${name}`, local_Enum_ColorUtil_Dark.GREEN)
    //         let str2 = local_Util.HtmlColorTxt(`双倍强化经验`, local_Enum_ColorUtil_Dark.GREEN)
    //         let str = local_Util.StrToHTML(`本次强化将会消耗${str1}获得${str2}，（优先消耗绑钻），是否确认强化`)

    //         let cancel_func = (is_from_close) => {
    //             if (is_from_close) return
    //             this._cb_double.selected = false
    //             _is_double_ = false
    //         }
    //         let ok_func = () => {
    //             // if (own < cost) {
    //             //     let str = `当前绑钻余额不足，还需${cost - own}绑钻，是否前往充值`
    //             //     Alert.Show(str, Alert_Type.Two, () => {
    //             //         OpenFun.OpenFunHandler(21)
    //             //     }, cancel_func, "确定", "取消")
    //             // } else {
    //             this.SendProtoStren()
    //             // }
    //         }

    //         Alert.Show(str, Alert_Type.Two, ok_func, cancel_func, "确定", "取消")
    //     }

    //     this.ClickAll = (evt: egret.Event) => {
    //         let checkbox: eui.CheckBox = evt.target
    //         let list = _ac_item_.source
    //         for (let info of list) {
    //             if (!info.type_id) continue
    //             info._select = checkbox.selected
    //             if (info._select) _cur_goods_dic_[info.goods_id] = info
    //             else delete _cur_goods_dic_[info.goods_id]
    //         }
    //         _ac_item_.refresh()
    //         this.SendPreview()
    //     }

    //     this.UpdateView = () => {
    //         this.UpdateEquipItems()
    //         this.UpdateBagItems(_cur_cond_)
    //     }

    //     this.UpdateBagItems = (cond) => {
    //         _cur_goods_dic_ = {}
    //         let list = _model.GetGoodsByDropCond(cond)
    //         list.sort((a, b) => {
    //             if (a.subtype != 51 && b.subtype != 51) {
    //                 return a.rating - b.rating
    //             } else {
    //                 return a.subtype == 51 ? -1 : 1
    //             }
    //         })
    //         for (let info of list) {
    //             info._select = false
    //         }
    //         if (list.length < GodBeastDefine.STREN_BAG_COUNT) {
    //             local_GodBeastModel.EMPTY_BAG_DATA._select = false
    //             for (let i = list.length; i < GodBeastDefine.STREN_BAG_COUNT; i++) {
    //                 // list.push({ type_id: 0, _select: false })
    //                 list.push(local_GodBeastModel.EMPTY_BAG_DATA)
    //             }
    //         }
    //         _ac_item_.source = list
    //     }

    //     this.UpdateEquipItems = () => {
    //         let list = _model.GetAllBeastEquips()
    //         list.sort((a, b) => { return b.rating - a.rating })
    //         _ac_list_.source = list
    //         if (!_cur_info_) {
    //             _ac_list_.refresh()
    //             local_egret.callLater(() => {
    //                 _model.Fire(local_GodBeastEvent.SELECT_STREN_ITEM, list[0])
    //             }, this)
    //         }
    //     }

    //     this.UpdateShowItems = (info) => {
    //         let cur_data = _model.GetStrenData(info.equip_type, info.stren, eudemons_strength_cfg_)
    //         let next_data = _model.GetStrenData(info.equip_type, info.stren + 1, eudemons_strength_cfg_)
    //         if (!_item_cur_) {
    //             _item_cur_ = new EquipmentItem(this._group_cur)
    //             _item_cur_.Load()
    //         }
    //         if (!_item_next_ && next_data) {
    //             _item_next_ = new EquipmentItem(this._group_next)
    //             _item_next_.Load()
    //         }

    //         if (_item_cur_) {
    //             _item_cur_.ExcuteCallback(() => {
    //                 _item_cur_.SetData(info.type_id)
    //                 _item_cur_.SetStrengthen(info.stren)
    //             })
    //             _item_cur_.SetClickCallBack(() => {
    //                 ui_tool_tip_mgr.AppendGodBeastTips(info.type_id, null, null, info)
    //             })
    //         }
    //         if (_item_next_ && next_data) {
    //             _item_next_.ExcuteCallback(() => {
    //                 _item_next_.SetData(info.type_id)
    //                 _item_next_.SetStrengthen(info.stren + 1)
    //             })
    //             _item_next_.SetClickCallBack(() => {
    //                 ui_tool_tip_mgr.AppendGodBeastTips(info.type_id, null, null, info)
    //             })
    //         }
    //         this._img_arrow.visible = !!next_data
    //         this._img_arrow.includeInLayout = !!next_data
    //         this._group_next.visible = !!next_data
    //         this._group_next.includeInLayout = !!next_data
    //     }

    //     this.UpdateShowData = () => {
    //         if (!_cur_info_) return
    //         let info = _cur_info_
    //         this.UpdateShowItems(info)
    //         let cur_data = _model.GetStrenData(info.equip_type, info.stren, eudemons_strength_cfg_)
    //         let attr_list = this.GetAttrList(info)
    //         this.UpdateAttrs(attr_list)
    //         this.UpdateProgress()
    //     }

    //     this.GetAttrList = (info, next_stren?) => {
    //         if (!info) return []
    //         let dic = []
    //         let attr_list = info.base_attrlist || info.attr
    //         // let attrs = JSON.parse(attr_list)
    //         let attrs = JSON.parse(attr_list)
    //         for (let attr of attrs) {
    //             dic[attr[0]] = { key: attr[0], value: local_Number(attr[1]), cur: 0 }
    //         }
    //         //这里默认属性一样
    //         let cur_data = _model.GetStrenData(info.equip_type, info.stren, eudemons_strength_cfg_)
    //         next_stren = next_stren || info.stren + 1
    //         let next_data = _model.GetStrenData(info.equip_type, next_stren, eudemons_strength_cfg_)
    //         if (cur_data) {
    //             attrs = local_JSON.parse(cur_data.attr)
    //             for (let attr of attrs) {
    //                 dic[attr[0]].value += local_Number(attr[1])
    //                 dic[attr[0]].cur = local_Number(attr[1])
    //             }
    //         }
    //         if (next_data) {
    //             attrs = local_JSON.parse(next_data.attr)
    //             for (let attr of attrs) {
    //                 dic[attr[0]].add = local_Number(attr[1]) - dic[attr[0]].cur
    //             }
    //         }
    //         let list = []
    //         for (let key in dic) {
    //             list.push(dic[key])
    //         }
    //         return list
    //     }

    //     this.UpdateAttrs = (attr_list) => {
    //         for (let i = 0; i < attr_list.length; i++) {
    //             let attr = attr_list[i]
    //             let label = _attr_list_[i]
    //             if (!label) {
    //                 label = new eui.Label()
    //                 label.textColor = local_Enum_ColorUtil_Dark.WHITE
    //                 label.size = 24
    //                 this._group_attr.addChild(label)
    //                 _attr_list_[i] = label
    //             }
    //             let name = WordManager.GetProperties(attr.key)
    //             let stren = attr.add ? local_Util.HtmlColorTxt(`+${attr.add}`, local_Enum_ColorUtil_Dark.GREEN) : ""
    //             let str = `${name}：${attr.value}  ${stren}`
    //             label.textFlow = local_Util.StrToHTML(str)
    //             label.visible = true
    //         }

    //         for (let i = attr_list.length; i < _attr_list_.length; i++) {
    //             _attr_list_[i].visible = false
    //         }
    //     }

    //     this.UpdateProgress = () => {
    //         if (!_cur_info_) return
    //         let info = _cur_info_
    //         let next_data = _model.GetStrenData(info.equip_type, info.stren + 1, eudemons_strength_cfg_)
    //         if (!next_data) {
    //             this._lb_progress.text = "已满级"
    //             this._img_progress.width = _pro_max_width_
    //             return
    //         }
    //         this._lb_progress.text = `${info.exp}/${next_data.exp}`
    //         this._img_progress.width = info.exp / next_data.exp * _pro_max_width_
    //     }

    //     this.ProgressAction = (exp, texp) => {
    //         let tar_width = exp / texp * _pro_max_width_
    //         let cur_width = this._img_progress.width
    //         // if(cur_width < target)
    //         // this._img_progress.width = 
    //     }

    //     this.GetCostGoodsIdList = () => {
    //         let list = []
    //         for (let key in _cur_goods_dic_) {
    //             list.push(_cur_goods_dic_[key].goods_id)
    //         }
    //         return list
    //     }

    //     this.GetExpBySelectGoods = () => {
    //         let exp = 0
    //         for (let key in _cur_goods_dic_) {
    //             let info = _cur_goods_dic_[key]
    //             let eudemons_equip_attr_cfg = res_mgr.GetGameConfigFromCache(this, "config_eudemons_equip_attr", false)
    //             let data = _model.GetEquipData(info.type_id, eudemons_equip_attr_cfg)
    //             if (!data) continue
    //             exp += data.base_exp
    //         }
    //         return exp
    //     }

    //     this.SendPreview = () => {
    //         if (!_cur_info_) return
    //         let list = this.GetCostGoodsIdList()
    //         if (list.length < 1) { this.UpdateShowData(); return; }
    //         let id = _cur_info_.goods_id
    //         let is_double = _is_double_ ? 1 : 0
    //         _model.Fire(local_GodBeastEvent.SEND_STREN_PREVIEW, id, is_double, list)
    //     }

    //     this.GetDoubleCost = (config) => {
    //         let cfg = config[`strength_cost_gold@cost`]
    //         return cfg && cfg.value
    //     }
    // }
    // _Image11: Laya.Image
    // _Image2: Laya.Image
    // _Image3: Laya.Image
    // _Image4: Laya.Image
    // _Image5: Laya.Image
    // _Image6: Laya.Image
    // _Label1: Laya.Label
    // _Label2: Laya.Label
    // _Label3: Laya.Label
    // _Label4: Laya.Label
    // _Scroller1: Laya.Panel
    // _group_item: Laya.VBox
    // _Scroller2: Laya.Panel
    // _group_attr: Laya.VBox
    // _Scroller3: Laya.Panel
    // _list: Laya.VBox
    // _Group1: Laya.Box
    // _Image7: Laya.Image
    // _img_progress: Laya.Image
    // _lb_progress: Laya.Label
    // _Group2: Laya.HBox
    // _group_cur: Laya.Box
    // _img_arrow: Laya.Image
    // _group_next: Laya.Box
    // _btn_ok: Laya.Box
    // _Image1: Laya.Image
    // labelDisplay: Laya.Label
    // _dd_color: Laya.Box
    // _Label5: Laya.Label
    // _Label6: Laya.Label
    // _group_eff: Laya.Box
    // public GetComponents() {
    //     [
    //         this._Image11,
    //         this._Image2,
    //         this._Image3,
    //         this._Image4,
    //         this._Image5,
    //         this._Image6,
    //         this._Label1,
    //         this._Label2,
    //         this._Label3,
    //         this._Label4,
    //         this._Scroller1,
    //         this._group_item,
    //         this._Scroller2,
    //         this._group_attr,
    //         this._Scroller3,
    //         this._list,
    //         this._Group1,
    //         this._Image7,
    //         this._img_progress,
    //         this._lb_progress,
    //         this._Group2,
    //         this._group_cur,
    //         this._img_arrow,
    //         this._group_next,
    //         this._btn_ok,
    //         this._Image1,
    //         this.labelDisplay,
    //         this._dd_color,
    //         this._Label5,
    //         this._Label6,
    //         this._group_eff,
    //     ]
    //         = this.GetChildrenByNames([

    //             "_Image11",
    //             "_Image2",
    //             "_Image3",
    //             "_Image4",
    //             "_Image5",
    //             "_Image6",
    //             "_Label1",
    //             "_Label2",
    //             "_Label3",
    //             "_Label4",
    //             "_Scroller1",
    //             "_group_item",
    //             "_Scroller2",
    //             "_group_attr",
    //             "_Scroller3",
    //             "_list",
    //             "_Group1",
    //             "_Image7",
    //             "_img_progress",
    //             "_lb_progress",
    //             "_Group2",
    //             "_group_cur",
    //             "_img_arrow",
    //             "_group_next",
    //             "_btn_ok",
    //             "_Image1",
    //             "labelDisplay",
    //             "_dd_color",
    //             "_Label5",
    //             "_Label6",
    //             "_group_eff",
    //         ])
    // }
}
window["GodBeastStrenView"] = GodBeastStrenView