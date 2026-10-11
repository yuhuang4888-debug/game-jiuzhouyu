import { TransferJobCardController } from "./TransferJobController"
import { LoopScrCon, LoopScrowViewMgr } from "./../common/LoopScrowViewMgr"
import { RoleManager } from "./../commonModel/RoleManager"
import { ResManager } from "./../common/ResManager"
import { TransferJobCardItem } from "./TransferJobCardItem"
import { Util } from "./../util/Util"
import { BaseView1 } from "./../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager";

export class TransferJobCardView extends BaseView1 {
    c: TransferJobCardController;
    loop_mgr: LoopScrowViewMgr
    public constructor() {
        super()
        this.base_file = "transferJob"
        this.layout_file = "TransferJobCardView"
        this.is_center = true
        this.layer_value = Enum_UILayer.Activity
        this.not_show_main_msg = true
		this.use_background = true
		this.click_bg_toClose = true
        this.load_callback = () => {
            this.c = TransferJobCardController.ins
            this.initView()
        }
        this.open_callback = this.initView;
    }
    private async initView() {
        await this.c.init()
        Util.AddClickEvent(this.spClose, () => {
            this.Close()
        }, this, true)
        let { careerCfg } = this.c.model
        let { career: myCareer } = RoleManager.GetInstance().GetMainRoleVo()
        let data = Object.keys(careerCfg).map(key => {
            let [career, sex] = key.split('@')
            return [Number(career), Number(sex)]
        }).filter(obj => {
            return obj[0] != myCareer
        }).sort((oa, ob) => oa[0] - ob[0])

        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr()
            this.loop_mgr.SetData(this.listTransfer, TransferJobCardItem, data, LoopScrCon.Vertical)
        } else {
            this.loop_mgr.replaceAll(data)
        }
    }

    Open() {
        super.Open()
    }

    lblTitle: Laya.Label
    lblDesc: Laya.Label
    listTransfer: Laya.List
    spClose: Laya.Box
    public GetComponents() {
        [
            this.lblTitle,
            this.lblDesc,
            this.listTransfer,
            this.spClose,
        ]
            = this.GetChildrenByNames([

                "lblTitle",
                "lblDesc",
                "listTransfer",
                "spClose",
            ])
    }
}
window["TransferJobCardView"] = TransferJobCardView