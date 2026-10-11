import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { ResManager } from '../common/ResManager';
import { EnumFestivalProtocol } from '../commonController/FestivalController';
import { FestivalModel, FestivalModelEvent, ICConfFiestaLvExp, IS2CFestivalBasicInfo, IS2CFestivalBasicInfoRewaed } from '../commonModel/FestivalModel';
import { ComActTimerView } from '../customActivity/ComActTimerView';
import { GlobalTimerQuest, SetSizeDeltaY, Util } from '../util/Util';
import { FestivalAwardListItem } from './FestivalAwardListItem';
import { BaseItem1 } from './../common/BaseItem1';
import { FestivalBaseView } from './FestivalBaseView';
import { TimeUtil } from '../util/TimeUtil';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventName } from '../common/EventName';
import { GameResPath } from '../util/GameResPath';
import { ErlangParser } from '../util/ErlangParser';
import { Message } from './../sysInfo/SysInfoController';

export class FestivalLevelAwardView extends BaseItem1 {

    private conf: any;
    private loop_mgr: LoopScrowViewMgr;
    private loop_mgr1: LoopScrowViewMgr;
    private timer: ComActTimerView;
    private time_id: number;

    private get FestivalModel() {
        return FestivalModel.GetInstance();
    }

    public constructor(parent?: any) {
        super(parent);

        this.base_file = 'festival';
        this.layout_file = 'FestivalLevelAwardView';
        this.layer_value = Enum_UILayer.Activity;
        this.preload_server_config = {
            "config_quick_buy_price": false
        }
        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent();
            this.StartTimer();
        };

    }

    private LoadSuccess() {
        // 加载位图字体
        this.levelLab.fontSize = 32
        ResManager.GetInstance().LoadFont(this, "festival_level", this.levelLab, 32);
        ResManager.GetInstance().SetTexture(
            this,
            this.bgImg1,
            GameResPath.GetIconOtherPath('festival', 'ui_db_jd010')
        );

        this.AddUIEffect("ui_anniu_8", this.effectBox, { x: 0, y: 0 }, 12, true)
        this.RenderView();
    }

    public InitEvent() {
        // 点击全部领取
        Util.AddClickEvent(
            this.getAllBtn,
            () => {
                this.FestivalModel.Fire(
                    FestivalModelEvent.FESTIVAL_REQUEST_PROTO,
                    EnumFestivalProtocol.eProtocol19402, 'h', 0
                );
            },
            this,
            true
        );

        // 点击升级庆典
        Util.AddClickEvent(
            this.upBtn,
            () => {
                let info: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
                let confs: ICConfFiestaLvExp[] = this.FestivalModel.GetFestivalAwardsConfs(info.uid, info.act_id);
                if (info.lv < confs[confs.length - 1].lv) {
                    this.FestivalModel.Fire(
                        FestivalModelEvent.OPEN_FESTIVAL_VIEW,
                        'FestivalUpLevelView',
                    );
                } else {
                    Message.show('已满级');
                }
            },
            this,
            true
        );

        // 点击进阶庆典
        Util.AddClickEvent(
            this.buyBtn,
            () => {
                this.FestivalModel.Fire(
                    FestivalModelEvent.OPEN_FESTIVAL_VIEW,
                    FestivalBaseView._layout_file,
                    2
                );
            },
            this,
            true
        );


        this.BindEvent(this.FestivalModel, FestivalModelEvent.FESTIVAL_BASIC_INIT, () => {
            this.RenderView();
        });

        this.BindEvent(GlobalEventSystem, EventName.CHANGE_SUB_VIEW, (view_name: string) => {
            if (view_name == this.layout_file) {
                this.RenderView();
            }
        })

        this.levelList.scrollBar.changeHandler = new Laya.Handler(this, this.OnChangeHandler);

    }
    curData_ //避免一直刷新
    private OnChangeHandler() {
        let info: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
        let data: ICConfFiestaLvExp = this.levelList.cells[this.levelList.cells.length - 2]['data'];
        let conf: ICConfFiestaLvExp = this.FestivalModel.GetFestivalOrderReward(data.lv);
        let bool: boolean = info?.lv < conf?.lv && Boolean(conf);

        if (info?.lv >= conf?.lv) return;

        if (bool) {
            let curData: ICConfFiestaLvExp = JSON.parse(JSON.stringify(conf));
            curData['isOrder'] = true;
            if (!this.loop_mgr1) {
                this.curData_ = curData
                this.loop_mgr1 = new LoopScrowViewMgr();
                this.loop_mgr1.SetData(
                    this.orderList,
                    FestivalAwardListItem,
                    [curData],
                    LoopScrCon.Vertical
                );
            } else {
                if (this.curData_ && curData) {
                    if (this.curData_.lv!= curData.lv) {
                        this.curData_ = curData
                this.loop_mgr1.replaceAll([curData]);
                    }
                }else{
                    this.curData_ = curData
                    this.loop_mgr1.replaceAll([curData]);
                }
            }
        }
        SetSizeDeltaY(this.levelList, bool ? 479 : 602);
        this.orderList.visible = bool;
        this.effectBox.visible = bool;

    }


    private RenderView() {
        let info: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
        let confs: ICConfFiestaLvExp[] = this.FestivalModel.GetFestivalAwardsConfs(info.uid, info.act_id);
        let lv: number = info.lv == confs[confs.length - 1].lv ? info.lv : info.lv + 1;
        let targetNum: number = this.FestivalModel.GetFestivalLevelToTalExp(lv, info.uid, info.act_id);
        let confCurLvExp: ICConfFiestaLvExp = this.FestivalModel.GetFestivalAwardsConf(lv, info.uid, info.act_id);
        let barW: number = (info.exp / targetNum) * 266;
        this.barImg.width = barW > 266 ? 266 : barW;
        this.levelLab.changeText(`${info.lv}`);
        this.barLab.changeText(`${confCurLvExp.exp - (targetNum - info.exp)}/${confCurLvExp.exp}`);
        this.buyBtn.visible = !this.FestivalModel.GetFestivalIsBuy();
        this.RenderAward();
    }

    /**
     * 渲染奖励列表
     */
    private RenderAward() {
        let info: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
        let confs: ICConfFiestaLvExp[] = this.FestivalModel.GetFestivalAwardsConfs(info.uid, info.act_id);
        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(
                this.levelList,
                FestivalAwardListItem,
                confs,
                LoopScrCon.Vertical
            );
        } else {
            this.loop_mgr.replaceAll(confs);
        }

        // 过滤没有奖励的数据
        let levels = this.FestivalModel.GetLevelMapValues().filter((levelInfo: IS2CFestivalBasicInfoRewaed) => {
            let conf: ICConfFiestaLvExp = this.FestivalModel.confFiestaLvExp[`${info.uid}@${levelInfo.lv}`];
            let reward = ErlangParser.GetInstance().parse(conf.reward);
            let premiumReward = ErlangParser.GetInstance().parse(conf.premium_reward);
            return (reward.length > 0 || premiumReward.length > 0);
        })

        let redIndex: number = levels.findIndex((levelInfo: IS2CFestivalBasicInfoRewaed) => {
            return (levelInfo.status1 == 1 || levelInfo.status2 == 1)
        })

        let defIndex: number = this.FestivalModel.GetFetivalCurLevelByIndex() + 1;
        this.levelList.tweenTo(redIndex > -1 ? redIndex : defIndex > confs.length - 1 ? confs.length - 1 : defIndex);

        if (defIndex == 0) {
            this.levelList.scrollBar.value = 1;
        }

        this.redImg.visible = this.FestivalModel.GetFestivalAwardRedDot();
        this.getAllBtn.gray = !this.FestivalModel.GetFestivalAwardRedDot();
        this.getAllBtn.mouseEnabled = this.FestivalModel.GetFestivalAwardRedDot();
        this.CallLater(() => {
            if (this.use_delete_method) return
            this.OnChangeHandler()
        })
    }


    /**
     * 倒计时
     */
    public StartTimer() {
        let info: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
        this.StopTimer();
        let loop_func = () => {
            let left_time = info.expired_time - TimeUtil.getServerTime()
            if (left_time <= 0) {
                this.StopTimer();
                this.timeLab.text = '已结束';
            } else {
                let time: string = TimeUtil.timeConvert(left_time, 'hh-mm-ss')
                this.timeLab.text = time;
            }
        }

        this.time_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1);
        loop_func();
    }

    public StopTimer() {
        if (this.time_id) {
            GlobalTimerQuest.CancelQuest(this.time_id)
            this.time_id = null
        }
    }


    private LocalDeleteMe() {
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
        if (this.loop_mgr1) {
            this.loop_mgr1.DeleteMe();
            this.loop_mgr1 = null;
        }

        if (this.timer) {
            this.timer.DeleteMe();
            this.timer = null
        }

        this.StopTimer();
        this.ClearUIEffect(this.effectBox);
        super.DeleteMe();

    }

    public DeleteMe() {
        this.LocalDeleteMe();

    }

    barImg: Laya.Image
    barLab: Laya.Label
    levelLab: Laya.Label
    bgImg1: Laya.Image
    buyBtn: Laya.Box
    getAllBtn: Laya.Box
    redImg: Laya.Image
    timeLab: Laya.Label
    levelList: Laya.List
    upBtn: Laya.Box
    orderList: Laya.List
    effectBox: Laya.Box
    public GetComponents() {
        [
            this.barImg,
            this.barLab,
            this.levelLab,
            this.bgImg1,
            this.buyBtn,
            this.getAllBtn,
            this.redImg,
            this.timeLab,
            this.levelList,
            this.upBtn,
            this.orderList,
            this.effectBox,
        ]
            = this.GetChildrenByNames([

                "barImg",
                "barLab",
                "levelLab",
                "bgImg1",
                "buyBtn",
                "getAllBtn",
                "redImg",
                "timeLab",
                "levelList",
                "upBtn",
                "orderList",
                "effectBox",
            ])
    }
}
window["FestivalLevelAwardView"] = FestivalLevelAwardView