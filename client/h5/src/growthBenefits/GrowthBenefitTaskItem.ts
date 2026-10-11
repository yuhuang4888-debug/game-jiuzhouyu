import { ResManager } from '../common/ResManager';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { Util } from '../util/Util';
import { GameResPath } from '../util/GameResPath';
import { EnumGrowWelefareTaskState, GrowthBenefitsModel, GrowthBenefitsModelEvent, IConfGrowWelfareInfo, IGrowWelfareTaskParam } from '../commonModel/GrowthBenefitsModel';
import { OpenFun } from '../common/OpenFun';
import { EnumGrowthBenefitsProtocol } from '../commonController/GrowthBenefitsController';
import { ErlangParser } from '../util/ErlangParser';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { GrowthBenefitsAwardItem } from './GrowthBenefitsAwardItem';
import { GrowthForceModel, GrowthForceModelEvent } from '../commonModel/GrowthForceModel';
import { GrowthForceView } from '../growthForce/GrowthForceView';

export class GrowthBenefitTaskItem extends BaseItemRenderer {

    WIDTH = 510;
    HEIGT = 138;


    private loop_mgr1: LoopScrowViewMgr;

    private get GrowthBenefitsModel() {
        return GrowthBenefitsModel.GetInstance();
    }

    public constructor() {
        super();

        this.base_file = 'growthBenefits';
        this.layout_file = 'GrowthBenefitTaskItem';

        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvents();
        };

        this.Load();
    }
    private LoadSuccess() {
        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.bgImg,
            GameResPath.GetIcon("growthBenefits", 'ui_fl_10')
        );

        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.bgImg1,
            GameResPath.GetIcon("growthBenefits", 'uimrbj_001')
        );
    }

    private InitEvents() {
        // 点击前往
        let ClickJump = () => {
            if (this.data) {
                OpenFun.OpenFunHandler(this.data.jump_id);
                GrowthForceModel.GetInstance().Fire(GrowthForceModelEvent.CLOSE_VIEW, GrowthForceView._layout_file)
            }
        }

        // 点击领取
        let ClickGet = () => {
            if (this.data) {
                let task: IGrowWelfareTaskParam = this.GrowthBenefitsModel.GetTaskStateMap(this.data.task_id);
                if (task?.status == EnumGrowWelefareTaskState.eAvailable) {
                    this.GrowthBenefitsModel.Fire(GrowthBenefitsModelEvent.REQUEST_PROTO, EnumGrowthBenefitsProtocol.eProtocol41722, 'h', this.data.task_id)
                }
            }
        }

        Util.AddClickEvent(this.jumpBox, ClickJump, this, true);
        Util.AddClickEvent(this.getBox, ClickGet, this, true);
    }


    public dataChanged() {
        if (super.dataChanged()) {
            let conf: IConfGrowWelfareInfo = this.data;
            let task: IGrowWelfareTaskParam = this.GrowthBenefitsModel.GetTaskStateMap(conf.task_id);

            if (task) {
                // 判断显示状态
                this.getImg.visible = task.status == EnumGrowWelefareTaskState.eReceived;
                this.jumpBox.visible = task.status == EnumGrowWelefareTaskState.eNotAvailable;
                this.getBox.visible = task.status == EnumGrowWelefareTaskState.eAvailable;
                this.redImg.visible = task.status == EnumGrowWelefareTaskState.eAvailable;
            } else {
                this.jumpBox.visible = true;
                this.getImg.visible = false;
                this.getBox.visible = false;
                this.redImg.visible = false;
            }


            let curNum: number = task?.process || 0;
            let condition = ErlangParser.GetInstance().parse(conf.condition)[0]
            let targetNum: number = condition[Object.keys(condition).length - 1]


            this.nameLab.text = conf.desc;
            this.numLab.text = `(${curNum}/${targetNum})`;
            this.numLab.color = curNum >= targetNum ? '#0A953E' : '#FE1A1A';

            let awards = ErlangParser.GetInstance().parse(conf.reward);

            // 渲染奖励
            if (!this.loop_mgr1) {
                this.loop_mgr1 = new LoopScrowViewMgr();
                this.loop_mgr1.SetData(
                    this.awardList,
                    GrowthBenefitsAwardItem,
                    awards,
                    LoopScrCon.Horizontal
                );
            } else {
                this.loop_mgr1.replaceAll(awards);
            }
        }
    }

    public DeleteMe() {
        if (this.loop_mgr1) {
            this.loop_mgr1.DeleteMe();
            this.loop_mgr1 = null;
        }
        super.DeleteMe()
    }




    bgImg: Laya.Image
    bgImg1: Laya.Image
    getImg: Laya.Image
    nameLab: Laya.Label
    numLab: Laya.Label
    awardList: Laya.List
    jumpBox: Laya.Box
    getBox: Laya.Box
    redImg: Laya.Image
    public GetComponents() {
        [
            this.bgImg,
            this.bgImg1,
            this.getImg,
            this.nameLab,
            this.numLab,
            this.awardList,
            this.jumpBox,
            this.getBox,
            this.redImg,
        ]
            = this.GetChildrenByNames([

                "bgImg",
                "bgImg1",
                "getImg",
                "nameLab",
                "numLab",
                "awardList",
                "jumpBox",
                "getBox",
                "redImg",
            ])
    }
}
window["GrowthBenefitTaskItem"] = GrowthBenefitTaskItem