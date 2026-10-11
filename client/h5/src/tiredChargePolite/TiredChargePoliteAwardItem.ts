import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { BaseAwardItem } from "../common/BaseAwardItem";
import { GoodsModel } from "../commonModel/GoodsModel";
import { IS2CTiredChargePoliteTaskInfoParam, TiredChargePoliteTaskState } from "../commonModel/TiredChargePoliteModel";
import { ErlangParser } from "../util/ErlangParser";

export class TiredChargePoliteAwardItem extends BaseItemRenderer {


    WIDTH = 90;
    HEIGT = 90;

    private _item: BaseAwardItem;



    public constructor() {
        super();
        this.base_file = "tiredChargePolite";
        this.layout_file = "TiredChargePoliteAwardItem";

        this.load_callback = () => {
            this.InitEvents();
            this.LoadSuccess();
        }
        this.Load();

    }

    private InitEvents() {


    }

    private LoadSuccess() {
        if (!this._item) {
            this._item = new BaseAwardItem(this.iconBox);
            this._item.Load();
            this._item.SetItemSize(85, 85);
        }
    }

    public DeleteMe() {
        if (this._item) {
            this._item.DeleteMe();
            this._item = null;
        }
        super.DeleteMe();
    }


    public dataChanged() {
        if (super.dataChanged()) {

            let data: IS2CTiredChargePoliteTaskInfoParam = this.data;

            if (!this._item) {
                this._item.Load();
                this._item = new BaseAwardItem(this.iconBox);
            }
            let reward = data.reward;
            this._item.SetItemSize(85, 85);
            let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1]);
            let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
            if (goods_vo) {
                this._item.SetData(goods_vo.type_id, reward[2], lock);
            }

            this.titleImg.visible = data.form_type == 2; // 珍稀奖励
            this.getImg.visible = this.maskImg.visible = data.status == TiredChargePoliteTaskState.eHaveGet;

        }
    }



    iconBox: Laya.Box
    titleImg: Laya.Image
    maskImg: Laya.Image
    getImg: Laya.Image
    public GetComponents() {
        [
            this.iconBox,
            this.titleImg,
            this.maskImg,
            this.getImg,
        ]
            = this.GetChildrenByNames([

                "iconBox",
                "titleImg",
                "maskImg",
                "getImg",
            ])
    }
}
window["TiredChargePoliteAwardItem"] = TiredChargePoliteAwardItem