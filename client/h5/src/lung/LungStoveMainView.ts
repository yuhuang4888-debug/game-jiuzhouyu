import { BaseAwardItem } from '../common/BaseAwardItem';
import { BaseView1 } from '../common/BaseView1';
import { EquipmentItem } from '../common/EquipmentItem';
import { Enum_UILayer } from '../common/LayerManager';
import { ModuleType, RedDotManager } from '../common/RedDotManager';
import { ResManager } from '../common/ResManager';
import { GoodsModel } from '../commonModel/GoodsModel';
import { LungDotSubType, LungEvent, LungModel } from '../commonModel/LungModel';
import { TimeUtil } from '../util/TimeUtil';
import { GlobalTimerQuest, Util } from '../util/Util';
import { LungStoveStageItem } from './LungStoveStageItem';
import { Config } from "../common/Config"
import { ShopModel } from '../commonModel/ShopModel';
import { Alert, Alert_Type } from '../alert/Alert';
import { OpenFun } from '../common/OpenFun';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventName } from '../common/EventName';
import { CongratulationObtainView } from '../common/CongratulationObtainView';
import { GameResPath } from './../util/GameResPath';
import { SYTweenLite } from '../util/SYTweenLite';
import { SYTweenFunc } from '../util/SYTweenFunc';
import { LoopScrowViewMgr, LoopScrCon } from '../common/LoopScrowViewMgr';
import { RuneShowItem } from '../runeTreasure/RuneShowItem';
import { LungStoveShowItem } from './LungStoveShowItem';
import { table } from '../common/table';
import { AutoBrushResultView } from '../autoBrush/AutoBrushResultView';

export class LungStoveMainView extends BaseView1 {
    static _layout_file: string = "LungStoveMainView";

    private get lungModel() {
        return LungModel.GetInstance();
    }

    private reward_item_list_: EquipmentItem[] = [];
    private reward_item_list1_: EquipmentItem[] = [];
    private item_list_: LungStoveStageItem[] = [];
    private target_item_: EquipmentItem = null;
    private one_cost_item_: BaseAwardItem = null;
    private ten_cost_item_: BaseAwardItem = null;
    private one_cost_list_: any;
    private ten_cost_list_: any;
    private one_cost_enough_: boolean = true;
    private ten_cost_enough_: boolean = true;
    private is_left_playAnime_: boolean = true;  //是否播放左边奖励循环动画
    private is_right_playAnime_: boolean = true;  //是否播放左边奖励循环动画
    private progress_width_: number = 370;
    private count_anim_time_id_: number = 0;
    private count_time_id_: number = 0;
    private count_free_time_id_: number = 0;
    private tween_id_: number = 0;

    left_collection_: LoopScrowViewMgr
    right_collection_: LoopScrowViewMgr
    InitEvents

    all_value = 0
    reward_data
    reward_data2
    anim_timeId
    anim_time = 0.01
    anim_step = 1
    child_height = 80
    judge_count = 3

    public constructor() {
        super();

        this.base_file = 'lung';
        this.layout_file = 'LungStoveMainView';
        this.use_background = true;
        this.click_bg_toClose = true;
        this.is_center = true;
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = false;

        this.preload_server_config = {
            config_dragon_crucible: false
        }

        this.load_callback = function () {
            this.LoadSuccess();
            this.InitEvent();
        }
        this.open_callback = function () {
            this.SetData();
        }

        this.close_callback = function () {
            this.CancelTimer()
            this.CancelFreeTimer()
            Laya.Tween.clearAll(this.scrPanel.hScrollBar)
            if (this.reward_item_list_) {
                for (let obj of this.reward_item_list_) {
                    obj.DeleteMe()
                }
                this.reward_item_list_ = null
            }
            if (this.reward_item_list1_) {
                for (let obj of this.reward_item_list1_) {
                    obj.DeleteMe()
                }
                this.reward_item_list1_ = null
            }
            if (this.item_list_) {
                for (let obj of this.item_list_) {
                    obj.DeleteMe()
                }
                this.item_list_ = null
            }
            if (this.target_item_) {
                this.target_item_.DeleteMe()
                this.target_item_ = null
            }
            if (this.one_cost_item_) {
                this.one_cost_item_.DeleteMe()
                this.one_cost_item_ = null
            }
            if (this.ten_cost_item_) {
                this.ten_cost_item_.DeleteMe()
                this.ten_cost_item_ = null
            }

            if (this.tween_id_) {
                SYTweenLite.Stop(this.tween_id_)
                this.tween_id_ = null
            }
            this.ClearUIEffect(this.effBox);
            // skip_animation_ = false
            this.one_cost_enough_ = true
            this.ten_cost_enough_ = true
            this.is_playAnime = true
            this.CanceAnimlTimer();
            if (this.anim_timeId) {
                GlobalTimerQuest.CancelQuest(this.anim_timeId)
                this.anim_timeId = null
            }

            if (this.left_collection_) {
                this.left_collection_.DeleteMe()
                this.left_collection_ = null
            }

            if (this.right_collection_) {
                this.right_collection_.DeleteMe()
                this.right_collection_ = null
            }
        }
    }



    public InitEvent() {
        let close_fun = () => {
            this.Close()
        }
        Util.AddClickEvent(this.closeBtn, close_fun, this, true)

        let freeBtn_fun = () => {
            this.lungModel.Fire(LungEvent.LUNG_REQUEST_PROTO, 18106, "cc", 1, 0)
        }
        // Util.AddClickEvent(this.freeBtn, freeBtn_fun, this, true)

        let one_fun = () => {
            // 免费次数
            let show: boolean = RedDotManager.GetInstance().CheckRedStatus(ModuleType.LUNG_DOT, LungDotSubType.StoveFreeTimes)
            if (show) {
                this.lungModel.Fire(LungEvent.LUNG_REQUEST_PROTO, 18106, "cc", 1, 0)
            } else {
                this.BtnFun(1);
            }

        }
        Util.AddClickEvent(this.oneBtn, one_fun, this, true)

        let ten_fun = () => {
            this.BtnFun(10)
        }
        Util.AddClickEvent(this.tenBtn, ten_fun, this, true)

        let update_fun = () => {
            this.SetData()
        }
        this.BindVar(this.lungModel, "stove_data", update_fun)

        // Util.AddClickEvent(this.checkBtn, () => {
        //     this.SetCheckBtn(!skip_animation_)
        // }, this)

        let success_fun = (goods_list) => {
            this.PlaySuccessEffect(goods_list)
        }
        this.BindEvent(this.lungModel, LungEvent.LUNG_STOVE_SUCCESS, success_fun)

        let dot_fun = (mType, rType) => {
            if (mType == ModuleType.LUNG_DOT) {
                if (rType == LungDotSubType.StoveFreeTimes) {
                    this.ShowFreeTimesDot()
                }
            }
        }
        this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, dot_fun)

        let close_tips_view = () => {
            this.is_left_playAnime_ = true
            this.is_right_playAnime_ = true
        }
        this.BindEvent(GlobalEventSystem, EventName.CLOSE_TIPS_VIEW, close_tips_view)

        let open_tips_view = () => {
            this.is_left_playAnime_ = false
            this.is_right_playAnime_ = false
        }
        this.BindEvent(GlobalEventSystem, EventName.OPEN_TIPS_VIEW, open_tips_view)

        this.scrPanel.hScrollBar.on(Laya.UIEvent.CHANGE, this, () => {
            this.SetAwardArrow();
        });

        Util.AddClickEvent(this._btn_show, () => {
            this.lungModel.Fire(LungEvent.LUNG_OPEN_VIEW, "LungStoveRewardView")
        }, this, true)
    }


    public LoadSuccess() {
        let res_mgr = ResManager.GetInstance();
        // 加载位图字体
        this.stove_times.fontSize = 22
        res_mgr.LoadFont(this, "lung_num", this.stove_times, 22);
        res_mgr.SetTexture(this, this.bgImg1, GameResPath.GetIcon('lung', 'ui_swzh_01'))
        res_mgr.SetTexture(this, this.bgImg2, GameResPath.GetIcon('zeroMoney', 'ui_gift_02'))
        this.lungModel.Fire(LungEvent.LUNG_REQUEST_PROTO, 18105);
        this.scrPanel.hScrollBar.visible = false;
        this.scrPanel.hScrollBar.value = 0;
    }

    private SetData() {
        if (!this.lungModel.stove_data) {
            return
        }
        this.SetReward()
        this.StartTimer()
        this.SetBtnStateAndFreeTimes()
        this.ClearUIEffect(this.effBox);
        this.AddUIEffect('ui_shenwen1', this.effBox, { x: 0, y: -3 }, 3, true);
    }

    private SetReward() {
        if (!this.lungModel.stove_data) {
            return
        }
        let dragon_crucible_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dragon_crucible", false)
        let cfg = this.lungModel.GetStoveCfg(this.lungModel.stove_data.crucible_id, dragon_crucible_cfg)
        if (cfg) {
            let reward_list = JSON.parse(cfg.show_list)
            let up_list = JSON.parse(cfg.is_up_list)
            let up_dict = []
            if (up_list) {
                for (let i = 0; i < up_list.length; i++) {
                    const id = up_list[i];
                    up_dict[id] = true;
                }
            }
            if (reward_list) {
                let list = [];
                for (let i = 0, length = reward_list.length; i < length; i++) {
                    let type_id = reward_list[i][1];
                    table.insert(list, { itemData: reward_list[i], isUp: up_dict[type_id] })
                }
                this.reward_data = Util.DeepCopy(list)
                this.all_value = list.length * this.child_height - this.left_list.height + 50
                if (!this.left_collection_) {
                    this.left_collection_ = new LoopScrowViewMgr()
                    this.left_collection_.SetData(this.left_list, LungStoveShowItem, list, LoopScrCon.Vertical, 1)
                    this.left_collection_.SetOnValueChanged(() => {
                        let value = this.left_list.scrollBar.value
                        let left = this.judge_count * this.child_height
                        let right = this.all_value - left
                        if (value <= left) {
                            this.ResetReward(true, value)
                        } else if (value >= right) {
                            this.ResetReward(false, value)
                        }
                    }
                    )
                } else {
                    this.left_collection_.replaceAll(list)
                }
                let default_value = Math.ceil(list.length / 2) * this.child_height - this.left_list.height / 2
                this.left_list.scrollBar.value = default_value
                this.PlayRewardAnim()
                this.reward_data2 = Util.DeepCopy(list)
                if (!this.right_collection_) {
                    this.right_collection_ = new LoopScrowViewMgr()
                    this.right_collection_.SetData(this.right_list, LungStoveShowItem, list, LoopScrCon.Vertical)
                    let right_all_value = list.length * this.child_height - this.right_list.height + 50
                    this.right_list.scrollBar.value = right_all_value
                    this.right_collection_.SetOnValueChanged(() => {
                        let value = this.right_list.scrollBar.value
                        let left =  this.judge_count * this.child_height
                        let right = right_all_value - left
                        if (value >= right) {
                            this.ResetReward2(false, value)
                        }else if(value <= left){
                            this.ResetReward2(true, value)
                        } 
                    })
                } else {
                    this.right_collection_.replaceAll(list)
                }

                this.SetTargetReward(cfg.show)

                let stage_reward = JSON.parse(cfg.count_award)
                this.SetStageReward(stage_reward)

                let cost_list = JSON.parse(cfg.cost_list)
                this.SetCost(cost_list)
            }
        }
    }

    private PlayRewardAnim() {
        if (this.anim_timeId) {
            GlobalTimerQuest.CancelQuest(this.anim_timeId)
            this.anim_timeId = null
        }
        this.anim_timeId = GlobalTimerQuest.AddPeriodQuest(() => {
            if(!this.left_list.scrollBar) return
            let value = this.left_list.scrollBar.value + this.anim_step
            this.left_list.scrollBar.value = value

            let value2 = this.right_list.scrollBar.value - this.anim_step;
            this.right_list.scrollBar.value = value2
        }, this.anim_time)
    }

    // 重置奖励池数据 
    private ResetReward(is_front, value) {
        let list = []
        let now_value = 0
        let length = this.reward_data.length
        let move_count = Math.ceil(length / 3)
        if (is_front) {
            for (let i = 0; i < move_count; i++) {
                list[i] = this.reward_data[length - move_count + i]
            }
            for (let i = move_count; i < length; i++) {
                list[i] = this.reward_data[i - move_count]
            }
            now_value = value + move_count * this.child_height + move_count * 6
        } else {
            for (let i = 0; i < (length - move_count); i++) {
                list[i] = this.reward_data[i + move_count]
            }
            for (let i = (length - move_count); i < length; i++) {
                list[i] = this.reward_data[i - length + move_count]
            }
            now_value = value - move_count * this.child_height - move_count * 6
        }
        this.reward_data = list
        this.left_list.updateArray(list)
        this.left_list.scrollBar.value = now_value
    }

    // 重置奖励池数据 
    private ResetReward2(is_front, value) {
        let list = []
        let now_value = 0
        let length = this.reward_data2.length
        let move_count = Math.ceil(length / 3)
        if (is_front) {
            for (let i = 0; i < move_count; i++) {
                list[i] = this.reward_data2[length - move_count + i]
            }
            for (let i = move_count; i < length; i++) {
                list[i] = this.reward_data2[i - move_count]
            }
            now_value = value + move_count * this.child_height + (move_count -1) * 6
        } else {
            for (let i = 0; i < (length - move_count); i++) {
                list[i] = this.reward_data2[i + move_count]
            }
            for (let i = (length - move_count); i < length; i++) {
                list[i] = this.reward_data2[i - length + move_count]
            }
            now_value = value - move_count * this.child_height + move_count * 6
        }
        this.reward_data2 = list
        this.right_list.updateArray(list)
        this.right_list.scrollBar.value = now_value
    }

    private SetTargetReward(type_id: number) {
        if (!this.target_item_) {
            this.target_item_ = new EquipmentItem(this.target_con)
            this.target_item_.Load()
            this.target_item_.SetItemSize(130, 130)
        }
        this.target_con.y = 427;
        this.target_item_.SetData(type_id, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, 1)
        this.target_item_.SetItembgVisible(false);
        if (!this.tween_id_) {
            let end_value = this.target_con.y + 30;
            this.tween_id_ = SYTweenLite.to(this, this.target_con, SYTweenLite.UiAnimationType.POSY, end_value, 3, null, SYTweenFunc.PINGPONG, true)
        }
        // res_mgr.SetTexture(this, this.target_name_img, `resource/game/lung/texture/${type_id}.png`)
        // ResManager.GetInstance().SetImageSprite(this, this.target_name_img, "lung", `${type_id}`)
    }

    //设置消耗
    private SetCost(cost_list) {
        if (cost_list[0] && cost_list[0][1] && cost_list[0][1][0]) {
            this.one_cost_list_ = cost_list[0][1][0]
            let one = Number(this.one_cost_list_[2])
            let my_have = GoodsModel.GetInstance().GetTypeGoodsNum(Number(this.one_cost_list_[1]))
            let enough = my_have >= one
            let color_str = enough ? "'#00FA64'" : "'#ff4f50'"
            // this.one_cost.textColor = color_str
            this.one_cost.style.fontSize = 20
            this.one_cost.style.color = "#ffffff"
            this.one_cost.width = 120
            this.one_cost.innerHTML = Util.StrToHTML(`<font color=${color_str}>${my_have}</font>/${one}`)
            this.one_cost_enough_ = enough;
            this.oneRedImg.visible = enough;
            if (!this.one_cost_item_) {
                this.one_cost_item_ = new BaseAwardItem(this.one_cost_con)
                this.one_cost_item_.Load()
            }
            this.one_cost_item_.SetItemSize(40, 40)
            this.one_cost_item_.SetItembgVisible(false)
            this.one_cost_item_.SetData(Number(this.one_cost_list_[1]))
        }

        if (cost_list[1] && cost_list[1][1] && cost_list[1][1][0]) {
            this.ten_cost_list_ = cost_list[1][1][0]
            let ten = Number(this.ten_cost_list_[2])
            let my_have = GoodsModel.GetInstance().GetTypeGoodsNum(Number(this.ten_cost_list_[1]))
            let enough = my_have >= ten
            let color_str = enough ? "'#00FA64'" : "'#ff4f50'"
            // this.ten_cost.textColor = color_str
            this.ten_cost.style.fontSize = 20
            this.ten_cost.style.color = "#ffffff"
            this.ten_cost.width = 120
            this.ten_cost.innerHTML = Util.StrToHTML(`<font color=${color_str}>${my_have}</font>/${ten}`)
            this.ten_cost_enough_ = enough
            this.tenRedImg.visible = enough;
            if (!this.ten_cost_item_) {
                this.ten_cost_item_ = new BaseAwardItem(this.ten_cost_con)
                this.ten_cost_item_.Load()
            }
            this.ten_cost_item_.SetItemSize(40, 40)
            this.ten_cost_item_.SetItembgVisible(false)
            this.ten_cost_item_.SetData(Number(this.ten_cost_list_[1]))
        }
    }

    //设置阶段奖励
    private SetStageReward(stage_reward) {
        if (!stage_reward) {
            return
        }
        if (!this.item_list_) {
            this.item_list_ = []
        }
        let vo
        let cfg
        let max = 0
        let con: Laya.Box
        let item: LungStoveStageItem
        let goods_list
        let basic
        let count: number = this.lungModel.stove_data.count; // 当前抽奖次数
        let firstRedDotIndex = -1;
        for (let i = 0, length = stage_reward.length; i < length; i++) {
            vo = stage_reward[i]
            con = this[`${"stage_con" + i}`]
            if (con) {
                item = this.item_list_[i]
                if (!item) {
                    item = new LungStoveStageItem(con)
                    item.Load()
                    this.item_list_[i] = item
                }
                item.SetData(vo)
                max = Number(vo[0])
                let state = this.lungModel.GetStoveStageState(vo[0]);
                if (firstRedDotIndex == -1 && state == 1) {
                    firstRedDotIndex = i;
                }
            }
        }
        // panel滑动距离
        let scroll_width = this.scrPanel.hScrollBar.max / stage_reward.length;
        if (firstRedDotIndex > -1) {
            this.scrPanel.hScrollBar.value = firstRedDotIndex * scroll_width;
        } else {
            Laya.Tween.clearAll(this.scrPanel.hScrollBar)
            let h_value = this.scrPanel.contentWidth - this.scrPanel.width;
            Laya.Tween.to(this.scrPanel.hScrollBar, { value: h_value}, 2000, Laya.Ease.circOut)
        }
        this.scrPanel.refresh();
        // 每一段的宽度
        let w: number = this.progress_width_ / stage_reward.length - 1;
        // 因为进度不规则所以写死
        let barWs: number[] = [0, 100, 200, 300, 370, 481];
        // 获取当前处于第几段
        let cellIndex: number = -1;
        // let times: number = stage_reward[stage_reward.length - 1][0];
        for (let i = 0; i < stage_reward.length; i++) {
            const element = stage_reward[i];
            if (count >= element[0]) {
                cellIndex = i;
            }
        }

        let barW: number = barWs[Math.max(cellIndex, 0)];
        this.progress_front.width = barW;
        this.stove_times.text = String(count) + '次';
        this.CallLater(() => {
            this.stove_times.centerX = 0;

        });
    }

    private StartAnimTimer() {
        this.CanceAnimlTimer()
        let self: this = this;

        let OnAnimTime = () => {
            // for (let index = 0; index < self.reward_item_list_.length; index++) {
            //     // const item = self.reward_item_list_[index];
            //     const item1 = self.reward_item_list1_[index];
            //     // if (item.display_obj) {
            //     //     if (self.is_left_playAnime_)
            //     //         item.display_obj.y -= 1
            //     //     if (item.display_obj.y < - 80) {
            //     //         let i = Number(index) - 1 >= 0 ? Number(index) - 1 : self.reward_item_list_.length - 1
            //     //         item.display_obj.y = self.reward_scroll.getChildAt(i)['y'] + 80 + 6;
            //     //     }
            //     // }

            //     if (item1.display_obj) {
            //         if (self.is_right_playAnime_)
            //             item1.display_obj.y += 1
            //         if (item1.display_obj.y > /* self.reward_scroll0.height */332 + 80) {
            //             let i = Number(index) - 1 >= 0 ? Number(index) - 1 : self.reward_item_list_.length - 1
            //             item1.display_obj.y = self.reward_scroll0.getChildAt(i)['y'] - 80 - 6;
            //         }
            //     }
            // }
        }

        this.count_anim_time_id_ = GlobalTimerQuest.AddPeriodQuest(OnAnimTime, 0.05)
        OnAnimTime();
    }

    private StartTimer() {
        this.CancelTimer();
        let self: this = this;
        let OnTime = () => {
            if (self.lungModel.stove_data && self.lungModel.stove_data.end_time) {
                let left_time = self.lungModel.stove_data.end_time - TimeUtil.getServerTime()
                if (left_time < 0) {
                    self.CancelTimer()
                    self.left_time.text = Util.StrToHTML("00:00:00")
                    return
                }
                let time_str = TimeUtil.convertTime(left_time)
                let str = String(time_str)
                self.left_time.text = Util.StrToHTML(str)
            } else {
                self.CancelTimer()
            }
        }

        this.count_time_id_ = GlobalTimerQuest.AddPeriodQuest(OnTime, 1)
        OnTime();
    }


    private CancelTimer = () => {
        if (this.count_time_id_) {
            GlobalTimerQuest.CancelQuest(this.count_time_id_)
            this.count_time_id_ = null
        }
    }


    private SetBtnStateAndFreeTimes() {
        if (this.lungModel.stove_data) {
            let res_mgr = ResManager.GetInstance();
            let bool: boolean = this.lungModel.stove_data.free_times > 0;
            res_mgr.SetImageSpriteTrans(this, this.oneBtn, GameResPath.GetIcon('lung', bool ? 'ui_swzh_11' : 'ui_swzh_07'))
            this.costOne.visible = !bool;

            let gap = this.lungModel.stove_data.next_free_time - TimeUtil.getServerTime()
            this.freeLab.visible = gap > 0
            if (gap > 0) {
                this.StartFreeTimer()
            }
            this.ShowFreeTimesDot()
        }
    }

    private StartFreeTimer = () => {
        this.CancelFreeTimer();
        let self: this = this;
        let OnFreeTime = () => {
            if (self.lungModel.stove_data && self.lungModel.stove_data.next_free_time) {
                let left_time = self.lungModel.stove_data.next_free_time - TimeUtil.getServerTime()
                if (left_time < 0) {
                    self.CancelFreeTimer()
                    self.next_free_time.text = "";
                    self.freeLab.visible = false;
                    // model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18105)
                    return
                }
                self.freeLab.visible = true;
                let time_str = TimeUtil.convertTime(left_time)
                self.next_free_time.text = Util.StrToHTML(`${time_str}`)
            } else {
                self.CancelFreeTimer()
            }
        }

        this.count_free_time_id_ = GlobalTimerQuest.AddPeriodQuest(OnFreeTime, 1)
        OnFreeTime();
    }

    private CancelFreeTimer = () => {
        if (this.count_free_time_id_) {
            GlobalTimerQuest.CancelQuest(this.count_free_time_id_)
            this.count_free_time_id_ = null
        }
    }

    private ShowFreeTimesDot = () => {
        let show = RedDotManager.GetInstance().CheckRedStatus(ModuleType.LUNG_DOT, LungDotSubType.StoveFreeTimes)
        this.oneRedImg.visible = this.one_cost_enough_ || show;
    }



    private CanceAnimlTimer() {
        if (this.count_anim_time_id_) {
            GlobalTimerQuest.CancelQuest(this.count_anim_time_id_)
            this.count_anim_time_id_ = null
        }
    }


    private BtnFun(times) {
        let call_fun = (auto_buy) => {
            this.lungModel.Fire(LungEvent.LUNG_REQUEST_PROTO, 18106, "cc", times, auto_buy)
        }
        let ok_fun = () => {
            call_fun(1)
        }
        let check_func = (bool) => {
            this.lungModel.lung_daimond_cost_alert = !bool
        }
        let cost_enough = this.one_cost_enough_
        let cost_list = this.one_cost_list_
        if (times == 10) {
            cost_enough = this.ten_cost_enough_
            cost_list = this.ten_cost_list_
        }
        if (cost_enough) {
            call_fun(0)
        } else if (cost_list) {
            let my_have = GoodsModel.GetInstance().GetTypeGoodsNum(Number(cost_list[1]))
            let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(Number(cost_list[1]))
            let need = Number(cost_list[2])
            let ticket_gap = need - my_have
            let price_info = Config.PRELOAD_SERVER_CONFIG.config_goods_price[Number(cost_list[1])]
            let goods_price = ticket_gap * price_info.price
            if (price_info) {
                let [enough, gap, my_money, alert_str] = ShopModel.GetInstance().MoneyIsEnough(price_info.price_type, goods_price)
                if (enough) {
                    if (this.lungModel.lung_daimond_cost_alert) {
                        let str = `是否消耗<font color='#639c12'>${goods_price}勾玉</font>购买<font color='#639c12'>${ticket_gap}</font>个<font color='#639c12'>${basic.goods_name}</font>`
                        let content = Util.StrToHTML(str)
                        Alert.Show(content, Alert_Type.AlertTypeCheckBox, ok_fun, undefined, "确定", "取消", undefined, false, check_func, "本次登录不再提示")
                    } else {
                        ok_fun()
                    }
                } else {
                    let charge_fun = () => {
                        OpenFun.OpenFunHandler(21)
                    }
                    let str = `您的勾玉不足${goods_price}，是否前往充值`
                    Alert.Show(str, Alert_Type.One, charge_fun, undefined, "确定")
                }
            }
        }
    }

    private PlaySuccessEffect(goods_list) {
        let show_reward = () => {
            if (goods_list) {
                let list = []
                for (let vo of goods_list) {
                    let obj = []
                    obj[0] = vo.style
                    obj[1] = vo.typeId
                    obj[2] = vo.count
                    list.push(obj)
                }
                let view = new CongratulationObtainView(list, 10)
                view.Open()
            }
        }
        show_reward();
    }

    private SetAwardArrow () {
        if (this.scrPanel.hScrollBar.value >= this.scrPanel.contentWidth - this.scrPanel.width - 3) {
            this.img_right.visible = false;
        } else {
            this.img_right.visible = true;
        }
        if (this.scrPanel.hScrollBar.value <= 3) {
            this.img_letf.visible = false;
        } else {
            this.img_letf.visible = true;
        }
    }

    public Open(...new_args) {
        super.Open();
    }
    bgImg1: Laya.Image
    bgImg2: Laya.Image
    titleImg: Laya.Image
    effBox: Laya.Box
    propertyImage: Laya.Image
    closeBtn: Laya.Image
    left_time: Laya.Label
    left_list: Laya.List
    right_list: Laya.List
    target_con: Laya.Box
    stove_times: Laya.Label
    scrPanel: Laya.Panel
    _Group1: Laya.Box
    progress_bg: Laya.Image
    progress_front: Laya.Image
    _Group2: Laya.HBox
    stage_con0: Laya.Box
    stage_con1: Laya.Box
    stage_con2: Laya.Box
    stage_con3: Laya.Box
    stage_con4: Laya.Box
    stage_con5: Laya.Box
    oneBtn: Laya.Image
    oneRedImg: Laya.Image
    tenBtn: Laya.Image
    tenRedImg: Laya.Image
    costOne: Laya.Box
    one_cost_con: Laya.Box
    one_cost: Laya.HTMLDivElement
    costTen: Laya.Box
    ten_cost_con: Laya.Box
    ten_cost: Laya.HTMLDivElement
    freeLab: Laya.Label
    next_free_time: Laya.Label
    img_right: Laya.Image
    img_letf: Laya.Image
    _btn_show: Laya.Image

    public GetComponents() {
        [
            this.bgImg1,
            this.bgImg2,
            this.titleImg,
            this.effBox,
            this.propertyImage,
            this.closeBtn,
            this.left_time,
            this.left_list,
            this.right_list,
            this.target_con,
            this.stove_times,
            this.scrPanel,
            this._Group1,
            this.progress_bg,
            this.progress_front,
            this._Group2,
            this.stage_con0,
            this.stage_con1,
            this.stage_con2,
            this.stage_con3,
            this.stage_con4,
            this.stage_con5,
            this.oneBtn,
            this.oneRedImg,
            this.tenBtn,
            this.tenRedImg,
            this.costOne,
            this.one_cost_con,
            this.one_cost,
            this.costTen,
            this.ten_cost_con,
            this.ten_cost,
            this.freeLab,
            this.next_free_time,
            this.img_right,
            this.img_letf,
            this._btn_show,
        ]
            = this.GetChildrenByNames([

                "bgImg1",
                "bgImg2",
                "titleImg",
                "effBox",
                "propertyImage",
                "closeBtn",
                "left_time",
                "left_list",
                "right_list",
                "target_con",
                "stove_times",
                "scrPanel",
                "_Group1",
                "progress_bg",
                "progress_front",
                "_Group2",
                "stage_con0",
                "stage_con1",
                "stage_con2",
                "stage_con3",
                "stage_con4",
                "stage_con5",
                "oneBtn",
                "oneRedImg",
                "tenBtn",
                "tenRedImg",
                "costOne",
                "one_cost_con",
                "one_cost",
                "costTen",
                "ten_cost_con",
                "ten_cost",
                "freeLab",
                "next_free_time",
                "img_right",
                "img_letf",
                "_btn_show",
            ])
    }
}
window["LungStoveMainView"] = LungStoveMainView