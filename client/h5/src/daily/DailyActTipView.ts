import { Alert, Alert_Type } from "../alert/Alert";
import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { ActivityForeshowManager } from "../commonModel/ActivityForeshowManager";
import { DailyModel } from "../commonModel/DailyModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { GuildModel } from "../commonModel/GuildModel";
import { RoleManager } from "../commonModel/RoleManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, Util } from "../util/Util";
import { DailyActTipTab } from "./DailyActTipTab";
import { DailyEvent } from "./DailyEvent";

export class DailyActTipView extends BaseView1 {
    static OpenTweenData = {
        /**界面进入时间 */
        ViewInTime : 500,
        ViewInStartPos: 100,
        ViewInStartAlpha:0,

        TabInTimeInterval : 70,
        TabInStartPos: 30,
        TabInStartAlpha:0,

        YuYueBtnInTime : 200,
        YuYueBtnInStartPos: -30,
        YuYueBtnInStartScale: 1.5,

        YuYueBtnInAlphaTime:80,
        YuYueBtnInStartAlpha:0,
        YuYueBtnInEndAlpha:1,

        SwitchTime:100,
    }


    InitEvent
    InitView
    InitTab
    SetActDataList
    SwitchTab
    UpdateView
    InitReward
    InitTime
    StartCountTime
    CancelCountTime
    CheckNextTab
    GetNewIndex

    loop_mgr: LoopScrowViewMgr
    data_list = []
    item_list
    new_mod = 0
    cache_yuyue_y
    public constructor() {
        super()


        this.base_file = "daily";
        this.layout_file = "DailyActTipView";
        this.use_background = true;
        this.is_center = true;
        this.layer_value = Enum_UILayer.Activity;
        this.not_show_main_msg = true;
        this.is_lastView_close = true;
        this.append_to_ctl_queue = true;
        this.destroy_imm = true;
        this.click_bg_toClose = true
        let model: DailyModel = DailyModel.GetInstance();
        let now_index_ = null;
        let time_id_ = [];
        let time_func_ = [];
        this.preload_server_config = {
            "config_ac": false
        }

        this.load_callback = () => {
            this.reward_panel.hScrollBarSkin = ""
            this.cache_yuyue_y = this.yuyue_box.y
        }

        this.open_callback = () => {
            this.data_list = []
            now_index_ = null
            this.InitEvent()
            this.InitView()

            Laya.Tween.clearAll(this.display_obj)
            this.display_obj.centerY = DailyActTipView.OpenTweenData.ViewInStartPos
            this.display_obj.alpha = DailyActTipView.OpenTweenData.ViewInStartAlpha
            Laya.Tween.to(this.display_obj, { centerY: 0, alpha: 1 }, DailyActTipView.OpenTweenData.ViewInTime, Laya.Ease.circOut)
            
            Laya.Tween.clearAll(this.yuyue_box)
            this.yuyue_box.y = this.cache_yuyue_y + DailyActTipView.OpenTweenData.YuYueBtnInStartPos
            this.yuyue_box.scale(DailyActTipView.OpenTweenData.YuYueBtnInStartScale, DailyActTipView.OpenTweenData.YuYueBtnInStartScale) 
            this.yuyue_box.alpha = DailyActTipView.OpenTweenData.YuYueBtnInStartAlpha

            let tab_count = this.data_list.length
            let yuyue_delay_time = (tab_count - 1) * DailyActTipView.OpenTweenData.TabInTimeInterval + DailyActTipView.OpenTweenData.ViewInTime
            setTimeout(() => {
                if(this.use_delete_method) return
                Laya.Tween.to(this.yuyue_box, { y: this.cache_yuyue_y, scaleX: 1, scaleY: 1 }, DailyActTipView.OpenTweenData.YuYueBtnInTime, Laya.Ease.backOut)
                Laya.Tween.to(this.yuyue_box, { alpha: DailyActTipView.OpenTweenData.YuYueBtnInEndAlpha}, DailyActTipView.OpenTweenData.YuYueBtnInAlphaTime, Laya.Ease.linearNone)
            }, yuyue_delay_time);
        }   

        this.destroy_callback = () => {
            //model.ResetDailyActData()
            this.data_list = []
            now_index_ = null
            this.CancelCountTime()
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe()
                this.loop_mgr = null
            }
            if (this.item_list) {
                for (let _tmpi in this.item_list) {
                    let obj = this.item_list[_tmpi]
                    obj.DeleteMe()
                }
                this.item_list = null
            }
            if(this.yuyue_box){
                Laya.Tween.clearAll(this.yuyue_box)
                Laya.Tween.clearAll(this.title)
                Laya.Tween.clearAll(this.bg2)
                Laya.Tween.clearAll(this.reward_gp)
            }
            ActivityForeshowManager.GetInstance().is_pop_tip = true
        }

        this.InitView = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("daily", "ui_dshd_01"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("daily", "ui_ gift_02"))
            this.SetActDataList()
            this.InitTab()
            //this.SwitchTab(0)
        }
        this.InitTab = () => {
            let data = this.data_list

            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr()
                this.loop_mgr.SetData(this.tab_gp, DailyActTipTab, data, LoopScrCon.Vertical, 1, () => {
                    this.SwitchTab()
                }, null, null, null, false)
            } else {
                this.loop_mgr.replaceAll(data)
            }
            let index = this.GetNewIndex(data)
            this.loop_mgr.SetSelectIndex(index)
        }

        this.GetNewIndex = (data_list) => {
            let new_mod = this.new_mod
            let index = 0
            if (!data_list) return index
            if (data_list && Util.TableSize(data_list) > 0) {
                for (let key in data_list) {
                    let data = data_list[key]
                    if (data && data.module == new_mod) {
                        index = Number(key)
                        break
                    }
                }
            }
            return index
        }

        this.SwitchTab = () => {
            let index = this.tab_gp.selectedIndex
            
            if (now_index_ == index) {
                return
            }

            let need_ani = true

            if(now_index_ == null){
                need_ani = false
            }
            now_index_ = index

            
            if(need_ani){
                Laya.Tween.clearAll(this.title)
                Laya.Tween.clearAll(this.bg2)
                Laya.Tween.clearAll(this.reward_gp)

                Laya.Tween.to(this.title, { alpha: 0, }, DailyActTipView.OpenTweenData.SwitchTime, Laya.Ease.quadIn)
                Laya.Tween.to(this.bg2, { alpha: 0, }, DailyActTipView.OpenTweenData.SwitchTime, Laya.Ease.quadIn)
                Laya.Tween.to(this.reward_gp, { alpha: 0, }, DailyActTipView.OpenTweenData.SwitchTime, Laya.Ease.quadIn, Laya.Handler.create(this, () =>{
                    this.UpdateView()
                    Laya.Tween.to(this.title, { alpha: 1, }, DailyActTipView.OpenTweenData.SwitchTime, Laya.Ease.quadOut)
                    Laya.Tween.to(this.bg2, { alpha: 1, }, DailyActTipView.OpenTweenData.SwitchTime, Laya.Ease.quadOut)
                    Laya.Tween.to(this.reward_gp, { alpha: 1, }, DailyActTipView.OpenTweenData.SwitchTime, Laya.Ease.quadOut)
                }))
                
            }
            else{
                this.UpdateView()
            }
            

        }
        this.UpdateView = () => {
            let data = this.data_list && this.data_list[now_index_]
            if (!data) return
            this.act_num.text = `预告活动${now_index_ + 1}/${this.data_list.length}`
            let module = data && data.module
            let sign_state = data.sign_state
            let info_id = data.info_id
            ResManager.GetInstance().SetOutsideImageSprite(this, this.title, GameResPath.GetIcon("daily", `title_${module}`))
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg2, GameResPath.GetIcon("daily", `bg_${module}`), true)
            let reservation = model.GetResStatus(module, data.module_sub, data.ac_sub)
            let yuyue_state = sign_state == 0 && reservation != null && data.state != 1
            this.yuyue.visible = yuyue_state
            this.yuyue_red.visible = yuyue_state
            this.go.visible = data.state == 1 || (sign_state != 0 || (!reservation && reservation != 0))
            this.ins.visible = info_id && info_id != 0
            this.InitReward(data.reward)
            this.InitTime(data.state, data.time)
        }

        this.InitTime = (state, time) => {
            this.CancelCountTime()
            if (state == 1) {
                this.StartCountTime(
                    4, () => {
                        let left_time = time - TimeUtil.getServerTime()
                        if (left_time < 0) {
                            this.time.visible = false
                            this.CancelCountTime(4)
                        }
                        else {
                            if (this.time) {
                                this.time.visible = true
                                this.time.innerHTML = `正在进行中：<font color='#22ba54'>${TimeUtil.convertTime(left_time)}</font>`

                            }
                        }

                    }
                )
            }
            else if (state == 2) {
                this.time.visible = true
                let des = TimeUtil.GetHalfDesc(time)
                let date = new Date(time * 1000); //时间戳为10位需*1000，时间戳为13位的话不需乘1000

                let h = (date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ':';
                let m = (date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes());
                this.time.innerHTML = `今${des}<font color='#fe1a1a'> ${h}${m}</font>开启`
            }
            let parent: Laya.HBox = <Laya.HBox>this.time.parent
            if (parent)
                parent.refresh()
        }
        this.StartCountTime = (index?, func?) => {
            if (!time_id_) {
                time_id_ = []
            }
            if (!time_func_) {
                time_func_ = []
            }
            this.CancelCountTime(index)
            // [ts2lua]time_func_下标访问可能不正确
            time_func_[index] = func
            time_id_[index] = GlobalTimerQuest.AddPeriodQuest(func, 1)

            func()
        }
        this.CancelCountTime = (index?) => {
            if (index == null) {
                if (!time_id_) {
                    return
                }
                for (let key in time_id_) {
                    GlobalTimerQuest.CancelQuest(time_id_[key])
                }
                time_id_ = null
                time_func_ = null
            } else {
                if (!time_id_ || !time_id_[index]) {
                    return
                }
                GlobalTimerQuest.CancelQuest(time_id_[index])
                table.remove(time_id_, index)
                table.remove(time_func_, index)
            }
        }

        this.InitReward = (reward) => {
            let show_reward = JSON.parse(reward)
            if (this.item_list) {
                for (let _tmpi in this.item_list) {
                    let obj = this.item_list[_tmpi]
                    obj.DeleteMe()
                }
                this.item_list = null
            }
            if (!this.item_list) {
                this.item_list = []
            }
            let list = show_reward && show_reward[0] && show_reward[0][1]

            if (!list) return
            let count = Util.TableSize(list)
            let width = 85 * count
            width = Math.min(width, 85 * 6)
            this.reward_panel.width = width
            for (let key in list) {
                let item: EquipmentItem = this.item_list[key]
                if (!item) {
                    item = new EquipmentItem(this.reward_gp)
                    this.item_list[key] = item
                    item.SetItemSize(85, 85)
                    item.Load()
                    item.ExcuteCallback(() => {
                        this.reward_gp.refresh()
                        //item.display_obj.visible = true

                    })
                }
                // if (item && item.display_obj)
                //     item.display_obj.visible = true
                let vo = list[key]
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
                item.SetData(type_id, vo[2])
                this.reward_gp.refresh()

            }
        }

        this.SetActDataList = () => {
            let data = model.GetDailyActData()
            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_ac", false)
            this.data_list = []
            for (let key in data) {
                let vo = data[key]
                let module = vo.module
                let module_sub = vo.module_sub
                let ac_sub = vo.ac_sub
                let info = cfg && cfg[`${module}@${module_sub}@${ac_sub}`]
                if (info) {
                    vo.ac_name = info.ac_name
                    vo.reward = info.reward
                    vo.jump_id = info.jump_id
                    vo.info_id = info.info_id
                    table.insert(this.data_list, vo)
                }
            }
            table.sort(this.data_list, (a?, b?) => {
                if (a.state == b.state) {
                    return a.time < b.time
                }
                else
                    return a.state < b.state
            })

        }

        this.CheckNextTab = () => {
            let data_list = this.data_list
            let index = now_index_
            // if (data_list && Util.TableSize(data_list) > 0) {
            //     for (let key in data_list) {
            //         let data = data_list[key]
            //         if (data && data.sign_state == 0 && Number(key) != now_index_) {
            //             index = Number(key)
            //             break
            //         }
            //     }
            // }
            return index
        }


        this.InitEvent = () => {
            //预约成功
            this.BindEvent(model, DailyEvent.DAILY_ORDER_SUCCESS, (module, module_sub, ac_sub, sign_state) => {
                let data = this.data_list && this.data_list[now_index_]
                if (data.module == module && data.module_sub == module_sub && data.ac_sub == ac_sub) {
                    //数据
                    this.yuyue.visible = sign_state == 0
                    this.yuyue_red.visible = sign_state == 0
                    this.go.visible = sign_state != 0
                    data.sign_state = sign_state


                    //跳到下一个可预约
                    let next_index = now_index_,data_temp,reservation,yuyue_state
                    for (let i = 0; i < this.data_list.length; i++) {
                        data_temp = this.data_list && this.data_list[i]
                        reservation = model.GetResStatus(data_temp.module, data_temp.module_sub, data_temp.ac_sub)
                        yuyue_state = data_temp.sign_state == 0 && reservation != null && data_temp.state != 1
                        if (yuyue_state) {
                            next_index = i
                            break;
                        }
                    }

                    this.loop_mgr.SetSelectIndex(next_index)

                }
            })

            //预约成功
            this.BindEvent(model, DailyEvent.DAILY_UPDATE_ORDER_VIEW, (mod) => {
                this.new_mod = mod
                this.SetActDataList()
                this.InitTab()
                this.UpdateView()
            })

            Util.AddClickEvent(this.close, () => {
                this.Close()
            }, this, true)

            Util.AddClickEvent(this.ins, () => {
                let data = this.data_list && this.data_list[now_index_]
                if (data && data.info_id) {
                    GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, data.info_id)
                }
            }, this, true)

            Util.AddClickEvent(this.yuyue, () => {
                let data = this.data_list && this.data_list[now_index_]
                if (data && data.module) {
                    if (data.module == 402 && !GuildModel.IsHasGuild()) {
                        Alert.Show("暂未加入结社，是否前往加入结社？", Alert_Type.Two, () => {
                            GuildModel.GetInstance().OpenGuildView()
                        }, null, "前往", "取消")
                        return
                    }

                    DailyModel.GetInstance().Fire(DailyEvent.DAILY_REQUEST_PROTO, 15719, "iii", data.module, data.module_sub, data.ac_sub)
                }

            }, this, true)

            Util.AddClickEvent(this.go, () => {
                let data = this.data_list && this.data_list[now_index_]
                if (data && data.jump_id) {
                    let open_id = data.jump_id
                    OpenFun.OpenFunHandler(open_id)
                    this.Close()
                }
            }, this, true)

            Util.AddClickEvent(this.check, () => {
                this.toggle.visible = !this.toggle.visible
                let state = !this.toggle.visible ? 1 : 0
                model.Fire(DailyEvent.DAILY_REQUEST_PROTO, 15722, "c", state)
            }, this, true)
        }
    }

    public Open(...new_args) {

        let parms = new_args
        if (parms[0]) {
            this.new_mod = parms[0]
        }
        super.Open()
    }



    bg: Laya.Image
    bg1: Laya.Image
    title: Laya.Image
    bg2: Laya.Image
    close: Laya.Image
    ins: Laya.Image
    yuyue: Laya.Image
    yuyue_red: Laya.Image
    go: Laya.Image
    act_num: Laya.Label
    tip: Laya.Box
    check: Laya.Image
    toggle: Laya.Image
    time: Laya.HTMLDivElement
    reward_gp: Laya.HBox
    tab_gp: Laya.List
    reward_panel: Laya.Panel
    yuyue_box: Laya.Box
    public GetComponents() {
        [
            this.bg,
            this.bg1,
            this.title,
            this.bg2,
            this.close,
            this.ins,
            this.yuyue,
            this.yuyue_red,
            this.go,
            this.act_num,
            this.tip,
            this.check,
            this.toggle,
            this.time,
            this.reward_gp,
            this.tab_gp,
            this.reward_panel,
            this.yuyue_box
        ]
            = this.GetChildrenByNames([

                "bg",
                "bg1",
                "title",
                "bg2",
                "close",
                "ins",
                "yuyue",
                "yuyue_red",
                "go",
                "act_num",
                "tip",
                "check",
                "toggle",
                "time",
                "reward_gp",
                "tab_gp",
                "reward_panel",
                "yuyue_box"
            ])
        this.time.style.color = "#663915"
        this.time.style.fontSize = 20
        this.time.style.wordWrap = false
    }
}
window["DailyActTipView"] = DailyActTipView