import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { CookieWrapper } from "../common/CookieWrapper";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { WelfareModel } from "../commonModel/WelfareModel";
import { LoginModel } from "../login/LoginModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { md5 } from "../util/md5";

export class GameNoticeListItem extends BaseItemRenderer {
    WIDTH = 200
    HEIGT = 100

    _img_select: Laya.Image
    _lab_title: Laya.Label
    _img_red: Laya.Image
    public constructor() {
        super();
        this.base_file = 'gameNotice';
        this.layout_file = 'GameNoticeListItem';
        this.Load()
    }
    public createChildren() {
        super.createChildren()
    }

    public dataChanged() {
        if (super.dataChanged()) {
            let data = this.data.content[0]
            let md5_key = md5.hex_md5(data.content).toLowerCase()
            if (this.selected) { //选中过的数据 红点清除
                CookieWrapper.GetInstance().SaveCookie(md5_key, 2)
                this._img_red.visible = false
            } else {
                let red_value = CookieWrapper.GetInstance().GetCookie(md5_key)
                this._img_red.visible = Number(red_value) == 1
            }
            let url = this.selected ? "ui_notice_1" : "ui_notice_2"
            this._lab_title.color = this.selected ? "#663915" : "#6773a5"
            this._lab_title.text = this.data.title
            ResManager.GetInstance().SetImageSprite(this, this._img_select, "gameNotice", url)
            let red = LoginModel.GetInstance().GetNoticeRed()
            GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 417)
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WelfareView", 4, red)
        }

    }

    public GetComponents() {
        [
            this._img_select,
            this._lab_title,
            this._img_red,
        ]
            = this.GetChildrenByNames([

                "_img_select",
                "_lab_title",
                "_img_red",
            ])
    }
}
window["GameNoticeListItem"] = GameNoticeListItem