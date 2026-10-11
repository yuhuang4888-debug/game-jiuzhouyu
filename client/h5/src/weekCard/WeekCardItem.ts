import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { WordManager } from "../common/WordManager"

export class WeekCardItem extends BaseItem1 {
    need_refresh_data
    data

    public constructor(parent?) {
        super(parent)
        this.need_refresh_data = false
        this.base_file = "weekCard"
        this.layout_file = "WeekCardItem"
        this.load_callback = () => {

            this.LoadSuccess()

        }
    }

    public LoadSuccess() {


        this.InitEvent()
        if (this.need_refresh_data) {
            this.need_refresh_data = false
            this.UpdataView()
        }
    }

    public Setdata(data) {

        this.data = data
        if (this.is_loaded) {
            this.UpdataView()
        } else {
            this.need_refresh_data = true
        }
    }

    public UpdataView() {
        let data = this.data
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("weekCard", `ui_activity_${48 + Number(data)}`))
        let vip = WordManager.NumConvertStage(Number(data) + 2)
        this.vip.text = `特权${vip}`
    }

    public InitEvent() {

    }

    public DeleteMe() {

        super.DeleteMe()
    }



    bg: Laya.Image
    vip: Laya.Label
    public GetComponents() {
        [
            this.bg,
            this.vip,
        ]
            = this.GetChildrenByNames([

                "bg",
                "vip",
            ])
    }
}
window["WeekCardItem"] = WeekCardItem