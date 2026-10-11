import { BaseView1 } from "../common/BaseView1";
import { CongratulationObtainView } from "../common/CongratulationObtainView";
import { EventName } from "../common/EventName";
import { InstructionType } from "../common/InstructionType";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { EnumRedEvnelopeRebateViewType, IS2CRedEvnelopeRebateParam, RedEnvelopeRebateModel, RedEnvelopeRebateModelEvent } from "../commonModel/RedEnvelopeRebateModel";
import { ComActRecordView } from "../customActivity/ComActRecordView";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, Util } from "../util/Util";
import { RedEnvelopeRebateItem } from "./RedEnvelopeRebateItem";
import { RedEnvelopeRebateTabItem } from "./RedEnvelopeRebateTabItem";
import { PlatformManager } from './../PlatformManager';
import { ActivityIconManager } from "../commonModel/ActivityIconManager";
import { SYTweenLite } from "../util/SYTweenLite";
import { Alert, Alert_Type } from "../alert/Alert";

export class RedEnvelopeRebateView extends BaseView1 {
    static _layout_file: string = "RedEnvelopeRebateView";

    public SetActInfo: Function;
    private loop_mgr: LoopScrowViewMgr;
    private actInfo: any;
    private actDate: any;
    private time_id: any;
    private item1: RedEnvelopeRebateItem[] = [];
    private recordView: ComActRecordView;

    /**默认选中页签 */
    private defTabIndex: number = 0;
    private defType: EnumRedEvnelopeRebateViewType = EnumRedEvnelopeRebateViewType.eLoginRedEnvelope;

    private get RedEnvelopeRebateModel() {
        return RedEnvelopeRebateModel.GetInstance();
    }

    public constructor() {
        super();

        this.base_file = 'redEnvelopeRebate';
        this.layout_file = 'RedEnvelopeRebateView';
        this.use_background = true;
        this.click_bg_toClose = true;
        this.is_center = true;
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;

        this.preload_server_config = {
            config_recharge_product: false
        }

        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
        };

        this.close_callback = () => {
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe();
                this.loop_mgr = null;
            }

            if (this.item1) {
                for (let key in this.item1) {
                    let _item = this.item1[key];
                    _item.DeleteMe();
                }
                this.item1 = [];
            }

            if (this.recordView) {
                this.recordView.DeleteMe()
                this.recordView = null
            }

            this.recordBox.visible = false;
            Laya.Tween.clearAll(this.iconImg);
            Laya.timer.clearAll(this);

            this.StopTimer();
        }

        this.SetActInfo = (info: any, parm: any) => {
            if (!info) return
            this.actInfo = info;
            this.GetActDate();
        }

    }

    public LoadSuccess() {

        ResManager.GetInstance().SetTexture(
            this,
            this.bgImg,
            GameResPath.GetIconOtherPath('redEnvelopeRebate', 'ui_hb_01')
        );
        ResManager.GetInstance().SetTexture(
            this,
            this.bgImg3,
            GameResPath.GetIconOtherPath('redEnvelopeRebate', 'ui_gift_02')
        );

        this.StartTimer();
        this.RenderView();
        this.recordView = CustomActivityModel.GetInstance().LoadActRecord(this.tipsBox, this.actDate.base_type, this.actDate.sub_type, null, 2);
        this.recordView.ExcuteCallback(() => {
            this.recordView._record.style.fontSize = 20;
            this.recordView._panel.width = 255;
            this.recordView._lb_desc.visible = false;
        });
    }

    public InitEvent() {
        // 跳转一元秒杀
        Util.AddClickEvent(
            this.jumpBox,
            () => {
                OpenFun.OpenFunHandler(332115);
                this.Close();
            },
            this,
            true
        );

        // 关闭界面
        Util.AddClickEvent(
            this.closeBox,
            () => {
                this.Close();
            },
            this,
            true
        );

        // 功能介绍
        Util.AddClickEvent(
            this.descBox,
            () => {
                GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, this.defType == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? InstructionType.LoginRedEnvelope : InstructionType.SevenDayRebate)
            },
            this,
            true
        );

        // 点击提现
        Util.AddClickEvent(
            this.buyBtn,
            () => {
                let actData: IS2CRedEvnelopeRebateParam = this.RedEnvelopeRebateModel.actData;
                if (!actData) {
                    return;
                }
                let curDay: number = TimeUtil.naturalDaysBetween(actData.start_time * 1000, TimeUtil.getServerTime() * 1000) + 1;
                let condition = ErlangParser.GetInstance().parse(this.actInfo.condition);
                let withdrawalDays: string[] = this.defType == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? condition[3][1] : condition[4][1];
                let withdrawaNum: number = +(this.defType == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? condition[5][1] : condition[6][1]);
                let curWithdrawaNum: number = this.defType == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? actData.login_global_times : actData.recharge_global_times;
                let selfIsWithdrawa: boolean = Boolean((this.defType == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? actData.login_withdrawal : actData.recharge_withdrawal));
                // 本服是否还有提现次数
                if (curWithdrawaNum >= withdrawaNum && !selfIsWithdrawa) {
                    return Message.show(`提现人数已满`);
                }
                // 是否可以提现
                if (withdrawalDays.indexOf(curDay.toString()) == -1) {
                    return Message.show(`不在提现时间内`);
                }
                // 余额是否足够提现
                let money: number = this.defType == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? actData.login_money : actData.recharge_money;
                if (money <= 0) {
                    return Message.show(`余额不足`);
                }

                Alert.Show(`提现次数有限，请确认领取完全部红包再进行提现。`, Alert_Type.Two, () => {
                    let packageCode: string = PlatformManager.GetInstance().GetWXPackageCode();
                    let tokenId: string = PlatformManager.GetInstance().GetWXTokenId();
                    CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33256, this.actDate.base_type, this.actDate.sub_type, this.defType, packageCode, tokenId)
                }, null, "确定", '取消');



            },
            this,
            true
        );

        // 是否显示传闻
        this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.UP_LOG_LIST, (scmd?) => {
            if (scmd.base_type == this.actDate.base_type && scmd.sub_type == this.actDate.sub_type) {
                this.recordBox.visible = scmd.log_list.length > 0;
            }
        });

        this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.UPDATE_VIEW, (...new_args) => {
            let args = new_args;
            if (this.actInfo.base_type == args[0] && this.actInfo.sub_type == args[1]) {
                this.actDate = CustomActivityModel.GetInstance().GetActData(args[0], args[1]);
                this.actInfo = CustomActivityModel.GetInstance().GetActInfo(args[0], args[1]);
                this.RenderTabList();
                this.RenderAwardList();
            }

        });

        this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.ANSWER_TARGET, (...new_args) => {
            let args = new_args;
            if (this.actInfo.base_type == args[0] && this.actInfo.sub_type == args[1]) {
                if (args[3] && args[3].reward) {
                    let reward = CustomActivityModel.GetInstance().GetActReward(args[0], args[1], args[3].form_type, args[3].reward)
                    if (reward && reward.length) {
                        let view = new CongratulationObtainView(reward, 10)
                        view.Open()
                    }
                }
                this.actDate = CustomActivityModel.GetInstance().GetActData(args[0], args[1]);
                this.actInfo = CustomActivityModel.GetInstance().GetActInfo(args[0], args[1]);
                this.RenderTabList();
                this.RenderAwardList();
            }

        });

        // 选择页签回调
        this.BindEvent(RedEnvelopeRebateModel.GetInstance(), RedEnvelopeRebateModelEvent.TAB_SELECT, (data: any, index: number) => {
            this.defTabIndex = index;
            this.defType = data.type;
            this.loop_mgr.SetSelectIndex(this.defTabIndex);
            this.SetIcon(data.type);
            this.SetTabView(data.type)
            this.RenderAwardList();
        });

        // 更新提现状态
        this.BindEvent(RedEnvelopeRebateModel.GetInstance(), RedEnvelopeRebateModelEvent.UPDATE_WITHDRAW_STATE, () => {
            this.SetTabView(this.defType);
            this.RenderTabList();
        });

        this.BindEvent(GlobalEventSystem, EventName.CONGRATULATION_VIEW_CLOSE, () => {
            Laya.timer.once(500, this, () => {
                if (this.use_delete_method) return
                this.AddEffect();
            });
        });

    }


    private RenderView() {
        this.SetDefIndex();
        this.RenderTabList();
        this.RenderAwardList();
    }



    private RenderAwardList() {
        let awards: any[] = this.RedEnvelopeRebateModel.GetRewardsByType(this.defType);

        for (let i = 0; i < awards.length; i++) {
            const info = awards[i];
            let _gp: Laya.Node = this.icon1Box.getChildAt(i)//this.defType == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? this.icon1Box.getChildAt(i) : this.icon2Box.getChildAt(i);
            let _item: RedEnvelopeRebateItem = this.item1[i];  //this.defType == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? this.item1[i] : this.item2[i];
            if (!_item) {
                _item = new RedEnvelopeRebateItem(_gp);
                _item.Load();
                // table.insert(this.defType == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? this.item1 : this.item2, _item);
                table.insert(this.item1, _item);
            }
            _item.SetData(info, i);
        }


    }

    private RenderTabList() {
        let types: number[] = this.RedEnvelopeRebateModel.GetTypes(this.actDate.base_type, this.actDate.sub_type);
        let tabs: { type: number, red: boolean }[] = [];

        for (const iterator of types) {
            tabs.push({ type: iterator, red: this.RedEnvelopeRebateModel.GetTypeRedDot(iterator) })
        }

        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(
                this.tabList,
                RedEnvelopeRebateTabItem,
                tabs,
            );
        } else {
            this.loop_mgr.replaceAll(tabs);
        }

        this.loop_mgr.SetSelectIndex(this.defTabIndex);
    }

    /**
     * 倒计时
     */
    public StartTimer() {
        let actData: IS2CRedEvnelopeRebateParam = this.RedEnvelopeRebateModel.actData;
        this.StopTimer();
        let loop_func = () => {
            let left_time = actData.end_time - TimeUtil.getServerTime()
            if (left_time <= 0) {
                this.StopTimer();
                this.time1Lab.text = '已结束';
                this.time2Lab.text = '已结束';
            } else {
                let time: string = TimeUtil.timeConvert(left_time, 'hh-mm-ss')
                this.time1Lab.text = time;
                this.time2Lab.text = time;
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

    private SetDefIndex() {
        let types: number[] = this.RedEnvelopeRebateModel.GetTypes(this.actDate.base_type, this.actDate.sub_type);
        let index: number = types.findIndex((type: number) => {
            return this.RedEnvelopeRebateModel.GetTypeRedDot(type);
        });
        this.defTabIndex = Math.max(0, index);
        this.defType = types[this.defTabIndex];
        this.SetIcon(this.defType);
        this.SetTabView(this.defType);
    }


    private SetIcon(type: number) {

        this.bgImg1.x = type == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? 75 : 72;

        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.bgImg1,
            GameResPath.GetIconOtherPath('redEnvelopeRebate', 'ui_hb_' + (type + 2))
        );

        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.bgImg2,
            GameResPath.GetIconOtherPath('redEnvelopeRebate', 'ui_hb_0' + (type + 1)),
            true
        );


    }


    private SetTabView(type: number) {
        let actData: IS2CRedEvnelopeRebateParam = this.RedEnvelopeRebateModel.actData;
        if(!actData) return
        this.type2Box.visible = type == EnumRedEvnelopeRebateViewType.eSevenDayRebate;
        this.type1Box.visible = type == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope;
        // this.icon1Box.visible = type == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope;
        // this.icon2Box.visible = type == EnumRedEvnelopeRebateViewType.eSevenDayRebate;

        this.money1Lab.text = `${actData.login_money / 100}元`;
        this.money2Lab.text = `${actData.recharge_money / 100}元`;

        // let money: number = this.defType == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? actData.login_money : actData.recharge_money;
        this.redImg.visible = this.RedEnvelopeRebateModel.GetTypeWithdrawRedDot(type);

        let state: boolean = Boolean(type == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? actData.login_status : actData.recharge_status);

        this.buyBtn.gray = state;
        this.buyBtn.mouseEnabled = !state;
        this.withdrawLab.text = '提现';/*  state ? '提现中' : '提现'; */
        this.jumpBox.visible = Boolean(ActivityIconManager.GetInstance().getIconInfo('331@115@0'))

    }


    private AddEffect() {
        let end_pos = this.defType == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? { x: 357, y: 1055 } : { x: 599, y: 1005 }
        this.iconImg.visible = true;
        Laya.Tween.to(this.iconImg, { alpha: 0.2, scaleX: 0.2, scaleY: 0.2, x: end_pos.x, y: end_pos.y }, 1000, Laya.Ease.circOut, Laya.Handler.create(this, () => {
            this.iconImg.visible = false;
            this.iconImg.alpha = 1;
            this.iconImg.scale(1, 1);
            this.iconImg.pos(360, 541);
        }, null, true));
    }



    public Open(...new_args) {
        this._Local_Open(new_args)
    }

    private _Local_Open(parms: any) {
        super.Open();
    }

    public DeleteMe() {
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }


        super.DeleteMe();
    }

    private GetActDate() {
        if (!this.actInfo) {
            return;
        }
        this.actDate = CustomActivityModel.GetInstance().GetActData(this.actInfo.base_type, this.actInfo.sub_type);
    }

    bgImg: Laya.Image
    bgImg3: Laya.Image
    bgImg2: Laya.Image
    bgImg1: Laya.Image
    icon1Box: Laya.Box
    type1Box: Laya.Box
    money1Lab: Laya.Label
    time1Lab: Laya.Label
    type2Box: Laya.Box
    money2Lab: Laya.Label
    time2Lab: Laya.Label
    jumpBox: Laya.Box
    jumpLab: Laya.Label
    buyBtn: Laya.Box
    withdrawLab: Laya.Label
    redImg: Laya.Image
    closeBox: Laya.Box
    descBox: Laya.Box
    recordBox: Laya.Box
    tipsBox: Laya.Box
    tabList: Laya.List
    iconImg: Laya.Image
    public GetComponents() {
        [
            this.bgImg,
            this.bgImg3,
            this.bgImg2,
            this.bgImg1,
            this.icon1Box,
            this.type1Box,
            this.money1Lab,
            this.time1Lab,
            this.type2Box,
            this.money2Lab,
            this.time2Lab,
            this.jumpBox,
            this.jumpLab,
            this.buyBtn,
            this.withdrawLab,
            this.redImg,
            this.closeBox,
            this.descBox,
            this.recordBox,
            this.tipsBox,
            this.tabList,
            this.iconImg,
        ]
            = this.GetChildrenByNames([

                "bgImg",
                "bgImg3",
                "bgImg2",
                "bgImg1",
                "icon1Box",
                "type1Box",
                "money1Lab",
                "time1Lab",
                "type2Box",
                "money2Lab",
                "time2Lab",
                "jumpBox",
                "jumpLab",
                "buyBtn",
                "withdrawLab",
                "redImg",
                "closeBox",
                "descBox",
                "recordBox",
                "tipsBox",
                "tabList",
                "iconImg",
            ])
    }
}
window["RedEnvelopeRebateView"] = RedEnvelopeRebateView