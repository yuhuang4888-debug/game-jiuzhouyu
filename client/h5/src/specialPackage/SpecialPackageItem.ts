import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager";
import { GameResPath } from "../util/GameResPath";

export class SpecialPackageItem extends BaseItemRenderer {
    _item


    WIDTH = 100;
    HEIGT = 190;

    public constructor() {
        super();
        this._item = null;
        this.base_file = "specialPackage";
        this.layout_file = "SpecialPackageItem";

        this.load_callback = () => {

            this.LoadSuccess();
        }
        this.Load();

    }

    private LoadSuccess() {

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
            let data = this.data;
            this.timesLab.text = this.index == 0 ? `当前` : `购买${data[0]}件`;
            let str: string = 'zk0' + data[1];
            let iconName: string = data[3] ? str + '-1' : str;
            ResManager.GetInstance().SetImageSpriteTrans(this, this.disImg, GameResPath.GetIcon("specialPackage", iconName));
        }
    }




    timesLab: Laya.Label
    disImg: Laya.Image
    public GetComponents() {
        [
            this.timesLab,
            this.disImg,
        ]
            = this.GetChildrenByNames([

                "timesLab",
                "disImg",
            ])
    }
}
window["SpecialPackageItem"] = SpecialPackageItem