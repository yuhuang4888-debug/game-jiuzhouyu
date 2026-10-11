import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { ResManager } from '../common/ResManager';
import { table } from '../common/table';
import { EnumGrowthForceViewType, GrowthForceModel, GrowthForceModelEvent } from '../commonModel/GrowthForceModel';
import { GrowthBenefitsView } from '../growthBenefits/GrowthBenefitsView';
import { GameResPath } from '../util/GameResPath';
import { Util } from '../util/Util';
import { GrowthFightWelfareView } from './GrowthFightWelfareView';
import { GrowthForceTabItem } from './GrowthForceTabItem';
import { GrowthBenefitsModel, GrowthBenefitsModelEvent } from './../commonModel/GrowthBenefitsModel';



export class GrowthForceView extends BaseView1 {

    static _layout_file: string = "GrowthForceView";
    private loop_mgr: LoopScrowViewMgr;

    // 默认界面
    private defTabIndex: EnumGrowthForceViewType = EnumGrowthForceViewType.eGrowingUp;
    private defType: EnumGrowthForceViewType = EnumGrowthForceViewType.eGrowingUp;
    private growingView: GrowthBenefitsView;
    private fightView: GrowthFightWelfareView;
    private tabs: { type: EnumGrowthForceViewType.eGrowingUp }[];
    private _model: GrowthForceModel;
    public constructor() {
        super();

        this.base_file = 'growthForce';
        this.layout_file = 'GrowthForceView';
        this.use_background = true;
        this.click_bg_toClose = true;
        this.is_center = true;
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;
        this._model = GrowthForceModel.GetInstance();
        this.tabs = []
        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
        };

        this.close_callback = () => {
            this.defTabIndex = EnumGrowthForceViewType.eGrowingUp;
            this.defType = EnumGrowthForceViewType.eGrowingUp;
        }

        this.destroy_callback = () => {
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe();
                this.loop_mgr = null;
            }

            if (this.growingView) {
                this.growingView.DeleteMe()
                this.growingView = null
            }

            if (this.fightView) {
                this.fightView.DeleteMe()
                this.fightView = null
            }

        }
    }

    public LoadSuccess() {
        this.tabs = [];
        // 如果已经全部领取就不显示该页签
        if (!GrowthBenefitsModel.GetInstance().GetTaskIsAllReceive()) {
            table.insert(this.tabs, { type: EnumGrowthForceViewType.eGrowingUp })
        }
        if (!this._model.IsFightWelfareGotAll()&&this._model.CheckFightWelfareOpen() ) {
            table.insert(this.tabs, { type: EnumGrowthForceViewType.eCombatPower })
        }

        // 居中显示
        this.tabList.x = this.tabs.length >= 2 ? 127 : 247;
        // this.tabList.scrollBar.touchScrollEnable = this.tabs.length >= 2;
        // this.tabList.scrollBar.mouseWheelEnable = this.tabs.length >= 2;

        this.SetDefIndex();
        this.RenderTabList();

    }

    public InitEvent() {

        Util.AddClickEvent(
            this.closeBox,
            () => {
                this.Close();
            },
            this,
            true
        );


        // 选择页签回调
        this.BindEvent(GrowthForceModel.GetInstance(), GrowthForceModelEvent.TAB_SELECT, (data: any, index: number) => {
            this.defTabIndex = index;
            this.loop_mgr.SetSelectIndex(this.defTabIndex);
            this.SetIcon(data.type);
            this.SetTabView(data.type)
        });

        this.BindEvent(GrowthBenefitsModel.GetInstance(), GrowthBenefitsModelEvent.UPDATE_TASK, () => {
            this.SetDefIndex();
            this.RenderTabList();
        });


    }



    private RenderTabList() {

        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(
                this.tabList,
                GrowthForceTabItem,
                this.tabs
                // LoopScrCon.Horizontal
            );
        } else {
            this.loop_mgr.replaceAll(this.tabs);
        }

        this.loop_mgr.SetSelectIndex(this.defTabIndex);

    }

    private SetTabView(index) {
        this.viewBox1.visible = index == EnumGrowthForceViewType.eGrowingUp;
        this.viewBox2.visible = index == EnumGrowthForceViewType.eCombatPower;

        if (this.viewBox1.visible && !this.growingView) {
            this.growingView = new GrowthBenefitsView(this.viewBox1)
            this.growingView.Load()
        }

        if (this.viewBox2.visible && !this.fightView) {
            this.fightView = new GrowthFightWelfareView(this.viewBox2)
            this.fightView.Load()
        }
    }

    private SetIcon(index) {
        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.bgImg,
            GameResPath.GetIconOtherPath('growthForce', index ? 'ui_fl_02' : 'ui_fl_01')
        );

        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.titleImg1,
            GameResPath.GetIconOtherPath('growthForce', index ? 'ui_fl_06' : 'ui_fl_05'),
            true
        );

        ResManager.GetInstance().SetImageSpriteTrans(
            this,
            this.nameImg,
            GameResPath.GetIcon('growthForce', index ? 'ui_fl_04' : 'ui_fl_03'),
        );
    }

    private SetDefIndex() {
        let flag: boolean = true;
        for (let i = 0; i < this.tabs.length; i++) {
            const e: { type: EnumGrowthForceViewType } = this.tabs[i];
            if (e.type ? this._model.CheckFightWelfareRed() : GrowthBenefitsModel.GetInstance().GetDayRedDotStateAll()) {
                flag = false;
                this.defType = e.type;
                this.defTabIndex = i;
                break;
            }
        }
        // 都没有红点选中默认的
        if (flag) {
            this.defType = this.tabs[0].type;
            this.defTabIndex = EnumGrowthForceViewType.eGrowingUp;
        }


        // let bool: boolean = this.defTabIndex ? this._model.CheckFightWelfareRed() : GrowthBenefitsModel.GetInstance().GetDayRedDotStateAll();
        // if (bool) {
        //     this.SetIcon(this.defTabIndex);
        //     this.SetTabView(this.defTabIndex)
        //     return;
        // }

        // if (GrowthBenefitsModel.GetInstance().GetDayRedDotStateAll()) {
        //     this.defTabIndex = EnumGrowthForceViewType.eGrowingUp;
        // } else {
        //     if (this._model.CheckFightWelfareRed()) {
        //         this.defTabIndex = EnumGrowthForceViewType.eCombatPower;
        //     }
        // }

        this.SetIcon(this.defType);
        this.SetTabView(this.defType)
    }


    public Open(...new_args) {
        this._Local_Open(new_args)
    }

    private _Local_Open(parms: any) {
        this.defTabIndex = parms[0];
        super.Open();
    }

    public DeleteMe() {
        super.DeleteMe();
    }



    bgImg: Laya.Image
    closeBox: Laya.Box
    nameImg: Laya.Image
    titleImg1: Laya.Image
    tabList: Laya.List
    viewBox1: Laya.Box
    viewBox2: Laya.Box
    public GetComponents() {
        [
            this.bgImg,
            this.closeBox,
            this.nameImg,
            this.titleImg1,
            this.tabList,
            this.viewBox1,
            this.viewBox2,
        ]
            = this.GetChildrenByNames([

                "bgImg",
                "closeBox",
                "nameImg",
                "titleImg1",
                "tabList",
                "viewBox1",
                "viewBox2",
            ])
    }
}
window["GrowthForceView"] = GrowthForceView