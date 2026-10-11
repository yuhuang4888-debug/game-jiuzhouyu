import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { BabyEvent, BabyModel } from "../commonModel/BabyModel"
import { Util } from "../util/Util"

export class BabyCulTaskItem extends BaseItemRenderer {
    public WIDTH = 334
    public HEIGT = 122

    cfg
    model: BabyModel
    public constructor() {
        super()
        this.base_file = "baby"
        this.layout_file = "BabyCulTaskItem"
        this.model = BabyModel.GetInstance()
        this.Load()
    }

    public load_callback() {
        Util.AddClickEvent(this.goBtn, () => {
            if (this.data && this.cfg) {
                OpenFun.OpenFunHandler(this.cfg.jump_id)
            }
        }, this, true)

        Util.AddClickEvent(this.getBtn, () => {
            if (this.data) {
                this.model.Fire(BabyEvent.REQUEST_PROTO, 18222, "h", this.data.task_id)
            }
        }, this, true)
    }

    public dataChanged() {
        if (super.dataChanged()) {
            let baby_raise_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_baby_raise", false)
            let cfg
            if (baby_raise_cfg) {
                cfg = baby_raise_cfg[this.data.task_id]
            }
            if (cfg) {
                this.cfg = cfg
                this.taskDes.style.fontSize = 20
                this.taskDes.style.color = "#663915"
                this.taskDes.style.wordWrap = false

                this.rewardLb.text = `${cfg.raise_exp}`
                let finish_color = this.data.finish_num >= cfg.num_con ? "#0a953e" : "#ff4f50"
                this.taskDes.innerHTML = Util.StrToHTML(`${cfg.desc}(<font color='${finish_color}'>${this.data.finish_num}</font>/${cfg.num_con})`)
                this.goBtn.visible = this.data.finish_state == 0
                this.reddot.visible = this.getBtn.visible = this.data.finish_state == 1
                this.finishImg.visible = this.data.finish_state == 2
            } else {
                this.cfg = null
            }
        }
    }
    

    _Image1: Laya.Image
    _Image2: Laya.Image
    finishImg: Laya.Image
    taskDes: Laya.HTMLDivElement
    _Label1: Laya.Label
    rewardLb: Laya.Label
    rewardImg: Laya.Image
    goBtn: Laya.Box
    _Image11: Laya.Image
    labelDisplay: Laya.Label
    getBtn: Laya.Box
    _Image111: Laya.Image
    labelDisplay1: Laya.Label
    reddot: Laya.Image
    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this.finishImg,
            this.taskDes,
            this._Label1,
            this.rewardLb,
            this.rewardImg,
            this.goBtn,
            this._Image11,
            this.labelDisplay,
            this.getBtn,
            this._Image111,
            this.labelDisplay1,
            this.reddot,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "finishImg",
                "taskDes",
                "_Label1",
                "rewardLb",
                "rewardImg",
                "goBtn",
                "_Image11",
                "labelDisplay",
                "getBtn",
                "_Image111",
                "labelDisplay1",
                "reddot",
            ])
    }
}
window["BabyCulTaskItem"] = BabyCulTaskItem