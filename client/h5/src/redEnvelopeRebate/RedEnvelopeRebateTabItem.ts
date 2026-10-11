import { ResManager } from '../common/ResManager';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { Util } from '../util/Util';
import { GameResPath } from '../util/GameResPath';
import { EnumRedEvnelopeRebateViewType, RedEnvelopeRebateModel, RedEnvelopeRebateModelEvent } from '../commonModel/RedEnvelopeRebateModel';

export class RedEnvelopeRebateTabItem extends BaseItemRenderer {

    WIDTH = 149;
    HEIGT = 76;


    private get RedEnvelopeRebateModel() {
        return RedEnvelopeRebateModel.GetInstance();
    }

    public constructor() {
        super();

        this.base_file = 'redEnvelopeRebate';
        this.layout_file = 'RedEnvelopeRebateTabItem';

        this.load_callback = () => {
            this.InitEvents();
        };

        this.Load();
    }



    private InitEvents() {
        // 点击页签
        let ClickTab = () => {
            if (this.data) {
                this.RedEnvelopeRebateModel.Fire(RedEnvelopeRebateModelEvent.TAB_SELECT, this.data, this.index);
            }
        }

        Util.AddClickEvent(this.btnBox, ClickTab, this);
    }


    public dataChanged() {
        if (super.dataChanged()) {
            let data: { type: number, red: boolean } = this.data;

            this.nameLab.text = data.type == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? '登录红包' : '七天返利';
            this.nameLab.color = this.selected ? '#FFFFFF' : '#4F538F';
            this.nameLab.strokeColor = this.selected ? '#AD455C' : '#C6C3F4';
            ResManager.GetInstance().SetImageSpriteTrans(
                this,
                this.bgImg,
                GameResPath.GetIcon("redEnvelopeRebate", this.selected ? "ui_fl_07" : "ui_fl_08")
            );

            this.redImg.visible = data.red;
        }
    }




    btnBox: Laya.Box
    bgImg: Laya.Image
    nameLab: Laya.Label
    redImg: Laya.Image
    compImg: Laya.Image
    public GetComponents() {
        [
            this.btnBox,
            this.bgImg,
            this.nameLab,
            this.redImg,
            this.compImg,
        ]
            = this.GetChildrenByNames([

                "btnBox",
                "bgImg",
                "nameLab",
                "redImg",
                "compImg",
            ])
    }
}
window["RedEnvelopeRebateTabItem"] = RedEnvelopeRebateTabItem