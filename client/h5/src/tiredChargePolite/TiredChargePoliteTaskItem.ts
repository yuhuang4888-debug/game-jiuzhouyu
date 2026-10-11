import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { HtmlColorTxt, Util } from "../util/Util";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { TiredChargePoliteAwardItem } from "./TiredChargePoliteAwardItem";
import { IS2CTiredChargePoliteParam, IS2CTiredChargePoliteTaskInfoParam, IS2CTiredChargePoliteTasksParam, TiredChargePoliteModel, TiredChargePoliteTaskState } from "../commonModel/TiredChargePoliteModel";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventName } from "../common/EventName";
import { TiredChargePoliteTips } from "./TiredChargePoliteTips";
import { ErlangParser } from "../util/ErlangParser";
import { Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { Message } from "../sysInfo/SysInfoController";

export class TiredChargePoliteTaskItem extends BaseItemRenderer {

    public WIDTH = 676;
    public HEIGT = 164;

    private loop_mgr: LoopScrowViewMgr;
    fly_list

    private _viewData: IS2CTiredChargePoliteParam;

    private get tiredChargePoliteModel() {
        return TiredChargePoliteModel.GetInstance();
    }

    public constructor() {
        super();
        this.base_file = "tiredChargePolite";
        this.layout_file = "TiredChargePoliteTaskItem";

        this.load_callback = () => {
            this.InitEvents();
            this.LoadSuccess();
        }
        this.Load();

    }

    private InitEvents() {
        // 前往充值
        let ClickGoBtn = () => {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, TiredChargePoliteTips._layout_file,);
        }
        Util.AddClickEvent(this.goBtn, ClickGoBtn, this, true);

        // 领取奖励
        let ClickGetBnt = () => {
            if (!this.data) {
                return;
            }

            CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, this._viewData.base_type, this._viewData.sub_type, this.data.grade)

            //奖励处理
            let awards: IS2CTiredChargePoliteTaskInfoParam[] = [];
            for (const reward of this.data.reward_list) {
                let rewards = ErlangParser.GetInstance().parse(reward.reward);
                for (const iterator of rewards) {
                    awards.push({ form_type: reward.form_type, status: reward.status, reward: iterator })
                }
            }
            awards.sort((a: IS2CTiredChargePoliteTaskInfoParam, b: IS2CTiredChargePoliteTaskInfoParam) => {
                return b.form_type - a.form_type;
            })

            this.fly_list = CustomActivityModel.GetInstance().GetFlyRewardList(awards,3)

        }
        Util.AddClickEvent(this.getBtn, ClickGetBnt, this, true);

        // 点击未达成
        let ClickNotBnt = () => {
            Message.show("条件未达成")
        }
        Util.AddClickEvent(this.notBtn, ClickNotBnt, this, true);


        this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.ANSWER_TARGET, (base_type?, sub_type?, result_data?) => {
			if (this.data && this.data.base_type == base_type && this.data.sub_type == sub_type && this.data.grade == result_data.grade) {
				//飘字特效
				CustomActivityModel.GetInstance().ShowActFlyReward(this.fly_list, this.getBtn)
			}
		})

    }

    private LoadSuccess() {
        this._viewData = this.tiredChargePoliteModel.GetTiredChargePoliteData();
    }

    public DeleteMe() {
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
        super.DeleteMe();
    }


    public dataChanged() {
        if (super.dataChanged()) {
            if(!this._viewData) return
            let data: IS2CTiredChargePoliteTasksParam = this.data;
            let actInfo = CustomActivityModel.GetInstance().GetActInfo(this._viewData.base_type, this._viewData.sub_type);
            if (!(actInfo && data)) {
                return;
            }
            let curRechargeNum: number = this._viewData.recharge_num;
            let limiNum: number = ErlangParser.GetInstance().parse(actInfo.condition)[0][1];
            let conditon = ErlangParser.GetInstance().parse(data.condition);
            let rechargeNum: number = conditon[0][1];
            let showForm: number = conditon[1][1];
            let state: TiredChargePoliteTaskState = this.tiredChargePoliteModel.GetGearStateByGrade(data.grade);
            let color = curRechargeNum >= rechargeNum && Enum_ColorUtil_Dark.GREEN || Enum_ColorUtil_Dark.RED;

            // 按钮状态
            this.getImg.visible = state == TiredChargePoliteTaskState.eHaveGet;
            this.getBtn.visible = state == TiredChargePoliteTaskState.eGet;
            this.redImg.visible = state == TiredChargePoliteTaskState.eGet;
            this.notBtn.visible = state == TiredChargePoliteTaskState.eNot;
            this.goBtn.visible = state == TiredChargePoliteTaskState.eJump;

            // 描述
            this.descHtml.innerHTML = showForm == 1 ?
                `${data.desc}(${HtmlColorTxt(Math.min(curRechargeNum, limiNum), color)}/${rechargeNum})人` :
                `${data.desc}≥${HtmlColorTxt(rechargeNum, color)}人`;
            this.descHtml.style.width = 300;
            let awards: IS2CTiredChargePoliteTaskInfoParam[] = [];
            for (const reward of data.reward_list) {
                let rewards = ErlangParser.GetInstance().parse(reward.reward);
                for (const iterator of rewards) {
                    awards.push({ form_type: reward.form_type, status: reward.status, reward: iterator })
                }
            }

            awards.sort((a: IS2CTiredChargePoliteTaskInfoParam, b: IS2CTiredChargePoliteTaskInfoParam) => {
                return b.form_type - a.form_type;
            })


            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr();
                this.loop_mgr.SetData(
                    this.iconList,
                    TiredChargePoliteAwardItem,
                    awards,
                    LoopScrCon.Horizontal,
                );
            } else {
                this.loop_mgr.replaceAll(awards);
            }
        }
    }

    descHtml: Laya.HTMLDivElement
    getImg: Laya.Image
    iconList: Laya.List
    goBtn: Laya.Box
    getBtn: Laya.Box
    redImg: Laya.Image
    notBtn: Laya.Box
    public GetComponents() {
        [
            this.descHtml,
            this.getImg,
            this.iconList,
            this.goBtn,
            this.getBtn,
            this.redImg,
            this.notBtn,
        ]
            = this.GetChildrenByNames([

                "descHtml",
                "getImg",
                "iconList",
                "goBtn",
                "getBtn",
                "redImg",
                "notBtn",
            ])

        this.descHtml.style.fontSize = 22;
        this.descHtml.style.color = '#663915';
        this.descHtml.style.height = 22;
        this.descHtml.style.width = 300;
    }
}
window["TiredChargePoliteTaskItem"] = TiredChargePoliteTaskItem