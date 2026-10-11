import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { OpenFun } from "../common/OpenFun";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RuneTreasureModel, RuneTreasureEvent } from "../commonModel/RuneTreasureModel";
import { PlatformManager } from "../PlatformManager";
import { Util } from "../util/Util";

export class BabyTreasureTaskItem extends BaseItemRenderer {
    private _bg;
    private _gp_reward;
    private _lb_desc;
    private _lb_num;
    private _img_get;
    private _red_dot;
    private _btn;
    private _btn_get;
    _Image11: Laya.Image
    labelDisplay1: Laya.Label

    _Image1: Laya.Image
    labelDisplay: Laya.Label
    private _item: BaseAwardItem;
    private _model = RuneTreasureModel.GetInstance();
    private _state = 0//0 未完成 1已完成未领取 2 已领取
    cfg
    public constructor() {
        super();
        this.base_file = "runeTreasure"
        this.layout_file = "BabyTreasureTaskItem"
        // this.skinName = "resource/game/runeTreasure/exml/BabyTreasureTaskItemExml.exml";
    }

    public createChildren() {
        let local_util = Util
        local_util.AddClickEvent(this._btn, () => {
            if (this.cfg) {
                OpenFun.OpenFunHandler(this.cfg.jump_id);
            }
        }, this, true);

        local_util.AddClickEvent(this._btn_get, () => {
            this._model.Fire(RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41622, "ci", RuneTreasureModel.BABY_TREASURE_TYPE, this.data.task_id);
        }, this, true);

        this._bg.skin = "resource/game/runeTreasure/texture/uizydj_004.png"
        // ResManager.GetInstance().SetTexture(ResManager.GetInstance(), this._bg, "resource/game/runeTreasure/texture/uizydj_004.png");
        super.createChildren();
    }

    public DeleteMe() {
        super.DeleteMe();
    }

    public dataChanged() {
        if (super.dataChanged()) {
            if (PlatformManager.IsEyouEnPlatform()) {
                this._lb_desc.size = 18
            }
            if (this._model.taskCfg) {
                let cfg = this._model.taskCfg[`5@${this.data.task_id}`]
                if (cfg) {
                    this.cfg = cfg
                    this._lb_desc.text = cfg.desc;
                    let reward = JSON.parse(cfg.rewards);
                    if (reward && reward[0]) {
                        if (!this._item) {
                            this._item = new BaseAwardItem(this._gp_reward);
                            this._item.Load();
                            this._item.SetScale(0.3);
                        }
                        let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0][0], reward[0][1]);
                        this._item.SetData(type_id);
                        this._lb_num.text = `X${reward[0][2]}`;
                    }
                    this._btn.visible = this.data.state == 0;
                    this._red_dot.visible = this._btn_get.visible = this.data.state == 1;
                    this._img_get.visible = this.data.state == 2;
                }
            }
        }
    }


    public GetComponents() {
        [
            this._bg,
            this._gp_reward,
            this._lb_desc,
            this._lb_num,
            this._btn,
            this._Image11,
            this.labelDisplay1,
            this._btn_get,
            this._Image1,
            this.labelDisplay,
            this._img_get,
            this._red_dot,
        ]
            = this.GetChildrenByNames([

                "_bg",
                "_gp_reward",
                "_lb_desc",
                "_lb_num",
                "_btn",
                "_Image11",
                "labelDisplay1",
                "_btn_get",
                "_Image1",
                "labelDisplay",
                "_img_get",
                "_red_dot",
            ])
    }
}

window["BabyTreasureTaskItem"] = BabyTreasureTaskItem