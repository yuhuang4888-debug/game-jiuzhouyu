import { Alert, Alert_Type } from "../alert/Alert";
import { BaseItem1 } from "../common/BaseItem1";
import { EventName } from "../common/EventName";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { RedDotController } from "../common/RedDotController";
import { RedKey } from "../common/RedDotDefine";
import { ModuleType, RedDotManager } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { GodBeastDefine, GodBeastEvent, GodBeastModel } from "../commonModel/GodBeastModel";
import { MainFunc } from "../commonModel/MainUIModel";
import { EnumPushGiftType, PushGiftModel } from "../commonModel/PushGiftModel";
import { GiftPushIcon } from "../mainUI/GiftPushIcon";
import { Message } from "../sysInfo/SysInfoController";
import { Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { PlayBigEffect, Util } from "../util/Util";
import { GodBeastAttrItem } from "./GodBeastAttrItem";
import { GodBeastEquipItem } from "./GodBeastEquipItem";
import { GodBeastItem } from "./GodBeastItem";
import { GodBeastSkillItem } from "./GodBeastSkillItem";

export class GodBeastView extends BaseItem1 {

    InitEvent
    UpdateView
    LoadSuccess
    ClickItem
    UpdateItems
    InitEquipItems
    UpdateEquipItems
    UpdateShowData
    UpdatePosData
    UpdateAttrs
    GetAttrList
    UpdateShowBeastData
    UpdateSkills
    SetBtnStatus
    SetDefaultItem
    attr_loop_list
    attr_loop_mgr: LoopScrowViewMgr
    item_loop_mgr: LoopScrowViewMgr
    UpdateRed
    UpdateCombRed

    private giftItem: GiftPushIcon;

    public constructor(parent) {
        super(parent)
        let _model = GodBeastModel.GetInstance(),
            local_Util = Util,
            local_Message = Message,
            local_GlobalEventSystem = GlobalEventSystem,
            local_EventName = EventName,
            local_Alert = Alert,
            local_Alert_Type = Alert_Type,
            local_GodBeastEvent = GodBeastEvent,
            res_mgr = ResManager.GetInstance(),
            local_ModuleType = ModuleType,
            // func_open_model = FunctionOpenModel.GetInstance(),
            // local_FuncOpenId = FuncOpenId,
            local_GodBeastModel = GodBeastModel,
            red_dot_mgr = RedDotManager.GetInstance(),
            _equip_list_ = new Array<GodBeastEquipItem>(),
            _skill_list_ = new Array<GodBeastSkillItem>(),
            _point_list_ = new Array<Laya.Image>(),
            // _ac_item_: eui.ArrayCollection,
            // _ac_attr_: eui.ArrayCollection,
            _beast_info_,
            _cur_info_,
            _frist_update_ = false

        this.base_file = "godBeast"
        this.layout_file = "GodBeastView"

        this.load_callback = function () {
            this.LoadSuccess()
            this.InitEvent()
            this.UpdateView()
        }
        this.preload_server_config = {
            "config_eudemons_item": false,
            "config_eudemons_equip_pos": false,
            "config_eudemons_equip_attr": false,
        }
        this.DeleteMe = () => {
            for (let key in _equip_list_) {
                _equip_list_[key].DeleteMe()
            }
            _equip_list_.length = 0

            for (let item of _skill_list_) {
                item.DeleteMe()
            }
            _skill_list_.length = 0

            _cur_info_ = undefined
            _model._select_beast_id = undefined
            // if (this._list_item) {
            //     this._list_item.removeEventListener(eui.ItemTapEvent.ITEM_TAP, this.ClickItem, this)
            // }
            if (this.attr_loop_mgr) {
                this.attr_loop_mgr.DeleteMe
                this.attr_loop_mgr = null
            }
            if (this.item_loop_mgr) {
                this.item_loop_mgr.DeleteMe
                this.item_loop_mgr = null
            }
            if(this.giftItem){
                this.giftItem.DeleteMe()
                this.giftItem = null;
            }
            

            super.DeleteMe()
        }

        this.InitEvent = () => {
            RedDotController.ins.bind(RedKey.GOD_BEAST_MIJUAN, this._red_senyao);
            this.BindEvent(PushGiftModel.GetInstance(), PushGiftModel.UPDATE_ICON, (giftId: number) => {
                this.ShowGiftIcon();
            })

            local_Util.AddClickEvent(this._btn_add_pos, () => {
                if (!_beast_info_) return
                if (_beast_info_.fight_count >= GodBeastDefine.POS_MAX_COUNT) {
                    local_Message.show("助战位已扩充至上限")
                } else {
                    local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "GodBeastTipsView")
                }
            }, this, true)

            local_Util.AddClickEvent(this._btn_disboard, () => {
                if (!_cur_info_) return
                if (_cur_info_.equip_list.length < 1) { local_Message.show("没有穿戴装备"); return; }
                if (_cur_info_.state == 2) {
                    local_Alert.Show("拆除当前装备将会取消该蜃妖的助战状态，是否继续", local_Alert_Type.Two, () => {
                        _model.Fire(local_GodBeastEvent.REQUEST_PROTO, 17304, "ic", _cur_info_.id, 0)
                    }, undefined, "确定", "取消")
                } else {
                    _model.Fire(local_GodBeastEvent.REQUEST_PROTO, 17304, "ic", _cur_info_.id, 0)
                }
            }, this, true)

            local_Util.AddClickEvent(this._btn_bag, () => {
                local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "GodBeastBagView")
            }, this, true)

            local_Util.AddClickEvent(this._btn_callback, () => {
                if (!_cur_info_) return
                if (_cur_info_.state != 2) { local_Message.show("没有出战"); return; }
                local_Alert.Show("召回蜃妖可能会导致战力下降，是否召回", local_Alert_Type.Two, () => {
                    _model.Fire(local_GodBeastEvent.REQUEST_PROTO, 17305, "ic", _cur_info_.id, 1)
                })
            }, this, true)

            local_Util.AddClickEvent(this._btn_fight, () => {
                if (!_beast_info_) return
                if (!_cur_info_) return
                if (_cur_info_.state == 2) {
                    local_Message.show("已经出战"); return;
                }
                let fight_count = _model._fight_count
                if (fight_count >= _beast_info_.fight_count) {
                    local_Message.show("当前助战位已满"); return;
                }
                _model.Fire(local_GodBeastEvent.REQUEST_PROTO, 17305, "ic", _cur_info_.id, 2)
            }, this, true)

            local_Util.AddClickEvent(this._btn_gray, () => {
                local_Message.show("需要激活蜃妖后方可助战")
            }, this, true)

            local_Util.AddClickEvent(this._btn_equip, () => {
                if (!_cur_info_) return
                let id = _cur_info_.id
                let eudemons_equip_pos = res_mgr.GetGameConfigFromCache(this, "config_eudemons_equip_pos", false)
                let eudemons_equip_attr = res_mgr.GetGameConfigFromCache(this, "config_eudemons_equip_attr", false)
                let list = _model.GetBestEquipGoodIDList(id, eudemons_equip_pos, eudemons_equip_attr)
                if (list.length < 1) { local_Message.show("没有装备可以穿戴"); return; }
                if (_cur_info_.equip_list.length > 0) {
                    local_Alert.Show(`是否将旧蜃妖装备的熟练度经验无损转移至新的蜃妖装备？`, local_Alert_Type.Two, () => {
                        _model.Fire(local_GodBeastEvent.QUICK_EQUIP, id, 1, list)
                    }, (bool) => {
                        if (!bool) {
                            _model.Fire(local_GodBeastEvent.QUICK_EQUIP, id, 0, list)
                        }
                    }, "确认", "取消")
                } else {
                    _model.Fire(local_GodBeastEvent.QUICK_EQUIP, id, 1, list)
                }
            }, this, true)

            this.BindVar(_model, "_beast_info", () => {
                this.UpdateView()
                _cur_info_ = this._list_item.selectedItem
                this.UpdateShowData()
            })

            this.BindEvent(local_GlobalEventSystem, local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, (_type) => {
                if (_type && _type == MainFunc.Treasure && !this.use_delete_method) {
                    this.UpdateView()
                    _cur_info_ = this._list_item.selectedItem
                    this.UpdateShowData()
                }
            })

            // this.BindEvent(_model, local_GodBeastEvent.BEAST_ACTIVE, () => {
            //     //this.AddUIEffect("ui_jihuochenggong_glow", this._group_eff)
            // })

            local_Util.AddClickEvent(this._btn_stren, () => {
                // let list = GodBeastModel.GetInstance().GetAllBeastEquips()
                // if (list.length < 1) {
                //     Message.show("暂无装备可以强化！")
                // } else {
                //     GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GodBeastStrenBaseView")
                // }
                local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "GodBeastComView")
            }, this, true)


            this.BindEvent(local_GlobalEventSystem, local_EventName.UPDATE_REDDOT, (mType, rType) => {
                if (_cur_info_ && ModuleType.BEAST_EQUIP == mType && rType == _cur_info_.id) {
                    this.UpdateRed(_cur_info_.id)
                }
                if (mType != local_ModuleType.BEAST_STREN) return
                // this._red_stren.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.BEAST_STREN)
            })
            this.BindVar(_model, "beastComRed", () => {
                this.UpdateCombRed()
            })



        }

        this.UpdateCombRed = () => {
            //如果有可以一键穿戴的item则不显示合成红点
            // this._red_stren.visible=false
            // let  beast_info_ = _model.GetBeastInfo()
            // if(!beast_info_)return
            // let eudemons_list= beast_info_.eudemons_list
            // let is_red=false
            // for(let i=0;i<eudemons_list.length;i++){
            //     let vo = eudemons_list[i]
            //     is_red = RedDotManager.GetInstance().CheckRedStatus(ModuleType.BEAST_EQUIP, vo.id)
            //     if(is_red){
            //         return
            //     }
            // }
            this._red_stren.visible = _model.beastComRed
        }

        this.UpdateRed = (id) => {
            this._red_wear.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.BEAST_EQUIP, id)
        }

        this.UpdateView = () => {
            _beast_info_ = _model.GetBeastInfo()
            if (!_beast_info_) return
            let beast_info = _beast_info_
            this.UpdateItems(beast_info.eudemons_list)
            this.UpdatePosData()
        }

        this.LoadSuccess = () => {
            this._group_attr.scrollBar.visible = false
            this._list_item.scrollBar.visible = false

            _model.Fire(local_GodBeastEvent.REQUEST_PROTO, 17301)
            this.InitEquipItems()
            local_Util.SetImageGray(this._btn_gray, true)
            this.UpdateCombRed()
            this.ShowGiftIcon();

        }

        this.ClickItem = (index) => {
            let old_id = _model._select_beast_id
            _cur_info_ = this._list_item.selectedItem
            if (!_cur_info_) {
                return
            }
            _model._select_beast_id = _cur_info_.id
            if (old_id == _cur_info_.id) return
            this.UpdateShowData()
            this.UpdateRed(_cur_info_.id)
            _model.Fire(local_GodBeastEvent.SELECT_SBEAST_ITEM, _cur_info_)
        }

        this.UpdateItems = (list) => {
            if (!this.item_loop_mgr) {
                this.item_loop_mgr = new LoopScrowViewMgr()
                this.item_loop_mgr.SetData(this._list_item, GodBeastItem, list, LoopScrCon.Horizontal, 1, (index?) => {
                    this.ClickItem(index)
                })
            } else {
                this.item_loop_mgr.replaceAll(list)
            }

            if (!_frist_update_) {
                this._list_item.refresh()
                this.SetDefaultItem()
            }
        }

        this.InitEquipItems = () => {
            for (let pos of local_GodBeastModel.EQUIP_POS_LIST) {
                let item = new GodBeastEquipItem(this._group_equip, pos)
                item.Load()
                _equip_list_[pos] = item
            }
        }

        this.UpdateEquipItems = () => {
            if (!_cur_info_) return

            for (let key in _equip_list_) {
                let item = _equip_list_[key]
                item.SetBeastId(_cur_info_.id)
                // item.ExcuteCallback(() => {
                item.SetDefault(_cur_info_)
                // })
            }

            let list = _cur_info_.equip_list
            for (let data of list) {
                let item = _equip_list_[data.pos]
                item.SetData(data)
            }
        }

        this.UpdateShowData = () => {
            this.UpdateShowBeastData()
            this.UpdateEquipItems()
            this.UpdateAttrs()
            this.SetBtnStatus()
            this.UpdateCombRed()
        }

        this.UpdatePosData = () => {
            _beast_info_ = _model.GetBeastInfo()
            if (!_beast_info_) return
            let count = _model._fight_count
            let str = local_Util.HtmlColorTxt(`${count}/${_beast_info_.fight_count}`, Enum_ColorUtil_Dark.GREEN)
            this._lb_count.style.fontSize = 20
            this._lb_count.style.color = "#663915"
            this._lb_count.width = 140
            this._lb_count.innerHTML = local_Util.StrToHTML(`助战蜃妖:${str}`)
        }

        this.UpdateAttrs = () => {
            if (!_cur_info_) return
            if (!this.attr_loop_mgr) {
                this.attr_loop_mgr = new LoopScrowViewMgr()
                this.attr_loop_mgr.SetData(this._group_attr, GodBeastAttrItem, this.GetAttrList(), LoopScrCon.Vertical, 1)
            } else {
                this.attr_loop_mgr.replaceAll(this.GetAttrList())
            }
        }

        this.GetAttrList = () => {
            let info = _cur_info_
            if (!info) return []
            let eudemons_item_cfg = res_mgr.GetGameConfigFromCache(this, "config_eudemons_item", false)
            let data = _model.GetBeastData(info.id, eudemons_item_cfg)
            if (!data) return []
            let attrs = JSON.parse(data.base_att)
            let dic = []
            for (let attr of attrs) {
                dic[attr[0]] = { key: attr[0], value: attr[1], add: 0 }
            }
            for (let attr of info.equip_attr) {
                let value = dic[attr.attr_type]
                if (value) {
                    value.add = attr.attr_value
                } else {
                    dic[attr.attr_type] = { key: attr.attr_type, value: 0, add: attr.attr_value }
                }
            }
            let list = []
            for (let key in dic) {
                list.push(dic[key])
            }
            return list
        }

        this.UpdateShowBeastData = () => {
            let info = _cur_info_
            if (!info) return
            let eudemons_item_cfg = res_mgr.GetGameConfigFromCache(this, "config_eudemons_item", false)
            let data = _model.GetBeastData(info.id, eudemons_item_cfg)
            if (!data) return

            this.UpdateSkills(data)
            let path = `resource/game/godBeast/other/${data.icon_id}.png`
            res_mgr.SetTexture(this, this._img_icon, path)
        }

        this.UpdateSkills = (data) => {
            if (_skill_list_) {
                for (let item of _skill_list_) {
                    item.DeleteMe()
                    item = null
                }
                _skill_list_ = []
            }
            let list = JSON.parse(data.skill_ids)
            for (let i = 0; i < list.length; i++) {
                let sdata = list[i]
                let item = _skill_list_[i]
                if (!item) {
                    item = new GodBeastSkillItem(this._group_skill)
                    // let pos = this._skill_pos_list[i]
                    // item.SetPosition(pos[0], pos[1])
                    item.Load()
                    _skill_list_[i] = item
                }
                item.SetData(sdata)
            }
            // let pos = list.length > 1 ? this._skill_pos_list[0] : this._skill_pos_list[1]
            // _skill_list_[0].SetPosition(pos[0], pos[1])
        }

        this.SetBtnStatus = () => {
            if (!_cur_info_) return
            let info = _cur_info_
            this._btn_gray.visible = info.state == 0
            this._btn_fight.visible = info.state == 1
            this._btn_callback.visible = info.state == 2

            let full_equip = info.equip_list.length >= local_GodBeastModel.EQUIP_POS_LIST.length
            this._btn_equip.visible = !full_equip
            this._btn_disboard.visible = full_equip

            this._red_fight.visible = red_dot_mgr.CheckRedStatus(local_ModuleType.BEAST_FIGHT, info.id)
        }

        this.SetDefaultItem = () => {
            if (_frist_update_) return
            _beast_info_ = _model.GetBeastInfo()
            if (!_beast_info_) return
            _frist_update_ = true
            let beast_info = _beast_info_
            let has_red = false
            for (let i = 0; i < beast_info.eudemons_list.length; i++) {
                let data = beast_info.eudemons_list[i]
                let red1 = red_dot_mgr.CheckRedStatus(local_ModuleType.BEAST_EQUIP, data.id)
                let red2 = red_dot_mgr.CheckRedStatus(local_ModuleType.BEAST_FIGHT, data.id)
                let red3 = red_dot_mgr.CheckAnyRedStatus(local_ModuleType.BEAST_STREN, data.id)
                let red4 = _model.GetReplaceRedStatus(data.id)
                if (red1 || red2 || red3 || red4) {
                    this._list_item.selectedIndex = i
                    this._list_item.selectedItem = data
                    _cur_info_ = data
                    _model._select_beast_id = _cur_info_.id
                    this.UpdateShowData()
                    this._list_item.refresh()
                    this.item_loop_mgr.FirstOnChild(i)
                    has_red = true
                    break
                }
            }
            if (!has_red) {
                let data = beast_info.eudemons_list[0]
                this._list_item.selectedIndex = 0
                this._list_item.selectedItem = data
                _cur_info_ = data
                _model._select_beast_id = _cur_info_.id
                this.UpdateRed(_cur_info_.id)
                this.UpdateShowData()
            }
        }
    }

    private ShowGiftIcon() {
        let bool: boolean = Boolean(PushGiftModel.GetInstance().GetGiftList(EnumPushGiftType.eShiYao));
        if (bool) {
            if (!this.giftItem) {
                this.giftItem = new GiftPushIcon(this.giftIcon);
                this.giftItem.Load();
            }
            this.giftItem.ExcuteCallback(() => {
                this.giftItem.SetDate(PushGiftModel.ICON_TYPE, EnumPushGiftType.eShiYao);
            });

        }
        this.giftIcon.visible = bool;
    }


    _img_bg: Laya.Image
    _img_1: Laya.Image
    _Image1: Laya.Image
    _Image2: Laya.Image
    _Image4: Laya.Image
    _img_icon: Laya.Image
    _Image5: Laya.Image
    _btn_add_pos: Laya.Image
_red_senyao:Laya.Image
    _lb_count: Laya.HTMLDivElement
    _Label2: Laya.Label
    _Label3: Laya.Label
    _group_attr: Laya.List
    _group_equip: Laya.HBox
    _group_skill: Laya.VBox
    _group_eff: Laya.Box
    _group_point: Laya.HBox
    _list_item: Laya.List
    _btn_disboard: Laya.Box
    _Image11111: Laya.Image
    labelDisplay: Laya.Label
    _btn_equip: Laya.Box
    _Image1111: Laya.Image
    labelDisplay1: Laya.Label
    _red_wear: Laya.Image
    _btn_bag: Laya.Box
    _Image11: Laya.Image
    labelDisplay111: Laya.Label
    _btn_stren: Laya.Box
    _Image111: Laya.Image
    labelDisplay11: Laya.Label
    _btn_callback: Laya.Image
    _btn_fight: Laya.Image
    _btn_gray: Laya.Image
    _red_fight: Laya.Image
    _red_stren: Laya.Image
    _Image3: Laya.Image
    _Label33: Laya.Label
    giftIcon: Laya.Box
    public GetComponents() {
        [
            this._img_bg,
            this._img_1,
            this._Image1,
            this._Image2,
            this._Image4,
            this._img_icon,
            this._Image5,
            this._btn_add_pos,
this._red_senyao,
            this._lb_count,
            this._Label2,
            this._Label3,
            this._group_attr,
            this._group_equip,
            this._group_skill,
            this._group_eff,
            this._group_point,
            this._list_item,
            this._btn_disboard,
            this._Image11111,
            this.labelDisplay,
            this._btn_equip,
            this._Image1111,
            this.labelDisplay1,
            this._red_wear,
            this._btn_bag,
            this._Image11,
            this.labelDisplay111,
            this._btn_stren,
            this._Image111,
            this.labelDisplay11,
            this._btn_callback,
            this._btn_fight,
            this._btn_gray,
            this._red_fight,
            this._red_stren,
            this._Image3,
            this._Label33,
            this.giftIcon,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_1",
                "_Image1",
                "_Image2",
                "_Image4",
                "_img_icon",
                "_Image5",
                "_btn_add_pos",
"_red_senyao",
                "_lb_count",
                "_Label2",
                "_Label3",
                "_group_attr",
                "_group_equip",
                "_group_skill",
                "_group_eff",
                "_group_point",
                "_list_item",
                "_btn_disboard",
                "_Image11111",
                "labelDisplay",
                "_btn_equip",
                "_Image1111",
                "labelDisplay1",
                "_red_wear",
                "_btn_bag",
                "_Image11",
                "labelDisplay111",
                "_btn_stren",
                "_Image111",
                "labelDisplay11",
                "_btn_callback",
                "_btn_fight",
                "_btn_gray",
                "_red_fight",
                "_red_stren",
                "_Image3",
                "_Label33",
                "giftIcon",
            ])
    }
}
window["GodBeastView"] = GodBeastView