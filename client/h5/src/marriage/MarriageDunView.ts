import { Alert, Alert_Type } from "../alert/Alert";
import { BaseItem1 } from "../common/BaseItem1";
import { Config } from "../common/Config";
import { DownDropBtn } from "../common/DownDropBtn";
import { EquipmentItem } from "../common/EquipmentItem";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel";
import { FriendEvent, FriendModel, FRIEND_TYPE } from "../commonModel/FriendModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MarriageDefine, MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { VipModel } from "../commonModel/VipModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { SetHtmlCenter, Util } from "../util/Util";
import { MarriageDropBtn } from "./MarriageDropBtn";
import { GameResPath } from "../util/GameResPath";

export class MarriageDunView extends BaseItem1 {




    _drop_btn: MarriageDropBtn
    LoadSuccess
    InitEvent
    UpdateDunCount
    CheckTimeEnough
    UpdateView
    SetFriendBtn
    ClickFriendDrop
    UpdateAwardItems
    public constructor(parent) {
        super(parent)
        this.base_file = "marriage";
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageDunView"
        let _model = MarriageModel.GetInstance(),
            res_mgr = ResManager.GetInstance(),
            local_Util = Util,
            vip_model = VipModel.GetInstance(),
            role_mgr = RoleManager.GetInstance(),
            dungeon_model = BaseDungeonModel.GetInstance(),
            friend_model = FriendModel.GetInstance(),
            local_FriendEvent = FriendEvent,
            Marriage = DUN_TYPE.Marriage,
            local_Message = Message,
            REQUEST_PROTO = MarriageEvent.REQUEST_PROTO,
            local_Enum_ColorUtil_Dark = Enum_ColorUtil_Dark,
            local_MarriageDefine = MarriageDefine,
            _item_list_: Array<EquipmentItem>,
            _friend_list_,
            _cur_role_data_,
            _no_friend_,
            _total_buy_count_ = 0

        this.load_callback = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.img4, GameResPath.GetIcon("marriage", "uijh_123"))
            this.LoadSuccess()
            this.InitEvent()
        }

        this.DeleteMe = () => {
            if (_item_list_) {
                for (let item of _item_list_) {
                    item.DeleteMe()
                }
                _item_list_.length = 0
            }
            _no_friend_ = undefined
            if (this._drop_btn) {
                this._drop_btn.DeleteMe()
                this._drop_btn = null
            }
            super.DeleteMe()
        }

        this.LoadSuccess = () => {
            _item_list_ = []
            this.scroll.hScrollBar.visible = false
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("marriage", "ui_marry_bg4"))
            let str1 = local_Util.HtmlColorTxt("异性/伴侣", "'#fae50a'")
            let str2 = local_Util.HtmlColorTxt("520后", "'#fae50a'")
            let str = `与${str1}一起进入副本，同性好友亲密度超过${str2}也可一起进入`
            this._lb_tips.style.fontSize = 16
            this._lb_tips.style.color = "#ffffff"
            this._lb_tips.style.align = "center"
            this._lb_tips.style.valign = "middle"
            this._lb_tips.width = 564
            this._lb_tips.height = 30
            this._lb_tips.innerHTML = local_Util.StrToHTML(str)
            this._lb_tips.style.padding = [(this._lb_tips.height - this._lb_tips.contextHeight) / 2, 0, 0, 0];     //垂直居中
            SetHtmlCenter(this._lb_tips, { "x": 10, "w": 546 })

            let dungeon_ui_content = res_mgr.GetGameConfigFromCache(this, "config_dungeon_ui_content", false)
            if (dungeon_ui_content) {
                let cfg = dungeon_ui_content[local_MarriageDefine.DUN_ID]
                if (cfg) {
                    let list = cfg.rewards || cfg[1]
                    if (list) {
                        let rewards = JSON.parse(list)
                        this.UpdateAwardItems(rewards)
                    }
                }
            }

            let vip_card = vip_model.GetNobleCardState()
            let vip_flag = role_mgr.GetMainRoleVo().vip_flag
            _total_buy_count_ = vip_model.GetVipPrivilegeValue(
                BaseDungeonModel.MODULE_ID,
                BaseDungeonModel.VIP_PARAMETER + Marriage
                , vip_card, vip_flag)

            //请求好友数据
            friend_model.Fire(local_FriendEvent.REQUEST_FRIEND_DATA, FRIEND_TYPE.FRIEND)
            //请求副本信息
            dungeon_model.Fire(BaseDungeonModel.SCMD_REQUEST, 61020, Marriage)
        }

        this.InitEvent = () => {
            // this.BindEvent(_model, "", () => {
            //     this.UpdateView()
            // })

            local_Util.AddClickEvent(this._btn_go, () => {
                if (!_cur_role_data_) {
                    local_Message.show("请先选择一个队友")
                    return
                }
                if (!this.CheckTimeEnough()) {
                    local_Message.show("自己次数不足")
                    return
                }

                if (_cur_role_data_.online_flag == 0) {
                    //镜像确认
                    let str = `伴侣处于离线状态，是否邀请对方镜像入场战斗？镜像通关时，无法进行默契答题双倍奖励？`
                    Alert.Show(str, Alert_Type.Two, () => {
                        if(_cur_role_data_){
                            dungeon_model.Fire(BaseDungeonModel.SCMD_REQUEST, 61046, 1, local_MarriageDefine.DUN_ID, _cur_role_data_.role_id)
                        }
                    })
                } else {
                    dungeon_model.Fire(BaseDungeonModel.SCMD_REQUEST, 61046, 1, local_MarriageDefine.DUN_ID, _cur_role_data_.role_id)
                }

            }, this, true)

            local_Util.AddClickEvent(this._btn_match, () => {
                // local_Message.show("自动匹配")
                if (!this.CheckTimeEnough()) {
                    local_Message.show("自己次数不足")
                    return
                }
                _model.Fire(REQUEST_PROTO, 17245, "ci", 1, local_MarriageDefine.DUN_ID)
            }, this, true)

            local_Util.AddClickEvent(this._btn_add, () => {
                let married = role_mgr.GetMainRoleVo().is_marriage == 2
                if (!married) {
                    local_Message.show("结婚后方可增加额外次数")
                    return
                }
                let dinfo = _model.GetDunInfo()
                if(!dinfo)return
                // let count = dinfo.vip_count + dinfo.add_count
                // if (count >= _total_buy_count_) {
                //     local_Message.show("购买次数已达上限")
                //     return
                // }
                let cfgs = res_mgr.GetGameConfigFromCache(this, "config_dungeon", false)
                let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, local_MarriageDefine.DUN_ID, false, cfgs)
                if (!cfg) return
                let cost_list = ErlangParser.GetInstance().Parse(cfg.buy_count_cost)
                //没购买取第0个,购买了1次取第1个
                // let cdata = cost_list[dinfo.vip_count]
                // if (!cdata) return
                let cdata = cost_list[0]
                if (!cdata) return
                let color = dinfo.vip_count >= _total_buy_count_ ? local_Enum_ColorUtil_Dark.RED : local_Enum_ColorUtil_Dark.GREEN
                let remain = _total_buy_count_ - dinfo.vip_count
                let str4 = local_Util.HtmlColorTxt(`${cdata[1]}勾玉（优先扣除绑玉）`, local_Enum_ColorUtil_Dark.GREEN)
                let str5 = local_Util.HtmlColorTxt(`${cdata[0]}次`, local_Enum_ColorUtil_Dark.GREEN)
                let str = `花费${str4}可以为伴侣和自己同时增加${str5}挑战次数，是否购买？\n `
                let str1 = local_Util.HtmlColorTxt(`今天可购买次数：`, local_Enum_ColorUtil_Dark.GREEN)
                let str2 = local_Util.HtmlColorTxt(`${remain}/${_total_buy_count_}`, color)
                let str3 = local_Util.StrToHTML(`${str}${str1}${str2}`)
                Alert.Show(str3, Alert_Type.Two, () => {
                    dungeon_model.Fire(BaseDungeonModel.SCMD_REQUEST, 61021, local_MarriageDefine.DUN_ID, 1)
                }, (is_close) => {
                    if (!is_close) _model.Fire(REQUEST_PROTO, 17295, "i", local_MarriageDefine.DUN_ID)
                }, "购买", "请TA购买")
            }, this, true)

            local_Util.AddClickEvent(this._btn_help, () => {
                GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 1721)
            }, this, true)

            this.BindEvent(friend_model, local_FriendEvent.FRIEND_DATA_UPDATE, () => {
                if (_no_friend_ != undefined) return
                let list = _model.GetCanDunFriendList()
                this.SetFriendBtn(list)
            })

            this.BindEvent(dungeon_model, BaseDungeonModel.UPDATE_DUNGEON_TYPE_VIEW, (dun_type) => {
                if (dun_type != Marriage) return
                this.UpdateDunCount()
            })

            this.BindEvent(dungeon_model, BaseDungeonModel.UPDATE_DUNGEON_TIME, (dun_id) => {
                if (MarriageDefine.DUN_ID == dun_id) {
                    this.UpdateDunCount()
                }
            })
        }

        this.UpdateDunCount = () => {
            let dinfo = _model.GetDunInfo()
            if (dinfo) {
                //每日默认次数 = vip默认次数 + 副本默认次数
                let daily_default_count = Number(dinfo.count_cond)
                let total_count: number = dinfo.add_count + dinfo.vip_count + daily_default_count
                let left_times = total_count - dinfo.daily_count
                this._lb_count.text = `副本次数：${left_times}/${total_count}`
            }
        }

        this.CheckTimeEnough = () => {
            let dinfo = _model.GetDunInfo()
            if(!dinfo)return false
            let daily_default_count = Number(dinfo.count_cond)
            let total_count: number = dinfo.add_count + dinfo.vip_count + daily_default_count
            let left_times = total_count - dinfo.daily_count
            return left_times > 0
        }


        this.UpdateView = () => {

        }

        this.SetFriendBtn = (list) => {
            if (list.length <= 0) {
                _friend_list_ = [{ role_name: local_Util.HtmlColorTxt("无可邀请对象", "'#F44767'") }]
                _no_friend_ = true
            } else {
                let role_vo = role_mgr.GetMainRoleVo()
                let fdata = friend_model.getFriendById(role_vo.marriage_id)
                if (list[0] != fdata) {
                    let del_list = list.splice(list.indexOf(fdata), 1)
                    list.unshift(del_list[0])
                }
                _friend_list_ = list
                _no_friend_ = false
            }
            if (!this._drop_btn) {
                // this._drop_btn = new MarriageDropBtn(this._drop_btn_con)
                this._drop_btn = new DownDropBtn(this._drop_btn_con)
                this._drop_btn.Init(_friend_list_, this.ClickFriendDrop, undefined, "role_name", undefined, 5)
                this._drop_btn.Load()
            }
        }
        this.ClickFriendDrop = (index, data) => {
            if (_no_friend_) {
                local_Message.show("无可邀请对象");
                return;
            }
            let role_vo = role_mgr.GetMainRoleVo()
            let is_mate = role_vo.marriage_id == data.role_id
            this._img_mate.visible = is_mate
            _cur_role_data_ = data
        }

        this.UpdateAwardItems = (list) => {
            if (!list || list.length < 1) return
            for (var i = 0; i < list.length; i++) {
                let item = _item_list_[i]
                let info = list[i]
                if (!item) {
                    item = new EquipmentItem(this._group_item)
                    item.Load()
                    item.SetItemSize(87, 87)
                    _item_list_[i] = item
                }
                let [type_id] = GoodsModel.GetInstance().GetMappingTypeId(info[0], info[1])
                item.SetData(type_id, info[2])
            }
        }
    }


    bg: Laya.Image
    _btn_add: Laya.Image
    img2: Laya.Image
    img4: Laya.Image
    _lb_count: Laya.Label
    label2: Laya.Label
    label3: Laya.Label
    _lb_tips: Laya.HTMLDivElement
    _btn_match: Laya.Box
    _Image11: Laya.Image
    labelDisplay11: Laya.Label
    _btn_go: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    scroll: Laya.Panel
    _group_item: Laya.HBox
    _drop_btn_con: Laya.Box
    _img_mate: Laya.Image
    _btn_help: Laya.Image
    public GetComponents() {
        [
            this.bg,
            this._btn_add,
            this.img2,
            this.img4,
            this._lb_count,
            this.label2,
            this.label3,
            this._lb_tips,
            this._btn_match,
            this._Image11,
            this.labelDisplay11,
            this._btn_go,
            this._Image1,
            this.labelDisplay,
            this.scroll,
            this._group_item,
            this._drop_btn_con,
            this._img_mate,
            this._btn_help,
        ]
            = this.GetChildrenByNames([

                "bg",
                "_btn_add",
                "img2",
                "img4",
                "_lb_count",
                "label2",
                "label3",
                "_lb_tips",
                "_btn_match",
                "_Image11",
                "labelDisplay11",
                "_btn_go",
                "_Image1",
                "labelDisplay",
                "scroll",
                "_group_item",
                "_drop_btn_con",
                "_img_mate",
                "_btn_help",
            ])
    }
}
window["MarriageDunView"] = MarriageDunView