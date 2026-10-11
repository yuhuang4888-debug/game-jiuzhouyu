import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel";
import { ResManager } from "../common/ResManager";
export class KfHolyAreaRankItem extends BaseItemRenderer {
    WIDTH = 402
    HEIGT = 42
    model
    public constructor() {
        super()
        this.model = KfHolyAreaModel.GetInstance();
        this.base_file = "kfHolyArea"
        this.layout_file = "KfHolyAreaRankItem"
        this.Load()
    }

    public load_callback() {
        this.InitEvent()
    }

    public InitEvent() {

    }

    public dataChanged() {
        if (! super.dataChanged()) {
            return
        }
        let data = this.data
        if (data.rank < 4) {
            this.rank_img.visible = true
            this.rank_lb.visible = false
        } else {
            this.rank_img.visible = false
            this.rank_lb.visible = true
        }
        if(data.rank <=3 ){
            ResManager.GetInstance().SetImageSprite(this, this.rank_img, "rank_asset", "rank_icon_" + data.rank + "", true)
        }else{
            this.rank_lb.text = String(data.rank)
        }
        this.name_lb.text = data.role_name
        this.kill_cnt_lb.text = String(data.kill_num)
        this.contribution_lb.text = String(data.score)
    }
    bg_img: Laya.Image
    _Group1: Laya.Box
    rank_img: Laya.Image
    rank_lb: Laya.Label
    name_lb: Laya.Label
    kill_cnt_lb: Laya.Label
    contribution_lb: Laya.Label
    public GetComponents() {
        [
            this.bg_img,
            this._Group1,
            this.rank_img,
            this.rank_lb,
            this.name_lb,
            this.kill_cnt_lb,
            this.contribution_lb,
        ]
            = this.GetChildrenByNames([

                "bg_img",
                "_Group1",
                "rank_img",
                "rank_lb",
                "name_lb",
                "kill_cnt_lb",
                "contribution_lb",
            ])
    }
}
window["KfHolyAreaRankItem"] = KfHolyAreaRankItem