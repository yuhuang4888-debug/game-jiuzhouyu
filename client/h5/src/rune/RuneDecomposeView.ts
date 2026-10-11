import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { WordManager } from "../common/WordManager";
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { DungeonEnterView } from "../dungeon/DungeonEnterView";
import { PlatformManager } from "../PlatformManager";
import { Message } from "../sysInfo/SysInfoController";
import { ColorType, ColorUtil, Enum_ColorUtil_Light, Enum_ColorUtil_NEW } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { HtmlColorTxt, PlayBigEffect, Util } from "../util/Util";
import { RuneDecMainView } from "./RuneDecMainView";
import { RuneDecomposeItem } from "./RuneDecomposeItem";

export class RuneDecomposeView extends BaseItem1 {

    LoadSuccess
    InitEvent
    InitView
    UpdateSelectGoodsDic
    UpdateView
    UpdateItems
    InitGainItems
    UpdateGainDataOne
    UpdateGainData
    InitCheckBox
    CancelCheckBoxStatus
    CheckBoxHandle
    ClearCheckBoxEvent
    GetGoodsByColor
    CheckPreview
    GetDecomposeList
    GetPreviewList

    bag_loop_mgr: LoopScrowViewMgr
    public constructor(parent) {
        super(parent)
        this.base_file = "rune"
        this.layout_file = "RuneDecomposeView"
        let _model = RuneModel.GetInstance(),
            local_laya = Laya,
            res_mgr = ResManager.GetInstance(),
            local_Util = Util,
            local_GlobalEventSystem = GlobalEventSystem,
            local_EventName = EventName,
            goods_model = GoodsModel.GetInstance(),
            local_GoodsModel = GoodsModel,
            local_RuneEvent = RuneEvent,
            local_WordManager = WordManager,
            local_ColorType = ColorType,
            _ac_item_: Laya.List,
            _cb_list_: Array<number>,
            select_goods_dic_: { [key: number]: any },
            _bag_rune_: Array<any>,
            _gain_dic_

        this.load_callback = function () {
            this.LoadSuccess()
        }

        this.DeleteMe = () => {
            this.ClearCheckBoxEvent()
            this.ClearUIEffect(this._gp_effect)
            Laya.Tween.clearAll(this)
            if (this.bag_loop_mgr) {
                this.bag_loop_mgr.DeleteMe()
                this.bag_loop_mgr = undefined
            }
            super.DeleteMe()
        }

        this.LoadSuccess = () => {
            if (PlatformManager.IsEyouEnPlatform()) {
                this._Label11.width = 434
                this._Label11.height = 40
                this._Label11.y = 624
                this._Label11.wordWrap = true
                this._Label11.align = "center"
                this._Label11.leading = 0.1
                this._Label1.pos(13,663)
                this._Label1.width = 125
                this._Label1.height = 51
                this._Label1.leading = 0.1
                this._Label1.wordWrap = true
                this._Label12.pos(13,663)
                this._Label12.width = 125
                this._Label12.height = 51
                this._Label12.leading = 0.1
                this._Label12.wordWrap = true
                this.labelDisplay.fontSize = 18
                this.labelDisplay1.fontSize = 18
            }
            // res_mgr.SetTexture(this, this._bg, "resource/game/soul/texture/uisy_023.png")
            this._list_item.scrollBar.visible = false
            this.InitEvent()
            this.InitView()
        }

        this.InitEvent = () => {

            local_Util.AddClickEvent(this._btn_get, () => {
                let challenge_data = BaseDungeonModel.GetInstance().GetRuneChallengeData()
                if (challenge_data) {
                    let cfgs = Config.PRELOAD_SERVER_CONFIG.config_dungeon
                    let dun_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, challenge_data.dun_id, false, cfgs)
                    if(RoleManager.GetInstance().GetMainRoleVo().fighting >= Number(dun_cfg.recommend_power) * BaseDungeonModel.Recommend_Power_Module){
                        local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterView.Index.Rune)
                    }
                    else{
                        _model.Fire(RuneEvent.CHANGE_RUNE_TAB, 1);
                    }
                }else{
                    _model.Fire(RuneEvent.CHANGE_RUNE_TAB, 1);
                }
                
            }, this, true)

            local_Util.AddClickEvent(this._btn_decompose, () => {
                let goods_list = this.GetDecomposeList()
                if (goods_list.length) {
                    goods_model.Fire(local_GoodsModel.RESOLVE_GOODS, goods_list)
                }
                else {
                    Message.show("请先选择需要分解的物品")
                }
            }, this, true)

            this.BindEvent(_model, local_RuneEvent.RUNE_SELECT_DECOMPOSE_ITEM, (data) => {
                if (data.is_selected) {
                    //选择相同不做处理
                    let old_data = select_goods_dic_[data.goods_id]
                    if (old_data && old_data.is_selected) return
                    select_goods_dic_[data.goods_id] = data
                } else {
                    delete select_goods_dic_[data.goods_id]
                }

                this.CheckPreview()
            })

            this.BindEvent(_model, local_RuneEvent.RESOLVE_PREVIEW, (data) => {
                this.UpdateGainData(data)
            })

            this.BindEvent(goods_model, local_GoodsModel.GOODS_DECOMPOSE_SUCCESS, () => {
                PlayBigEffect("ui_fenjietexiao")
            })

            //符文背包更新
            this.BindEvent(goods_model, local_GoodsModel.CHANGE_RUNE_BAG_LIST, () => {
                if (_model.RuneDecSelectTab != _model.DECOMPOSE) return;
                let delete_list = {}
                if (_bag_rune_) {
                    for (let i in _bag_rune_) {
                        let v = _bag_rune_[i]
                        delete_list[v.goods_id] = i
                    }
                }

                let now_bag = _model.GetRunesInBag()
                for (let key in now_bag) {
                    let vo = now_bag[key]
                    if (delete_list[vo.goods_id]) {
                        delete delete_list[vo.goods_id]
                    }
                }

                let now_index = {}
                let len = this._list_item.numChildren
                for (let i = 0; i < len; i++) {
                    let item = <RuneDecomposeItem>this._list_item.getChildAt(i)
                    now_index[item["index"]] = { x: item.x, y: item.y - this._list_item.scrollBar.value }
                }
                for (let a in delete_list) {
                    let b = delete_list[a]
                    let pos = now_index[b]
                    if (pos) {
                        let group = new Laya.Box()
                        group.x = pos.x + 20 + 175 / 2
                        group.y = pos.y + 75 + 17 + 119 / 2
                        this._gp_effect.addChild(group)
                        let call_back = () => {
                            this.AddUIEffect("ui_achievementglow2", group, null, null, true, null, null, null, null, true)
                            Laya.Tween.to(group, { x: 145, y: 610 }, 800, Laya.Ease.circOut, Laya.Handler.create(this, () => {
                                this.ClearUIEffect(group)
                                let end_call = () => {
                                    Laya.Tween.clearAll(group)
                                    this.ClearUIEffect(group)
                                    this._gp_effect.removeChild(group)
                                }
                                this.AddUIEffect("ui_achievementglow3", group, null, null, false, null, null, null, null, true)
                            }))
                        }
                        this.AddUIEffect("ui_achievementglow1", group, { x: -13, y: -75 }, null, false, null, call_back, null, null, true)
                    }
                }
                select_goods_dic_ = {}
                _model.decSelectNum = 0
                this.UpdateView()
                this.CancelCheckBoxStatus()
            })

            this.BindEvent(_model, local_RuneEvent.RUNE_RESOLUTION_RETURN, () => {
                select_goods_dic_ = {}
                _model.decSelectNum = 0
                this.UpdateView()
                this.CancelCheckBoxStatus()
            })

            this.BindEvent(_model, local_RuneEvent.UPDATE_RUNE_DATA, () => {
                if (!this.use_delete_method) {
                    this.InitGainItems()
                }
            })
        }

        this.InitView = () => {
            // _ac_item_ = new Laya.ArrayCollection()
            // this._list_item.dataProvider = _ac_item_
            // this._list_item.itemRenderer = RuneDecomposeItem

            _cb_list_ = new Array<number>();
            select_goods_dic_ = {};
            _gain_dic_ = {};

            this.InitCheckBox()
            this.UpdateView()
            this.InitGainItems()
            //初始化物品dic(必须先赋值_bag_souls)
            this.UpdateSelectGoodsDic()
            this.GetGoodsByColor(local_ColorType.BLUE, true)

            let img_state: Laya.Image = this._cb_blue.getChildAt(1) as Laya.Image
            img_state.visible = true
        }

        this.UpdateSelectGoodsDic = () => {
            if (_bag_rune_) {
                for (let info of _bag_rune_) {
                    if (info.is_selected) {
                        select_goods_dic_[info.goods_id] = info
                    }
                }
            }
        }

        this.UpdateView = () => {
            _bag_rune_ = _model.GetRunesInBag()

            this.UpdateSelectGoodsDic()
            this.UpdateItems(_bag_rune_)
            this.CheckPreview()
            this._reddot.visible = _model.CanResolve()
        }

        this.UpdateItems = (list) => {
            if (!this.bag_loop_mgr) {
                this.bag_loop_mgr = new LoopScrowViewMgr()
                this.bag_loop_mgr.SetData(this._list_item, RuneDecomposeItem, list, LoopScrCon.Vertical, 3)
            } else {
                this.bag_loop_mgr.replaceAll(list)
            }
            this.none_conta.visible = (!(list && Util.TableSize(list) > 0))
        }

        this.InitGainItems = () => {
            let exp_id = RuneModel.RuneExp
            let own = _model.GetRuneExp()
            this.UpdateGainDataOne(exp_id, true, local_WordManager.FormatNumber2(own))
            // let list = SoulDefine.DECOMPOSE_GOODS_ID
            // for (let i = 0; i < list.length; i++) {
            // let type_id = exp_id
            // let own = goods_model.GetTypeGoodsNum(type_id)
            // let own_str = local_WordManager.ConvertNum(own, false)
            // this.UpdateGainDataOne(type_id, own > 0, own_str)
            // }
        }

        this.UpdateGainDataOne = (type_id, visible, txt?) => {
            let cfg = RuneModel.RuneDecomposeGoods[type_id]
            if (!_gain_dic_[type_id]) {
                _gain_dic_[type_id] = {
                    group: this[`_group_gain${cfg.id}`],
                    label: this[`_lb_gain${cfg.id}`],
                    img: this[`_img_gain${cfg.id}`],
                }
                res_mgr.SetTexture(this, _gain_dic_[type_id].img, local_GoodsModel.GetGoodsPath(type_id))
            }
            let gainObj = _gain_dic_[type_id]
            gainObj.group.visible = visible
            gainObj.label.style.fontSize = 20
            gainObj.label.style.color = "#ffffff"

            gainObj.label.width = 180


            // gainObj.group.includeInLayout = visible
            if (visible) {
                gainObj.label.innerHTML = String(txt)
            }
        }

        this.UpdateGainData = (data) => {
            let exp_id = RuneModel.RuneExp
            // let own = goods_model.GetTypeGoodsNum(exp_id)
            let own = _model.GetRuneExp()
            let txt = data.exp > 0 ? local_Util.HtmlColorTxt(`+${local_WordManager.FormatNumber2(data.exp)}`, ColorUtil.TransHtmlColor(Enum_ColorUtil_NEW.LIGHT_GREEN)) : ""
            this.UpdateGainDataOne(exp_id, true, `${local_WordManager.FormatNumber2(own)} ${txt}`)

            let list = data.result_list
            list.sort((a, b) => { return a.typeId - b.typeId })

            // let id_list = SoulDefine.DECOMPOSE_GOODS_ID
            // for (let i = 0; i < id_list.length; i++) {
            //     let info = list[i]
            //     let type_id = id_list[i]
            //     let own = goods_model.GetTypeGoodsNum(type_id)
            //     let own_str = local_WordManager.ConvertNum(own, false)
            //     if (!info) {
            //         this.UpdateGainDataOne(type_id, own > 0, own_str)
            //     } else {
            //         let txt = local_Util.HtmlColorTxt(`+${info.count}`, Enum_ColorUtil_Light.GREEN)
            //         this.UpdateGainDataOne(info.typeId, true, `${own_str}${txt}`)
            //     }
            // }
        }

        this.InitCheckBox = () => {
            for (let data of RuneModel.RuneCheckColor) {
                let check = this[`_cb_${data.key}`]
                let check_lb = this[`${data.key}_lb`]
                let check_state = this[`${data.key}_state`]
                if (check && check_lb && check_state) {
                    check_state.visible = false
                    check.tag = data.id
                    check_lb.color = ColorUtil.GetColorDark(data.id, false)
                    check_lb.text = data.name
                    local_Util.AddClickEvent(check, (e: Laya.Event) => {
                        this.CheckBoxHandle(e)
                    }, this, true)
                }
            }


        }

        this.CancelCheckBoxStatus = () => {
            for (let data of RuneModel.RuneCheckColor) {
                let check_state = this[`${data.key}_state`]
                if (check_state.visible == true) {
                    if (data.id >= 4) {  //橙色及以上在玩家勾选分解成功后会去除勾选状态
                        check_state.visible = false
                        this.GetGoodsByColor(Number(data.id), false, false)
                    } else {  //紫色以下勾选框在玩家点击勾选，分解成功不会去除勾选状态，保留之前的勾选状态
                        this.GetGoodsByColor(Number(data.id), true, false)
                    }
                } else {
                    check_state.visible = false
                    this.GetGoodsByColor(Number(data.id), false, false)
                }
            }
            this.UpdateItems(_bag_rune_)
            this.CheckPreview()
        }

        this.CheckBoxHandle = (evt: Laya.Event) => {
            let checkbox: Laya.Box = evt.target as Laya.Box
            let img_state: Laya.Image = checkbox.getChildAt(1) as Laya.Image
            img_state.visible = !img_state.visible
            this.GetGoodsByColor(Number(checkbox.tag), img_state.visible)
        }

        this.ClearCheckBoxEvent = () => {
            // for (let data of RuneModel.RuneCheckColor) {
            // let checkBox: Laya.CheckBox = this[`_cb_${data.key}`]
            // checkBox.removeEventListener(Laya.Event.CHANGE, this.CheckBoxHandle, this)
            // }
        }

        this.GetGoodsByColor = (color: number, select: boolean, update_now = true) => {
            _model.decSelectNum = 0
            for (let info of _bag_rune_) {
                let is_color = color == local_ColorType.BLUE ? info.color <= color : info.color == color
                if (is_color && info.is_selected != select) {
                    //最高品质并且没被选中的情况下不做处理
                    if (info.is_better && !info.is_selected) continue
                    if (info.subtype == 99) continue
                    info.is_selected = select
                    if (info.is_selected) {
                        if (_model.decSelectNum > RuneModel.MaxDecNum) {
                            break
                        }
                        select_goods_dic_[info.goods_id] = info
                        _model.decSelectNum++
                    } else {
                        _model.decSelectNum--
                        delete select_goods_dic_[info.goods_id]
                    }
                }
            }
            if (update_now) {
                this.UpdateItems(_bag_rune_)
                this.CheckPreview()
            }
        }

        this.CheckPreview = () => {
            let list = this.GetPreviewList()
            if (list.length) {
                _model.Fire(local_RuneEvent.REQUEST_RESOLVE_PREVIEW, list)
            }
            else {
                this.InitGainItems()
            }
        }

        this.GetDecomposeList = () => {
            let list = []
            for (let id in select_goods_dic_) {
                list.push({ goods_id: select_goods_dic_[id].goods_id, goods_num: 1 })
            }
            return list
        }

        this.GetPreviewList = () => {
            let list = []
            for (let id in select_goods_dic_) {
                list.push(select_goods_dic_[id].goods_id)
            }
            return list
        }
    }

    _Image111: Laya.Image
    _Image2: Laya.Image
    _Scroller1: Laya.Panel
    _list_item: Laya.List
    _btn_get: Laya.Box
    _Image1: Laya.Image
    labelDisplay1: Laya.Label
    _btn_decompose: Laya.Box
    _Image11: Laya.Image
    labelDisplay: Laya.Label
    _Label12: Laya.Label
    _Image4: Laya.Image
    _Group1: Laya.HBox
    _group_gain1: Laya.Box
    _Image5: Laya.Image
    _img_gain1: Laya.Image
    _lb_gain1: Laya.HTMLDivElement
    _group_gain2: Laya.Box
    _Image6: Laya.Image
    _img_gain2: Laya.Image
    _lb_gain2: Laya.HTMLDivElement
    _group_gain3: Laya.Box
    _Image7: Laya.Image
    _img_gain3: Laya.Image
    _lb_gain3: Laya.HTMLDivElement
    _reddot: Laya.Image
    _Label1: Laya.Label
    _gp_effect: Laya.Box
    _Label11: Laya.Label
    check_group: Laya.Box
    _cb_blue: Laya.Box
    blue_state: Laya.Image
    blue_lb: Laya.Text
    _cb_purple: Laya.Box
    purple_state: Laya.Image
    purple_lb: Laya.Text
    _cb_orange: Laya.Box
    orange_state: Laya.Image
    orange_lb: Laya.Text
    _cb_red: Laya.Box
    red_state: Laya.Image
    red_lb: Laya.Text
    none_conta: Laya.Box
    tips: Laya.Label
    tips_icon: Laya.Image
    public GetComponents() {
        [
            this._Image111,
            this._Image2,
            this._Scroller1,
            this._list_item,
            this._btn_get,
            this._Image1,
            this.labelDisplay1,
            this._btn_decompose,
            this._Image11,
            this.labelDisplay,
            this._Label12,
            this._Image4,
            this._Group1,
            this._group_gain1,
            this._Image5,
            this._img_gain1,
            this._lb_gain1,
            this._group_gain2,
            this._Image6,
            this._img_gain2,
            this._lb_gain2,
            this._group_gain3,
            this._Image7,
            this._img_gain3,
            this._lb_gain3,
            this._reddot,
            this._Label1,
            this._gp_effect,
            this._Label11,
            this.check_group,
            this._cb_blue,
            this.blue_state,
            this.blue_lb,
            this._cb_purple,
            this.purple_state,
            this.purple_lb,
            this._cb_orange,
            this.orange_state,
            this.orange_lb,
            this._cb_red,
            this.red_state,
            this.red_lb,
            this.none_conta,
            this.tips,
            this.tips_icon,
        ]
            = this.GetChildrenByNames([

                "_Image111",
                "_Image2",
                "_Scroller1",
                "_list_item",
                "_btn_get",
                "_Image1",
                "labelDisplay1",
                "_btn_decompose",
                "_Image11",
                "labelDisplay",
                "_Label12",
                "_Image4",
                "_Group1",
                "_group_gain1",
                "_Image5",
                "_img_gain1",
                "_lb_gain1",
                "_group_gain2",
                "_Image6",
                "_img_gain2",
                "_lb_gain2",
                "_group_gain3",
                "_Image7",
                "_img_gain3",
                "_lb_gain3",
                "_reddot",
                "_Label1",
                "_gp_effect",
                "_Label11",
                "check_group",
                "_cb_blue",
                "blue_state",
                "blue_lb",
                "_cb_purple",
                "purple_state",
                "purple_lb",
                "_cb_orange",
                "orange_state",
                "orange_lb",
                "_cb_red",
                "red_state",
                "red_lb",
                "none_conta",
                "tips",
                "tips_icon",
            ])
    }
}
window["RuneDecomposeView"] = RuneDecomposeView