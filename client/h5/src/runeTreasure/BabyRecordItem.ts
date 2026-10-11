import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Util } from "../util/Util";
import { Config } from "../common/Config";
import { DressModel } from "../commonModel/DressModel";
import { ResManager } from "../common/ResManager";
import { GameResPath } from "../util/GameResPath";

export class BabyRecordItem extends BaseItemRenderer {
    private _lb_name;
    private _lb_desc;
    private _head;
    _Image1: Laya.Image

    public constructor() {
        super();
        this.base_file = "runeTreasure"
        this.layout_file = "BabyRecordItem"
        // this.skinName = "resource/game/runeTreasure/exml/BabyTreasureRecExml.exml";
    }
    public createChildren() {
        super.createChildren();
    }
    public DeleteMe() {
        super.DeleteMe();
    }
    public dataChanged() {
        if (super.dataChanged()) {

            let cDesc = GoodsModel.GetGoodsNameWithColorDark(this.data.gtyp_id)
            this._lb_name.textFlow = Util.StrToHTML(`<font color = 0xf551ff>${this.data.role_name}</font>在宝具寻宝中获得${cDesc}X${this.data.goods_num}`);
            // let _source = this.data.career ? `${this.data.career}001` : `${RoleManager.GetInstance().mainRoleInfo.career}001`;
            // if (this.data.picture && String(this.data.picture).trim() !== "") {
            //     let picture_cfg = Config.PRELOAD_SERVER_CONFIG.config_picture[this.data.picture];
            //     if (picture_cfg) {
            //         _source = picture_cfg.resource;
            //     }
            // }
            // picture_source = `resource/game/head/${_source}.png`;
            let _career = RoleManager.GetInstance().mainRoleInfo.career
            let turn: number = RoleManager.GetInstance().mainRoleInfo.turn;
			let picture_Id  = DressModel.GetInstance().getDressIdByTurn(turn);
            let headStr: string = DressModel.GetInstance().getHeadICon(picture_Id, _career)
			ResManager.GetInstance().SetImageSpriteTrans(this, this._head, GameResPath.GetIcon("head", headStr))
            // this._head.skin = picture_source
            // ResManager.GetInstance().SetTexture(this, this._head, picture_source);
        }
    }
    public GetComponents() {
        [
            this._lb_name,
            this._Image1,
            this._head,
        ]
            = this.GetChildrenByNames([

                "_lb_name",
                "_Image1",
                "_head",
            ])
    }
}

window["BabyRecordItem"] = BabyRecordItem