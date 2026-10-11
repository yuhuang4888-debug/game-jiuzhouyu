import { ResManager } from '../common/ResManager';
import { FestivalModel, FestivalModelEvent } from '../commonModel/FestivalModel';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { Util } from '../util/Util';
import { SaiboModel } from '../commonModel/SaiboModel';
import { SaiBoModelEvent } from './../commonModel/SaiboModel';
import { CustomActivityModel } from '../commonModel/CustomActivityModel';

export class SaiboTabItem extends BaseItemRenderer {

    WIDTH = 139;
    HEIGT = 54;



    public constructor() {
        super();

        this.base_file = 'saiboTreasure';
        this.layout_file = 'SaiboTabItem';

        this.load_callback = () => {
            this.InitEvents();
        };

        this.Load();
    }

    private InitEvents() {
        // 点击页签
        let ClickTab = () => {
            if (this.data) {
                SaiboModel.GetInstance().Fire(SaiBoModelEvent.SELECT_TAB, this.data, this.index);
            }
        }
        Util.AddClickEvent(this.btn, ClickTab, this, true);
    }


    public dataChanged() {
        if (super.dataChanged()) {
            let data = this.data;

            this.numLab.text = data[1].condition.total + '~' + data[4].condition.total;

            this.checkImg.visible = this.selected;
            this.img.visible = !this.selected;
            this.redImg.visible = CustomActivityModel.GetInstance().GetGradeRed(data[1].type, data[1].subtype, data[1].stage)
        }
    }

    // public DeleteMe(): void {
    // 	super.DeleteMe();
    // }


    btn: Laya.Box
    img: Laya.Image
    checkImg: Laya.Image
    numLab: Laya.Label
    redImg: Laya.Image
    public GetComponents() {
        [
            this.btn,
            this.img,
            this.checkImg,
            this.numLab,
            this.redImg,
        ]
            = this.GetChildrenByNames([

                "btn",
                "img",
                "checkImg",
                "numLab",
                "redImg",
            ])
    }
}
window["SaiboTabItem"] = SaiboTabItem