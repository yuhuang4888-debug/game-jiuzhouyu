
import { GameResPath } from "../util/GameResPath"
import { Trim } from "../util/Util"
import { BaseItem1 } from "./BaseItem1"
import { ResManager } from "./ResManager"
export class FairyWishEnterBtn extends BaseItem1 {
    img_btn: Laya.Image
    img_red: Laya.Image
    box_pop: Laya.Box
    effect_con: Laya.Box
    img_popo: Laya.Image
    htmlContent: Laya.HTMLDivElement
    SetData
    public constructor(parent) {
        super(parent)
        let data_,
            need_refresh_

        this.base_file = "common"
        this.layout_file = "FairyWishEnterBtn"
        this.load_callback = () => {
            if (need_refresh_) {
                this.SetData(data_)
            }
        }
        this.preload_client_config = {
            "ClientFairyPopoContent": false
        }
        this.SetData = (data) => {
            data_ = data
            if(!data_.icon) return
            if (this.is_loaded) {
                need_refresh_ = false
                this.img_red.visible = false
                ResManager.GetInstance().SetTexture(this, this.img_btn, GameResPath.GetIcon("pet", `${data_.icon}`), undefined, undefined, true)
            } else {
                need_refresh_ = true
            }
        }

    }

    public setRedVisible(bool?) {
        if (this.is_loaded) {
            this.img_red.visible = bool || false
        }

    }

    public updatePopoVisible(bool, fairy_id) {
        if (this.is_loaded) {
            this.box_pop.visible =this.effect_con.visible  = bool
            this.ClearUIEffect(this.effect_con)
            if (bool) {
                let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientFairyPopoContent", true)
                this.htmlContent.style.fontSize = 20
                this.htmlContent.style.color = "#763320"
                this.htmlContent.innerHTML = Trim(`${cfg[fairy_id]}` )
                this.img_popo.width = cfg[fairy_id].length * 20 + 20
                this.AddUIEffect("UI_1303c", this.effect_con, null, 7)
            }
        }
    }

    public GetComponents() {
        [
            this.img_btn,
            this.img_red,
            this.box_pop,
            this.effect_con,
            this.img_popo,
            this.htmlContent,
        ]
            = this.GetChildrenByNames([

                "img_btn",
                "img_red",
                "box_pop",
                "effect_con",
                "img_popo",
                "htmlContent",
            ])
    }
}
window["FairyWishEnterBtn"] = FairyWishEnterBtn