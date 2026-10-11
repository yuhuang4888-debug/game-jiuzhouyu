import { ResManager } from '../common/ResManager';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { Util } from '../util/Util';
import { OneDollarSpikeModel, OneDollarSpikeModelEvent } from '../commonModel/OneDollarSpikeModel';
import { GameResPath } from '../util/GameResPath';

export class OneDollarSpikeTabItem extends BaseItemRenderer {

    WIDTH = 150;
    HEIGT = 57;


    private get OneDollarSpikeModel() {
        return OneDollarSpikeModel.GetInstance();
    }

    public constructor() {
        super();

        this.base_file = 'oneDollarSpike';
        this.layout_file = 'OneDollarSpikeTabItem';

        this.load_callback = () => {
            this.InitEvents();
        };

        this.Load();
    }

    private InitEvents() {
        // 点击页签
        let ClickTab = () => {
            if (this.data) {
                this.OneDollarSpikeModel.Fire(OneDollarSpikeModelEvent.TAB_SELECT, this.data, this.index);
            }
        }
        Util.AddClickEvent(this.itemBox, ClickTab, this);
    }


    public dataChanged() {
        if (super.dataChanged()) {
            let data: { id: number, price: number, red: boolean } = this.data;

            ResManager.GetInstance().SetImageSpriteTrans(
                this,
                this.tabImg,
                GameResPath.GetIcon("oneDollarSpike", this.selected ? "ui_mrzg_01" : "ui_mrzg_02")
            );

            this.titleLab.text = `${data.price}元礼包`;
            this.titleLab.color = this.selected ? '#9D3335' : '#FFFFFF';
            this.titleLab.strokeColor = this.selected ? '#FFFFFF' : '#7D699C';

            // this.redImg.visible = data.red;
        }
    }


    tabImg: Laya.Image
    redImg: Laya.Image
    itemBox: Laya.Box
    titleLab: Laya.Label
    public GetComponents() {
        [
            this.tabImg,
            this.redImg,
            this.itemBox,
            this.titleLab,
        ]
            = this.GetChildrenByNames([

                "tabImg",
                "redImg",
                "itemBox",
                "titleLab",
            ])
    }
}
window["OneDollarSpikeTabItem"] = OneDollarSpikeTabItem