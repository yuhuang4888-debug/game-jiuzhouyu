import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"

export class MonthCardItem extends BaseItem1 {
    need_refresh_data
    data

    public constructor(parent?) {
        super(parent)
        this.need_refresh_data = false
        this.base_file = "invest"
        this.layout_file = "MonthCardItem"
        this.load_callback = () => {

            this.LoadSuccess()

        }
    }

    public LoadSuccess() {


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
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("invest", `yk_bg_${data}`))
        ResManager.GetInstance().SetImageSprite(this, this.title, "invest", `yk_title_${data}`)
    }



    public DeleteMe() {

        super.DeleteMe()
    }




    bg: Laya.Image
    title: Laya.Image
    public GetComponents() {
        [
            this.bg,
            this.title,
        ]
            = this.GetChildrenByNames([

                "bg",
                "title",
            ])
    }
}
window["MonthCardItem"] = MonthCardItem