import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { OpenFun } from "../common/OpenFun";
import { TiredChargePoliteModel } from "../commonModel/TiredChargePoliteModel";
import { Util } from "../util/Util";
import { TiredChargePoliteAwardItem } from "./TiredChargePoliteAwardItem";

export class TiredChargePoliteTips extends BaseView1 {
    static _layout_file: string = "TiredChargePoliteTips";


    private loop_mgr: LoopScrowViewMgr;

    private get tiredChargePoliteModel() {
        return TiredChargePoliteModel.GetInstance();
    }

    public constructor() {
        super();

        this.base_file = 'tiredChargePolite';
        this.layout_file = 'TiredChargePoliteTips';
        this.use_background = true;
        this.click_bg_toClose = true;
        this.is_center = true;
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;

        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
        };

        this.close_callback = () => {
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe();
                this.loop_mgr = null;
            }
        }

    }



    public InitEvent() {
        // 点击关闭
        Util.AddClickEvent(
            this.closeBtn,
            () => {
                this.Close();
            },
            this,
            true
        );
        // 点击取消
        Util.AddClickEvent(
            this.cancelBtn,
            () => {
                this.Close();
            },
            this,
            true
        );
        // 点击前往充值
        Util.AddClickEvent(
            this.goBtn,
            () => {
                OpenFun.OpenFunHandler(21);
                this.Close();
            },
            this,
            true
        );
    }


    private LoadSuccess() {
        this.RenderTask();
    }

    private RenderTask() {
        let task: any[] = this.tiredChargePoliteModel.GetRareRewards();
        let tasks: any[] = []
        for (const iterator of task) {
            tasks.push({ status: 0, form_type: 1, reward: { 0: iterator[0], 1: iterator[1], 2: iterator[2] } })
        }

        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(
                this.iconList,
                TiredChargePoliteAwardItem,
                tasks,
                LoopScrCon.Horizontal,
            );
        } else {
            this.loop_mgr.replaceAll(tasks);
        }
    }





    public Open(...new_args) {
        // [this._data, this.suitType, this.subType] = [...new_args]
        super.Open();
    }

    public DeleteMe() {
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
        super.DeleteMe();
    }

    closeBtn: Laya.Image
    cancelBtn: Laya.Box
    goBtn: Laya.Box
    iconList: Laya.List
    public GetComponents() {
        [
            this.closeBtn,
            this.cancelBtn,
            this.goBtn,
            this.iconList,
        ]
            = this.GetChildrenByNames([

                "closeBtn",
                "cancelBtn",
                "goBtn",
                "iconList",
            ])
    }
}
window["TiredChargePoliteTips"] = TiredChargePoliteTips