import { BaseItem1 } from "../common/BaseItem1";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { SpecialPackageModel, SpecialPackageModelEvent } from "../commonModel/SpecialPackageModel";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, HtmlColorTxt, SetLocalPositionX, Util } from "../util/Util";
import { SpecialPackageRewaedItem } from "./SpecialPackageRewaedItem";
import { ErlangParser } from './../util/ErlangParser';
import { SpecialPackageItem } from "./SpecialPackageItem";
import { RoleManager } from "../commonModel/RoleManager";
import { ResManager } from "../common/ResManager";
import { GameResPath } from './../util/GameResPath';
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { Message } from "../sysInfo/SysInfoController";
import { MainRoleVo } from "../sharedata/MainRoleVo";
import { Alert, Alert_Type } from "../alert/Alert";
import { OpenFun } from './../common/OpenFun';
import { CongratulationObtainView } from "../common/CongratulationObtainView";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventName } from "../common/EventName";
import { SpecialPackageBuyTimesView } from "./SpecialPackageBuyTimesView";


export class SpecialPackageView extends BaseItem1 {

    private _type_ = null;
    private _sub_type_ = null;
    private time_id: number;
    private actData: any;
    private actInfo: any;
    private loop_mgr: LoopScrowViewMgr;
    private loop_mgr1: LoopScrowViewMgr;
    private state: number = 0; // 可购买
    private costNum: number = 0;
    private _flag: boolean = true;

    private get specialPackageModel() {
        return SpecialPackageModel.GetInstance();
    }

    public constructor(parent?) {
        super(parent)
        this.base_file = "specialPackage";
        this.layout_file = "SpecialPackageView";
        this.layer_value = Enum_UILayer.Activity;
        this.load_callback = () => {
            this._flag = true;
            this.InitEvent();
            this.LoadSuccess();
        };

    }


    private InitEvent() {
        // 点击购买
        Util.AddClickEvent(
            this.buyBox,
            () => {
                let actInfo = ErlangParser.GetInstance().parse(this.actInfo.condition);
                let actData = this.actData.reward_list[0];
                let roleVo: MainRoleVo = RoleManager.GetInstance().GetMainRoleVo();
                if (this.state == 1) {
                    Message.show('商品已全部售空,请明日再来');
                } else if (this.state == 2) {
                    /*     let vips = actInfo[2][1];
                        let roleVipLv: number = roleVo.vip_flag;
                        let vipAndTimes: { times: number, lv: number } = this.specialPackageModel.GetNextLvBuyTimes(vips, roleVipLv); */
                    // Message.show(`V${vipAndTimes.lv}可购买`);
                    GlobalEventSystem.Fire(EventName.OPEN_VIEW, SpecialPackageBuyTimesView._cName, this._type_, this._sub_type_);
                } else {
                    if(!actData) return
                    let costType: number = actInfo[3][2];
                    let grade: number = actData.grade;
                    let goodId: number = 33 + costType;
                    let costName: string = costType == 1 ? '勾玉' : '绑玉';
                    let myCost: number = costType == 1 ? roleVo.jin : roleVo.jinLock;

                    let ok_func = () => {
                        if (!this._flag) {
                            return;
                        }
                        this._flag = false;
                        CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, this._type_, this._sub_type_, grade)
                    }
                    if (myCost >= this.costNum) {
                        ok_func();
                    } else {
                        if (costType != 1 && (roleVo.jinLock + roleVo.jin) >= this.costNum) {
                            if (this.specialPackageModel.openAlert) {
                                let check_func = () => {
                                    this.specialPackageModel.openAlert = false;
                                }
                                let num = this.costNum - myCost;
                                Alert.Show("绑玉不足，是否消耗" + num + "勾玉购买礼包？", Alert_Type.AlertTypeCheckBox, ok_func, null, null, null, null, null, check_func)
                                Alert.SetIsCharge(true)
                            } else {
                                ok_func();
                            }
                        } else {
                            Alert.Show(`还需要${HtmlColorTxt(this.costNum - myCost - (costType != 1 && roleVo.jin), "'#0A953E'")}${costName}才能购买${actData.name},是否前往充值?`, Alert_Type.Two, () => {
                                OpenFun.OpenFunHandler(21);
                            }, null, "确定", '取消');
                        }
                    }
                }
            },
            this,
            true
        );

        this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.ANSWER_TARGET, (...new_args) => {
            this._flag = true;
            let args = new_args;
            if (this._type_ == args[0] && this._sub_type_ == args[1]) {
                if (args[3] && args[3].reward) {
                    let reward = CustomActivityModel.GetInstance().GetActReward(args[0], args[1], args[3].form_type, args[3].reward)
                    if (reward && reward.length) {
                        let view = new CongratulationObtainView(reward, 10)
                        view.Open()
                    }
                }
                this.actData.reward_list[0] = args[3];
                this.RenderReward();
                this.RenderBar();
            }

        });
    }

    private LoadSuccess() {
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bgImg, GameResPath.GetIconOtherPath("specialPackage", "bg1"));
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bgImg1, GameResPath.GetIconOtherPath('specialPackage', 'ui_activity_27'));
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bgImg2, GameResPath.GetIconOtherPath('specialPackage', 'ui_activity_29'));
        this.SetData();
        this.RenderView();

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
        this.StopTimer();
        super.DeleteMe();
    }

    public CustomMehod(index?, args?) {
        if (this._type_ == null) {
            this._flag = true;
            this._type_ = args.base_type;
            this._sub_type_ = args.sub_type;
        }
    }

    private RenderView() {
        this.RenderReward();
        this.RenderBar();
        this.StartTimer();
        CustomActivityModel.GetInstance().CloseACTRed(this._type_, this._sub_type_);
    }


    /**
     * 渲染进度
     */
    private RenderBar() {
        let actInfo = ErlangParser.GetInstance().parse(this.actInfo.condition);
        let actData = this.actData.reward_list[0];
        let roleVipLv: number = RoleManager.GetInstance().GetMainRoleVo().vip_flag;
        let list = actInfo[1][1];
        let vips = actInfo[2][1];
        let price: number = actInfo[3][1];
        let costType: number = actInfo[3][2];
        let vipList: any[] = [];

        for (const iterator of list) {
            vipList.push({ 0: iterator[0], 1: iterator[1], 2: actData.receive_times >= iterator[0], 3: false })
        }

        let selectIndex: number = 0;
        for (let j = 0; j < vipList.length; j++) {
            const element = vipList[j];
            if (actData.receive_times >= element[0]) {
                selectIndex = j;
            }
        }
        vipList[selectIndex][3] = true;
        if (!this.loop_mgr1) {
            this.loop_mgr1 = new LoopScrowViewMgr();
            this.loop_mgr1.SetData(
                this.vipList,
                SpecialPackageItem,
                vipList,
                LoopScrCon.Horizontal
            );
        } else {
            this.loop_mgr1.replaceAll(vipList);
        }

        this.descHtml.width = 480;
        this.descHtml.style.align = "center";
        this.descHtml.style.valign = "middle";
        this.descHtml.style.fontSize = 22;
        this.descHtml.style.color = '#663915';
        SetLocalPositionX(this.descHtml, 250);

        let totalNum: number = this.specialPackageModel.GetCurLvBuyTimes(vips, roleVipLv);
        let info = this.specialPackageModel.GetCurTimesByDiscount(list, actData.receive_times);
        let vipAndTimes = this.specialPackageModel.GetNextLvBuyTimes(vips, roleVipLv);
        {
            // 判断VIP等级是否达到设定最高值
            let str: string = '';
            let str1: string = '';
            str = `当前V${HtmlColorTxt(roleVipLv, "'#0A953E'")}已购买${HtmlColorTxt(actData.receive_times, "'#0A953E'")}/${HtmlColorTxt(totalNum, "'#0A953E'")}件`
            if (roleVipLv < vips[vips.length - 1][0]) {
                SetLocalPositionX(this.descHtml, 150);
                str1 = `,升至V${HtmlColorTxt(vipAndTimes.lv, "'#0A953E'")}可多购买${HtmlColorTxt(vipAndTimes.times, "'#0A953E'")}件`;
            }
            this.descHtml.innerHTML = str + str1;
        }

        {
            // 是否用完购买次数
            this.timesLab.visible = this.disLab.visible = Boolean(info);
            if (info) {
                this.timesLab.text = info.num.toString();
                this.disLab.text = info.dis;
            }

        }

        let curDis: number = this.specialPackageModel.GetCurTimesByDiscount1(list, actData.receive_times);
        let icon = costType == 1 && "com_diamond" || "com_bind_diamond";
        ResManager.GetInstance().SetImageSpriteTrans(this, this.icon1Img, GameResPath.GetIcon('common', icon));
        ResManager.GetInstance().SetImageSpriteTrans(this, this.icon2Img, GameResPath.GetIcon('common', icon));
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bgImg3, GameResPath.GetIconOtherPath('specialPackage', info ? 'ui_activity_35' : 'ui_activity_35_1'));

        this.costNum = price * curDis / 10;
        this.num1Lab.text = `${price}`;
        this.num2Lab.text = `${this.costNum}`;
        this.lineImg.width = this.num1Lab.width;

        // 判断按钮状态
        if (actData.receive_times >= vips[vips.length - 1][1]) {
            this.state = 1; // 所有次数已用完
        } else if (actData.receive_times >= totalNum) {
            this.state = 2; // 当前vip可购买次数已用完
        }

        let strs: string[] = ['购买', '已售空'];
        this.btnTitleLab.text = this.state == 2 ? `V${vipAndTimes.lv}可买` : strs[this.state];

        // let barW: number = (actData.receive_times / vipList[vipList.length - 1][0]) * 564;
        // this.barImg.width = barW > 564 ? 564 : barW;

        // 每一段的宽度
        let w: number = 558 / (vipList.length - 1);
        // 获取当前处于第几段
        let cellIndex: number = -1;
        for (let i = 0; i < vipList.length; i++) {
            const element = vipList[i];
            if (actData.receive_times < element[0]) {
                cellIndex = i;
                break;
            }

        }

        let cellNum: number = 0;
        for (const iterator of vipList) {
            if (iterator[2]) {
                cellNum = iterator[0];
            }
        }
        let times: number = vips[vips.length - 1][1];
        for (const iterator of vipList) {
            if (!iterator[2]) {
                times = iterator[0];
                break;
            }
        }


        if (actData.receive_times >= vipList[vipList.length - 1][0]) {
            this.barImg.width = 564;
        } else {
            let barW: number = ((Math.max(cellIndex - 1, 0)) * w) + (((actData.receive_times - cellNum) / (times - cellNum)) * w);
            this.barImg.width = barW;
        }


    }



    /**
     * 渲染奖励
     */
    private RenderReward() {
        let data = this.actData.reward_list[0];
        let reward_list = data.reward;
        let rewards = ErlangParser.GetInstance().parse(reward_list);
        this.titleLab.text = data.name;
        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(
                this.rewaedList,
                SpecialPackageRewaedItem,
                rewards,
                LoopScrCon.Horizontal
            );
        } else {
            this.loop_mgr.replaceAll(rewards);
        }
    }

    private SetData() {
        this.actData = CustomActivityModel.GetInstance().GetActData(this._type_, this._sub_type_);
        this.actInfo = CustomActivityModel.GetInstance().GetActInfo(this._type_, this._sub_type_);
    }



    /**
     * 倒计时
     */
    public StartTimer() {
        let act = this.actInfo;
        if (!act) {
            return;
        }
        this.StopTimer();
        let loop_func = () => {
            let left_time = act.etime - TimeUtil.getServerTime()
            if (left_time <= 0) {
                this.StopTimer();
                this._lb_time.text = '已结束';
            } else {
                let time: string = TimeUtil.timeConvert(left_time, 'hh-mm-ss')
                this._lb_time.text = time;
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

    public DeleteMe() {
        this.LocalDeleteMe();
    }






    bgImg: Laya.Image
    bgImg1: Laya.Image
    bgImg2: Laya.Image
    bgImg3: Laya.Image
    timesLab: Laya.Label
    disLab: Laya.Label
    _Group1: Laya.HBox
    _Label1: Laya.Label
    _lb_time: Laya.Label
    titleLab: Laya.Label
    descHtml: Laya.HTMLDivElement
    rewaedList: Laya.List
    barImg: Laya.Image
    vipList: Laya.List
    num1Lab: Laya.Label
    icon1Img: Laya.Image
    num2Lab: Laya.Label
    icon2Img: Laya.Image
    buyBox: Laya.Box
    btnTitleLab: Laya.Label
    lineImg: Laya.Image
    public GetComponents() {
        [
            this.bgImg,
            this.bgImg1,
            this.bgImg2,
            this.bgImg3,
            this.timesLab,
            this.disLab,
            this._Group1,
            this._Label1,
            this._lb_time,
            this.titleLab,
            this.descHtml,
            this.rewaedList,
            this.barImg,
            this.vipList,
            this.num1Lab,
            this.icon1Img,
            this.num2Lab,
            this.icon2Img,
            this.buyBox,
            this.btnTitleLab,
            this.lineImg,
        ]
            = this.GetChildrenByNames([

                "bgImg",
                "bgImg1",
                "bgImg2",
                "bgImg3",
                "timesLab",
                "disLab",
                "_Group1",
                "_Label1",
                "_lb_time",
                "titleLab",
                "descHtml",
                "rewaedList",
                "barImg",
                "vipList",
                "num1Lab",
                "icon1Img",
                "num2Lab",
                "icon2Img",
                "buyBox",
                "btnTitleLab",
                "lineImg",
            ])
    }
}
window["SpecialPackageView"] = SpecialPackageView